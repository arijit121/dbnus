import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';
import 'package:dbnus/features/gods_eye_view/domain/entities/geoint_contact.dart';
import 'package:dbnus/features/gods_eye_view/domain/entities/sensor_mode.dart';

enum GeointLayer {
  flights,
  military,
  satellites,
  vessels,
  earthquakes,
  cctv,
  infrastructure,
  detectionBoxes,
}

enum BasemapType {
  satellite,
  dark,
  street;

  String get displayName {
    switch (this) {
      case BasemapType.satellite:
        return 'ESRI WORLD IMAGERY';
      case BasemapType.dark:
        return 'TACTICAL DARK';
      case BasemapType.street:
        return 'OPENSTREETMAP';
    }
  }

  String get tileUrl {
    switch (this) {
      case BasemapType.satellite:
        return 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}';
      case BasemapType.dark:
        return 'https://cartodb-basemaps-a.global.ssl.fastly.net/dark_all/{z}/{x}/{y}.png';
      case BasemapType.street:
        return 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
    }
  }
}

abstract class GodsEyeViewEvent extends Equatable {
  const GodsEyeViewEvent();

  @override
  List<Object?> get props => [];
}

class InitGeointData extends GodsEyeViewEvent {
  const InitGeointData();
}

class RefreshFeeds extends GodsEyeViewEvent {
  const RefreshFeeds();
}

class TickDeadReckoning extends GodsEyeViewEvent {
  final double dtSeconds;
  const TickDeadReckoning(this.dtSeconds);

  @override
  List<Object?> get props => [dtSeconds];
}

class SelectContact extends GodsEyeViewEvent {
  final GeointContact? contact;
  const SelectContact(this.contact);

  @override
  List<Object?> get props => [contact];
}

class ToggleCockpitMode extends GodsEyeViewEvent {
  final bool? enable;
  const ToggleCockpitMode([this.enable]);

  @override
  List<Object?> get props => [enable];
}

class ChangeSensorMode extends GodsEyeViewEvent {
  final SensorMode mode;
  const ChangeSensorMode(this.mode);

  @override
  List<Object?> get props => [mode];
}

class ToggleLayer extends GodsEyeViewEvent {
  final GeointLayer layer;
  const ToggleLayer(this.layer);

  @override
  List<Object?> get props => [layer];
}

class ChangeBasemap extends GodsEyeViewEvent {
  final BasemapType basemap;
  const ChangeBasemap(this.basemap);

  @override
  List<Object?> get props => [basemap];
}

class ExecuteVoiceOrTextCommand extends GodsEyeViewEvent {
  final String command;
  const ExecuteVoiceOrTextCommand(this.command);

  @override
  List<Object?> get props => [command];
}

class CenterOnLocation extends GodsEyeViewEvent {
  final LatLng position;
  final double zoom;
  final String label;

  const CenterOnLocation(this.position, this.zoom, {this.label = ''});

  @override
  List<Object?> get props => [position, zoom, label];
}

class ResetGlobe extends GodsEyeViewEvent {
  const ResetGlobe();
}
