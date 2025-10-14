import 'dart:convert';

class TreeInformationOption0Array {
  String? numberOfTrees;
  String? plantingDistance;
  String? speciesPlanted;
  String? speciesImage;
  String? yearOfEstablishment;

  TreeInformationOption0Array({
    this.numberOfTrees,
    this.plantingDistance,
    this.speciesPlanted,
    this.speciesImage,
    this.yearOfEstablishment,
  });

  Map<String, dynamic> toFarmInformationArrayJson() => {
        "numberOfTrees": numberOfTrees,
        "plantingDistance": plantingDistance,
        "speciesPlanted": speciesPlanted,
        "speciesImage": speciesImage,
        "yearOfEstablishment": yearOfEstablishment,
      };

  factory TreeInformationOption0Array.fromJson(Map<String, dynamic> jsonData) {
    return TreeInformationOption0Array(
      numberOfTrees: jsonData['numberOfTrees'],
      plantingDistance: jsonData['plantingDistance'],
      speciesPlanted: jsonData['speciesPlanted'],
      speciesImage: jsonData['speciesImage'],
      yearOfEstablishment: jsonData['yearOfEstablishment'],
    );
  }

  static Map<String, dynamic> toMap(TreeInformationOption0Array farmInfo) => {
        'numberOfTrees': farmInfo.numberOfTrees,
        "plantingDistance": farmInfo.plantingDistance,
        "speciesPlanted": farmInfo.speciesPlanted,
        "speciesImage": farmInfo.speciesImage,
        "yearOfEstablishment": farmInfo.yearOfEstablishment,
      };

  static String encode(List<TreeInformationOption0Array> farmInfos) =>
      json.encode(
        farmInfos
            .map<Map<String, dynamic>>(
                (farmInfo) => TreeInformationOption0Array.toMap(farmInfo))
            .toList(),
      );

  static List<TreeInformationOption0Array> decode(String farmInfos) =>
      (json.decode(farmInfos) as List<dynamic>)
          .map<TreeInformationOption0Array>(
              (farmitem) => TreeInformationOption0Array.fromJson(farmitem))
          .toList();

  @override
  String toString() {
    return '{"numberOfTrees": $numberOfTrees, "plantingDistance": '
        '$plantingDistance, "speciesPlanted": "$speciesPlanted", '
        '"speciesImage": "$speciesImage", "yearOfEstablishment": $yearOfEstablishment}';
  }
}
