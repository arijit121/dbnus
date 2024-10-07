import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../data/api_client/repo/api_repo.dart';

part 'network_image_event.dart';

part 'network_image_state.dart';

class NetWorkImageBloc extends Bloc<NetWorkImageEvent, NetWorkImageState> {
  NetWorkImageBloc() : super(NetWorkImageWebInitial()) {
    on<NetWorkImageEvent>((event, emit) async {
      if (event is GetData) {
        try {
          Uint8List bytes = await apiRepo()
              .urlToByte(url: event.url, timeOut: const Duration(minutes: 5));
          emit(NetWorkImageState(bytes: bytes, isLoaded: true));
        } catch (e) {
          emit(NetWorkImageState(isLoaded: false, isError: true));
        }
      }
    });
  }
}
