import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../../../extension/logger_extension.dart';
import '../../model/api_return_model.dart';
import '../repo/api_repo.dart';

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

      Uri url = stringQueryParameters.isNotEmpty
          ? Uri.parse(uri).replace(queryParameters: stringQueryParameters)
          : Uri.parse(uri);
      Request request = http.Request(method.name, url);
      MultipartRequest requestFormData =
          http.MultipartRequest(method.name, url);
      AppLog.i(tag: "$tag Method", method.name, time: DateTime.now());
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
          body.value?.customMultipartFiles?.forEach((element) async {
            if (kIsWeb) {
              Uint8List byte = element.bytes ?? Uint8List(0);
              requestFormData.files.add(http.MultipartFile.fromBytes(
                  element.field ?? "", byte,
                  filename: element.name));
            } else {
              requestFormData.files.add(await http.MultipartFile.fromPath(
                  element.field ?? "", element.path ?? ""));
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
    } catch (e) {
      AppLog.e(e, time: DateTime.now());
    }
    return null;
  }

  @override
  Future<Uint8List> urlToByte({required String url, Duration? timeOut}) async {
    http.Response response = await http
        .get(
          Uri.parse(url),
        )
        .timeout(timeOut ?? timeout());
    return response.bodyBytes;
  }
}

Duration timeout() => const Duration(minutes: 4);

enum Method {
  get('GET'),
  post('POST');

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

  static rawText({Map<String, dynamic>? body}) {
    return BodyData<String>(
        bodyTypeStatus: BodyTypeStatus.rawText, value: '''${body ?? ""}''');
  }

  static formData({FormData? formData}) {
    return BodyData<FormData?>(
        bodyTypeStatus: BodyTypeStatus.formData, value: formData);
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
