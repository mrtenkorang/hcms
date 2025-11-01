// models/training_log_model.dart
class TrainingLogModel {
  int? id;
  int communityId;
  String communityName;
  String trainingTopic;
  String eventDate;
  String eventDuration;
  String trainerName;
  String trainerOrganisation;
  int enumeratorId;
  String participants; // JSON string of participants list
  DateTime? createdAt;
  DateTime? updatedAt;
  bool isSynced;

  TrainingLogModel({
    this.id,
    required this.communityId,
    required this.communityName,
    required this.trainingTopic,
    required this.eventDate,
    required this.eventDuration,
    required this.trainerName,
    required this.trainerOrganisation,
    required this.enumeratorId,
    required this.participants,
    this.createdAt,
    this.updatedAt,
    this.isSynced = false,
  });

  // Convert to Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'community_id': communityId,
      'community_name': communityName,
      'training_topic': trainingTopic,
      'event_date': eventDate,
      'event_duration': eventDuration,
      'trainer_name': trainerName,
      'trainer_organisation': trainerOrganisation,
      'enumerator_id': enumeratorId,
      'participants': participants,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'is_synced': isSynced ? 1 : 0,
    };
  }

  // Create from Map
  factory TrainingLogModel.fromMap(Map<String, dynamic> map) {
    return TrainingLogModel(
      id: map['id'],
      communityId: map['community_id'],
      communityName: map['community_name'],
      trainingTopic: map['training_topic'],
      eventDate: map['event_date'],
      eventDuration: map['event_duration'],
      trainerName: map['trainer_name'],
      trainerOrganisation: map['trainer_organisation'],
      enumeratorId: map['enumerator_id'],
      participants: map['participants'],
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
      isSynced: map['is_synced'] == 1,
    );
  }

  // Convert to JSON for API
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'communityId': communityId,
      'communityName': communityName,
      'trainingTopic': trainingTopic,
      'eventDate': eventDate,
      'eventDuration': eventDuration,
      'trainerName': trainerName,
      'trainerOrganisation': trainerOrganisation,
      'enumeratorId': enumeratorId,
      'participants': participants,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isSynced': isSynced,
    };
  }

  // Create from JSON
  factory TrainingLogModel.fromJson(Map<String, dynamic> json) {
    return TrainingLogModel(
      id: json['id'],
      communityId: json['communityId'],
      communityName: json['communityName'],
      trainingTopic: json['trainingTopic'],
      eventDate: json['eventDate'],
      eventDuration: json['eventDuration'],
      trainerName: json['trainerName'],
      trainerOrganisation: json['trainerOrganisation'],
      enumeratorId: json['enumeratorId'],
      participants: json['participants'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      isSynced: json['isSynced'] ?? false,
    );
  }

  @override
  String toString() {
    return 'TrainingLogModel(id: $id, communityId: $communityId, trainingTopic: $trainingTopic, eventDate: $eventDate)';
  }
}

// Participant model for the participants list
class TrainingParticipant {
  int? id;
  String farmerName;
  String? contact;
  int? communityId;
  String? gender;
  int? age;

  TrainingParticipant({
    this.id,
    required this.farmerName,
    this.contact,
    this.communityId,
    this.gender,
    this.age,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'farmerName': farmerName,
      'contact': contact,
      'communityId': communityId,
      'gender': gender,
      'age': age,
    };
  }

  factory TrainingParticipant.fromMap(Map<String, dynamic> map) {
    return TrainingParticipant(
      id: map['id'],
      farmerName: map['farmerName'],
      contact: map['contact'],
      communityId: map['communityId'],
      gender: map['gender'],
      age: map['age'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'farmerName': farmerName,
      'contact': contact,
      'communityId': communityId,
      'gender': gender,
      'age': age,
    };
  }

  factory TrainingParticipant.fromJson(Map<String, dynamic> json) {
    return TrainingParticipant(
      id: json['id'],
      farmerName: json['farmerName'],
      contact: json['contact'],
      communityId: json['communityId'],
      gender: json['gender'],
      age: json['age'],
    );
  }
}