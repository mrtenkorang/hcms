import 'dart:convert';

class SeedlingsMappingModel {
  String? seedlingName;
  String? date;
  double? latitude;
  double? longitude;
  double? altitude;
  double? accuracy;
  String? pointID;
  String? wayPointNumber;

  SeedlingsMappingModel({
    this.seedlingName,
    this.date,
    this.latitude,
    this.longitude,
    this.altitude,
    this.accuracy,
    this.pointID,
    this.wayPointNumber,
  });

  Map<String, dynamic> toSeedlingsMappingModelJson() => {
        "species": seedlingName,
        "date": date,
        "latitude": latitude,
        "longitude": longitude,
        "altitude": altitude,
        "accuracy": accuracy,
        "pointId": pointID,
        "wayPointNumber": wayPointNumber,
      };

  factory SeedlingsMappingModel.fromJson(Map<String, dynamic> jsonData) {
    return SeedlingsMappingModel(
      seedlingName: jsonData['species'],
      date: jsonData['date'],
      latitude: jsonData['latitude'] as double,
      longitude: jsonData['longitude'] as double,
      altitude: jsonData['altitude'] as double,
      pointID: jsonData['pointId'],
      wayPointNumber: jsonData['wayPointNumber'],
    );
  }

  static Map<String, dynamic> toMap(SeedlingsMappingModel farmInfo) => {
        "species": farmInfo.seedlingName,
        'date': farmInfo.date,
        "latitude": farmInfo.latitude,
        "longitude": farmInfo.longitude,
        "altitude": farmInfo.altitude,
        "pointId": farmInfo.pointID,
        "wayPointNumber": farmInfo.wayPointNumber,
      };

  static String encode(List<SeedlingsMappingModel> farmInfos) => json.encode(
        farmInfos
            .map<Map<String, dynamic>>(
                (farmInfo) => SeedlingsMappingModel.toMap(farmInfo))
            .toList(),
      );

  static List<SeedlingsMappingModel> decode(String farmInfos) =>
      (json.decode(farmInfos) as List<dynamic>)
          .map<SeedlingsMappingModel>(
              (farmitem) => SeedlingsMappingModel.fromJson(farmitem))
          .toList();

  @override
  String toString() {
    return '{"species": "$seedlingName","date": "$date", "latitude": $latitude, "longitude": $longitude,'
        ' "altitude": $altitude, "pointId": "$pointID", "wayPointNumber": "$wayPointNumber"}';
  }
}
