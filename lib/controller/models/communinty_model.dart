class CommunityModel {
  String? community;
  int? id;
  int? district;

  CommunityModel({
    this.community,
    this.id,
    this.district
  });

  factory CommunityModel.fromJson(Map<String, dynamic> json) {
    return CommunityModel(
      community: json['community']?.toString(),
      district: json['district'] is int ? json['district'] : int.tryParse(json['district']?.toString() ?? ''),
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'community': community,
      'district': district,
      'id': id,
    };
  }

  @override
  String toString() {
    return 'CommunityModel{community: $community, id: $id, district: $district}';
  }
}