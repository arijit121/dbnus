part of 'localization_bloc.dart';

sealed class LocalizationEvent extends Equatable {
  const LocalizationEvent();

  @override
  List<Object> get props => [];
}

class InitLocalization extends LocalizationEvent {}

class ChangeLanguage extends LocalizationEvent {
  final Locale locale;
  const ChangeLanguage({required this.locale});
}
