import 'package:jci/referral/services/api_config.dart';

class FitnessStoryItem {
  final int id;
  final String imageUrl;
  final DateTime? createdAt;
  final DateTime? expiresAt;

  FitnessStoryItem({
    required this.id,
    required this.imageUrl,
    this.createdAt,
    this.expiresAt,
  });

  factory FitnessStoryItem.fromJson(Map<String, dynamic> json) {
    return FitnessStoryItem(
      id: int.parse('${json['id']}'),
      imageUrl: ApiConfig.resolveMediaUrl(json['image_url']?.toString()),
      createdAt: json['created_at'] != null ? DateTime.tryParse('${json['created_at']}') : null,
      expiresAt: json['expires_at'] != null ? DateTime.tryParse('${json['expires_at']}') : null,
    );
  }
}

class MemberStoryGroup {
  final int memberId;
  final String memberName;
  final String? profilePic;
  final List<FitnessStoryItem> stories;

  MemberStoryGroup({
    required this.memberId,
    required this.memberName,
    this.profilePic,
    required this.stories,
  });

  factory MemberStoryGroup.fromJson(Map<String, dynamic> json) {
    final stories = (json['stories'] as List? ?? [])
        .map((e) => FitnessStoryItem.fromJson(e as Map<String, dynamic>))
        .toList();
    return MemberStoryGroup(
      memberId: int.parse('${json['member_id']}'),
      memberName: json['member_name'] ?? 'Member',
      profilePic: json['profile_pic'] != null
          ? ApiConfig.resolveMediaUrl(json['profile_pic']?.toString())
          : null,
      stories: stories,
    );
  }
}
