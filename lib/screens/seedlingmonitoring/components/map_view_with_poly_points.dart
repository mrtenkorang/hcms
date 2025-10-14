import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hcms_revived2/models/senddata/components/treefarminformationcomponents/farminformationarraydetails.dart';
import 'package:hcms_revived2/screens/seedlingmonitoring/components/treefarminformationcomponents/seedlingsmappingModel.dart';
import 'package:hcms_revived2/utils/constants/colours.dart';

class MarkerInfo {
  final String id;
  final LatLng position;
  final String title;
  final String snippet;
  final DateTime timeAdded;

  MarkerInfo({
    required this.id,
    required this.position,
    required this.title,
    required this.snippet,
    required this.timeAdded,
  });
}

class MapPage extends StatefulWidget {
  final List<SeedlingsMappingModel>? points;
  final List<FarmInformationArray>? decodedFarmData;

  const MapPage({Key? key, this.points, this.decodedFarmData})
      : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with SingleTickerProviderStateMixin {
  late GoogleMapController _mapController;
  final Completer<GoogleMapController> _controllerCompleter = Completer();

  static const CameraPosition _initialCamera = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14,
  );

  final List<MarkerInfo> _markerInfos = [];
  final Map<MarkerId, Marker> _markers = {};

  // Polygons
  List<LatLng> setFarmBoundary() {
    List<LatLng> boundaryMarks = [];

    for (var x in widget.decodedFarmData!) {
      boundaryMarks.add(LatLng(
          x.latitude ?? 37.42796133580664, x.longitude ?? -122.085749655962));
    }

    return boundaryMarks;
  }

  // Polygons
  final Set<Polygon> _farmBoundaryPolygons = {};

  setPolygons() {
    for (var x in widget.decodedFarmData!) {
      _farmBoundaryPolygons.add(
        Polygon(
          polygonId: PolygonId('${x.date}'),
          points: setFarmBoundary(),
          strokeColor: Colors.green,
          fillColor: Colors.greenAccent.withOpacity(0.15),
          strokeWidth: 2,
        ),
      );
    }
  }

  // final Set<Polygon> _polygons = {
  //   Polygon(
  //     polygonId: const PolygonId('poly_red'),
  //     points: const [
  //       LatLng(37.42796133580664, -122.085749655962),
  //       LatLng(37.4300, -122.085749655962),
  //       LatLng(37.4300, -122.0830),
  //       LatLng(37.42796133580664, -122.0830),
  //     ],
  //     strokeColor: Colors.red,
  //     fillColor: Colors.redAccent.withOpacity(0.15),
  //     strokeWidth: 2,
  //   ),
  //   Polygon(
  //     polygonId: const PolygonId('poly_blue'),
  //     points: const [
  //       LatLng(37.4310, -122.0920),
  //       LatLng(37.4330, -122.0920),
  //       LatLng(37.4330, -122.0890),
  //       LatLng(37.4310, -122.0890),
  //     ],
  //     strokeColor: Colors.blue,
  //     fillColor: Colors.blueAccent.withOpacity(0.15),
  //     strokeWidth: 2,
  //   ),
  //   Polygon(
  //     polygonId: const PolygonId('poly_green'),
  //     points: const [
  //       LatLng(37.4280, -122.0810),
  //       LatLng(37.4290, -122.0810),
  //       LatLng(37.4290, -122.0780),
  //       LatLng(37.4280, -122.0780),
  //     ],
  //     strokeColor: Colors.green,
  //     fillColor: Colors.greenAccent.withOpacity(0.15),
  //     strokeWidth: 2,
  //   ),
  // };

  // Draggable panel control
  late AnimationController _panelAnimController;
  double _panelMinHeight = 96.0; // collapsed height
  double _panelMaxHeight = 350.0; // expanded height
  late double _panelHeight; // current height (animated)

  // Drag internal state
  double _dragStartY = 0.0;
  double _startPanelHeight = 0.0;

