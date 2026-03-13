import 'package:dbnus/shared/extensions/spacing.dart';
import 'package:dbnus/shared/ui/atoms/text/custom_text.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';

class DirectionsPanel extends StatelessWidget {
  final TextEditingController fromController;
  final TextEditingController toController;
  final FocusNode fromFocusNode;
  final FocusNode toFocusNode;
  final bool isSearching;
  final bool isFromSearch;
  final bool usingCurrentLocation;
  final bool loadingLocation;
  final ValueChanged<String> onFromChanged;
  final ValueChanged<String> onToChanged;
  final VoidCallback onClearRoute;
  final VoidCallback onUseCurrentLocation;

  const DirectionsPanel({
    super.key,
    required this.fromController,
    required this.toController,
    required this.fromFocusNode,
    required this.toFocusNode,
    required this.isSearching,
    required this.isFromSearch,
    required this.usingCurrentLocation,
    this.loadingLocation = false,
    required this.onFromChanged,
    required this.onToChanged,
    required this.onClearRoute,
    required this.onUseCurrentLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(FeatherIcons.arrowLeft, size: 20),
                  color: const Color(0xFF5F6368),
                  onPressed: onClearRoute,
                ),
                const Spacer(),
                const CustomText(
                  'Directions',
                  color: Color(0xFF202124),
                  fontWeight: FontWeight.w600,
                  size: 16,
                ),
                const Spacer(),
                const SizedBox(width: 48),
              ],
            ),
          ),
          // From field
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: const Color(0xFF34A853),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
                12.pw,
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F3F4),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: fromController,
                            focusNode: fromFocusNode,
                            onChanged: onFromChanged,
                            decoration: const InputDecoration(
                              hintText: 'Choose starting point',
                              hintStyle: TextStyle(
                                  color: Color(0xFF9AA0A6), fontSize: 14),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 12),
                            ),
                            style: const TextStyle(
                                fontSize: 14, color: Color(0xFF202124)),
                          ),
                        ),
                        if (isSearching && isFromSearch)
                          const Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Color(0xFF4285F4)),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 21.5),
            child: Column(
              children: List.generate(
                3,
                (_) => Container(
                  width: 3,
                  height: 3,
                  margin: const EdgeInsets.symmetric(vertical: 1.5),
                  decoration: const BoxDecoration(
                    color: Color(0xFFDADCE0),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
          // To field
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEA4335),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
                12.pw,
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F3F4),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: toController,
                            focusNode: toFocusNode,
                            onChanged: onToChanged,
                            decoration: const InputDecoration(
                              hintText: 'Choose destination',
                              hintStyle: TextStyle(
                                  color: Color(0xFF9AA0A6), fontSize: 14),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 12),
                            ),
                            style: const TextStyle(
                                fontSize: 14, color: Color(0xFF202124)),
                          ),
                        ),
                        if (isSearching && !isFromSearch)
                          const Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Color(0xFF4285F4)),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          8.ph,
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: GestureDetector(
              onTap: onUseCurrentLocation,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: usingCurrentLocation
                      ? const Color(0xFF4285F4).withValues(alpha: 0.1)
                      : const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: usingCurrentLocation
                        ? const Color(0xFF4285F4).withValues(alpha: 0.3)
                        : const Color(0xFFE8EAED),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      FeatherIcons.crosshair,
                      size: 16,
                      color: usingCurrentLocation
                          ? const Color(0xFF4285F4)
                          : const Color(0xFF5F6368),
                    ),
                    8.pw,
                    CustomText(
                      'Use my current location',
                      color: usingCurrentLocation
                          ? const Color(0xFF4285F4)
                          : const Color(0xFF5F6368),
                      size: 13,
                      fontWeight: usingCurrentLocation
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                    if (loadingLocation) ...[
                      const Spacer(),
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Color(0xFF4285F4)),
                      ),
                    ] else if (usingCurrentLocation) ...[
                      const Spacer(),
                      const Icon(FeatherIcons.check,
                          size: 16, color: Color(0xFF4285F4)),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
