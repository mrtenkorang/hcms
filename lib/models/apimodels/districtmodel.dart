class DistrictsJson {
  int? districtcode;
  String? district;

  DistrictsJson({
    this.districtcode,
    this.district,
  });

  Map<String, dynamic> tobeneficiaryJson() => {
        "districtcode": districtcode,
        "district": district,
      };

  static DistrictsJson fromJson(json) => DistrictsJson(
        district: json['district'],
        districtcode: json['districtcode'],
      );
}
