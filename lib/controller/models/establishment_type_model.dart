class EstaTypeModel {
  String? esta_type;
  int? id;

  EstaTypeModel({
    this.esta_type,
    this.id,
  });

  factory EstaTypeModel.fromJson(Map<String, dynamic> json) {
    return EstaTypeModel(
      esta_type: json['esta_type']?.toString(),
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'esta_type': esta_type,
      'id': id,
    };
  }

  @override
  String toString() {
    return 'EstaTypeModel{esta_type: $esta_type, id: $id}';
  }
}