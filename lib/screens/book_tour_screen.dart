import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:lnmq/screens/tour_chat_screen.dart';
import 'package:lnmq/services/booking_service.dart';
import 'package:lnmq/services/coupon_service.dart';
import 'package:lnmq/models/booking_model.dart';
import 'package:lnmq/models/coupon_model.dart';
import 'package:lnmq/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookTourScreen extends StatefulWidget {
  const BookTourScreen({super.key});

  @override
  State<BookTourScreen> createState() => _BookTourScreenState();
}

class _BookTourScreenState extends State<BookTourScreen> {
  final _formKey = GlobalKey<FormState>();
  final BookingService _bookingService = BookingService();
  String? _selectedTourId;
  String? _selectedTourName;
  String? _selectedTourDescription;
  int? _selectedTourPrice;
  List<dynamic>? _selectedTourItinerary;
  final TextEditingController _dateStartController = TextEditingController();
  final TextEditingController _couponController = TextEditingController();
  int _numPeople = 1;
  bool _isLoading = false;
  String? _couponError;
  int? _discountPercent;
  int? _discountedPrice;
  bool _couponApplied = false;

  @override
  void initState() {
    super.initState();
    _seedCoupons();
  }

  void _seedCoupons() async {
    final couponService = CouponService();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Xóa sạch mọi dữ liệu cũ
    final fixedExpiry = DateTime(2025, 10, 10, 23, 59, 59); // Cuối ngày 10/10/2025
    final coupons = [
      Coupon(code: 'GIAM10', discountPercent: 10, expiryDate: fixedExpiry, used: false),
      Coupon(code: 'GIAM20', discountPercent: 20, expiryDate: fixedExpiry, used: false),
      Coupon(code: 'GIAM50', discountPercent: 50, expiryDate: fixedExpiry, used: false),
    ];
    for (var c in coupons) {
      print('Seed coupon: code=${c.code}, expiryDate=${c.expiryDate}, used=${c.used}');
    }
    await couponService.saveCoupons(coupons);
  }

  Future<void> _bookTour() async {
    if (!_formKey.currentState!.validate() || _selectedTourId == null) return;
    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception(AppLocalizations.of(context)!.needLoginToBookTour);
      }

