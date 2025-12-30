import 'dart:async';
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

  Future<Uint8List?> urlToByte(
      {required String uri,
      Map<String, dynamic>? queryParameters,
      Map<String, String>? headers,
      required String tag});

  Future<StreamSubscription?> callSse({
    required String tag,
    required String uri,
    required Method method,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    BodyData? bodyData,
    required void Function(ApiReturnModel)? onData,
    void Function()? onDone,
    void Function(Object, StackTrace)? onError,
  });
}

class ApiEngine {
  static ApiRepo _apiRepo() => ApiRepoImp();
  static final ApiRepo instance = _apiRepo();
}
