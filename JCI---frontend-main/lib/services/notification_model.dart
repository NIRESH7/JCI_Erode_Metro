class AppNotification {
  final int id;
  final String type;
  final String title;
  final String body;
  final int? referralId;
  final int? actorMemberId;
  final String? actorName;
  final String? actorProfilePic;
  final bool isRead;
  final String? createdAt;

  AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    this.referralId,
    this.actorMemberId,
    this.actorName,
    this.actorProfilePic,
    required this.isRead,
    this.createdAt,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}') ?? 0,
      type: '${json['type'] ?? ''}',
      title: '${json['title'] ?? ''}',
      body: '${json['body'] ?? ''}',
      referralId: json['referral_id'] == null
          ? null
          : (json['referral_id'] is int
              ? json['referral_id'] as int
              : int.tryParse('${json['referral_id']}')),
      actorMemberId: json['actor_member_id'] == null
          ? null
          : (json['actor_member_id'] is int
              ? json['actor_member_id'] as int
              : int.tryParse('${json['actor_member_id']}')),
      actorName: json['actor_name']?.toString(),
      actorProfilePic: json['actor_profile_pic']?.toString(),
      isRead: json['is_read'] == true || json['is_read'] == 1 || '${json['is_read']}' == 'true',
      createdAt: json['createdAt']?.toString(),
    );
  }
}
