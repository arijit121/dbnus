import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' deferred as path_provider;

import '../service/value_handler.dart' deferred as value_handler;
import 'local_preferences.dart' deferred as local_preferences;

///How to use Hive Collection:-<br />
///<br />
///1.BoxCollection collection = [await SsHive.getHiveCollection()];<br />
///2.final box = [await collection?.openBox<Map>(name)];<br />
///<br />
///For get all value all values:-<br />
///<br />
/// [Map<String, Map>? value = await box?.getAllValues();]<br />
///<br />
///For add or update data:-<br />
///<br />
/// [await box?.put(key, data in Map);]<br />
///<br />
///Delete:-<br />
///<br />
/// particulate key [await box?.delete(keyId)], for delete whole box [await box?.clear()]<br />
class SsHive {
  static const String searchBoxKey = "SearchBox";
  static const String productBoxKey = "ProductBox";
  static const String serviceBoxKey = "ServiceBox";
  static const String _collectionName = "DbnusHiveBox";
  static const Set<String> _boxNames = {
    searchBoxKey,
    productBoxKey,
    serviceBoxKey
  };

  ///Get hive collection:-<br />
  ///<br />
  ///BoxCollection collection = [await SsHive.getHiveCollection()];<br />
  static Future<BoxCollection> getHiveCollection() async {
    List<int> key = await _getKey();
    String storePath;
    if (kIsWeb) {
      storePath = "./";
    } else {
      await path_provider.loadLibrary();
      storePath =
          "${(await path_provider.getApplicationDocumentsDirectory()).path}/hive_box";
    }
    BoxCollection collection = await BoxCollection.open(
      _collectionName,
      _boxNames,
      path: storePath,
      key: HiveAesCipher(key),
    );
    return collection;
  }

  static Future<List<int>> _getKey() async {
    await Future.wait(
        [local_preferences.loadLibrary(), value_handler.loadLibrary()]);
    final localPreferences = local_preferences.LocalPreferences();
    String? encryptionKey = await localPreferences.getString(
        key: local_preferences.LocalPreferences.hiveEncryptionKey);
    if (value_handler.ValueHandler().isTextNotEmptyOrNull(encryptionKey)) {
      var key = base64Url.decode(encryptionKey ?? "");
      return key;
    } else {
      var key = Hive.generateSecureKey();
      await localPreferences.setString(
          key: local_preferences.LocalPreferences.hiveEncryptionKey,
          value: base64UrlEncode(key));
      return key;
    }
  }
}
