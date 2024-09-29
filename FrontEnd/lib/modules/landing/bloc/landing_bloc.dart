import 'package:bloc/bloc.dart';
import 'package:dbnus/extension/logger_extension.dart';
import 'package:equatable/equatable.dart';

import '../../../data/bloc_data_model/dynamic_data.dart';
import '../../../data/connection/connection_status.dart';
import '../model/landing_banner_response.dart';
import '../repo/landing_repo.dart';

part 'landing_event.dart';
part 'landing_state.dart';

class LandingBloc extends Bloc<LandingEvent, LandingState> {
  LandingBloc()
      : super(LandingState(
            bannerData: DynamicBlocData<LandingBannerResponse>.init(),
            pageIndex: DynamicBlocData.init())) {
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
                    message: "Something went wrong.")));
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
        emit(state.copyWith(
            pageIndex: DynamicBlocData<int>.success(value: event.index)));
      }
    });
  }

  @override
  Future<void> close() {
    AppLog.i("LandingBloc dispose");
    return super.close();
  }
}
