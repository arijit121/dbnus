part of 'localization_bloc.dart';

class LocalizationState extends Equatable {
  final DynamicBlocData<Locale> locale;

  const LocalizationState({
    required this.locale,
  });

  factory LocalizationState.initial() {
    return LocalizationState(
        locale: DynamicBlocData.init(
            value: LocalizationUtils.supportedLocales.first));
  }

  LocalizationState copyWith({DynamicBlocData<Locale>? locale}) {
    return LocalizationState(
      locale: locale ?? this.locale,
    );
  }

  @override
  List<Object?> get props => [locale.status];
}
