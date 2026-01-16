import 'dart:convert';

import 'package:hive_ce/hive.dart';
// import 'package:localstore/localstore.dart';

import 'package:dbnus/core/models/service_model.dart';
import 'package:dbnus/core/extensions/logger_extension.dart';
import 'package:dbnus/core/storage/ss_hive.dart';
import 'package:dbnus/core/storage/localCart/model/cart_service_model.dart';

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
      final serviceBox = await collection?.openBox<CartServiceModel>(
        name,
        fromJson: (json) => CartServiceModel.fromJson(json),
      );
      Map<String, CartServiceModel>? value = await serviceBox?.getAllValues();

      if (value?.isNotEmpty == true) {
        value?.forEach((key, v) {
          resultList.add(v);
        });
      }

      return resultList;
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

      serviceModel?.packageServices?.forEach((element) {
        services.add(element);
      });
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }

    return services;
  }

  Future<void> addServiceToCart(CartServiceModel serviceModel) async {
    if (collection == null) {
      await _init();
    }
    final serviceBox = await collection?.openBox<CartServiceModel>(
      name,
      fromJson: (json) => CartServiceModel.fromJson(json),
    );
    await serviceBox?.put(serviceModel.serviceId ?? "", serviceModel);
  }

  Future<void> addServiceListToCart(
      List<CartServiceModel> serviceModelList) async {
    if (collection == null) {
      await _init();
    }
    final serviceBox = await collection?.openBox<CartServiceModel>(
      name,
      fromJson: (json) => CartServiceModel.fromJson(json),
    );

    // Speed up write actions with transactions
    await collection?.transaction(
      () async {
        for (var serviceModel in serviceModelList) {
          await serviceBox?.put(
            serviceModel.serviceId ?? "", // Use serviceId as the key
            serviceModel, // Serialize model to JSON
          );
        }
      },
      boxNames: [name],
      readOnly: false,
    );
  }

  Future<void> removeServiceFromCart(String serviceId) async {
    if (collection == null) {
      await _init();
    }
    final serviceBox = await collection?.openBox<CartServiceModel>(
      name,
      fromJson: (json) => CartServiceModel.fromJson(json),
    );
    await serviceBox?.delete(serviceId);
  }

  Future<void> clearCart() async {
    if (collection == null) {
      await _init();
    }
    final serviceBox = await collection?.openBox<CartServiceModel>(
      name,
      fromJson: (json) => CartServiceModel.fromJson(json),
    );
    await serviceBox?.clear();
  }
}