  // Focused marker index
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _panelHeight = _panelMinHeight;
    _panelAnimController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 450));

    // Add some sample markers
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _addSeedlingMarkers();
      setPolygons();
    });
  }

  @override
  void dispose() {
    _panelAnimController.dispose();
    super.dispose();
  }

  void _addSeedlingMarkers() {
    List<MarkerInfo> samples = [];
    for (var x in widget.points!) {
      samples.add(MarkerInfo(
        id: '${x.date}',
        position: LatLng(
            x.latitude ?? 37.42796133580664, x.longitude ?? -122.085749655962),
        title: x.seedlingName.toString().toUpperCase(),
        snippet: x.altitude.toString(),
        timeAdded: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
      ));
    }

    for (var info in samples) {
      _addMarkerInfo(info);
    }
    setState(() {});
  }

  // void _addSampleMarkers() {
  //   final samples = [
  //     MarkerInfo(
  //       id: 'm1',
  //       position: const LatLng(37.42796133580664, -122.085749655962),
  //       title: 'Google HQ',
  //       snippet: '1600 Amphitheatre Pkwy',
  //       timeAdded: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
  //     ),
  //     MarkerInfo(
  //       id: 'm2',
  //       position: const LatLng(37.4300, -122.0900),
  //       title: 'Shoreline Park',
  //       snippet: 'Trails & lake nearby',
  //       timeAdded: DateTime.now().subtract(const Duration(hours: 12)),
  //     ),
  //     MarkerInfo(
  //       id: 'm3',
  //       position: const LatLng(37.4325, -122.0800),
  //       title: 'Computer History Museum',
  //       snippet: 'Computing artifacts',
  //       timeAdded: DateTime.now().subtract(const Duration(hours: 6)),
  //     ),
  //   ];

  //   for (var info in samples) {
  //     _addMarkerInfo(info);
  //   }
  //   setState(() {});
  // }

  void _addMarkerInfo(MarkerInfo info) {
    final markerId = MarkerId(info.id);
    final marker = Marker(
      markerId: markerId,
      position: info.position,
      infoWindow: InfoWindow(title: info.title, snippet: info.snippet),
      onTap: () => _onMarkerTappedById(info.id),
    );
    _markerInfos.add(info);
    _markers[markerId] = marker;
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    if (!_controllerCompleter.isCompleted) {
      _controllerCompleter.complete(controller);
    }
  }

  void _onMapTap(LatLng pos) {
    final id = 'm${_markerInfos.length + 1}';
    final info = MarkerInfo(
        id: id,
        position: pos,
        title: 'Marker ${_markerInfos.length + 1}',
        snippet: 'Custom marker',
        timeAdded: DateTime.now());
    setState(() {
      _addMarkerInfo(info);
      _currentIndex = _markerInfos.length - 1;
      _moveToIndex(_currentIndex);
      _snapPanel(expand: false); // keep collapsed when adding
    });
  }

  void _onMarkerTappedById(String id) {
    final idx = _markerInfos.indexWhere((m) => m.id == id);
    if (idx >= 0) {
      setState(() {
        _currentIndex = idx;
      });
      _moveToIndex(idx);
      _snapPanel(expand: false);
    }
  }

  void _moveToIndex(int idx) async {
    if (idx < 0 || idx >= _markerInfos.length) return;
    final info = _markerInfos[idx];
    await _mapController.animateCamera(CameraUpdate.newLatLng(info.position));
  }

  void _nextMarker() {
    if (_markerInfos.isEmpty) return;
    setState(() {
      _currentIndex = (_currentIndex + 1) % _markerInfos.length;
    });
    _moveToIndex(_currentIndex);
  }

  void _prevMarker() {
    if (_markerInfos.isEmpty) return;
    setState(() {
      _currentIndex =
          (_currentIndex - 1 + _markerInfos.length) % _markerInfos.length;
    });
    _moveToIndex(_currentIndex);
  }

  void _zoomToCurrent() async {
    if (_markerInfos.isEmpty) return;
    final info = _markerInfos[_currentIndex];
    await _mapController
        .animateCamera(CameraUpdate.newLatLngZoom(info.position, 16));
  }

  void _removeCurrentMarker() {
    if (_markerInfos.isEmpty) return;
    setState(() {
      final removed = _markerInfos.removeAt(_currentIndex);
      _markers.remove(MarkerId(removed.id));
      if (_markerInfos.isEmpty) {
        _currentIndex = 0;
      } else {
        _currentIndex = _currentIndex % _markerInfos.length;
      }
    });
    _snapPanel(expand: false);
  }

  // Panel controls: animate to expand or collapse with slight bounce
  void _snapPanel({required bool expand}) {
    final target = expand ? _panelMaxHeight : _panelMinHeight;
    const curve = Curves.easeOutBack; // gives a slight bounce
    final tween = Tween<double>(begin: _panelHeight, end: target);
    _panelAnimController.reset();
    final anim = tween
        .animate(CurvedAnimation(parent: _panelAnimController, curve: curve));
    anim.addListener(() {
      setState(() => _panelHeight = anim.value);
    });
    _panelAnimController.forward();
  }

  // Handle drag updates
  void _onVerticalDragStart(DragStartDetails details) {
    _dragStartY = details.globalPosition.dy;
    _startPanelHeight = _panelHeight;
    _panelAnimController.stop();
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    final dy = details.globalPosition.dy - _dragStartY;
    final newHeight =
        (_startPanelHeight - dy).clamp(_panelMinHeight, _panelMaxHeight);
    setState(() => _panelHeight = newHeight);
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    // Decide snap based on velocity or position
    const velocityThreshold = 700.0;
    if (details.primaryVelocity != null &&
        details.primaryVelocity!.abs() > velocityThreshold) {
      // swift swipe
      final expand = details.primaryVelocity! < 0; // negative = upward swipe
      _snapPanel(expand: expand);
    } else {
      // snap to nearest
      final mid = (_panelMinHeight + _panelMaxHeight) / 2;
      final expand = _panelHeight > mid;
      _snapPanel(expand: expand);
    }
  }

  String _formatDateTime(DateTime dt) {
    return '${dt.year.toString().padLeft(4, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final hasMarker = _markerInfos.isNotEmpty;
    final current = hasMarker ? _markerInfos[_currentIndex] : null;

    return Scaffold(
      // Edge-to-edge map (no appbar)
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _initialCamera,
            onMapCreated: _onMapCreated,
            myLocationEnabled: true,
            markers: Set<Marker>.from(_markers.values),
            polygons: _farmBoundaryPolygons,
            onTap: _onMapTap,
            zoomControlsEnabled: false,
          ),

          // Top-right floating controls (draw/finish not required here but kept minimal)
          Positioned(
            right: 12,
            top: 48,
            child: Column(
              children: [
                // FloatingActionButton.small(
                //   heroTag: 'clear',
                //   onPressed: () {
                //     setState(() {
                //       _markerInfos.clear();
                //       _markers.clear();
                //       _currentIndex = 0;
                //     });
                //   },
                //   child: const Icon(Icons.delete_outline),
                // ),
                FloatingActionButton.small(
                  heroTag: 'Go back',
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.arrow_back_ios_new_rounded),
                ),
              ],
            ),
          ),

          // Custom draggable frosted sheet
          Positioned(
            left: 12,
            right: 12,
            bottom: 12,
            height: _panelHeight,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onVerticalDragStart: _onVerticalDragStart,
              onVerticalDragUpdate: _onVerticalDragUpdate,
              onVerticalDragEnd: _onVerticalDragEnd,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: _panelHeight > _panelMinHeight
                          ? primaryColour.withOpacity(.80)
                          : primaryColour,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.white.withOpacity(0.12)),
                    ),
                    child: Column(
                      children: [
                        // Grab handle
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 10.0, bottom: 6.0),
                          child: Center(
                            child: Container(
                              width: 48,
                              height: 6,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                        ),

                        // Navigation bar (always visible)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.chevron_left),
                                color: Colors.white,
                                onPressed: hasMarker ? _prevMarker : null,
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    hasMarker
                                        ? '${_currentIndex + 1} of ${_markerInfos.length} — ${current!.title}'
                                        : 'No markers',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.chevron_right),
                                color: Colors.white,
                                onPressed: hasMarker ? _nextMarker : null,
                              ),
                            ],
                          ),
                        ),

                        // Divider
                        Divider(
                            color: Colors.white.withOpacity(0.12), height: 1),

                        // Expanded content area (shows more when panel is tall)
                        Expanded(
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child:
                              //  hasMarker
                              //     ? 
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          current?.title ?? "Heading",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          current?.snippet ?? "Info",
                                          style: const TextStyle(
                                              color: Colors.white70),
                                        ),
                                        const SizedBox(height: 12),
                                        Row(
                                          children: [
                                            const Icon(
                                                Icons.location_on_outlined,
                                                color: Colors.white70,
                                                size: 18),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                'Lat: ${current?.position.latitude.toStringAsFixed(6)}, Lng: ${current?.position.longitude.toStringAsFixed(6)}',
                                                style: const TextStyle(
                                                    color: Colors.white70),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            const Icon(Icons.access_time,
                                                color: Colors.white70,
                                                size: 16),
                                            const SizedBox(width: 8),
                                            Text(
                                              _formatDateTime(
                                                  current!.timeAdded),
                                              style: const TextStyle(
                                                  color: Colors.white70),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16),

                                        // Action buttons
                                        Row(
                                          children: [
                                            Expanded(
                                              child: ElevatedButton.icon(
                                                onPressed: _zoomToCurrent,
                                                icon: const Icon(Icons.zoom_in),
                                                label: const Text('Zoom here'),
                                                style: ElevatedButton.styleFrom(
                                                  elevation: 2,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8)),
                                                ),
                                              ),
                                            ),
                                            // const SizedBox(width: 12),
                                            // Expanded(
                                            //   child: ElevatedButton.icon(
                                            //     onPressed: _removeCurrentMarker,
                                            //     icon: const Icon(
                                            //         Icons.delete_outline),
                                            //     label:
                                            //         const Text('Remove marker'),
                                            //     style: ElevatedButton.styleFrom(
                                            //       elevation: 0,
                                            //       backgroundColor:
                                            //           Colors.white24,
                                            //       shape: RoundedRectangleBorder(
                                            //           borderRadius:
                                            //               BorderRadius.circular(
                                            //                   8)),
                                            //     ),
                                            //   ),
                                            // ),
                                          ],
                                        ),

                                        const SizedBox(height: 12),

                                        // Extra placeholder content to show expand behavior
                                        // if (_panelHeight >
                                        //     (_panelMinHeight + 80))
                                        //   const Column(
                                        //     crossAxisAlignment:
                                        //         CrossAxisAlignment.start,
                                        //     children: [
                                        //       Divider(color: Colors.white24),
                                        //       SizedBox(height: 8),
                                        //       Text('Notes',
                                        //           style: TextStyle(
                                        //               color: Colors.white70,
                                        //               fontWeight:
                                        //                   FontWeight.bold)),
                                        //       SizedBox(height: 6),
                                        //       Text(
                                        //         'This is an example of expanded content. You can add more structured fields here — address, custom metadata, photos, links, etc.',
                                        //         style: TextStyle(
                                        //             color: Colors.white70),
                                        //       ),
                                        //       SizedBox(height: 12),
                                          //   ],
                                          // ),
                                      ],
                                    )
                                  // : SizedBox(
                                  //     height: 80,
                                  //     child: Center(
                                  //       child: Text(
                                  //         'Tap on the map to add a marker',
                                  //         style: TextStyle(
                                  //             color: Colors.white
                                  //                 .withOpacity(0.85)),
                                  //       ),
                                  //     ),
                                  //   ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
