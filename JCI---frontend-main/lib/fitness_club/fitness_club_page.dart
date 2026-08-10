import 'dart:async';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jci/fitness_club/models/fitness_story_model.dart';
import 'package:jci/fitness_club/services/fitness_story_service.dart';
import 'package:jci/fitness_club/services/story_seen_service.dart';
import 'package:jci/fitness_club/story_viewer.dart';
import 'package:jci/fitness_club/utils/story_time.dart';
import 'package:jci/fitness_club/widgets/status_list_tile.dart';
import 'package:jci/referral/services/session_service.dart';
import 'package:jci/referral/widgets/referral_theme.dart';

class FitnessClubPage extends StatefulWidget {
  const FitnessClubPage({super.key});

  @override
  State<FitnessClubPage> createState() => _FitnessClubPageState();
}

class _FitnessClubPageState extends State<FitnessClubPage> {
  List<MemberStoryGroup> _groups = [];
  int? _myId;
  bool _loading = true;
  bool _uploading = false;
  bool _hasFullAccess = false;
  Set<int> _seenStoryIds = {};
  Timer? _timeTicker;

  @override
  void initState() {
    super.initState();
    _init();
    _timeTicker = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timeTicker?.cancel();
    super.dispose();
  }

  Future<void> _init() async {
    await _load();
    await _loadSeen();
  }

