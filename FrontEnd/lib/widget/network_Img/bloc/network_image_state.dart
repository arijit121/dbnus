part of 'network_image_bloc.dart';

class NetWorkImageState {
  Uint8List? bytes;
  bool isLoaded;
  bool? isError;

  NetWorkImageState({this.bytes, required this.isLoaded, this.isError});
}

class NetWorkImageWebInitial extends NetWorkImageState {
  NetWorkImageWebInitial() : super(isLoaded: false);
}
