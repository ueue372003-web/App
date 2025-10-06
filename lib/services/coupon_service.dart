import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/coupon_model.dart';

class CouponService {
  static const String _key = 'coupons';

  Future<List<Coupon>> getCoupons() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];
    return list.map((e) => Coupon.fromMap(Map<String, dynamic>.from(_decode(e)))).toList();
  }

  Future<void> saveCoupons(List<Coupon> coupons) async {
    final prefs = await SharedPreferences.getInstance();
    final list = coupons.map((c) => _encode(c.toMap())).toList();
    await prefs.setStringList(_key, list);
  }

  Future<Coupon?> findCoupon(String code) async {
    final coupons = await getCoupons();
    for (final c in coupons) {
      if (c.code == code) {
        print('[DEBUG] Kiểm tra mã: code=${c.code}, expiryDate=${c.expiryDate}, used=${c.used}, now=${DateTime.now()}');
        return c;
      }
    }
    return null;
  }

  Future<bool> applyCoupon(String code) async {
    final coupons = await getCoupons();
    final idx = coupons.indexWhere((c) => c.code == code);
    if (idx == -1) return false;
    if (coupons[idx].used || coupons[idx].isExpired) return false;
    coupons[idx] = coupons[idx].copyWith(used: true);
    await saveCoupons(coupons);
    return true;
  }

  // Helper encode/decode Map<String, dynamic> to String
  String _encode(Map<String, dynamic> map) => jsonEncode(map);
  Map<String, dynamic> _decode(String str) {
    final map = jsonDecode(str);
    // expiryDate cần parse lại
    if (map.containsKey('expiryDate')) {
      map['expiryDate'] = DateTime.tryParse(map['expiryDate'].toString()) ?? DateTime.now();
    }
    if (map.containsKey('discountPercent')) {
      map['discountPercent'] = int.tryParse(map['discountPercent'].toString()) ?? 0;
    }
    if (map.containsKey('used')) {
      map['used'] = map['used'] == true || map['used'] == 'true';
    }
    return map;
  }
}