  Future<void> _load() async {
    _myId = await SessionService.getMemberId();
    _hasFullAccess = await SessionService.hasFullAccess();
    try {
      final groups = await FitnessStoryService.getStories();
      final filtered = groups
          .map((g) => MemberStoryGroup(
                memberId: g.memberId,
                memberName: g.memberName,
                profilePic: g.profilePic,
                stories: g.stories.where((s) => s.imageUrl.isNotEmpty).toList(),
              ))
          .where((g) => g.stories.isNotEmpty)
          .toList();
      final activeIds = filtered.expand((g) => g.stories.map((s) => s.id)).toSet();
      await StorySeenService.pruneSeenIds(activeIds);
      if (mounted) {
        setState(() {
          _groups = filtered;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
        _snack('$e');
      }
    }
  }

  Future<void> _loadSeen() async {
    final seen = await StorySeenService.getSeenStoryIds();
    if (mounted) setState(() => _seenStoryIds = seen);
  }

  Future<void> _addStory() async {
    final allowed = await SessionService.hasFullAccess();
    if (!mounted) return;
    setState(() => _hasFullAccess = allowed);
    if (!allowed) {
      _snack('View only — ask admin for access');
      return;
    }
    final picker = ImagePicker();
    final picked = await picker.pickMultiImage(imageQuality: 80);
    if (picked.isEmpty) return;

    setState(() => _uploading = true);
    try {
      final count = await FitnessStoryService.uploadStoriesFromXFiles(picked);
      _snack(count == 1 ? 'Story uploaded!' : '$count stories uploaded!');
      await _load();
    } catch (e) {
      final msg = e.toString().startsWith('Exception: ')
          ? e.toString().substring(11)
          : e.toString();
      _snack(msg);
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  Future<void> _openStories(int index, {int storyIndex = 0}) async {
    final group = _groups[index];
    if (group.stories.isEmpty) return;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StoryViewer(
          groups: [group],
          initialGroupIndex: 0,
          initialStoryIndex: storyIndex,
        ),
      ),
    );
    await _load();
    await _loadSeen();
  }

  void _snack(String m) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
  }

  MemberStoryGroup? get _myGroup {
    if (_myId == null) return null;
    for (final g in _groups) {
      if (g.memberId == _myId) return g;
    }
    return null;
  }

  String? _storyThumb(MemberStoryGroup? group) {
    if (group == null || group.stories.isEmpty) return null;
    return group.stories.last.imageUrl;
  }

  bool _hasUnseen(MemberStoryGroup group) {
    return group.stories.any((s) => !_seenStoryIds.contains(s.id));
  }

  int _unseenCount(MemberStoryGroup group) {
    return group.stories.where((s) => !_seenStoryIds.contains(s.id)).length;
  }

  List<MemberStoryGroup> get _otherGroups {
    if (_myId == null) return _groups;
    final list = _groups.where((g) => g.memberId != _myId).toList();
    list.sort((a, b) {
      final aUnseen = _hasUnseen(a);
      final bUnseen = _hasUnseen(b);
      if (aUnseen != bUnseen) return aUnseen ? -1 : 1;
      final aTime = a.stories.last.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bTime = b.stories.last.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bTime.compareTo(aTime);
    });
    return list;
  }

  void _onMyStatusTap() {
    if (_myGroup != null && _myGroup!.stories.isNotEmpty) {
      final idx = _groups.indexWhere((g) => g.memberId == _myId);
      if (idx >= 0) _openStories(idx);
    } else if (_hasFullAccess) {
      _addStory();
    } else {
      _snack('View only — ask admin for access');
    }
  }

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 4),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'pop-med',
          fontSize: 14,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final myGroup = _myGroup;
    final others = _otherGroups;
    final unseen = others.where(_hasUnseen).toList();
    final viewed = others.where((g) => !_hasUnseen(g)).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: ReferralTheme.darkBlue,
        elevation: 0,
        title: const Text(
          'Fitness Club',
          style: TextStyle(fontFamily: 'pop-semibold', color: Colors.white, fontSize: 20),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: ReferralTheme.lightBlue))
          : RefreshIndicator(
              color: ReferralTheme.lightBlue,
              onRefresh: () async {
                await _load();
                await _loadSeen();
              },
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 8, bottom: 4),
                    child: Text(
                      'Status',
                      style: TextStyle(
                        fontFamily: 'pop-semibold',
                        fontSize: 18,
                        color: Color(0xFF111827),
                      ),
                    ),
                  ),
                  StatusListTile(
                    title: _hasFullAccess ? 'Add status' : 'My status',
                    subtitle: _hasFullAccess
                        ? 'Disappears after 24 hours'
                        : 'View only — ask admin for access',
                    imageUrl: _storyThumb(myGroup),
                    isAdd: myGroup == null || myGroup.stories.isEmpty,
                    showAddBadge: _hasFullAccess,
                    showBlueRing: false,
                    onTap: _uploading ? () {} : _onMyStatusTap,
                    onAddBadgeTap: (!_hasFullAccess || _uploading) ? null : _addStory,
                  ),
                  if (unseen.isNotEmpty) ...[
                    _sectionLabel('Recent updates'),
                    ...unseen.map((g) {
                      final idx = _groups.indexWhere((x) => x.memberId == g.memberId);
                      final latest = g.stories.last;
                      final unseenCount = _unseenCount(g);
                      return StatusListTile(
                        title: g.memberName,
                        subtitle: StoryTime.listTime(latest.createdAt),
                        imageUrl: _storyThumb(g),
                        showBlueRing: true,
                        storyCount: unseenCount.clamp(1, 6),
                        onTap: () => _openStories(idx),
                      );
                    }),
                  ],
                  if (viewed.isNotEmpty) ...[
                    _sectionLabel('Viewed updates'),
                    ...viewed.map((g) {
                      final idx = _groups.indexWhere((x) => x.memberId == g.memberId);
                      final latest = g.stories.last;
                      return StatusListTile(
                        title: g.memberName,
                        subtitle: StoryTime.listTime(latest.createdAt),
                        imageUrl: _storyThumb(g),
                        showBlueRing: false,
                        onTap: () => _openStories(idx),
                      );
                    }),
                  ],
                  if (others.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 32),
                      child: Center(
                        child: Text(
                          'No status updates from others yet',
                          style: TextStyle(
                            fontFamily: 'pop-reg',
                            fontSize: 14,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
      floatingActionButton: _hasFullAccess
          ? FloatingActionButton(
              backgroundColor: ReferralTheme.lightBlue,
              elevation: 4,
              onPressed: _uploading ? null : _addStory,
              child: _uploading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 26),
            )
          : null,
    );
  }
}
