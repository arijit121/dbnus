import 'dart:typed_data';

import '../../model/api_return_model.dart';
import '../imp/api_repo_imp.dart';

abstract class ApiRepo {
  Future<ApiReturnModel?> callApi(
      {required String tag,
      required String uri,
      required Method method,
      Map<String, dynamic>? queryParameters,
      Map<String, String>? headers,
      BodyData? bodyData});

  Future<Uint8List> urlToByte({required String url, Duration? timeOut});
}

ApiRepo apiRepo() => ApiRepoImp();
