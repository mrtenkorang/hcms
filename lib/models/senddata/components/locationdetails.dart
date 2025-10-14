class LocationDetails {
  String? community;
  String? family;
  String? forestDistrict;
  String? mmdas;
  String? region;

  LocationDetails({
    this.community,
    this.family,
    this.forestDistrict,
    this.mmdas,
    this.region,
  });

  Map<String, dynamic> toLocationJson() => {
        "community": community,
        "family": family,
        "forestDistrict": forestDistrict,
        "mmdas": mmdas,
        "region": region,
      };
}
