// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get reviewStarRequired => 'Please select a rating star.';

  @override
  String get reviewCommentRequired => 'Please enter your comment.';

  @override
  String get reviewSent => 'Your review has been sent!';

  @override
  String get placeNotFound => 'Place not found.';

  @override
  String get searchTitle => 'Search Places';

  @override
  String get searchHint => 'Please enter place name...';

  @override
  String get noPlaceFound => 'No places found.';

  @override
  String get appTitle => 'Travel App Vietnam';

  @override
  String get login => 'Login';

  @override
  String get logout => 'Logout';

  @override
  String get home => 'Home';

  @override
  String get profile => 'Profile';

  @override
  String get search => 'Search';

  @override
  String get favorite => 'Favorite';

  @override
  String get bookTour => 'Book Tour';

  @override
  String get invoice => 'Invoice';

  @override
  String get language => 'Language';

  @override
  String get vietnamese => 'Vietnamese';

  @override
  String get english => 'English';

  @override
  String get popular => 'Popular';

  @override
  String get sea => 'Sea';

  @override
  String get mountain => 'Mountain';

  @override
  String get city => 'City';

  @override
  String get forest => 'Forest';

  @override
  String get relic => 'Relic';

  @override
  String get cuisine => 'Cuisine';

  @override
  String get other => 'Other';

  @override
  String get suggestion => 'Suggestion for you';

  @override
  String get seeMore => 'See more';

  @override
  String get whereToGo => 'Where do you want to go?';

  @override
  String get searchPlace => 'Search for places';

  @override
  String get noInvoice => 'You have no invoices';

  @override
  String get needLoginToViewInvoice => 'You need to login to view invoices';

  @override
  String get profileTitle => 'Profile';

  @override
  String get updateProfileSuccess => 'Profile updated successfully!';

  @override
  String get updateProfileError => 'Error updating profile:';

  @override
  String get viewInvoice => 'View my invoice';

  @override
  String get noFavoritePlace => 'No favorite places found.';

  @override
  String get favoriteCategory => 'Favorite category';

  @override
  String get favoriteLoadError => 'Error loading favorite places:';

  @override
  String get noFavoriteFound => 'No favorite places found.';

  @override
  String get loginWithGoogle => 'Login with Google';

  @override
  String get needLoginToBookTour => 'You need to login to book a tour';

  @override
  String get bookTourSuccess => 'Booking successful! Please wait for admin confirmation.';

  @override
  String get needLoginToChatAdmin => 'You need to login to chat with admin.';

  @override
  String get noTourBooked => 'You have not booked any tours yet.';

  @override
  String get needLoginToFavorite => 'You need to login to use favorite feature.';

  @override
  String get addedToFavorite => 'Added to favorite!';

  @override
  String get removedFromFavorite => 'Removed from favorite.';

  @override
  String get personal => 'Personal';

  @override
  String get searchLocation => 'Search location';

  @override
  String get invoiceTitle => 'My Invoice';

  @override
  String loadDataError(Object error) {
    return 'Error loading data: $error';
  }

  @override
  String get noPlaceAdded => 'No places have been added yet.';

  @override
  String get loading => 'Loading...';

  @override
  String reviewCount(Object count) {
    return '($count reviews)';
  }

  @override
  String get noReview => 'No reviews yet.';

  @override
  String get guest => 'Guest';

  @override
  String hello(Object name) {
    return 'Hello, $name';
  }

  @override
  String invoiceIssueDate(Object date) {
    return 'Issue date: $date';
  }

  @override
  String get invoiceTotal => 'Total:';

  @override
  String invoiceTotalAmount(Object amount) {
    return '$amount VND';
  }

  @override
  String invoiceExported(Object date) {
    return 'Exported: $date';
  }

  @override
  String get basicInfo => 'Basic Information';

  @override
  String get displayName => 'Display Name *';

  @override
  String get phoneNumber => 'Phone Number *';

  @override
  String get phoneHint => '0901234567';

  @override
  String get address => 'Address *';

  @override
  String get addressHint => 'House number, street, district/city';

  @override
  String get birthdate => 'Birthdate';

  @override
  String get birthdateHint => 'DD/MM/YYYY';

  @override
  String get gender => 'Gender';

  @override
  String get occupation => 'Occupation';

  @override
  String get occupationHint => 'Student, Office worker, Teacher...';

  @override
  String get emergencyContact => 'Emergency Contact';

  @override
  String get emergencyContactName => 'Emergency Contact Name';

  @override
  String get emergencyContactHint => 'Relative\'s full name';

  @override
  String get emergencyPhone => 'Emergency Phone';

  @override
  String get additionalInfo => 'Additional Information';

  @override
  String get nationalId => 'National ID';

  @override
  String get nationalIdHint => '123456789012';

  @override
  String get travelPreferences => 'Travel Preferences';

  @override
  String get updateProfile => 'Update Profile';

  @override
  String get profileNote => '* Required information\nThis information will help us support you better during your trip.';

  @override
  String get chatWithAdmin => 'Chat with Admin';

  @override
  String get chatWithAdminFree => 'Chat with Admin - Free Consultation';

  @override
  String get chooseTour => 'Choose tour';

  @override
  String get noName => 'No name';

  @override
  String get noDescription => 'No description';

  @override
  String get pleaseChooseTour => 'Please choose a tour';

  @override
  String pricePerPerson(Object price) {
    return 'Price per person: $price VND';
  }

  @override
  String get itinerary => 'Itinerary:';

  @override
  String itineraryItem(Object item) {
    return '- $item';
  }

  @override
  String get numPeople => 'Number of people:';

  @override
  String get departureDate => 'Departure date';

  @override
  String get pleaseChooseDate => 'Please choose a date';

  @override
  String get bookedTours => 'Tours you have booked:';

  @override
  String departureDateLabel(Object date) {
    return 'Departure date: $date';
  }

  @override
  String numPeopleLabel(Object num) {
    return 'Number of people: $num';
  }

  @override
  String totalPriceLabel(Object price) {
    return 'Total price: $price VND';
  }

  @override
  String get chatWithAdminTour => 'Chat with admin about this tour';

  @override
  String get mapTitle => 'Travel Map';

  @override
  String get authScreenSubtitle => 'Discover and experience Vietnam travel easier than ever!';

  @override
  String get copyright2025 => '© 2025 LNMQ Travel';

  @override
  String get viewMap => 'View Map';

  @override
  String get suggestTour => 'Suggest Tour';

  @override
  String get leaveReview => 'Leave your review';

  @override
  String get reviewCommentLabel => 'Your comment';

  @override
  String get sendReview => 'Send review';

  @override
  String reviewList(Object reviewCount) {
    return 'Reviews ($reviewCount)';
  }

  @override
  String get noReviewForPlace => 'No reviews for this place yet.';

  @override
  String get noInformation => 'No information';
}
