part of 'custom_expansion_tile_bloc.dart';

sealed class CustomExpansionTileEvent extends Equatable {
  const CustomExpansionTileEvent();

  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
class ChangeExpanded extends CustomExpansionTileEvent {
  ChangeExpanded({this.expanded});
  bool? expanded;
}
