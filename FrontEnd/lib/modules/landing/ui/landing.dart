import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../extension/logger_extension.dart';
import '../../../utils/screen_utils.dart';
import '../../../utils/text_utils.dart';
import '../../../widget/custom_button.dart';
import '../../../widget/init_widget.dart';
import '../bloc/landing_bloc.dart';
import '../utils/landing_utils.dart';
import '../widget/landing_widget.dart';

class LandingUi extends StatefulWidget {
  const LandingUi({super.key, required this.index});

  final int index;

  @override
  State<LandingUi> createState() => _LandingUiState();
}

class _LandingUiState extends State<LandingUi> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget _narrowUiBody({required LandingState state}) =>
      state.page.value ?? Center(child: InitWidget());

  Widget _mediumUiBody({required LandingState state}) =>
      Flexible(child: state.page.value ?? Center(child: InitWidget()));

  Widget _largeUiBody({required LandingState state}) => Flexible(
        child: state.page.value ?? Center(child: InitWidget()),
      );

  void _onChooseIndex(
      {required int index,
      required int? selectedIndex,
      required BuildContext context}) {
    if (LandingUtils.listNavigation.elementAt(index).action ==
        TextUtils.logout) {
      AppLog.i("Log out");
    } else {
      if (index != selectedIndex) {
        LandingUtils.redirect(index);
      }
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
                            _onChooseIndex(
                                index: value,
                                context: context,
                                selectedIndex: state.pageIndex.value);
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
                            _onChooseIndex(
                                index: value,
                                context: context,
                                selectedIndex: state.pageIndex.value);
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
                            _onChooseIndex(
                                index: value,
                                context: context,
                                selectedIndex: state.pageIndex.value);
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
