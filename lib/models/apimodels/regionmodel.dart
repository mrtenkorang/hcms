class RegionJson {
  int? regcode;
  String? name;

  RegionJson({
    this.regcode,
    this.name,
  });

  Map<String, dynamic> toRegionJson() => {
        "regcode": regcode,
        "name": name,
      };

  static RegionJson fromRegionJson(json) => RegionJson(
        name: json['name'],
        regcode: json['regcode'],
      );
}
