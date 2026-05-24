import 'package:dbnus/shared/extensions/spacing.dart';
import 'package:dbnus/shared/ui/atoms/text/custom_text.dart';
import 'package:dbnus/shared/constants/assects_const.dart';
import 'package:dbnus/shared/ui/atoms/images/custom_image.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/search_place.dart';

class PlaceDetailsCard extends StatelessWidget {
  final SearchPlace place;
  final VoidCallback? onClose;
  final VoidCallback? onDirections;

  const PlaceDetailsCard({
    super.key,
    required this.place,
    this.onClose,
    this.onDirections,
  });

  String _getCategoryIcon() {
    switch (place.category) {
      case 'amenity':
        return AssetsConst.featherCoffee;
      case 'tourism':
        return AssetsConst.featherCamera;
      case 'shop':
        return AssetsConst.featherShoppingBag;
      case 'highway':
        return AssetsConst.featherNavigation;
      case 'building':
        return AssetsConst.featherHome;
      case 'natural':
        return AssetsConst.featherSun;
      case 'leisure':
        return AssetsConst.featherHeart;
      case 'place':
        return AssetsConst.featherMapPin;
      default:
        return AssetsConst.featherMapPin;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with close button
          Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 8, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4285F4).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: CustomSvgAssetImageView(
                    path: _getCategoryIcon(),
                    color: const Color(0xFF4285F4),
                    height: 22, width: 22,
                  ),
                ),
                12.pw,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        place.title,
                        color: const Color(0xFF202124),
                        fontWeight: FontWeight.w600,
                        size: 16,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      4.ph,
                      if (place.type != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F0FE),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: CustomText(
                            place.type!.replaceAll('_', ' '),
                            color: const Color(0xFF4285F4),
                            size: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const CustomSvgAssetImageView(
                    path: AssetsConst.featherX,
                    color: Colors.grey,
                    height: 20, width: 20,
                  ),
                  onPressed: onClose,
                  color: Colors.grey,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minHeight: 36,
                    minWidth: 36,
                  ),
                ),
              ],
            ),
          ),
          // Address
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomSvgAssetImageView(path: AssetsConst.featherMapPin,
                    color: Color(0xFF5F6368), height: 16, width: 16),
                8.pw,
                Expanded(
                  child: CustomText(
                    place.fullAddress,
                    color: const Color(0xFF5F6368),
                    size: 13,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          // Coordinates
          if (place.latitude != null && place.longitude != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                children: [
                  const CustomSvgAssetImageView(path: AssetsConst.featherCrosshair,
                      color: Color(0xFF5F6368), height: 16, width: 16),
                  8.pw,
                  CustomText(
                    '${place.latitude!.toStringAsFixed(6)}, '
                    '${place.longitude!.toStringAsFixed(6)}',
                    color: const Color(0xFF5F6368),
                    size: 12,
                  ),
                ],
              ),
            ),
          14.ph,
          // Action button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onDirections,
                icon: const CustomSvgAssetImageView(
                  path: AssetsConst.featherNavigation2,
                  color: Colors.white,
                  height: 16, width: 16,
                ),
                label: const Text('Navigate',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4285F4),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
