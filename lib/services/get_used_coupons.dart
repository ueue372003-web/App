import 'package:shared_preferences/shared_preferences.dart';
import '../models/coupon_model.dart';

Future<List<Coupon>> getUsedCoupons() async {
  final prefs = await SharedPreferences.getInstance();
  final list = prefs.getStringList('coupons') ?? [];
  final coupons = list.map((e) => Coupon.fromMap(Map<String, dynamic>.from(_decode(e)))).toList();
  return coupons.where((c) => c.used).toList();
}

Map<String, dynamic> _decode(String str) {
  str = str.replaceAll(RegExp(r'[{}]'), '');
  final pairs = str.split(',');
  final map = <String, dynamic>{};
  for (var p in pairs) {
    final kv = p.split(':');
    if (kv.length == 2) {
      map[kv[0].trim()] = kv[1].trim();
    }
  }
  if (map.containsKey('expiryDate')) {
    map['expiryDate'] = map['expiryDate'];
  }
  if (map.containsKey('discountPercent')) {
    map['discountPercent'] = int.tryParse(map['discountPercent'].toString()) ?? 0;
  }
  if (map.containsKey('used')) {
    map['used'] = map['used'] == 'true';
  }
  return map;
}
