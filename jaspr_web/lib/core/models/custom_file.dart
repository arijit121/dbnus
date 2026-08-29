import 'dart:typed_data';

class CustomFile {
  String? name;
  Uint8List? bytes;
  String? path;

  CustomFile({this.name, this.bytes, this.path});

  CustomFile.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    bytes = json['bytes'] != null ? Uint8List.fromList(List<int>.from(json['bytes'])) : null;
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['bytes'] = bytes?.toList();
    data['path'] = path;
    return data;
  }
}
