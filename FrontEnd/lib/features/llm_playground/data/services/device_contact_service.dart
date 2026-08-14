import 'package:flutter/foundation.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class DeviceContactService {
  static Future<List<Contact>> searchContacts(String query) async {
    if (kIsWeb) return [];
    try {
      if (await FlutterContacts.permissions.request(PermissionType.readWrite) ==
          PermissionStatus.granted) {
        final contacts = await FlutterContacts.getAll(
          properties: {ContactProperty.photoThumbnail},
        );
        final lower = query.toLowerCase().trim();
        final isMomQuery =
            lower == 'mother' ||
            lower == 'mom' ||
            lower == 'mum' ||
            lower == 'ma';

        return contacts.where((c) {
          final displayName = c.displayName?.toLowerCase();
          final firstName = c.name?.first?.toLowerCase();
          final lastName = c.name?.last?.toLowerCase();

          final nameMatch =
              displayName?.contains(lower) == true ||
              firstName?.contains(lower) == true ||
              lastName?.contains(lower) == true;

          if (nameMatch) return true;

          if (isMomQuery) {
            return displayName?.contains('mother') == true ||
                displayName?.contains('mom') == true ||
                displayName?.contains('mum') == true ||
                firstName?.contains('mom') == true ||
                firstName?.contains('mother') == true;
          }

          return false;
        }).toList();
      }
    } catch (e) {
      debugPrint('DeviceContactService error: $e');
    }
    return [];
  }

  static String formatContactsForPrompt(List<Contact> contacts) {
    if (contacts.isEmpty) {
      return 'No matching contacts found in device phone directory.';
    }

    final sb = StringBuffer();
    sb.writeln('Found the following entries in device contacts directory:');
    for (final contact in contacts) {
      sb.writeln('- Contact: ${contact.displayName}');
      if (contact.phones.isEmpty) {
        sb.writeln('  (No phone numbers saved)');
      } else {
        for (final phone in contact.phones) {
          final label = phone.label.label.name.isEmpty == true
              ? phone.label.label.toString()
              : 'Phone';
          sb.writeln('  * $label: ${phone.number}');
        }
      }
    }
    return sb.toString();
  }

  static String generateCallActionCard(String query, List<Contact> contacts) {
    final sb = StringBuffer();
    final lower = query.toLowerCase().trim();

    String searchTarget = 'Mother';
    if (lower.contains('call ')) {
      final idx = lower.indexOf('call ');
      if (query.length > idx + 5) {
        searchTarget = query.substring(idx + 5).trim();
      }
    } else if (lower.contains('dial ')) {
      final idx = lower.indexOf('dial ');
      if (query.length > idx + 5) {
        searchTarget = query.substring(idx + 5).trim();
      }
    }
    if (searchTarget.isEmpty) searchTarget = 'Mother';

    final numericOnly = searchTarget.replaceAll(RegExp(r'[^\d\+]'), '');
    final isDirectNumber = numericOnly.length >= 3;

    sb.writeln('📞 **Contact Search Results for "$searchTarget"**');
    sb.writeln();

    if (isDirectNumber) {
      sb.writeln('Direct phone number action for **`$searchTarget`**:');
      sb.writeln();
      sb.writeln(
        '👉 **[Call $searchTarget](tel:$numericOnly)** | 💬 **[WhatsApp](https://wa.me/$numericOnly)**',
      );
    } else if (contacts.isEmpty) {
      sb.writeln(
        'No matching contact entry named "$searchTarget" was found in your device contacts directory.',
      );
      sb.writeln();
      sb.writeln(
        'You can place a direct call by entering the phone number below:',
      );
      sb.writeln('👉 **[Call Phone Number](tel:)**');
    } else {
      sb.writeln(
        'Found matching entries in your device contact directory. Select which number to call:',
      );
      sb.writeln();
      for (final contact in contacts) {
        sb.writeln('👤 **${contact.displayName}**');
        if (contact.phones.isEmpty) {
          sb.writeln('  *(No phone numbers saved)*');
        } else {
          for (final phone in contact.phones) {
            final cleanNum = phone.number.replaceAll(RegExp(r'[^\d\+]'), '');
            final label = phone.label.label.name.isNotEmpty
                ? phone.label.label.name
                : 'Phone';
            sb.writeln('- **$label**: `${phone.number}`');
            sb.writeln(
              '  👉 **[Call $label](tel:$cleanNum)** | 💬 **[WhatsApp](https://wa.me/$cleanNum)**',
            );
          }
        }
        sb.writeln();
      }
    }
    sb.writeln('---');
    sb.writeln();
    return sb.toString();
  }
}
