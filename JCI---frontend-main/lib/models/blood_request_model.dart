import 'package:jci/utils/String.dart';

class CreateBloodRequestModel {
  String? nameOfPatient;
  String? bloodGroup;
  String? noOfUnits;
  String? hospitalName;
  String? location;
  String? contact;
  String? attender;
  String? verifiedBy;

  CreateBloodRequestModel({
    this.nameOfPatient,
    this.bloodGroup,
    this.noOfUnits,
    this.hospitalName,
    this.location,
    this.contact,
    this.attender,
    this.verifiedBy,
  });

  CreateBloodRequestModel.fromJson(Map<String, dynamic> json) {
    nameOfPatient = json['NameOfPatient'];
    bloodGroup = json['BloodGroup'];
    noOfUnits = json['NoOfUnits'];
    hospitalName = json['Hospital_name'];
    location = json['location'];
    contact = json['Contact'];
    attender = json['Attender'];
    verifiedBy = json['created_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['NameOfPatient'] = this.nameOfPatient;
    data['BloodGroup'] = this.bloodGroup;
    data['NoOfUnits'] = this.noOfUnits;
    data['Hospital_name'] = this.hospitalName;
    data['location'] = this.location;
    data['Contact'] = this.contact;
    data['Attender'] = this.attender;
    data['created_by'] = this.verifiedBy;
    return data;
  }
}

class BloodRequestList {
  String? resource;
  String? type;
  Data? data;

  BloodRequestList({this.resource, this.type, this.data});

  BloodRequestList.fromJson(Map<String, dynamic> json) {
    resource = json['resource'];
    type = json['type'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }
}

class Data {
  bool? created;
  List<BloodRequestInfo>? info;

  Data({this.created, this.info});

  Data.fromJson(Map<String, dynamic> json) {
    created = json['created'];
    if (json['info'] != null) {
      info = <BloodRequestInfo>[];
      json['info'].forEach((v) {
        info!.add(new BloodRequestInfo.fromJson(v));
      });
    }
  }
}

class BloodRequestInfo {
  int? id;
  String? nameOfPatient;
  String? bloodGroup;
  String? noOfUnits;
  String? hospitalName;
  String? location;
  String? contact;
  String? attender;
  String? verifiedBy;
  String? createdAt;
  String? updatedAt;

  BloodRequestInfo(
      {this.id,
      this.nameOfPatient,
      this.bloodGroup,
      this.noOfUnits,
      this.hospitalName,
      this.location,
      this.contact,
      this.attender,
      this.verifiedBy,
      this.createdAt,
      this.updatedAt});

  BloodRequestInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nameOfPatient = caps(json['NameOfPatient']);
    bloodGroup = caps(json['BloodGroup']);
    noOfUnits = json['NoOfUnits'];
    hospitalName = caps(json['Hospital_name']);
    location = caps(json['location']);
    contact = json['Contact'];
    attender = caps(json['Attender']);
    verifiedBy = caps(json['created_by'] ?? json['VerifiedBy']);
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
}
