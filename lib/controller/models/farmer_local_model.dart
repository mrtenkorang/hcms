class FarmerBiodataModel {
  int? id;
  String? landscape;
  int? community;
  String? farmercode;
  String? farmerName;
  String? contact;
  String? nationalidType;
  String? nationalid;
  bool? membershipRa;
  String? cocoaCard;
  String? gender;
  String? dob;
  int? age;
  String? smallHolderCategory;
  double? farmSize;
  String? status; // 'pending' or 'submitted'
  String? createdAt;

  FarmerBiodataModel({
    this.id,
    this.landscape,
    this.community,
    this.farmercode,
    this.farmerName,
    this.contact,
    this.nationalidType,
    this.nationalid,
    this.membershipRa,
    this.cocoaCard,
    this.gender,
    this.dob,
    this.age,
    this.smallHolderCategory,
    this.farmSize,
    this.status = 'pending',
    this.createdAt,
  });

  factory FarmerBiodataModel.fromJson(Map<String, dynamic> json) {
    return FarmerBiodataModel(
      id: json['id'],
      landscape: json['landscape'],
      community: json['community'],
      farmercode: json['farmercode'],
      farmerName: json['farmer_name'],
      contact: json['contact'],
      nationalidType: json['nationalid_type'],
      nationalid: json['nationalid'],
      membershipRa: json['membership_ra'],
      cocoaCard: json['cocoa_card'],
      gender: json['gender'],
      dob: json['dob'],
      age: json['age'],
      smallHolderCategory: json['small_holder_category'],
      farmSize: json['farm_size']?.toDouble(),
      status: json['status'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'landscape': landscape,
      'community': community,
      'farmercode': farmercode,
      'farmer_name': farmerName,
      'contact': contact,
      'nationalid_type': nationalidType,
      'nationalid': nationalid,
      'membership_ra': membershipRa,
      'cocoa_card': cocoaCard,
      'gender': gender,
      'dob': dob,
      'age': age,
      'small_holder_category': smallHolderCategory,
      'farm_size': farmSize,
      'status': status,
      'created_at': createdAt,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'landscape': landscape,
      'community': community,
      'farmercode': farmercode,
      'farmer_name': farmerName,
      'contact': contact,
      'nationalid_type': nationalidType,
      'nationalid': nationalid,
      'membership_ra': membershipRa == true ? 1 : 0,
      'cocoa_card': cocoaCard,
      'gender': gender,
      'dob': dob,
      'age': age,
      'small_holder_category': smallHolderCategory,
      'farm_size': farmSize,
      'status': status,
      'created_at': createdAt ?? DateTime.now().toIso8601String(),
    };
  }

  factory FarmerBiodataModel.fromMap(Map<String, dynamic> map) {
    return FarmerBiodataModel(
      id: map['id'],
      landscape: map['landscape'],
      community: map['community'],
      farmercode: map['farmercode'],
      farmerName: map['farmer_name'],
      contact: map['contact'],
      nationalidType: map['nationalid_type'],
      nationalid: map['nationalid'],
      membershipRa: map['membership_ra'] == 1,
      cocoaCard: map['cocoa_card'],
      gender: map['gender'],
      dob: map['dob'],
      age: map['age'],
      smallHolderCategory: map['small_holder_category'],
      farmSize: map['farm_size'],
      status: map['status'],
      createdAt: map['created_at'],
    );
  }

  FarmerBiodataModel copyWith({
    String? landscape,
    int? community,
    String? farmercode,
    String? farmerName,
    String? contact,
    String? nationalidType,
    String? nationalid,
    bool? membershipRa,
    String? cocoaCard,
    String? gender,
    String? dob,
    int? age,
    String? smallHolderCategory,
    double? farmSize,
    String? status,
  }) {
    return FarmerBiodataModel(
      id: id,
      landscape: landscape ?? this.landscape,
      community: community ?? this.community,
      farmercode: farmercode ?? this.farmercode,
      farmerName: farmerName ?? this.farmerName,
      contact: contact ?? this.contact,
      nationalidType: nationalidType ?? this.nationalidType,
      nationalid: nationalid ?? this.nationalid,
      membershipRa: membershipRa ?? this.membershipRa,
      cocoaCard: cocoaCard ?? this.cocoaCard,
      gender: gender ?? this.gender,
      dob: dob ?? this.dob,
      age: age ?? this.age,
      smallHolderCategory: smallHolderCategory ?? this.smallHolderCategory,
      farmSize: farmSize ?? this.farmSize,
      status: status ?? this.status,
      createdAt: createdAt,
    );
  }
}