// seedling_monitoring_model.dart

import 'dart:convert';
import 'package:flutter/foundation.dart';

class SeedlingMonitoringModel {
  // General Information
  String? surveyorName;
  String? dateOfSurvey;
  String? community;
  String? farmerName;
  String? farmerIDNumber;
  bool? communityNotFound;
  String? customCommunityName;

  // Plantation Details
  String? plantationType;
  double? totalSizeAcres;
  List<String> speciesProvidedPlanted = [];

  // Species Planting Details
  List<SpeciesPlantingDetail> speciesPlantingDetails = [];

  // Mapped Area
  String? mappedFarmBoundaries;
  double? mappedAreaHectares;

  // Seedling Survival
  int? totalSeedlingsAlive;
  List<String> speciesAlive = [];
  List<String> reasonForDeath = [];
  String? mappedSurvivingSeedlings; // Now stores tree data as JSON

  // Environmental Conditions
  List<String> sourceOfWater = [];
  String? wateringFrequency;
  bool? hasExtremeWeather;
  List<String> extremeWeathers = [];
  String? otherExtremeWeather;

  // Final Observations
  bool? pestsAround;
  String? pestDescription;
  bool? signsOfDisease;
  String? diseaseDescription;
  bool? fertiliserApplied;
  String? fertiliserType;
  bool? pesticideApplied;
  String? pesticideType;
  String? additionalObservations;

  // Metadata
  String? farmerContact;
  String? enumeratorValue;
  DateTime? createdAt;
  String? submissionStatus; // 'draft', 'submitted', 'offline'
  String? connectionStatus; // 'connected', 'not connected'

  SeedlingMonitoringModel({
    // General Information
    this.surveyorName,
    this.dateOfSurvey,
    this.community,
    this.farmerName,
    this.farmerIDNumber,
    this.communityNotFound = false,
    this.customCommunityName,

    // Plantation Details
    this.plantationType,
    this.totalSizeAcres,
    List<String>? speciesProvidedPlanted,

    // Species Planting Details
    List<SpeciesPlantingDetail>? speciesPlantingDetails,

    // Mapped Area
    this.mappedFarmBoundaries,
    this.mappedAreaHectares,

    // Seedling Survival
    this.totalSeedlingsAlive,
    List<String>? speciesAlive,
    List<String>? reasonForDeath,
    this.mappedSurvivingSeedlings,

    // Environmental Conditions
    List<String>? sourceOfWater,
    this.wateringFrequency,
    this.hasExtremeWeather,
    List<String>? extremeWeathers,
    this.otherExtremeWeather,

    // Final Observations
    this.pestsAround,
    this.pestDescription,
    this.signsOfDisease,
    this.diseaseDescription,
    this.fertiliserApplied,
    this.fertiliserType,
    this.pesticideApplied,
    this.pesticideType,
    this.additionalObservations,

    // Metadata
    this.farmerContact,
    this.enumeratorValue,
    this.createdAt,
    this.submissionStatus = 'draft',
    this.connectionStatus = 'not connected',
  }) {
    this.speciesProvidedPlanted = speciesProvidedPlanted ?? [];
    this.speciesPlantingDetails = speciesPlantingDetails ?? [];
    this.speciesAlive = speciesAlive ?? [];
    this.reasonForDeath = reasonForDeath ?? [];
    this.sourceOfWater = sourceOfWater ?? [];
    this.extremeWeathers = extremeWeathers ?? [];
    this.createdAt = createdAt ?? DateTime.now();
  }

  // Tree Data Getters and Setters
  List<Map<String, dynamic>> get treeData {
    if (mappedSurvivingSeedlings == null || mappedSurvivingSeedlings!.isEmpty) {
      return [];
    }
    try {
      return List<Map<String, dynamic>>.from(json.decode(mappedSurvivingSeedlings!));
    } catch (e) {
      debugPrint('Error parsing tree data: $e');
      return [];
    }
  }

  set treeData(List<Map<String, dynamic>> trees) {
    if (trees.isEmpty) {
      mappedSurvivingSeedlings = null;
    } else {
      mappedSurvivingSeedlings = json.encode(trees);
    }
  }

  // Add individual tree
  void addTree(Map<String, dynamic> tree) {
    final currentTrees = treeData;
    currentTrees.add(tree);
    treeData = currentTrees;
  }

  // Remove tree by index
  void removeTree(int index) {
    final currentTrees = treeData;
    if (index >= 0 && index < currentTrees.length) {
      currentTrees.removeAt(index);
      treeData = currentTrees;
    }
  }

