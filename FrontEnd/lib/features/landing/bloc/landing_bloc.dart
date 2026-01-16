import 'package:bloc/bloc.dart';
import 'package:dbnus/core/extensions/logger_extension.dart';
import 'package:dbnus/core/utils/text_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:dbnus/core/models/dynamic_data.dart';
import 'package:dbnus/core/network/connection/connection_status.dart';
import 'package:dbnus/features/landing/model/landing_banner_response.dart';
import 'package:dbnus/features/landing/model/navigation_model.dart';
import 'package:dbnus/features/landing/repo/landing_repo.dart';
import 'package:dbnus/features/landing/utils/landing_utils.dart';

part 'landing_event.dart';

part 'landing_state.dart';

class LandingBloc extends Bloc<LandingEvent, LandingState> {
  LandingBloc() : super(LandingState.initial()) {
    ConnectionStatus connectionStatus = ConnectionStatus.getInstance;
    on<LandingEvent>((event, emit) async {
      if (event is InitiateSplash) {
        bool onlineStatus = await connectionStatus.checkConnection();
        if (onlineStatus) {
          emit(state.copyWith(bannerData: DynamicBlocData.loading()));
          LandingBannerResponse? splashBannerResponse =
              await LandingRepo().getSplashBanner();
          if (splashBannerResponse != null) {
            emit(state.copyWith(
                bannerData: DynamicBlocData<LandingBannerResponse>.success(
                    value: splashBannerResponse)));
          } else {
            emit(state.copyWith(
                bannerData: DynamicBlocData<LandingBannerResponse>.error(
                    message: TextUtils.somethingWentWrong)));
          }
        } else {
          connectionStatus.connectionChange.listen((onlineStatus) {
            if (onlineStatus && state.bannerData.status == Status.init) {
              add(InitiateSplash());
            }
          });
        }
      } else if (event is ChangeIndex) {
        emit(state.copyWith(pageIndex: DynamicBlocData.loading()));
        NavigationModel navigation =
            LandingUtils.listNavigation.elementAt(event.index);
        Widget ui = await LandingUtils().getUi(action: navigation.action);
        emit(state.copyWith(
            pageIndex: DynamicBlocData.success(value: event.index),
            page: DynamicBlocData.success(value: ui)));
      }
    });
  }

  @override
  Future<void> close() {
    AppLog.i("LandingBloc dispose");
    return super.close();
  }
}
