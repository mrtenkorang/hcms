import 'dart:async';
import 'dart:io';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:geolocator/geolocator.dart' as gl;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/boilerplate/methods.dart';
import 'package:hcms_revived2/helpers/geo_fence/tree_within_polygon.dart';
import 'package:hcms_revived2/screens/addedMaps/dependencies/custom_button.dart';
import 'package:hcms_revived2/screens/addedMaps/dependencies/double_value_trimmer.dart';
import 'package:hcms_revived2/screens/addedMaps/dependencies/globals.dart';
import 'package:hcms_revived2/screens/addedMaps/dependencies/style.dart';
import 'package:hcms_revived2/screens/addedMaps/dependencies/tree_picking_tool/pick_tree_map_controller.dart';
import 'package:hcms_revived2/screens/addedMaps/dependencies/user_current_location.dart';
import 'package:hcms_revived2/screens/farmregistration/tree_registration/tree_registration_controller.dart';
import 'package:hcms_revived2/screens/seedlingmonitoring/seedling_monitoring_controller.dart';
import 'package:hcms_revived2/utils/widgets/textFields/generic_text_field.dart';
import 'package:hcms_revived2/utils/widgets/textFormats/app_text.dart';
import 'package:location/location.dart';
import 'dart:ui' as ui;

class PickTreesMap extends StatefulWidget {
  final Map<String, dynamic> farm;
  final bool isViewMode;
  final bool isViewModePolygon;
  final List? existingTreeData;
  final bool isTreeRegisterModeOther;
  final bool isTreeRegisterMode;

  const PickTreesMap({
    super.key,
    required this.farm,
    required this.survivedSeedlings,
    this.isViewModePolygon = false,
    this.isViewMode = false,
    this.existingTreeData,
    this.isTreeRegisterMode = false,
    this.isTreeRegisterModeOther = false,
  });

  final List<String> survivedSeedlings;

  @override
  _PickTreesMapState createState() => _PickTreesMapState();
}

class _PickTreesMapState extends State<PickTreesMap> {
  bool? pickingTrees = false;
  Timer? _locationTimer;
  final RxString selectedTreeType = ''.obs;
  bool _isDisposed = false;
  var pnValue = ''.obs;
  var treeSpeciesValue = ''.obs;
  List<String> pnValues = ['Planted', 'Natural'];

  // lod from local db later
  List<String> treeSpeciesValues = ['specie 1', 'specie 2'];

  void _onPNChanged(String? value) {
    if (value != null) {
      pnValue.value = value;

      if (mounted) setState(() {});
      debugPrint("P/N changed: $value");
    }
  }

  void _onTreeSpeciesChanged(String? value) {
    if (value != null) {
      treeSpeciesValue.value = value;

      if (mounted) setState(() {});
      debugPrint("Tree species changed: $value");
    }
  }

  final RxString _yoEstablishment = ''.obs;
  final treeNameController = TextEditingController();
  final treeSpecieController = TextEditingController();
  final treeSizeController = TextEditingController();
  final establishmentDateController = TextEditingController();

  CameraPosition initialCameraPosition = const CameraPosition(
    target: LatLng(7.9527706, -1.0307118),
    zoom: 8.0,
  );

  final GlobalKey _keySelectBasemapButton = const GlobalObjectKey(
    "_keySelectBasemapButton",
  );

  final GlobalKey _keyZoomToUserButton = const GlobalObjectKey(
    "_keyZoomToUserButton",
  );

  final GlobalKey _keyIsDone = const GlobalObjectKey("_keyIsDone");

  MapType mapType = MapType.normal;

  BitmapDescriptor customIcon = BitmapDescriptor.defaultMarker;

