part of 'local_cart_bloc.dart';
//ignore: must_be_immutable
class LocalCartState extends Equatable {
  DynamicBlocData<List<CartServiceModel>> serviceList;
  DynamicBlocData<num> totalPrice;

  LocalCartState({
    required this.serviceList,
    required this.totalPrice,
  });

  LocalCartState copyWith({
    DynamicBlocData<List<CartServiceModel>>? serviceList,
    DynamicBlocData<num>? totalPrice,
  }) {
    return LocalCartState(
      serviceList: serviceList ?? this.serviceList,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }

  @override
  List<Object> get props => [
        serviceList.status,
        totalPrice.status,
      ];
}
