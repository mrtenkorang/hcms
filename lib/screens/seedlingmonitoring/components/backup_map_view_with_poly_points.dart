
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:flutter/services.dart'
//     show Clipboard, ClipboardData, rootBundle;
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:hcms_revived2/screens/addedMaps/dependencies/globals.dart';
// import 'package:hcms_revived2/screens/addedMaps/dependencies/round_icon_button.dart';
// import 'package:hcms_revived2/screens/addedMaps/dependencies/style.dart';
// import 'package:sliding_up_panel/sliding_up_panel.dart';


// class AssignedOutbreaksMap extends StatefulWidget {
//   const AssignedOutbreaksMap({Key? key}) : super(key: key);

//   @override
//   State<AssignedOutbreaksMap> createState() => _AssignedOutbreaksMapState();
// }

// class _AssignedOutbreaksMapState extends State<AssignedOutbreaksMap>
//     with WidgetsBindingObserver {

//   // GlobalController indexController = Get.find();

//   Globals globals = Globals();

//   String? _mapStyle;

//   final double _initFabHeight = 190.0;
//   late double _fabHeight;
//   late double _panelHeightOpen;
//   final double _panelHeightClosed = 180.0;
//   PanelController panelController = PanelController();

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }

//   @override
//   void initState() {
//     super.initState();

//     rootBundle.loadString('assets/map_style/silver.txt').then((string) {
//       _mapStyle = string;
//     });

