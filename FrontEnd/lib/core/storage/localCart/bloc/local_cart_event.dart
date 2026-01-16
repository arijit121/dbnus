part of 'local_cart_bloc.dart';

sealed class LocalCartEvent extends Equatable {
  const LocalCartEvent();
  @override
  List<Object?> get props => [];
}

class InItLocalCartEvent extends LocalCartEvent {}

class AddServiceToCart extends LocalCartEvent {
  const AddServiceToCart({required this.serviceModel});
  final CartServiceModel serviceModel;
}

class RemoveServiceFromCart extends LocalCartEvent {
  const RemoveServiceFromCart({required this.serviceId});
  final String serviceId;
}

class ClearCart extends LocalCartEvent {}
