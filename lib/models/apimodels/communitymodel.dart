class CommunityJson {
  int? comcode;
  String? name;

  CommunityJson({
    this.comcode,
    this.name,
  });

  Map<String, dynamic> toJson() => {
        "comcode": comcode,
        "name": name,
      };

  static CommunityJson fromJson(json) => CommunityJson(
        name: json['name'],
        comcode: json['comcode'],
      );
}
