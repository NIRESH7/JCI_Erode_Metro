class ReferralModel {
  final int id;
  final int referrerMemberId;
  final int? linkedMemberId;
  final String referralType;
  final String referredName;
  final String referredPhone;
  final String? remark;
  final int? referredMemberId;
  final String status;
  final String? connectionType;
  final double? connectAmount;
  final String? referrerName;
  final String? linkedMemberName;

  ReferralModel({
    required this.id,
    required this.referrerMemberId,
    this.linkedMemberId,
    required this.referralType,
    required this.referredName,
    required this.referredPhone,
    this.remark,
    this.referredMemberId,
    required this.status,
    this.connectionType,
    this.connectAmount,
    this.referrerName,
    this.linkedMemberName,
  });

  factory ReferralModel.fromJson(Map<String, dynamic> json) {
    return ReferralModel(
      id: int.parse('${json['id']}'),
      referrerMemberId: int.parse('${json['referrer_member_id']}'),
      linkedMemberId: json['linked_member_id'] != null
          ? int.parse('${json['linked_member_id']}')
          : null,
      referralType: json['referral_type'] ?? '',
      referredName: json['referred_name'] ?? '',
      referredPhone: json['referred_phone'] ?? '',
      remark: json['remark']?.toString(),
      referredMemberId: json['referred_member_id'] != null
          ? int.parse('${json['referred_member_id']}')
          : null,
      status: json['status'] ?? 'pending',
      connectionType: json['connection_type'],
      connectAmount: json['connect_amount'] != null
          ? double.tryParse('${json['connect_amount']}')
          : null,
      referrerName: json['referrer_name'],
      linkedMemberName: json['linked_member_name'],
    );
  }

  String get typeLabel {
    switch (referralType) {
      case 'self':
        return 'Self';
      case 'jci_member':
        return 'JCI Member';
      case 'non_jci_member':
        return 'Non JCI';
      default:
        return referralType;
    }
  }

  String get statusLabel {
    switch (status) {
      case 'accepted':
        return connectionType == 'completed' ? 'Connected' : 'Non Closed Connection';
      case 'rejected':
        return 'Non Closed Connection';
      default:
        return 'Pending';
    }
  }
}
