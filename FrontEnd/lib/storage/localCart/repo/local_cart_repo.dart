import 'package:genu/extension/logger_extension.dart';
import 'package:localstore/localstore.dart';

import '../../../data/model/service_model.dart';
import '../model/cart_service_model.dart';

class LocalCartRepo {
  String path = "servicePath";

  bool checkIfServiceContainInCart(
      {required List<CartServiceModel> allServiceList,
      required String serviceId}) {
    try {
      return allServiceList
          .where((element) => element.serviceId == serviceId)
          .isNotEmpty;
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
      return false;
    }
  }

  bool checkIfPackageServiceContainInCart(
      {required List<CartServiceModel> allServiceList,
      ServiceModel? serviceModel}) {
    try {
      if (allServiceList.isNotEmpty == true) {
        List<Services> associatedService =
            getAssociatedService(serviceModel: serviceModel);
        if (associatedService.isNotEmpty == true) {
          List<String> allPackageServiceIds = [];
          List<String> packageServiceIds = associatedService.map((e) {
            return e.serviceId ?? "";
          }).toList();
          for (var element in allServiceList) {
            allPackageServiceIds.addAll(
                element.listOfPackageService?.map((e) => e.serviceId ?? '') ??
                    []);
            allPackageServiceIds.add(element.serviceId ?? "");
          }

          if (packageServiceIds
              .any((item) => allPackageServiceIds.contains(item))) {
            return true;
          } else {
            return false;
          }
        } else {
          List<String> allPackageServiceIds = [];

          for (var element in allServiceList) {
            allPackageServiceIds.addAll(
                element.listOfPackageService?.map((e) => e.serviceId ?? '') ??
                    []);
            allPackageServiceIds.add(element.serviceId ?? "");
          }

          if (allPackageServiceIds.contains(serviceModel?.serviceId)) {
            return true;
          } else {
            return false;
          }
        }
      }

      return false;
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
      return false;
    }
  }

  Future<List<CartServiceModel>> getStoreDataList() async {
    try {
      final db = Localstore.instance;
      Iterable<MapEntry<String, dynamic>>? json =
          (await db.collection(path).get())?.entries;
      List<CartServiceModel> serviceList = <CartServiceModel>[];
      if (json?.isNotEmpty == true) {
        json?.forEach((v) {
          serviceList
              .add(CartServiceModel.fromJson(v.value as Map<String, dynamic>));
        });
      }
      return serviceList;
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
      return [];
    }
  }

  List<Services> getAssociatedService({ServiceModel? serviceModel}) {
    List<Services> services = [];
    try {
      serviceModel?.services?.forEach((element) {
        services.add(element);
      });
      // if (serviceModel?.services?.isNotEmpty == true) {
      //   services.addAll(serviceModel?.services?.iterator as Iterable<Services>);
      // }
      serviceModel?.packageServices?.forEach((element) {
        services.add(element);
      });

      // if (serviceModel?.packageServices?.isNotEmpty == true) {
      //   services.addAll(
      //       serviceModel?.packageServices?.iterator as Iterable<Services>);
      // }
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }

    return services;
  }

  Future<void> addServiceToCart(CartServiceModel serviceModel) async {
    final db = Localstore.instance;
    await db
        .collection(path)
        .doc(serviceModel.serviceId)
        .set(serviceModel.toJson());
  }

  Future<void> removeServiceFromCart(String serviceId) async {
    final db = Localstore.instance;
    await db.collection(path).doc(serviceId).delete();
  }

  Future<void> clearCart() async {
    final db = Localstore.instance;
    await db.collection(path).delete();
  }
}
