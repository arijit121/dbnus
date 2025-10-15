import 'package:dbnus/extension/spacing.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../const/color_const.dart';
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

  Widget _narrowUiBody({required LandingState state}) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: state.page.value ?? Center(child: InitWidget()),
      );

  Widget _mediumUiBody({required LandingState state}) => Row(
        children: [
          DrawerNavigationRail(
              selectedIndex: state.pageIndex.value,
              chooseIndex: (int value) {
                _onChooseIndex(
                    index: value,
                    context: context,
                    selectedIndex: state.pageIndex.value);
              }),
          8.pw,
          Flexible(
              child: Padding(
            padding: const EdgeInsets.only(top: 16),
            child: state.page.value ?? Center(child: InitWidget()),
          )),
          8.pw,
        ],
      );

  Widget _largeUiBody({required LandingState state}) => Row(
        children: [
          DrawerNavigationRail(
              selectedIndex: state.pageIndex.value,
              withTitle: true,
              expanded: true,
              chooseIndex: (int value) {
                _onChooseIndex(
                    index: value,
                    context: context,
                    selectedIndex: state.pageIndex.value);
              }),
          8.pw,
          Flexible(
              child: Padding(
            padding: const EdgeInsets.only(top: 18),
            child: state.page.value ?? Center(child: InitWidget()),
          )),
          8.pw,
        ],
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
            final bloc = context.read<LandingBloc>();
            return Scaffold(
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
              appBar: widthState != WidthState.narrow
                  ? null
                  : AppBar(
                      leading: CustomIconButton(
                        padding: EdgeInsets.all(16),
                        color: ColorConst.primaryDark,
                        iconSize: 24,
                        onPressed: () {
                          _scaffoldKey.currentState?.openDrawer();
                        },
                        icon: Icon(FeatherIcons.menu),
                      ),
                      elevation: 0,
                      shadowColor: Colors.transparent,
                    ),
              body: SafeArea(
                  child: ResponsiveUI(
                narrowUI: (BuildContext context) {
                  return _narrowUiBody(state: state);
                },
                mediumUI: (BuildContext context) {
                  return _mediumUiBody(state: state);
                },
                largeUI: (BuildContext context) {
                  return _largeUiBody(state: state);
                },
              )),
            );
          },
        ),
      );
    });
  }
}
