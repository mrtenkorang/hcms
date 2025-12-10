
class FarmerFromServerModel {
  final int id;
  final String landscape;
  final int community;
  final String farmercode;
  final String farmerName;
  final String contact;
  final String nationalidType;
  final String nationalid;
  final bool membershipRa;
  final String cocoaCard;
  final String photo;
  final String gender;
  final String dob;
  final int age;
  final String smallHolderCategory;
  final double farmSize;
  final String createdDate;
  final String communityName;
  final int communityId;
  final double? communityLat;
  final double? communityLong;
  final double? communityElevation;
  final String districtName;
  final int districtId;
  final String districtCode;
  final bool districtPilot;
  final String regionName;
  final int regionId;
  final String regionCode;
  final bool regionPilot;

  FarmerFromServerModel({
    required this.id,
    required this.landscape,
    required this.community,
    required this.farmercode,
    required this.farmerName,
    required this.contact,
    required this.nationalidType,
    required this.nationalid,
    required this.membershipRa,
    required this.cocoaCard,
    required this.photo,
    required this.gender,
    required this.dob,
    required this.age,
    required this.smallHolderCategory,
    required this.farmSize,
    required this.createdDate,
    required this.communityName,
    required this.communityId,
    this.communityLat,
    this.communityLong,
    this.communityElevation,
    required this.districtName,
    required this.districtId,
    required this.districtCode,
    required this.districtPilot,
    required this.regionName,
    required this.regionId,
    required this.regionCode,
    required this.regionPilot,
  });

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
      'membership_ra': membershipRa ? 1 : 0,
      'cocoa_card': cocoaCard,
      'photo': photo,
      'gender': gender,
      'dob': dob,
      'age': age,
      'small_holder_category': smallHolderCategory,
      'farm_size': farmSize,
      'created_date': createdDate,
      'community_name': communityName,
      'community_id': communityId,
      'community_lat': communityLat,
      'community_long': communityLong,
      'community_elevation': communityElevation,
      'district_name': districtName,
      'district_id': districtId,
      'district_code': districtCode,
      'district_pilot': districtPilot ? 1 : 0,
      'region_name': regionName,
      'region_id': regionId,
      'region_code': regionCode,
      'region_pilot': regionPilot ? 1 : 0,
    };
  }

  factory FarmerFromServerModel.fromMap(Map<String, dynamic> map) {
    return FarmerFromServerModel(
      id: map['id'] ,
      landscape: map['landscape'] ?? "none",
      community: map['community'] ?? 0,
      farmercode: map['farmercode'] ?? "none",
      farmerName: map['farmer_name'] ?? "none",
      contact: map['contact'] ?? "none",
      nationalidType: map['nationalid_type'] ?? "none",
      nationalid: map['nationalid'] ?? "none",
      membershipRa: map['membership_ra'] == 1,
      cocoaCard: map['cocoa_card'] ?? "none",
      photo: map['photo'] ?? "none",
      gender: map['gender'] ?? "none",
      dob: map['dob'] ?? 'none',
      age: map['age'] ?? 0,
      smallHolderCategory: map['small_holder_category'] ?? "none",
      farmSize: map['farm_size'] ?? 0.0,
      createdDate: map['created_date'] ?? '',
      communityName: map['community_name'] ?? "none",
      communityId: map['community_id'] ?? 0,
      communityLat: map['community_lat'] ?? 0.0,
      communityLong: map['community_long'] ?? 0.0,
      communityElevation: map['community_elevation'] ?? 0.0,
      districtName: map['district_name'] ?? "none",
      districtId: map['district_id'] ?? "none",
      districtCode: map['district_code'] ?? "none",
      districtPilot: map['district_pilot'] == 1,
      regionName: map['region_name'] ?? "none",
      regionId: map['region_id'] ?? "none",
      regionCode: map['region_code'] ?? "none",
      regionPilot: map['region_pilot'] == 1,
    );
  }
}
