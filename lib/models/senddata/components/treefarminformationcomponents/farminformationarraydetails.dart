import 'dart:convert';

class FarmInformationArray {
  String? date;
  double? latitude;
  double? longitude;
  double? accuracy;
  String? pointID;
  String? wayPointNumber;

  FarmInformationArray({
    this.date,
    this.latitude,
    this.longitude,
    this.accuracy,
    this.pointID,
    this.wayPointNumber,
  });

  Map<String, dynamic> toFarmInformationArrayJson() => {
        "date": date,
        "latitude": latitude,
        "longitude": longitude,
        "pointId": pointID,
        "wayPointNumber": wayPointNumber,
      };

  factory FarmInformationArray.fromJson(Map<String, dynamic> jsonData) {
    return FarmInformationArray(
      date: jsonData['date'],
      latitude: jsonData['latitude'] as double,
      longitude: jsonData['longitude'] as double,
      pointID: jsonData['pointId'],
      wayPointNumber: jsonData['wayPointNumber'],
    );
  }

  static Map<String, dynamic> toMap(FarmInformationArray farmInfo) => {
        'date': farmInfo.date,
        "latitude": farmInfo.latitude,
        "longitude": farmInfo.longitude,
        "pointId": farmInfo.pointID,
        "wayPointNumber": farmInfo.wayPointNumber,
      };

  static String encode(List<FarmInformationArray> farmInfos) => json.encode(
        farmInfos
            .map<Map<String, dynamic>>(
                (farmInfo) => FarmInformationArray.toMap(farmInfo))
            .toList(),
      );

  static List<FarmInformationArray> decode(String farmInfos) =>
      (json.decode(farmInfos) as List<dynamic>)
          .map<FarmInformationArray>(
              (farmitem) => FarmInformationArray.fromJson(farmitem))
          .toList();

  @override
  String toString() {
    return '{"date": "$date", "latitude": $latitude, "longitude": $longitude,'
        ' "pointId": "$pointID", "wayPointNumber": "$wayPointNumber"}';
  }
}
