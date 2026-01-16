// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'package:dbnus/core/services/Localization/app_localizations/app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get hello_world => '¡Hola Mundo!';

  @override
  String get profile => 'Perfil';

  @override
  String get edit_profile => 'Editar Perfil';

  @override
  String get completed_topics => 'Temas Completados';

  @override
  String get completed_lessons => 'Lecciones Completadas';

  @override
  String get completed_quiz => 'Cuestionario Completado';

  @override
  String get completed_games => 'Juegos Completados';

  @override
  String get change_language => 'Cambiar Idioma';

  @override
  String get logout => 'Cerrar Sesión';

  @override
  String get logout_confirmation =>
      '¿Estás seguro de que quieres cerrar sesión?';

  @override
  String get serial_number => 'N°';

  @override
  String get title => 'Título';

  @override
  String get completed_at => 'Completado En';

  @override
  String get name => 'Nombre';

  @override
  String get email => 'Correo Electrónico';

  @override
  String get phone_number => 'Número de Teléfono';

  @override
  String get submit => 'Enviar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get ok => 'OK';

  @override
  String cannot_be_blank(String field) {
    return '$field no puede estar vacío.';
  }

  @override
  String length_greater_than(String field, int minLength) {
    return '$field debe tener al menos $minLength caracteres.';
  }

  @override
  String enter_valid_msg(String field) {
    return 'Ingresa un $field válido.';
  }

  @override
  String get enter_valid_date => 'Ingresa una fecha válida';

  @override
  String get date_cannot_be_blank => 'La fecha no puede estar vacía';

  @override
  String get email_validator => 'Ingresa un correo electrónico válido.';

  @override
  String get phone_validation =>
      'Ingresa un número de móvil válido (10 dígitos).';

  @override
  String enter_value(String value) {
    return 'Ingresa $value.';
  }

  @override
  String get otp => 'Otp';
}
