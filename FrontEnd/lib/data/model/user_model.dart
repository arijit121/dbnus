import '../../extension/logger_extension.dart';
import '../../service/value_handler.dart';

class UserModel {
  String? addLine;
  int? age;
  String? alternativeContactNo;
  String? city;
  String? dOB;
  String? emailId;
  String? firstName;
  String? fullName;
  String? gender;
  String? landmark;
  String? lastName;
  String? maritalStatus;
  String? middleName;
  String? mobileNo;
  String? pinCode;
  int? smartReportExists;
  String? stateName;
  String? status;
  String? userId;
  String? custUserId;
  String? lastPincode;
  String? accessToken;
  String? rtoken;

  UserModel({
    this.addLine,
    this.age,
    this.alternativeContactNo,
    this.city,
    this.dOB,
    this.emailId,
    this.firstName,
    this.fullName,
    this.gender,
    this.landmark,
    this.lastName,
    this.maritalStatus,
    this.middleName,
    this.mobileNo,
    this.pinCode,
    this.smartReportExists,
    this.stateName,
    this.status,
    this.userId,
    this.custUserId,
    this.lastPincode,
    this.accessToken,
    this.rtoken,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    try {
      addLine = json['AddLine'];
      age = json['Age'];
      alternativeContactNo = json['AlternativeContactNo'];
      city = json['City'];
      dOB = json['DOB'];
      emailId = json['EmailId'];
      firstName = json['FirstName'];
      fullName = json['FullName'];
      gender = json['Gender'];
      landmark = json['Landmark'];
      lastName = json['LastName'];
      maritalStatus = json['MaritalStatus'];
      middleName = json['MiddleName'];
      mobileNo = ValueHandler().stringify(json['MobileNo']);
      pinCode = ValueHandler().stringify(json['PinCode']);
      smartReportExists = json['SmartReportExists'];
      stateName = json['StateName'];
      status = json['Status'];
      userId = ValueHandler().stringify(json['UserId']);
      custUserId = json['CustUserId'];
      lastPincode = ValueHandler().stringify(json['LastPincode']);
      accessToken = json['access_token'];
      rtoken = json['rtoken'];
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['AddLine'] = addLine;
    data['Age'] = age;
    data['AlternativeContactNo'] = alternativeContactNo;
    data['City'] = city;
    data['DOB'] = dOB;
    data['EmailId'] = emailId;
    data['FirstName'] = firstName;
    data['FullName'] = fullName;
    data['Gender'] = gender;
    data['Landmark'] = landmark;
    data['LastName'] = lastName;
    data['MaritalStatus'] = maritalStatus;
    data['MiddleName'] = middleName;
    data['MobileNo'] = mobileNo;
    data['PinCode'] = pinCode;
    data['SmartReportExists'] = smartReportExists;
    data['StateName'] = stateName;
    data['Status'] = status;
    data['UserId'] = userId;
    data['CustUserId'] = custUserId;
    data['LastPincode'] = lastPincode;
    data['access_token'] = accessToken;
    data['rtoken'] = rtoken;
    return data;
  }
}
