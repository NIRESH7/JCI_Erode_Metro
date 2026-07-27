import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jci/fitness_club/models/fitness_story_model.dart';
import 'package:jci/fitness_club/utils/story_time.dart';
import 'package:jci/referral/widgets/referral_theme.dart';

class ViewedStoryTile extends StatelessWidget {
  const ViewedStoryTile({
    super.key,
    required this.memberName,
    required this.story,
    required this.onTap,
  });

  final String memberName;
  final FitnessStoryItem story;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE9EDF3)),
            ),
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    width: 56,
                    height: 56,
                    child: story.imageUrl.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: story.imageUrl,
                            fit: BoxFit.cover,
                            errorWidget: (_, __, ___) => _placeholder(),
                          )
                        : _placeholder(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        memberName,
                        style: const TextStyle(
                          fontFamily: 'pop-semibold',
                          fontSize: 14,
                          color: ReferralTheme.darkBlue,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        StoryTime.uploadedLabel(story.createdAt),
                        style: TextStyle(
                          fontFamily: 'pop-reg',
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      if (story.expiresAt != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          StoryTime.expiresLabel(story.expiresAt),
                          style: TextStyle(
                            fontFamily: 'pop-reg',
                            fontSize: 11,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 22),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      color: const Color(0xFFE8F4FC),
      child: const Icon(Icons.image_outlined, color: Color(0xFF8AA8C4)),
    );
  }
}
