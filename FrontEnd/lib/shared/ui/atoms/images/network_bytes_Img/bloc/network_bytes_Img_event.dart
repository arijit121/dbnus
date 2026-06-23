part of 'network_bytes_Img_bloc.dart';

@immutable
abstract class NetworkBytesImgEvent {}

class GetData extends NetworkBytesImgEvent {
  final String url;

  GetData({required this.url});
}
