import 'dart:convert';

// Json methods for decoding and encoding to and from json format
// One set for each corresponding model class below

SpeciesGalleryModel speciesGalleryModelFromJson(String str) =>
    SpeciesGalleryModel.fromJson(json.decode(str));

String speciesGalleryModelToJson(SpeciesGalleryModel data) =>
    json.encode(data.toJson());

class SpeciesGalleryModel {
  String? species;
  String? image;

  SpeciesGalleryModel({
    required this.species,
    required this.image,
  });

  factory SpeciesGalleryModel.fromJson(Map<String, dynamic> datas) {
    return SpeciesGalleryModel(
      species: datas["species"],
      image: datas["image"],
    );
  }

  Map<String, dynamic> toJson() => {
        "species": species,
        "image": image,
      };
}
