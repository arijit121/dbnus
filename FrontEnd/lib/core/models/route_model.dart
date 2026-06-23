class RouteModel {
  String? name;
  String? path;
  Uri uri;
  Map<String, String> pathParameters = const <String, String>{};
  Map<String, dynamic> queryParameters = const <String, dynamic>{};
  Object? extra;

  RouteModel({
    required this.name,
    required this.uri,
    this.path,
    this.pathParameters = const <String, String>{},
    this.queryParameters = const <String, dynamic>{},
    this.extra,
  });
}

