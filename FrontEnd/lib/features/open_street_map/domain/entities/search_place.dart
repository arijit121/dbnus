class SearchPlace {
  final int? placeId;
  final String? displayName;
  final double? latitude;
  final double? longitude;
  final String? type;
  final String? category;
  final String? addressType;
  final String? name;

  SearchPlace({
    this.placeId,
    this.displayName,
    this.latitude,
    this.longitude,
    this.type,
    this.category,
    this.addressType,
    this.name,
  });

  String get title => (name?.isNotEmpty == true) ? name! : shortAddress;

  String get shortAddress {
    if (displayName == null) return '';
    final parts = displayName!.split(',');
    return parts.take(3).join(',').trim();
  }

  String get fullAddress => displayName ?? '';
}
