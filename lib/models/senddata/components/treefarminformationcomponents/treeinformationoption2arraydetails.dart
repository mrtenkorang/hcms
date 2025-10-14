import 'dart:convert';

class TreeInformationOption2Array {
  String? pN;
  String? sizeofTree;
  String? species;
  String? speciesImage;
  TreeLocation? treeLocation;
  String? yearNurturingStarted;
  String? yearPlanted;

  TreeInformationOption2Array({
    this.pN,
    this.sizeofTree,
    this.species,
    this.speciesImage,
    this.treeLocation,
    this.yearNurturingStarted,
    this.yearPlanted,
  });

  Map<String, dynamic> toTree2Json() => {
        "pn": pN,
        "sizeOfTree": sizeofTree,
        "species": species,
        "speciesImage": speciesImage,
        "treeLocation": treeLocation?.toTreeLocationJson(),
        "yearNurturingStarted": yearNurturingStarted,
        "yearPlanted": yearPlanted,
      };

  factory TreeInformationOption2Array.fromJson(Map<String, dynamic> jsonData) {
    return TreeInformationOption2Array(
      pN: jsonData['pn'],
      sizeofTree: jsonData['sizeOfTree'],
      species: jsonData['species'],
      speciesImage: jsonData["speciesImage"],
      // treeLocation:
      //     TreeLocation.toMap(jsonData['treeLocation']) as TreeLocation,
      treeLocation: TreeLocation.fromJson(jsonData['treeLocation']),
      yearNurturingStarted: jsonData['yearNurturingStarted'],
      yearPlanted: jsonData['yearPlanted'],
    );
  }

  static Map<String, dynamic> toMap(TreeInformationOption2Array treeInfo) => {
        "pn": treeInfo.pN,
        "sizeOfTree": treeInfo.sizeofTree,
        "species": treeInfo.species,
        "speciesImage": treeInfo.speciesImage,
        "treeLocation": treeInfo.treeLocation?.toTreeLocationJson(),
        "yearNurturingStarted": treeInfo.yearNurturingStarted,
        "yearPlanted": treeInfo.yearPlanted,
      };

  static String encode(List<TreeInformationOption2Array> treeInfos) =>
      jsonEncode(
        treeInfos
            .map<Map<String, dynamic>>(
                (farmInfo) => TreeInformationOption2Array.toMap(farmInfo))
            .toList(),
      );

  static List<TreeInformationOption2Array> decode(String treeInfos) =>
      (json.decode(treeInfos) as List<dynamic>)
          .map<TreeInformationOption2Array>(
              (farmitem) => TreeInformationOption2Array.fromJson(farmitem))
          .toList();

  @override
  String toString() {
    return '{"pn": "$pN", "sizeOfTree": $sizeofTree, "species": "$species", '
        '"speciesImage": "$speciesImage", "treeLocation": $treeLocation,'
        ' "yearPlanted": $yearPlanted, "yearNurturingStarted": $yearNurturingStarted}';
  }
}

class TreeLocation {
  double? latitude;
  double? longitude;
  String? pointID;

  TreeLocation({
    this.latitude,
    this.longitude,
    this.pointID,
  });

  Map<String, dynamic> toTreeLocationJson() => {
        "latitude": latitude,
        "longitude": longitude,
        "pointId": pointID,
      };

  factory TreeLocation.fromJson(Map<String, dynamic> jsonData) {
    return TreeLocation(
      latitude: jsonData['latitude'] as double,
      longitude: jsonData['longitude'] as double,
      pointID: jsonData['pointId'],
    );
  }

  static Map<String, dynamic> toMap(TreeLocation farmInfo) => {
        "latitude": farmInfo.latitude,
        "longitude": farmInfo.longitude,
        "pointId": farmInfo.pointID,
      };

  static String encode(List<TreeLocation> treeInfos) => json.encode(
        treeInfos
            .map<Map<String, dynamic>>(
                (farmInfo) => TreeLocation.toMap(farmInfo))
            .toList(),
      );

  static List<TreeLocation> decode(String treeInfos) =>
      (json.decode(treeInfos) as List<dynamic>)
          .map<TreeLocation>((farmitem) => TreeLocation.fromJson(farmitem))
          .toList();

  @override
  String toString() {
    return '{"latitude": $latitude, "longitude": $longitude,'
        ' "pointId": "$pointID"}';
  }
}
