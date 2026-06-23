import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'custom_expansion_tile_event.dart';
part 'custom_expansion_tile_state.dart';

class CustomExpansionTileBloc
    extends Bloc<CustomExpansionTileEvent, CustomExpansionTileState> {
  CustomExpansionTileBloc()
      : super(CustomExpansionTileState(isExpanded: false)) {
    on<CustomExpansionTileEvent>((event, emit) {
      if (event is ChangeExpanded) {
        if (event.expanded != null) {
          emit(state.copyWith(isExpanded: event.expanded));
        }
      }
    });
  }
}
