import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Resolves the backend base URL for the current platform.
class ApiConfig {
  static String get baseUrl {
    final fromEnv = dotenv.maybeGet('URL');
    if (fromEnv != null && fromEnv.trim().isNotEmpty) {
      return fromEnv.trim();
    }
    if (kIsWeb) return 'http://localhost:3002';
    if (Platform.isAndroid) return 'http://10.0.2.2:3002';
    return 'http://localhost:3002';
  }

  /// Turns API image paths into URLs reachable from the phone/emulator.
  static String resolveMediaUrl(String? url) {
    if (url == null || url.isEmpty || url == 'null') return '';
    final trimmed = url.trim();
    if (trimmed.contains('placeholder.jpg')) return '';

    if (trimmed.startsWith('http')) {
      final uri = Uri.tryParse(trimmed);
      if (uri != null && uri.host.isNotEmpty && _shouldRewriteHost(uri.host)) {
        final base = Uri.parse(baseUrl);
        return '${base.scheme}://${base.host}:${base.hasPort ? base.port : 3002}${uri.path}';
      }
      return trimmed;
    }

    return '$baseUrl$trimmed';
  }

  static bool _shouldRewriteHost(String host) {
    if (host == 'localhost' || host == '127.0.0.1') return true;
    if (host.startsWith('192.168.') || host.startsWith('10.')) return true;
    return false;
  }
}
