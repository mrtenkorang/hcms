class StoolJson {
  int? stoolcode;
  String? name;

  StoolJson({
    this.stoolcode,
    this.name,
  });

  Map<String, dynamic> tobeneficiaryJson() => {
        "stoolcode": stoolcode,
        "name": name,
      };

  static StoolJson fromJson(json) => StoolJson(
        name: json['name'],
        stoolcode: json['stoolcode'],
      );
}
