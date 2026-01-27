import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' deferred as http_parser;
import 'package:mime/mime.dart' deferred as mime;

import 'package:dbnus/shared/extensions/logger_extension.dart';
import 'package:dbnus/core/services/value_handler.dart';
import 'package:dbnus/core/network/models/api_return_model.dart';
import 'package:dbnus/core/network/api_client/repo/api_repo.dart';

class ApiRepoImp extends ApiRepo {
  @override
  Future<ApiReturnModel?> callApi(
      {required String tag,
      required String uri,
      required Method method,
      Map<String, dynamic>? queryParameters,
      Map<String, String>? headers,
      BodyData? bodyData}) async {
    try {
      Map<String, String> stringQueryParameters = <String, String>{};
      queryParameters?.forEach((key, value) {
        if (value != null) {
          stringQueryParameters[key] = value!.toString();
        }
      });
      Uri.parse(uri).queryParameters.forEach((key, value) {
        stringQueryParameters[key] = value.toString();
      });
      Uri url = stringQueryParameters.isNotEmpty
          ? Uri.parse(uri).replace(queryParameters: stringQueryParameters)
          : Uri.parse(uri);
      http.Request request = http.Request(method.value, url);
      http.MultipartRequest requestFormData =
          http.MultipartRequest(method.value, url);
      AppLog.i(tag: "$tag Method", method.value, time: DateTime.now());
      AppLog.i(tag: "$tag Url", "$url", time: DateTime.now());
      if (headers?.isNotEmpty == true) {
        AppLog.i(
            tag: "$tag Headers", json.encode(headers), time: DateTime.now());
      }
      if (bodyData?.bodyTypeStatus == BodyTypeStatus.raw) {
        BodyData<Map<String, dynamic>?> body =
            bodyData as BodyData<Map<String, dynamic>?>;
        if (body.value?.isNotEmpty == true) {
          request.body = json.encode(body.value);
          AppLog.i(
              tag: "$tag BodyData",
              json.encode(body.value),
              time: DateTime.now());
        }
      } else if (bodyData?.bodyTypeStatus == BodyTypeStatus.rawText) {
        BodyData<String> body = bodyData as BodyData<String>;
        if (body.value?.isNotEmpty == true) {
          request.body = body.value ?? "";
          AppLog.i(tag: "$tag BodyData", "${body.value}", time: DateTime.now());
        }
      } else if (bodyData?.bodyTypeStatus == BodyTypeStatus.formData) {
        BodyData<FormData?> body = bodyData as BodyData<FormData?>;
        if (body.value != null) {
          requestFormData.fields.addAll(body.value?.fields ?? {});
        }
        if (body.value?.customMultipartFiles?.isNotEmpty == true) {
          await Future.wait([http_parser.loadLibrary(), mime.loadLibrary()]);
          body.value?.customMultipartFiles?.forEach((element) async {
            if (kIsWeb) {
              Uint8List byte = element.bytes ?? Uint8List(0);
              requestFormData.files.add(http.MultipartFile.fromBytes(
                element.field ?? "",
                byte,
                filename: element.name,
                contentType: http_parser.MediaType.parse(
                  mime.lookupMimeType(element.name ?? "",
                          headerBytes: element.bytes) ??
                      "",
                ),
              ));
            } else {
              requestFormData.files.add(await http.MultipartFile.fromPath(
                element.field ?? "",
                element.path ?? "",
                contentType: http_parser.MediaType.parse(
                  mime.lookupMimeType(element.name ?? "",
                          headerBytes: element.bytes) ??
                      "",
                ),
              ));
            }
          });
        }
        AppLog.i(
            tag: "$tag BodyData",
            json.encode(((body.value) as FormData).toJson()),
            time: DateTime.now());
      }
      if (headers?.isNotEmpty == true) {
        (bodyData?.bodyTypeStatus == BodyTypeStatus.formData
                ? requestFormData
                : request)
            .headers
            .addAll(headers ?? {});
      }
      DateTime requestTime = DateTime.now();
      http.StreamedResponse response =
          await (bodyData?.bodyTypeStatus == BodyTypeStatus.formData
                  ? requestFormData
                  : request)
              .send()
              .timeout(timeout());
      if (response.statusCode == 200) {
        String responseReturn = await response.stream.bytesToString();
        AppLog.i(tag: "$tag Response", responseReturn, time: DateTime.now());
        AppLog.i(
            tag: "$tag Response time",
            "${DateTime.now().difference(requestTime)} HH:MM:SS ",
            time: DateTime.now());
        return ApiReturnModel(
            statusCode: response.statusCode, responseString: responseReturn);
      } else {
        String responseReturn = await response.stream.bytesToString();
        AppLog.i(
            tag: "$tag Response code",
            "${response.statusCode}",
            time: DateTime.now());
        AppLog.i(tag: "$tag Response", responseReturn, time: DateTime.now());
        return ApiReturnModel(
            statusCode: response.statusCode, responseString: responseReturn);
      }
    } catch (e, s) {
      AppLog.e(e, time: DateTime.now(), stackTrace: s);
    }
    return null;
  }

