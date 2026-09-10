import 'package:jaspr/dom.dart' hide BorderRadius, Padding;
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';
import 'package:jaspr_app/shared/constants/assects_const.dart';
import 'package:jaspr_app/shared/constants/theme.dart';
import 'package:jaspr_app/shared/ui/ui.dart';
import 'package:jaspr_app/shared/utils/pop_up_items.dart';
import 'package:jaspr_app/shared/extensions/logger_extension.dart';
import 'package:jaspr_app/core/services/download_handler.dart';
import 'package:jaspr_app/core/services/geocoding.dart';
import 'package:jaspr_app/core/services/models/forward_geocoding.dart';
import 'package:jaspr_app/core/services/models/reverse_geocoding.dart';
import 'package:jaspr_app/navigation/route_names.dart';

class ToolsSection extends StatelessComponent {
  const ToolsSection({super.key});

  @override
  Component build(BuildContext context) {
    final tools = [
      _ToolItem(
        icon: AssetsConst.featherDownload,
        title: "Download GlucoseFasting PDF",
        subtitle: "Download sample report",
        color: deepGreen,
        tag: "Download",
        onTap: () {
          DownloadHandler.download(
              downloadUrl:
                  "https://res.genupathlabs.com/genu_path_lab/live/customer_V2/sample_report/GlucoseFasting.pdf");
        },
      ),
      _ToolItem(
        icon: AssetsConst.featherDownloadCloud,
        title: "Download with Headers",
        subtitle: "Authenticated download",
        color: lightBlue,
        tag: "Download",
        onTap: () {
          DownloadHandler.download(
              downloadUrl:
                  "http://65.0.139.63:5001/api/admin/invoices/676f20131e1add0f4b4b2a58/pdf",
              headers: {
                "Authentication":
                    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY3N2FkM2Y3ZWQxZmQxZDA2YjgyMTliYiIsImlhdCI6MTczNjEwMjkwM30.RtRG7Sr6sPjCJX26Otmd9SWWfzF67_8ZzUIiblbJRZ8",
                "App-Type": "A",
                "App-Version": "1.0.0",
                "Content-Type": "application/json",
                "Device-Id": "7f9bfffbb6adeb27",
                "Device-Density-Type": "xhdpi",
                "Device-Name": "V2217A",
                "Network-Info": "wifi",
                "Device-Width": "431.30434782608694",
                "Device-Os-Info": "9",
                "Device-Height": "834.7826086956521",
                "Device-Density": "560",
                "App-Version-Code": "1"
              });
        },
      ),
      _ToolItem(
        icon: AssetsConst.featherMapPin,
        title: "Forward Geocoding",
        subtitle: "Jot Bhim, New Town, Bidhannagar",
        color: violate,
        tag: "Location",
        onTap: () async {
          ForwardGeocoding? forwardGeocoding =
              await Geocoding.forwardGeocoding(
                  address:
                      "Jot Bhim, New Town, Bidhannagar, North 24 Parganas District, West Bengal, 700160, India");
          AppLog.i(forwardGeocoding?.longitude);
        },
      ),
      _ToolItem(
        icon: AssetsConst.featherNavigation,
        title: "Reverse Geocoding",
        subtitle: "Lat: 22.5754, Lng: 88.4798",
        color: const Color('#E67E22'),
        tag: "Location",
        onTap: () async {
          ReverseGeocoding? reverseGeocoding =
              await Geocoding.reverseGeocoding(
                  latitude: 22.5754, longitude: 88.4798);
          AppLog.i(reverseGeocoding?.displayName);
        },
      ),
      _ToolItem(
        icon: AssetsConst.featherCheckCircle,
        title: "Show Success Dialog",
        subtitle: "Display success message popup",
        color: green,
        tag: "UI",
        onTap: () {
          PopUpItems.customMsgDialog(
              title: "Success",
              content: "Thank you, transaction complete.",
              type: DialogType.success);
        },
      ),
      _ToolItem(
        icon: AssetsConst.featherMap,
        title: "Open Street Map",
        subtitle: "Explore world landmarks on a map",
        color: const Color('#2980B9'),
        tag: "Map",
        onTap: () {
          Router.of(context).push(RouteName.openStreetMap);
        },
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: cardBg.value,
        borderRadius: BorderRadius.circular(18),
      ),
      style: Styles(raw: {
        'box-shadow': '0 4px 16px rgba(0, 0, 0, 0.06)',
        'border': '1px solid rgba(0, 0, 0, 0.04)',
      }),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header row
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  style: Styles(raw: {
                    'background-color': '${violate.value}1A',
                  }),
                  child: img(
                    src: AssetsConst.featherLayers,
                    styles: Styles(raw: {'width': '14px', 'height': '14px'}),
                  ),
                ),
                const SizedBox(width: 8),
                CustomText(
                  "${tools.length} tools available",
                  variant: TextVariant.bodySmall,
                  color: secondaryDark,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ),
          div(styles: Styles(raw: {'height': '1px', 'background-color': lineGrey.value}), []),

          // Tool tiles
          ...List.generate(tools.length * 2 - 1, (index) {
            if (index.isOdd) {
              return div(
                styles: Styles(raw: {
                  'height': '1px',
                  'background-color': lineGrey.value,
                  'margin-left': '60px',
                }),
                [],
              );
            }
            return _buildToolTile(context, tools[index ~/ 2]);
          }),
        ],
      ),
    );
  }

  Component _buildToolTile(BuildContext context, _ToolItem tool) {
    return div(
      events: {
        'click': (event) => tool.onTap(),
      },
      classes: 'tool-tile',
      styles: Styles(raw: {
        'padding': '16px',
        'display': 'flex',
        'align-items': 'center',
        'cursor': 'pointer',
        'transition': 'background-color 0.2s ease',
      }),
      [
        // Ring-bordered icon
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          style: Styles(raw: {
            'background-color': '${tool.color.value}14', // 8%
            'border': '1.5px solid ${tool.color.value}33', // 20%
            'display': 'flex',
            'justify-content': 'center',
            'align-items': 'center',
          }),
          child: img(
            src: tool.icon,
            styles: Styles(raw: {
              'width': '20px',
              'height': '20px',
            }),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: CustomText(
                      tool.title,
                      fontWeight: FontWeight.w600,
                      variant: TextVariant.body,
                      color: primaryDark,
                    ),
                  ),
                  const SizedBox(width: 6),
                  // Category tag
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    style: Styles(raw: {
                      'background-color': '${tool.color.value}1A',
                    }),
                    child: CustomText(
                      tool.tag,
                      variant: TextVariant.caption,
                      color: tool.color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 3),
              CustomText(
                tool.subtitle,
                variant: TextVariant.bodySmall,
                color: secondaryDark,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
          ),
          style: Styles(raw: {
            'background-color': lineGrey.value,
            'display': 'flex',
            'justify-content': 'center',
            'align-items': 'center',
          }),
          child: img(
            src: AssetsConst.featherChevronRight,
            styles: Styles(raw: {'width': '14px', 'height': '14px'}),
          ),
        ),
      ],
    );
  }
}

class _ToolItem {
  final String icon;
  final String title;
  final String subtitle;
  final Color color;
  final String tag;
  final VoidCallback onTap;

  const _ToolItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.tag,
    required this.onTap,
  });
}
