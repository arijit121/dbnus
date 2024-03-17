import '../../../extension/logger_extension.dart';

class CartServiceModel {
  String? serviceId;
  num? price;
  List<CartPackageService>? listOfPackageService;

  CartServiceModel({this.serviceId, this.price, this.listOfPackageService});

  CartServiceModel.fromJson(Map<String, dynamic> json) {
    try {
      serviceId = json['ServiceId'];
      price = json['price'];
      if (json['PackageServices'] != null) {
        listOfPackageService = <CartPackageService>[];
        json['PackageServices'].forEach((v) {
          listOfPackageService?.add(CartPackageService.fromJson(v));
        });
      }
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ServiceId'] = serviceId;
    data['price'] = price;
    data['PackageServices'] =
        listOfPackageService?.map((e) => e.toJson()).toList();
    return data;
  }
}

class CartPackageService {
  String? serviceId;

  CartPackageService({this.serviceId});

  CartPackageService.fromJson(Map<String, dynamic> json) {
    try {
      serviceId = json['ServiceId'];
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ServiceId'] = serviceId;

    return data;
  }
}