  @override
  Future<Uint8List?> urlToByte(
      {required String uri,
      Map<String, dynamic>? queryParameters,
      Map<String, String>? headers,
      required String tag}) async {
    try {
      Map<String, String> stringQueryParameters = <String, String>{};
      queryParameters?.forEach((key, value) {
        if (value != null) {
          stringQueryParameters[key] = value!.toString();
        }
      });
      Uri.parse(uri).queryParameters.forEach((key, value) {
        stringQueryParameters[key] = value.toString();
      });
      Uri url = stringQueryParameters.isNotEmpty
          ? Uri.parse(uri).replace(queryParameters: stringQueryParameters)
          : Uri.parse(uri);

      AppLog.i(tag: "$tag Url", url, time: DateTime.now());
      DateTime requestTime = DateTime.now();
      http.Response response =
          await http.get(url, headers: headers).timeout(timeout());
      if (response.statusCode == 200) {
        AppLog.i(
            tag: "$tag Response time",
            "${DateTime.now().difference(requestTime)} HH:MM:SS ",
            time: DateTime.now());
        return response.bodyBytes;
      } else {
        return null;
      }
    } catch (e, s) {
      AppLog.e(e, time: DateTime.now(), stackTrace: s);
      return null;
    }
  }

  @override
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
  }) async {
    try {
      Map<String, String> stringQueryParameters = <String, String>{};
      queryParameters?.forEach((key, value) {
        if (value != null) {
          stringQueryParameters[key] = value!.toString();
        }
      });
      Uri.parse(uri).queryParameters.forEach((key, value) {
        stringQueryParameters[key] = value.toString();
      });
      Uri url = stringQueryParameters.isNotEmpty
          ? Uri.parse(uri).replace(queryParameters: stringQueryParameters)
          : Uri.parse(uri);
      http.Request request = http.Request(method.value, url);
      http.MultipartRequest requestFormData =
          http.MultipartRequest(method.value, url);
      AppLog.i(tag: "$tag Method", method.value, time: DateTime.now());
      AppLog.i(tag: "$tag Url", "$url", time: DateTime.now());
      if (headers?.isNotEmpty == true) {
        AppLog.i(
            tag: "$tag Headers", json.encode(headers), time: DateTime.now());
      }
      if (bodyData?.bodyTypeStatus == BodyTypeStatus.raw) {
        BodyData<Map<String, dynamic>?> body =
            bodyData as BodyData<Map<String, dynamic>?>;
        if (body.value?.isNotEmpty == true) {
          request.body = json.encode(body.value);
          AppLog.i(
              tag: "$tag BodyData",
              json.encode(body.value),
              time: DateTime.now());
        }
      } else if (bodyData?.bodyTypeStatus == BodyTypeStatus.rawText) {
        BodyData<String> body = bodyData as BodyData<String>;
        if (body.value?.isNotEmpty == true) {
          request.body = body.value ?? "";
          AppLog.i(tag: "$tag BodyData", "${body.value}", time: DateTime.now());
        }
      } else if (bodyData?.bodyTypeStatus == BodyTypeStatus.formData) {
        BodyData<FormData?> body = bodyData as BodyData<FormData?>;
        if (body.value != null) {
          requestFormData.fields.addAll(body.value?.fields ?? {});
        }
        if (body.value?.customMultipartFiles?.isNotEmpty == true) {
          await Future.wait([http_parser.loadLibrary(), mime.loadLibrary()]);
          body.value?.customMultipartFiles?.forEach((element) async {
            if (kIsWeb) {
              Uint8List byte = element.bytes ?? Uint8List(0);
              requestFormData.files.add(http.MultipartFile.fromBytes(
                element.field ?? "",
                byte,
                filename: element.name,
                contentType: http_parser.MediaType.parse(
                  mime.lookupMimeType(element.name ?? "",
                          headerBytes: element.bytes) ??
                      "",
                ),
              ));
            } else {
              requestFormData.files.add(await http.MultipartFile.fromPath(
                element.field ?? "",
                element.path ?? "",
                contentType: http_parser.MediaType.parse(
                  mime.lookupMimeType(element.name ?? "",
                          headerBytes: element.bytes) ??
                      "",
                ),
              ));
            }
          });
        }
        AppLog.i(
            tag: "$tag BodyData",
            json.encode(((body.value) as FormData).toJson()),
            time: DateTime.now());
      }
      if (headers?.isNotEmpty == true) {
        (bodyData?.bodyTypeStatus == BodyTypeStatus.formData
                ? requestFormData
                : request)
            .headers
            .addAll(headers ?? {});
      }
      DateTime requestTime = DateTime.now();
      http.StreamedResponse response =
          await (bodyData?.bodyTypeStatus == BodyTypeStatus.formData
                  ? requestFormData
                  : request)
              .send()
              .timeout(timeout());
      String? event;
      StreamSubscription? streamSubscription;
      streamSubscription = response.stream
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .listen(
        (data) {
          AppLog.i(tag: "$tag Response", data, time: DateTime.now());
          AppLog.i(
              tag: "$tag Response time",
              "${DateTime.now().difference(requestTime)} HH:MM:SS ",
              time: DateTime.now());
          if (data.startsWith("data:")) {
            String value = data;
            value = value.replaceAll("data:", "");
            value = value.trim();
            Map<String, dynamic> body = {
              "event": event,
              "data": ValueHandler.canBeJsonDecoded(value)
                  ? json.decode(value)
                  : value,
            };
            body.removeWhere(
                (key, value) => !ValueHandler.isTextNotEmptyOrNull(value));
            onData?.call(
              ApiReturnModel(
                statusCode: response.statusCode,
                responseString: json.encode(body),
              ),
            );
            event = null;
          } else if (data.startsWith("event:")) {
            event = data;
            event = event?.replaceAll("event:", "");
            event = event?.trim();
          }
        },
        onError: (e, s) {
          AppLog.e(e, time: DateTime.now(), stackTrace: s);
          onError?.call(e, s);
        },
        onDone: onDone,
      );
      return streamSubscription;
    } catch (e, s) {
      AppLog.e(e, time: DateTime.now(), stackTrace: s);
      onError?.call(e, s);
    }
    return null;
  }
}

