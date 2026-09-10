import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:dbnus/features/gods_eye_view/domain/entities/geoint_contact.dart';
import 'package:dbnus/features/gods_eye_view/domain/entities/sensor_mode.dart';

class CctvFeedDialog extends StatelessWidget {
  final CctvCameraContact camera;
  final SensorMode sensorMode;

  const CctvFeedDialog({
    super.key,
    required this.camera,
    required this.sensorMode,
  });

  @override
  Widget build(BuildContext context) {
    final hudColor = sensorMode.hudColor;
    final timestamp =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now().toUtc());

    return Dialog(
      backgroundColor: const Color(0xFF0F172A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: hudColor, width: 1.5),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        constraints: const BoxConstraints(maxWidth: 520),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFFF5252),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'LIVE CCTV // ${camera.city.toUpperCase()}',
                  style: TextStyle(
                    color: hudColor,
                    fontSize: 12,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.close, color: Colors.white70, size: 20),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Video / Snapshot Frame with CCTV Watermark
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: CachedNetworkImage(
                      imageUrl: camera.snapshotUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.black,
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.black,
                        child: Center(
                          child: Icon(Icons.videocam_off,
                              color: hudColor.withValues(alpha: 0.5), size: 48),
                        ),
                      ),
                    ),
                  ),

                  // Overlay Telemetry Watermark (Top-Left)
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      color: Colors.black.withValues(alpha: 0.7),
                      child: Text(
                        'REC ● $timestamp UTC',
                        style: const TextStyle(
                          color: Color(0xFFFF5252),
                          fontFamily: 'monospace',
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // Overlay Cam Info (Bottom-Left)
                  Positioned(
                    bottom: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      color: Colors.black.withValues(alpha: 0.7),
                      child: Text(
                        camera.cameraName.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'monospace',
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Viewshed & Optics Telemetry
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                    color: hudColor.withValues(alpha: 0.3), width: 1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'BEARING: ${camera.bearingDeg}°',
                    style: TextStyle(
                      color: hudColor,
                      fontSize: 11,
                      fontFamily: 'monospace',
                    ),
                  ),
                  Text(
                    'FOV CONE: ${camera.fovDeg}°',
                    style: TextStyle(
                      color: hudColor,
                      fontSize: 11,
                      fontFamily: 'monospace',
                    ),
                  ),
                  const Text(
                    'VIEWSHED: PROJECTED',
                    style: TextStyle(
                      color: Color(0xFF00E676),
                      fontSize: 11,
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
