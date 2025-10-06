import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:lnmq/models/place_model.dart';
import 'package:lnmq/models/review_model.dart';
import 'package:lnmq/models/user_model.dart';
import 'package:lnmq/services/place_service.dart';
import 'package:lnmq/services/review_service.dart';
import 'package:lnmq/services/auth_service.dart';
import 'package:lnmq/services/user_service.dart';
import 'package:lnmq/screens/book_tour_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:lnmq/l10n/app_localizations.dart';
import 'package:lnmq/services/coupon_service.dart';
import 'package:lnmq/services/get_used_coupons.dart'; // Import getUsedCoupons helper
// import 'package:lnmq/models/coupon_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';


class PlaceDetailScreen extends StatefulWidget {
  final String placeId;

  const PlaceDetailScreen({super.key, required this.placeId});

  @override
  State<PlaceDetailScreen> createState() => _PlaceDetailScreenState();
}

class _PlaceDetailScreenState extends State<PlaceDetailScreen> {

  final PlaceService _placeService = PlaceService();
  final ReviewService _reviewService = ReviewService();
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();
  late Stream<AppUser?> _currentUserStream;
  final TextEditingController _reviewCommentController = TextEditingController();
  double _currentRating = 0.0;

  // Coupon logic
  final TextEditingController _couponController = TextEditingController();
  String? _couponError;
  int? _discountPercent;
  int? _discountedPrice;
  bool _couponApplied = false;
  CouponService couponService = CouponService();

  @override
  void initState() {
    super.initState();
    _currentUserStream = _userService.getCurrentUserStream();
  }

  @override
  void dispose() {
    _reviewCommentController.dispose();
    super.dispose();
  }

