class TAStoolSkinFamilyModel {
  String? name;
  int? id;

  TAStoolSkinFamilyModel({
    this.name,
    this.id,
  });

  factory TAStoolSkinFamilyModel.fromJson(Map<String, dynamic> json) {
    return TAStoolSkinFamilyModel(
      name: json['name']?.toString(),
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
    };
  }

  @override
  String toString() {
    return 'TypeModel{name: $name, id: $id}';
  }
}