class Coupon {
  final String code;
  final int discountPercent;
  final DateTime expiryDate;
  final bool used;

  Coupon({
    required this.code,
    required this.discountPercent,
    required this.expiryDate,
    this.used = false,
  });

  bool get isExpired {
    print('[DEBUG] So sánh ngày hết hạn: now=${DateTime.now()}, expiryDate=$expiryDate, isExpired=${DateTime.now().isAfter(expiryDate)}');
    return DateTime.now().isAfter(expiryDate);
  }

  Coupon copyWith({bool? used}) {
    return Coupon(
      code: code,
      discountPercent: discountPercent,
      expiryDate: expiryDate,
      used: used ?? this.used,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'discountPercent': discountPercent,
      'expiryDate': expiryDate.toIso8601String(),
      'used': used,
    };
  }

  factory Coupon.fromMap(Map<String, dynamic> map) {
    var expiryRaw = map['expiryDate'];
    DateTime expiryDate;
    if (expiryRaw is DateTime) {
      expiryDate = expiryRaw;
    } else if (expiryRaw is String) {
      expiryDate = DateTime.tryParse(expiryRaw) ?? DateTime.now();
    } else {
      expiryDate = DateTime.now();
    }
    return Coupon(
      code: map['code']?.toString() ?? '',
      discountPercent: int.tryParse(map['discountPercent']?.toString() ?? '0') ?? 0,
      expiryDate: expiryDate,
      used: map['used'] == true || map['used'] == 'true',
    );
  }
}
