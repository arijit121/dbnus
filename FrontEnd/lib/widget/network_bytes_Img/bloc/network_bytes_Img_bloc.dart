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
          Uint8List bytes = await apiRepo()
              .urlToByte(url: event.url, timeOut: const Duration(minutes: 5));
          emit(NetworkBytesImgState(bytes: bytes, isLoaded: true));
        } catch (e) {
          emit(NetworkBytesImgState(isLoaded: false, isError: true));
        }
      }
    });
  }
}
