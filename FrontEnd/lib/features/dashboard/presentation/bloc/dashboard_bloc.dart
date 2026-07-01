import 'package:bloc/bloc.dart';
import 'package:dbnus/shared/extensions/logger_extension.dart';
import 'package:equatable/equatable.dart';

import 'package:dbnus/core/models/dynamic_data.dart';
import 'package:dbnus/core/network/connection/connection_status.dart';
import 'package:dbnus/features/dashboard/domain/entities/dashboard_data.dart';
import 'package:dbnus/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:dbnus/features/dashboard/domain/usecases/get_dashboard_data_usecase.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepository repository;

  DashboardBloc({required this.repository}) : super(DashboardState.initial()) {
    on<Init>(_init);
    on<GetDashboardData>(_getDashboardData);
    on<IncrementCounter>(_incrementCounter);
  }

  ConnectionStatus connectionStatus = ConnectionStatus.getInstance;

  void _init(Init event, Emitter<DashboardState> emit) async {
    // Initialization code if needed
  }

  void _getDashboardData(GetDashboardData event, Emitter<DashboardState> emit) async {
    bool onlineStatus = await connectionStatus.checkConnection();
    if (onlineStatus) {
      emit(state.copyWith(dashboardData: const DynamicBlocData.loading()));
      DashboardData? data = await GetDashboardDataUseCase(repository).call();
      if (data != null) {
        emit(state.copyWith(
          dashboardData: DynamicBlocData<DashboardData>.success(value: data),
        ));
      } else {
        emit(state.copyWith(
          dashboardData: const DynamicBlocData.error(message: "Something went wrong"),
        ));
      }
    } else {
      connectionStatus.connectionChange.listen((onlineStatus) {
        if (onlineStatus && state.dashboardData.status == Status.init) {
          add(GetDashboardData());
        }
      });
    }
  }

  void _incrementCounter(IncrementCounter event, Emitter<DashboardState> emit) {
    final currentValue = state.counter.value ?? 0;
    emit(state.copyWith(
      counter: DynamicBlocData<int>.success(value: currentValue + 1),
    ));
  }

  @override
  Future<void> close() {
    AppLog.i("DashboardBloc dispose");
    return super.close();
  }
}
