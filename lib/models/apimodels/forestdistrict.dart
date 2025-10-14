class ForestDistrictsJson {
  int? code;
  String? name;

  ForestDistrictsJson({
    this.code,
    this.name,
  });

  Map<String, dynamic> tobeneficiaryJson() => {
        "code": code,
        "name": name,
      };

  static ForestDistrictsJson fromJson(json) => ForestDistrictsJson(
        name: json['name'],
        code: json['code'],
      );
}
