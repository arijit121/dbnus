import 'package:dbnus/shared/extensions/spacing.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dbnus/shared/constants/color_const.dart';
import 'package:dbnus/shared/extensions/logger_extension.dart';
import 'package:dbnus/shared/utils/screen_utils.dart';
import 'package:dbnus/shared/utils/text_utils.dart';
import 'package:dbnus/shared/ui/atoms/buttons/custom_button.dart';
import 'package:dbnus/shared/ui/atoms/decorations/init_widget.dart';
import 'package:dbnus/features/landing/presentation/bloc/landing_bloc.dart';
import 'package:dbnus/features/landing/presentation/utils/landing_utils.dart';
import 'package:dbnus/features/landing/presentation/widgets/landing_widget.dart';
import 'package:dbnus/features/landing/data/datasources/landing_remote_data_source.dart';
import 'package:dbnus/features/landing/data/repositories/landing_repository_impl.dart';
import 'package:dbnus/features/landing/domain/usecases/get_splash_banner_usecase.dart';

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
    String action = LandingUtils.listNavigation.elementAt(index).action;
    if (action == TextUtils.logout) {
      AppLog.i("Log out");
    } else {
      if (index != selectedIndex) {
        LandingUtils.redirect(action);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, widthState) {
      return BlocProvider(
        create: (context) => LandingBloc(
          getSplashBannerUseCase: GetSplashBannerUseCase(
            LandingRepositoryImpl(
              remoteDataSource: LandingRemoteDataSourceImpl(),
            ),
          ),
        )..add(ChangeIndex(index: widget.index)),
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
