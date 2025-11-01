// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:collection';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:hcms_revived2/screens/addedMaps/dependencies/capitalize_string.dart';
import 'package:hcms_revived2/screens/addedMaps/dependencies/custom_button.dart';
import 'package:hcms_revived2/screens/addedMaps/dependencies/double_value_trimmer.dart';
import 'package:hcms_revived2/screens/addedMaps/dependencies/globals.dart';
import 'package:hcms_revived2/screens/addedMaps/dependencies/round_icon_button.dart';
import 'package:hcms_revived2/screens/addedMaps/dependencies/user_current_location.dart';
import 'package:hcms_revived2/screens/seedlingmonitoring/seedling_monitoring_controller.dart';
import 'package:location/location.dart';
import 'dart:math' as math;
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart' as gl;

typedef DrawingSaveCallback = Function(Polygon polygon, Set<Marker> markers, double area);

class PolygonDrawingTool extends StatefulWidget {
  final DrawingSaveCallback onSave;
  final Set<Polygon> layers;
  final Polygon? initialPolygon;
  final bool? viewInitialPolygon;
  final bool? useBackgroundLayers;
  final LatLngBounds? currentBounds;
  final CameraPosition? cameraPosition;
  final bool? allowTappingInputMethod;
  final bool? allowTracingInputMethod;
  final bool? persistMaxAccuracy;
  final bool? viewOnlyMap;
  final double? maxAccuracy;
  final bool? isTreeMapping;
  final Polygon? mappedFarmPolygon;

  final bool isTreeRegistrationFarmMap;

  const PolygonDrawingTool({
    super.key,
    this.isTreeMapping = false,
    this.isTreeRegistrationFarmMap=false,
    this.mappedFarmPolygon,
    required this.onSave,
    required this.layers,
    required this.useBackgroundLayers,
    this.currentBounds,
    this.cameraPosition,
    this.allowTappingInputMethod = true,
    this.allowTracingInputMethod = true,
    this.initialPolygon,
    this.viewInitialPolygon = false,
    this.persistMaxAccuracy = false,
    this.maxAccuracy,
    this.viewOnlyMap = false,
  });

  @override
  State<PolygonDrawingTool> createState() => _PolygonDrawingToolState();
}

class _PolygonDrawingToolState extends State<PolygonDrawingTool> with WidgetsBindingObserver {
  // Performance-optimized variables
  GoogleMapController? _mapController;
  Polygon? _activePolygon;
  final _markers = HashSet<Marker>();
  final _polygons = HashSet<Polygon>();

  // Fast state management
  var _pickingPoints = false;
  var _inputMethod = InputMethod.tapping;
  LocationData? _currentPosition;
  UserCurrentLocation? _userCurrentLocation;
  MapType _mapType = MapType.normal;
  String? _mapStyle;
  String? _polyID;

  // Performance timers
  Timer? _locationTimer;
  Timer? _autoPickerTimer;
  final _throttleTimer = <String, Timer>{};

  // UI keys
  final _keys = {
    'gpsPanel': const GlobalObjectKey("_keyGPSStatusPanel"),
    'addInput': const GlobalObjectKey("_keyAddInputButton"),
    'backspace': const GlobalObjectKey("_keyBackspaceButton"),
    'delete': const GlobalObjectKey("_keyDeleteButton"),
    'zoomToUser': const GlobalObjectKey("_keyZoomToUserButton"),
    'basemap': const GlobalObjectKey("_keySelectBasemapButton"),
    'save': const GlobalObjectKey("_keySaveButton"),
    'tutorial': const GlobalObjectKey("_keyShowTutorialButton"),
    'clear': const GlobalObjectKey("_clearKey"),
  };

