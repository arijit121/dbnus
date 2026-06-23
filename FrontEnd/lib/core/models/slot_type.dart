import 'package:dbnus/shared/extensions/logger_extension.dart';

class SlotType {
  int? isMorningSlot;
  String? title;
  int? isEveningSlot;

  SlotType({this.isMorningSlot, this.title, this.isEveningSlot});

  SlotType.fromJson(Map<String, dynamic> json) {
    try {
      isMorningSlot = json['IsMorningSlot'];
      title = json['Title'];
      isEveningSlot = json['IsEveningSlot'];
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['IsMorningSlot'] = isMorningSlot;
    data['Title'] = title;
    data['IsEveningSlot'] = isEveningSlot;
    return data;
  }
}
