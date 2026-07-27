import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jci/fitness_club/models/fitness_story_model.dart';
import 'package:jci/fitness_club/utils/story_time.dart';
import 'package:jci/referral/widgets/referral_theme.dart';

class ViewedMemberTile extends StatelessWidget {
  const ViewedMemberTile({
    super.key,
    required this.group,
    required this.seenStories,
    required this.onTap,
  });

  final MemberStoryGroup group;
  final List<FitnessStoryItem> seenStories;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final latest = seenStories.isNotEmpty ? seenStories.last : group.stories.last;
    final thumb = latest.imageUrl;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade400, width: 2),
                ),
                child: ClipOval(
                  child: thumb.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: thumb,
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
                      group.memberName,
                      style: const TextStyle(
                        fontFamily: 'pop-semibold',
                        fontSize: 15,
                        color: ReferralTheme.darkBlue,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${seenStories.length} ${seenStories.length == 1 ? 'story' : 'stories'} viewed',
                      style: TextStyle(
                        fontFamily: 'pop-reg',
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    if (latest.createdAt != null)
                      Text(
                        StoryTime.uploadedLabel(latest.createdAt),
                        style: TextStyle(
                          fontFamily: 'pop-reg',
                          fontSize: 11,
                          color: Colors.grey.shade500,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      color: const Color(0xFFE8F4FC),
      child: const Icon(Icons.person_outline, color: Color(0xFF8AA8C4)),
    );
  }
}
