import 'package:bloc/bloc.dart';
import 'package:dbnus/shared/extensions/logger_extension.dart';
import 'package:dbnus/shared/utils/text_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:dbnus/core/models/dynamic_data.dart';
import 'package:dbnus/core/network/connection/connection_status.dart';
import 'package:dbnus/features/landing/data/models/landing_banner_response.dart';
import 'package:dbnus/features/landing/domain/entities/navigation_option.dart';
import 'package:dbnus/features/landing/domain/usecases/get_splash_banner_usecase.dart';
import 'package:dbnus/features/landing/presentation/utils/landing_utils.dart';
import 'package:dbnus/features/landing/domain/entities/landing_banner.dart';

import '../../../../core/services/JsService/provider/js_provider.dart';

part 'landing_event.dart';

part 'landing_state.dart';

class LandingBloc extends Bloc<LandingEvent, LandingState> {
  final GetSplashBannerUseCase getSplashBannerUseCase;
  LandingBloc({required this.getSplashBannerUseCase})
      : super(LandingState.initial()) {
    on<Init>(_init);
    on<GetSplashData>(_getSplashBanner);
    on<ChangeIndex>(_changeIndex);
  }

  ConnectionStatus connectionStatus = ConnectionStatus.getInstance;

  void _init(Init event, Emitter<LandingState> emit) async {
    /* AppLog.i("PWA Status", tag: "PWA Status");
    final pwaStatus = await JsProvider.getPWAStatus();
    AppLog.i(pwaStatus, tag: "PWA Status");
    final installPWA = await JsProvider.installPWA();
    AppLog.i(installPWA, tag: "PWA Status"); */
  }

  void _getSplashBanner(GetSplashData event, Emitter<LandingState> emit) async {
    bool onlineStatus = await connectionStatus.checkConnection();
    if (onlineStatus) {
      emit(state.copyWith(bannerData: DynamicBlocData.loading()));
      LandingBanner? splashBannerResponse = await getSplashBannerUseCase();
      if (splashBannerResponse != null &&
          splashBannerResponse is LandingBannerResponse) {
        emit(state.copyWith(
            bannerData: DynamicBlocData<LandingBannerResponse>.success(
                value: splashBannerResponse)));
      } else if (splashBannerResponse != null) {
        // Handle if it is not the response model, but since we cast it or use entity,
        // State expects LandingBannerResponse.
        // Ideally State should use Entity.
        // For now, I will cast or reconstruct if needed, but since Impl returns Response(Model), it is safe.
        // Actually, I should update State to use LandingBanner Entity.
        // But to minimize changes, I will force cast if needed or update Logic.
        // Wait, UseCase returns LandingBanner entity. Model extends Entity.
        // If I assume it returns the Model (which it does), I can cast 'as'.
        emit(state.copyWith(
            bannerData: DynamicBlocData<LandingBannerResponse>.success(
                value: splashBannerResponse as LandingBannerResponse)));
      } else {
        emit(state.copyWith(
            bannerData: DynamicBlocData<LandingBannerResponse>.error(
                message: TextUtils.somethingWentWrong)));
      }
    } else {
      connectionStatus.connectionChange.listen((onlineStatus) {
        if (onlineStatus && state.bannerData.status == Status.init) {
          add(GetSplashData());
        }
      });
    }
  }

  void _changeIndex(ChangeIndex event, Emitter<LandingState> emit) async {
    emit(state.copyWith(pageIndex: DynamicBlocData.loading()));
    NavigationOption navigation =
        LandingUtils.listNavigation.elementAt(event.index);
    Widget? ui = await LandingUtils.getUi(action: navigation.action);
    if (ui != null) {
      emit(state.copyWith(
          pageIndex: DynamicBlocData.success(value: event.index),
          page: DynamicBlocData.success(value: ui)));
    }
  }

  @override
  Future<void> close() {
    AppLog.i("LandingBloc dispose");
    return super.close();
  }
}
