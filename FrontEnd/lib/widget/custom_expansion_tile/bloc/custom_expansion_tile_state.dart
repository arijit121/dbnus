part of 'custom_expansion_tile_bloc.dart';

// ignore: must_be_immutable
class CustomExpansionTileState extends Equatable {
  bool isExpanded;

  CustomExpansionTileState({
    required this.isExpanded,
  });

  CustomExpansionTileState copyWith({bool? isExpanded}) {
    return CustomExpansionTileState(isExpanded: isExpanded ?? this.isExpanded);
  }

  @override
  List<Object> get props => [isExpanded];
}
