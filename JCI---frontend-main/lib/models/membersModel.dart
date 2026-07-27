import 'package:jci/referral/services/api_config.dart';

class MembersModel {
  int? id;
  String? profilePic;
  String? userName;
  String? email;
  String? contact;
  String? gender;
  String? dob;
  String? location;
  String? bloodGroup;
  String? willingToDonate;
  String? officeName;
  String? job;
  String? sector;
  String? martialStatus;
  String? role;
  String? type;
  String? status;
  String? createdAt;
  String? updatedAt;

  MembersModel(
      {this.id,
      this.profilePic,
      this.userName,
      this.email,
      this.contact,
      this.gender,
      this.dob,
      this.location,
      this.bloodGroup,
      this.willingToDonate,
      this.officeName,
      this.job,
      this.sector,
      this.martialStatus,
      this.role,
      this.type,
      this.status,
      this.createdAt,
      this.updatedAt});

  MembersModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}');
    profilePic = ApiConfig.resolveMediaUrl(json['profile_pic']?.toString());
    userName = json['user_name'];
    email = json['email'];
    contact = json['contact'];
    gender = json['gender'];
    dob = json['dob'];
    location = json['location'];
    bloodGroup = json['blood_group'];
    willingToDonate = json['willing_to_donate'];
    officeName = json['office_name'];
    job = json['job'];
    sector = json['sector'];
    martialStatus = json['martial_status'];
    role = json['role'];
    type = json['type'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
}
