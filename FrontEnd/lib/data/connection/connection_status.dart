import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart'
    deferred as connectivity_plus;
import 'package:flutter/foundation.dart';

///ConnectionStatus connectionStatus = ConnectionStatus.getInstance;
///
/// Check ConnectionStatus
///bool onlineStatus = await connectionStatus.checkConnection();
///
///On status change
/// connectionStatus.connectionChange.listen((onlineStatus) {
///             Perform task
///             });
///
class ConnectionStatus {
  //This creates the single instance by calling the `_internal` constructor specified below
  static final ConnectionStatus _singleton = ConnectionStatus._internal()
    ..initialize();

  ConnectionStatus._internal();

  //This is what's used to retrieve the instance through the app
  static ConnectionStatus getInstance = _singleton;

  //This tracks the current connection status
  bool _hasConnection = false;

  //This is how we'll allow subscribing to connection changes
  final StreamController<bool> _connectionChangeController =
      StreamController.broadcast();

  //flutter_connectivity
  // final _connectivity = connectivity_plus.Connectivity();

  //Hook into flutter_connectivity's Stream to listen for changes
  //And check the connection status out of the gate
  Future<void> initialize() async {
    await connectivity_plus.loadLibrary();
    final connectivity = connectivity_plus.Connectivity();
    connectivity.onConnectivityChanged.listen((result) {
      _connectionChange();
    });
    checkConnection();
  }

  Stream<bool> get connectionChange => _connectionChangeController.stream;

  //A clean up method to close our StreamController
  //   Because this is meant to exist through the entire application life cycle this isn't
  //   really an issue
  void dispose() {
    _connectionChangeController.close();
  }

  //flutter_connectivity's listener
  void _connectionChange() {
    checkConnection();
  }

  //The test to actually see if there is a connection
  Future<bool> checkConnection() async {
    bool previousConnection = _hasConnection;

    try {
      if (kIsWeb) {
        _hasConnection = true;
      } else {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          _hasConnection = true;
        } else {
          _hasConnection = false;
        }
      }
    } on SocketException catch (_) {
      _hasConnection = false;
    }

    //The connection status changed send out an update to all listeners
    if (previousConnection != _hasConnection) {
      _connectionChangeController.add(_hasConnection);
    }

    return _hasConnection;
  }

  Future<String> getNetworkInfo() async {
    await connectivity_plus.loadLibrary();
    final connectivity = connectivity_plus.Connectivity();
    final connectivityResult = await connectivity.checkConnectivity();
    return connectivityResult.first.name;
  }
}