  // Get tree count
  int get treeCount => treeData.length;

  // Convert to Map for JSON serialization
  Map<String, dynamic> toJson() {
    return {
      // General Information
      'surveyorName': surveyorName,
      'dateOfSurvey': dateOfSurvey,
      'community': community,
      'farmerName': farmerName,
      'farmerIDNumber': farmerIDNumber,
      'communityNotFound': communityNotFound,
      'customCommunityName': customCommunityName,

      // Plantation Details
      'plantationType': plantationType,
      'totalSizeAcres': totalSizeAcres,
      'speciesProvidedPlanted': speciesProvidedPlanted,

      // Species Planting Details
      'speciesPlantingDetails': speciesPlantingDetails.map((detail) => detail.toJson()).toList(),

      // Mapped Area
      'mappedFarmBoundaries': mappedFarmBoundaries,
      'mappedAreaHectares': mappedAreaHectares,

      // Seedling Survival
      'totalSeedlingsAlive': totalSeedlingsAlive,
      'speciesAlive': speciesAlive,
      'reasonForDeath': reasonForDeath,
      'mappedSurvivingSeedlings': mappedSurvivingSeedlings,

      // Environmental Conditions
      'sourceOfWater': sourceOfWater,
      'wateringFrequency': wateringFrequency,
      'hasExtremeWeather': hasExtremeWeather,
      'extremeWeathers': extremeWeathers,
      'otherExtremeWeather': otherExtremeWeather,

      // Final Observations
      'pestsAround': pestsAround,
      'pestDescription': pestDescription,
      'signsOfDisease': signsOfDisease,
      'diseaseDescription': diseaseDescription,
      'fertiliserApplied': fertiliserApplied,
      'fertiliserType': fertiliserType,
      'pesticideApplied': pesticideApplied,
      'pesticideType': pesticideType,
      'additionalObservations': additionalObservations,

      // Metadata
      'farmerContact': farmerContact,
      'enumeratorValue': enumeratorValue,
      'createdAt': createdAt?.toIso8601String(),
      'submissionStatus': submissionStatus,
      'connectionStatus': connectionStatus,
    };
  }

