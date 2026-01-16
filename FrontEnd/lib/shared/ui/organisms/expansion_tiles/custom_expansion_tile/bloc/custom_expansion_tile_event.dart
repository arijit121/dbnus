part of 'custom_expansion_tile_bloc.dart';

sealed class CustomExpansionTileEvent extends Equatable {
  const CustomExpansionTileEvent();

  @override
  List<Object> get props => [];
}

class ChangeExpanded extends CustomExpansionTileEvent {
  const ChangeExpanded({this.expanded});
  final bool? expanded;
}
