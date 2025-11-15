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
  String get signInWithKakao => 'Sign in with Kakao';

  @override
  String get signInWithNaver => 'Sign in with Naver';

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
  String get profileLoginRequired => 'Login required';

  @override
  String get profileLoginPrompt => 'Login to access more features';

  @override
  String get profileLoginButton => 'Go to Login';

  @override
  String get profileLoadError => 'Failed to load profile information';

  @override
  String accountSuffix(String platform) {
    return '$platform account';
  }

  @override
  String get permissionCreateScheduleRequired =>
      'You need to sign in to create a schedule.';

  @override
  String get permissionPurchaseCourseRequired =>
      'You need to sign in to purchase a course.';

  @override
  String get permissionEditProfileRequired =>
      'You need to sign in to edit your profile.';

  @override
  String get permissionAccessMapRequired =>
      'Location permission is required to use the map.';

  @override
  String get permissionGeneralRequired =>
      'Appropriate permission is required to use this feature.';

  @override
  String get onboardingWelcomeMessage =>
      'Start planning your special trip\nwith Tripgether ✈️';

  @override
  String get startTripgether => 'Start Tripgether';

  @override
  String get onboardingBirthdatePrompt => 'Please enter your birthdate';

  @override
  String get onboardingBirthdateDescription =>
      'It won\'t be visible to other users.\nIt\'s only used for age-appropriate content settings and recommendations.';

  @override
  String get onboardingBirthdateAgeLimit => '※ Only for ages 14 and above';

  @override
  String get onboardingInterestsPrompt => 'Please select your interests';

  @override
  String get onboardingInterestsChangeHint =>
      'You can change your interests anytime in settings.';

  @override
  String reviewCount(int count) {
    return '$count reviews';
  }

  @override
  String get mapMyLocationTooltip => 'Go to my location';

  @override
  String get mapPlaceholder => 'Map feature coming soon';

  @override
  String get placeInfo => 'Place Info';

  @override
  String get businessInfo => 'Business Info';

  @override
  String get location => 'Location';

  @override
  String get viewOnMap => 'View on Map';

  @override
  String get getDirections => 'Get Directions';

  @override
  String get comingSoon => 'Coming Soon';

  @override
  String get noPopularCoursesYet => 'No popular courses yet';

  @override
  String get onboardingNicknamePrompt => 'Please set your name';

  @override
  String get onboardingGenderPrompt => 'Select your gender';

  @override
  String get genderMale => 'Male';

  @override
  String get genderFemale => 'Female';

  @override
  String get genderOther => 'Other';

  @override
  String get genderSkip => 'Skip';

  @override
  String onboardingWelcomeDescription(String userName) {
    return 'All set! 🎉\nLet\'s start your local journey, $userName';
  }

  @override
  String get snsPlaceExtractionTutorial => 'SNS Place Extraction Tutorial';

  @override
  String get btnContinue => 'Continue';

  @override
  String get btnComplete => 'Complete';

  @override
  String get onboardingGenderDescription =>
      'Used for personalized recommendations\nYou can skip if you want';

  @override
  String get onboardingInterestsDescription =>
      'Select 3-10 interests for better recommendations';

  @override
  String get onboardingInterestsChangeInfo =>
      'You can change your interests anytime in settings';

  @override
  String onboardingWelcomeTitle(String nickname) {
    return 'Welcome,\n$nickname!';
  }

  @override
  String get onboardingWelcomeTitleFallback => 'Welcome!';

  @override
  String get defaultNickname => 'Traveler';

  @override
  String get cannotLoadContent => 'Cannot load content';

  @override
  String get noSnsContentMessage =>
      'When you share content from SNS,\nyou can check it here';

  @override
  String get noTitle => 'No title';

  @override
  String get backButtonLabel => 'Back button';

  @override
  String get backButtonTooltip => 'Back';

  @override
  String get menuButtonLabel => 'Menu button';

  @override
  String get menuButtonTooltip => 'Menu';

  @override
  String get notificationButtonLabel => 'Notification button';

  @override
  String get notificationTitle => 'Notifications';

  @override
  String get noNewNotifications => 'No new notifications.';

  @override
  String get settingsButtonLabel => 'Settings button';

  @override
  String get searchButtonLabel => 'Search button';

  @override
  String get onboardingTermsPrompt => 'Please agree to the terms';

  @override
  String get onboardingTermsDescription =>
      'You need to agree to the terms to use the service';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get ageConfirmation => 'I am 14 years or older';

  @override
  String get marketingConsent => 'Marketing consent (optional)';

  @override
  String get agreeToAll => 'Agree to all';

  @override
  String get viewDetails => 'View details';

  @override
  String get onboardingNicknameDescription =>
      'This is the name other users will see\nProfanity and advertising are restricted';

  @override
  String get onboardingNicknameHint => 'Enter your nickname';

  @override
  String onboardingInterestsSelectedCount(int count) {
    return '$count selected';
  }

  @override
  String get startNow => 'Get Started';

  @override
  String onboardingWelcomeUnified(String nickname) {
    return 'All set! 🎉\nLet\'s dive into the local day, $nickname!';
  }

  @override
  String get notifications => 'Notifications';

  @override
  String get notificationSectionToday => 'Today';

  @override
  String get noNotifications => 'No new notifications';

  @override
  String get sharedContentMessage =>
      'Shared links from external apps will appear here';

  @override
  String get aiAnalyzingLocation => 'AI is analyzing location information';

  @override
  String aiAnalyzedLocations(String count) {
    return 'AI analyzed $count location(s)';
  }

  @override
  String authorPost(String author) {
    return '$author\'s post';
  }

  @override
  String get notificationStatusProcessing => 'Processing';

  @override
  String get notificationStatusCheckButton => 'View';

  @override
  String get timestampJustNow => 'Just now';

  @override
  String timestampMinutesAgo(int minutes) {
    return '${minutes}m ago';
  }

  @override
  String timestampHoursAgo(int hours) {
    return '${hours}h ago';
  }

  @override
  String timestampDaysAgo(int days) {
    return '${days}d ago';
  }

  @override
  String get defaultAuthor => 'User';
}
