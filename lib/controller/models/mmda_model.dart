class MMDAModel {
  String? mmda;
  int? id;

  MMDAModel({
    this.mmda,
    this.id,
  });

  factory MMDAModel.fromJson(Map<String, dynamic> json) {
    return MMDAModel(
      mmda: json['mmda']?.toString(),
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mmda': mmda,
      'id': id,
    };
  }

  @override
  String toString() {
    return 'MMDAModel{mmda: $mmda, id: $id}';
  }
}