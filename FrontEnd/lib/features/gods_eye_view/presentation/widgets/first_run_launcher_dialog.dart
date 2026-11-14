import 'package:material_ui/material_ui.dart';
import 'package:latlong2/latlong.dart';
import 'package:dbnus/shared/ui/atoms/decorations/glass_container.dart';
import 'package:dbnus/features/gods_eye_view/presentation/bloc/gods_eye_view_bloc.dart';
import 'package:dbnus/features/gods_eye_view/presentation/bloc/gods_eye_view_event.dart';

/// Authentic Mission Control First Run Dialog matching lines 836-883 of the GitHub repo:
/// "Choose your first view — It feels like a forbidden cockpit—then you realize the sources are public and the data is real."
class FirstRunLauncherDialog extends StatefulWidget {
  final GodsEyeViewBloc bloc;
  final Color hudColor;

  const FirstRunLauncherDialog({
    super.key,
    required this.bloc,
    required this.hudColor,
  });

  static Future<void> show(BuildContext context, GodsEyeViewBloc bloc, Color hudColor) {
    return showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.75),
      builder: (_) => FirstRunLauncherDialog(bloc: bloc, hudColor: hudColor),
    );
  }

  @override
  State<FirstRunLauncherDialog> createState() => _FirstRunLauncherDialogState();
}

class _FirstRunLauncherDialogState extends State<FirstRunLauncherDialog> {
  bool _suppressInFuture = false;

  @override
  Widget build(BuildContext context) {
    final themeColor = widget.hudColor;
    final screenWidth = MediaQuery.of(context).size.width;
    final isCompact = screenWidth < 600;

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: isCompact ? screenWidth * 0.94 : 520,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: GlassContainer(
            blur: 20,
            borderRadius: 12,
            color: const Color(0xFF0C0C14).withValues(alpha: 0.94),
            padding: EdgeInsets.zero,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isCompact ? 16 : 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Top Kicker & Close
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: themeColor,
                              boxShadow: [
                                BoxShadow(
                                  color: themeColor,
                                  blurRadius: 6,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'MISSION CONTROL · FIRST LAUNCH',
                            style: TextStyle(
                              color: themeColor,
                              fontSize: 10,
                              fontFamily: 'monospace',
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white60, size: 18),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Heading
                  const Text(
                    'Choose your first view',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Verbatim Subcopy from GitHub
                  Text(
                    'It feels like a forbidden cockpit\u2014then you realize the sources are public and the data is real.',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.72),
                      fontSize: 13,
                      height: 1.4,
                      fontFamily: 'monospace',
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Choice 1: LIVE CONTACTS
                  _buildChoiceCard(
                    context: context,
                    icon: Icons.radar,
                    title: 'LIVE CONTACTS',
                    subtitle: 'Aircraft, vessels and nearby intelligence',
                    themeColor: themeColor,
                    onTap: () {
                      widget.bloc.add(const ToggleLayer(GeointLayer.flights));
                      widget.bloc.add(const ToggleLayer(GeointLayer.military));
                      widget.bloc.add(const CenterOnLocation(LatLng(38.89, -77.03), 6.5, label: 'EAST COAST CORRIDOR'));
                      Navigator.of(context).pop();
                    },
                  ),
                  const SizedBox(height: 10),

                  // Choice 2: SPACE MISSIONS
                  _buildChoiceCard(
                    context: context,
                    icon: Icons.rocket_launch,
                    title: 'SPACE MISSIONS',
                    subtitle: 'Launches, spacecraft and orbital context',
                    themeColor: const Color(0xFF00E5FF),
                    onTap: () {
                      widget.bloc.add(const ToggleLayer(GeointLayer.satellites));
                      widget.bloc.add(const CenterOnLocation(LatLng(28.57, -80.64), 4.0, label: 'CAPE CANAVERAL / ISS ORBIT'));
                      Navigator.of(context).pop();
                    },
                  ),
                  const SizedBox(height: 10),

                  // Choice 3: ENVIRONMENTAL
                  _buildChoiceCard(
                    context: context,
                    icon: Icons.local_fire_department,
                    title: 'ENVIRONMENTAL',
                    subtitle: 'Live earthquakes and active fires, from USGS and NASA',
                    themeColor: const Color(0xFFFF9100),
                    onTap: () {
                      widget.bloc.add(const ToggleLayer(GeointLayer.earthquakes));
                      widget.bloc.add(const CenterOnLocation(LatLng(35.68, 139.76), 5.0, label: 'PACIFIC RING OF FIRE'));
                      Navigator.of(context).pop();
                    },
                  ),
                  const SizedBox(height: 10),

                  // Choice 4: EXPLORE MANUALLY
                  _buildChoiceCard(
                    context: context,
                    icon: Icons.public,
                    title: 'EXPLORE MANUALLY',
                    subtitle: 'Begin with a clean globe',
                    themeColor: Colors.white70,
                    onTap: () {
                      widget.bloc.add(const ResetGlobe());
                      Navigator.of(context).pop();
                    },
                  ),
                  const SizedBox(height: 18),

                  // Footer
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                            value: _suppressInFuture,
                            activeColor: themeColor,
                            checkColor: Colors.black,
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            onChanged: (val) {
                              setState(() {
                                _suppressInFuture = val ?? false;
                              });
                            },
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "Don't show this again",
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.6),
                              fontSize: 11,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'ESC to dismiss',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.4),
                          fontSize: 11,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Verbatim Tip Note
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.mic, size: 12, color: themeColor),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Tip: the GEV MIC button in the dock lets you talk to the map.',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: 10,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChoiceCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color themeColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF131726).withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: themeColor.withValues(alpha: 0.35), width: 1.0),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: themeColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: themeColor, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: themeColor,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: themeColor.withValues(alpha: 0.6), size: 14),
          ],
        ),
      ),
    );
  }
}
