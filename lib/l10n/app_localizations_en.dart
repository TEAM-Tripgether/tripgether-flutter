// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'TripTogether';

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
}
