import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jci/fitness_club/models/fitness_story_model.dart';
import 'package:jci/fitness_club/services/story_seen_service.dart';
import 'package:jci/fitness_club/utils/story_time.dart';

class StoryViewer extends StatefulWidget {
  const StoryViewer({
    super.key,
    required this.groups,
    required this.initialGroupIndex,
    this.initialStoryIndex = 0,
  });

  final List<MemberStoryGroup> groups;
  final int initialGroupIndex;
  final int initialStoryIndex;

  @override
  State<StoryViewer> createState() => _StoryViewerState();
}

class _StoryViewerState extends State<StoryViewer> {
  late int _groupIndex;
  late int _storyIndex;
  Timer? _timer;
  double _progress = 0;

  @override
  void initState() {
    super.initState();
    _groupIndex = widget.initialGroupIndex;
    _storyIndex = widget.initialStoryIndex.clamp(
      0,
      widget.groups[widget.initialGroupIndex].stories.length - 1,
    );
    _startTimer();
    _markCurrentStorySeen();
  }

  void _markStorySeen(int groupIndex, int storyIndex) {
    if (groupIndex < 0 ||
        groupIndex >= widget.groups.length ||
        storyIndex < 0 ||
        storyIndex >= widget.groups[groupIndex].stories.length) return;
    final story = widget.groups[groupIndex].stories[storyIndex];
    // Fire-and-forget; we only need persistence.
    unawaited(StorySeenService.markStorySeen(story.id));
  }

  void _markCurrentStorySeen() => _markStorySeen(_groupIndex, _storyIndex);

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  MemberStoryGroup get _group => widget.groups[_groupIndex];
  FitnessStoryItem get _story => _group.stories[_storyIndex];

  void _startTimer() {
    _timer?.cancel();
    _progress = 0;
    _timer = Timer.periodic(const Duration(milliseconds: 50), (t) {
      if (!mounted) return;
      setState(() => _progress += 0.01);
      if (_progress >= 1) {
        _next();
      }
    });
  }

  void _next() {
    if (_storyIndex < _group.stories.length - 1) {
      setState(() => _storyIndex++);
      _markCurrentStorySeen();
      _startTimer();
      return;
    }
    Navigator.pop(context);
  }

  void _prev() {
    if (_storyIndex > 0) {
      setState(() => _storyIndex--);
      _markCurrentStorySeen();
      _startTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTapUp: (details) {
          final w = MediaQuery.of(context).size.width;
          if (details.globalPosition.dx < w / 2) {
            _prev();
          } else {
            _next();
          }
        },
        onVerticalDragEnd: (details) {
          if (details.primaryVelocity != null && details.primaryVelocity! > 200) {
            Navigator.pop(context);
          }
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            Center(
              child: CachedNetworkImage(
                imageUrl: _story.imageUrl,
                fit: BoxFit.contain,
                width: double.infinity,
                height: double.infinity,
                placeholder: (_, __) => const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: Row(
                      children: List.generate(_group.stories.length, (i) {
                        final value = i < _storyIndex
                            ? 1.0
                            : i == _storyIndex
                                ? _progress
                                : 0.0;
                        return Expanded(
                          child: Container(
                            height: 3,
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: value.clamp(0.0, 1.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: const Color(0xFF24B9EC),
                          backgroundImage: _story.imageUrl.isNotEmpty
                              ? CachedNetworkImageProvider(_story.imageUrl)
                              : (_group.profilePic != null && _group.profilePic!.isNotEmpty
                                  ? CachedNetworkImageProvider(_group.profilePic!)
                                  : null),
                          child: _story.imageUrl.isEmpty &&
                                  (_group.profilePic == null || _group.profilePic!.isEmpty)
                              ? const Icon(Icons.person, color: Colors.white, size: 18)
                              : null,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _group.memberName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'pop-semibold',
                                  fontSize: 15,
                                ),
                              ),
                              if (_story.createdAt != null)
                                Text(
                                  StoryTime.uploadedLabel(_story.createdAt),
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.8),
                                    fontFamily: 'pop-reg',
                                    fontSize: 12,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
