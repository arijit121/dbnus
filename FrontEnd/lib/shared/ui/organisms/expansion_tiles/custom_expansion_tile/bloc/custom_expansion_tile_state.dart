part of 'custom_expansion_tile_bloc.dart';

class CustomExpansionTileState extends Equatable {
  final bool isExpanded;

  const CustomExpansionTileState({
    required this.isExpanded,
  });

  CustomExpansionTileState copyWith({bool? isExpanded}) {
    return CustomExpansionTileState(isExpanded: isExpanded ?? this.isExpanded);
  }

  @override
  List<Object> get props => [isExpanded];
}
