// dart format off
// ignore_for_file: type=lint

// GENERATED FILE, DO NOT MODIFY
// Generated with jaspr_builder

import 'package:jaspr/server.dart';
import 'package:jaspr_app/shared/constants/theme.dart' as _theme;
import 'package:jaspr_app/shared/ui/atoms/custom_button.dart' as _custom_button;
import 'package:jaspr_app/shared/ui/atoms/custom_divider.dart'
    as _custom_divider;
import 'package:jaspr_app/shared/ui/atoms/custom_image.dart' as _custom_image;
import 'package:jaspr_app/shared/ui/atoms/custom_input.dart' as _custom_input;
import 'package:jaspr_app/shared/ui/atoms/custom_text.dart' as _custom_text;
import 'package:jaspr_app/shared/ui/molecules/coming_soon_page.dart'
    as _coming_soon_page;
import 'package:jaspr_app/shared/ui/molecules/error_page.dart' as _error_page;
import 'package:jaspr_app/shared/ui/molecules/error_widget.dart'
    as _error_widget;
import 'package:jaspr_app/shared/ui/molecules/init_widget.dart' as _init_widget;
import 'package:jaspr_app/shared/ui/molecules/loading_widget.dart'
    as _loading_widget;
import 'package:jaspr_app/shared/ui/organisms/app_bar.dart' as _app_bar;
import 'package:jaspr_app/shared/ui/organisms/app_shell.dart' as _app_shell;
import 'package:jaspr_app/shared/ui/organisms/column.dart' as _column;
import 'package:jaspr_app/shared/ui/organisms/grid_view.dart' as _grid_view;
import 'package:jaspr_app/shared/ui/organisms/list_view.dart' as _list_view;
import 'package:jaspr_app/shared/ui/organisms/navigation_rail.dart'
    as _navigation_rail;
import 'package:jaspr_app/shared/ui/organisms/row.dart' as _row;
import 'package:jaspr_app/app.dart' as _app;

/// Default [ServerOptions] for use with your Jaspr project.
///
/// Use this to initialize Jaspr **before** calling [runApp].
///
/// Example:
/// ```dart
/// import 'main.server.options.dart';
///
/// void main() {
///   Jaspr.initializeApp(
///     options: defaultServerOptions,
///   );
///
///   runApp(...);
/// }
/// ```
ServerOptions get defaultServerOptions => ServerOptions(
  clientId: 'main.client.dart.js',
  clients: {_app.App: ClientTarget<_app.App>('app')},
  styles: () => [
    ..._theme.styles,
    ..._app.App.styles,
    ..._custom_button.CustomCheckbox.styles,
    ..._custom_button.CustomGOEButton.styles,
    ..._custom_button.CustomIconButton.styles,
    ..._custom_button.CustomRadioButton.styles,
    ..._custom_button.CustomTextButton.styles,
    ..._custom_button.CustomToggleSwitchButton.styles,
    ..._custom_divider.CustomDivider.styles,
    ..._custom_image.CustomImage.styles,
    ..._custom_input.CustomInput.styles,
    ..._custom_text.CustomText.styles,
    ..._coming_soon_page.ComingSoonPage.styles,
    ..._error_page.ErrorPage.styles,
    ..._error_widget.ErrorWidget.styles,
    ..._init_widget.InitWidget.styles,
    ..._loading_widget.LoadingWidget.styles,
    ..._app_bar.AppTopBar.styles,
    ..._app_shell.AppShell.styles,
    ..._column.Column.styles,
    ..._grid_view.GridView.styles,
    ..._list_view.ListView.styles,
    ..._navigation_rail.NavigationRail.styles,
    ..._row.Row.styles,
  ],
);
