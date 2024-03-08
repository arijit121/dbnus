part of 'local_cart_bloc.dart';

abstract class LocalCartEvent extends Equatable {
  const LocalCartEvent();
}

class InItLocalCartEvent extends LocalCartEvent {
  @override
  List<Object?> get props => [];
}
//ignore: must_be_immutable
class AddServiceToCart extends LocalCartEvent {
  AddServiceToCart({required this.serviceModel});

  CartServiceModel serviceModel;

  @override
  List<Object?> get props => [];
}
//ignore: must_be_immutable
class RemoveServiceFromCart extends LocalCartEvent {
  RemoveServiceFromCart({required this.serviceId});

  String serviceId;

  @override
  List<Object?> get props => [];
}

class ClearCart extends LocalCartEvent {
  @override
  List<Object?> get props => [];
}
