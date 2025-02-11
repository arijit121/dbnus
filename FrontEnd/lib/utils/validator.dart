import 'package:dbnus/service/Localization/extension/localization_ext.dart';
import 'package:intl/intl.dart';

import '../extension/logger_extension.dart';
import '../utils/text_utils.dart';
import '../service/context_service.dart';

class Validator {
  String? textValidatorAlphanumericWithSpecialCharacters(
      {String? value, required String msg}) {
    final context = CurrentContext().context;
    String p = r'^[ A-Za-z0-9-,\.(@/-_)&]*$';
    RegExp regExp = RegExp(p);
    bool validate = regExp.hasMatch(value ?? "");

    if (value == null || value.isEmpty) {
      return context.l10n?.cannot_be_blank(msg) ??
          "$msg ${TextUtils.cannot_be_blank}";
    } else if (value.trim().isEmpty) {
      return context.l10n?.enter_valid_msg(msg) ??
          "${TextUtils.enter_valid_msg} $msg .";
    } else if (value.length < 3) {
      return context.l10n?.length_greater_than(msg, 3) ??
          "$msg ${TextUtils.length_grater_than}";
    } else if (!validate) {
      return context.l10n?.enter_valid_msg(msg) ??
          "${TextUtils.enter_valid_msg} $msg .";
    } else {
      return null;
    }
  }

  String? textValidatorAlphanumeric({String? value, required String msg}) {
    final context = CurrentContext().context;
    String p = r'^[ A-Za-z0-9]*$';
    RegExp regExp = RegExp(p);
    bool validate = regExp.hasMatch(value ?? "");

    if (value == null || value.isEmpty || value[0] == " ") {
      return context.l10n?.cannot_be_blank(msg) ??
          "$msg ${TextUtils.cannot_be_blank}";
    } else if (value.length < 3) {
      return context.l10n?.length_greater_than(msg, 3) ??
          "$msg ${TextUtils.length_grater_than}";
    } else if (!validate) {
      return context.l10n?.enter_valid_msg(msg) ??
          "${TextUtils.enter_valid_msg} $msg .";
    } else {
      return null;
    }
  }

  String? onlyNameValidator({String? value, required String msg}) {
    final context = CurrentContext().context;
    String p = r'^[ A-Za-z.]*$';
    RegExp regExp = RegExp(p);
    bool validate = regExp.hasMatch(value ?? "");

    if (value == null || value.isEmpty) {
      return context.l10n?.cannot_be_blank(msg) ??
          "$msg ${TextUtils.cannot_be_blank}";
    } else if (value.trim().isEmpty) {
      return context.l10n?.enter_valid_msg(msg) ??
          "${TextUtils.enter_valid_msg} $msg .";
    } else if (value.length < 3) {
      return context.l10n?.length_greater_than(msg, 3) ??
          "$msg ${TextUtils.length_grater_than}";
    } else if (!validate) {
      return context.l10n?.enter_valid_msg(msg) ??
          "${TextUtils.enter_valid_msg} $msg .";
    } else {
      return null;
    }
  }

  String? onlyTextValidator({String? value, required String msg}) {
    final context = CurrentContext().context;
    String p = r'^[ A-Za-z]*$';
    RegExp regExp = RegExp(p);
    bool validate = regExp.hasMatch(value ?? "");

    if (value == null || value.isEmpty) {
      return context.l10n?.cannot_be_blank(msg) ??
          "$msg ${TextUtils.cannot_be_blank}";
    } else if (value.trim().isEmpty) {
      return context.l10n?.enter_valid_msg(msg) ??
          "${TextUtils.enter_valid_msg} $msg .";
    } else if (value.length < 3) {
      return context.l10n?.length_greater_than(msg, 3) ??
          "$msg ${TextUtils.length_grater_than}";
    } else if (!validate) {
      return context.l10n?.enter_valid_msg(msg) ??
          "${TextUtils.enter_valid_msg} $msg .";
    } else {
      return null;
    }
  }

  String? pinCodeValidator(String? value) {
    final context = CurrentContext().context;
    String p = r'^[1-9][0-9]{5}$';
    RegExp regExp = RegExp(p);
    bool validate = regExp.hasMatch(value ?? "");

    if (value == null || value.isEmpty) {
      return context.l10n?.cannot_be_blank(TextUtils.pinCode) ??
          "${TextUtils.pinCode} ${TextUtils.cannot_be_blank}";
    } else if (value[0] == " ") {
      return context.l10n?.enter_valid_msg(TextUtils.pinCode) ??
          "${TextUtils.enter_valid_msg} ${TextUtils.pinCode} .";
    } else if (value.length != 6 || !validate) {
      return context.l10n?.enter_valid_msg(TextUtils.pinCode) ??
          "${TextUtils.enter_valid_msg} ${TextUtils.pinCode} .";
    } else {
      return null;
    }
  }

