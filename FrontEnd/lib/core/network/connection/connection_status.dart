import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart'
    deferred as connectivity_plus;
import 'package:flutter/foundation.dart';

import '../../services/JsService/provider/js_provider.dart';

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
  static final ConnectionStatus _singleton = ConnectionStatus._internal();

  ConnectionStatus._internal();

  //This is what's used to retrieve the instance through the app
  static ConnectionStatus getInstance = _singleton;

  //This tracks the current connection status
  bool _hasConnection = false;

  //This is how we'll allow subscribing to connection changes
  final StreamController<bool> _connectionChangeController =
      StreamController.broadcast();

  Timer? _timerHandle;
  StreamSubscription? _connectivitySubscription;

  bool _isInitialized = false;
  bool _isDisposed = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    _isInitialized = true;
    await connectivity_plus.loadLibrary();
    _connectivitySubscription =
        connectivity_plus.Connectivity().onConnectivityChanged.listen((_) {
      _checkOnline();
    });

    _checkOnline();
  }

  Stream<bool> get connectionChange => _connectionChangeController.stream;

  //A clean up method to close our StreamController
  //   Because this is meant to exist through the entire application life cycle this isn't
  //   really an issue
  void dispose() {
    _isDisposed = true;

    _timerHandle?.cancel();
    _connectivitySubscription?.cancel();

    if (!_connectionChangeController.isClosed) {
      _connectionChangeController.close();
    }
  }

  Future<void> _checkOnline() async {
    if (_isDisposed) return;

    final bool previousConnection = _hasConnection;

    try {
      if (kIsWeb) {
        // Keeping your existing web behavior
        _hasConnection = JsProvider().isOnline();
      } else {
        final result = await InternetAddress.lookup('google.com');

        _hasConnection =
            result.isNotEmpty && result.first.rawAddress.isNotEmpty;
      }
    } on SocketException {
      _hasConnection = false;
    } catch (_) {
      _hasConnection = false;
    }

    if (previousConnection != _hasConnection &&
        !_connectionChangeController.isClosed) {
      _connectionChangeController.add(_hasConnection);
    }

    if (_hasConnection) {
      _timerHandle?.cancel();
      _timerHandle = null;
    }
  }

  Future<bool> checkConnection() async {
    await _checkOnline();

    if (!_hasConnection) {
      _startTimer();
    }

    return _hasConnection;
  }

  void _startTimer() {
    if (_timerHandle?.isActive ?? false) {
      return;
    }

    _timerHandle = Timer.periodic(
      const Duration(seconds: 10),
      (_) => _checkOnline(),
    );
  }

  Future<String> getNetworkInfo() async {
    await connectivity_plus.loadLibrary();
    final connectivity = connectivity_plus.Connectivity();
    final connectivityResult = await connectivity.checkConnectivity();
    return connectivityResult.first.name;
  }

  bool get hasConnection => _hasConnection;
}