Duration timeout() => const Duration(minutes: 4);

enum Method {
  get('GET'),
  post('POST'),
  put('PUT'),
  patch('PATCH'),
  delete('DELETE'),
  head('HEAD'),
  options('OPTIONS'),
  trace('TRACE'),
  connect('CONNECT');

  final String value;

  const Method(this.value);
}

class BodyData<T> {
  BodyTypeStatus? bodyTypeStatus;
  T? value;

  BodyData({
    this.bodyTypeStatus,
    this.value,
  });

  static raw({Map<String, dynamic>? body}) {
    return BodyData<Map<String, dynamic>?>(
        bodyTypeStatus: BodyTypeStatus.raw, value: body);
  }

  static rawText({dynamic body}) {
    return BodyData<String>(
        bodyTypeStatus: BodyTypeStatus.rawText, value: '''${body ?? ""}''');
  }

  static formData(
      {Map<String, String>? fields,
      List<CustomMultipartFile>? customMultipartFiles}) {
    return BodyData<FormData?>(
        bodyTypeStatus: BodyTypeStatus.formData,
        value: fields != null || customMultipartFiles != null
            ? FormData(
                fields: fields, customMultipartFiles: customMultipartFiles)
            : null);
  }

  @override
  String toString() {
    return "Status : $bodyTypeStatus \n Data : $value";
  }
}

enum BodyTypeStatus {
  formData,
  raw,
  rawText,
}

class FormData {
  Map<String, String>? fields;
  List<CustomMultipartFile>? customMultipartFiles;

  FormData({this.fields, this.customMultipartFiles});

  FormData.fromJson(Map<String, dynamic> json) {
    fields = json['fields'];
    if (json['files'] != null) {
      customMultipartFiles = <CustomMultipartFile>[];
      json['files'].forEach((v) {
        customMultipartFiles?.add(CustomMultipartFile.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fields'] = fields;
    if (customMultipartFiles != null) {
      data['files'] = customMultipartFiles?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

/// Custom Multipart file class
///
/// With Api field
///
/// And File path
///
class CustomMultipartFile {
  String? field;
  String? path;
  String? name;
  Uint8List? bytes;

  CustomMultipartFile({
    this.field,
    this.path,
    this.name,
    this.bytes,
  });

  CustomMultipartFile.fromJson(Map<String, dynamic> json) {
    field = json['field'];
    path = json['path'];
    name = json['name'];
    bytes = json['bytes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['field'] = field;
    data['path'] = path;
    data['name'] = name;
    data['bytes'] = bytes;
    return data;
  }
}
