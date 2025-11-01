class DistrictModel {
  final int? id;
  final String regionName;
  final String districtName;
  final int districtId;
  final String regionId;

  DistrictModel({
    this.id,
    required this.regionName,
    required this.districtName,
    required this.districtId,
    required this.regionId,
  });

  // Convert DistrictModel to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'region_name': regionName,
      'district_name': districtName,
      'district_id': districtId,
      'region_id': regionId,
    };
  }

  // Create DistrictModel from Map
  factory DistrictModel.fromMap(Map<String, dynamic> map) {
    return DistrictModel(
      id: map['id'],
      regionName: map['region_name'] ?? '',
      districtName: map['district_name'] ?? '',
      districtId: map['district_id'] ?? 0,
      regionId: map['region_id'] ?? '',
    );
  }

  // Create a copy of DistrictModel with updated values
  DistrictModel copyWith({
    int? id,
    String? regionName,
    String? districtName,
    int? districtId,
    String? regionId,
  }) {
    return DistrictModel(
      id: id ?? this.id,
      regionName: regionName ?? this.regionName,
      districtName: districtName ?? this.districtName,
      districtId: districtId ?? this.districtId,
      regionId: regionId ?? this.regionId,
    );
  }

  @override
  String toString() {
    return 'DistrictModel(id: $id, regionName: $regionName, districtName: $districtName, districtId: $districtId, regionId: $regionId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DistrictModel &&
        other.id == id &&
        other.regionName == regionName &&
        other.districtName == districtName &&
        other.districtId == districtId &&
        other.regionId == regionId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
    regionName.hashCode ^
    districtName.hashCode ^
    districtId.hashCode ^
    regionId.hashCode;
  }
}