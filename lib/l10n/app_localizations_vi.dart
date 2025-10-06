// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get reviewStarRequired => 'Vui lòng chọn số sao đánh giá.';

  @override
  String get reviewCommentRequired => 'Vui lòng nhập bình luận của bạn.';

  @override
  String get reviewSent => 'Đánh giá của bạn đã được gửi!';

  @override
  String get placeNotFound => 'Không tìm thấy địa điểm.';

  @override
  String get searchTitle => 'Tìm kiếm địa điểm';

  @override
  String get searchHint => 'Vui lòng nhập tên địa điểm...';

  @override
  String get noPlaceFound => 'Không tìm thấy địa điểm nào.';

  @override
  String get appTitle => 'Ứng dụng Du lịch Việt Nam';

  @override
  String get login => 'Đăng nhập';

  @override
  String get logout => 'Đăng xuất';

  @override
  String get home => 'Trang chủ';

  @override
  String get profile => 'Hồ sơ';

  @override
  String get search => 'Tìm kiếm';

  @override
  String get favorite => 'Yêu thích';

  @override
  String get bookTour => 'Đặt tour';

  @override
  String get invoice => 'Hóa đơn';

  @override
  String get language => 'Ngôn ngữ';

  @override
  String get vietnamese => 'Tiếng Việt';

  @override
  String get english => 'Tiếng Anh';

  @override
  String get popular => 'Phổ biến';

  @override
  String get sea => 'Biển';

  @override
  String get mountain => 'Núi';

  @override
  String get city => 'Thành phố';

  @override
  String get forest => 'Rừng';

  @override
  String get relic => 'Di tích';

  @override
  String get cuisine => 'Ẩm thực';

  @override
  String get other => 'Khác';

  @override
  String get suggestion => 'Gợi ý cho bạn';

  @override
  String get seeMore => 'Xem thêm';

  @override
  String get whereToGo => 'Bạn muốn đi đâu?';

  @override
  String get searchPlace => 'Tìm kiếm địa điểm';

  @override
  String get noInvoice => 'Bạn chưa có hóa đơn nào';

  @override
  String get needLoginToViewInvoice => 'Bạn cần đăng nhập để xem hóa đơn';

  @override
  String get profileTitle => 'Hồ sơ cá nhân';

  @override
  String get updateProfileSuccess => 'Cập nhật hồ sơ thành công!';

  @override
  String get updateProfileError => 'Lỗi khi cập nhật hồ sơ:';

  @override
  String get viewInvoice => 'Xem hóa đơn của tôi';

  @override
  String get noFavoritePlace => 'Bạn chưa có địa điểm yêu thích nào.';

  @override
  String get favoriteCategory => 'Danh mục yêu thích';

  @override
  String get favoriteLoadError => 'Lỗi tải địa điểm yêu thích:';

  @override
  String get noFavoriteFound => 'Không tìm thấy địa điểm yêu thích nào.';

  @override
  String get loginWithGoogle => 'Đăng nhập với Google';

  @override
  String get needLoginToBookTour => 'Bạn cần đăng nhập để đặt tour';

  @override
  String get bookTourSuccess => 'Đặt tour thành công! Vui lòng chờ admin xác nhận.';

  @override
  String get needLoginToChatAdmin => 'Bạn cần đăng nhập để chat với admin.';

  @override
  String get noTourBooked => 'Bạn chưa đặt tour nào.';

  @override
  String get needLoginToFavorite => 'Bạn cần đăng nhập để sử dụng tính năng yêu thích.';

  @override
  String get addedToFavorite => 'Đã thêm vào danh sách yêu thích!';

  @override
  String get removedFromFavorite => 'Đã xóa khỏi danh sách yêu thích.';

  @override
  String get personal => 'Cá nhân';

  @override
  String get searchLocation => 'Tìm kiếm địa điểm';

  @override
  String get invoiceTitle => 'Hóa đơn của tôi';

  @override
  String loadDataError(Object error) {
    return 'Lỗi tải dữ liệu: $error';
  }

  @override
  String get noPlaceAdded => 'Chưa có địa điểm nào được thêm.';

  @override
  String get loading => 'Đang tải...';

  @override
  String reviewCount(Object count) {
    return '($count đánh giá)';
  }

  @override
  String get noReview => 'Chưa có đánh giá';

  @override
  String get guest => 'Khách';

  @override
  String hello(Object name) {
    return 'Chào, $name';
  }

  @override
  String invoiceIssueDate(Object date) {
    return 'Ngày xuất: $date';
  }

  @override
  String get invoiceTotal => 'Tổng tiền:';

  @override
  String invoiceTotalAmount(Object amount) {
    return '$amount VNĐ';
  }

  @override
  String invoiceExported(Object date) {
    return 'Đã xuất: $date';
  }

  @override
  String get basicInfo => 'Thông tin cơ bản';

  @override
  String get displayName => 'Tên hiển thị *';

  @override
  String get phoneNumber => 'Số điện thoại *';

  @override
  String get phoneHint => '0901234567';

  @override
  String get address => 'Địa chỉ *';

  @override
  String get addressHint => 'Số nhà, đường, quận/huyện, tỉnh/thành phố';

  @override
  String get birthdate => 'Ngày sinh';

  @override
  String get birthdateHint => 'DD/MM/YYYY';

  @override
  String get gender => 'Giới tính';

  @override
  String get occupation => 'Nghề nghiệp';

  @override
  String get occupationHint => 'Sinh viên, Nhân viên văn phòng, Giáo viên...';

  @override
  String get emergencyContact => 'Liên hệ khẩn cấp';

  @override
  String get emergencyContactName => 'Tên người liên hệ khẩn cấp';

  @override
  String get emergencyContactHint => 'Họ tên người thân';

  @override
  String get emergencyPhone => 'Số điện thoại khẩn cấp';

  @override
  String get additionalInfo => 'Thông tin bổ sung';

  @override
  String get nationalId => 'Số CCCD/CMND';

  @override
  String get nationalIdHint => '123456789012';

  @override
  String get travelPreferences => 'Sở thích du lịch';

  @override
  String get updateProfile => 'Cập nhật hồ sơ';

  @override
  String get profileNote => '* Thông tin bắt buộc\nThông tin này sẽ giúp chúng tôi hỗ trợ bạn tốt hơn trong quá trình du lịch.';

  @override
  String get chatWithAdmin => 'Chat với Admin';

  @override
  String get chatWithAdminFree => 'Chat với Admin - Tư vấn miễn phí';

  @override
  String get chooseTour => 'Chọn tour';

  @override
  String get noName => 'Không tên';

  @override
  String get noDescription => 'Không có mô tả';

  @override
  String get pleaseChooseTour => 'Hãy chọn tour';

  @override
  String pricePerPerson(Object price) {
    return 'Giá 1 người: $price VNĐ';
  }

  @override
  String get itinerary => 'Lịch trình:';

  @override
  String itineraryItem(Object item) {
    return '- $item';
  }

  @override
  String get numPeople => 'Số người:';

  @override
  String get departureDate => 'Ngày đi';

  @override
  String get pleaseChooseDate => 'Chọn ngày đi';

  @override
  String get bookedTours => 'Các tour bạn đã đặt:';

  @override
  String departureDateLabel(Object date) {
    return 'Ngày đi: $date';
  }

  @override
  String numPeopleLabel(Object num) {
    return 'Số người: $num';
  }

  @override
  String totalPriceLabel(Object price) {
    return 'Tổng tiền: $price VNĐ';
  }

  @override
  String get chatWithAdminTour => 'Chat với admin về tour này';

  @override
  String get mapTitle => 'Bản đồ du lịch';

  @override
  String get authScreenSubtitle => 'Khám phá và trải nghiệm du lịch Việt Nam dễ dàng hơn bao giờ hết!';

  @override
  String get copyright2025 => '© 2025 LNMQ Travel';

  @override
  String get viewMap => 'Xem bản đồ';

  @override
  String get suggestTour => 'Gợi ý Tour';

  @override
  String get leaveReview => 'Để lại đánh giá của bạn';

  @override
  String get reviewCommentLabel => 'Bình luận của bạn';

  @override
  String get sendReview => 'Gửi đánh giá';

  @override
  String reviewList(Object reviewCount) {
    return 'Các đánh giá ($reviewCount)';
  }

  @override
  String get noReviewForPlace => 'Chưa có đánh giá nào cho địa điểm này.';

  @override
  String get noInformation => 'Chưa có thông tin';
}
