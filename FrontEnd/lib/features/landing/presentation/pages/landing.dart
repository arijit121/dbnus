import 'package:material_ui/material_ui.dart';
import 'package:dbnus/shared/constants/color_const.dart';
import 'package:dbnus/shared/ui/atoms/decorations/init_widget.dart';
import 'package:dbnus/features/landing/presentation/utils/landing_utils.dart';
import 'package:dbnus/features/landing/presentation/widgets/landing_widget.dart';
import 'package:dbnus/shared/utils/screen_utils.dart';

import '../../../../navigation/router_name.dart';
import '../../../../shared/constants/assects_const.dart';
import '../../../../shared/extensions/logger_extension.dart';
import '../../../../shared/extensions/spacing.dart';
import '../../../../shared/ui/atoms/buttons/custom_button.dart';
import '../../../../shared/ui/atoms/images/custom_image.dart';
import '../../../../shared/ui/atoms/text/custom_text.dart';
import '../../../../shared/utils/text_utils.dart';

class LandingUi extends StatefulWidget {
  const LandingUi({super.key, required this.index, this.ui});

  final int index;
  final Widget? ui;

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
        LandingUtils.redirect(action, uiContain: action != RouteName.bioData);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, widthState) {
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
                      selectedIndex: widget.index,
                      withTitle: true,
                      chooseIndex: (int value) {
                        Navigator.of(context).pop();
                        _onChooseIndex(
                            index: value,
                            context: context,
                            selectedIndex: widget.index);
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
                            color: Colors.black.withValues(alpha: 0.06),
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
                        icon: const CustomSvgAssetImageView(
                          path: AssetsConst.featherMenu,
                          color: ColorConst.primaryDark,
                        ),
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
                            color: Colors.black.withValues(alpha: 0.06),
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
                        icon: const CustomSvgAssetImageView(
                          path: AssetsConst.featherBell,
                          color: ColorConst.primaryDark,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

        body: SafeArea(
          child: ResponsiveUI(
            narrowUI: (BuildContext context) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: widget.ui ?? Center(child: InitWidget()),
                ),
              );
            },
            mediumUI: (BuildContext context) {
              return Row(
                children: [
                  DrawerNavigationRail(
                      selectedIndex: widget.index,
                      chooseIndex: (int value) {
                        _onChooseIndex(
                            index: value,
                            context: context,
                            selectedIndex: widget.index);
                      }),
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
                        child: widget.ui ?? Center(child: InitWidget()),
                      ),
                    ),
                  ),
                ],
              );
            },
            largeUI: (BuildContext context) {
              return Row(
                children: [
                  DrawerNavigationRail(
                      selectedIndex: widget.index,
                      withTitle: true,
                      expanded: true,
                      chooseIndex: (int value) {
                        _onChooseIndex(
                            index: value,
                            context: context,
                            selectedIndex: widget.index);
                      }),
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
                        child: widget.ui ?? Center(child: InitWidget()),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        /* bottomNavigationBar: widthState == WidthState.narrow
            ? ButtonNavigationBar(
                selectedIndex: widget.index,
                chooseIndex: (value) {
                  _onChooseIndex(
                      index: value,
                      context: context,
                      selectedIndex: widget.index);
                },
              )
            : null,*/
      );
    });
  }
}