  // Create from JSON
  factory SeedlingMonitoringModel.fromJson(Map<String, dynamic> json) {
    return SeedlingMonitoringModel(
      // General Information
      surveyorName: json['surveyorName'],
      dateOfSurvey: json['dateOfSurvey'],
      community: json['community'],
      farmerName: json['farmerName'],
      farmerIDNumber: json['farmerIDNumber'],
      communityNotFound: json['communityNotFound'],
      customCommunityName: json['customCommunityName'],

      // Plantation Details
      plantationType: json['plantationType'],
      totalSizeAcres: json['totalSizeAcres']?.toDouble(),
      speciesProvidedPlanted: List<String>.from(json['speciesProvidedPlanted'] ?? []),

      // Species Planting Details
      speciesPlantingDetails: (json['speciesPlantingDetails'] as List<dynamic>?)
          ?.map((detail) => SpeciesPlantingDetail.fromJson(detail))
          .toList() ?? [],

      // Mapped Area
      mappedFarmBoundaries: json['mappedFarmBoundaries'],
      mappedAreaHectares: json['mappedAreaHectares']?.toDouble(),

      // Seedling Survival
      totalSeedlingsAlive: json['totalSeedlingsAlive'],
      speciesAlive: List<String>.from(json['speciesAlive'] ?? []),
      reasonForDeath: List<String>.from(json['reasonForDeath'] ?? []),
      mappedSurvivingSeedlings: json['mappedSurvivingSeedlings'],

      // Environmental Conditions
      sourceOfWater: List<String>.from(json['sourceOfWater'] ?? []),
      wateringFrequency: json['wateringFrequency'],
      hasExtremeWeather: json['hasExtremeWeather'],
      extremeWeathers: List<String>.from(json['extremeWeathers'] ?? []),
      otherExtremeWeather: json['otherExtremeWeather'],

      // Final Observations
      pestsAround: json['pestsAround'],
      pestDescription: json['pestDescription'],
      signsOfDisease: json['signsOfDisease'],
      diseaseDescription: json['diseaseDescription'],
      fertiliserApplied: json['fertiliserApplied'],
      fertiliserType: json['fertiliserType'],
      pesticideApplied: json['pesticideApplied'],
      pesticideType: json['pesticideType'],
      additionalObservations: json['additionalObservations'],

      // Metadata
      farmerContact: json['farmerContact'],
      enumeratorValue: json['enumeratorValue'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      submissionStatus: json['submissionStatus'],
      connectionStatus: json['connectionStatus'],
    );
  }

  // Helper method to check if all required fields are filled
  bool get isComplete {
    return surveyorName != null &&
        surveyorName!.isNotEmpty &&
        dateOfSurvey != null &&
        dateOfSurvey!.isNotEmpty &&
        community != null &&
        community!.isNotEmpty &&
        farmerName != null &&
        farmerName!.isNotEmpty &&
        farmerIDNumber != null &&
        farmerIDNumber!.isNotEmpty &&
        plantationType != null &&
        plantationType!.isNotEmpty &&
        totalSizeAcres != null &&
        speciesProvidedPlanted.isNotEmpty &&
        speciesPlantingDetails.isNotEmpty &&
        totalSeedlingsAlive != null &&
        speciesAlive.isNotEmpty &&
        reasonForDeath.isNotEmpty &&
        sourceOfWater.isNotEmpty &&
        wateringFrequency != null &&
        wateringFrequency!.isNotEmpty &&
        hasExtremeWeather != null &&
        pestsAround != null &&
        signsOfDisease != null &&
        fertiliserApplied != null &&
        pesticideApplied != null;
  }

  // Helper method to get API-ready data structure
  Map<String, dynamic> toApiJson() {
    return {
      "name_of_surveyor": enumeratorValue,
      "date_of_survey": dateOfSurvey,
      "name_of_community": community,
      "name_of_farmer": farmerName,
      "farmer_id_number": farmerIDNumber,
      "type_of_plantation": plantationType,
      "species_provided_planted": speciesProvidedPlanted,
      "planted_species": speciesPlantingDetails.map((detail) => detail.toApiJson()).toList(),
      "farm_boundary": mappedFarmBoundaries,
      "species_alive": speciesAlive,
      "living_species_records": treeData, // Use parsed tree data
      "total_seedlings_alive": totalSeedlingsAlive,
      "reason_for_death": reasonForDeath,
      "source_of_water": sourceOfWater,
      "avg_watering_frequency": wateringFrequency,
      "any_extreme_weather": hasExtremeWeather == true ? "Yes" : "No",
      "extreme_weather_type": extremeWeathers,
      "any_pests_around": pestsAround == true ? "Yes" : "No",
      "pest_description": pestDescription,
      "any_signs_of_disease": signsOfDisease == true ? "Yes" : "No",
      "disease_signs_description": diseaseDescription,
      "any_fertiliser_applied": fertiliserApplied == true ? "Yes" : "No",
      "fertiliser_type": fertiliserType,
      "any_pesticide_herbicide": pesticideApplied == true ? "Yes" : "No",
      "pesticide_herbicide_type": pesticideType,
      "additional_observations": additionalObservations
    };
  }

  // Copy with method for updating values
  SeedlingMonitoringModel copyWith({
    String? surveyorName,
    String? dateOfSurvey,
    String? community,
    String? farmerName,
    String? farmerIDNumber,
    bool? communityNotFound,
    String? customCommunityName,
    String? plantationType,
    double? totalSizeAcres,
    List<String>? speciesProvidedPlanted,
    List<SpeciesPlantingDetail>? speciesPlantingDetails,
    String? mappedFarmBoundaries,
    double? mappedAreaHectares,
    int? totalSeedlingsAlive,
    List<String>? speciesAlive,
    List<String>? reasonForDeath,
    String? mappedSurvivingSeedlings,
    List<String>? sourceOfWater,
    String? wateringFrequency,
    bool? hasExtremeWeather,
    List<String>? extremeWeathers,
    String? otherExtremeWeather,
    bool? pestsAround,
    String? pestDescription,
    bool? signsOfDisease,
    String? diseaseDescription,
    bool? fertiliserApplied,
    String? fertiliserType,
    bool? pesticideApplied,
    String? pesticideType,
    String? additionalObservations,
    String? farmerContact,
    String? enumeratorValue,
    DateTime? createdAt,
    String? submissionStatus,
    String? connectionStatus,
  }) {
    return SeedlingMonitoringModel(
      surveyorName: surveyorName ?? this.surveyorName,
      dateOfSurvey: dateOfSurvey ?? this.dateOfSurvey,
      community: community ?? this.community,
      farmerName: farmerName ?? this.farmerName,
      farmerIDNumber: farmerIDNumber ?? this.farmerIDNumber,
      communityNotFound: communityNotFound ?? this.communityNotFound,
      customCommunityName: customCommunityName ?? this.customCommunityName,
      plantationType: plantationType ?? this.plantationType,
      totalSizeAcres: totalSizeAcres ?? this.totalSizeAcres,
      speciesProvidedPlanted: speciesProvidedPlanted ?? this.speciesProvidedPlanted,
      speciesPlantingDetails: speciesPlantingDetails ?? this.speciesPlantingDetails,
      mappedFarmBoundaries: mappedFarmBoundaries ?? this.mappedFarmBoundaries,
      mappedAreaHectares: mappedAreaHectares ?? this.mappedAreaHectares,
      totalSeedlingsAlive: totalSeedlingsAlive ?? this.totalSeedlingsAlive,
      speciesAlive: speciesAlive ?? this.speciesAlive,
      reasonForDeath: reasonForDeath ?? this.reasonForDeath,
      mappedSurvivingSeedlings: mappedSurvivingSeedlings ?? this.mappedSurvivingSeedlings,
      sourceOfWater: sourceOfWater ?? this.sourceOfWater,
      wateringFrequency: wateringFrequency ?? this.wateringFrequency,
      hasExtremeWeather: hasExtremeWeather ?? this.hasExtremeWeather,
      extremeWeathers: extremeWeathers ?? this.extremeWeathers,
      otherExtremeWeather: otherExtremeWeather ?? this.otherExtremeWeather,
      pestsAround: pestsAround ?? this.pestsAround,
      pestDescription: pestDescription ?? this.pestDescription,
      signsOfDisease: signsOfDisease ?? this.signsOfDisease,
      diseaseDescription: diseaseDescription ?? this.diseaseDescription,
      fertiliserApplied: fertiliserApplied ?? this.fertiliserApplied,
      fertiliserType: fertiliserType ?? this.fertiliserType,
      pesticideApplied: pesticideApplied ?? this.pesticideApplied,
      pesticideType: pesticideType ?? this.pesticideType,
      additionalObservations: additionalObservations ?? this.additionalObservations,
      farmerContact: farmerContact ?? this.farmerContact,
      enumeratorValue: enumeratorValue ?? this.enumeratorValue,
      createdAt: createdAt ?? this.createdAt,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      connectionStatus: connectionStatus ?? this.connectionStatus,
    );
  }
}

class SpeciesPlantingDetail {
  final String species;
  final int quantityReceived;
  final int quantityPlanted;
  final String dateOfPlanting;

