import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../service/value_handler.dart';
import 'local_preferences.dart';

class SsHive {
  static String searchBoxKey = "SearchBox";
  static String productBoxKey = "ProductBox";
  final String _collectionName = "SsHiveBox";
  final Set<String> _boxNames = {searchBoxKey, productBoxKey};

  Future<BoxCollection> getHiveCollection() async {
    List<int> key = await _getKey();
    String storePath =
        kIsWeb ? "./" : (await getApplicationDocumentsDirectory()).path;
    BoxCollection collection = await BoxCollection.open(
      _collectionName,
      _boxNames,
      path: storePath,
      key: HiveAesCipher(key),
    );
    return collection;
  }

  Future<List<int>> _getKey() async {
    String? encryptionKey = await LocalPreferences()
        .getString(key: LocalPreferences.hiveEncryptionKey);
    if (ValueHandler().isTextNotEmptyOrNull(encryptionKey)) {
      var key = base64Url.decode(encryptionKey ?? "");
      return key;
    } else {
      var key = Hive.generateSecureKey();
      await LocalPreferences().setString(
          key: LocalPreferences.hiveEncryptionKey, value: base64UrlEncode(key));
      return key;
    }
  }
}
