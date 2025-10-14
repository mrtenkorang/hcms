class FarmerListJson {
  int? farmerid;
  String? farmername;
  String? communityname;
  int? community;

  FarmerListJson({
    this.farmerid,
    this.farmername,
    this.communityname,
    this.community,
  });

  Map<String, dynamic> toJson() => {
        "farmerid": farmerid,
        "farmer_name": farmername,
        "community_name": communityname,
        "community": community,
      };

  static FarmerListJson fromJson(json) => FarmerListJson(
        farmerid: json['farmerid'],
        farmername: json['farmer_name'],
        communityname: json['community_name'],
        community: json['community'],
      );
}
