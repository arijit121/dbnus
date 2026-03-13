import 'package:dbnus/shared/ui/atoms/text/custom_text.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/search_place.dart';

class SearchResultsDropdown extends StatelessWidget {
  final List<SearchPlace> results;
  final ValueChanged<SearchPlace> onPlaceSelected;

  const SearchResultsDropdown({
    super.key,
    required this.results,
    required this.onPlaceSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 6),
      constraints: const BoxConstraints(maxHeight: 280),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: ListView.separated(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 6),
          itemCount: results.length,
          separatorBuilder: (_, __) => const Divider(
            height: 1,
            indent: 56,
            endIndent: 16,
            color: Color(0xFFF1F3F4),
          ),
          itemBuilder: (context, index) {
            final place = results[index];
            return ListTile(
              dense: true,
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F3F4),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(FeatherIcons.mapPin,
                    size: 16, color: Color(0xFF5F6368)),
              ),
              title: CustomText(
                place.title,
                color: const Color(0xFF202124),
                size: 14,
                fontWeight: FontWeight.w500,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: CustomText(
                place.shortAddress,
                color: const Color(0xFF9AA0A6),
                size: 12,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () => onPlaceSelected(place),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            );
          },
        ),
      ),
    );
  }
}