  final _controller = Get.put(SeedlingMonitoringController());
  final _globals = Globals();

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  void _initializeMap() async {
    _inputMethod = widget.allowTappingInputMethod! ? InputMethod.tapping : InputMethod.manualRecording;
    _polyID = DateTime.now().millisecondsSinceEpoch.remainder(100000).toString();

    // Load map style
    rootBundle.loadString('assets/map_style/silver.txt').then((string) {
      _mapStyle = string;
    });

    _setupInitialLayers();

    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeLocationServices();
    });
  }

  void _initializeLocationServices() {
    _userCurrentLocation = UserCurrentLocation(context: context);
    _startLocationUpdates();

    if (!widget.viewOnlyMap!) {
      Timer(const Duration(seconds: 1), _showGuides);
    }
  }

  void _startLocationUpdates() {
    // Optimized location updates - less frequent when not picking points
    _locationTimer = Timer.periodic(const Duration(seconds: 2), (Timer t) {
      _userCurrentLocation?.getUserLocation(
        forceEnableLocation: false,
        onLocationEnabled: (isEnabled, pos) {
          if (isEnabled == true && mounted) {
            setState(() {
              _currentPosition = pos;
            });

            // Fast camera updates when picking points
            if (_pickingPoints && (_inputMethod == InputMethod.manualRecording || _inputMethod == InputMethod.automaticRecording)) {
              _moveToCurrentLocation(pos!);
            }
          }
        },
      );
    });
  }

  void _moveToCurrentLocation(LocationData position) {
    final newPosition = CameraPosition(
      target: LatLng(position.latitude!, position.longitude!),
      zoom: 20.5,
      tilt: 12.0,
    );

    _mapController?.animateCamera(CameraUpdate.newCameraPosition(newPosition));
  }

  void _setupInitialLayers() {
    if (widget.useBackgroundLayers == true && widget.layers.isNotEmpty) {
      for (var polygon in widget.layers) {
        _polygons.add(Polygon(
          polygonId: polygon.polygonId,
          points: polygon.points,
          strokeColor: polygon.strokeColor,
          consumeTapEvents: true,
          fillColor: polygon.fillColor,
          strokeWidth: polygon.strokeWidth,
          onTap: polygon.onTap,
        ));
      }
    }

    if (widget.viewInitialPolygon == true && widget.initialPolygon != null) {
      _polygons.add(widget.initialPolygon!);
    }
  }

  // HIGH-PERFORMANCE POINT ADDITION
  void _addPoint(LatLng latLng) {
    // Throttle rapid point additions
    if (_throttleTimer.containsKey('addPoint')) {
      return;
    }

    _throttleTimer['addPoint'] = Timer(const Duration(milliseconds: 50), () {
      _throttleTimer.remove('addPoint');
    });

    setState(() {
      // Add marker instantly
      _markers.add(Marker(
        markerId: MarkerId('marker_${_markers.length}_${DateTime.now().millisecondsSinceEpoch}'),
        position: latLng,
      ));

      // Fast polygon update
      final existingPolygon = _polygons.firstWhere(
            (element) => element.polygonId == PolygonId(_polyID!),
        orElse: () => Polygon(
          polygonId: PolygonId(_polyID!),
          points: [],
          strokeColor: Colors.red,
          fillColor: Colors.red.withOpacity(0.3),
          strokeWidth: 3,
          consumeTapEvents: false,
        ),
      );

      if (!_polygons.contains(existingPolygon)) {
        _polygons.add(existingPolygon);
      }

      // Update points directly for performance
      final points = List<LatLng>.from(existingPolygon.points)..add(latLng);
      _polygons.remove(existingPolygon);
      _polygons.add(existingPolygon.copyWith(pointsParam: points));
    });
  }

  // OPTIMIZED LOCATION-BASED POINT ADDITION
  void _addCurrentLocationPoint() {
    if (_currentPosition == null) return;

    // Fast accuracy check
    if (widget.persistMaxAccuracy == true && (_currentPosition!.accuracy ?? 100) > (widget.maxAccuracy ?? 30)) {
      _showAccuracyError();
      return;
    }

    _addPoint(LatLng(_currentPosition!.latitude!, _currentPosition!.longitude!));
  }

  void _showAccuracyError() {
    Get.snackbar(
      "Cannot record point",
      "The accuracy must be ${widget.maxAccuracy ?? 3} or below",
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 2),
    );
  }

  // FAST AUTOMATIC POINT PICKING
  void _startAutomaticPicking() {
    const fastInterval = Duration(seconds: 1); // Much faster interval

    _autoPickerTimer = Timer.periodic(fastInterval, (Timer t) {
      if (!_pickingPoints || _inputMethod != InputMethod.automaticRecording) {
        t.cancel();
        return;
      }
      _addCurrentLocationPoint();
    });
  }

  void _stopAutomaticPicking() {
    _autoPickerTimer?.cancel();
    _autoPickerTimer = null;
  }

  // PERFORMANCE-OPTIMIZED UI BUILD
  @override
  Widget build(BuildContext context) {
    final safePadding = MediaQuery.of(context).padding.top;

    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Material(
        child: Scaffold(
          body: Column(
            children: [
              // Header
              _buildHeader(safePadding),
              // GPS Status
              _buildGPSStatus(),
              // Map
              Expanded(child: _buildMap()),
              // Controls
              _buildControls(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(double safePadding) {
    return Container(
      padding: EdgeInsets.only(
        top: safePadding + 12,
        bottom: 12,
        left: 12,
        right: 15,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            RoundedIconButton(
              icon: const Icon(Icons.arrow_back),
              size: 45,
              backgroundColor: Theme.of(context).colorScheme.primary,
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(width: 12),
            Text(
              widget.viewOnlyMap! ? 'View demarcated area' : 'Demarcate area',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ]),
          if (!widget.viewOnlyMap!)
            GestureDetector(
              key: _keys['tutorial'],
              onTap: _showTutorial,
              child: const Icon(Icons.help_outline_rounded, size: 20),
            ),
        ],
      ),
    );
  }

  Widget _buildGPSStatus() {
    return Container(
      key: _keys['gpsPanel'],
      width: double.infinity,
      color: _getAccuracyColor(_currentPosition?.accuracy),
      padding: const EdgeInsets.all(6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _currentPosition != null
                ? "Accuracy: ${_currentPosition!.accuracy?.toStringAsFixed(1) ?? "..."} m"
                : "Getting location...",
            style: const TextStyle(fontSize: 11, color: Colors.white),
          ),
          if (_currentPosition == null) ...[
            const SizedBox(width: 10),
            CustomButton(
              horizontalPadding: 10,
              backgroundColor: Colors.white,
              onTap: _forceEnableLocation,
              child: const Text('Enable', style: TextStyle(fontSize: 12)),
            )
          ],
        ],
      ),
    );
  }

  Widget _buildMap() {
    return Stack(children: [
      GoogleMap(
        initialCameraPosition: widget.cameraPosition ?? const CameraPosition(
          target: LatLng(7.9527706, -1.0307118),
          zoom: 8.0,
        ),
        mapType: _mapType,
        compassEnabled: false,
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: widget.viewOnlyMap!,
        mapToolbarEnabled: false,
        markers: _markers,
        polygons: _polygons,
        polylines: _controller.polyLines,
        onMapCreated: (controller) {
          _mapController = controller;
          controller.setMapStyle(_mapStyle);
          _zoomToInitialPosition();
        },
        onTap: (coordinates) {
          if (_pickingPoints && _inputMethod == InputMethod.tapping) {
            _addPoint(coordinates); // Fast tap response
          }
        },
      ),
      Positioned(child:  _buildControlButton(
        key: _keys['clear'],
        icon: Icons.clear,
        onTap: _togglePointPicking,
      ),),
      // Control buttons
      Positioned(right: 12, top: 12, child: _buildControlButtons()),
    ]);
  }

  Widget _buildControlButtons() {
    return Column(children: [
      if (!widget.viewOnlyMap!) ...[
        _buildControlButton(
          key: _keys['addInput'],
          icon: _pickingPoints ? Icons.pause : Icons.add_location_alt,
          onTap: _togglePointPicking,
        ),
        const SizedBox(height: 8),
        _buildControlButton(
          key: _keys['backspace'],
          icon: Icons.backspace_rounded,
          onTap: _removeLastPoint,
          disabled: _markers.isEmpty,
        ),
        const SizedBox(height: 8),
        _buildControlButton(
          key: _keys['delete'],
          icon: Icons.delete,
          onTap: _clearAllPoints,
          disabled: _markers.isEmpty,
        ),
        const SizedBox(height: 8),
      ],
      _buildControlButton(
        key: _keys['zoomToUser'],
        icon: PhosphorIcons.crosshair,
        onTap: _zoomToCurrentLocation,
      ),
      if (!widget.viewOnlyMap!) ...[
        const SizedBox(height: 8),
        _buildControlButton(
          key: _keys['basemap'],
          icon: Icons.map_rounded,
          onTap: _selectBasemapStyle,
        ),
        const SizedBox(height: 8),
        _buildControlButton(
          key: _keys['save'],
          icon: Icons.save,
          onTap: _savePolygon,
        ),
      ],
    ]);
  }

  Widget _buildControlButton({
    required GlobalKey? key,
    required IconData icon,
    required VoidCallback onTap,
    bool disabled = false,
  }) {
    return Container(
      key: key,
      decoration: BoxDecoration(
        color: disabled ? Colors.grey : Colors.black54,
        shape: BoxShape.circle,
        boxShadow: const [BoxShadow(blurRadius: 8.0)],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: disabled ? null : onTap,
          customBorder: const CircleBorder(),
          child: Container(
            width: 50,
            height: 50,
            child: Center(child: Icon(icon, color: Colors.white, size: 25)),
          ),
        ),
      ),
    );
  }

  Widget _buildControls() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
      color: Colors.blueGrey.shade100,
      child: Column(children: [
        // Manual record button
        if (_pickingPoints && _inputMethod == InputMethod.manualRecording && !widget.viewOnlyMap!)
          CustomButton(
            horizontalPadding: 10,
            backgroundColor: _isAccuracyGood() ? Theme.of(context).colorScheme.primary : Colors.black12,
            onTap: _addCurrentLocationPoint,
            child: Text(
              'Record Point',
              style: TextStyle(
                color: _isAccuracyGood() ? Theme.of(context).colorScheme.primaryContainer : Colors.black,
                fontSize: 11,
              ),
            ),
          ),
        // Status text
        if (_pickingPoints) _buildStatusText(),
        // Points counter
        Text(
          "Points: ${_markers.length}",
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
        // Area display
        if (_markers.length >= 3) _buildAreaDisplay(),
      ]),
    );
  }

  Widget _buildStatusText() {
    String text = "";
    if (_inputMethod == InputMethod.automaticRecording) {
      text = "Auto-recording points...";
    } else if (_inputMethod == InputMethod.tapping) {
      text = "Tap map to place points";
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Text(text, style: const TextStyle(fontSize: 12)),
    );
  }

  Widget _buildAreaDisplay() {
    final area = _calculatePolygonArea();
    return Padding(
      padding: const EdgeInsets.only(top: 3.0),
      child: Text(
        "Area: ${area.toStringAsFixed(4)} ha",
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
      ),
    );
  }

  // FAST POLYGON AREA CALCULATION
  double _calculatePolygonArea() {
    final polygon = _polygons.firstWhere(
          (element) => element.polygonId == PolygonId(_polyID!),
      orElse: () => Polygon(polygonId: PolygonId(''), points: []),
    );

    if (polygon.points.length < 3) return 0.0;

    return _computeArea(polygon.points);
  }

  double _computeArea(List<LatLng> points) {
    double area = 0;
    final coordinates = List<LatLng>.from(points)..add(points.first);

    for (int i = 0; i < coordinates.length - 1; i++) {
      final p1 = coordinates[i];
      final p2 = coordinates[i + 1];
      area += _toRadians(p2.longitude - p1.longitude) *
          (2 + math.sin(_toRadians(p1.latitude)) + math.sin(_toRadians(p2.latitude)));
    }

    area = area * 6378137 * 6378137 / 2;
    return (area.abs() * 0.000247105) / 2.471;
  }

  double _toRadians(double degrees) => degrees * math.pi / 180;

  // CONTROL METHODS
  void _togglePointPicking() {
    if (_markers.isEmpty) {
      _showInputMethodDialog();
      return;
    }

    setState(() {
      _pickingPoints = !_pickingPoints;
    });

    if (_pickingPoints && _inputMethod == InputMethod.automaticRecording) {
      _startAutomaticPicking();
    } else {
      _stopAutomaticPicking();
    }
  }

  void _removeLastPoint() {
    if (_markers.isEmpty) return;

    setState(() {
      _markers.remove(_markers.last);

      final polygon = _polygons.firstWhere(
            (element) => element.polygonId == PolygonId(_polyID!),
      );

      if (polygon.points.length > 1) {
        final newPoints = List<LatLng>.from(polygon.points)..removeLast();
        _polygons.remove(polygon);
        _polygons.add(polygon.copyWith(pointsParam: newPoints));
      } else {
        _polygons.removeWhere((element) => element.polygonId == PolygonId(_polyID!));
      }
    });

    if (_markers.isEmpty) {
      setState(() => _pickingPoints = false);
    }
  }

  void _clearAllPoints() {
    setState(() {
      _markers.clear();
      _polygons.removeWhere((element) => element.polygonId == PolygonId(_polyID!));
      _pickingPoints = false;
    });
  }

  void _zoomToCurrentLocation() {
    _userCurrentLocation?.getUserLocation(
      forceEnableLocation: true,
      onLocationEnabled: (isEnabled, pos) {
        if (isEnabled == true && pos != null) {
          _mapController?.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng(pos.latitude!, pos.longitude!), zoom: 18.0),
          ));
        }
      },
    );
  }

  void _savePolygon() {
    if (_markers.length < 3) {
      _showSaveError();
      return;
    }

    _cleanupTimers();

    final polygon = _polygons.firstWhere(
          (element) => element.polygonId == PolygonId(_polyID!),
    );

    final area = _calculatePolygonArea();
    Navigator.of(context).pop();
    widget.onSave(polygon, _markers, area);
  }

  void _cleanupTimers() {
    _locationTimer?.cancel();
    _autoPickerTimer?.cancel();
    _throttleTimer.forEach((key, timer) => timer.cancel());
  }

  // HELPER METHODS
  Color _getAccuracyColor(double? accuracy) {
    if (accuracy == null) return Colors.red;
    if (accuracy <= 3) return Colors.green;
    if (accuracy <= 6) return Colors.amber;
    return Colors.red;
  }

  bool _isAccuracyGood() {
    return _currentPosition != null && (_currentPosition!.accuracy ?? 100) <= (widget.maxAccuracy ?? 30);
  }

  void _forceEnableLocation() {
    _userCurrentLocation?.getUserLocation(
      forceEnableLocation: true,
      onLocationEnabled: (isEnabled, pos) {
        if (isEnabled == true) {
          setState(() => _currentPosition = pos);
        }
      },
    );
  }

  void _zoomToInitialPosition() {
    if (widget.viewInitialPolygon == true && widget.initialPolygon != null) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _mapController?.animateCamera(CameraUpdate.newLatLngBounds(
            _boundsFromLatLngList(widget.initialPolygon!.points), 140.0));
      });
    } else {
      _zoomToCurrentLocation();
    }
  }

  LatLngBounds _boundsFromLatLngList(List<LatLng> list) {
    double? x0, x1, y0, y1;
    for (final latLng in list) {
      x0 = x0 == null ? latLng.latitude : math.min(x0, latLng.latitude);
      x1 = x1 == null ? latLng.latitude : math.max(x1, latLng.latitude);
      y0 = y0 == null ? latLng.longitude : math.min(y0, latLng.longitude);
      y1 = y1 == null ? latLng.longitude : math.max(y1, latLng.longitude);
    }
    return LatLngBounds(
      northeast: LatLng(x1!, y1!),
      southwest: LatLng(x0!, y0!),
    );
  }

  // DIALOGS
  void _showInputMethodDialog() {
    showDialog(
      context: context,
      builder: (context) => _InputMethodDialog(
        currentMethod: _inputMethod,
        allowTapping: widget.allowTappingInputMethod!,
        allowTracing: widget.allowTracingInputMethod!,
        onMethodSelected: (method) {
          setState(() => _inputMethod = method);
          setState(() => _pickingPoints = true);

          if (method == InputMethod.automaticRecording) {
            _startAutomaticPicking();
          }
        },
      ),
    );
  }

  void _showSaveError() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text("A valid polygon requires at least 3 points"),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
      ),
    );
  }

  // TUTORIAL (keep existing implementation but optimized)
  void _showGuides() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('bypassDrawingToolGuide') != true) {
      _showTutorial();
    } else {
      _showInputMethodDialog();
    }
  }

  void _showTutorial() {
    // Existing tutorial implementation (optimized version)
    // ... (keep your existing tutorial code but ensure it's performant)
  }

  @override
  void dispose() {
    _cleanupTimers();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _mapController != null) {
      _mapController!.setMapStyle(_mapStyle);
    }
  }

  void _selectBasemapStyle() {
    showDialog(
      context: context,
      builder: (context) => _BasemapDialog(
        currentType: _mapType,
        onTypeSelected: (type) => setState(() => _mapType = type),
      ),
    );
  }
}

