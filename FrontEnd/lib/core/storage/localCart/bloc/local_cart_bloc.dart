import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:dbnus/core/models/dynamic_data.dart';
import 'package:dbnus/core/storage/localCart/model/cart_service_model.dart';
import 'package:dbnus/core/storage/localCart/repo/local_cart_repo.dart';

part 'local_cart_event.dart';
part 'local_cart_state.dart';

class LocalCartBloc extends Bloc<LocalCartEvent, LocalCartState> {
  LocalCartBloc()
      : super(LocalCartState(
          serviceList: DynamicBlocData<List<CartServiceModel>>.init(),
          totalPrice: DynamicBlocData<num>.init(),
        )) {
    on<LocalCartEvent>((event, emit) async {
      if (event is InItLocalCartEvent) {
        List<CartServiceModel> serviceList =
            await LocalCartRepo.instance.getStoreDataList();
        emit(state.copyWith(
            serviceList: DynamicBlocData<List<CartServiceModel>>.loading()));
        emit(state.copyWith(
            serviceList: DynamicBlocData<List<CartServiceModel>>.success(
                value: serviceList),
            totalPrice: serviceList.isNotEmpty
                ? DynamicBlocData<num>.success(
                    value: serviceList.fold<num>(0.0, (previousValue, element) {
                    return previousValue + (element.price ?? 0.0);
                  }))
                : null));
      } else if (event is AddServiceToCart) {
        List<CartServiceModel> serviceList =
            await LocalCartRepo.instance.getStoreDataList();
        if (serviceList
            .where(
                (element) => element.serviceId == event.serviceModel.serviceId)
            .isEmpty) {
          await LocalCartRepo.instance.addServiceToCart(event.serviceModel);

          add(InItLocalCartEvent());
        }
      } else if (event is RemoveServiceFromCart) {
        List<CartServiceModel> serviceList =
            await LocalCartRepo.instance.getStoreDataList();
        if (serviceList
            .where((element) => element.serviceId == event.serviceId)
            .isNotEmpty) {
          await LocalCartRepo.instance.removeServiceFromCart(event.serviceId);

          add(InItLocalCartEvent());
        }
      } else if (event is ClearCart) {
        await LocalCartRepo.instance.clearCart();
        add(InItLocalCartEvent());
      }
    });
  }
}