  // Hàm toggle yêu thích
  Future<void> _toggleFavorite(String placeId, bool shouldAdd) async {
    User? currentUser = _authService.getCurrentUser();
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.needLoginToFavorite)),
      );
      return;
    }

    try {
      if (shouldAdd) {
        await _userService.addFavoritePlace(placeId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.addedToFavorite)),
        );
      } else {
        await _userService.removeFavoritePlace(placeId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.removedFromFavorite)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: ${e.toString()}')),
      );
    }
  }


  // Hàm gửi đánh giá
  Future<void> _submitReview(String placeId, String userId, String userName) async {
    final localizations = AppLocalizations.of(context)!;
    if (_currentRating == 0.0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localizations.reviewStarRequired)),
      );
      return;
    }
    if (_reviewCommentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localizations.reviewCommentRequired)),
      );
      return;
    }

    try {
      await _reviewService.addReview(
        placeId,
        _currentRating,
        _reviewCommentController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localizations.reviewSent)),
      );

      // Xóa nội dung form sau khi gửi thành công
      _reviewCommentController.clear();
      setState(() {
        _currentRating = 0.0;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi gửi đánh giá: $e')),
      );
    }
  }

  Future<void> showUsedCoupons(BuildContext context) async {
  final usedCoupons = await getUsedCoupons();
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Các mã đã sử dụng'),
      content: usedCoupons.isEmpty
          ? Text('Bạn chưa sử dụng mã nào.')
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: usedCoupons.map((c) => Text('${c.code} - ${c.discountPercent}%')).toList(),
            ),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('Đóng'))],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return FutureBuilder<Place?>(
      future: _placeService.getPlaceById(widget.placeId),
      builder: (context, placeSnapshot) {
        if (placeSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (placeSnapshot.hasError) {
          return Scaffold(body: Center(child: Text(AppLocalizations.of(context)!.loadDataError(placeSnapshot.error.toString()))));
        }
        if (!placeSnapshot.hasData || placeSnapshot.data == null) {
          return Scaffold(body: Center(child: Text(AppLocalizations.of(context)!.placeNotFound)));
        }

        final place = placeSnapshot.data!;
        final int price = place.minPrice ?? place.maxPrice ?? 0;
        // Map địa điểm sang link review uy tín (ưu tiên Wikipedia)
        String getReviewLink(String placeName) {
          switch (placeName) {
            case 'Vịnh Hạ Long':
              return 'https://vi.wikipedia.org/wiki/Vịnh_Hạ_Long';
            case 'Sầm Sơn':
              return 'https://vi.wikipedia.org/wiki/Sầm_Sơn';
            case 'Mộc Châu':
              return 'https://vi.wikipedia.org/wiki/Mộc_Châu';
            case 'Ninh Bình':
              return 'https://vi.wikipedia.org/wiki/Ninh_Bình';
            case 'Hồ Gươm Tháp Rùa':
            case 'Tháp Rùa':
              return 'https://vi.wikipedia.org/wiki/Tháp_Rùa';
            case 'Tà Xùa':
              return 'https://vi.wikipedia.org/wiki/Tà_Xùa';
            case 'Huế':
              return 'https://vi.wikipedia.org/wiki/Huế';
            case 'Đà Lạt':
              return 'https://vi.wikipedia.org/wiki/Đà_Lạt';
            case 'Sapa':
            case 'Sa Pa':
              return 'https://vi.wikipedia.org/wiki/Sa_Pa';
            case 'Phú Quốc':
              return 'https://vi.wikipedia.org/wiki/Phú_Quốc';
            case 'Thác Bản Giốc':
              return 'https://vi.wikipedia.org/wiki/Thác_Bản_Giốc';
            case 'Đà Nẵng':
              return 'https://vi.wikipedia.org/wiki/Đà_Nẵng';
            case 'Văn Miếu (Hà Nội)':
            case 'Văn Miếu':
              return 'https://vi.wikipedia.org/wiki/Văn_Miếu';
            default:
              return 'https://vntrip.vn/cam-nang';
          }
        }
        void _sharePlace() {
          final reviewLink = getReviewLink(place.name);
          final text = '${place.name}\n${place.description}\n${place.location}\nReview: $reviewLink';
          Share.share(text);
        }
        // LẤY THÔNG TIN USER Ở ĐÂY, VÌ ĐÃ ĐĂNG NHẬP MỚI VÀO ĐƯỢC MÀN HÌNH NÀY
        final User? firebaseCurrentUser = _authService.getCurrentUser();
        // Đảm bảo có giá trị userId và userName để truyền cho _submitReview
        final String currentUserId = firebaseCurrentUser?.uid ?? 'anonymous'; 
        final String currentUserName = firebaseCurrentUser?.displayName ?? firebaseCurrentUser?.email?.split('@')[0] ?? 'Người dùng';
        
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
  expandedHeight: 250.0,
  floating: false,
  pinned: true,
  automaticallyImplyLeading: false, 
  actions: [
    // Nút chia sẻ
    IconButton(
      icon: const Icon(Icons.share, color: Colors.white),
      onPressed: _sharePlace,
    ),
    // Nút yêu thích
    StreamBuilder<AppUser?>(
      stream: _currentUserStream,
      builder: (context, userSnapshot) {
        final AppUser? currentUser = userSnapshot.data;
        final bool isFavorite = currentUser?.favoritePlaceIds.contains(place.id) ?? false;

        return IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : Colors.white,
          ),
          onPressed: () => _toggleFavorite(place.id, !isFavorite),
        );
      },
    ),
  ],
  flexibleSpace: FlexibleSpaceBar(
    titlePadding: const EdgeInsets.only(left: 16, bottom: 16, right: 16),
    title: Text(
      place.name,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
        shadows: [
          Shadow(
            blurRadius: 4.0,
            color: Colors.black54,
            offset: Offset(2.0, 2.0),
          ),
        ],
      ),
      overflow: TextOverflow.ellipsis,
    ),
    background: Stack(
      children: [
        // Carousel ảnh
        PageView.builder(
          itemCount: place.imageUrls.isNotEmpty ? place.imageUrls.length : 1,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                // Mở gallery fullscreen khi nhấn vào ảnh
                _showImageGallery(context, place.imageUrls, index);
              },
              child: place.imageUrls.isNotEmpty
                  ? Image.network(
                      place.imageUrls[index],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: Colors.grey[300],
                          child: Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.broken_image, size: 80, color: Colors.grey),
                        );
                      },
                    )
                  : Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.image, size: 80, color: Colors.grey),
                    ),
            );
          },
        ),
        
        // Gradient overlay cho title
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
          ),
        ),
 
      ],
    ),
  ),
),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.location_on, size: 20, color: Colors.grey[600]),
                              const SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  place.location,
                                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const Spacer(),
                              Icon(Icons.star, size: 20, color: Colors.amber),
                              Text(
                                '${place.rating.toStringAsFixed(1)} (${place.reviewCount} đánh giá)',
                                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Text(
                            place.description,
                            style: TextStyle(fontSize: 16, height: 1.5, color: Colors.grey[800]),
                          ),
                          const SizedBox(height: 20),
                          
                          // Phần thông tin dạng card ngang
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                // Card Duration (Thời điểm lý tưởng)
                                _buildInfoCard(
                                  icon: Icons.access_time,
                                  iconColor: Colors.orange,
                                  backgroundColor: Colors.orange.withOpacity(0.1),
                                  title: 'Thời điểm',
                                  subtitle: place.bestTimeToVisit,
                                ),
                                
                                const SizedBox(width: 12),
                                
                                // Card Price (Mức giá)
                                _buildInfoCard(
                                  icon: Icons.attach_money,
                                  iconColor: Colors.red,
                                  backgroundColor: Colors.red.withOpacity(0.1),
                                  title: 'Giá',
                                  subtitle: place.formattedPriceRange,
                                ),
                                
                                const SizedBox(width: 12),
                                
                                // Card Weather (Danh mục)
                                _buildInfoCard(
                                  icon: Icons.wb_sunny,
                                  iconColor: Colors.blue,
                                  backgroundColor: Colors.blue.withOpacity(0.1),
                                  title: 'Danh mục',
                                  subtitle: (place.categories.isNotEmpty)
                                      ? place.categories.join(', ')
                                      : 'Không rõ',
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 20),
                          const Divider(),
                          const SizedBox(height: 10),
                          

                          ElevatedButton.icon(
                            onPressed: () async {
                              final query = Uri.encodeComponent(place.name);
                              final url = 'https://www.google.com/maps/search/?api=1&query=$query';
                              if (await canLaunchUrl(Uri.parse(url))) {
                                await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Không mở được Google Maps.')),
                                );
                              }
                            },
                            icon: const Icon(Icons.map, color: Colors.white),
                            label: Text(localizations.viewMap, style: const TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const BookTourScreen()),
                                );
                              },
                              icon: const Icon(Icons.route, color: Colors.white),
                              label: Text(localizations.suggestTour, style: const TextStyle(color: Colors.white)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                          // ĐÃ XÓA Ô NHẬP MÃ GIẢM GIÁ KHỎI MÀN HÌNH ĐỊA ĐIỂM
                          // Ô nhập mã giảm giá xuất hiện ngay trước nút đặt tour
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
                                            _discountedPrice = price - (price * coupon.discountPercent ~/ 100);
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

                          // Phần Thêm Đánh giá
                          Text(
                            localizations.leaveReview,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 10),
                          RatingBar.builder(
                            initialRating: _currentRating,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 30.0,
                            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              setState(() {
                                _currentRating = rating;
                              });
                            },
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _reviewCommentController,
                            decoration: InputDecoration(
                              labelText: localizations.reviewCommentLabel,
                              border: const OutlineInputBorder(),
                              alignLabelWithHint: true,
                            ),
                            maxLines: 3,
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              onPressed: () => _submitReview(place.id, currentUserId, currentUserName),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(localizations.sendReview),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Divider(),
                          const SizedBox(height: 10),

                          // Phần Danh sách Đánh giá
                          Text(
                            localizations.reviewCount(place.reviewCount),
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 10),
                          StreamBuilder<List<Review>>(
                            stream: _reviewService.getReviewsForPlace(widget.placeId),
                            builder: (context, reviewSnapshot) {
                              if (reviewSnapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator());
                              }
                              if (reviewSnapshot.hasError) {
                                return Center(child: Text('Lỗi tải đánh giá: ${reviewSnapshot.error}'));
                              }
                              if (!reviewSnapshot.hasData || reviewSnapshot.data!.isEmpty) {
                                return Center(child: Text(localizations.noReviewForPlace));
                              }

                              final reviews = reviewSnapshot.data!;

                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: reviews.length,
                                itemBuilder: (context, index) {
                                  final review = reviews[index];
                                  return Card(
                                    margin: const EdgeInsets.symmetric(vertical: 5),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  review.userName,
                                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                              Text(
                                                '${review.timestamp.day}/${review.timestamp.month}/${review.timestamp.year}',
                                                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 5),
                                          RatingBarIndicator(
                                            rating: review.rating,
                                            itemBuilder: (context, index) => const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            itemCount: 5,
                                            itemSize: 20.0,
                                            direction: Axis.horizontal,
                                          ),
                                          const SizedBox(height: 5),
                                          Text(review.comment),
                                        ],
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
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Hàm helper để xây dựng card thông tin
  Widget _buildInfoCard({
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Hàm helper để xây dựng các phần thông tin
  void _showImageGallery(BuildContext context, List<String> imageUrls, int initialIndex) {
  showDialog(
    context: context,
    barrierColor: Colors.black,
    builder: (context) => ImageGalleryDialog(
      imageUrls: imageUrls,
      initialIndex: initialIndex,
    ),
  );
}
}

class ImageGalleryDialog extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const ImageGalleryDialog({
    super.key,
    required this.imageUrls,
    required this.initialIndex,
  });

  @override
  State<ImageGalleryDialog> createState() => _ImageGalleryDialogState();
}

class _ImageGalleryDialogState extends State<ImageGalleryDialog> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '${_currentIndex + 1} / ${widget.imageUrls.length}',
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.imageUrls.length,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          return InteractiveViewer(
            child: Center(
              child: Image.network(
                widget.imageUrls[index],
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.broken_image, size: 80, color: Colors.white54),
                        SizedBox(height: 16),
                        Text(
                          'Không thể tải ảnh',
                          style: TextStyle(color: Colors.white54),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: widget.imageUrls.length > 1
          ? Container(
              height: 80,
              color: Colors.black.withOpacity(0.8),
              child: Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      widget.imageUrls.length,
                      (index) => GestureDetector(
                        onTap: () {
                          _pageController.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: _currentIndex == index ? Colors.white : Colors.transparent,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.network(
                              widget.imageUrls[index],
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[800],
                                  child: const Icon(Icons.broken_image, color: Colors.white54),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          : null,
    );
  }
}