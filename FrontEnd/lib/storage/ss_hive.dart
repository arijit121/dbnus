import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../service/value_handler.dart';
import 'local_preferences.dart';

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
  static const String _collectionName = "SsHiveBox";
  static const Set<String> _boxNames = {searchBoxKey, productBoxKey};

  ///Get hive collection:-<br />
  ///<br />
  ///BoxCollection collection = [await SsHive.getHiveCollection()];<br />
  static Future<BoxCollection> getHiveCollection() async {
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

  static Future<List<int>> _getKey() async {
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
