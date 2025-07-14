import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../service/value_handler.dart' deferred as value_handler;
import '../connection_status.dart';
import '../utils/connection_utils.dart' deferred as connection_utils;

part 'connection_event.dart';

part 'connection_state.dart';

class ConnectionBloc extends Bloc<ConnectionEvent, ConnectionState> {
  ConnectionBloc() : super(ConnectionInitial()) {
    ConnectionStatus connectionStatus = ConnectionStatus.getInstance;
    on<ConnectionEvent>((event, emit) async {
      if (event is InitConnection) {
        connectionStatus.connectionChange.listen((onlineStatus) {
          if (onlineStatus) {
            add(OnConnectionChange());
          }
        });
        add(OnConnectionChange());
      } else if (event is OnConnectionChange) {
        await Future.wait(
            [value_handler.loadLibrary(), connection_utils.loadLibrary()]);
        String? ipV4 = await connection_utils.ConnectionUtils().fetchWifiIpV4();
        if (value_handler.ValueHandler.isTextNotEmptyOrNull(ipV4)) {
          connection_utils.ConnectionUtils().setIpV4(ipV4 ?? '');
        }
        String? ipV6 = await connection_utils.ConnectionUtils().fetchWifiIpV6();
        if (value_handler.ValueHandler.isTextNotEmptyOrNull(ipV6)) {
          connection_utils.ConnectionUtils().setIpV6(ipV6 ?? '');
        }
      }
    });
  }
}
