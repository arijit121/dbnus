part of 'network_image_bloc.dart';

@immutable
abstract class NetWorkImageEvent {}

class GetData extends NetWorkImageEvent {
  final String url;

  GetData({required this.url});
}
