import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../data/api_client/repo/api_repo.dart';

part 'network_bytes_Img_event.dart';

part 'network_bytes_Img_state.dart';

class NetworkBytesImgBloc
    extends Bloc<NetworkBytesImgEvent, NetworkBytesImgState> {
  NetworkBytesImgBloc() : super(NetWorkImageWebInitial()) {
    on<NetworkBytesImgEvent>((event, emit) async {
      if (event is GetData) {
        try {
          Uint8List? bytes = await ApiEngine.instance.urlToByte(uri: event.url);
          if (bytes == null) {
            emit(state.copyWith(bytes: bytes, isLoaded: true));
          } else {
            emit(state.copyWith(isLoaded: false, isError: true));
          }
        } catch (e) {
          emit(state.copyWith(isLoaded: false, isError: true));
        }
      }
    });
  }
}