  Future<Uint8List?> _getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
    );
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(
      format: ui.ImageByteFormat.png,
    ))?.buffer.asUint8List();
  }

  PickTreeMapController pickTreeMapController = Get.put(
    PickTreeMapController(),
  );

  SeedlingMonitoringController seedlingMonitoringController = Get.put(
    SeedlingMonitoringController(),
  );

  TreeRegistrationController treeRegistrationController = Get.put(
    TreeRegistrationController(),
  );
  GoogleMapController? mapController;
  LocationData? _locationData;
  String? _mapStyle;
  late Location location;
  bool? pickingPoints = false;
  LocationData? locationData;
  List<Marker> markersList = [];
  Map<MarkerId, int> markerIdToIndex = {};
  UserCurrentLocation? userCurrentLocation;

  // Location tracking variables
  String _locationMessage = "Getting your location...";
  double accuracy = 1000.0;
  double userLat = 0.0;
  double altitude = 0.0;
  double userLong = 0.0;
  bool locationIsEnabled = false;
  bool _isGettingLocation = false;
  StreamSubscription<gl.Position>? _positionStreamSubscription;

  // Track editing state
  int? _editingTreeIndex;

  @override
  void initState() {
    super.initState();
    location = Location();

    rootBundle.loadString('assets/map_style/silver.txt').then((string) {
      _mapStyle = string;
    });
    pickingTrees = true;

    _getBytesFromAsset('assets/images/tt.png', 64).then((onValue) {
      customIcon = BitmapDescriptor.fromBytes(onValue!);
    });

    // Load existing tree data if available
    _loadExistingTreeData();

    // Start automatic location tracking immediately
    _startFastLocationTracking();
  }

  void _loadExistingTreeData() {
    _getBytesFromAsset('assets/images/tt.png', 64).then((onValue) {
      customIcon = BitmapDescriptor.fromBytes(onValue!);
    });
    if (widget.existingTreeData != null && widget.existingTreeData!.isNotEmpty) {
      for (int i = 0; i < widget.existingTreeData!.length; i++) {
        var tree = widget.existingTreeData![i];
        double lat = tree['latitude'];
        double lng = tree['longitude'];

        MarkerId markerId = MarkerId('existing_tree_$i');
        debugPrint("Existing tree marker ID: $markerId");
        debugPrint("MARKERS::::: ${markersList.length}");

        setState(() {
          markersList.add(
            Marker(
              markerId: markerId,
              position: LatLng(lat, lng),
              icon: customIcon,
              consumeTapEvents: true,
              onTap: () {
                _onExistingTreeMarkerTapped(i);
              },
            ),
          );
          markerIdToIndex[markerId] = markersList.length - 1;
        });

        debugPrint("MARKERS::::: ${markersList.length}");
      }
    }
  }

  void _onExistingTreeMarkerTapped(int index) {
    if (widget.existingTreeData != null && index < widget.existingTreeData!.length) {
      var tree = widget.existingTreeData![index];
      _editingTreeIndex = index;

      showLocationPopup(
        context,
        lat: tree['latitude'],
        long: tree['longitude'],
        altitude: tree['altitude'],
        accuracy: tree['accuracy'],
        isOpenAgain: true,
        index: index,
        existingTreeData: tree,
      );
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _locationTimer?.cancel();
    _positionStreamSubscription?.cancel();
    super.dispose();
  }

  // Fast location tracking using stream
  Future<void> _startFastLocationTracking() async {
    if (_isGettingLocation) return;

    _isGettingLocation = true;

    try {
      // Check permissions first
      gl.LocationPermission permission = await gl.Geolocator.checkPermission();
      if (permission == gl.LocationPermission.denied) {
        permission = await gl.Geolocator.requestPermission();
        if (permission == gl.LocationPermission.denied) {
          _updateLocationStatus("Location permission denied", 1000.0);
          _isGettingLocation = false;
          return;
        }
      }

      if (permission == gl.LocationPermission.deniedForever) {
        _updateLocationStatus("Location permission permanently denied", 1000.0);
        _isGettingLocation = false;
        return;
      }

      // Check if location services are enabled
      bool serviceEnabled = await gl.Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _updateLocationStatus("Location services disabled", 1000.0);
        _isGettingLocation = false;
        return;
      }

      // Get initial position quickly
      gl.Position initialPosition =
      await gl.Geolocator.getCurrentPosition(
        desiredAccuracy: gl.LocationAccuracy.best,
        timeLimit: Duration(seconds: 5), // Timeout after 5 seconds
      )
          .catchError((error) {
        // If current position fails, try with lower accuracy
        return gl.Geolocator.getCurrentPosition(
          desiredAccuracy: gl.LocationAccuracy.medium,
          timeLimit: Duration(seconds: 3),
        );
      })
          .catchError((error) {
        // If that also fails, use any available location
        return gl.Geolocator.getCurrentPosition(
          desiredAccuracy: gl.LocationAccuracy.low,
        );
      });

      _updateLocationData(initialPosition);

      // Start listening to position stream for continuous updates
      _positionStreamSubscription =
          gl.Geolocator.getPositionStream(
            locationSettings: gl.LocationSettings(
              accuracy: gl.LocationAccuracy.best,
              distanceFilter: 1, // Update every 1 meter
              timeLimit: Duration(seconds: 10), // Timeout for each update
            ),
          ).listen(
                (gl.Position position) {
              _updateLocationData(position);
            },
            onError: (error) {
              debugPrint("Location stream error: $error");
              // Try to restart if there's an error
              if (!_isDisposed) {
                _restartLocationTracking();
              }
            },
            cancelOnError: true,
          );
    } catch (e) {
      debugPrint("Error starting location tracking: $e");
      _updateLocationStatus("Error getting location: $e", 1000.0);
      _isGettingLocation = false;

      // Retry after delay
      if (!_isDisposed) {
        Timer(Duration(seconds: 3), _restartLocationTracking);
      }
    }
  }

  void _updateLocationData(gl.Position position) {
    if (_isDisposed) return;

    if (mounted) {
      setState(() {
        accuracy = position.accuracy;
        userLat = position.latitude;
        altitude = position.altitude;
        userLong = position.longitude;
        locationIsEnabled = true;
        _locationMessage =
        "Location accuracy: ${accuracy.truncateToDecimalPlaces(2)}m";

        // Auto-zoom to location when we first get good accuracy
        if (accuracy < 50 && (mapController != null)) {
          zoomToCurrentLocation(userLat, userLong);
        }
      });
    }
  }

  void _updateLocationStatus(String message, double acc) {
    if (_isDisposed) return;

    if (mounted) {
      setState(() {
        _locationMessage = message;
        accuracy = acc;
        locationIsEnabled = false;
      });
    }
  }

  void _restartLocationTracking() {
    if (_isDisposed) return;

    _positionStreamSubscription?.cancel();
    _isGettingLocation = false;
    _startFastLocationTracking();
  }

  @override
  Widget build(BuildContext context) {
    _getBytesFromAsset('assets/images/tt.png', 64).then((onValue) {
      customIcon = BitmapDescriptor.fromBytes(onValue!);
    });
    debugPrint("EXISTING TREE DATA ::::::::::::::: ${widget.existingTreeData}");
    pickTreeMapController.pickTreesMapScreenContext = context;
    var safePadding = MediaQuery.of(context).padding.top;

    final GlobalKey _keyGPSStatusPanel = GlobalKey();

    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) => Future.value(false),
      child: Scaffold(
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                top: safePadding + 12,
                bottom: 12,
                left: 12,
                right: 15,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Icon(Icons.arrow_back, color: AppColor.primary),
                    ),
                  ),
                  SizedBox(width: 12),
                  AppText(
                    text: widget.isViewMode ? 'View Trees' : 'Capture trees',
                    color: AppColor.primary,
                    fontSize: 20,
                  ),
                  Spacer(),
                  // if (_isGettingLocation)
                  //   SizedBox(
                  //     width: 20,
                  //     height: 20,
                  //     child: CircularProgressIndicator(
                  //       strokeWidth: 2,
                  //       valueColor: AlwaysStoppedAnimation<Color>(AppColor.primary),
                  //     ),
                  //   ),
                ],
              ),
            ),
            widget.isViewModePolygon
                ? Container()
                : Container(
              key: _keyGPSStatusPanel,
              width: double.infinity,
              color: locationAccuracyColor(accuracy),
              alignment: Alignment.center,
              padding: const EdgeInsets.all(6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (accuracy <= 10)
                    Icon(Icons.gps_fixed, color: Colors.white, size: 14),
                  if (accuracy > 10 && accuracy <= 50)
                    Icon(
                      Icons.gps_not_fixed,
                      color: Colors.white,
                      size: 14,
                    ),
                  if (accuracy > 50)
                    Icon(Icons.gps_off, color: Colors.white, size: 14),
                  SizedBox(width: 6),
                  AppText(
                    text: _locationMessage,
                    fontSize: 11,
                    color: Colors.white,
                  ),
                  // if (_isGettingLocation)
                  //   Padding(
                  //     padding: const EdgeInsets.only(left: 8.0),
                  //     child: SizedBox(
                  //       width: 12,
                  //       height: 12,
                  //       child: CircularProgressIndicator(
                  //         strokeWidth: 1,
                  //         valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  //       ),
                  //     ),
                  //   ),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition:
                    pickTreeMapController.initialCameraPosition,
                    mapType: mapType,
                    compassEnabled: false,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                    mapToolbarEnabled: false,
                    markers: Set<Marker>.of(markersList),
                    polygons: pickTreeMapController.polygons,
                    onMapCreated: (GoogleMapController controller) async {
                      mapController = controller;
                      mapController?.setMapStyle(_mapStyle);
                      await pickTreeMapController.loadFarms(widget.farm);

                      setState(() {
                        if (pickTreeMapController.polygons.isNotEmpty) {
                          zoomToPolygonCenter(
                            pickTreeMapController.polygons.first.points,
                          );
                        }
                      });
                    },
                  ),
                  Positioned(
                    bottom: 220,
                    right: 10,
                    child: Container(
                      child: controlButton(
                        key: _keyIsDone,
                        backgroundColor:
                        (mapType == MapType.hybrid ||
                            mapType == MapType.satellite)
                            ? Colors.white
                            : AppColor.primary,
                        child: Text(
                          'Finish',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          //build confirm dialog
                          _showConfirmDialog();
                        },
                      ),
                    ),
                  ),
                  widget.isViewModePolygon
                      ? Container()
                      : Positioned(
                    bottom: 80,
                    right: 10,
                    child: controlButton(
                      key: _keyZoomToUserButton,
                      backgroundColor:
                      (mapType == MapType.hybrid ||
                          mapType == MapType.satellite)
                          ? Colors.white
                          : AppColor.primary,
                      child: Icon(
                        PhosphorIcons.crosshair,
                        color:
                        (mapType == MapType.hybrid ||
                            mapType == MapType.satellite)
                            ? AppColor.primary
                            : Colors.white,
                        size: 25,
                      ),
                      onTap: () =>
                          zoomToCurrentLocation(userLat, userLong),
                    ),
                  ),
                  widget.isViewModePolygon
                      ? Container()
                      : Positioned(
                    right: 12,
                    bottom: 140,
                    child: Column(
                      children: [
                        controlButton(
                          key: _keySelectBasemapButton,
                          backgroundColor:
                          (mapType == MapType.hybrid ||
                              mapType == MapType.satellite)
                              ? Colors.white
                              : AppColor.primary,
                          child: Icon(
                            Icons.map_rounded,
                            color:
                            (mapType == MapType.hybrid ||
                                mapType == MapType.satellite)
                                ? AppColor.primary
                                : Colors.white,
                            size: 25,
                          ),
                          onTap: () => selectBasemapStyle(),
                        ),
                        SizedBox(height: 12),
                        // controlButton(
                        //   backgroundColor:
                        //   (mapType == MapType.hybrid ||
                        //       mapType == MapType.satellite)
                        //       ? Colors.white
                        //       : AppColor.primary,
                        //   child: Icon(
                        //     Icons.save,
                        //     color:
                        //     (mapType == MapType.hybrid ||
                        //         mapType == MapType.satellite)
                        //         ? AppColor.primary
                        //         : Colors.white,
                        //   ),
                        //   onTap: () {
                        //     // pickTreeMapController.saveTreeOffline();
                        //   },
                        // ),
                      ],
                    ),
                  ),
                  widget.isViewModePolygon || widget.isViewMode
                      ? Container()
                      : Positioned(
                    bottom: 10,
                    left: 10,
                    right: 10,
                    child: CustomButton(
                      horizontalPadding: 10,
                      isFullWidth: true,
                      backgroundColor:
                      (mapType == MapType.hybrid ||
                          mapType == MapType.satellite)
                          ? Colors.white
                          : AppColor.primary,
                      onTap: () async {
                        if (accuracy <= 1000) {
                          LatLng latLng = LatLng(userLat, userLong);

                          bool treeLocationWithinFarm =
                          isLocationInsidePolygon(
                            latLng,
                            pickTreeMapController.polygons,
                          );

                          Get.closeAllSnackbars();

                          showLocationPopup(
                            context,
                            lat: userLat,
                            altitude: altitude,
                            accuracy: accuracy,
                            long: userLong,
                            // farmRef: widget.farm["farm_reference"],
                          );
                        } else {
                          Get.closeAllSnackbars();
                          Get.snackbar(
                            "Cannot capture tree",
                            "Location accuracy too low: ${accuracy.truncateToDecimalPlaces(2)}m",
                            messageText: AppText(
                              text:
                              "Location accuracy too low: ${accuracy.truncateToDecimalPlaces(2)}m",
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColor.white,
                            ),
                            colorText: AppColor.white,
                            snackPosition: SnackPosition.BOTTOM,
                            margin: const EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 10,
                            ),
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.error,
                            duration: const Duration(seconds: 3),
                          );
                        }
                      },
                      child: AppText(
                        text: 'Capture tree',
                        color:
                        (mapType == MapType.hybrid ||
                            mapType == MapType.satellite)
                            ? AppColor.primary
                            : Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget controlButton({
    Key? key,
    Color? backgroundColor,
    Widget? child,
    Function? onTap,
    bool disabled = false,
  }) {
    return AbsorbPointer(
      key: key,
      absorbing: disabled,
      child: Container(
        decoration: BoxDecoration(
          color: disabled ? Colors.grey : backgroundColor,
          shape: BoxShape.circle,
          boxShadow: const [
            BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.15), blurRadius: 8.0),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: Ink(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: disabled ? Colors.grey : backgroundColor,
              shape: BoxShape.circle,
            ),
            child: InkWell(
              onTap: () => disabled ? null : onTap!(),
              customBorder: const CircleBorder(),
              child: Center(child: child),
            ),
          ),
        ),
      ),
    );
  }

  Color locationAccuracyColor(double? accuracy) {
    if (accuracy == null) {
      return Colors.red;
    } else if (accuracy <= 10) {
      return Colors.green;
    } else if (accuracy <= 50) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  void zoomToCurrentLocation(double lat, double long) {
    if (lat == 0.0 && long == 0.0) return;

    pickTreeMapController.initialCameraPosition = CameraPosition(
      target: LatLng(lat, long),
      zoom: 20.0,
      tilt: 18.0,
    );
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        pickTreeMapController.initialCameraPosition,
      ),
    );
  }

  selectBasemapStyle() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        MapType selected = mapType;
        return AlertDialog(
          scrollable: true,
          insetPadding: const EdgeInsets.all(10),
          contentPadding: EdgeInsets.zero,
          clipBehavior: Clip.none,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 20,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppText(
                      text: 'Select basemap style',
                      fontWeight: FontWeight.w500,
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selected = MapType.normal;
                        });
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Radio<MapType>(
                            value: MapType.normal,
                            groupValue: selected,
                            onChanged: (value) {
                              setState(() {
                                selected = MapType.normal;
                              });
                            },
                            activeColor: AppColor.primary,
                          ),
                          const AppText(text: 'Normal', fontSize: 13),
                        ],
                      ),
                    ),
                    const Divider(height: 0),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selected = MapType.hybrid;
                        });
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Radio<MapType>(
                            value: MapType.hybrid,
                            groupValue: selected,
                            onChanged: (value) {
                              setState(() {
                                selected = MapType.hybrid;
                              });
                            },
                            activeColor: AppColor.primary,
                          ),
                          const AppText(text: 'Hybrid', fontSize: 13),
                        ],
                      ),
                    ),
                    const Divider(height: 0),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selected = MapType.satellite;
                        });
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Radio<MapType>(
                            value: MapType.satellite,
                            groupValue: selected,
                            onChanged: (value) {
                              setState(() {
                                selected = MapType.satellite;
                              });
                            },
                            activeColor: AppColor.primary,
                          ),
                          const AppText(text: 'Satellite', fontSize: 13),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CustomButton(
                          isFullWidth: false,
                          backgroundColor: Colors.transparent,
                          verticalPadding: 0.0,
                          horizontalPadding: 8.0,
                          onTap: () => Navigator.of(context).pop(),
                          child: const AppText(
                            text: 'Cancel',
                            color: Colors.black,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(width: 15),
                        CustomButton(
                          isFullWidth: false,
                          backgroundColor: const Color(0XFF002424),
                          verticalPadding: 0.0,
                          horizontalPadding: 8.0,
                          onTap: () {
                            setState(() {
                              mapType = selected;
                            });
                            Navigator.of(context).pop();
                          },
                          child: const AppText(
                            text: 'Okay',
                            color: Colors.white,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    ).then((val) {
      setState(() {});
    });
  }

  void zoomToPolygonCenter(List<LatLng> polygon) {
    var totalX = 0.0;
    var totalY = 0.0;
    for (var i = 0; i < polygon.length; i++) {
      totalX += polygon[i].latitude;
      totalY += polygon[i].longitude;
    }
    var center = LatLng(totalX / polygon.length, totalY / polygon.length);
    pickTreeMapController.initialCameraPosition = CameraPosition(
      target: center,
      zoom: 16.0,
      tilt: 18.0,
    );
  }

  void showLocationPopup(
      BuildContext context, {
        double? lat,
        double? long,
        double? altitude,
        double? accuracy,
        // String? farmRef,
        bool isOpenAgain = false,
        int? index,
        Map<String, dynamic>? existingTreeData,
      }) {
    showDialog(
      context: pickTreeMapController.pickTreesMapScreenContext!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // If editing existing tree, pre-populate the fields
        if (existingTreeData != null) {
          selectedTreeType.value = existingTreeData['treeType'] ?? '';
          if (widget.isTreeRegisterMode) {
            // Pre-populate tree registration fields if needed
            treeNameController.text = existingTreeData['tree_name'] ?? '';
            pnValue.value = existingTreeData['pn'] ?? '';
            treeSpeciesValue.value = existingTreeData['species'] ?? '';
            _yoEstablishment.value = existingTreeData['yo_establishment'] ?? '';
            treeSizeController.text = existingTreeData['size']?.toString() ?? '';
          }
        }

        Map<String, dynamic> tree = {};
        tree["latitude"] = lat;
        tree["longitude"] = long;

        return AlertDialog(
          elevation: 0,
          backgroundColor: Colors.white,
          scrollable: false,
          insetPadding: const EdgeInsets.all(20.0),
          contentPadding: EdgeInsets.zero,
          clipBehavior: Clip.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(AppBorderRadius.sm)),
          ),
          title: AppText(
            text: isOpenAgain ? 'Edit Tree Information' : 'Tree information',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          content: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: SingleChildScrollView(
              child: widget.isTreeRegisterMode
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppText(text: "Tree Coordinate"),
                  AppText(
                    text: "$lat, $long",
                    color: AppColor.primary,
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(height: 5),
                  Text("Enter tree name"),
                  TextFieldWidget(
                    controller: treeNameController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter tree name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 5),
                  Obx(
                        () => _buildDropdown(
                      title: "P/N",
                      value: pnValue.value,
                      items: pnValues,
                      onChanged: _onPNChanged,
                    ),
                  ),
                  Obx(
                        () => pnValue.value.isEmpty
                        ? const Padding(
                      padding: EdgeInsets.only(left: 20, top: 4),
                      child: Text(
                        'This field is required',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    )
                        : const SizedBox(),
                  ),
                  const SizedBox(height: 5),
                  Obx(
                        () => _buildDropdown(
                      title: "Tree Species",
                      value: treeSpeciesValue.value,
                      items: treeSpeciesValues,
                      onChanged: _onTreeSpeciesChanged,
                    ),
                  ),
                  Obx(
                        () => treeSpeciesValue.value.isEmpty
                        ? const Padding(
                      padding: EdgeInsets.only(left: 20, top: 4),
                      child: Text(
                        'This field is required',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    )
                        : const SizedBox(),
                  ),

                  SizedBox(height: 5),
                  Text("Tree Size (dbh)"),
                  TextFieldWidget(
                    keyboardType: TextInputType.number,
                    controller: treeSizeController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please tree size';
                      }
                      return null;
                    },
                  ),

                  _buildYearOfEstablishment(),
                ],
              )
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const AppText(text: "Tree Coordinate"),
                  AppText(
                    text: "$lat, $long",
                    color: AppColor.primary,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 5),
                  const AppText(text: "Tree type"),
                  const SizedBox(height: 8),

                  // Enhanced Chip Selection Section
                  Obx(() {
                    final aliveSpecies = widget.survivedSeedlings;

                    if (aliveSpecies.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'No tree types available',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      );
                    }

                    return SizedBox(
                      width: double.infinity,
                      child: Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        alignment: WrapAlignment.start,
                        children: aliveSpecies.asMap().entries.map((
                            entry,
                            ) {
                          // final index = entry.key;
                          final species = entry.value;

                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeInOut,
                            child: FilterChip(
                              label: Text(
                                species,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: selectedTreeType.value == species
                                      ? Colors.white
                                      : AppColor.primary,
                                ),
                              ),
                              selected: selectedTreeType.value == species,
                              onSelected: (bool selected) {
                                if (selected) {
                                  selectedTreeType.value = species;
                                  HapticFeedback.lightImpact();
                                }
                              },
                              backgroundColor: Colors.grey[100],
                              selectedColor: AppColor.primary,
                              checkmarkColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                side: BorderSide(
                                  color: selectedTreeType.value == species
                                      ? AppColor.primary
                                      : Colors.grey[300]!,
                                  width: selectedTreeType.value == species
                                      ? 1.5
                                      : 1.0,
                                ),
                              ),
                              elevation: selectedTreeType.value == species
                                  ? 2.0
                                  : 0.0,
                              shadowColor: AppColor.primary.withOpacity(
                                0.3,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                                vertical: 8.0,
                              ),
                              materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  }),

                  // Enhanced Error Message
                  Obx(
                        () => selectedTreeType.value.isEmpty
                        ? AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 16,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Please select a tree type',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                        : SizedBox.shrink(),
                  ),

                  // Clear Selection Option
                  Obx(
                        () => selectedTreeType.value.isNotEmpty
                        ? Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          selectedTreeType.value = '';
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.clear,
                              color: Colors.grey,
                              size: 14,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Clear selection',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                decoration:
                                TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                        : SizedBox.shrink(),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            if (isOpenAgain && index != null)
              TextButton(
                child: AppText(text: 'Delete', color: Colors.red),
                onPressed: () {
                  if (index < markersList.length) {
                    setState(() {
                      markersList.removeAt(index);
                    });
                  }
                  // Also remove from existing tree data if applicable
                  if (widget.existingTreeData != null && index < widget.existingTreeData!.length) {
                    widget.existingTreeData!.removeAt(index);
                  }
                  Navigator.of(context).pop();
                },
              ),
            TextButton(
              child: AppText(text: 'Cancel', color: AppColor.black),
              onPressed: () {
                // Clear form when canceling
                _clearForm();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: AppText(text: isOpenAgain ? 'Update' : 'Done'),
              onPressed: () async {
                // Call the _isTreeRegisterModeDone function if the isTreeRegisterMode is true
                if (widget.isTreeRegisterMode) {
                  _isTreeRegisterModeDone(lat!, long!, isOpenAgain: isOpenAgain, index: index);
                  return;
                }

                if (selectedTreeType.value.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please select a tree type'),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  return;
                }

                if (isOpenAgain && index != null) {
                  // Update existing tree
                  if (widget.existingTreeData != null && index < widget.existingTreeData!.length) {
                    widget.existingTreeData![index] = {
                      "latitude": lat,
                      "longitude": long,
                      "altitude": altitude,
                      "accuracy": accuracy,
                      "treeType": selectedTreeType.value,
                    };
                  }
                  _clearForm();
                  Navigator.of(context).pop();
                } else {
                  // Add new tree
                  LatLng currentLatLng = LatLng(lat!, long!);

                  MarkerId markerId = MarkerId(
                    currentLatLng.toString() + DateTime.now().toIso8601String(),
                  );

                  setState(() {
                    markersList.add(
                      Marker(
                        markerId: markerId,
                        position: currentLatLng,
                        icon: customIcon,
                        consumeTapEvents: true,
                        onTap: () {
                          // Handle marker tap if needed
                        },
                      ),
                    );
                    markerIdToIndex[markerId] = markersList.length - 1;
                  });

                  tree["altitude"] = altitude;
                  tree["accuracy"] = accuracy;
                  tree["treeType"] = selectedTreeType.value;

                  seedlingMonitoringController.treeData.add(tree);
                  _clearForm();

                  debugPrint("Tree added: $tree");
                  debugPrint(
                    "Tree added FROM CONTROLLER: ${seedlingMonitoringController.treeData}",
                  );
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _clearForm() {
    selectedTreeType.value = '';
    treeNameController.clear();
    pnValue.value = '';
    treeSpeciesValue.value = '';
    _yoEstablishment.value = '';
    treeSizeController.clear();
    _editingTreeIndex = null;
  }

  void _showConfirmDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm'),
          content: const Text('Are you sure you want to finish?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Finish'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _isTreeRegisterModeDone(double lat, double long, {bool isOpenAgain = false, int? index}) {
    Map<String, dynamic> tree = {};
    tree["latitude"] = lat;
    tree["longitude"] = long;

    if (!isOpenAgain) {
      // Add new marker for new tree
      LatLng currentLatLng = LatLng(lat, long);
      MarkerId markerId = MarkerId(
        currentLatLng.toString() + DateTime.now().toIso8601String(),
      );

      setState(() {
        markersList.add(
          Marker(
            markerId: markerId,
            position: currentLatLng,
            icon: customIcon,
            consumeTapEvents: true,
            onTap: () {
              // Find the index of this marker and open edit dialog
              int markerIndex = markersList.indexWhere((marker) => marker.markerId == markerId);
              if (markerIndex != -1) {
                _onExistingTreeMarkerTapped(markerIndex);
              }
            },
          ),
        );
        markerIdToIndex[markerId] = markersList.length - 1;
      });
    }

    tree["tree_name"] = treeNameController.text;
    tree["pn"] = pnValue.value;
    tree["species"] = treeSpeciesValue.value;
    tree["yo_establishment"] = _yoEstablishment.value;
    tree["altitude"] = altitude;
    tree["size"] = treeSizeController.text;
    tree["accuracy"] = accuracy;

    if (isOpenAgain && index != null) {
      // Update existing tree
      if (treeRegistrationController.treeData.length > index) {
        treeRegistrationController.treeData[index] = tree;
      }
    } else {
      // Add new tree
      treeRegistrationController.treeData.add(tree);
    }

    debugPrint("Tree ${isOpenAgain ? 'updated' : 'added'}: $tree");
    debugPrint(
      "Tree data FROM CONTROLLER TREE REGISTRATION: ${treeRegistrationController.treeData}",
    );

    // clear the form
    _clearForm();

    Navigator.of(context).pop();
  }

  Widget _buildYearOfEstablishment() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text(
                "Year of Establishment",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Text(' *', style: TextStyle(color: Colors.red, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: _showYearPicker,
            child: Obx(() {
              final year = _yoEstablishment.value;
              final hasError = year.isEmpty;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: hasError ? Colors.red : Colors.grey[300]!,
                        width: hasError ? 1.5 : 1.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          year.isNotEmpty ? year : 'Select Year',
                          style: TextStyle(
                            color: year.isNotEmpty
                                ? Colors.black87
                                : Colors.grey[500],
                            fontSize: 16,
                          ),
                        ),
                        Icon(Icons.calendar_today, color: fPrimaryColour),
                      ],
                    ),
                  ),
                  if (hasError)
                    const Padding(
                      padding: EdgeInsets.only(left: 4, top: 4),
                      child: Text(
                        'This field is required',
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String title,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    bool isRequired = true,
  }) {
    // Ensure the current value is valid
    final String? validValue =
    (value != null && value.isNotEmpty && items.contains(value))
        ? value
        : null;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              if (isRequired)
                const Text(
                  ' *',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: validValue,
                isExpanded: true,
                icon: Icon(Icons.arrow_drop_down, color: fPrimaryColour),
                elevation: 2,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
                hint: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Select $title',
                    style: TextStyle(color: Colors.grey[500], fontSize: 16),
                  ),
                ),
                items: items.map<DropdownMenuItem<String>>((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(item, style: const TextStyle(fontSize: 16)),
                    ),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }

  File? _pickedImage;
  void _selectedImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  Widget _buildSpeciesImageSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text(
                "Species Image",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Text(' *', style: TextStyle(color: Colors.red, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Take picture of species",
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                SpeciesImage(_selectedImage),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showYearPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select Year"),
          content: SizedBox(
            width: 300,
            height: 300,
            child: YearPicker(
              firstDate: DateTime(1800),
              lastDate: DateTime.now(),
              initialDate: DateTime.now(),
              selectedDate: DateTime.now(),
              onChanged: (DateTime date) {
                Navigator.pop(context);
                _yoEstablishment.value = '${date.year}';
                if (mounted) setState(() {});
              },
            ),
          ),
        );
      },
    );
  }
}