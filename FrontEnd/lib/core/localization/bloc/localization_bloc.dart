import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:dbnus/core/models/dynamic_data.dart';
import 'package:dbnus/core/services/localization/utils/localization_utils.dart';

part 'localization_event.dart';

part 'localization_state.dart';

class LocalizationBloc extends Bloc<LocalizationEvent, LocalizationState> {
  LocalizationBloc() : super(LocalizationState.initial()) {
    on<LocalizationEvent>((event, emit) async {
      if (event is InitLocalization) {
        Locale? local = await LocalizationUtils.getFromStore();
        if (local != null) {
          emit(state.copyWith(locale: DynamicBlocData.init(value: local)));
          emit(state.copyWith(locale: DynamicBlocData.success(value: local)));
        } else if (state.locale.value != null) {
          await LocalizationUtils.store(local: state.locale.value!);
        }
      } else if (event is ChangeLanguage) {
        emit(state.copyWith(locale: DynamicBlocData.loading()));
        final supportedLocale = LocalizationUtils.supportedLocales.firstWhere(
            (locale) => locale.toLanguageTag() == event.locale.toLanguageTag(),
            orElse: () => Locale(''));

        if (supportedLocale.languageCode.isNotEmpty) {
          emit(state.copyWith(
              locale: DynamicBlocData.success(value: event.locale)));
          await LocalizationUtils.store(local: event.locale);
        } else {
          emit(state.copyWith(
              locale: DynamicBlocData.error(error: "Unsupported locale")));
        }
      }
    });
  }
}
