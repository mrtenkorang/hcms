class TreeSpeciesJson {
  int? code;
  String? species;

  TreeSpeciesJson({
    this.code,
    this.species,
  });

  Map<String, dynamic> tobeneficiaryJson() => {
        "code": code,
        "species": species,
      };

  static TreeSpeciesJson fromJson(json) => TreeSpeciesJson(
        species: json['species'],
        code: json['code'],
      );
}
