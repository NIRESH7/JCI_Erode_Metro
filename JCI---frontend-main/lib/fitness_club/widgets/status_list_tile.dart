import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class StatusAvatar extends StatelessWidget {
  const StatusAvatar({
    super.key,
    required this.imageUrl,
    this.showBlueRing = false,
    this.storyCount = 1,
    this.isAdd = false,
    this.showAddBadge = false,
    this.onAddBadgeTap,
    this.size = 54,
  });

  final String? imageUrl;
  final bool showBlueRing;
  final int storyCount;
  final bool isAdd;
  final bool showAddBadge;
  final VoidCallback? onAddBadgeTap;
  final double size;

  static const _blue = Color(0xFF24B9EC);
  static const _ringStroke = 2.0;
  static const _ringGap = 3.0;

  double get _ringCenterRadius => size / 2 + _ringGap + _ringStroke / 2;
  double get _outerSize => size + 2 * (_ringGap + _ringStroke);
  double get _boxSize => _outerSize + (showAddBadge ? 8 : 0);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _boxSize,
      height: _boxSize,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          if (showBlueRing)
            SizedBox(
              width: _outerSize,
              height: _outerSize,
              child: CustomPaint(
                painter: _StatusRingPainter(
                  radius: _ringCenterRadius,
                  strokeWidth: _ringStroke,
                  segments: _ringSegments,
                ),
              ),
            ),
          SizedBox(
            width: size,
            height: size,
            child: ClipOval(child: _innerImage()),
          ),
          if (showAddBadge)
            Positioned(
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: onAddBadgeTap,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: _blue,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2.5),
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 15),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// 1 story = full ring. 2+ stories = that many neat arc segments.
  int get _ringSegments => storyCount.clamp(1, 6);

  Widget _innerImage() {
    if (isAdd) {
      return Container(
        color: const Color(0xFFF0F4F8),
        child: const Icon(Icons.person_outline, color: Color(0xFF9CA3AF), size: 28),
      );
    }
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: imageUrl!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorWidget: (_, __, ___) => _placeholder(),
      );
    }
    return _placeholder();
  }

  Widget _placeholder() {
    return Container(
      color: const Color(0xFFE8F4FC),
      child: const Icon(Icons.person_outline, color: Color(0xFF8AA8C4), size: 26),
    );
  }
}

class _StatusRingPainter extends CustomPainter {
  _StatusRingPainter({
    required this.radius,
    required this.strokeWidth,
    required this.segments,
  });

  final double radius;
  final double strokeWidth;
  final int segments;

  static const _blue = Color(0xFF24B9EC);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final rect = Rect.fromCircle(center: center, radius: radius);

    final paint = Paint()
      ..color = _blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true;

    if (segments <= 1) {
      canvas.drawCircle(center, radius, paint);
      return;
    }

    if (segments == 2) {
      _paintTwoRounds(canvas, rect, paint);
      return;
    }

    const gapRadians = 0.14;
    final segmentAngle = (2 * math.pi) / segments;
    final arcSweep = segmentAngle - gapRadians;

    for (var i = 0; i < segments; i++) {
      final start = -math.pi / 2 + (segmentAngle * i) + (gapRadians / 2);
      canvas.drawArc(rect, start, arcSweep, false, paint);
    }
  }

  void _paintTwoRounds(Canvas canvas, Rect rect, Paint paint) {
    const gap = 0.24;
    const arcSweep = math.pi - gap;

    const round1Start = -math.pi / 2 + math.pi / 6 + gap / 2;
    canvas.drawArc(rect, round1Start, arcSweep, false, paint);

    const round2Start = round1Start + arcSweep + gap;
    canvas.drawArc(rect, round2Start, arcSweep, false, paint);
  }

  @override
  bool shouldRepaint(covariant _StatusRingPainter oldDelegate) {
    return oldDelegate.radius != radius ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.segments != segments;
  }
}

class StatusListTile extends StatelessWidget {
  const StatusListTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.imageUrl,
    this.showBlueRing = false,
    this.storyCount = 1,
    this.isAdd = false,
    this.showAddBadge = false,
    this.onAddBadgeTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final String? imageUrl;
  final bool showBlueRing;
  final int storyCount;
  final bool isAdd;
  final bool showAddBadge;
  final VoidCallback? onAddBadgeTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            StatusAvatar(
              imageUrl: imageUrl,
              showBlueRing: showBlueRing,
              storyCount: storyCount,
              isAdd: isAdd,
              showAddBadge: showAddBadge,
              onAddBadgeTap: onAddBadgeTap,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'pop-med',
                      fontSize: 16,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontFamily: 'pop-reg',
                      fontSize: 13,
                      color: Colors.grey.shade600,
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
