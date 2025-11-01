class DeforestationReportModel {
  int? id;
  String? community;
  String? directedByGfw;
  String? seeDeforestation;
  List<String>? deforestationCauses;
  String? furtherActionRequired;
  String? reasonForAction;
  double? latitude;
  double? longitude;
  String? photos;
  String? submissionStatus;
  DateTime? createdAt;
  DateTime? updatedAt;

  DeforestationReportModel({
    this.id,
    this.community,
    this.directedByGfw,
    this.seeDeforestation,
    this.deforestationCauses,
    this.furtherActionRequired,
    this.reasonForAction,
    this.latitude,
    this.longitude,
    this.photos,
    this.submissionStatus = 'pending',
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {

    
    return {
      'id': id,
      'community': community,
      'directed_by_gfw': directedByGfw,
      'do_u_see_deforestation': seeDeforestation,
      'cause_deforestation': deforestationCauses != null
          ? deforestationCauses!.join(',')
          : null,
      'further_action_taken': furtherActionRequired,
      'reason_further_action_taken': reasonForAction,
      'latitude': latitude,
      'longitude': longitude,
      'photos': photos,
      'submission_status': submissionStatus,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory DeforestationReportModel.fromMap(Map<String, dynamic> map) {
    // Process the photos field to ensure it's in the correct format
    String? photos = map['photos'];
    if (photos != null && photos.isNotEmpty) {
      // If it's a full data URL, extract just the base64 part
      if (photos.startsWith('data:image/')) {
        final parts = photos.split(',');
        if (parts.length > 1) {
          photos = parts[1];
        }
      }
    }
    
    return DeforestationReportModel(
      id: map['id'],
      community: map['community'],
      directedByGfw: map['directed_by_gfw'],
      seeDeforestation: map['do_u_see_deforestation'],
      deforestationCauses: map['cause_deforestation'] != null
          ? (map['cause_deforestation'] as String).split(',')
          : [],
      furtherActionRequired: map['further_action_taken'],
      reasonForAction: map['reason_further_action_taken'],
      latitude: map['latitude'] != null ? double.parse(map['latitude'].toString()) : null,
      longitude: map['longitude'] != null ? double.parse(map['longitude'].toString()) : null,
      photos: photos,
      submissionStatus: map['submission_status'] ?? 'pending',
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
    );
  }

  Map<String, dynamic> toApiMap() {
    // Ensure photos is properly formatted as a base64 string
    // String? processedPhotos = photos;
    // if (photos != null && photos!.isNotEmpty) {
    //   // If the string doesn't look like base64, try to encode it
    //   if (!photos!.startsWith('data:image/')) {
    //     processedPhotos = 'data:image/jpeg;base64,$photos';
    //   }
    // }
    
    return {
      'community': community,
      'directed_by_gfw': directedByGfw,
      'do_u_see_deforestation': seeDeforestation,
      'cause_deforestation': deforestationCauses != null
          ? deforestationCauses!.join(',')
          : '',
      'further_action_taken': furtherActionRequired,
      'reason_further_action_taken': reasonForAction,
      'latitude': latitude,
      'longitude': longitude,
      'photos': photos,
    };
  }

  DeforestationReportModel copyWith({
    int? id,
    String? community,
    String? directedByGfw,
    String? seeDeforestation,
    List<String>? deforestationCauses,
    String? furtherActionRequired,
    String? reasonForAction,
    double? latitude,
    double? longitude,
    String? photos,
    String? submissionStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DeforestationReportModel(
      id: id ?? this.id,
      community: community ?? this.community,
      directedByGfw: directedByGfw ?? this.directedByGfw,
      seeDeforestation: seeDeforestation ?? this.seeDeforestation,
      deforestationCauses: deforestationCauses ?? this.deforestationCauses,
      furtherActionRequired: furtherActionRequired ?? this.furtherActionRequired,
      reasonForAction: reasonForAction ?? this.reasonForAction,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      photos: photos ?? this.photos,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class PlaceLocation {
  final double latitude;
  final double longitude;
  final double? altitude;
  final double? accuracy;

  PlaceLocation({
    required this.latitude,
    required this.longitude,
    this.altitude,
    this.accuracy,
  });
}

class DeforestationFormData {
  String? gfwDirection;
  String? seeDeforestation;
  List<String> deforestationCauses = [];
  String? otherCause;
  String? actionRequired;
  String? whyAction;
  PlaceLocation? location;
  String? photoBase64;
  int? communityId;
  String? communityName;

  bool get isFormValid {
    return communityId != null &&
        location != null &&
        gfwDirection != null &&
        seeDeforestation != null &&
        photoBase64 != null &&
        photoBase64!.isNotEmpty;
  }

  DeforestationReportModel toReport() {
    return DeforestationReportModel(
      community: communityId?.toString(),
      directedByGfw: gfwDirection,
      seeDeforestation: seeDeforestation,
      deforestationCauses: deforestationCauses,
      furtherActionRequired: actionRequired,
      reasonForAction: whyAction,
      latitude: location?.latitude,
      longitude: location?.longitude,
      photos: photoBase64,
      submissionStatus: 'pending',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  clearFields() {
    gfwDirection = null;
    seeDeforestation = null;
    deforestationCauses = [];
    otherCause = null;
    actionRequired = null;
    whyAction = null;
    location = null;
    photoBase64 = null;
    communityId = null;
    communityName = null;
  }
}