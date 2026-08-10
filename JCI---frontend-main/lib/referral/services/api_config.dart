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

    final base = Uri.parse(baseUrl);

    if (trimmed.startsWith('http')) {
      final uri = Uri.tryParse(trimmed);
      if (uri == null || uri.host.isEmpty) return trimmed;

      // Already points at the configured API host — keep as-is (do not force :3002).
      if (_sameApiHost(uri, base)) {
        return trimmed;
      }

      // Rewrite localhost / LAN / old deploy hosts onto the current API base.
      if (_shouldRewriteHost(uri.host)) {
        return _joinBasePath(base, uri.path);
      }
      return trimmed;
    }

    final path = trimmed.startsWith('/') ? trimmed : '/$trimmed';
    return _joinBasePath(base, path);
  }

  static String _joinBasePath(Uri base, String path) {
    final normalized = path.startsWith('/') ? path : '/$path';
    if (base.hasPort) {
      return '${base.scheme}://${base.host}:${base.port}$normalized';
    }
    return '${base.scheme}://${base.host}$normalized';
  }

  static bool _sameApiHost(Uri media, Uri base) {
    return media.host.toLowerCase() == base.host.toLowerCase();
  }

  static bool _shouldRewriteHost(String host) {
    final h = host.toLowerCase();
    if (h == 'localhost' || h == '127.0.0.1') return true;
    if (h.startsWith('192.168.') || h.startsWith('10.')) return true;
    if (h.contains('jcierodemetro') || h.contains('jcierodegreencity')) return true;
    return false;
  }
}
