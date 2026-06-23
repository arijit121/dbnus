part of 'connection_bloc.dart';

sealed class ConnectionEvent extends Equatable {
  const ConnectionEvent();
  @override
  List<Object> get props => [];
}

class InitConnection extends ConnectionEvent {}

class OnConnectionChange extends ConnectionEvent {}
