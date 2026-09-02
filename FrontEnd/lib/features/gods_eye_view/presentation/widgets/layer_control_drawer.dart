import 'package:material_ui/material_ui.dart';
import 'package:dbnus/features/gods_eye_view/presentation/bloc/gods_eye_view_bloc.dart';
import 'package:dbnus/features/gods_eye_view/presentation/bloc/gods_eye_view_event.dart';
import 'package:dbnus/features/gods_eye_view/presentation/bloc/gods_eye_view_state.dart';

class LayerControlDrawer extends StatelessWidget {
  final GodsEyeViewState state;
  final GodsEyeViewBloc bloc;

  const LayerControlDrawer({
    super.key,
    required this.state,
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    final hudColor = state.sensorMode.hudColor;

    return Drawer(
      backgroundColor: const Color(0xFF0C0C14),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      color: hudColor.withValues(alpha: 0.3), width: 1),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.layers, color: hudColor, size: 20),
                  const SizedBox(width: 10),
                  Text(
                    'DATA LAYERS',
                    style: TextStyle(
                      color: hudColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                      letterSpacing: 1.2,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white70),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  // Basemap Section
                  _buildSectionHeader('BASEMAP TILE STACK', hudColor),
                  ...BasemapType.values.map((base) {
                    final isSelected = state.basemap == base;
                    return ListTile(
                      dense: true,
                      leading: Icon(
                        isSelected
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked,
                        color: isSelected ? hudColor : Colors.white38,
                        size: 18,
                      ),
                      title: Text(
                        base.displayName,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.white70,
                          fontSize: 12,
                          fontFamily: 'monospace',
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      onTap: () {
                        bloc.add(ChangeBasemap(base));
                      },
                    );
                  }),

                  const Divider(color: Colors.white12, height: 24),

                  // GEOINT Signal Feeds
                  _buildSectionHeader('LIVE GEOINT SIGNALS', hudColor),
                  _buildLayerToggle(
                    title: 'COMMERCIAL FLIGHTS',
                    subtitle: 'OpenSky live ADS-B air traffic',
                    layer: GeointLayer.flights,
                    icon: Icons.flight,
                    hudColor: hudColor,
                  ),
                  _buildLayerToggle(
                    title: 'MILITARY FLIGHTS',
                    subtitle: 'Recon & strategic air assets',
                    layer: GeointLayer.military,
                    icon: Icons.shield,
                    hudColor: hudColor,
                  ),
                  _buildLayerToggle(
                    title: 'SATELLITES & ORBITS',
                    subtitle: 'ISS, Starlink, KH-11, GPS',
                    layer: GeointLayer.satellites,
                    icon: Icons.satellite_alt,
                    hudColor: hudColor,
                  ),
                  _buildLayerToggle(
                    title: 'MARITIME AIS VESSELS',
                    subtitle: 'Cargo, tankers, naval vessels',
                    layer: GeointLayer.vessels,
                    icon: Icons.directions_boat,
                    hudColor: hudColor,
                  ),
                  _buildLayerToggle(
                    title: 'USGS EARTHQUAKES',
                    subtitle: 'Live global seismic monitoring',
                    layer: GeointLayer.earthquakes,
                    icon: Icons.waves,
                    hudColor: hudColor,
                  ),
                  _buildLayerToggle(
                    title: 'PUBLIC CCTV MESH',
                    subtitle: 'Projected cameras & viewsheds',
                    layer: GeointLayer.cctv,
                    icon: Icons.videocam,
                    hudColor: hudColor,
                  ),
                  _buildLayerToggle(
                    title: 'CRITICAL INFRASTRUCTURE',
                    subtitle: 'Undersea cables, datacenters, dams',
                    layer: GeointLayer.infrastructure,
                    icon: Icons.cable,
                    hudColor: hudColor,
                  ),
                  _buildLayerToggle(
                    title: 'DETECTION BOUNDING BOXES',
                    subtitle: 'Screen-space AI tactical brackets',
                    layer: GeointLayer.detectionBoxes,
                    icon: Icons.crop_free,
                    hudColor: hudColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color hudColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Text(
        '// $title',
        style: TextStyle(
          color: hudColor.withValues(alpha: 0.6),
          fontSize: 10,
          fontFamily: 'monospace',
          fontWeight: FontWeight.bold,
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  Widget _buildLayerToggle({
    required String title,
    required String subtitle,
    required GeointLayer layer,
    required IconData icon,
    required Color hudColor,
  }) {
    final isEnabled = state.activeLayers.contains(layer);

    return SwitchListTile(
      dense: true,
      secondary: Icon(
        icon,
        color: isEnabled ? hudColor : Colors.white30,
        size: 20,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isEnabled ? Colors.white : Colors.white60,
          fontSize: 12,
          fontFamily: 'monospace',
          fontWeight: isEnabled ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: Colors.white38,
          fontSize: 10,
        ),
      ),
      activeTrackColor: hudColor.withValues(alpha: 0.5),
      activeThumbColor: hudColor,
      value: isEnabled,
      onChanged: (_) {
        bloc.add(ToggleLayer(layer));
      },
    );
  }
}