      // Kiểm tra mã giảm giá khi đặt tour
      final code = _couponController.text.trim();
      int discountPercent = 0;
      bool couponValid = true;
      if (code.isNotEmpty) {
        final couponService = CouponService();
        final coupon = await couponService.findCoupon(code);
        if (coupon == null) {
          setState(() { _couponError = 'Mã không tồn tại.'; });
          couponValid = false;
        } else if (coupon.isExpired) {
          setState(() { _couponError = 'Mã đã hết hạn.'; });
          couponValid = false;
        } else if (coupon.used) {
          setState(() { _couponError = 'Mã đã được sử dụng.'; });
          couponValid = false;
        } else {
          await couponService.applyCoupon(code);
          discountPercent = coupon.discountPercent;
          setState(() {
            _couponError = null;
            _couponApplied = true;
            _discountPercent = discountPercent;
          });
        }
      }
      if (!couponValid) {
        setState(() { _isLoading = false; });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_couponError ?? 'Mã giảm giá không hợp lệ.')),
        );
        return;
      }

      final totalPrice = (_selectedTourPrice ?? 0) * _numPeople;
      final discountedPrice = discountPercent > 0
          ? totalPrice - ((totalPrice * discountPercent) ~/ 100)
          : totalPrice;

      await _bookingService.createBooking(
        tourId: _selectedTourId!,
        tourName: _selectedTourName!,
        dateStart: _dateStartController.text.trim(),
        numPeople: _numPeople,
        totalPrice: discountedPrice,
        couponCode: code.isNotEmpty ? code : null,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.bookTourSuccess)),
        );
        setState(() {
          _selectedTourId = null;
          _selectedTourName = null;
          _selectedTourDescription = null;
          _selectedTourPrice = null;
          _selectedTourItinerary = null;
          _numPeople = 1;
          _couponApplied = false;
        });
        _dateStartController.clear();
        _couponController.clear();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // Method để chat với admin (không cần tour cụ thể)
  void _navigateToGeneralChat(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.needLoginToChatAdmin)),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TourChatScreen(
          tourId: 'general_chat', // ID đặc biệt cho chat tổng quát
          tourName: 'Tư vấn chung',
        ),
      ),
    );
  }

  @override
  void dispose() {
    _dateStartController.dispose();
    _couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.bookTour),
        actions: [
          IconButton(
            icon: const Icon(Icons.support_agent),
            tooltip: localizations.chatWithAdmin,
            onPressed: () => _navigateToGeneralChat(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 24),
                child: ElevatedButton.icon(
                  onPressed: () => _navigateToGeneralChat(context),
                  icon: const Icon(Icons.support_agent, color: Colors.white),
                  label: Text(
                    localizations.chatWithAdminFree,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                  ),
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('tours').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final tours = snapshot.data!.docs;
                  return DropdownButtonFormField<String>(
                    value: _selectedTourId,
                    decoration: InputDecoration(
                      labelText: localizations.chooseTour,
                      border: const OutlineInputBorder(),
                    ),
                    items: tours.map((doc) {
                      final name = doc['name'] ?? localizations.noName;
                      return DropdownMenuItem<String>(
                        value: doc.id,
                        child: Text(name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedTourId = value;
                        final selectedDoc = tours.firstWhere((doc) => doc.id == value);
                        _selectedTourName = selectedDoc['name'];
                        _selectedTourDescription = selectedDoc['description'] ?? localizations.noDescription;
                        _selectedTourPrice = selectedDoc['price'];
                        _selectedTourItinerary = selectedDoc['itinerary'];
                      });
                    },
                    validator: (value) => value == null ? localizations.pleaseChooseTour : null,
                  );
                },
              ),
              if (_selectedTourId != null) ...[
                if (_selectedTourDescription != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.07),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _selectedTourDescription!,
                            style: const TextStyle(fontSize: 16, color: Colors.black87),
                          ),                          if (_selectedTourPrice != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                localizations.pricePerPerson(NumberFormat('#,###', 'vi_VN').format(_selectedTourPrice!)),
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          if (_selectedTourItinerary != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    localizations.itinerary,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blueAccent),
                                  ),
                                  ..._selectedTourItinerary!.map((item) => Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Text(
                                          localizations.itineraryItem(item),
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                      )),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text(localizations.numPeople, style: const TextStyle(fontSize: 16)),
                    const SizedBox(width: 16),
                    DropdownButton<int>(
                      value: _numPeople,
                      items: List.generate(10, (i) => i + 1)
                          .map((n) => DropdownMenuItem(value: n, child: Text('$n')))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _numPeople = value ?? 1;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _dateStartController,
                  decoration: InputDecoration(
                    labelText: localizations.departureDate,
                    border: const OutlineInputBorder(),
                    suffixIcon: const Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      _dateStartController.text = "${picked.day}/${picked.month}/${picked.year}";
                    }
                  },
                  validator: (value) =>
                      value == null || value.isEmpty ? localizations.pleaseChooseDate : null,
                ),
                const SizedBox(height: 16),
                // Ô nhập mã giảm giá dưới số người đi và ngày đi
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: TextField(
                    controller: _couponController,
                    decoration: InputDecoration(
                      labelText: 'Nhập mã giảm giá',
                      border: OutlineInputBorder(),
                      errorText: _couponError,
                      suffixIcon: !_couponApplied
                          ? IconButton(
                              icon: const Icon(Icons.check),
                              onPressed: () async {
                                final code = _couponController.text.trim();
                                if (code.isEmpty) {
                                  setState(() { _couponError = 'Vui lòng nhập mã.'; });
                                  return;
                                }
                                final couponService = CouponService();
                                final coupon = await couponService.findCoupon(code);
                                if (coupon == null) {
                                  setState(() { _couponError = 'Mã không tồn tại.'; });
                                  return;
                                }
                                if (coupon.isExpired) {
                                  setState(() { _couponError = 'Mã đã hết hạn.'; });
                                  return;
                                }
                                if (coupon.used) {
                                  setState(() { _couponError = 'Bạn đã sử dụng mã này.'; });
                                  return;
                                }
                                await couponService.applyCoupon(code);
                                setState(() {
                                  _couponError = null;
                                  _couponApplied = true;
                                  _discountPercent = coupon.discountPercent;
                                  _discountedPrice = (_selectedTourPrice ?? 0) * _numPeople - (((_selectedTourPrice ?? 0) * _numPeople * coupon.discountPercent) ~/ 100);
                                });
                              },
                            )
                          : null,
                    ),
                  ),
                ),
                if (_couponApplied && _discountPercent != null && _discountedPrice != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Đã áp dụng mã giảm giá: -$_discountPercent%', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                        Text('Giá sau giảm: ${_discountedPrice}đ', style: const TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                const SizedBox(height: 24),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton.icon(
                        icon: const Icon(Icons.check_circle_outline),
                        onPressed: _bookTour,
                        label: Text(localizations.bookTour),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
              ],
              const SizedBox(height: 32),
              Text(
                localizations.bookedTours,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              StreamBuilder<List<Booking>>(
                stream: _bookingService.getUserBookings(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final bookings = snapshot.data!;
                  if (bookings.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(localizations.noTourBooked),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: bookings.length,
                    itemBuilder: (context, index) {
                      final booking = bookings[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text(booking.tourName),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(localizations.departureDateLabel(booking.dateStart)),
                              Text(localizations.numPeopleLabel(booking.numPeople)),
                              Text(localizations.totalPriceLabel(booking.formattedTotalPrice)),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Color(int.parse('0xFF${booking.statusColor.substring(1)}')),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  booking.statusName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          isThreeLine: true,
                          trailing: IconButton(
                            icon: const Icon(Icons.chat_bubble_outline, color: Colors.blueAccent),
                            tooltip: localizations.chatWithAdminTour,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TourChatScreen(
                                    tourId: booking.tourId,
                                    tourName: booking.tourName,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}