import 'package:dbnus/shared/extensions/spacing.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dbnus/shared/constants/color_const.dart';
import 'package:dbnus/shared/extensions/logger_extension.dart';
import 'package:dbnus/shared/utils/screen_utils.dart';
import 'package:dbnus/shared/utils/text_utils.dart';
import 'package:dbnus/shared/ui/atoms/buttons/custom_button.dart';
import 'package:dbnus/shared/ui/atoms/text/custom_text.dart';
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

class _LandingUiState extends State<LandingUi>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    )..forward();
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  // ── Narrow body ─────────────────────────────────────
  Widget _narrowUiBody({required LandingState state}) => FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: state.page.value ?? Center(child: InitWidget()),
        ),
      );

  // ── Medium body ─────────────────────────────────────
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
          // Subtle divider line
          Container(
            width: 1,
            color: Colors.black.withValues(alpha: 0.06),
          ),
          Flexible(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 16, left: 16, right: 16),
                child:
                    state.page.value ?? Center(child: InitWidget()),
              ),
            ),
          ),
        ],
      );

  // ── Large body ──────────────────────────────────────
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
          // Subtle divider line
          Container(
            width: 1,
            color: Colors.black.withValues(alpha: 0.06),
          ),
          Flexible(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 16, left: 24, right: 24),
                child:
                    state.page.value ?? Center(child: InitWidget()),
              ),
            ),
          ),
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
        // Replay fade animation on page switch
        _fadeController.reset();
        _fadeController.forward();
        LandingUtils.redirect(action);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, widthState) {
      return BlocProvider(
        lazy: false,
        create: (context) => LandingBloc(
          repository: LandingRepositoryImpl(
            dataSource: LandingRemoteDataSourceImpl(),
          ),
        )
          ..add(ChangeIndex(index: widget.index))
          ..add(Init()),
        child: BlocBuilder<LandingBloc, LandingState>(
          builder: (context, state) {
            return Scaffold(
              key: _scaffoldKey,
              backgroundColor: ColorConst.scaffoldBg,

              // ── Drawer (narrow only) ───────────────────
              drawer: widthState != WidthState.narrow
                  ? null
                  : Drawer(
                      width: 240,
                      backgroundColor: const Color(0xFF1A1D2E),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.horizontal(
                          right: Radius.circular(20),
                        ),
                      ),
                      child: SafeArea(
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
                    ),

              // ── AppBar (narrow only) ───────────────────
              appBar: widthState != WidthState.narrow
                  ? null
                  : AppBar(
                      backgroundColor: ColorConst.scaffoldBg,
                      surfaceTintColor: Colors.transparent,
                      leading: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Center(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      Colors.black.withValues(alpha: 0.06),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: CustomIconButton(
                              padding: const EdgeInsets.all(10),
                              color: ColorConst.primaryDark,
                              iconSize: 22,
                              onPressed: () {
                                _scaffoldKey.currentState?.openDrawer();
                              },
                              icon: const Icon(FeatherIcons.menu),
                            ),
                          ),
                        ),
                      ),
                      title: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              gradient: const LinearGradient(
                                colors: [
                                  ColorConst.sidebarSelected,
                                  ColorConst.violate,
                                ],
                              ),
                            ),
                            child: const Center(
                              child: CustomText(
                                "D",
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                size: 14,
                              ),
                            ),
                          ),
                          8.pw,
                          const CustomText(
                            'Dbnus',
                            fontWeight: FontWeight.w700,
                            size: 20,
                            color: ColorConst.primaryDark,
                          ),
                        ],
                      ),
                      centerTitle: false,
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      actions: [
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      Colors.black.withValues(alpha: 0.06),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: CustomIconButton(
                              padding: const EdgeInsets.all(10),
                              color: ColorConst.primaryDark,
                              iconSize: 20,
                              onPressed: () {
                                // Could open notifications, search, etc.
                              },
                              icon: const Icon(FeatherIcons.bell),
                            ),
                          ),
                        ),
                      ],
                    ),

              // ── Body ───────────────────────────────────
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