  String? dobValidator({String? value}) {
    final context = CurrentContext().context;
    try {
      if (value == null || value.isEmpty) {
        return context.l10n?.date_cannot_be_blank ?? TextUtils.dateCannotBlank;
      } else if (value.length < 10) {
        return context.l10n?.enter_valid_date ?? TextUtils.enterValidDate;
      } else if (value.length == 10) {
        var date = DateTime.parse(value);
        if (DateFormat("yyyy-MM-dd").format(date) != value ||
            date.difference(DateTime.now()).inDays > 0) {
          return context.l10n?.date_cannot_be_blank ??
              TextUtils.dateCannotBlank;
        }
      }
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
    return null;
  }

  String? emailValidator(String? value) {
    final context = CurrentContext().context;
    String p =
        r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(p);
    bool validate = regExp.hasMatch(value?.trim() ?? "");
    if (!validate) {
      return context.l10n?.email_validator ?? TextUtils.emailValidator;
    } else {
      return null;
    }
  }

  String? phoneNumberValidator(String? value) {
    final context = CurrentContext().context;
    String p = r'^[0-9]*$';
    RegExp regExp = RegExp(p);
    bool validate = regExp.hasMatch(value ?? "");

    if (value == null || value.isEmpty) {
      return context.l10n?.phone_validation ?? TextUtils.phoneValidation;
    } else if (value[0] == " " || !validate) {
      return context.l10n?.phone_validation ?? TextUtils.phoneValidation;
    } else if (int.parse(value[0]) < 5) {
      return context.l10n?.phone_validation ?? TextUtils.phoneValidation;
    } else if (value.length != 10) {
      return context.l10n?.phone_validation ?? TextUtils.phoneValidation;
    } else {
      return null;
    }
  }

  String? otpValidator(String? value) {
    final context = CurrentContext().context;
    String p = r'^[0-9]*$';
    RegExp regExp = RegExp(p);
    bool validate = regExp.hasMatch(value ?? "");

    if (value == null || value.isEmpty) {
      return context.l10n?.enter_value(context.l10n?.otp ?? "") ??
          "Enter ${TextUtils.otp}";
    } else if (value.length != 5 || !validate) {
      return context.l10n?.enter_valid_msg(context.l10n?.otp ?? "") ??
          "Enter Valid ${TextUtils.otp}";
    } else {
      return null;
    }
  }

  String? numValidator({
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
      return context.l10n?.enter_value(msg) ?? "Enter $msg .";
    } else if (checkZero == true && num.parse(value ?? "0") < 1) {
      return context.l10n?.enter_value(msg) ?? "Enter $msg .";
    } else if ((equalLength == true && value.length != length) || !validate) {
      return context.l10n?.enter_valid_msg(msg) ?? "Enter Valid $msg .";
    } else if (value.length > length || !validate) {
      return context.l10n?.enter_valid_msg(msg) ?? "Enter Valid $msg .";
    } else {
      return null;
    }
  }

  bool? isBeforeDate({required String startDate, required String endDate}) {
    if (startDate == "" || endDate == "") {
      return null;
    } else {
      return DateTime.parse(startDate).isBefore(DateTime.parse(endDate));
    }
  }

  String? bodyWeight(String? value) {
    String p = r'^-?\d+(?:\.\d+)?$';
    RegExp regExp = RegExp(p);

    bool validate = regExp.hasMatch(value ?? "");

    if (value == null || value.isEmpty) {
      return "${TextUtils.body_weight} ${TextUtils.cannot_be_blank}";
    } else if (value[0] == " " || !validate) {
      return "${TextUtils.enter_valid_msg} ${TextUtils.body_weight} .";
    } else if (num.parse(value) > 250 || num.parse(value) < 1) {
      return "${TextUtils.enter_valid_msg} ${TextUtils.body_weight} (1-250) Kgs .";
    } else {
      return null;
    }
  }

  String? bodyHeight(String? value) {
    String p = r'^-?\d+(?:\.\d+)?$';
    RegExp regExp = RegExp(p);

    bool validate = regExp.hasMatch(value ?? "");

    if (value == null || value.isEmpty) {
      return "${TextUtils.height} ${TextUtils.cannot_be_blank}";
    } else if (value[0] == " " || !validate) {
      return "${TextUtils.enter_valid_msg} ${TextUtils.height} .";
    } else if (num.parse(value) > 250 || num.parse(value) < 1) {
      return "${TextUtils.enter_valid_msg} ${TextUtils.height} (1-250) cm .";
    } else {
      return null;
    }
  }

  String? bodyTemperature(String? value) {
    String p = r'^-?\d+(?:\.\d+)?$';
    RegExp regExp = RegExp(p);

    bool validate = regExp.hasMatch(value ?? "");

    if (value == null || value.isEmpty) {
      return "${TextUtils.body_temperature} ${TextUtils.cannot_be_blank}";
    } else if (value[0] == " " || !validate) {
      return "${TextUtils.enter_valid_msg} ${TextUtils.body_temperature} .";
    } else if (num.parse(value) > 125 || num.parse(value) < 1) {
      return "${TextUtils.enter_valid_msg} ${TextUtils.body_temperature} (1-125)°F .";
    } else {
      return null;
    }
  }

  String? bloodPressure(String? value) {
    String p = r'^[0-9]*$';
    RegExp regExp = RegExp(p);

    bool validate = regExp.hasMatch(value ?? "");

    if (value == null || value.isEmpty) {
      return "${TextUtils.blood_pressure} \n${TextUtils.cannot_be_blank}";
    } else if (value[0] == " " || !validate) {
      return "${TextUtils.enter_valid_msg} \n${TextUtils.blood_pressure} .";
    } else if (num.parse(value) > 500 || num.parse(value) < 1) {
      return "${TextUtils.enter_valid_msg} \n${TextUtils.blood_pressure} (1-500) .";
    } else {
      return null;
    }
  }

  String? pulseRate(String? value) {
    String p = r'^[0-9]*$';
    RegExp regExp = RegExp(p);

    bool validate = regExp.hasMatch(value ?? "");

    if (value == null || value.isEmpty) {
      return "${TextUtils.pulse_rate} ${TextUtils.cannot_be_blank}";
    } else if (value[0] == " " || !validate) {
      return "${TextUtils.enter_valid_msg} ${TextUtils.pulse_rate} .";
    } else if (num.parse(value) > 300 || num.parse(value) < 1) {
      return "${TextUtils.enter_valid_msg} ${TextUtils.pulse_rate} (1-300) .";
    } else {
      return null;
    }
  }
}
