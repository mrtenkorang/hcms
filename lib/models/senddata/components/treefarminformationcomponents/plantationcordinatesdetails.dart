class PlantationCordinates {
  double? latitude;
  double? longitude;

  PlantationCordinates({
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> toPlantationCordinatesJson() => {
        "latitude": latitude,
        "longitude": longitude,
      };
}
