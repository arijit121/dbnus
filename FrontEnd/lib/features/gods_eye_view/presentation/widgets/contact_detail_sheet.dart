import 'package:flutter/material.dart';
import 'package:dbnus/features/gods_eye_view/domain/entities/geoint_contact.dart';
import 'package:dbnus/features/gods_eye_view/domain/entities/sensor_mode.dart';
import 'package:dbnus/features/gods_eye_view/presentation/bloc/gods_eye_view_bloc.dart';
import 'package:dbnus/features/gods_eye_view/presentation/bloc/gods_eye_view_event.dart';
import 'package:dbnus/features/gods_eye_view/presentation/widgets/gev_contact_model_preview.dart';

class ContactDetailSheet extends StatelessWidget {
  final GeointContact contact;
  final SensorMode sensorMode;
  final GodsEyeViewBloc bloc;
  final VoidCallback? onViewCctv;

  const ContactDetailSheet({
    super.key,
    required this.contact,
    required this.sensorMode,
    required this.bloc,
    this.onViewCctv,
  });

  @override
  Widget build(BuildContext context) {
    final hudColor = sensorMode.hudColor;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF09121B).withValues(alpha: 0.94),
        border: Border.all(
          color: const Color(0xFF7BBDD3).withValues(alpha: 0.35),
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.58),
            blurRadius: 28,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: hudColor.withValues(alpha: 0.08),
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: hudColor.withValues(alpha: 0.2),
                  border: Border.all(color: hudColor, width: 1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  contact.type.name.toUpperCase(),
                  style: TextStyle(
                    color: hudColor,
                    fontSize: 10,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  contact.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.close, color: Colors.white70, size: 18),
                onPressed: () {
                  bloc.add(const SelectContact(null));
                },
              ),
            ],
          ),
          const SizedBox(height: 12),

          if (contact is FlightContact || contact is VesselContact)
            GevContactModelPreview(
              contact: contact,
              hudColor: hudColor,
            ),

          // Telemetry Grid
          _buildTelemetryContent(hudColor),
          const SizedBox(height: 14),

          // Actions
          Row(
            children: [
              if (contact is FlightContact)
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: hudColor.withValues(alpha: 0.25),
                      side: BorderSide(color: hudColor, width: 1.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    icon: Icon(Icons.flight_takeoff, color: hudColor, size: 16),
                    label: Text(
                      'ENTER COCKPIT',
                      style: TextStyle(
                        color: hudColor,
                        fontSize: 11,
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      bloc.add(const ToggleCockpitMode(true));
                    },
                  ),
                ),
              if (contact is CctvCameraContact)
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: hudColor.withValues(alpha: 0.25),
                      side: BorderSide(color: hudColor, width: 1.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    icon: Icon(Icons.videocam, color: hudColor, size: 16),
                    label: Text(
                      'VIEW CCTV FEED',
                      style: TextStyle(
                        color: hudColor,
                        fontSize: 11,
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: onViewCctv,
                  ),
                ),
              if (contact is! FlightContact && contact is! CctvCameraContact)
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: hudColor.withValues(alpha: 0.25),
                      side: BorderSide(color: hudColor, width: 1.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    icon: Icon(Icons.my_location, color: hudColor, size: 16),
                    label: Text(
                      'LOCK & CENTER',
                      style: TextStyle(
                        color: hudColor,
                        fontSize: 11,
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      bloc.add(CenterOnLocation(contact.position, 10.0,
                          label: contact.title));
                    },
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTelemetryContent(Color hudColor) {
    if (contact is FlightContact) {
      final f = contact as FlightContact;
      return Column(
        children: [
          _row('CALLSIGN', f.callsign, 'ICAO24', f.icao24, hudColor),
          _row('MODEL', f.model, 'SQUAWK', f.squawk, hudColor),
          _row('ALTITUDE', '${f.altitudeFt.toInt()} FT', 'AIRSPEED',
              '${f.speedKnots.toInt()} KTS', hudColor),
          _row('HEADING', '${f.headingDeg.toInt()}°', 'ORIGIN', f.origin,
              hudColor),
          _row('DESTINATION', f.destination, 'CLASS',
              f.isMilitary ? 'MILITARY / SEC' : 'COMMERCIAL', hudColor),
        ],
      );
    } else if (contact is SatelliteContact) {
      final s = contact as SatelliteContact;
      return Column(
        children: [
          _row('NORAD ID', s.noradId, 'CATEGORY', s.category, hudColor),
          _row('ALTITUDE', '${s.altitudeKm.toStringAsFixed(1)} KM', 'VELOCITY',
              '${s.velocityKmS.toStringAsFixed(2)} KM/S', hudColor),
          _row('INCLINATION', '${s.inclinationDeg.toStringAsFixed(1)}°',
              'PERIOD', '~92 MINS', hudColor),
        ],
      );
    } else if (contact is VesselContact) {
      final v = contact as VesselContact;
      return Column(
        children: [
          _row('MMSI', v.mmsi, 'TYPE', v.vesselType, hudColor),
          _row('SPEED', '${v.speedKnots} KTS', 'HEADING', '${v.headingDeg}°',
              hudColor),
          _row('DRAUGHT', '${v.draughtM} M', 'DEST', v.destination, hudColor),
        ],
      );
    } else if (contact is EarthquakeContact) {
      final eq = contact as EarthquakeContact;
      return Column(
        children: [
          _row('MAGNITUDE', 'M${eq.magnitude.toStringAsFixed(1)}', 'DEPTH',
              '${eq.depthKm.toStringAsFixed(1)} KM', hudColor),
          _row('ALERT LEVEL', eq.alertLevel.toUpperCase(), 'UTC TIME',
              eq.timestamp.toUtc().toString().substring(11, 19), hudColor),
        ],
      );
    } else if (contact is CctvCameraContact) {
      final c = contact as CctvCameraContact;
      return Column(
        children: [
          _row('CITY / JURISDICTION', c.city, 'BEARING', '${c.bearingDeg}°',
              hudColor),
          _row('FIELD OF VIEW', '${c.fovDeg}°', 'STATUS', 'LIVE ONLINE',
              hudColor),
        ],
      );
    } else if (contact is InfrastructureContact) {
      final i = contact as InfrastructureContact;
      return Column(
        children: [
          _row('CATEGORY', i.category, 'CAPACITY', i.capacity, hudColor),
          _row('DETAILS', i.details, 'STRATEGIC TIER', 'TIER 1 CRITICAL',
              hudColor),
        ],
      );
    } else if (contact is WildfireContact) {
      final w = contact as WildfireContact;
      return Column(
        children: [
          _row(
              'FIRE RADIATIVE PWR',
              '${w.frpMw.toStringAsFixed(1)} MW',
              'BRIGHTNESS',
              '${w.brightnessKelvin.toStringAsFixed(1)} K',
              hudColor),
          _row('CONFIDENCE', w.confidence.toUpperCase(), 'REGION', w.region,
              hudColor),
          _row('SENSOR PLATFORM', 'NASA FIRMS VIIRS', 'UTC ACQUIRED',
              w.acquisitionTime.toUtc().toString().substring(11, 19), hudColor),
        ],
      );
    } else if (contact is SpaceLaunchContact) {
      final sl = contact as SpaceLaunchContact;
      return Column(
        children: [
          _row('MISSION', sl.missionName, 'STATUS', sl.status, hudColor),
          _row('VEHICLE', sl.vehicle, 'OPERATOR', sl.operatorName, hudColor),
          _row(
              'LAUNCH SITE', sl.site, 'AZIMUTH', '${sl.azimuthDeg}°', hudColor),
          _row('TRAJECTORY VECTORS', '${sl.trajectoryPoints.length} WAYPOINTS',
              'CORRIDOR', 'NOMINAL ASCENT', hudColor),
        ],
      );
    }

    return Text(
      'POS: ${contact.position.latitude.toStringAsFixed(4)}, ${contact.position.longitude.toStringAsFixed(4)}',
      style: TextStyle(color: hudColor, fontFamily: 'monospace', fontSize: 11),
    );
  }

  Widget _row(String k1, String v1, String k2, String v2, Color hudColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 10, fontFamily: 'monospace'),
                children: [
                  TextSpan(
                    text: '$k1: ',
                    style: TextStyle(color: hudColor.withValues(alpha: 0.7)),
                  ),
                  TextSpan(
                    text: v1,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 10, fontFamily: 'monospace'),
                children: [
                  TextSpan(
                    text: '$k2: ',
                    style: TextStyle(color: hudColor.withValues(alpha: 0.7)),
                  ),
                  TextSpan(
                    text: v2,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
