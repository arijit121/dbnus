part of 'localization_bloc.dart';

class LocalizationState extends Equatable {
  final DynamicBlocData<Locale> locale;

  const LocalizationState({
    required this.locale,
  });

  LocalizationState copyWith({DynamicBlocData<Locale>? locale}) {
    return LocalizationState(
      locale: locale ?? this.locale,
    );
  }

  @override
  List<Object?> get props => [locale.status];
}
