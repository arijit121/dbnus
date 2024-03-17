import '../../extension/logger_extension.dart';
import '../../service/value_handler.dart';

class PatientModel {
  String? dOB;
  String? emailId;
  String? gender;
  int? lastBookedPatient;
  String? mobileNo;
  String? name;
  List<PatientAddress>? patientAddress;
  String? patientId;
  String? relationship;
  int? ageYr;

  PatientModel(
      {this.dOB,
      this.emailId,
      this.gender,
      this.lastBookedPatient,
      this.mobileNo,
      this.name,
      this.patientAddress,
      this.patientId,
      this.relationship,
      this.ageYr});

  PatientModel.fromJson(Map<String, dynamic> json) {
    try {
      dOB = json['DOB'];
      emailId = json['EmailId'];
      gender = json['Gender'];
      lastBookedPatient = json['LastBookedPatient'];
      mobileNo = "${json['MobileNo']}";
      name = json['Name'];
      if (json['PatientAddress'] != null) {
        patientAddress = <PatientAddress>[];
        json['PatientAddress'].forEach((v) {
          patientAddress!.add(PatientAddress.fromJson(v));
        });
      }
      patientId = "${json['PatientId']}";
      relationship = json['Relationship'];
      ageYr = json['AgeYr'] ?? json['Age'];
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['DOB'] = dOB;
    data['EmailId'] = emailId;
    data['Gender'] = gender;
    data['LastBookedPatient'] = lastBookedPatient;
    data['MobileNo'] = mobileNo;
    data['Name'] = name;
    if (patientAddress != null) {
      data['PatientAddress'] = patientAddress!.map((v) => v.toJson()).toList();
    }
    data['PatientId'] = patientId;
    data['Relationship'] = relationship;
    data['AgeYr'] = ageYr;
    return data;
  }
}

class PatientAddress {
  String? addline;
  int? addressId;
  String? addressType;
  String? city;
  bool? isPrimary;
  String? landmark;
  int? lastBookedAddress;
  String? nickName;
  int? patientId;
  int? pinCode;
  String? stateName;
  int? userId;

  PatientAddress(
      {this.addline,
      this.addressId,
      this.addressType,
      this.city,
      this.isPrimary,
      this.landmark,
      this.lastBookedAddress,
      this.nickName,
      this.patientId,
      this.pinCode,
      this.stateName,
      this.userId});

  PatientAddress.fromJson(Map<String, dynamic> json) {
    try {
      addline = json['Addline'];
      addressId = json['AddressId'];
      addressType = ValueHandler().stringify(json['AddressType']);
      city = json['City'];
      isPrimary = json['IsPrimary'];
      landmark = ValueHandler().stringify(json['Landmark']);
      lastBookedAddress = json['LastBookedAddress'];
      nickName = json['NickName'];
      patientId = json['PatientId'];
      pinCode = json['PinCode'];
      stateName = json['StateName'];
      userId = json['UserId'];
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Addline'] = addline;
    data['AddressId'] = addressId;
    data['AddressType'] = addressType;
    data['City'] = city;
    data['IsPrimary'] = isPrimary;
    data['Landmark'] = landmark;
    data['LastBookedAddress'] = lastBookedAddress;
    data['NickName'] = nickName;
    data['PatientId'] = patientId;
    data['PinCode'] = pinCode;
    data['StateName'] = stateName;
    data['UserId'] = userId;
    return data;
  }
}
