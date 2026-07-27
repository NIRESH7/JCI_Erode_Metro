class FamilyModel {
  final String name;
  final String dob;
  final String relationship;
  final String bloodGroup;
  final String anniversary;

  FamilyModel({
    required this.name,
    required this.dob,
    required this.relationship,
    this.bloodGroup = '',
    this.anniversary = '',
  });
}
