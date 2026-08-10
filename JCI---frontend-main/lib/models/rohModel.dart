class RohModel {
  final int? id;
  final int? memberId;
  final String img;
  final String name;
  final String designationName;
  final String designationYear;
  final String? email;
  final String? contact;
  final String? gender;
  final String? dob;
  final String? location;
  final String? bloodGroup;
  final String? willingToDonate;
  final String? officeName;
  final String? job;
  final String? sector;
  final String? martialStatus;
  final String? role;
  final String? jciLocation;
  final String? membershipId;
  final String? type;
  final String? status;

  RohModel({
    this.id,
    this.memberId,
    required this.img,
    required this.name,
    required this.designationName,
    required this.designationYear,
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
    this.jciLocation,
    this.membershipId,
    this.type,
    this.status,
  });

  /// Back-compat for older call sites.
  String get roleLabel =>
      designationName.trim().isNotEmpty ? designationName : (role ?? '');
}
