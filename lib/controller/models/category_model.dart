// models/category_model.dart
class CategoryModel {
  final int id;
  final String displayName;
  final String code;
  final String? description;
  final bool isActive;
  final DateTime createdDate;
  final DateTime updatedDate;

  CategoryModel({
    required this.id,
    required this.displayName,
    required this.code,
    this.description,
    required this.isActive,
    required this.createdDate,
    required this.updatedDate,
  });

  // Convert to Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'display_name': displayName,
      'code': code,
      'description': description,
      'is_active': isActive ? 1 : 0,
      'created_date': createdDate.toIso8601String(),
      'updated_date': updatedDate.toIso8601String(),
    };
  }

  // Convert from Map from SQLite
  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'],
      displayName: map['display_name'] ?? '',
      code: map['code'] ?? '',
      description: map['description'],
      isActive: map['is_active'] == 1,
      createdDate: DateTime.parse(map['created_date']),
      updatedDate: DateTime.parse(map['updated_date']),
    );
  }

  // Convert from JSON from API
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      displayName: json['display_name'] ?? '',
      code: json['code'] ?? '',
      description: json['description'],
      isActive: json['is_active'] ?? false,
      createdDate: DateTime.parse(json['created_date']),
      updatedDate: DateTime.parse(json['updated_date']),
    );
  }

  @override
  String toString() {
    return 'CategoryModel(id: $id, displayName: $displayName, code: $code, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is CategoryModel &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;
}

// API Response Model
class CategoryResponse {
  final bool status;
  final String message;
  final List<CategoryModel> data;

  CategoryResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CategoryResponse.fromJson(Map<String, dynamic> json) {
    return CategoryResponse(
      status: json['status'] ?? false,
      message: json['msg'] ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => CategoryModel.fromJson(item))
          .toList() ??
          [],
    );
  }
}