  SpeciesPlantingDetail({
    required this.species,
    required this.quantityReceived,
    required this.quantityPlanted,
    required this.dateOfPlanting,
  });

  Map<String, dynamic> toJson() {
    return {
      'species': species,
      'quantityReceived': quantityReceived,
      'quantityPlanted': quantityPlanted,
      'dateOfPlanting': dateOfPlanting,
    };
  }

  factory SpeciesPlantingDetail.fromJson(Map<String, dynamic> json) {
    return SpeciesPlantingDetail(
      species: json['species'],
      quantityReceived: json['quantityReceived'],
      quantityPlanted: json['quantityPlanted'],
      dateOfPlanting: json['dateOfPlanting'],
    );
  }

  Map<String, dynamic> toApiJson() {
    // Convert species name to API format (snake_case)
    String apiSpecies = species.toLowerCase().replaceAll(' ', '_');

    return {
      "species": apiSpecies,
      "quantity_received": quantityReceived,
      "quantity_planted": quantityPlanted,
      "date_of_planting": dateOfPlanting,
    };
  }

  SpeciesPlantingDetail copyWith({
    String? species,
    int? quantityReceived,
    int? quantityPlanted,
    String? dateOfPlanting,
  }) {
    return SpeciesPlantingDetail(
      species: species ?? this.species,
      quantityReceived: quantityReceived ?? this.quantityReceived,
      quantityPlanted: quantityPlanted ?? this.quantityPlanted,
      dateOfPlanting: dateOfPlanting ?? this.dateOfPlanting,
    );
  }
}

// Helper class for species constants
class SpeciesConstants {
  static const List<String> allSpecies = [
    "Prekese",
    "Kokrodua_Afromosia",
    "Dahoma",
    "Edinam",
    "Emire",
    "Ofram",
    "Mahogany_Dubini",
    "Mansonia_Oprono",
    "Okoro",
    "Efoobodedwo_Utile",
    "Bako",
  ];

  static const List<String> deathReasons = [
    "Disease",
    "Drought",
    "Pest",
    "Vandalism",
    "Transportation_Shocks",
  ];

