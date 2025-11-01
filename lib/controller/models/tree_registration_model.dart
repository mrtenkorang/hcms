import 'dart:typed_data';

class TreeRegistrationModel {
  final int? id;
  final int? farmerId;
  final int? regionId;
  final int? districtId;
  final int? mmdaId;
  final int? communityId;
  final String? establishmentType;
  final String? nextOfKinName;
  final String? farmerRelationshipWithNextOfKin;
  final DateTime? nextOfKinDoB;
  final String? nextOfKinGender;
  final String? nextOfKinPhoneNumber;
  final String? nextOfKinPostalAddress;
  final Uint8List? farmBoundaryPolygon;
  final List<Map<String, dynamic>> trees;
  final double? farmSize;

  // group details
  final String? groupName;
  final String? groupPresident;
  final String? groupSecretary;
  final String? companyDirectors;
  final String? groupPhoneNumber;
  final String? groupEmail;
  final String? groupPostalAddress;
  final String? groupRegNumb;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? isSynced;

  TreeRegistrationModel({
    this.isSynced,
    this.id,
    this.farmerId,
    this.regionId,
    this.districtId,
    this.mmdaId,
    this.communityId,
    this.establishmentType,
    this.nextOfKinName,
    this.farmerRelationshipWithNextOfKin,
    this.nextOfKinDoB,
    this.nextOfKinGender,
    this.nextOfKinPhoneNumber,
    this.nextOfKinPostalAddress,
    this.farmBoundaryPolygon,
    this.farmSize,
    required this.trees,
    this.groupName,
    this.groupPresident,
    this.groupSecretary,
    this.companyDirectors,
    this.groupPhoneNumber,
    this.groupEmail,
    this.groupPostalAddress,
    this.groupRegNumb,
    this.createdAt,
    this.updatedAt,
  });

  // Copy with method
  TreeRegistrationModel copyWith({
    int? id,
    int? farmerId,
    int? regionId,
    int? districtId,
    int? mmdaId,
    int? communityId,
    String? establishmentType,
    String? nextOfKinName,
    String? farmerRelationshipWithNextOfKin,
    DateTime? nextOfKinDoB,
    String? nextOfKinGender,
    String? nextOfKinPhoneNumber,
    String? nextOfKinPostalAddress,
    Uint8List? farmBoundaryPolygon,
    double? farmSize,
    List<Map<String, dynamic>>? trees,
    String? groupName,
    String? groupPresident,
    String? groupSecretary,
    String? companyDirectors,
    String? groupPhoneNumber,
    String? groupEmail,
    String? groupPostalAddress,
    String? groupRegNumb,
    int? isSynced,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TreeRegistrationModel(
      id: id ?? this.id,
      farmerId: farmerId ?? this.farmerId,
      regionId: regionId ?? this.regionId,
      districtId: districtId ?? this.districtId,
      mmdaId: mmdaId ?? this.mmdaId,
      communityId: communityId ?? this.communityId,
      establishmentType: establishmentType ?? this.establishmentType,
      nextOfKinName: nextOfKinName ?? this.nextOfKinName,
      farmerRelationshipWithNextOfKin: farmerRelationshipWithNextOfKin ?? this.farmerRelationshipWithNextOfKin,
      nextOfKinDoB: nextOfKinDoB ?? this.nextOfKinDoB,
      nextOfKinGender: nextOfKinGender ?? this.nextOfKinGender,
      nextOfKinPhoneNumber: nextOfKinPhoneNumber ?? this.nextOfKinPhoneNumber,
      nextOfKinPostalAddress: nextOfKinPostalAddress ?? this.nextOfKinPostalAddress,
      farmBoundaryPolygon: farmBoundaryPolygon ?? this.farmBoundaryPolygon,
      farmSize: farmSize ?? 0.0,
      trees: trees ?? this.trees,
      groupName: groupName ?? this.groupName,
      groupPresident: groupPresident ?? this.groupPresident,
      groupSecretary: groupSecretary ?? this.groupSecretary,
      companyDirectors: companyDirectors ?? this.companyDirectors,
      groupPhoneNumber: groupPhoneNumber ?? this.groupPhoneNumber,
      groupEmail: groupEmail ?? this.groupEmail,
      groupPostalAddress: groupPostalAddress ?? this.groupPostalAddress,
      groupRegNumb: groupRegNumb ?? this.groupRegNumb,
      isSynced: isSynced ?? this.isSynced,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // To JSON method with underscore names
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'farmer_id': farmerId,
      'farm_size': farmSize,
      'region_id': regionId,
      'district_id': districtId,
      'mmda_id': mmdaId,
      'community_id': communityId,
      'establishment_type': establishmentType,
      'next_of_kin_name': nextOfKinName,
      'farmer_relationship_with_next_of_kin': farmerRelationshipWithNextOfKin,
      'next_of_kin_dob': nextOfKinDoB?.toIso8601String(),
      'next_of_kin_gender': nextOfKinGender,
      'next_of_kin_phone_number': nextOfKinPhoneNumber,
      'next_of_kin_postal_address': nextOfKinPostalAddress,
      'farm_boundary_polygon': farmBoundaryPolygon,
      'trees': trees,
      'group_name': groupName,
      'group_president': groupPresident,
      'group_secretary': groupSecretary,
      'company_directors': companyDirectors,
      'group_phone_number': groupPhoneNumber,
      'group_email': groupEmail,
      'group_postal_address': groupPostalAddress,
      'group_reg_numb': groupRegNumb,
      'is_synced': isSynced,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  // From JSON method with underscore names
  factory TreeRegistrationModel.fromJson(Map<String, dynamic> json) {
    return TreeRegistrationModel(
      id: json['id'],
      farmerId: json['farmer_id'],
      regionId: json['region_id'],
      districtId: json['district_id'],
      mmdaId: json['mmda_id'],
      communityId: json['community_id'],
      establishmentType: json['establishment_type'],
      nextOfKinName: json['next_of_kin_name'],
      farmerRelationshipWithNextOfKin: json['farmer_relationship_with_next_of_kin'],
      nextOfKinDoB: json['next_of_kin_dob'] != null ? DateTime.parse(json['next_of_kin_dob']) : null,
      nextOfKinGender: json['next_of_kin_gender'],
      nextOfKinPhoneNumber: json['next_of_kin_phone_number'],
      nextOfKinPostalAddress: json['next_of_kin_postal_address'],
      farmBoundaryPolygon: json['farm_boundary_polygon'],
      farmSize: json['farm_size'],
      trees: List<Map<String, dynamic>>.from(json['trees'] ?? []),
      groupName: json['group_name'],
      groupPresident: json['group_president'],
      groupSecretary: json['group_secretary'],
      companyDirectors: json['company_directors'],
      groupPhoneNumber: json['group_phone_number'],
      groupEmail: json['group_email'],
      groupPostalAddress: json['group_postal_address'],
      groupRegNumb: json['group_reg_numb'],
      isSynced: json['is_synced'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  // Empty factory constructor
  factory TreeRegistrationModel.empty() {
    return TreeRegistrationModel(
      trees: [],
    );
  }

  @override
  String toString() {
    return 'TreeRegistrationModel(id: $id, farmerId: $farmerId, trees: ${trees.length})';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is TreeRegistrationModel &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;
}