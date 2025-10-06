import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi')
  ];

  /// No description provided for @reviewStarRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select a rating star.'**
  String get reviewStarRequired;

  /// No description provided for @reviewCommentRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your comment.'**
  String get reviewCommentRequired;

  /// No description provided for @reviewSent.
  ///
  /// In en, this message translates to:
  /// **'Your review has been sent!'**
  String get reviewSent;

  /// No description provided for @placeNotFound.
  ///
  /// In en, this message translates to:
  /// **'Place not found.'**
  String get placeNotFound;

  /// No description provided for @searchTitle.
  ///
  /// In en, this message translates to:
  /// **'Search Places'**
  String get searchTitle;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Please enter place name...'**
  String get searchHint;

  /// No description provided for @noPlaceFound.
  ///
  /// In en, this message translates to:
  /// **'No places found.'**
  String get noPlaceFound;

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Travel App Vietnam'**
  String get appTitle;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @favorite.
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get favorite;

  /// No description provided for @bookTour.
  ///
  /// In en, this message translates to:
  /// **'Book Tour'**
  String get bookTour;

  /// No description provided for @invoice.
  ///
  /// In en, this message translates to:
  /// **'Invoice'**
  String get invoice;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @vietnamese.
  ///
  /// In en, this message translates to:
  /// **'Vietnamese'**
  String get vietnamese;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @popular.
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get popular;

  /// No description provided for @sea.
  ///
  /// In en, this message translates to:
  /// **'Sea'**
  String get sea;

  /// No description provided for @mountain.
  ///
  /// In en, this message translates to:
  /// **'Mountain'**
  String get mountain;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @forest.
  ///
  /// In en, this message translates to:
  /// **'Forest'**
  String get forest;

  /// No description provided for @relic.
  ///
  /// In en, this message translates to:
  /// **'Relic'**
  String get relic;

  /// No description provided for @cuisine.
  ///
  /// In en, this message translates to:
  /// **'Cuisine'**
  String get cuisine;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @suggestion.
  ///
  /// In en, this message translates to:
  /// **'Suggestion for you'**
  String get suggestion;

  /// No description provided for @seeMore.
  ///
  /// In en, this message translates to:
  /// **'See more'**
  String get seeMore;

  /// No description provided for @whereToGo.
  ///
  /// In en, this message translates to:
  /// **'Where do you want to go?'**
  String get whereToGo;

  /// No description provided for @searchPlace.
  ///
  /// In en, this message translates to:
  /// **'Search for places'**
  String get searchPlace;

  /// No description provided for @noInvoice.
  ///
  /// In en, this message translates to:
  /// **'You have no invoices'**
  String get noInvoice;

  /// No description provided for @needLoginToViewInvoice.
  ///
  /// In en, this message translates to:
  /// **'You need to login to view invoices'**
  String get needLoginToViewInvoice;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @updateProfileSuccess.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully!'**
  String get updateProfileSuccess;

  /// No description provided for @updateProfileError.
  ///
  /// In en, this message translates to:
  /// **'Error updating profile:'**
  String get updateProfileError;

  /// No description provided for @viewInvoice.
  ///
  /// In en, this message translates to:
  /// **'View my invoice'**
  String get viewInvoice;

  /// No description provided for @noFavoritePlace.
  ///
  /// In en, this message translates to:
  /// **'No favorite places found.'**
  String get noFavoritePlace;

  /// No description provided for @favoriteCategory.
  ///
  /// In en, this message translates to:
  /// **'Favorite category'**
  String get favoriteCategory;

  /// No description provided for @favoriteLoadError.
  ///
  /// In en, this message translates to:
  /// **'Error loading favorite places:'**
  String get favoriteLoadError;

  /// No description provided for @noFavoriteFound.
  ///
  /// In en, this message translates to:
  /// **'No favorite places found.'**
  String get noFavoriteFound;

  /// No description provided for @loginWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Login with Google'**
  String get loginWithGoogle;

  /// No description provided for @needLoginToBookTour.
  ///
  /// In en, this message translates to:
  /// **'You need to login to book a tour'**
  String get needLoginToBookTour;

  /// No description provided for @bookTourSuccess.
  ///
  /// In en, this message translates to:
  /// **'Booking successful! Please wait for admin confirmation.'**
  String get bookTourSuccess;

  /// No description provided for @needLoginToChatAdmin.
  ///
  /// In en, this message translates to:
  /// **'You need to login to chat with admin.'**
  String get needLoginToChatAdmin;

  /// No description provided for @noTourBooked.
  ///
  /// In en, this message translates to:
  /// **'You have not booked any tours yet.'**
  String get noTourBooked;

  /// No description provided for @needLoginToFavorite.
  ///
  /// In en, this message translates to:
  /// **'You need to login to use favorite feature.'**
  String get needLoginToFavorite;

  /// No description provided for @addedToFavorite.
  ///
  /// In en, this message translates to:
  /// **'Added to favorite!'**
  String get addedToFavorite;

  /// No description provided for @removedFromFavorite.
  ///
  /// In en, this message translates to:
  /// **'Removed from favorite.'**
  String get removedFromFavorite;

  /// No description provided for @personal.
  ///
  /// In en, this message translates to:
  /// **'Personal'**
  String get personal;

  /// No description provided for @searchLocation.
  ///
  /// In en, this message translates to:
  /// **'Search location'**
  String get searchLocation;

  /// No description provided for @invoiceTitle.
  ///
  /// In en, this message translates to:
  /// **'My Invoice'**
  String get invoiceTitle;

  /// No description provided for @loadDataError.
  ///
  /// In en, this message translates to:
  /// **'Error loading data: {error}'**
  String loadDataError(Object error);

  /// No description provided for @noPlaceAdded.
  ///
  /// In en, this message translates to:
  /// **'No places have been added yet.'**
  String get noPlaceAdded;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @reviewCount.
  ///
  /// In en, this message translates to:
  /// **'({count} reviews)'**
  String reviewCount(Object count);

  /// No description provided for @noReview.
  ///
  /// In en, this message translates to:
  /// **'No reviews yet.'**
  String get noReview;

  /// No description provided for @guest.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get guest;

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello, {name}'**
  String hello(Object name);

  /// No description provided for @invoiceIssueDate.
  ///
  /// In en, this message translates to:
  /// **'Issue date: {date}'**
  String invoiceIssueDate(Object date);

  /// No description provided for @invoiceTotal.
  ///
  /// In en, this message translates to:
  /// **'Total:'**
  String get invoiceTotal;

  /// No description provided for @invoiceTotalAmount.
  ///
  /// In en, this message translates to:
  /// **'{amount} VND'**
  String invoiceTotalAmount(Object amount);

  /// No description provided for @invoiceExported.
  ///
  /// In en, this message translates to:
  /// **'Exported: {date}'**
  String invoiceExported(Object date);

  /// No description provided for @basicInfo.
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get basicInfo;

  /// No description provided for @displayName.
  ///
  /// In en, this message translates to:
  /// **'Display Name *'**
  String get displayName;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number *'**
  String get phoneNumber;

  /// No description provided for @phoneHint.
  ///
  /// In en, this message translates to:
  /// **'0901234567'**
  String get phoneHint;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address *'**
  String get address;

  /// No description provided for @addressHint.
  ///
  /// In en, this message translates to:
  /// **'House number, street, district/city'**
  String get addressHint;

  /// No description provided for @birthdate.
  ///
  /// In en, this message translates to:
  /// **'Birthdate'**
  String get birthdate;

  /// No description provided for @birthdateHint.
  ///
  /// In en, this message translates to:
  /// **'DD/MM/YYYY'**
  String get birthdateHint;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @occupation.
  ///
  /// In en, this message translates to:
  /// **'Occupation'**
  String get occupation;

  /// No description provided for @occupationHint.
  ///
  /// In en, this message translates to:
  /// **'Student, Office worker, Teacher...'**
  String get occupationHint;

  /// No description provided for @emergencyContact.
  ///
  /// In en, this message translates to:
  /// **'Emergency Contact'**
  String get emergencyContact;

  /// No description provided for @emergencyContactName.
  ///
  /// In en, this message translates to:
  /// **'Emergency Contact Name'**
  String get emergencyContactName;

  /// No description provided for @emergencyContactHint.
  ///
  /// In en, this message translates to:
  /// **'Relative\'s full name'**
  String get emergencyContactHint;

  /// No description provided for @emergencyPhone.
  ///
  /// In en, this message translates to:
  /// **'Emergency Phone'**
  String get emergencyPhone;

  /// No description provided for @additionalInfo.
  ///
  /// In en, this message translates to:
  /// **'Additional Information'**
  String get additionalInfo;

  /// No description provided for @nationalId.
  ///
  /// In en, this message translates to:
  /// **'National ID'**
  String get nationalId;

  /// No description provided for @nationalIdHint.
  ///
  /// In en, this message translates to:
  /// **'123456789012'**
  String get nationalIdHint;

  /// No description provided for @travelPreferences.
  ///
  /// In en, this message translates to:
  /// **'Travel Preferences'**
  String get travelPreferences;

  /// No description provided for @updateProfile.
  ///
  /// In en, this message translates to:
  /// **'Update Profile'**
  String get updateProfile;

  /// No description provided for @profileNote.
  ///
  /// In en, this message translates to:
  /// **'* Required information\nThis information will help us support you better during your trip.'**
  String get profileNote;

  /// No description provided for @chatWithAdmin.
  ///
  /// In en, this message translates to:
  /// **'Chat with Admin'**
  String get chatWithAdmin;

  /// No description provided for @chatWithAdminFree.
  ///
  /// In en, this message translates to:
  /// **'Chat with Admin - Free Consultation'**
  String get chatWithAdminFree;

  /// No description provided for @chooseTour.
  ///
  /// In en, this message translates to:
  /// **'Choose tour'**
  String get chooseTour;

  /// No description provided for @noName.
  ///
  /// In en, this message translates to:
  /// **'No name'**
  String get noName;

  /// No description provided for @noDescription.
  ///
  /// In en, this message translates to:
  /// **'No description'**
  String get noDescription;

  /// No description provided for @pleaseChooseTour.
  ///
  /// In en, this message translates to:
  /// **'Please choose a tour'**
  String get pleaseChooseTour;

  /// No description provided for @pricePerPerson.
  ///
  /// In en, this message translates to:
  /// **'Price per person: {price} VND'**
  String pricePerPerson(Object price);

  /// No description provided for @itinerary.
  ///
  /// In en, this message translates to:
  /// **'Itinerary:'**
  String get itinerary;

  /// No description provided for @itineraryItem.
  ///
  /// In en, this message translates to:
  /// **'- {item}'**
  String itineraryItem(Object item);

  /// No description provided for @numPeople.
  ///
  /// In en, this message translates to:
  /// **'Number of people:'**
  String get numPeople;

  /// No description provided for @departureDate.
  ///
  /// In en, this message translates to:
  /// **'Departure date'**
  String get departureDate;

  /// No description provided for @pleaseChooseDate.
  ///
  /// In en, this message translates to:
  /// **'Please choose a date'**
  String get pleaseChooseDate;

  /// No description provided for @bookedTours.
  ///
  /// In en, this message translates to:
  /// **'Tours you have booked:'**
  String get bookedTours;

  /// No description provided for @departureDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Departure date: {date}'**
  String departureDateLabel(Object date);

  /// No description provided for @numPeopleLabel.
  ///
  /// In en, this message translates to:
  /// **'Number of people: {num}'**
  String numPeopleLabel(Object num);

  /// No description provided for @totalPriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Total price: {price} VND'**
  String totalPriceLabel(Object price);

  /// No description provided for @chatWithAdminTour.
  ///
  /// In en, this message translates to:
  /// **'Chat with admin about this tour'**
  String get chatWithAdminTour;

  /// No description provided for @mapTitle.
  ///
  /// In en, this message translates to:
  /// **'Travel Map'**
  String get mapTitle;

  /// No description provided for @authScreenSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Discover and experience Vietnam travel easier than ever!'**
  String get authScreenSubtitle;

  /// No description provided for @copyright2025.
  ///
  /// In en, this message translates to:
  /// **'© 2025 LNMQ Travel'**
  String get copyright2025;

  /// No description provided for @viewMap.
  ///
  /// In en, this message translates to:
  /// **'View Map'**
  String get viewMap;

  /// No description provided for @suggestTour.
  ///
  /// In en, this message translates to:
  /// **'Suggest Tour'**
  String get suggestTour;

  /// No description provided for @leaveReview.
  ///
  /// In en, this message translates to:
  /// **'Leave your review'**
  String get leaveReview;

  /// No description provided for @reviewCommentLabel.
  ///
  /// In en, this message translates to:
  /// **'Your comment'**
  String get reviewCommentLabel;

  /// No description provided for @sendReview.
  ///
  /// In en, this message translates to:
  /// **'Send review'**
  String get sendReview;

  /// No description provided for @reviewList.
  ///
  /// In en, this message translates to:
  /// **'Reviews ({reviewCount})'**
  String reviewList(Object reviewCount);

  /// No description provided for @noReviewForPlace.
  ///
  /// In en, this message translates to:
  /// **'No reviews for this place yet.'**
  String get noReviewForPlace;

  /// No description provided for @noInformation.
  ///
  /// In en, this message translates to:
  /// **'No information'**
  String get noInformation;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'vi': return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