  static const List<String> waterSources = [
    "Rain_Fed",
    "Manual_Watering",
    "Irrigation_With_Pumps",
  ];

  static const List<String> wateringFrequencies = [
    "Daily",
    "Weekly",
    "Monthly",
    "Rarely_Never",
  ];

  static const List<String> extremeWeathers = [
    "Drought",
    "Flooding",
    "Fire",
    "Other",
  ];

  static const List<String> plantationTypes = [
    "Cocoa Farm",
    "Woodlot",
    "Degraded Area",
    "Riparian",
    "Others",
  ];
}

// Extension for model validation
extension SeedlingMonitoringValidation on SeedlingMonitoringModel {
  List<String> validateGeneralInformation() {
    final errors = <String>[];
    if (surveyorName == null || surveyorName!.isEmpty) {
      errors.add('Surveyor name is required');
    }
    if (dateOfSurvey == null || dateOfSurvey!.isEmpty) {
      errors.add('Date of survey is required');
    }
    if (community == null || community!.isEmpty) {
      errors.add('Community is required');
    }
    if (farmerName == null || farmerName!.isEmpty) {
      errors.add('Farmer name is required');
    }
    if (farmerIDNumber == null || farmerIDNumber!.isEmpty) {
      errors.add('Farmer ID number is required');
    }
    return errors;
  }

  List<String> validatePlantationDetails() {
    final errors = <String>[];
    if (plantationType == null || plantationType!.isEmpty) {
      errors.add('Plantation type is required');
    }
    if (totalSizeAcres == null || totalSizeAcres! <= 0) {
      errors.add('Total size in acres is required and must be greater than 0');
    }
    if (speciesProvidedPlanted.isEmpty) {
      errors.add('At least one species must be selected');
    }
    return errors;
  }

  List<String> validateSeedlingSurvival() {
    final errors = <String>[];
    if (totalSeedlingsAlive == null || totalSeedlingsAlive! < 0) {
      errors.add('Total seedlings alive is required');
    }
    if (speciesAlive.isEmpty) {
      errors.add('At least one alive species must be selected');
    }
    if (reasonForDeath.isEmpty) {
      errors.add('At least one reason for death must be selected');
    }
    if (treeCount == 0) {
      errors.add('At least one tree must be mapped for surviving seedlings');
    }
    return errors;
  }

  List<String> validateEnvironmentalConditions() {
    final errors = <String>[];
    if (sourceOfWater.isEmpty) {
      errors.add('At least one water source must be selected');
    }
    if (wateringFrequency == null || wateringFrequency!.isEmpty) {
      errors.add('Watering frequency is required');
    }
    if (hasExtremeWeather == null) {
      errors.add('Please indicate if there were extreme weather events');
    }
    if (hasExtremeWeather == true && extremeWeathers.isEmpty) {
      errors.add('Please specify extreme weather events');
    }
    if (extremeWeathers.contains("Other") &&
        (otherExtremeWeather == null || otherExtremeWeather!.isEmpty)) {
      errors.add('Please specify other extreme weather events');
    }
    return errors;
  }

  List<String> validateFinalObservations() {
    final errors = <String>[];
    if (pestsAround == null) {
      errors.add('Please indicate if pests were observed');
    }
    if (pestsAround == true && (pestDescription == null || pestDescription!.isEmpty)) {
      errors.add('Pest description is required when pests are observed');
    }
    if (signsOfDisease == null) {
      errors.add('Please indicate if disease signs were observed');
    }
    if (signsOfDisease == true && (diseaseDescription == null || diseaseDescription!.isEmpty)) {
      errors.add('Disease description is required when disease signs are observed');
    }
    if (fertiliserApplied == null) {
      errors.add('Please indicate if fertilizer was applied');
    }
    if (fertiliserApplied == true && (fertiliserType == null || fertiliserType!.isEmpty)) {
      errors.add('Fertilizer type is required when fertilizer was applied');
    }
    if (pesticideApplied == null) {
      errors.add('Please indicate if pesticide/herbicide was applied');
    }
    if (pesticideApplied == true && (pesticideType == null || pesticideType!.isEmpty)) {
      errors.add('Pesticide/herbicide type is required when applied');
    }
    return errors;
  }

  List<String> validateAll() {
    return [
      ...validateGeneralInformation(),
      ...validatePlantationDetails(),
      ...validateSeedlingSurvival(),
      ...validateEnvironmentalConditions(),
      ...validateFinalObservations(),
    ];
  }
}