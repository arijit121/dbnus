import 'package:dbnus/navigation/custom_router/custom_route.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';

class MapSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isSearching;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const MapSearchBar({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.isSearching,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: IconButton(
              icon: const Icon(FeatherIcons.arrowLeft, size: 20),
              color: const Color(0xFF5F6368),
              onPressed: () => CustomRoute.back(),
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              onChanged: onChanged,
              decoration: const InputDecoration(
                hintText: 'Search places...',
                hintStyle: TextStyle(color: Color(0xFF9AA0A6), fontSize: 15),
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 8, vertical: 14),
              ),
              style: const TextStyle(fontSize: 15, color: Color(0xFF202124)),
            ),
          ),
          if (isSearching)
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Color(0xFF4285F4)),
              ),
            )
          else if (controller.text.isNotEmpty)
            IconButton(
              icon: const Icon(FeatherIcons.x,
                  size: 18, color: Color(0xFF5F6368)),
              onPressed: onClear,
            ),
        ],
      ),
    );
  }
}
