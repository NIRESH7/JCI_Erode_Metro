import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class StoryRing extends StatelessWidget {
  const StoryRing({
    super.key,
    required this.label,
    required this.onTap,
    this.imageUrl,
    this.isAdd = false,
    this.hasStory = false,
    this.isSeen = false,
    this.hideImageWhenSeen = true,
    this.size = 72,
  });

  final String label;
  final VoidCallback onTap;
  final String? imageUrl;
  final bool isAdd;
  final bool hasStory;
  final bool isSeen;
  final bool hideImageWhenSeen;
  final double size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: size + 8,
        child: Column(
          children: [
            Container(
              width: size,
              height: size,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: hasStory && !isSeen
                    ? const LinearGradient(
                        colors: [Color(0xFF24B9EC), Color(0xFF23346B), Color(0xFFE040FB)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                border: isAdd
                    ? Border.all(color: const Color(0xFF24B9EC), width: 2, style: BorderStyle.solid)
                    : (!hasStory
                        ? Border.all(color: Colors.grey.shade300, width: 2)
                        : isSeen
                            ? Border.all(color: Colors.black.withValues(alpha: 0.45), width: 2)
                            : null),
              ),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(2),
                child: ClipOval(
                  child: isAdd
                      ? Container(
                          color: const Color(0xFFF4F8FC),
                          child: const Icon(Icons.add_a_photo, color: Color(0xFF24B9EC)),
                        )
                      : imageUrl != null && imageUrl!.isNotEmpty
                          ? (isSeen && hideImageWhenSeen
                              ? _placeholder()
                              : CachedNetworkImage(
                                  imageUrl: imageUrl!,
                                  fit: BoxFit.cover,
                                  errorWidget: (_, __, ___) => _placeholder(),
                                ))
                          : _placeholder(),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(fontFamily: 'pop-med', fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      color: const Color(0xFFE8F4FC),
      child: const Icon(Icons.person, color: Color(0xFF23346B)),
    );
  }
}
