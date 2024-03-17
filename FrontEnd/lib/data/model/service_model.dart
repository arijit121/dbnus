import '../../extension/logger_extension.dart';
import '../../service/value_handler.dart';

class ServiceModel {
  String? permalink;
  List<Labs>? labs;
  String? pkgAppBannerImage;
  String? subDeptName;
  String? pkgAppServiceImage;
  bool? isActive;
  bool? isPopular;
  String? pkgWebServiceImage;
  String? pkgWebBannerImage;
  String? subDeptId;
  String? newServiceImage;
  String? serviceImage;
  num? discAmount;
  String? serviceId;
  int? promoApplicable;
  String? appPackageImage;
  bool? isPackage;
  String? serviceText;
  num? offerFees;
  bool? isRadiology;
  String? permalinkNew;
  String? servicePreparation;
  num? discPercent;
  int? reportPeriod;
  bool? isHomeCollectionAvailable;
  bool? isRptAvlOnline;
  num? fees;
  List<Services>? packageServices;
  String? labId;
  String? serviceName;
  int? isYana;
  String? testCase;
  String? serviceDesc;
  String? newServiceShortHomeImage;
  List<String>? labIds;
  String? homeCollectionText;
  String? reportText;
  String? howThePackageHelps;
  int? isNABL;
  int? noOfParameters;
  List<Organs>? organs;
  String? sEOServiceDesc;
  String? sampleReport;
  String? sampleReportPath;
  String? sampleType;
  String? serviceParam;
  List<Services>? services;
  String? testOrderedFor;
  String? testRecommended;
  String? testRequiredFor;
  String? cntMsg;
  bool? isConsultation;

  ServiceModel({
    this.permalink,
    this.labs,
    this.pkgAppBannerImage,
    this.subDeptName,
    this.pkgAppServiceImage,
    this.isActive,
    this.isPopular,
    this.pkgWebServiceImage,
    this.pkgWebBannerImage,
    this.subDeptId,
    this.newServiceImage,
    this.serviceImage,
    this.discAmount,
    this.serviceId,
    this.promoApplicable,
    this.appPackageImage,
    this.isPackage,
    this.serviceText,
    this.offerFees,
    this.isRadiology,
    this.permalinkNew,
    this.servicePreparation,
    this.discPercent,
    this.reportPeriod,
    this.isHomeCollectionAvailable,
    this.isRptAvlOnline,
    this.fees,
    this.packageServices,
    this.labId,
    this.serviceName,
    this.isYana,
    this.testCase,
    this.serviceDesc,
    this.newServiceShortHomeImage,
    this.labIds,
    this.homeCollectionText,
    this.reportText,
    this.howThePackageHelps,
    this.isNABL,
    this.noOfParameters,
    this.organs,
    this.sEOServiceDesc,
    this.sampleReport,
    this.sampleReportPath,
    this.sampleType,
    this.serviceParam,
    this.services,
    this.testOrderedFor,
    this.testRecommended,
    this.testRequiredFor,
    this.cntMsg,
    this.isConsultation,
  });

