import 'device_contact_service.dart';

class DeviceIntentResult {
  final bool isHandled;
  final String actionCardMarkdown;
  final Uri? autoLaunchUri;

  const DeviceIntentResult({
    required this.isHandled,
    required this.actionCardMarkdown,
    this.autoLaunchUri,
  });

  static const DeviceIntentResult notHandled = DeviceIntentResult(
    isHandled: false,
    actionCardMarkdown: '',
  );
}

class DeviceIntentService {
  static Future<DeviceIntentResult> processIntent(String rawQuery) async {
    final query = rawQuery.trim();
    final lower = query.toLowerCase();

    // 1. YouTube & Media Intent
    if (lower.contains('youtube') ||
        lower.startsWith('play ') ||
        (lower.contains('play') &&
            (lower.contains('song') ||
                lower.contains('music') ||
                lower.contains('video')))) {
      String search = query;
      if (lower.startsWith('play ')) {
        search = query.length > 5 ? query.substring(5) : 'music';
      }
      search = search
          .replaceAll(
              RegExp(r'\b(in|on|at|from|with|via)\s+youtube\b',
                  caseSensitive: false),
              '')
          .replaceAll(RegExp(r'\byoutube\b', caseSensitive: false), '')
          .replaceAll(RegExp(r'\bplay\b', caseSensitive: false), '')
          .trim();
      if (search.isEmpty) search = 'music';

      final encodedSearch = Uri.encodeComponent(search);
      final youtubeUrl =
          'https://www.youtube.com/results?search_query=$encodedSearch';

      final card = StringBuffer()
        ..writeln('🎬 **YouTube Search for "$search"**')
        ..writeln()
        ..writeln('Direct YouTube action links to play the track:')
        ..writeln('- ⏯️ **[Play "$search" on YouTube]($youtubeUrl)**')
        ..writeln(
            '- 🎵 **[Open YouTube Music](https://music.youtube.com/search?q=$encodedSearch)**');

      return DeviceIntentResult(
        isHandled: true,
        actionCardMarkdown: card.toString(),
        autoLaunchUri: Uri.parse(youtubeUrl),
      );
    }

    // 2. Call / Contact Intent
    if (lower.startsWith('call') ||
        lower.startsWith('dial') ||
        lower.contains('mother') ||
        lower.contains('mom') ||
        lower.contains('phone number') ||
        lower.contains('contact directory')) {
      String searchName = 'Mother';
      if (lower.startsWith('call')) {
        searchName = query.length > 4 ? query.substring(4).trim() : 'Mother';
      } else if (lower.startsWith('dial')) {
        searchName = query.length > 4 ? query.substring(4).trim() : 'Mother';
      }
      if (searchName.isEmpty || searchName.toLowerCase() == 'me') {
        searchName = 'Mother';
      }

      final numericOnly = searchName.replaceAll(RegExp(r'[^\d\+]'), '');
      Uri? autoUri;

      if (numericOnly.length >= 3) {
        autoUri = Uri.parse('tel:$numericOnly');
      }

      final contacts = await DeviceContactService.searchContacts(searchName);
      if (autoUri == null &&
          contacts.length == 1 &&
          contacts.first.phones.length == 1) {
        final numClean = contacts.first.phones.first.number
            .replaceAll(RegExp(r'[^\d\+]'), '');
        if (numClean.isNotEmpty) {
          autoUri = Uri.parse('tel:$numClean');
        }
      }

      final card = DeviceContactService.generateCallActionCard(query, contacts);

      return DeviceIntentResult(
        isHandled: true,
        actionCardMarkdown: card,
        autoLaunchUri: autoUri,
      );
    }

    // 3. Maps Intent
    if (lower.contains('maps') ||
        lower.startsWith('directions to') ||
        lower.startsWith('navigate to') ||
        lower.startsWith('location of')) {
      String location = query
          .replaceAll(
              RegExp(
                  r'\b(open|show|get|directions to|navigate to|location of|maps)\b',
                  caseSensitive: false),
              '')
          .trim();
      if (location.isEmpty) location = 'current location';

      final encodedLocation = Uri.encodeComponent(location);
      final mapsUrl = 'https://maps.google.com/?q=$encodedLocation';

      final card = StringBuffer()
        ..writeln('🗺️ **Google Maps Search for "$location"**')
        ..writeln()
        ..writeln('- 📍 **[Open "$location" in Google Maps]($mapsUrl)**');

      return DeviceIntentResult(
        isHandled: true,
        actionCardMarkdown: card.toString(),
        autoLaunchUri: Uri.parse(mapsUrl),
      );
    }

    // 4. WhatsApp Intent
    if (lower.contains('whatsapp')) {
      final numericOnly = query.replaceAll(RegExp(r'[^\d\+]'), '');
      final hasNumber = numericOnly.length >= 3;
      final waUrl = hasNumber ? 'https://wa.me/$numericOnly' : 'https://wa.me/';

      final card = StringBuffer()
        ..writeln('💬 **WhatsApp Assistant**')
        ..writeln()
        ..writeln(hasNumber
            ? '- 📱 **[Chat with $numericOnly on WhatsApp]($waUrl)**'
            : '- 📱 **[Open WhatsApp]($waUrl)**');

      return DeviceIntentResult(
        isHandled: true,
        actionCardMarkdown: card.toString(),
        autoLaunchUri: Uri.parse(waUrl),
      );
    }

    // 5. App Store / Download Intent
    if (lower.startsWith('install') ||
        lower.startsWith('download') ||
        lower.contains('play store') ||
        lower.contains('app store')) {
      String appName = query
          .replaceAll(
              RegExp(
                  r'\b(install|download|get|app|from|on|play store|app store)\b',
                  caseSensitive: false),
              '')
          .trim();
      if (appName.isEmpty) appName = 'apps';

      final encodedAppName = Uri.encodeComponent(appName);
      final storeUrl = 'https://play.google.com/store/search?q=$encodedAppName';

      final card = StringBuffer()
        ..writeln('🛍️ **App Store Installation for "$appName"**')
        ..writeln()
        ..writeln(
            '- 📱 **[Search "$appName" on Google Play Store]($storeUrl)**');

      return DeviceIntentResult(
        isHandled: true,
        actionCardMarkdown: card.toString(),
        autoLaunchUri: Uri.parse(storeUrl),
      );
    }

    return DeviceIntentResult.notHandled;
  }
}
