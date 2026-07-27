import 'dart:async';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jci/referral/services/session_service.dart';

/// Stores "seen" fitness story ids on the device for the current member.
class StorySeenService {
  static const _storage = FlutterSecureStorage();

  static Future<String> _key() async {
    final memberId = await SessionService.getMemberId();
    return 'fitness_story_seen_v2_${memberId ?? 0}';
  }

  static Future<Set<int>> getSeenStoryIds() async {
    final raw = await _storage.read(key: await _key());
    if (raw == null || raw.trim().isEmpty) return <int>{};
    try {
      final decoded = json.decode(raw);
      if (decoded is List) {
        return decoded.map((e) => int.parse('${e}')).toSet();
      }
    } catch (_) {
      // ignore corrupted cache
    }
    return <int>{};
  }

  static Future<void> markStorySeen(int storyId) async {
    final set = await getSeenStoryIds();
    if (!set.contains(storyId)) {
      set.add(storyId);
      await _storage.write(key: await _key(), value: json.encode(set.toList()));
    }
  }

  /// Drop seen ids for stories that no longer exist on the server.
  static Future<void> pruneSeenIds(Set<int> activeStoryIds) async {
    final set = await getSeenStoryIds();
    final pruned = set.where(activeStoryIds.contains).toSet();
    if (pruned.length != set.length) {
      await _storage.write(key: await _key(), value: json.encode(pruned.toList()));
    }
  }
}