//     // assignedOutbreaksMapController.markers = Set.from([]);
//     WidgetsBinding.instance.addObserver(this);
//     _fabHeight = _initFabHeight;
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.resumed) {
//       // _initMapStyle();
//     }
//   }

//   // Future<void> _initMapStyle() async {
//   //   await assignedOutbreaksMapController.mapController?.setMapStyle(_mapStyle);
//   // }

//   @override
//   Widget build(BuildContext context) {
//     // assignedOutbreaksMapController.assignedOutbreaksMapScreenContext = context;
//     _panelHeightOpen = MediaQuery.of(context).size.height * 0.55;

//     return Material(
//       child: Scaffold(
//         body: Stack(
//           alignment: Alignment.topCenter,
//           children: <Widget>[
//             SlidingUpPanel(
//               maxHeight: _panelHeightOpen,
//               minHeight: _panelHeightClosed,
//               parallaxEnabled: true,
//               parallaxOffset: .5,
//               controller: panelController,
//               defaultPanelState: PanelState.CLOSED,
//               body: _body(),
//               panelBuilder: (sc) => _panel(sc),
//               borderRadius: const BorderRadius.only(
//                   topLeft: Radius.circular(18.0),
//                   topRight: Radius.circular(18.0)),
//               onPanelSlide: (double pos) => setState(() {
//                 _fabHeight = pos * (_panelHeightOpen - _panelHeightClosed) +
//                     _initFabHeight;
//               }),
//             ),

//             Positioned(
//               right: 10.0,
//               bottom: _fabHeight,
//               child: CircleIconButton(
//                 icon: appIconTarget(color: AppColor.black, size: 20),
//                 backgroundColor: Colors.white,
//                 hasShadow: true,
//                 size: 45,
//                 // onTap: () => assignedOutbreaksMapController.goToUserLocation(),
//               ),
//             ),

//             // Positioned(
//             //   right: 10.0,
//             //   bottom: _fabHeight + 60,
//             //   child: CircleIconButton(
//             //     icon: appIconZoomOut(color: AppColor.black, size: 20),
//             //     backgroundColor: Colors.white,
//             //     hasShadow: true,
//             //     size: 45,
//             //     onTap: () {},
//             //   ),
//             // ),
//             //
//             // Positioned(
//             //   right: 10.0,
//             //   bottom: _fabHeight + 120,
//             //   child: CircleIconButton(
//             //     icon: appIconZoomIn(color: AppColor.black, size: 20),
//             //     backgroundColor: Colors.white,
//             //     hasShadow: true,
//             //     size: 45,
//             //     onTap: () {},
//             //   ),
//             // ),

//             Align(
//               // top: 40.0,
//               // left: 10.0,
//               alignment: Alignment.topCenter,
//               child: Padding(
//                 padding:
//                     const EdgeInsets.symmetric(vertical: 45.0, horizontal: 15),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     CircleIconButton(
//                       icon: appIconBack(color: AppColor.black, size: 25),
//                       backgroundColor: Colors.white,
//                       hasShadow: true,
//                       size: 45,
//                       onTap: () => Get.back(),
//                     ),
//                     const SizedBox(
//                       width: 12,
//                     ),
//                     Expanded(
//                       child: Text('Assigned Outbreaks',
//                           style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w600,
//                               color: AppColor.black)),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//         // body: Stack(
//         //   children: [
//         //
//         //     GetBuilder(
//         //         init: assignedOutbreaksMapController,
//         //         builder: (controller) {
//         //           return GoogleMap(
//         //             initialCameraPosition: assignedOutbreaksMapController.initialCameraPosition,
//         //             mapType: MapType.normal,
//         //             compassEnabled: false,
//         //             myLocationEnabled: false,
//         //             myLocationButtonEnabled: false,
//         //             zoomControlsEnabled: false,
//         //             markers: assignedOutbreaksMapController.markers,
//         //             polygons: assignedOutbreaksMapController.polygons,
//         //             mapToolbarEnabled: false,
//         //             onMapCreated: _onMapCreated,
//         //             // onMapCreated: (GoogleMapController controller) {
//         //             //   assignedOutbreaksMapController.mapController = controller;
//         //             //   controller.setMapStyle(_mapStyle);
//         //             //   // waiIndexController.getUserLocation(useUserCurrentLocation: true);
//         //             // },
//         //
//         //           );
//         //         }
//         //     ),
//         //
//         //     Align(
//         //       // top: 40.0,
//         //       // left: 10.0,
//         //       alignment: Alignment.topCenter,
//         //       child: Padding(
//         //         padding: const EdgeInsets.symmetric(vertical: 45.0, horizontal: 15),
//         //         child: Row(
//         //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         //           children: [
//         //                 CircleIconButton(
//         //                   icon: appIconBack(color: AppColor.black, size: 25),
//         //                   backgroundColor: Colors.white,
//         //                   hasShadow: true,
//         //                   size: 45,
//         //                   onTap: () => Get.back(),
//         //                 ),
//         //
//         //             SizedBox(width: 12,),
//         //
//         //             Expanded(
//         //               child: Text('Your Farms',
//         //                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColor.black)
//         //               ),
//         //             ),
//         //
//         //           ],
//         //         ),
//         //       ),
//         //     ),
//         //
//         //   ],
//         // ),
//       ),
//     );
//   }

//   Widget _body() {
//     return GetBuilder(
//         // init: assignedOutbreaksMapController,
//         builder: (controller) {
//           return GoogleMap(
//             initialCameraPosition:
//                 assignedOutbreaksMapController.initialCameraPosition,
//             mapType: MapType.normal,
//             compassEnabled: false,
//             myLocationEnabled: true,
//             myLocationButtonEnabled: false,
//             zoomControlsEnabled: false,
//             markers: assignedOutbreaksMapController.markers,
//             polygons: assignedOutbreaksMapController.polygons,
//             mapToolbarEnabled: false,
//             onMapCreated: _onMapCreated,
//             // onMapCreated: (GoogleMapController controller) {
//             //   assignedOutbreaksMapController.mapController = controller;
//             //   controller.setMapStyle(_mapStyle);
//             //   // waiIndexController.getUserLocation(useUserCurrentLocation: true);
//             // },
//           );
//         });
//   }

//   // Widget _panel(ScrollController sc) {
//   //   return MediaQuery.removePadding(
//   //       context: context,
//   //       removeTop: true,
//   //       child: Column(
//   //         children: [
//   //           const SizedBox(
//   //             height: 12.0,
//   //           ),
//   //           Row(
//   //             mainAxisAlignment: MainAxisAlignment.center,
//   //             children: <Widget>[
//   //               Container(
//   //                 width: MediaQuery.of(context).size.width * 0.20,
//   //                 height: 4,
//   //                 decoration: const BoxDecoration(
//   //                     color: Colors.black12,
//   //                     borderRadius: BorderRadius.all(Radius.circular(20.0))),
//   //               ),
//   //             ],
//   //           ),
//   //           const SizedBox(
//   //             height: 12.0,
//   //           ),

//   //           Padding(
//   //             padding: const EdgeInsets.only(left: 24.0, right: 24.0),
//   //             child: DropdownSearch<AssignedOutbreak>(
//   //               popupProps: PopupProps.modalBottomSheet(
//   //                   showSelectedItems: true,
//   //                   showSearchBox: true,
//   //                   itemBuilder: (context, item, selected) {
//   //                     return ListTile(
//   //                       title: Text(item.obCode.toString(),
//   //                           style: selected
//   //                               ? TextStyle(color: AppColor.primary)
//   //                               : const TextStyle()),
//   //                       subtitle: Text(
//   //                         item.districtName.toString(),
//   //                       ),
//   //                     );
//   //                   },
//   //                   title: const Padding(
//   //                     padding: EdgeInsets.only(bottom: 15),
//   //                     child: Center(
//   //                       child: Text(
//   //                         'Select Assigned Outbreak',
//   //                         style: TextStyle(fontWeight: FontWeight.w500),
//   //                       ),
//   //                     ),
//   //                   ),
//   //                   disabledItemFn: (AssignedOutbreak s) => false,
//   //                   modalBottomSheetProps: ModalBottomSheetProps(
//   //                     elevation: 6,
//   //                     shape: RoundedRectangleBorder(
//   //                         borderRadius: BorderRadius.only(
//   //                             topLeft: Radius.circular(AppBorderRadius.md),
//   //                             topRight: Radius.circular(AppBorderRadius.md))),
//   //                   ),
//   //                   searchFieldProps: TextFieldProps(
//   //                     decoration: InputDecoration(
//   //                       contentPadding: const EdgeInsets.symmetric(
//   //                           vertical: 4, horizontal: 15),
//   //                       enabledBorder: inputBorder,
//   //                       focusedBorder: inputBorderFocused,
//   //                       errorBorder: inputBorder,
//   //                       focusedErrorBorder: inputBorderFocused,
//   //                       filled: true,
//   //                       fillColor: AppColor.xLightBackground,
//   //                     ),
//   //                   )),
//   //               dropdownDecoratorProps: DropDownDecoratorProps(
//   //                   dropdownSearchDecoration: InputDecoration(
//   //                     contentPadding: const EdgeInsets.symmetric(
//   //                         vertical: 4, horizontal: 15),
//   //                     enabledBorder: inputBorder,
//   //                     focusedBorder: inputBorderFocused,
//   //                     errorBorder: inputBorder,
//   //                     focusedErrorBorder: inputBorderFocused,
//   //                     filled: true,
//   //                     fillColor: AppColor.xLightBackground,
//   //                     hintText: 'Search',
//   //                     hintStyle:
//   //                         TextStyle(color: AppColor.lightText, fontSize: 13),
//   //                     hintMaxLines: 1,
//   //                     prefixIcon: Padding(
//   //                       padding: const EdgeInsets.all(15.0),
//   //                       child:
//   //                           appIconSearch(color: AppColor.lightText, size: 15),
//   //                     ),
//   //                   ),
//   //                   baseStyle: const TextStyle(color: Colors.red)),
//   //               asyncItems: (String filter) async {
//   //                 var response = await assignedOutbreaksMapController
//   //                     .globalController.database!.assignedOutbreakDao
//   //                     .findAllAssignedOutbreaks();
//   //                 return response;
//   //               },
//   //               itemAsString: (AssignedOutbreak d) => d.obCode ?? '',
//   //               filterFn: (AssignedOutbreak d, filter) => d.obCode
//   //                   .toString()
//   //                   .toLowerCase()
//   //                   .contains(filter.toLowerCase()),
//   //               compareFn: (d, filter) => d.obCode == filter.obCode,
//   //               selectedItem:
//   //                   assignedOutbreaksMapController.selectedOutbreak!.value,
//   //               onChanged: (val) {
//   //                 assignedOutbreaksMapController.selectedOutbreak!.value = val!;
//   //                 assignedOutbreaksMapController.goToSelectedPolygon(val);
//   //                 setState(() {});
//   //                 // addMonitoringRecordController.farm = val!;
//   //                 // addMonitoringRecordController.farmSizeTC?.text = val.farmSize.toString();
//   //               },
//   //             ),
//   //           ),

//   //           Container(
//   //             padding: const EdgeInsets.only(left: 12, right: 12),
//   //             child: Obx(
//   //               () => Row(
//   //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //                 mainAxisSize: MainAxisSize.max,
//   //                 children: [
//   //                   assignedOutbreaksMapController.isFirstPolygon.value == false
//   //                       ? CustomButton(
//   //                           isFullWidth: false,
//   //                           backgroundColor: Colors.transparent,
//   //                           verticalPadding: 0.0,
//   //                           horizontalPadding: 8.0,
//   //                           onTap: () => assignedOutbreaksMapController
//   //                               .goToNextPolygon(false),
//   //                           child: Row(
//   //                             mainAxisSize: MainAxisSize.min,
//   //                             children: [
//   //                               appIconCircleLeft(
//   //                                   color: AppColor.black, size: 20),
//   //                               const SizedBox(width: 6),
//   //                               Text(
//   //                                 'Previous',
//   //                                 style: TextStyle(
//   //                                     color: AppColor.black, fontSize: 14),
//   //                               ),
//   //                             ],
//   //                           ),
//   //                         )
//   //                       : Container(),
//   //                   assignedOutbreaksMapController.isLastPolygon.value == false
//   //                       ? CustomButton(
//   //                           isFullWidth: false,
//   //                           backgroundColor: Colors.transparent,
//   //                           verticalPadding: 0.0,
//   //                           horizontalPadding: 8.0,
//   //                           onTap: () => assignedOutbreaksMapController
//   //                               .goToNextPolygon(true),
//   //                           child: Row(
//   //                             mainAxisSize: MainAxisSize.min,
//   //                             children: [
//   //                               Text(
//   //                                 'Next',
//   //                                 style: TextStyle(
//   //                                     color: AppColor.black, fontSize: 14),
//   //                               ),
//   //                               const SizedBox(width: 6),
//   //                               appIconCircleRight(
//   //                                   color: AppColor.black, size: 20),
//   //                             ],
//   //                           ),
//   //                         )
//   //                       : Container(),
//   //                 ],
//   //               ),
//   //             ),
//   //           ),

//   //           // SizedBox(height: 12.0,),
//   //           GetBuilder(
//   //               init: assignedOutbreaksMapController,
//   //               builder: (ctx) {
//   //                 return assignedOutbreaksMapController.emptyData.value != true
//   //                     ? Expanded(
//   //                         child: SingleChildScrollView(
//   //                           padding: const EdgeInsets.only(
//   //                               left: 24.0, right: 24.0, bottom: 20),
//   //                           controller: sc,
//   //                           child: Column(
//   //                             crossAxisAlignment: CrossAxisAlignment.start,
//   //                             children: <Widget>[
//   //                               Obx(
//   //                                 () => assignedOutbreaksMapController
//   //                                             .selectedOutbreak!.value.obCode !=
//   //                                         null
//   //                                     ? Column(
//   //                                         crossAxisAlignment:
//   //                                             CrossAxisAlignment.start,
//   //                                         children: [
//   //                                           // Center(
//   //                                           //   child: Container(
//   //                                           //     padding: EdgeInsets.all(15),
//   //                                           //     decoration: BoxDecoration(
//   //                                           //       shape: BoxShape.circle,
//   //                                           //       color: AppColor.lightText
//   //                                           //     ),
//   //                                           //     child: appIconTractor(color: AppColor.white, size: 40),
//   //                                           //   ),
//   //                                           // ),

//   //                                           const SizedBox(height: 10),

//   //                                           Text('Assigned Outbreak Details',
//   //                                               style: TextStyle(
//   //                                                   fontSize: 17,
//   //                                                   fontWeight: FontWeight.bold,
//   //                                                   color: AppColor.black)),

//   //                                           const SizedBox(height: 15),

//   //                                           Text('Code',
//   //                                               style: TextStyle(
//   //                                                   fontSize: 13,
//   //                                                   color: AppColor.lightText)),
//   //                                           const SizedBox(height: 5),
//   //                                           GestureDetector(
//   //                                             onLongPress: () {
//   //                                               Clipboard.setData(ClipboardData(
//   //                                                       text: assignedOutbreaksMapController
//   //                                                           .selectedOutbreak!
//   //                                                           .value
//   //                                                           .obCode
//   //                                                           .toString()))
//   //                                                   .then((value) {
//   //                                                 globals.showToast(
//   //                                                     "Farm code ${assignedOutbreaksMapController.selectedOutbreak!.value.obCode} copied to clipboard");
//   //                                               });
//   //                                             },
//   //                                             child: Text(
//   //                                                 '${assignedOutbreaksMapController.selectedOutbreak!.value.obCode}',
//   //                                                 style: TextStyle(
//   //                                                     fontSize: 15,
//   //                                                     color: AppColor.black)),
//   //                                           ),

//   //                                           const SizedBox(height: 5),
//   //                                           const Divider(),
//   //                                           const SizedBox(height: 5),

//   //                                           Text('Size',
//   //                                               style: TextStyle(
//   //                                                   fontSize: 13,
//   //                                                   color: AppColor.lightText)),
//   //                                           const SizedBox(height: 5),
//   //                                           Text(
//   //                                               '${assignedOutbreaksMapController.selectedOutbreak!.value.obSize}',
//   //                                               style: TextStyle(
//   //                                                   fontSize: 15,
//   //                                                   color: AppColor.black)),

//   //                                           const SizedBox(height: 5),
//   //                                           const Divider(),
//   //                                           const SizedBox(height: 5),

//   //                                           Text('District',
//   //                                               style: TextStyle(
//   //                                                   fontSize: 13,
//   //                                                   color: AppColor.lightText)),
//   //                                           const SizedBox(height: 5),
//   //                                           Text(
//   //                                               '${assignedOutbreaksMapController.selectedOutbreak!.value.districtName}',
//   //                                               style: TextStyle(
//   //                                                   fontSize: 15,
//   //                                                   color: AppColor.black)),

//   //                                           const SizedBox(height: 5),
//   //                                           const Divider(),
//   //                                           const SizedBox(height: 5),

//   //                                           Text('Region',
//   //                                               style: TextStyle(
//   //                                                   fontSize: 13,
//   //                                                   color: AppColor.lightText)),
//   //                                           const SizedBox(height: 5),
//   //                                           Text(
//   //                                               '${assignedOutbreaksMapController.selectedOutbreak!.value.regionName}',
//   //                                               style: TextStyle(
//   //                                                   fontSize: 15,
//   //                                                   color: AppColor.black)),

//   //                                           const SizedBox(height: 15),

//   //                                           Align(
//   //                                             alignment: Alignment.topRight,
//   //                                             child: CustomButton(
//   //                                               isFullWidth: false,
//   //                                               backgroundColor:
//   //                                                   AppColor.primary,
//   //                                               verticalPadding: 0.0,
//   //                                               horizontalPadding: 8.0,
//   //                                               onTap: () =>
//   //                                                   assignedOutbreaksMapController
//   //                                                       .navigateToLocation(),
//   //                                               child: Row(
//   //                                                 mainAxisSize:
//   //                                                     MainAxisSize.min,
//   //                                                 children: [
//   //                                                   const Text(
//   //                                                     'Navigate Here',
//   //                                                     style: TextStyle(
//   //                                                         color: Colors.white,
//   //                                                         fontSize: 14,
//   //                                                         fontWeight:
//   //                                                             FontWeight.w600),
//   //                                                   ),
//   //                                                   const SizedBox(width: 6),
//   //                                                   appIconNavigation(
//   //                                                       color: Colors.white,
//   //                                                       size: 20),
//   //                                                 ],
//   //                                               ),
//   //                                             ),
//   //                                           )
//   //                                         ],
//   //                                       )
//   //                                     : Container(),
//   //                               )
//   //                             ],
//   //                           ),
//   //                         ),
//   //                       )
//   //                     : Center(
//   //                         child: Column(
//   //                           crossAxisAlignment: CrossAxisAlignment.center,
//   //                           children: [
//   //                             const SizedBox(height: 20),
//   //                             Image.asset(
//   //                               'assets/images/cocoa_monitor/empty-box.png',
//   //                               width: 80,
//   //                             ),
//   //                             const SizedBox(height: 20),
//   //                             Text(
//   //                               "You don't have any assigned outbreak",
//   //                               style: TextStyle(
//   //                                   color: AppColor.black, fontSize: 13),
//   //                               textAlign: TextAlign.center,
//   //                             ),
//   //                           ],
//   //                         ),
//   //                       );
//   //               }),
//   //         ],
//   //       ));
//   // }

//   void _onMapCreated(GoogleMapController controller) {
//     // assignedOutbreaksMapController.mapController = controller;
//     // controller.setMapStyle(_mapStyle);
//     // assignedOutbreaksMapController.loadAssignedOutbreaks();
//     // generalController.setUserCurrentLocation();
//   }
// }
