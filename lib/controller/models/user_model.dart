class UserModel {
  int? id;
  String? fname;
  String? sname;
  String? designation;
  String? emailAddress;
  String? contactNumber;
  bool? verified;
  String? createdDate;
  String? assignedDistrictIds;

  UserModel({
    this.id,
    this.fname,
    this.sname,
    this.designation,
    this.emailAddress,
    this.contactNumber,
    this.verified,
    this.createdDate,
    this.assignedDistrictIds,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? ''),
      fname: json['fname']?.toString(),
      sname: json['sname']?.toString(),
      designation: json['designation']?.toString(),
      emailAddress: json['email_address']?.toString(),
      contactNumber: json['contact_number']?.toString(),
      verified: json['verified'] is bool ? json['verified'] : (json['verified']?.toString() == 'true'),
      createdDate: json['created_date']?.toString(),
      assignedDistrictIds: json['assigned_district_ids']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fname': fname,
      'sname': sname,
      'designation': designation,
      'email_address': emailAddress,
      'contact_number': contactNumber,
      'verified': verified,
      'created_date': createdDate,
      'assigned_district_ids': assignedDistrictIds,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fname': fname,
      'sname': sname,
      'designation': designation,
      'email_address': emailAddress,
      'contact_number': contactNumber,
      'verified': verified == true ? 1 : 0,
      'created_date': createdDate,
      'assigned_district_ids': assignedDistrictIds,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      fname: map['fname'],
      sname: map['sname'],
      designation: map['designation'],
      emailAddress: map['email_address'],
      contactNumber: map['contact_number'],
      verified: map['verified'] == 1,
      createdDate: map['created_date'],
      assignedDistrictIds: map['assigned_district_ids'],
    );
  }

  @override
  String toString() {
    return 'UserModel{id: $id, fname: $fname, sname: $sname, email: $emailAddress, contact: $contactNumber, verified: $verified}';
  }
}