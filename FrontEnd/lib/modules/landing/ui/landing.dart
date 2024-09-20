import 'package:dbnus/config/app_config.dart';
import 'package:dbnus/const/color_const.dart';
import 'package:dbnus/extension/hex_color.dart';
import 'package:dbnus/router/router_name.dart';
import 'package:dbnus/utils/pop_up_items.dart';

import '../../../data/model/forward_geocoding.dart';
import 'package:dbnus/extension/spacing.dart';
import 'package:dbnus/service/download_handler.dart';
import 'package:dbnus/widget/custom_text.dart';
import 'package:dbnus/widget/custom_text_formfield.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/reverse_geocoding.dart';
import '../../../extension/logger_extension.dart';
import '../../../router/custom_router/custom_route.dart';
import '../../../service/geocoding.dart';
import '../../../service/open_service.dart';
import '../../../utils/screen_utils.dart';
import '../../../utils/text_utils.dart';
import '../../../widget/custom_button.dart';
import '../../../widget/custom_dropdown.dart';
import '../../reorderable_list/ui/my_reorderable_list.dart';
import '../bloc/landing_bloc.dart';
import '../utils/landing_utils.dart';
import '../widget/landing_widget.dart';

class LandingUi extends StatefulWidget {
  LandingUi({super.key, required this.index});

  final int index;

  @override
  State<LandingUi> createState() => _LandingUiState();
}

class _LandingUiState extends State<LandingUi> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget _narrowUiBody({required LandingState state}) =>
      LandingUtils.listNavigation.elementAt(state.pageIndex.value ?? 0).ui ??
      Container();

  Widget _mediumUiBody({required LandingState state}) => Flexible(
      child: LandingUtils.listNavigation
              .elementAt(state.pageIndex.value ?? 0)
              .ui ??
          Container());

  Widget _largeUiBody({required LandingState state}) => Flexible(
        child: LandingUtils.listNavigation
                .elementAt(state.pageIndex.value ?? 0)
                .ui ??
            Container(),
      );

  void _onChooseIndex({required int index, required BuildContext context}) {
    if (LandingUtils.listNavigation.elementAt(index).action ==
        TextUtils.logout) {
      AppLog.i("Log out");
    } else if (kIsWeb) {
      LandingUtils.redirect(index);
    } else {
      context.read<LandingBloc>().add(ChangeIndex(index: index));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, widthState) {
      return BlocProvider(
        create: (context) =>
            LandingBloc()..add(ChangeIndex(index: widget.index)),
        child: BlocBuilder<LandingBloc, LandingState>(
          builder: (context, state) {
            return Scaffold(
              appBar: widthState == WidthState.narrow
                  ? AppBar(
                      backgroundColor: Colors.white,
                      leading: CustomIconButton(
                          onPressed: () {
                            _scaffoldKey.currentState?.openDrawer();
                          },
                          icon: const Icon(Icons.menu_rounded)),
                    )
                  : null,
              key: _scaffoldKey,
              drawer: widthState != WidthState.narrow
                  ? null
                  : SafeArea(
                      child: DrawerNavigationRail(
                          selectedIndex: state.pageIndex.value,
                          withTitle: true,
                          chooseIndex: (int value) {
                            Navigator.of(context).pop();
                            _onChooseIndex(index: value, context: context);
                          }),
                    ),
              backgroundColor: Colors.white,
              body: SafeArea(
                  child: ResponsiveUI(
                narrowUI: (BuildContext context) {
                  return _narrowUiBody(state: state);
                },
                mediumUI: (BuildContext context) {
                  return Row(
                    children: [
                      DrawerNavigationRail(
                          selectedIndex: state.pageIndex.value,
                          chooseIndex: (int value) {
                            _onChooseIndex(index: value, context: context);
                          }),
                      _mediumUiBody(state: state),
                    ],
                  );
                },
                largeUI: (BuildContext context) {
                  return Row(
                    children: [
                      DrawerNavigationRail(
                          selectedIndex: state.pageIndex.value,
                          withTitle: true,
                          chooseIndex: (int value) {
                            _onChooseIndex(index: value, context: context);
                          }),
                      _largeUiBody(state: state),
                    ],
                  );
                },
              )),
            );
          },
        ),
      );
    });
  }
}