  ServiceModel.fromJson(Map<String, dynamic> json) {
    try {
      permalink = json['Permalink'];
      if (json['Labs'] != null) {
        labs = <Labs>[];
        json['Labs'].forEach((v) {
          labs!.add(Labs.fromJson(v));
        });
      }
      pkgAppBannerImage = json['PkgAppBannerImage'];
      subDeptName = json['SubDeptName'];
      pkgAppServiceImage = json['PkgAppServiceImage'];
      isActive = json['IsActive'];
      isPopular = json['IsPopular'];
      pkgWebServiceImage = json['PkgWebServiceImage'];
      pkgWebBannerImage = json['PkgWebBannerImage'];
      subDeptId = ValueHandler().stringify(json['SubDeptId']);
      newServiceImage = json['NewServiceImage'];
      serviceImage = json['ServiceImage'];
      discAmount = json['DiscAmount'] ?? json['Discount'];
      serviceId = ValueHandler().stringify(json['ServiceId']);
      promoApplicable = json['PromoApplicable'];
      appPackageImage = json['AppPackageImage'] ?? json['icon250ImageUrl'];
      isPackage = ValueHandler().boolify(json['IsPackage']);
      serviceText = json['ServiceText'];
      offerFees = json['OfferFees'] ?? json["OfferPrice"];
      isRadiology = json['IsRadiology'];
      permalinkNew = json['PermalinkNew'];
      servicePreparation = json['ServicePreparation'];
      discPercent = json['DiscPercent'];
      reportPeriod = json['ReportPeriod'];
      isHomeCollectionAvailable = json['IsHomeCollectionAvailable'];
      isRptAvlOnline = json['IsRptAvlOnline'];
      fees = json['Fees'] ?? json['fees'];
      if (json['PackageServices'] != null) {
        packageServices = <Services>[];
        json['PackageServices'].forEach((v) {
          packageServices!.add(Services.fromJson(v));
        });
      }
      labId = ValueHandler().stringify(json['LabId']);
      serviceName = json['ServiceName'];
      isYana = json['IsYana'];
      testCase = json['TestCase'];
      serviceDesc = json['ServiceDesc'];
      newServiceShortHomeImage = json['NewServiceShortHomeImage'];
      if (json['LabIds'] != null) {
        labIds = json['LabIds'].cast<String>();
      }
      homeCollectionText = json['HomeCollectionText'];
      reportText = json['ReportText'];
      howThePackageHelps = json['HowThePackageHelps'];
      isNABL = json['IsNABL'];
      noOfParameters = json['NoOfParameters'];
      if (json['Organs'] != null) {
        organs = <Organs>[];
        json['Organs'].forEach((v) {
          organs!.add(Organs.fromJson(v));
        });
      }
      sEOServiceDesc = json['SEOServiceDesc'];
      sampleReport = json['SampleReport'];
      sampleReportPath = json['SampleReportPath'];
      sampleType = json['SampleType'];
      serviceParam = json['ServiceParam'];
      if (json['Services'] != null) {
        services = <Services>[];
        json['Services'].forEach((v) {
          services!.add(Services.fromJson(v));
        });
      }
      testOrderedFor = json['TestOrderedFor'];
      testRecommended = json['TestRecommended'];
      testRequiredFor = json['TestRequiredFor'];
      cntMsg = json['cntMsg'];
      isConsultation = json['IsConsultation'];
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
  }

  ServiceModel.fromDetailsJson(Map<String, dynamic> json) {
    try {
      permalink = json['Permalink'];
      if (json['Labs'] != null) {
        labs = <Labs>[];
        json['Labs'].forEach((v) {
          labs!.add(Labs.fromJson(v));
        });
      }
      pkgAppBannerImage = json['PkgAppBannerImage'];
      subDeptName = json['SubDeptName'];
      pkgAppServiceImage = json['PkgAppServiceImage'];
      isActive = json['IsActive'];
      isPopular = json['IsPopular'];
      pkgWebServiceImage = json['PkgWebServiceImage'];
      pkgWebBannerImage = json['PkgWebBannerImage'];
      subDeptId = ValueHandler().stringify(json['SubDeptId']);
      newServiceImage = json['NewServiceImage'];
      serviceImage = json['ServiceImage'];
      discAmount = json['DiscAmount'] ?? json['Discount'];
      serviceId = ValueHandler().stringify(json['ServiceId']);
      promoApplicable = json['PromoApplicable'];
      appPackageImage = json['AppPackageImage'] ?? json['icon250ImageUrl'];
      isPackage = ValueHandler().boolify(json['IsPackage']);
      serviceText = json['ServiceText'];
      offerFees = json['OfferFees'] ?? json["OfferPrice"];
      isRadiology = json['IsRadiology'];
      permalinkNew = json['PermalinkNew'];
      servicePreparation = json['ServicePreparation'];
      discPercent = json['DiscPercent'];
      reportPeriod = json['ReportPeriod'];
      isHomeCollectionAvailable = json['IsHomeCollectionAvailable'];
      isRptAvlOnline = json['IsRptAvlOnline'];
      fees = json['Fees'] ?? json['fees'];
      if (json['PackageServices'] != null) {
        packageServices = <Services>[];
        json['PackageServices'].forEach((v) {
          packageServices!.add(Services.fromJson(v));
        });
      }
      labId = ValueHandler().stringify(json['LabId']);
      serviceName = json['ServiceName'];
      isYana = json['IsYana'];
      testCase = json['TestCase'];
      serviceDesc = json['ServiceDesc'];
      newServiceShortHomeImage = json['NewServiceShortHomeImage'];
      if (json['LabIds'] != null) {
        labIds = json['LabIds'].cast<String>();
      }
      homeCollectionText = json['HomeCollectionText'];
      reportText = json['ReportText'];
      howThePackageHelps = json['HowThePackageHelps'];
      isNABL = json['IsNABL'];
      noOfParameters = json['NoOfParameters'];
      if (json['Organs'] != null) {
        organs = <Organs>[];
        json['Organs'].forEach((v) {
          organs!.add(Organs.fromJson(v));
        });
      }
      sEOServiceDesc = json['SEOServiceDesc'];
      sampleReport = json['SampleReport'];
      sampleReportPath = json['SampleReportPath'];
      sampleType = json['SampleType'];
      serviceParam = json['ServiceParam'];
      if (json['Services'] != null) {
        services = <Services>[];
        json['Services'].forEach((v) {
          services!.add(Services.fromJson(v));
        });
      }
      testOrderedFor = json['TestOrderedFor'];
      testRecommended = json['TestRecommended'];
      testRequiredFor = json['TestRequiredFor'];
      cntMsg = json['cntMsg'];
      isConsultation = json['IsConsultation'];
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
  }

  ServiceModel.fromConsultationLabTestJson(Map<String, dynamic> json) {
    try {
      serviceId = ValueHandler().stringify(json['ServiceId']);
      serviceName = json['ServiceName'];
      discPercent = json['Discount'];
      fees = json['Fees'] ?? json['fees'];
      offerFees = json['OfferFees'] ?? json["OfferPrice"];
      labId = ValueHandler().stringify(json['LabId']);
      if (json['PackageServices'] != null) {
        packageServices = <Services>[];
        json['PackageServices'].forEach((v) {
          packageServices!.add(Services.fromJson(v));
        });
      }
      permalinkNew = json['PermalinkNew'];
      isPackage = ValueHandler().boolify(json['IsPackage']);
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Permalink'] = permalink;
    if (labs != null) {
      data['Labs'] = labs!.map((v) => v.toJson()).toList();
    }
    data['PkgAppBannerImage'] = pkgAppBannerImage;
    data['SubDeptName'] = subDeptName;
    data['PkgAppServiceImage'] = pkgAppServiceImage;
    data['IsActive'] = isActive;
    data['IsPopular'] = isPopular;
    data['PkgWebServiceImage'] = pkgWebServiceImage;
    data['PkgWebBannerImage'] = pkgWebBannerImage;
    data['SubDeptId'] = subDeptId;
    data['NewServiceImage'] = newServiceImage;
    data['ServiceImage'] = serviceImage;
    data['DiscAmount'] = discAmount;
    data['ServiceId'] = serviceId;
    data['PromoApplicable'] = promoApplicable;
    data['AppPackageImage'] = appPackageImage;
    data['IsPackage'] = isPackage;
    data['ServiceText'] = serviceText;
    data['OfferFees'] = offerFees;

    data['IsRadiology'] = isRadiology;
    data['PermalinkNew'] = permalinkNew;
    data['ServicePreparation'] = servicePreparation;
    data['DiscPercent'] = discPercent;
    data['ReportPeriod'] = reportPeriod;
    data['IsHomeCollectionAvailable'] = isHomeCollectionAvailable;
    data['IsRptAvlOnline'] = isRptAvlOnline;
    data['Fees'] = fees;
    if (packageServices != null) {
      data['PackageServices'] =
          packageServices!.map((v) => v.toJson()).toList();
    }
    data['LabId'] = labId;
    data['ServiceName'] = serviceName;
    data['IsYana'] = isYana;
    data['TestCase'] = testCase;
    data['ServiceDesc'] = serviceDesc;
    data['NewServiceShortHomeImage'] = newServiceShortHomeImage;
    data['LabIds'] = labIds;
    data['HomeCollectionText'] = homeCollectionText;
    data['ReportText'] = reportText;
    data['TestOrderedFor'] = testOrderedFor;
    data['TestRecommended'] = testRecommended;
    data['TestRequiredFor'] = testRequiredFor;
    data['cntMsg'] = cntMsg;
    data['IsConsultation'] = isConsultation;
    return data;
  }
}

class Labs {
  String? emailId;
  bool? isActive;
  String? stateName;
  int? stateId;
  String? city;
  String? labType;
  String? cityName;
  String? contactEmailId;
  num? fees;
  String? areaName;
  String? labName;
  String? labId;
  int? cityId;
  String? labTypeDesc;
  String? contactPersonName;
  String? phoneNumber;
  String? contactNumber;
  String? registrationNumber;
  num? offerFees;
  String? addLine1;
  String? addLine2;
  String? pincode;
  num? discountPercent;

  Labs(
      {this.emailId,
      this.isActive,
      this.stateName,
      this.stateId,
      this.city,
      this.labType,
      this.cityName,
      this.contactEmailId,
      this.fees,
      this.areaName,
      this.labName,
      this.labId,
      this.cityId,
      this.labTypeDesc,
      this.contactPersonName,
      this.phoneNumber,
      this.contactNumber,
      this.registrationNumber,
      this.offerFees,
      this.addLine1,
      this.addLine2,
      this.pincode,
      this.discountPercent});

  Labs.fromJson(Map<String, dynamic> json) {
    try {
      emailId = json['EmailId'];
      isActive = json['IsActive'];
      stateName = json['StateName'];
      stateId = json['StateId'];
      city = json['City'];
      labType = json['LabType'];
      cityName = json['CityName'];
      contactEmailId = json['ContactEmailId'];
      fees = json['Fees'];
      areaName = json['AreaName'];
      labName = json['LabName'];
      labId = json['LabId'];
      cityId = json['CityId'];
      labTypeDesc = json['LabTypeDesc'];
      contactPersonName = json['ContactPersonName'];
      phoneNumber = json['PhoneNumber'];
      contactNumber = json['ContactNumber'];
      registrationNumber = json['RegistrationNumber'];
      offerFees = json['OfferFees'];
      addLine1 = json['AddLine1'];
      addLine2 = json['AddLine2'];
      pincode = json['Pincode'];
      discountPercent = json['DiscountPercent'];
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['EmailId'] = emailId;
    data['IsActive'] = isActive;
    data['StateName'] = stateName;
    data['StateId'] = stateId;
    data['City'] = city;
    data['LabType'] = labType;
    data['CityName'] = cityName;
    data['ContactEmailId'] = contactEmailId;
    data['Fees'] = fees;
    data['AreaName'] = areaName;
    data['LabName'] = labName;
    data['LabId'] = labId;
    data['CityId'] = cityId;
    data['LabTypeDesc'] = labTypeDesc;
    data['ContactPersonName'] = contactPersonName;
    data['PhoneNumber'] = phoneNumber;
    data['ContactNumber'] = contactNumber;
    data['RegistrationNumber'] = registrationNumber;
    data['OfferFees'] = offerFees;
    data['AddLine1'] = addLine1;
    data['AddLine2'] = addLine2;
    data['Pincode'] = pincode;
    data['DiscountPercent'] = discountPercent;
    return data;
  }
}

// class PackageServices {
//   String? serviceName;
//   String? serviceDesc;
//   String? serviceId;
//
//   PackageServices({this.serviceName, this.serviceDesc, this.serviceId});
//
//   PackageServices.fromJson(Map<String, dynamic> json) {
//     try {
//       serviceName = json['ServiceName'];
//       serviceDesc = json['ServiceDesc'];
//       serviceId = ValueHandler().stringify(json['ServiceId']);
//     } catch (e, stacktrace) {
//       AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['ServiceName'] = serviceName;
//     data['ServiceDesc'] = serviceDesc;
//     data['ServiceId'] = serviceId;
//     return data;
//   }
// }

class Organs {
  String? appOrganImage;
  int? noOfParameters;
  int? organId;
  String? organImage;
  String? organName;
  List<Services>? services;

  Organs(
      {this.appOrganImage,
      this.noOfParameters,
      this.organId,
      this.organImage,
      this.organName,
      this.services});

  Organs.fromJson(Map<String, dynamic> json) {
    try {
      appOrganImage = json['AppOrganImage'];
      noOfParameters = json['NoOfParameters'];
      organId = json['OrganId'];
      organImage = json['OrganImage'];
      organName = json['OrganName'];
      if (json['Services'] != null) {
        services = <Services>[];
        json['Services'].forEach((v) {
          services!.add(Services.fromJson(v));
        });
      }
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['AppOrganImage'] = appOrganImage;
    data['NoOfParameters'] = noOfParameters;
    data['OrganId'] = organId;
    data['OrganImage'] = organImage;
    data['OrganName'] = organName;
    if (services != null) {
      data['Services'] = services!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Services {
  String? appOrganImage;
  int? isPackage;
  int? isYana;
  String? newServiceImage;
  int? noOfParameters;
  String? organId;
  String? organImage;
  String? organName;
  String? permalink;
  String? permalinkNew;
  int? promoApplicable;
  String? sampleReport;
  String? serviceDesc;
  String? serviceId;
  String? serviceName;
  String? slotEndTime;
  String? slotId;
  String? slotStartTime;

  Services(
      {this.appOrganImage,
      this.isPackage,
      this.isYana,
      this.newServiceImage,
      this.noOfParameters,
      this.organId,
      this.organImage,
      this.organName,
      this.permalink,
      this.permalinkNew,
      this.promoApplicable,
      this.sampleReport,
      this.serviceDesc,
      this.serviceId,
      this.serviceName,
      this.slotEndTime,
      this.slotId,
      this.slotStartTime});

  Services.fromJson(Map<String, dynamic> json) {
    try {
      appOrganImage = ValueHandler().stringify(json['AppOrganImage']);
      isPackage = ValueHandler().intify(json['IsPackage']);
      isYana = ValueHandler().intify(json['IsYana']);
      newServiceImage = ValueHandler().stringify(json['NewServiceImage']);
      noOfParameters = ValueHandler().intify(json['NoOfParameters']);
      organId = ValueHandler().stringify(json['OrganId']);
      organImage = ValueHandler().stringify(json['OrganImage']);
      organName = ValueHandler().stringify(json['OrganName']);
      permalink = ValueHandler().stringify(json['Permalink']);
      permalinkNew = ValueHandler().stringify(json['PermalinkNew']);
      promoApplicable = ValueHandler().intify(json['PromoApplicable']);
      sampleReport = ValueHandler().stringify(json['SampleReport']);
      serviceDesc = ValueHandler().stringify(json['ServiceDesc']);
      serviceId = ValueHandler().stringify(json['ServiceId']);
      serviceName = ValueHandler().stringify(json['ServiceName']);
      slotEndTime = ValueHandler().stringify(json['SlotEndTime']);
      slotId = ValueHandler().stringify(json['SlotId']);
      slotStartTime = ValueHandler().stringify(json['SlotStartTime']);
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['AppOrganImage'] = appOrganImage;
    data['IsPackage'] = isPackage;
    data['IsYana'] = isYana;
    data['NewServiceImage'] = newServiceImage;
    data['NoOfParameters'] = noOfParameters;
    data['OrganId'] = organId;
    data['OrganImage'] = organImage;
    data['OrganName'] = organName;
    data['Permalink'] = permalink;
    data['PermalinkNew'] = permalinkNew;
    data['PromoApplicable'] = promoApplicable;
    data['SampleReport'] = sampleReport;
    data['ServiceDesc'] = serviceDesc;
    data['ServiceId'] = serviceId;
    data['ServiceName'] = serviceName;
    data['SlotEndTime'] = slotEndTime;
    data['SlotId'] = slotId;
    data['SlotStartTime'] = slotStartTime;
    return data;
  }
}
