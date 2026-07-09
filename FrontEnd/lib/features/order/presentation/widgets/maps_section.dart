import 'package:material_ui/material_ui.dart';
import 'package:dbnus/shared/constants/assects_const.dart';

import 'package:dbnus/shared/constants/color_const.dart';
import 'package:dbnus/core/services/open_service.dart';
import 'package:dbnus/core/services/google_geo_coding.dart';
import 'package:dbnus/core/models/location_model.dart';
import 'package:dbnus/shared/utils/pop_up_items.dart';
import 'package:dbnus/shared/ui/atoms/indicators/loading_widget.dart';
import 'package:dbnus/shared/ui/atoms/inputs/custom_text_formfield.dart';

import 'order_tool_tile.dart';

class MapsSection extends StatefulWidget {
  const MapsSection({super.key});

  @override
  State<MapsSection> createState() => _MapsSectionState();
}

class _MapsSectionState extends State<MapsSection> {
  final TextEditingController _coordsController =
      TextEditingController(text: "22.578285701174266, 88.4814892102445");

  @override
  void dispose() {
    _coordsController.dispose();
    super.dispose();
  }

  (double?, double?) _parseCoordinates(String text) {
    final parts = text.split(',');
    if (parts.length != 2) return (null, null);
    final lat = double.tryParse(parts[0].trim());
    final lng = double.tryParse(parts[1].trim());
    return (lat, lng);
  }

  Widget _buildDivider() =>
      const Divider(height: 1, indent: 56, color: ColorConst.lineGrey);

  @override
  Widget build(BuildContext context) {
    final (lat, lng) = _parseCoordinates(_coordsController.text);
    final String latVal = lat?.toString() ?? "0.0";
    final String lngVal = lng?.toString() ?? "0.0";

    return Container(
      decoration: BoxDecoration(
        color: ColorConst.cardBg,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          OrderToolTile(
            icon: AssetsConst.featherSearch,
            title: "Open Kolkata in Maps",
            subtitle: "Search by address with directions",
            color: ColorConst.deepGreen,
            onTap: () {
              OpenService.openAddressInMap(address: 'Kolkata', direction: true);
            },
          ),
          _buildDivider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomTextFormField(
              controller: _coordsController,
              title: "Coordinates (Latitude, Longitude)",
              hintText: "e.g. 22.5754, 88.4798",
              keyboardType: TextInputType.text,
              onChanged: (val) => setState(() {}),
            ),
          ),
          _buildDivider(),
          OrderToolTile(
            icon: AssetsConst.featherNavigation,
            title: "Open Coordinates",
            subtitle: "Lat: $latVal, Lng: $lngVal",
            color: ColorConst.lightBlue,
            onTap: () {
              final (latitude, longitude) = _parseCoordinates(_coordsController.text);
              if (latitude != null && longitude != null) {
                OpenService.openCoordinatesInMap(
                  latitude: latitude,
                  longitude: longitude,
                );
              } else {
                PopUpItems.toastMessage(
                  "Please enter coordinates in 'lat, lng' format",
                  ColorConst.red,
                );
              }
            },
          ),
          _buildDivider(),
          OrderToolTile(
            icon: AssetsConst.featherMapPin,
            title: "Reverse Geocoding V2",
            subtitle: "Lat: $latVal, Lng: $lngVal",
            color: const Color(0xFFE67E22),
            onTap: () async {
              final (latitude, longitude) = _parseCoordinates(_coordsController.text);
              if (latitude == null || longitude == null) {
                PopUpItems.toastMessage(
                  "Please enter coordinates in 'lat, lng' format",
                  ColorConst.red,
                );
                return;
              }
              final loadingContext = await showLoading();
              try {
                final LocationModel? location = await GoogleGeoCoding().reverseGeocodingV2(
                  latitude: latitude,
                  longitude: longitude,
                );
                if (!loadingContext.mounted) return;
                hideLoading(loadingDialogContext: loadingContext);

                if (location != null) {
                  PopUpItems.customMsgDialog(
                    title: "Location Details",
                    content: "Address: ${location.address}\n\nPin Code: ${location.pinCode}\nName: ${location.addressName}",
                    type: DialogType.success,
                  );
                } else {
                  PopUpItems.customMsgDialog(
                    title: "Error",
                    content: "Failed to fetch address details.",
                    type: DialogType.error,
                  );
                }
              } catch (e) {
                if (!loadingContext.mounted) return;
                hideLoading(loadingDialogContext: loadingContext);
                PopUpItems.customMsgDialog(
                  title: "Error",
                  content: e.toString(),
                  type: DialogType.error,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
