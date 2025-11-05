// models/tree_species_model.dart
class TreeSpeciesModel {
  final int id;
  final String code;
  final String name;
  final String botanical;

  TreeSpeciesModel({
    required this.id,
    required this.code,
    required this.name,
    required this.botanical,
  });

  // Convert to Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'botanical': botanical,
    };
  }

  // Convert from Map from SQLite
  factory TreeSpeciesModel.fromMap(Map<String, dynamic> map) {
    return TreeSpeciesModel(
      id: map['id'],
      code: map['code'] ?? '',
      name: map['name'] ?? '',
      botanical: map['botanical'] ?? '',
    );
  }

  // Convert from JSON from API
  factory TreeSpeciesModel.fromJson(Map<String, dynamic> json) {
    return TreeSpeciesModel(
      id: json['id'],
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      botanical: json['botanical'] ?? '',
    );
  }

  @override
  String toString() {
    return 'TreeSpeciesModel(id: $id, code: $code, name: $name, botanical: $botanical)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is TreeSpeciesModel &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;
}

// API Response Model
class TreeSpeciesResponse {
  final bool status;
  final String message;
  final List<TreeSpeciesModel> data;

  TreeSpeciesResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory TreeSpeciesResponse.fromJson(Map<String, dynamic> json) {
    return TreeSpeciesResponse(
      status: json['status'] ?? false,
      message: json['msg'] ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => TreeSpeciesModel.fromJson(item))
          .toList() ??
          [],
    );
  }
}