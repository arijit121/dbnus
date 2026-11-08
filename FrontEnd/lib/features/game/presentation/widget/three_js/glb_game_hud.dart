import 'package:material_ui/material_ui.dart';
import '../../../../../navigation/custom_router/custom_route.dart';
import '../../../../../shared/ui/atoms/text/custom_text.dart';

class GlbGameHud extends StatelessWidget {
  final int score;
  final int shield;
  final double laserHeat;
  final bool laserOverheated;

  const GlbGameHud({
    super.key,
    required this.score,
    required this.shield,
    required this.laserHeat,
    required this.laserOverheated,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Back Button & Score Card
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new,
                        color: Colors.white),
                    onPressed: () => CustomRoute.back(),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xAA060614),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0x3300f0ff)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomText('SCORE',
                            color: Color(0xFF00F0FF),
                            size: 10,
                            fontWeight: FontWeight.bold),
                        CustomText('$score',
                            color: Colors.white,
                            size: 18,
                            fontWeight: FontWeight.w900),
                      ],
                    ),
                  ),
                ],
              ),

              // Systems Health panel
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Shields HUD
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xAA060614),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0x33ff0055)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.shield,
                            color: Color(0xFFFF0055), size: 16),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CustomText('DEFLECTOR SHIELDS',
                                color: Color(0xFFFF0055),
                                size: 8,
                                fontWeight: FontWeight.bold),
                            const SizedBox(height: 4),
                            Container(
                              width: 100,
                              height: 6,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(3),
                              ),
                              alignment: Alignment.centerLeft,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                width: 100 * (shield / 100),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(colors: [
                                    Color(0xFFFF0055),
                                    Color(0xFFFF00CC)
                                  ]),
                                  borderRadius: BorderRadius.circular(3),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFFFF0055)
                                          .withValues(alpha: 0.7),
                                      blurRadius: 6,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Laser heat meter HUD
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xAA060614),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: laserOverheated
                              ? const Color(0xFFFF3300)
                              : const Color(0xFFFFAA00)
                                  .withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.wb_sunny_outlined,
                            color: laserOverheated
                                ? const Color(0xFFFF3300)
                                : const Color(0xFFFFAA00),
                            size: 16),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                                laserOverheated
                                    ? 'WEAPONS OVERHEATED'
                                    : 'LASER CORE TEMP',
                                color: laserOverheated
                                    ? const Color(0xFFFF3300)
                                    : const Color(0xFFFFAA00),
                                size: 8,
                                fontWeight: FontWeight.bold),
                            const SizedBox(height: 4),
                            Container(
                              width: 100,
                              height: 6,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(3),
                              ),
                              alignment: Alignment.centerLeft,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                width: 100 * (laserHeat / 100.0),
                                decoration: BoxDecoration(
                                  color: laserOverheated
                                      ? const Color(0xFFFF3300)
                                      : const Color(0xFFFFAA00),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
