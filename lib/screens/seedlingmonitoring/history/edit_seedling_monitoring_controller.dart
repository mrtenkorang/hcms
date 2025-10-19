// // edit_seedling_monitoring_controller.dart
// import 'dart:collection';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:hcms_revived2/boilerplate/constants.dart';
// import 'package:hcms_revived2/helpers/services/seedling_monitoring_services.dart';
// import 'package:hcms_revived2/models/apimodels/communitymodel.dart';
// import 'package:hcms_revived2/models/localdbmodel/seedling_monitoring_model.dart';
// import 'package:hcms_revived2/screens/addedMaps/dependencies/double_value_trimmer.dart';
// import 'package:hcms_revived2/screens/addedMaps/dependencies/globals.dart';
// import 'package:hcms_revived2/screens/addedMaps/dependencies/polygon_drawing_tool/polygon_drawing_tool.dart';
// import 'package:hcms_revived2/screens/home/index.dart';
// import 'package:hcms_revived2/services/serverurls.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
//
// import '../../addedMaps/dependencies/style.dart';
//
// class EditSeedlingMonitoringController extends GetxController {
//   BuildContext? seedlingMonitoringScreenContext;
//
//   // Service instance
//   final SeedlingMonitoringService monitoringService = Get.find();
//
//   SeedlingMonitoringModel? seedlingMonitoringModel;
//
//   // Reactive variables
//   final RxInt currentPage = 0.obs;
//   final RxBool isLoading = false.obs;
//   final RxString farmerName = ''.obs;
//   final RxString community = ''.obs;
//   final RxBool communityNotFound = false.obs;
//   final RxString dateOfSurvey = ''.obs;
//   final RxString plantationType = ''.obs;
//   final RxList<String> speciesProvidedPlanted = <String>[].obs;
//   final RxList<String> speciesAlive = <String>[].obs;
//   final RxList<String> reasonForDeath = <String>[].obs;
//   final RxList<String> sourceOfWater = <String>[].obs;
//   final RxList<String> extremeWeathers = <String>[].obs;
//   final RxString waterFrequency = ''.obs;
//   final RxBool hasExtremeWeather = false.obs;
//   final RxBool pestsAround = false.obs;
//   final RxBool fertiliserApplied = false.obs;
//   final RxBool pesticideApplied = false.obs;
//   final RxBool signsOfDisease = false.obs;
//
//   // Text controllers
//   final TextEditingController farmerContact = TextEditingController();
//   final TextEditingController surveyorName = TextEditingController();
//   final TextEditingController farmerIDNumber = TextEditingController();
//   final TextEditingController farmerNameController = TextEditingController();
//   final TextEditingController farmSizeAcresController = TextEditingController();
//   final TextEditingController communityName = TextEditingController();
//   final TextEditingController totalSizeAcres = TextEditingController();
//   final TextEditingController totalSeedlingsAlive = TextEditingController();
//   final TextEditingController otherController = TextEditingController();
//   final TextEditingController additionalObservations = TextEditingController();
//   final TextEditingController pestDescription = TextEditingController();
//   final TextEditingController fertiliserType = TextEditingController();
//   final TextEditingController pesticideType = TextEditingController();
//   final TextEditingController diseaseDescription = TextEditingController();
//
//   // Species details controllers
//   final Map<String, TextEditingController> quantityReceivedControllers = {};
//   final Map<String, TextEditingController> quantityPlantedControllers = {};
//   final Map<String, String> plantingDates = {};
//
//
//
//   void _initializeSpeciesPlantingDetails() {
//     if (seedlingMonitoringModel != null) {
//       for (final detail in seedlingMonitoringModel!.speciesPlantingDetails) {
//         // Initialize quantity received controller
//         if (quantityReceivedControllers.containsKey(detail.species)) {
//           quantityReceivedControllers[detail.species]?.text =
//               detail.quantityReceived.toString() ?? '';
//         } else {
//           quantityReceivedControllers[detail.species] =
//               TextEditingController(text: detail.quantityReceived.toString() ?? '');
//         }
//
//         // Initialize quantity planted controller
//         if (quantityPlantedControllers.containsKey(detail.species)) {
//           quantityPlantedControllers[detail.species]?.text =
//               detail.quantityPlanted.toString() ?? '';
//         } else {
//           quantityPlantedControllers[detail.species] =
//               TextEditingController(text: detail.quantityPlanted.toString() ?? '');
//         }
//
//         // Initialize planting dates
//         plantingDates[detail.species] = detail.dateOfPlanting ?? '';
//       }
//     }
//   }
//
//   void _initializePolygonData() {
//     if (seedlingMonitoringModel != null &&
//         seedlingMonitoringModel!.mappedFarmBoundaries != null &&
//         seedlingMonitoringModel!.mappedFarmBoundaries!.isNotEmpty) {
//
//       try {
//         final polygonData = json.decode(seedlingMonitoringModel!.mappedFarmBoundaries!);
//
//         if (polygonData is Map<String, dynamic>) {
//           final points = polygonData['points'] as List?;
//           final strokeColor = polygonData['strokeColor'] as int?;
//           final fillColor = polygonData['fillColor'] as int?;
//           final strokeWidth = polygonData['strokeWidth'] as int?;
//
//           if (points != null) {
//             final List<LatLng> polygonPoints = points.map<LatLng>((point) {
//               return LatLng(
//                 point['latitude'] as double,
//                 point['longitude'] as double,
//               );
//             }).toList();
//
//             polygon = Polygon(
//               polygonId: const PolygonId('loaded_polygon'),
//               points: polygonPoints,
//               strokeWidth: strokeWidth ?? 2,
//               strokeColor: Color(strokeColor ?? Colors.blue.value),
//               fillColor: Color(fillColor ?? Colors.blue.withOpacity(0.3).value),
//             );
//
//             // Initialize markers for polygon vertices
//             markers = HashSet<Marker>();
//             for (int i = 0; i < polygonPoints.length; i++) {
//               markers!.add(
//                 Marker(
//                   markerId: MarkerId('vertex_$i'),
//                   position: polygonPoints[i],
//                   icon: BitmapDescriptor.defaultMarker,
//                 ),
//               );
//             }
//
//             // Update the reactive state
//             update();
//           }
//         }
//       } catch (e) {
//         debugPrint('Error initializing polygon data: $e');
//         // If JSON parsing fails, try to handle as string format
//         _initializePolygonFromString();
//       }
//     }
//   }
//
//   void _initializePolygonFromString() {
//     // Alternative method to parse polygon data if JSON format fails
//     // This handles cases where the data might be stored in a different format
//     final boundaryData = seedlingMonitoringModel!.mappedFarmBoundaries;
//     if (boundaryData != null && boundaryData.isNotEmpty) {
//       try {
//         // Try to parse as a simple coordinate string format
//         final coordinates = boundaryData.split(';');
//         final List<LatLng> polygonPoints = [];
//
//         for (final coord in coordinates) {
//           final parts = coord.split(',');
//           if (parts.length == 2) {
//             final lat = double.tryParse(parts[0]);
//             final lng = double.tryParse(parts[1]);
//             if (lat != null && lng != null) {
//               polygonPoints.add(LatLng(lat, lng));
//             }
//           }
//         }
//
//         if (polygonPoints.isNotEmpty) {
//           polygon = Polygon(
//             polygonId: const PolygonId('loaded_polygon'),
//             points: polygonPoints,
//             strokeWidth: 2,
//             strokeColor: Colors.blue,
//             fillColor: Colors.blue.withOpacity(0.3),
//           );
//
//           update();
//         }
//       } catch (e) {
//         debugPrint('Error initializing polygon from string: $e');
//       }
//     }
//   }
//
// // Additional helper method to ensure all controllers are properly initialized
//   void ensureAllControllersInitialized() {
//     // Initialize any missing species controllers
//     final speciesList = [
//       "Prekese", "Kokrodua_Afromosia", "Dahoma", "Edinam", "Emire",
//       "Ofram", "Mahogany_Dubini", "Mansonia_Oprono", "Okoro",
//       "Efoobodedwo_Utile", "Bako",
//     ];
//
//     for (var species in speciesList) {
//       if (!quantityReceivedControllers.containsKey(species)) {
//         quantityReceivedControllers[species] = TextEditingController();
//       }
//       if (!quantityPlantedControllers.containsKey(species)) {
//         quantityPlantedControllers[species] = TextEditingController();
//       }
//     }
//
//     // Ensure all text controllers have initial values
//     if (farmerContact.text.isEmpty) farmerContact.text = "";
//     if (surveyorName.text.isEmpty) surveyorName.text = "";
//     if (farmerIDNumber.text.isEmpty) farmerIDNumber.text = "";
//     if (farmerNameController.text.isEmpty) farmerNameController.text = "";
//     if (farmSizeAcresController.text.isEmpty) farmSizeAcresController.text = "";
//     if (communityName.text.isEmpty) communityName.text = "";
//     if (totalSizeAcres.text.isEmpty) totalSizeAcres.text = "";
//     if (totalSeedlingsAlive.text.isEmpty) totalSeedlingsAlive.text = "";
//     if (additionalObservations.text.isEmpty) additionalObservations.text = "";
//     if (pestDescription.text.isEmpty) pestDescription.text = "";
//     if (fertiliserType.text.isEmpty) fertiliserType.text = "";
//     if (pesticideType.text.isEmpty) pesticideType.text = "";
//     if (diseaseDescription.text.isEmpty) diseaseDescription.text = "";
//   }
//
//   // Community data
//   final RxList<CommunityJson> communities = <CommunityJson>[].obs;
//   final RxBool loadingCommunities = false.obs;
//
//   /// Collection of polylines for map display
//   Set<Polyline> polyLines = HashSet<Polyline>();
//   Set<Marker>? markers;
//   Polygon? polygon;
//
//   final mapFarmFormKey = GlobalKey<FormState>();
//
//   Globals globals = Globals();
//   DateFormat dateFormat = DateFormat('yyyy-MM-dd');
//
//   @override
//   void onInit() {
//     super.onInit();
//     initializeControllers();
//     loadCommunities();
//     // Start new monitoring session when controller initializes
//     monitoringService.startNewMonitoring();
//   }
//
//   void initializeControllers() {
//     final speciesList = [
//       "Prekese",
//       "Kokrodua_Afromosia",
//       "Dahoma",
//       "Edinam",
//       "Emire",
//       "Ofram",
//       "Mahogany_Dubini",
//       "Mansonia_Oprono",
//       "Okoro",
//       "Efoobodedwo_Utile",
//       "Bako",
//     ];
//
//     for (var species in speciesList) {
//       quantityReceivedControllers[species] = TextEditingController();
//       quantityPlantedControllers[species] = TextEditingController();
//     }
//   }
//
//   // Methods for environmental conditions page
//   void toggleWaterSource(String source, bool selected) {
//     if (selected) {
//       sourceOfWater.add(source);
//     } else {
//       sourceOfWater.remove(source);
//     }
//   }
//
//   void toggleExtremeWeather(String weather, bool selected) {
//     if (selected) {
//       extremeWeathers.add(weather);
//     } else {
//       extremeWeathers.remove(weather);
//     }
//   }
//
//   Future<void> loadCommunities() async {
//     loadingCommunities.value = true;
//     try {
//       final response = await http.get(Uri.parse("$stageBaseUrl/communityapi/"));
//       if (response.statusCode == 200) {
//         final items = json.decode(response.body).cast<Map<String, dynamic>>();
//         communities.assignAll(
//           items
//               .map<CommunityJson>((json) => CommunityJson.fromJson(json))
//               .toList(),
//         );
//       }
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to load communities');
//     } finally {
//       loadingCommunities.value = false;
//     }
//   }
//
//   Future<void> searchFarmer() async {
//     if (farmerContact.text.isEmpty) {
//       Get.snackbar(
//         'Error',
//         'Please enter farmer contact',
//         colorText: Colors.white,
//         backgroundColor: Colors.red,
//       );
//       return;
//     }
//
//     isLoading.value = true;
//     try {
//       final response = await http.get(
//         Uri.parse(
//           "$stageBaseUrl/searchfarmer/?contact=${farmerContact.text}&form=seedling",
//         ),
//       );
//
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         debugPrint("THE FARMER SEARCHED DATA ::::::::::: ${data}");
//         if (data["farmerid"] != null) {
//           farmerName.value = data["farmer_name"] ?? '';
//           farmerNameController.text = data["farmer_name"] ?? '';
//           community.value = data["community_id"] ?? '';
//           farmerIDNumber.text = data["contact"] ?? '';
//           currentPage.value = 1;
//
//           // Update the service with farmer data
//           updateGeneralInfo();
//
//           Get.snackbar(
//             'Success',
//             'Farmer record found',
//             colorText: Colors.white,
//             backgroundColor: Colors.green,
//           );
//         } else {
//           Get.snackbar(
//             'Error',
//             'No farmer record found',
//             colorText: Colors.white,
//             backgroundColor: Colors.red,
//           );
//         }
//       }
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to search farmer');
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   void toggleSpeciesSelection(String species, bool selected) {
//     if (selected) {
//       speciesProvidedPlanted.add(species);
//     } else {
//       speciesProvidedPlanted.remove(species);
//     }
//   }
//
//   void toggleSpeciesAlive(String species, bool selected) {
//     if (selected) {
//       speciesAlive.add(species);
//     } else {
//       speciesAlive.remove(species);
//     }
//   }
//
//   void setPlantingDate(String species, DateTime date) {
//     plantingDates[species] = '${date.year}-${date.month}-${date.day}';
//   }
//
//   void nextPage() {
//     if (currentPage.value < 7) {
//       currentPage.value++;
//       debugPrint(currentPage.value.toString());
//     }
//   }
//
//   void previousPage() {
//     if (currentPage.value > 0) {
//       currentPage.value--;
//     }
//   }
//
//
//   void updateGeneralInfo() {
//     monitoringService.updateGeneralInformation(
//       surveyorName: surveyorName.text,
//       dateOfSurvey: dateOfSurvey.value,
//       community: community.value,
//       farmerName: farmerNameController.text,
//       farmerIDNumber: farmerIDNumber.text,
//       communityNotFound: communityNotFound.value,
//       customCommunityName: communityName.text,
//     );
//   }
//
//   void updatePlantationInfo() {
//     monitoringService.updatePlantationDetails(
//       plantationType: plantationType.value,
//       totalSizeAcres: double.tryParse(totalSizeAcres.text),
//       speciesProvidedPlanted: speciesProvidedPlanted.toList(),
//     );
//   }
//
//   void updateSpeciesDetails() {
//     for (final species in speciesProvidedPlanted) {
//       final received = int.tryParse(quantityReceivedControllers[species]?.text ?? '');
//       final planted = int.tryParse(quantityPlantedControllers[species]?.text ?? '');
//       final date = plantingDates[species];
//
//       if (received != null && planted != null && date != null) {
//         final detail = SpeciesPlantingDetail(
//           species: species,
//           quantityReceived: received,
//           quantityPlanted: planted,
//           dateOfPlanting: date,
//         );
//         monitoringService.addSpeciesPlantingDetail(detail);
//       }
//     }
//   }
//
//   void updateMappedAreaInfo() {
//     monitoringService.updateMappedArea(
//       mappedFarmBoundaries: _getPolygonAsJson(),
//       mappedAreaHectares: double.tryParse(totalSizeAcres.text),
//     );
//   }
//
//   void updateSeedlingSurvivalInfo() {
//     monitoringService.updateSeedlingSurvival(
//       totalSeedlingsAlive: int.tryParse(totalSeedlingsAlive.text),
//       speciesAlive: speciesAlive.toList(),
//       reasonForDeath: reasonForDeath.toList(),
//       mappedSurvivingSeedlings: null, // Add your seedling mapping data here when available
//     );
//   }
//
//   void updateEnvironmentalConditionsInfo() {
//     monitoringService.updateEnvironmentalConditions(
//       sourceOfWater: sourceOfWater.toList(),
//       wateringFrequency: waterFrequency.value,
//       hasExtremeWeather: hasExtremeWeather.value,
//       extremeWeathers: extremeWeathers.toList(),
//       otherExtremeWeather: otherController.text,
//     );
//   }
//
//   void updateFinalObservationsInfo() {
//     monitoringService.updateFinalObservations(
//       pestsAround: pestsAround.value,
//       pestDescription: pestDescription.text,
//       signsOfDisease: signsOfDisease.value,
//       diseaseDescription: diseaseDescription.text,
//       fertiliserApplied: fertiliserApplied.value,
//       fertiliserType: fertiliserType.text,
//       pesticideApplied: pesticideApplied.value,
//       pesticideType: pesticideType.text,
//       additionalObservations: additionalObservations.text,
//     );
//   }
//
//   // Convert polygon to JSON for storage
//   String? _getPolygonAsJson() {
//     if (polygon == null) return null;
//
//     try {
//       final polygonData = {
//         'points': polygon!.points.map((point) => {
//           'latitude': point.latitude,
//           'longitude': point.longitude,
//         }).toList(),
//         'strokeColor': polygon!.strokeColor.value,
//         'fillColor': polygon!.fillColor.value,
//         'strokeWidth': polygon!.strokeWidth,
//       };
//       return json.encode(polygonData);
//     } catch (e) {
//       debugPrint('Error converting polygon to JSON: $e');
//       return null;
//     }
//   }
//
//   // Enhanced submission methods using the model
//   Future<void> submitDataOnline() async {
//     isLoading.value = true;
//
//     try {
//       // Update all data in the service
//       updateGeneralInfo();
//       updatePlantationInfo();
//       updateSpeciesDetails();
//       updateMappedAreaInfo();
//       updateSeedlingSurvivalInfo();
//       updateEnvironmentalConditionsInfo();
//       updateFinalObservationsInfo();
//
//       // Submit via service
//       final success = await monitoringService.submitOnline();
//
//       if (success) {
//         Get.snackbar(
//           'Success',
//           'Data submitted successfully!',
//           colorText: Colors.white,
//           backgroundColor: Colors.green,
//         );
//
//         Navigator.of(seedlingMonitoringScreenContext!).pushAndRemoveUntil(
//           MaterialPageRoute(builder: (context) => const IndexPage()),
//               (Route<dynamic> route) => false,
//         );
//
//
//       }
//     } catch (e) {
//       Get.snackbar(
//         'Submission Error',
//         'Failed to submit data: $e',
//         colorText: Colors.white,
//         backgroundColor: Colors.red,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   Future<void> saveDataOffline() async {
//     debugPrint("SAVING DATA");
//     isLoading.value = true;
//
//     try {
//       // Update all data in the service
//       updateGeneralInfo();
//       updatePlantationInfo();
//       updateSpeciesDetails();
//       updateMappedAreaInfo();
//       updateSeedlingSurvivalInfo();
//       updateEnvironmentalConditionsInfo();
//       updateFinalObservationsInfo();
//
//       // Save offline via service
//       final success = await monitoringService.saveOffline();
//
//       if (success) {
//         Get.snackbar(
//           'Success',
//           'Data saved offline successfully!',
//           colorText: Colors.white,
//           backgroundColor: Colors.green,
//         );
//
//         Navigator.of(seedlingMonitoringScreenContext!).pushAndRemoveUntil(
//           MaterialPageRoute(builder: (context) => const IndexPage()),
//               (Route<dynamic> route) => false,
//         );
//       }
//     } catch (e) {
//       Get.snackbar(
//         'Save Error',
//         'Failed to save data: $e',
//         colorText: Colors.white,
//         backgroundColor: Colors.red,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // Validation methods
//   bool validateCurrentPage() {
//     switch (currentPage.value) {
//       case 0:
//         return farmerContact.text.isNotEmpty;
//       case 1:
//         return surveyorName.text.isNotEmpty &&
//             dateOfSurvey.isNotEmpty &&
//             (community.isNotEmpty || communityName.text.isNotEmpty) &&
//             farmerName.value.isNotEmpty &&
//             farmerIDNumber.text.isNotEmpty;
//       case 2:
//         return plantationType.isNotEmpty && totalSizeAcres.text.isNotEmpty;
//       case 3:
//         return _validateSpeciesDetails();
//       case 4:
//         return _validateMappedArea();
//       case 5:
//         return _validateSeedlingSurvival();
//       case 6:
//         return _validateEnvironmentalConditions();
//       case 7:
//         return _validateFinalObservations();
//       default:
//         return true;
//     }
//   }
//
//   bool _validateSpeciesDetails() {
//     if (speciesProvidedPlanted.isEmpty) return false;
//
//     for (final species in speciesProvidedPlanted) {
//       final received = quantityReceivedControllers[species]?.text;
//       final planted = quantityPlantedControllers[species]?.text;
//       final date = plantingDates[species];
//
//       if (received == null || received.isEmpty) return false;
//       if (planted == null || planted.isEmpty) return false;
//       if (date == null || date.isEmpty) return false;
//     }
//
//     return true;
//   }
//
//   bool _validateMappedArea() {
//     return polygon != null && totalSizeAcres.text.isNotEmpty;
//   }
//
//   bool _validateSeedlingSurvival() {
//     return totalSeedlingsAlive.text.isNotEmpty &&
//         speciesAlive.isNotEmpty &&
//         reasonForDeath.isNotEmpty;
//   }
//
//   bool _validateEnvironmentalConditions() {
//     return sourceOfWater.isNotEmpty &&
//         waterFrequency.value.isNotEmpty &&
//         hasExtremeWeather.value != null;
//   }
//
//   bool _validateFinalObservations() {
//     return pestsAround.value != null &&
//         signsOfDisease.value != null &&
//         fertiliserApplied.value != null &&
//         pesticideApplied.value != null;
//   }
//
//   // Map integration methods
//   usePolygonDrawingTool() {
//     Set<Polygon> polys = HashSet<Polygon>();
//     if (polygon != null) polys.add(polygon!);
//
//     Get.to(
//           () => PolygonDrawingTool(
//         layers: polys,
//         initialPolygon: polygon,
//         viewInitialPolygon: polygon != null,
//         useBackgroundLayers: false,
//         allowTappingInputMethod: false,
//         allowTracingInputMethod: false,
//         maxAccuracy: MaxLocationAccuracy.max,
//         persistMaxAccuracy: true,
//         onSave: (poly, mkr, area) {
//           if (mkr.isNotEmpty) {
//             polygon = poly;
//             markers = mkr;
//             totalSizeAcres.text = area.truncateToDecimalPlaces(6).toString();
//
//             update();
//             globals.showOkayDialog(
//               context: seedlingMonitoringScreenContext,
//               title: 'Measurement Result',
//               image: 'lib/libassets/logos/hcmslogo.jpeg',
//               content: Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 8.0),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Text('measured area estimates in hectares',
//                         style: TextStyle(color: AppColor.black),
//                         textAlign: TextAlign.center),
//                     const SizedBox(height: 15),
//                     Text(
//                         '${area.truncateToDecimalPlaces(6).toString()} ha',
//                         style: TextStyle(
//                             color: AppColor.black,
//                             fontSize: 20,
//                             fontWeight: FontWeight.w600),
//                         textAlign: TextAlign.center),
//                   ],
//                 ),
//               ),
//             );
//           }
//         },
//       ),
//       transition: Transition.fadeIn,
//     );
//   }
//
//   // Methods for seedling survival page
//   void toggleReasonForDeath(String reason, bool selected) {
//     if (selected) {
//       reasonForDeath.add(reason);
//     } else {
//       reasonForDeath.remove(reason);
//     }
//   }
//
//   void saveSeedlingSurvivalData() {
//     updateSeedlingSurvivalInfo();
//
//     // For now, just debugPrint for verification
//     debugPrint('Total Alive: ${totalSeedlingsAlive.text}');
//     debugPrint('Species Alive: $speciesAlive');
//     debugPrint('Reasons for Death: $reasonForDeath');
//   }
//
//   // Add validation method for seedling survival page
//   bool validateSeedlingSurvivalPage() {
//     if (totalSeedlingsAlive.text.isEmpty) return false;
//     if (speciesAlive.isEmpty) return false;
//     if (reasonForDeath.isEmpty) return false;
//     return true;
//   }
//
//   // Get current monitoring data for UI display
//   SeedlingMonitoringModel get currentMonitoringData {
//     return monitoringService.currentMonitoring.value;
//   }
//
//   // Get statistics for dashboard
//   Map<String, dynamic> getStatistics() {
//     return monitoringService.getStatistics();
//   }
//
//   // Load existing monitoring session
//   void loadMonitoringSession(SeedlingMonitoringModel monitoring) {
//     monitoringService.loadMonitoring(monitoring);
//
//     // Sync controller state with loaded data
//     _syncControllerWithMonitoring(monitoring);
//   }
//
//   void _syncControllerWithMonitoring(SeedlingMonitoringModel monitoring) {
//     // Update all reactive variables from the monitoring data
//     surveyorName.text = monitoring.surveyorName ?? '';
//     dateOfSurvey.value = monitoring.dateOfSurvey ?? '';
//     community.value = monitoring.community ?? '';
//     farmerNameController.text = monitoring.farmerName ?? '';
//     farmerIDNumber.text = monitoring.farmerIDNumber ?? '';
//     communityNotFound.value = monitoring.communityNotFound ?? false;
//     communityName.text = monitoring.customCommunityName ?? '';
//
//     plantationType.value = monitoring.plantationType ?? '';
//     totalSizeAcres.text = monitoring.totalSizeAcres?.toString() ?? '';
//     speciesProvidedPlanted.assignAll(monitoring.speciesProvidedPlanted);
//
//     // Update species planting details controllers
//     for (final detail in monitoring.speciesPlantingDetails) {
//       quantityReceivedControllers[detail.species]?.text = detail.quantityReceived.toString();
//       quantityPlantedControllers[detail.species]?.text = detail.quantityPlanted.toString();
//       plantingDates[detail.species] = detail.dateOfPlanting;
//     }
//
//     totalSeedlingsAlive.text = monitoring.totalSeedlingsAlive?.toString() ?? '';
//     speciesAlive.assignAll(monitoring.speciesAlive);
//     reasonForDeath.assignAll(monitoring.reasonForDeath);
//
//     sourceOfWater.assignAll(monitoring.sourceOfWater);
//     waterFrequency.value = monitoring.wateringFrequency ?? '';
//     hasExtremeWeather.value = monitoring.hasExtremeWeather ?? false;
//     extremeWeathers.assignAll(monitoring.extremeWeathers);
//     otherController.text = monitoring.otherExtremeWeather ?? '';
//
//     pestsAround.value = monitoring.pestsAround ?? false;
//     pestDescription.text = monitoring.pestDescription ?? '';
//     signsOfDisease.value = monitoring.signsOfDisease ?? false;
//     diseaseDescription.text = monitoring.diseaseDescription ?? '';
//     fertiliserApplied.value = monitoring.fertiliserApplied ?? false;
//     fertiliserType.text = monitoring.fertiliserType ?? '';
//     pesticideApplied.value = monitoring.pesticideApplied ?? false;
//     pesticideType.text = monitoring.pesticideType ?? '';
//     additionalObservations.text = monitoring.additionalObservations ?? '';
//   }
//
//   @override
//   void onClose() {
//     // Dispose all text controllers
//     farmerContact.dispose();
//     surveyorName.dispose();
//     farmerIDNumber.dispose();
//     farmerNameController.dispose();
//     farmSizeAcresController.dispose();
//     communityName.dispose();
//     totalSizeAcres.dispose();
//     totalSeedlingsAlive.dispose();
//     otherController.dispose();
//     additionalObservations.dispose();
//     pestDescription.dispose();
//     fertiliserType.dispose();
//     pesticideType.dispose();
//     diseaseDescription.dispose();
//
//     for (var controller in quantityReceivedControllers.values) {
//       controller.dispose();
//     }
//     for (var controller in quantityPlantedControllers.values) {
//       controller.dispose();
//     }
//
//     super.onClose();
//   }
// }




// edit_seedling_monitoring_controller.dart
import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hcms_revived2/helpers/services/seedling_monitoring_services.dart';
import 'package:hcms_revived2/models/apimodels/communitymodel.dart';
import 'package:hcms_revived2/models/localdbmodel/seedling_monitoring_model.dart';
import 'package:hcms_revived2/screens/addedMaps/dependencies/double_value_trimmer.dart';
import 'package:hcms_revived2/screens/addedMaps/dependencies/globals.dart';
import 'package:hcms_revived2/screens/addedMaps/dependencies/polygon_drawing_tool/polygon_drawing_tool.dart';
import 'package:hcms_revived2/screens/addedMaps/dependencies/tree_picking_tool/pick_tree_map_controller.dart';
import 'package:hcms_revived2/screens/home/index.dart';
import 'package:hcms_revived2/services/serverurls.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../boilerplate/constants.dart';
import 'package:get/get.dart';
import '../../addedMaps/dependencies/style.dart';
import '../../addedMaps/dependencies/tree_picking_tool/pick_tree_map_controller.dart';

class EditSeedlingMonitoringController extends GetxController {
  BuildContext? seedlingMonitoringScreenContext;

  // Service instance
  late final SeedlingMonitoringService monitoringService;
  late final PickTreeMapController pickTreeMapController;


  // Reactive variables
  final RxInt currentPage = 0.obs;
  final RxBool isLoading = false.obs;
  final RxString farmerName = ''.obs;
  final RxString community = ''.obs;
  final RxBool communityNotFound = false.obs;
  final RxString dateOfSurvey = ''.obs;
  final RxString plantationType = ''.obs;
  final RxList<String> speciesProvidedPlanted = <String>[].obs;
  final RxList<String> speciesAlive = <String>[].obs;
  final RxList<String> reasonForDeath = <String>[].obs;
  final RxList<String> sourceOfWater = <String>[].obs;
  final RxList<String> extremeWeathers = <String>[].obs;
  final RxString waterFrequency = ''.obs;
  final RxBool hasExtremeWeather = false.obs;
  final RxBool pestsAround = false.obs;
  final RxBool fertiliserApplied = false.obs;
  final RxBool pesticideApplied = false.obs;
  final RxBool signsOfDisease = false.obs;

  // Tree data management
  final List<Map<String, dynamic>> treeData = [];

  // Method to add a tree to the list
  void addTree(Map<String, dynamic> tree) {
    treeData.add(tree);
    update();
  }

  // Method to remove a tree from the list
  void removeTree(String treeId) {
    treeData.removeWhere((tree) => tree['id'] == treeId);
    update();
  }

  // Method to clear all trees
  void clearAllTrees() {
    treeData.clear();
    update();
  }

  // Text controllers
  final TextEditingController farmerContact = TextEditingController();
  final TextEditingController surveyorName = TextEditingController();
  final TextEditingController farmerIDNumber = TextEditingController();
  final TextEditingController farmerNameController = TextEditingController();
  final TextEditingController farmSizeAcresController = TextEditingController();
  final TextEditingController communityName = TextEditingController();
  final TextEditingController totalSizeAcres = TextEditingController();
  final TextEditingController totalSeedlingsAlive = TextEditingController();
  final TextEditingController otherController = TextEditingController();
  final TextEditingController additionalObservations = TextEditingController();
  final TextEditingController pestDescription = TextEditingController();
  final TextEditingController fertiliserType = TextEditingController();
  final TextEditingController pesticideType = TextEditingController();
  final TextEditingController diseaseDescription = TextEditingController();

  // Species details controllers
  final Map<String, TextEditingController> quantityReceivedControllers = {};
  final Map<String, TextEditingController> quantityPlantedControllers = {};
  final Map<String, String> plantingDates = {};

  // Community data
  final RxList<CommunityJson> communities = <CommunityJson>[].obs;
  final RxBool loadingCommunities = false.obs;

  /// Collection of polylines for map display
  Set<Polyline> polyLines = HashSet<Polyline>();
  Set<Marker>? markers;
  Polygon? polygon;

  final mapFarmFormKey = GlobalKey<FormState>();
  var treeTypes = [].obs;

  Globals globals = Globals();
  DateFormat dateFormat = DateFormat('yyyy-MM-dd');

  SeedlingMonitoringModel? seedlingMonitoringModel;

  void initializeData() {
    if (seedlingMonitoringModel != null) {
      // General Information
      farmerContact.text = seedlingMonitoringModel!.farmerContact ?? "";
      surveyorName.text = seedlingMonitoringModel!.surveyorName ?? "";
      farmerIDNumber.text = seedlingMonitoringModel!.farmerIDNumber ?? "";
      farmerNameController.text = seedlingMonitoringModel!.farmerName ?? "";
      farmSizeAcresController.text = seedlingMonitoringModel!.totalSizeAcres?.toString() ?? "";
      communityName.text = seedlingMonitoringModel!.community ?? "";
      totalSizeAcres.text = seedlingMonitoringModel!.totalSizeAcres?.toString() ?? "";
      totalSeedlingsAlive.text = seedlingMonitoringModel!.totalSeedlingsAlive?.toString() ?? "";
      additionalObservations.text = seedlingMonitoringModel!.additionalObservations ?? "";
      pestDescription.text = seedlingMonitoringModel!.pestDescription ?? "";
      fertiliserType.text = seedlingMonitoringModel!.fertiliserType ?? "";
      pesticideType.text = seedlingMonitoringModel!.pesticideType ?? "";
      diseaseDescription.text = seedlingMonitoringModel!.diseaseDescription ?? "";

      // Reactive variables
      farmerName.value = seedlingMonitoringModel!.farmerName ?? '';
      community.value = seedlingMonitoringModel!.community ?? '';
      dateOfSurvey.value = seedlingMonitoringModel!.dateOfSurvey ?? '';
      plantationType.value = seedlingMonitoringModel!.plantationType ?? '';
      waterFrequency.value = seedlingMonitoringModel!.wateringFrequency ?? '';

      // Boolean flags
      communityNotFound.value = seedlingMonitoringModel!.communityNotFound ?? false;
      hasExtremeWeather.value = seedlingMonitoringModel!.hasExtremeWeather ?? false;
      pestsAround.value = seedlingMonitoringModel!.pestsAround ?? false;
      signsOfDisease.value = seedlingMonitoringModel!.signsOfDisease ?? false;
      fertiliserApplied.value = seedlingMonitoringModel!.fertiliserApplied ?? false;
      pesticideApplied.value = seedlingMonitoringModel!.pesticideApplied ?? false;

      // List data
      speciesProvidedPlanted.assignAll(seedlingMonitoringModel!.speciesProvidedPlanted);
      speciesAlive.assignAll(seedlingMonitoringModel!.speciesAlive);
      reasonForDeath.assignAll(seedlingMonitoringModel!.reasonForDeath);
      sourceOfWater.assignAll(seedlingMonitoringModel!.sourceOfWater);
      extremeWeathers.assignAll(seedlingMonitoringModel!.extremeWeathers);

      // Initialize species planting details controllers
      _initializeSpeciesPlantingDetails();

      // Initialize polygon data if available
      _initializePolygonData();

      // Update the monitoring service with the loaded data
      monitoringService.loadMonitoring(seedlingMonitoringModel!);
    }
  }

  void _initializeSpeciesPlantingDetails() {
    if (seedlingMonitoringModel != null) {
      for (final detail in seedlingMonitoringModel!.speciesPlantingDetails) {
        // Initialize quantity received controller
        if (quantityReceivedControllers.containsKey(detail.species)) {
          quantityReceivedControllers[detail.species]?.text =
              detail.quantityReceived.toString() ?? '';
        } else {
          quantityReceivedControllers[detail.species] =
              TextEditingController(text: detail.quantityReceived.toString() ?? '');
        }

        // Initialize quantity planted controller
        if (quantityPlantedControllers.containsKey(detail.species)) {
          quantityPlantedControllers[detail.species]?.text =
              detail.quantityPlanted.toString() ?? '';
        } else {
          quantityPlantedControllers[detail.species] =
              TextEditingController(text: detail.quantityPlanted.toString() ?? '');
        }

        // Initialize planting dates
        plantingDates[detail.species] = detail.dateOfPlanting ?? '';
      }
    }
  }

  void _initializePolygonData() {
    if (seedlingMonitoringModel != null &&
        seedlingMonitoringModel!.mappedFarmBoundaries != null &&
        seedlingMonitoringModel!.mappedFarmBoundaries!.isNotEmpty) {

      try {
        final polygonData = json.decode(seedlingMonitoringModel!.mappedFarmBoundaries!);

        if (polygonData is Map<String, dynamic>) {
          final points = polygonData['points'] as List?;
          final strokeColor = polygonData['strokeColor'] as int?;
          final fillColor = polygonData['fillColor'] as int?;
          final strokeWidth = polygonData['strokeWidth'] as int?;

          if (points != null) {
            final List<LatLng> polygonPoints = points.map<LatLng>((point) {
              return LatLng(
                point['latitude'] as double,
                point['longitude'] as double,
              );
            }).toList();

            polygon = Polygon(
              polygonId: const PolygonId('loaded_polygon'),
              points: polygonPoints,
              strokeWidth: strokeWidth ?? 2,
              strokeColor: Color(strokeColor ?? Colors.blue.value),
              fillColor: Color(fillColor ?? Colors.blue.withOpacity(0.3).value),
            );

            // Initialize markers for polygon vertices
            markers = HashSet<Marker>();
            for (int i = 0; i < polygonPoints.length; i++) {
              markers!.add(
                Marker(
                  markerId: MarkerId('vertex_$i'),
                  position: polygonPoints[i],
                  icon: BitmapDescriptor.defaultMarker,
                ),
              );
            }

            // Update the reactive state
            update();
          }
        }
      } catch (e) {
        debugPrint('Error initializing polygon data: $e');
        // If JSON parsing fails, try to handle as string format
        _initializePolygonFromString();
      }
    }
  }

  void _initializePolygonFromString() {
    // Alternative method to parse polygon data if JSON format fails
    // This handles cases where the data might be stored in a different format
    final boundaryData = seedlingMonitoringModel!.mappedFarmBoundaries;
    if (boundaryData != null && boundaryData.isNotEmpty) {
      try {
        // Try to parse as a simple coordinate string format
        final coordinates = boundaryData.split(';');
        final List<LatLng> polygonPoints = [];

        for (final coord in coordinates) {
          final parts = coord.split(',');
          if (parts.length == 2) {
            final lat = double.tryParse(parts[0]);
            final lng = double.tryParse(parts[1]);
            if (lat != null && lng != null) {
              polygonPoints.add(LatLng(lat, lng));
            }
          }
        }

        if (polygonPoints.isNotEmpty) {
          polygon = Polygon(
            polygonId: const PolygonId('loaded_polygon'),
            points: polygonPoints,
            strokeWidth: 2,
            strokeColor: Colors.blue,
            fillColor: Colors.blue.withOpacity(0.3),
          );

          update();
        }
      } catch (e) {
        debugPrint('Error initializing polygon from string: $e');
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    initializeControllers();
    loadCommunities();
    monitoringService = Get.find<SeedlingMonitoringService>();
    pickTreeMapController = Get.find<PickTreeMapController>();
    // Start new monitoring session when controller initializes
    monitoringService.startNewMonitoring();
  }

  void initializeControllers() {
    final speciesList = [
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

    for (var species in speciesList) {
      quantityReceivedControllers[species] = TextEditingController();
      quantityPlantedControllers[species] = TextEditingController();
    }
  }

  // Methods for environmental conditions page
  void toggleWaterSource(String source, bool selected) {
    if (selected) {
      sourceOfWater.add(source);
    } else {
      sourceOfWater.remove(source);
    }
  }

  void toggleExtremeWeather(String weather, bool selected) {
    if (selected) {
      extremeWeathers.add(weather);
    } else {
      extremeWeathers.remove(weather);
    }
  }

  Future<void> loadCommunities() async {
    loadingCommunities.value = true;
    try {
      final response = await http.get(Uri.parse("$stageBaseUrl/communityapi/"));
      if (response.statusCode == 200) {
        final items = json.decode(response.body).cast<Map<String, dynamic>>();
        communities.assignAll(
          items
              .map<CommunityJson>((json) => CommunityJson.fromJson(json))
              .toList(),
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load communities');
    } finally {
      loadingCommunities.value = false;
    }
  }

  Future<void> searchFarmer() async {
    if (farmerContact.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter farmer contact',
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
      return;
    }

    isLoading.value = true;
    try {
      final response = await http.get(
        Uri.parse(
          "$stageBaseUrl/searchfarmer/?contact=${farmerContact.text}&form=seedling",
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        debugPrint("THE FARMER SEARCHED DATA ::::::::::: ${data}");
        if (data["farmerid"] != null) {
          farmerName.value = data["farmer_name"] ?? '';
          farmerNameController.text = data["farmer_name"] ?? '';
          community.value = data["community_id"] ?? '';
          farmerIDNumber.text = data["contact"] ?? '';
          currentPage.value = 1;

          // Update the service with farmer data
          updateGeneralInfo();

          Get.snackbar(
            'Success',
            'Farmer record found',
            colorText: Colors.white,
            backgroundColor: Colors.green,
          );
        } else {
          Get.snackbar(
            'Error',
            'No farmer record found',
            colorText: Colors.white,
            backgroundColor: Colors.red,
          );
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to search farmer');
    } finally {
      isLoading.value = false;
    }
  }

  void toggleSpeciesSelection(String species, bool selected) {
    if (selected) {
      speciesProvidedPlanted.add(species);
    } else {
      speciesProvidedPlanted.remove(species);
    }
  }

  void toggleSpeciesAlive(String species, bool selected) {
    if (selected) {
      speciesAlive.add(species);
    } else {
      speciesAlive.remove(species);
    }
  }

  void setPlantingDate(String species, DateTime date) {
    plantingDates[species] = '${date.year}-${date.month}-${date.day}';
  }

  void nextPage() {
    if (currentPage.value < 7) {
      currentPage.value++;
      debugPrint(currentPage.value.toString());
    }
  }

  void previousPage() {
    if (currentPage.value > 0) {
      currentPage.value--;
    }
  }


  void updateTreeData() {
    try {
      if (treeData.isNotEmpty) {
        // Set all tree data at once
        monitoringService.setTreeData(List<Map<String, dynamic>>.from(treeData));
        debugPrint('Updated tree data with ${treeData.length} trees');
      } else {
        monitoringService.clearTreeData();
        debugPrint('Cleared tree data');
      }
      update(); // Notify listeners about the update
    } catch (e) {
      debugPrint('Error updating tree data: $e');
      // If there's an error, clear the tree data to prevent invalid state
      monitoringService.clearTreeData();
    }
  }

  void updateGeneralInfo() {
    monitoringService.updateGeneralInformation(
      surveyorName: surveyorName.text,
      dateOfSurvey: dateOfSurvey.value,
      community: community.value,
      farmerName: farmerNameController.text,
      farmerIDNumber: farmerIDNumber.text,
      communityNotFound: communityNotFound.value,
      customCommunityName: communityName.text,
    );
  }

  void updatePlantationInfo() {
    monitoringService.updatePlantationDetails(
      plantationType: plantationType.value,
      totalSizeAcres: double.tryParse(totalSizeAcres.text),
      speciesProvidedPlanted: speciesProvidedPlanted.toList(),
    );
  }

  void updateSpeciesDetails() {
    for (final species in speciesProvidedPlanted) {
      final received = int.tryParse(quantityReceivedControllers[species]?.text ?? '');
      final planted = int.tryParse(quantityPlantedControllers[species]?.text ?? '');
      final date = plantingDates[species];

      if (received != null && planted != null && date != null) {
        final detail = SpeciesPlantingDetail(
          species: species,
          quantityReceived: received,
          quantityPlanted: planted,
          dateOfPlanting: date,
        );
        monitoringService.addSpeciesPlantingDetail(detail);
      }
    }
  }

  void updateMappedAreaInfo() {
    monitoringService.updateMappedArea(
      mappedFarmBoundaries: _getPolygonAsJson(),
      mappedAreaHectares: double.tryParse(totalSizeAcres.text),
    );
  }

  void updateSeedlingSurvivalInfo() {
    // Update tree data first
    updateTreeData();

    monitoringService.updateSeedlingSurvival(
      totalSeedlingsAlive: int.tryParse(totalSeedlingsAlive.text),
      speciesAlive: speciesAlive.toList(),
      reasonForDeath: reasonForDeath.toList(),
      treeData: monitoringService.currentMonitoring.value.treeData,
    );
  }

  void updateEnvironmentalConditionsInfo() {
    monitoringService.updateEnvironmentalConditions(
      sourceOfWater: sourceOfWater.toList(),
      wateringFrequency: waterFrequency.value,
      hasExtremeWeather: hasExtremeWeather.value,
      extremeWeathers: extremeWeathers.toList(),
      otherExtremeWeather: otherController.text,
    );
  }

  void updateFinalObservationsInfo() {
    monitoringService.updateFinalObservations(
      pestsAround: pestsAround.value,
      pestDescription: pestDescription.text,
      signsOfDisease: signsOfDisease.value,
      diseaseDescription: diseaseDescription.text,
      fertiliserApplied: fertiliserApplied.value,
      fertiliserType: fertiliserType.text,
      pesticideApplied: pesticideApplied.value,
      pesticideType: pesticideType.text,
      additionalObservations: additionalObservations.text,
    );
  }

  // Convert polygon to JSON for storage
  String? _getPolygonAsJson() {
    if (polygon == null) return null;

    try {
      final polygonData = {
        'points': polygon!.points.map((point) => {
          'latitude': point.latitude,
          'longitude': point.longitude,
        }).toList(),
        'strokeColor': polygon!.strokeColor.value,
        'fillColor': polygon!.fillColor.value,
        'strokeWidth': polygon!.strokeWidth,
      };
      return json.encode(polygonData);
    } catch (e) {
      debugPrint('Error converting polygon to JSON: $e');
      return null;
    }
  }

  // Enhanced submission methods using the model
  Future<void> submitDataOnline() async {
    isLoading.value = true;

    try {
      // Update all data in the service
      updateGeneralInfo();
      updatePlantationInfo();
      updateSpeciesDetails();
      updateMappedAreaInfo();
      updateSeedlingSurvivalInfo();
      updateEnvironmentalConditionsInfo();
      updateFinalObservationsInfo();

      // Submit via service
      final success = await monitoringService.submitOnline();

      if (success) {
        Get.snackbar(
          'Success',
          'Data submitted successfully!',
          colorText: Colors.white,
          backgroundColor: Colors.green,
        );

        Navigator.of(seedlingMonitoringScreenContext!).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const IndexPage()),
              (Route<dynamic> route) => false,
        );


      }
    } catch (e) {
      Get.snackbar(
        'Submission Error',
        'Failed to submit data: $e',
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveDataOffline() async {
    debugPrint("SAVING DATA");
    isLoading.value = true;

    try {
      // Update all data in the service
      updateGeneralInfo();
      updatePlantationInfo();
      updateSpeciesDetails();
      updateMappedAreaInfo();
      updateSeedlingSurvivalInfo();
      updateEnvironmentalConditionsInfo();
      updateFinalObservationsInfo();

      // Save offline via service
      final success = await monitoringService.saveOffline();

      if (success) {
        clearForm();
        Get.snackbar(
          'Success',
          'Data saved offline successfully!',
          colorText: Colors.white,
          backgroundColor: Colors.green,
        );

        Navigator.of(seedlingMonitoringScreenContext!).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const IndexPage()),
              (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Save Error',
        'Failed to save data: $e',
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Validation methods
  bool validateCurrentPage() {
    switch (currentPage.value) {
      case 0:
        return farmerContact.text.isNotEmpty;
      case 1:
        return surveyorName.text.isNotEmpty &&
            dateOfSurvey.isNotEmpty &&
            (community.isNotEmpty || communityName.text.isNotEmpty) &&
            farmerName.value.isNotEmpty &&
            farmerIDNumber.text.isNotEmpty;
      case 2:
        return plantationType.isNotEmpty && totalSizeAcres.text.isNotEmpty;
      case 3:
        return _validateSpeciesDetails();
      case 4:
        return _validateMappedArea();
      case 5:
        return _validateSeedlingSurvival();
      case 6:
        return _validateEnvironmentalConditions();
      case 7:
        return _validateFinalObservations();
      default:
        return true;
    }
  }

  bool _validateSpeciesDetails() {
    if (speciesProvidedPlanted.isEmpty) return false;

    for (final species in speciesProvidedPlanted) {
      final received = quantityReceivedControllers[species]?.text;
      final planted = quantityPlantedControllers[species]?.text;
      final date = plantingDates[species];

      if (received == null || received.isEmpty) return false;
      if (planted == null || planted.isEmpty) return false;
      if (date == null || date.isEmpty) return false;
    }

    return true;
  }

  bool _validateMappedArea() {
    return polygon != null && totalSizeAcres.text.isNotEmpty;
  }

  bool _validateSeedlingSurvival() {
    return totalSeedlingsAlive.text.isNotEmpty &&
        speciesAlive.isNotEmpty &&
        reasonForDeath.isNotEmpty &&
        treeCount > 0; // Ensure at least one tree is mapped
  }

  bool _validateEnvironmentalConditions() {
    return sourceOfWater.isNotEmpty &&
        waterFrequency.value.isNotEmpty &&
        hasExtremeWeather.value != null;
  }

  bool _validateFinalObservations() {
    return pestsAround.value != null &&
        signsOfDisease.value != null &&
        fertiliserApplied.value != null &&
        pesticideApplied.value != null;
  }

  // Map integration methods
  usePolygonDrawingTool() {
    Set<Polygon> polys = HashSet<Polygon>();
    if (polygon != null) polys.add(polygon!);

    Get.to(
          () => PolygonDrawingTool(
        layers: polys,
        initialPolygon: polygon,
        viewInitialPolygon: polygon != null,
        useBackgroundLayers: false,
        allowTappingInputMethod: false,
        allowTracingInputMethod: false,
        maxAccuracy: MaxLocationAccuracy.max,
        persistMaxAccuracy: true,
        onSave: (poly, mkr, area) {
          if (mkr.isNotEmpty) {
            polygon = poly;
            markers = mkr;
            totalSizeAcres.text = area.truncateToDecimalPlaces(6).toString();

            update();
            globals.showOkayDialog(
              context: seedlingMonitoringScreenContext,
              title: 'Measurement Result',
              image: 'lib/libassets/logos/hcmslogo.jpeg',
              content: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('measured area estimates in hectares',
                        style: TextStyle(color: AppColor.black),
                        textAlign: TextAlign.center),
                    const SizedBox(height: 15),
                    Text(
                        '${area.truncateToDecimalPlaces(6).toString()} ha',
                        style: TextStyle(
                            color: AppColor.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center),
                  ],
                ),
              ),
            );
          }
        },
      ),
      transition: Transition.fadeIn,
    );
  }

  // Methods for seedling survival page
  void toggleReasonForDeath(String reason, bool selected) {
    if (selected) {
      reasonForDeath.add(reason);
    } else {
      reasonForDeath.remove(reason);
    }
  }

  void saveSeedlingSurvivalData() {
    updateSeedlingSurvivalInfo();

    // For now, just debugPrint for verification
    debugPrint('Total Alive: ${totalSeedlingsAlive.text}');
    debugPrint('Species Alive: $speciesAlive');
    debugPrint('Reasons for Death: $reasonForDeath');
    debugPrint('Tree Count: $treeCount');
  }

  // Add validation method for seedling survival page
  bool validateSeedlingSurvivalPage() {
    if (totalSeedlingsAlive.text.isEmpty) return false;
    if (speciesAlive.isEmpty) return false;
    if (reasonForDeath.isEmpty) return false;
    if (treeCount == 0) return false;
    return true;
  }

  // Get current monitoring data for UI display
  SeedlingMonitoringModel get currentMonitoringData {
    return monitoringService.currentMonitoring.value;
  }

  // Get current tree data
  List<Map<String, dynamic>> get currentTreeData {
    return monitoringService.currentMonitoring.value.treeData;
  }

  // Get tree count
  int get treeCount => monitoringService.treeCount;

  // Get statistics for dashboard
  Map<String, dynamic> getStatistics() {
    return monitoringService.getStatistics();
  }

  // Load existing monitoring session
  void loadMonitoringSession(SeedlingMonitoringModel monitoring) {
    monitoringService.loadMonitoring(monitoring);

    // Sync controller state with loaded data
    _syncControllerWithMonitoring(monitoring);
  }

  void _syncControllerWithMonitoring(SeedlingMonitoringModel monitoring) {
    // Update all reactive variables from the monitoring data
    surveyorName.text = monitoring.surveyorName ?? '';
    dateOfSurvey.value = monitoring.dateOfSurvey ?? '';
    community.value = monitoring.community ?? '';
    farmerNameController.text = monitoring.farmerName ?? '';
    farmerIDNumber.text = monitoring.farmerIDNumber ?? '';
    communityNotFound.value = monitoring.communityNotFound ?? false;
    communityName.text = monitoring.customCommunityName ?? '';

    plantationType.value = monitoring.plantationType ?? '';
    totalSizeAcres.text = monitoring.totalSizeAcres?.toString() ?? '';
    speciesProvidedPlanted.assignAll(monitoring.speciesProvidedPlanted);

    // Update species planting details controllers
    for (final detail in monitoring.speciesPlantingDetails) {
      quantityReceivedControllers[detail.species]?.text = detail.quantityReceived.toString();
      quantityPlantedControllers[detail.species]?.text = detail.quantityPlanted.toString();
      plantingDates[detail.species] = detail.dateOfPlanting;
    }

    totalSeedlingsAlive.text = monitoring.totalSeedlingsAlive?.toString() ?? '';
    speciesAlive.assignAll(monitoring.speciesAlive);
    reasonForDeath.assignAll(monitoring.reasonForDeath);

    sourceOfWater.assignAll(monitoring.sourceOfWater);
    waterFrequency.value = monitoring.wateringFrequency ?? '';
    hasExtremeWeather.value = monitoring.hasExtremeWeather ?? false;
    extremeWeathers.assignAll(monitoring.extremeWeathers);
    otherController.text = monitoring.otherExtremeWeather ?? '';

    pestsAround.value = monitoring.pestsAround ?? false;
    pestDescription.text = monitoring.pestDescription ?? '';
    signsOfDisease.value = monitoring.signsOfDisease ?? false;
    diseaseDescription.text = monitoring.diseaseDescription ?? '';
    fertiliserApplied.value = monitoring.fertiliserApplied ?? false;
    fertiliserType.text = monitoring.fertiliserType ?? '';
    pesticideApplied.value = monitoring.pesticideApplied ?? false;
    pesticideType.text = monitoring.pesticideType ?? '';
    additionalObservations.text = monitoring.additionalObservations ?? '';

    // Sync tree data with map controller if needed
    // if (monitoring.treeData.isNotEmpty) {
    //   treeData = monitoring.treeData;
    // }
  }

  @override
  void onClose() {
    // Dispose all text controllers
    farmerContact.dispose();
    surveyorName.dispose();
    farmerIDNumber.dispose();
    farmerNameController.dispose();
    farmSizeAcresController.dispose();
    communityName.dispose();
    totalSizeAcres.dispose();
    totalSeedlingsAlive.dispose();
    otherController.dispose();
    additionalObservations.dispose();
    pestDescription.dispose();
    fertiliserType.dispose();
    pesticideType.dispose();
    diseaseDescription.dispose();

    for (var controller in quantityReceivedControllers.values) {
      controller.dispose();
    }
    for (var controller in quantityPlantedControllers.values) {
      controller.dispose();
    }

    super.onClose();
  }

  /// Clears all form fields and resets the form to its initial state
  void clearForm() {
    // Reset page state
    currentPage.value = 0;

    // Clear text controllers
    farmerContact.clear();
    surveyorName.clear();
    farmerIDNumber.clear();
    farmerNameController.clear();
    farmSizeAcresController.clear();
    communityName.clear();
    totalSizeAcres.clear();
    totalSeedlingsAlive.clear();
    otherController.clear();

    // Reset observable variables
    farmerName.value = '';
    community.value = '';
    dateOfSurvey.value = '';
    plantationType.value = '';
    waterFrequency.value = '';

    // Clear lists
    speciesProvidedPlanted.clear();
    speciesAlive.clear();
    reasonForDeath.clear();
    sourceOfWater.clear();
    extremeWeathers.clear();

    // Reset boolean flags
    hasExtremeWeather.value = false;
    pestsAround.value = false;
    fertiliserApplied.value = false;
    pesticideApplied.value = false;
    signsOfDisease.value = false;

    // clear polygons and markers
    polygon = null;
    markers?.clear();

    // Clear tree data
    treeData.clear();

    // Reset any other necessary state
    communityNotFound.value = false;

    // Notify listeners
    update();

    debugPrint('Form has been cleared');
  }
}

