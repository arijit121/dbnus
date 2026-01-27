// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get hello_world => 'Hello World!';

  @override
  String get profile => 'Profile';

  @override
  String get edit_profile => 'Edit Profile';

  @override
  String get completed_topics => 'Completed Topics';

  @override
  String get completed_lessons => 'Completed Lessons';

  @override
  String get completed_quiz => 'Completed Quiz';

  @override
  String get completed_games => 'Completed Games';

  @override
  String get change_language => 'Change Language';

  @override
  String get logout => 'Logout';

  @override
  String get logout_confirmation => 'Are you sure you want to logout?';

  @override
  String get serial_number => 'Sl No';

  @override
  String get title => 'Title';

  @override
  String get completed_at => 'Completed At';

  @override
  String get name => 'Name';

  @override
  String get email => 'Email';

  @override
  String get phone_number => 'Phone Number';

  @override
  String get submit => 'Submit';

  @override
  String get cancel => 'Cancel';

  @override
  String get ok => 'OK';

  @override
  String cannot_be_blank(String field) {
    return '$field can\'t be blank.';
  }

  @override
  String length_greater_than(String field, int minLength) {
    return '$field should be greater than or equal to $minLength characters.';
  }

  @override
  String enter_valid_msg(String field) {
    return 'Enter a valid $field.';
  }

  @override
  String get enter_valid_date => 'Enter a Valid date';

  @override
  String get date_cannot_be_blank => 'Date cannot be blank';

  @override
  String get email_validator => 'Enter valid Email.';

  @override
  String get phone_validation => 'Enter a valid mobile no (10 digits)';

  @override
  String enter_value(String value) {
    return 'Enter $value.';
  }

  @override
  String get otp => 'Otp';
}
