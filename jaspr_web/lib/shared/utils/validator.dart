import 'package:intl/intl.dart';

import '../../core/localization/extension/localization_ext.dart';
import '../extensions/logger_extension.dart';
import '../../core/services/context_service.dart';
import '../constants/text_utils.dart';

class Validator {
  static String? textValidatorAlphanumericWithSpecialCharacters(
      {String? value, required String msg}) {
    final context = CurrentContext().context;
    String p = r'^[ A-Za-z0-9-,\.(@/-_)&]*$';
    RegExp regExp = RegExp(p);
    bool validate = regExp.hasMatch(value ?? "");

    if (value == null || value.isEmpty) {
      return context.l10n.cannot_be_blank(msg);
    } else if (value.trim().isEmpty) {
      return context.l10n.enter_valid_msg(msg);
    } else if (value.length < 3) {
      return context.l10n.length_greater_than(msg, 3);
    } else if (!validate) {
      return context.l10n.enter_valid_msg(msg);
    } else {
      return null;
    }
  }

  static String? textValidatorAlphanumeric(
      {String? value, required String msg}) {
    final context = CurrentContext().context;
    String p = r'^[ A-Za-z0-9]*$';
    RegExp regExp = RegExp(p);
    bool validate = regExp.hasMatch(value ?? "");

    if (value == null || value.isEmpty || value[0] == " ") {
      return context.l10n.cannot_be_blank(msg);
    } else if (value.length < 3) {
      return context.l10n.length_greater_than(msg, 3);
    } else if (!validate) {
      return context.l10n.enter_valid_msg(msg);
    } else {
      return null;
    }
  }

  static String? onlyNameValidator({String? value, required String msg}) {
    final context = CurrentContext().context;
    String p = r'^[ A-Za-z.]*$';
    RegExp regExp = RegExp(p);
    bool validate = regExp.hasMatch(value ?? "");

    if (value == null || value.isEmpty) {
      return context.l10n.cannot_be_blank(msg);
    } else if (value.trim().isEmpty) {
      return context.l10n.enter_valid_msg(msg);
    } else if (value.length < 3) {
      return context.l10n.length_greater_than(msg, 3);
    } else if (!validate) {
      return context.l10n.enter_valid_msg(msg);
    } else {
      return null;
    }
  }

  static String? onlyTextValidator({String? value, required String msg}) {
    final context = CurrentContext().context;
    String p = r'^[ A-Za-z]*$';
    RegExp regExp = RegExp(p);
    bool validate = regExp.hasMatch(value ?? "");

    if (value == null || value.isEmpty) {
      return context.l10n.cannot_be_blank(msg);
    } else if (value.trim().isEmpty) {
      return context.l10n.enter_valid_msg(msg);
    } else if (value.length < 3) {
      return context.l10n.length_greater_than(msg, 3);
    } else if (!validate) {
      return context.l10n.enter_valid_msg(msg);
    } else {
      return null;
    }
  }

  static String? pinCodeValidator(String? value) {
    final context = CurrentContext().context;
    String p = r'^[1-9][0-9]{5}$';
    RegExp regExp = RegExp(p);
    bool validate = regExp.hasMatch(value ?? "");

    if (value == null || value.isEmpty) {
      return context.l10n.cannot_be_blank(TextUtils.pinCode);
    } else if (value[0] == " ") {
      return context.l10n.enter_valid_msg(TextUtils.pinCode);
    } else if (value.length != 6 || !validate) {
      return context.l10n.enter_valid_msg(TextUtils.pinCode);
    } else {
      return null;
    }
  }

  static String? dobValidator({String? value}) {
    final context = CurrentContext().context;
    try {
      if (value == null || value.isEmpty) {
        return context.l10n.date_cannot_be_blank;
      } else if (value.length < 10) {
        return context.l10n.enter_valid_date;
      } else if (value.length == 10) {
        var date = DateTime.parse(value);
        if (DateFormat("yyyy-MM-dd").format(date) != value ||
            date.difference(DateTime.now()).inDays > 0) {
          return context.l10n.date_cannot_be_blank;
        }
      }
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
    return null;
  }

  static String? emailValidator(String? value) {
    final context = CurrentContext().context;
    String p =
        r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(p);
    bool validate = regExp.hasMatch(value?.trim() ?? "");
    if (!validate) {
      return context.l10n.email_validator;
    } else {
      return null;
    }
  }

  static String? phoneNumberValidator(String? value) {
    final context = CurrentContext().context;
    String p = r'^[0-9]*$';
    RegExp regExp = RegExp(p);
    bool validate = regExp.hasMatch(value ?? "");

    if (value == null || value.isEmpty) {
      return context.l10n.phone_validation;
    } else if (value[0] == " " || !validate) {
      return context.l10n.phone_validation;
    } else if (int.parse(value[0]) < 5) {
      return context.l10n.phone_validation;
    } else if (value.length != 10) {
      return context.l10n.phone_validation;
    } else {
      return null;
    }
  }

  static String? otpValidator(String? value) {
    final context = CurrentContext().context;
    String p = r'^[0-9]*$';
    RegExp regExp = RegExp(p);
    bool validate = regExp.hasMatch(value ?? "");

    if (value == null || value.isEmpty) {
      return context.l10n.enter_value(context.l10n.otp);
    } else if (value.length != 5 || !validate) {
      return context.l10n.enter_valid_msg(context.l10n.otp);
    } else {
      return null;
    }
  }

  static String? numValidator({
    required String? value,
    required int length,
    required String msg,
    bool? checkZero,
    bool? equalLength,
  }) {
    final context = CurrentContext().context;
    String p = r'^[0-9]*$';
    RegExp regExp = RegExp(p);
    bool validate = regExp.hasMatch(value ?? "");

    if (value == null || value.isEmpty) {
      return context.l10n.enter_value(msg);
    } else if (checkZero == true && num.parse(value) < 1) {
      return context.l10n.enter_value(msg);
    } else if ((equalLength == true && value.length != length) || !validate) {
      return context.l10n.enter_valid_msg(msg);
    } else if (value.length > length || !validate) {
      return context.l10n.enter_valid_msg(msg);
    } else {
      return null;
    }
  }

  static bool? isBeforeDate(
      {required String startDate, required String endDate}) {
    if (startDate == "" || endDate == "") {
      return null;
    } else {
      return DateTime.parse(startDate).isBefore(DateTime.parse(endDate));
    }
  }
}