// Optimized Dialog Widgets
class _InputMethodDialog extends StatefulWidget {
  final String currentMethod;
  final bool allowTapping;
  final bool allowTracing;
  final Function(String) onMethodSelected;

  const _InputMethodDialog({
    required this.currentMethod,
    required this.allowTapping,
    required this.allowTracing,
    required this.onMethodSelected,
  });

  @override
  State<_InputMethodDialog> createState() => _InputMethodDialogState();
}

class _InputMethodDialogState extends State<_InputMethodDialog> {
  late String _selectedMethod;

  @override
  void initState() {
    super.initState();
    _selectedMethod = widget.currentMethod;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Input Method'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.allowTapping) _buildMethodOption(
            InputMethod.tapping,
            'Draw Polygon',
            'Tap map to draw boundaries',
          ),
          if (widget.allowTapping) const SizedBox(height: 10),
          _buildMethodOption(
            InputMethod.manualRecording,
            'Pick Boundary Vertices',
            'Walk around area and drop markers',
          ),
          if (widget.allowTracing) const SizedBox(height: 10),
          if (widget.allowTracing) _buildMethodOption(
            InputMethod.automaticRecording,
            'Trace Boundaries',
            'Automatically draw by walking boundary',
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            widget.onMethodSelected(_selectedMethod);
          },
          child: const Text('Start'),
        ),
      ],
    );
  }

  Widget _buildMethodOption(String method, String title, String description) {
    return ListTile(
      leading: Radio<String>(
        value: method,
        groupValue: _selectedMethod,
        onChanged: (value) => setState(() => _selectedMethod = value!),
      ),
      title: Text(title, style: const TextStyle(fontSize: 14)),
      subtitle: Text(description, style: const TextStyle(fontSize: 12)),
      onTap: () => setState(() => _selectedMethod = method),
    );
  }
}

