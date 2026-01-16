part of 'connection_bloc.dart';

sealed class ConnectionState extends Equatable {
  const ConnectionState();
}

final class ConnectionInitial extends ConnectionState {
  @override
  List<Object> get props => [];
}
