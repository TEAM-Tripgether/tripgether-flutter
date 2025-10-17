// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Tripgether';

  @override
  String get appDescription =>
      'Share your travel moments and discover local places';

  @override
  String get navHome => 'Home';

  @override
  String get navMap => 'Map';

  @override
  String get navSchedule => 'Schedule';

  @override
  String get navCourseMarket => 'Course Market';

  @override
  String get navMyPage => 'My Page';

  @override
  String get btnConfirm => 'Confirm';

  @override
  String get btnCancel => 'Cancel';

  @override
  String get btnSave => 'Save';

  @override
  String get btnDelete => 'Delete';

  @override
  String get btnEdit => 'Edit';

  @override
  String get btnShare => 'Share';

  @override
  String get loading => 'Loading...';

  @override
  String get loadingData => 'Loading data...';

  @override
  String get noData => 'No data available';

  @override
  String get networkError => 'Please check your network connection';

  @override
  String get retry => 'Retry';

  @override
  String get trip => 'Trip';

  @override
  String get trips => 'Trips';

  @override
  String get myTrips => 'My Trips';

  @override
  String get createTrip => 'Create Trip';

  @override
  String get tripTitle => 'Trip Title';

  @override
  String get tripDescription => 'Trip Description';

  @override
  String get startDate => 'Start Date';

  @override
  String get endDate => 'End Date';

  @override
  String get schedule => 'Schedule';

  @override
  String get schedules => 'Schedules';

  @override
  String get addSchedule => 'Add Schedule';

  @override
  String get scheduleTime => 'Time';

  @override
  String get scheduleLocation => 'Location';

  @override
  String get map => 'Map';

  @override
  String get currentLocation => 'Current Location';

  @override
  String get searchLocation => 'Search location';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get languageSelection => 'Language Selection';

  @override
  String get korean => '한국어';

  @override
  String get english => 'English';

  @override
  String get currentLanguage => 'Current Language';

  @override
  String get theme => 'Theme';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get lightMode => 'Light Mode';

  @override
  String get errorGeneral => 'An error occurred';

  @override
  String get errorInvalidInput => 'Invalid input';

  @override
  String get errorSaveData => 'Failed to save data';

  @override
  String get dateFormat => 'MMM dd, yyyy';

  @override
  String get timeFormat => 'h:mm a';

  @override
  String greeting(String userName) {
    return 'Hello, $userName!';
  }

  @override
  String get greetingSubtitle => 'Where shall we explore today?';

  @override
  String get searchHint => 'Search keywords, cities, or places';

  @override
  String get clearInput => 'Clear input';

  @override
  String get recentSnsContent => 'Recent SNS Content';

  @override
  String get recentSavedPlaces => 'Recently Saved Places';

  @override
  String get seeMore => 'See More';

  @override
  String viewCount(String count) {
    return '$count views';
  }

  @override
  String get noMoreContent => 'No more content';

  @override
  String get noSnsContentYet => 'No SNS content shared yet.';

  @override
  String get noSavedPlacesYet => 'No saved places yet.';

  @override
  String get filterAll => 'All';

  @override
  String get filterYoutube => 'YouTube';

  @override
  String get filterInstagram => 'Instagram';

  @override
  String get placeVisited => 'Visited';

  @override
  String get seeMorePlaces => 'See More Places';

  @override
  String get sharedDataReceived => 'Shared Data Received';

  @override
  String get createTripFromShared => 'Create Trip';

  @override
  String get close => 'Close';

  @override
  String textCount(int count) {
    return 'Text ($count)';
  }

  @override
  String mediaFileCount(int count) {
    return 'Media Files ($count)';
  }

  @override
  String imageCount(int count) {
    return 'Images $count';
  }

  @override
  String videoCount(int count) {
    return 'Videos $count';
  }

  @override
  String fileCount(int count) {
    return 'Files $count';
  }

  @override
  String get snsContentDetail => 'Content Detail';

  @override
  String get description => 'Description';

  @override
  String get openOriginalContent => 'View Original Content';

  @override
  String get cannotOpenLink => 'Cannot open link';

  @override
  String get linkOpenError => 'Error occurred while opening link';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String daysAgo(int days) {
    return '$days days ago';
  }

  @override
  String weeksAgo(int weeks) {
    return '$weeks weeks ago';
  }

  @override
  String monthsAgo(int months) {
    return '$months months ago';
  }

  @override
  String yearsAgo(int years) {
    return '$years years ago';
  }

  @override
  String get goToOriginalPost => 'Go to original post';

  @override
  String get aiContentSummary => 'AI Content Summary';

  @override
  String get share => 'Share';

  @override
  String get courseMarket => 'Course Market';

  @override
  String get searchCourse => 'Search Courses';

  @override
  String get searchScreen => 'Search';

  @override
  String get searchPlaceholder => 'Search keywords, cities, or places';

  @override
  String get popularCourses => 'Popular Courses >';

  @override
  String get nearbyCourses => 'Nearby';

  @override
  String nearbyCoursesWithLocation(String location) {
    return 'Nearby (Current: $location) >';
  }

  @override
  String get addPlace => 'Add Place';

  @override
  String get createCourse => 'Create Course';

  @override
  String get recentSearches => 'Recent Searches';

  @override
  String get clearAllSearches => 'Clear All';

  @override
  String get recommendedSearches => 'Recommended Searches';

  @override
  String get noSearchResults => 'No search results';

  @override
  String get tryDifferentKeyword => 'Try a different keyword';

  @override
  String searchResults(int count) {
    return 'Search Results: $count';
  }

  @override
  String placesCount(int count) {
    return '$count places';
  }

  @override
  String get places => 'places';

  @override
  String get more => 'More';

  @override
  String priceKrw(int thousands) {
    return '${thousands}K KRW';
  }

  @override
  String hoursAndMinutes(int hours, int minutes) {
    return '${hours}h ${minutes}min';
  }

  @override
  String get free => 'Free';

  @override
  String get goBack => 'Go Back';

  @override
  String get loginFailedTryAgain => 'Login failed. Please try again.';

  @override
  String get googleLoginFailed => 'Google login failed.';

  @override
  String get signupScreenPreparation => 'Sign up screen is under preparation';

  @override
  String get emailLabel => 'Email';

  @override
  String get emailHint => 'support@tripgether-official.com';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordHint => '••••••••••••';

  @override
  String get emailRequired => 'Please enter your email';

  @override
  String get emailInvalidFormat => 'Please enter a valid email format';

  @override
  String get passwordRequired => 'Please enter your password';

  @override
  String get passwordMinLength => 'Password must be at least 6 characters';

  @override
  String get autoLogin => 'Remember me';

  @override
  String get findId => 'Find ID';

  @override
  String get findPassword => 'Find Password';

  @override
  String get login => 'Login';

  @override
  String get signInWithGoogle => 'Sign in with Google';

  @override
  String get signUpWithEmail => 'Sign up with Email';

  @override
  String get logout => 'Logout';

  @override
  String get logoutConfirmTitle => 'Logout';

  @override
  String get logoutConfirmMessage => 'Are you sure you want to logout?';

  @override
  String get logoutHint => 'You will need to login again after logging out';

  @override
  String get logoutSuccess => 'Logged out successfully';

  @override
  String logoutFailed(String error) {
    return 'Logout failed: $error';
  }

  @override
  String get loginLoadingMessage => 'Logging in...';

  @override
  String get pleaseWait => 'Please wait a moment';

  @override
  String get travelTip1Title => 'Solo Travel Magic';

  @override
  String get travelTip1Description =>
      'Find local restaurants. More freedom when traveling alone!';

  @override
  String get travelTip2Title => 'Catch the Golden Hour';

  @override
  String get travelTip2Description =>
      '1 hour after sunrise, 1 hour before sunset = best photo time';

  @override
  String get travelTip3Title => 'Offline Maps Essential';

  @override
  String get travelTip3Description =>
      'Download Google Maps offline maps in advance';

  @override
  String get travelTip4Title => 'Exchange Currency Locally';

  @override
  String get travelTip4Description =>
      'City exchange offices have better rates than airports';

  @override
  String get travelTip5Title => 'Pack Light';

  @override
  String get travelTip5Description =>
      'Travel days × 0.5 = number of clothes needed';

  @override
  String get travelTip6Title => 'Install Local Transport Apps';

  @override
  String get travelTip6Description =>
      'Pre-install apps like Uber, Grab for local transportation';

  @override
  String get travelTip7Title => 'Save Emergency Contacts';

  @override
  String get travelTip7Description =>
      'Save embassy and travel insurance numbers in advance';

  @override
  String get travelTip8Title => 'Check-in Time';

  @override
  String get travelTip8Description => 'Usually 2-3 PM, check in advance';

  @override
  String get travelTip9Title => 'Try Local Food';

  @override
  String get travelTip9Description =>
      'Half of travel is food! Try unfamiliar menus';

  @override
  String get travelTip10Title => 'Pre-book Tickets';

  @override
  String get travelTip10Description =>
      'Popular attractions require long waits for on-site purchases';
}