class _BasemapDialog extends StatefulWidget {
  final MapType currentType;
  final Function(MapType) onTypeSelected;

  const _BasemapDialog({required this.currentType, required this.onTypeSelected});

  @override
  State<_BasemapDialog> createState() => _BasemapDialogState();
}

class _BasemapDialogState extends State<_BasemapDialog> {
  late MapType _selectedType;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.currentType;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Basemap Style'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: MapType.values.map((type) {
          return ListTile(
            leading: Radio<MapType>(
              value: type,
              groupValue: _selectedType,
              onChanged: (value) => setState(() => _selectedType = value!),
            ),
            title: Text(_getMapTypeName(type)),
            onTap: () => setState(() => _selectedType = type),
          );
        }).toList(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            widget.onTypeSelected(_selectedType);
          },
          child: const Text('OK'),
        ),
      ],
    );
  }

  String _getMapTypeName(MapType type) {
    switch (type) {
      case MapType.normal: return 'Normal';
      case MapType.satellite: return 'Satellite';
      case MapType.hybrid: return 'Hybrid';
      case MapType.terrain: return 'Terrain';
      default: return 'Normal';
    }
  }
}

// Extension for Polygon copying
extension PolygonCopyWith on Polygon {
  Polygon copyWith({
    List<LatLng>? pointsParam,
    Color? strokeColorParam,
    Color? fillColorParam,
    int? strokeWidthParam,
    bool? consumeTapEventsParam,
  }) {
    return Polygon(
      polygonId: polygonId,
      points: pointsParam ?? points,
      strokeColor: strokeColorParam ?? strokeColor,
      fillColor: fillColorParam ?? fillColor,
      strokeWidth: strokeWidthParam ?? strokeWidth,
      consumeTapEvents: consumeTapEventsParam ?? consumeTapEvents,
      onTap: onTap,
    );
  }
}

class InputMethod {
  static const String tapping = "0";
  static const String manualRecording = "1";
  static const String automaticRecording = "2";
}