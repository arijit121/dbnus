part of 'network_bytes_Img_bloc.dart';

class NetworkBytesImgState {
  Uint8List? bytes;
  bool isLoaded;
  bool? isError;

  NetworkBytesImgState({this.bytes, required this.isLoaded, this.isError});

  NetworkBytesImgState copyWith(
      {Uint8List? bytes, bool? isLoaded, bool? isError}) {
    return NetworkBytesImgState(
        bytes: bytes ?? this.bytes,
        isLoaded: isLoaded ?? this.isLoaded,
        isError: isError ?? this.isError);
  }
}

class NetWorkImageWebInitial extends NetworkBytesImgState {
  NetWorkImageWebInitial() : super(isLoaded: false);
}
