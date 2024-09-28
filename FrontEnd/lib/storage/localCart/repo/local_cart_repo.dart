import 'dart:convert';

import 'package:hive/hive.dart';

// import 'package:localstore/localstore.dart';

import '../../../data/model/service_model.dart';
import '../../../extension/logger_extension.dart';
import '../../ss_hive.dart';
import '../model/cart_service_model.dart';

class LocalCartRepo {
  LocalCartRepo._();

  static final instance = LocalCartRepo._().._init();

  String name = SsHive.serviceBoxKey;
  BoxCollection? collection;

  Future<void> _init() async {
    collection = await SsHive.getHiveCollection();
  }

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
      List<CartServiceModel> resultList = [];
      if (collection == null) {
        await _init();
      }
      final productBox = await collection?.openBox<Map>(name);
      Map<String, Map>? value = await productBox?.getAllValues();

      if (value?.isNotEmpty == true) {
        value?.forEach((key, v) {
          String value = json.encode(v);
          resultList.add(CartServiceModel.fromJson(json.decode(value)));
        });
      }

      return resultList;
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
      return [];
    }
    // try {
    //   final db = Localstore.instance;
    //   Iterable<MapEntry<String, dynamic>>? json =
    //       (await db.collection(path).get())?.entries;
    //   List<CartServiceModel> serviceList = <CartServiceModel>[];
    //   if (json?.isNotEmpty == true) {
    //     json?.forEach((v) {
    //       serviceList
    //           .add(CartServiceModel.fromJson(v.value as Map<String, dynamic>));
    //     });
    //   }
    //   return serviceList;
    // } catch (e, stacktrace) {
    //   AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    //   return [];
    // }
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
    if (collection == null) {
      await _init();
    }
    final productBox = await collection?.openBox<Map>(name);
    await productBox?.put(serviceModel.serviceId ?? "",
        json.decode(json.encode(serviceModel.toJson()).toString()));
  }

  Future<void> removeServiceFromCart(String serviceId) async {
    if (collection == null) {
      await _init();
    }
    final productBox = await collection?.openBox<Map>(name);
    await productBox?.delete(serviceId);
  }

  Future<void> clearCart() async {
    if (collection == null) {
      await _init();
    }
    final productBox = await collection?.openBox<Map>(name);
    await productBox?.clear();
  }
}
