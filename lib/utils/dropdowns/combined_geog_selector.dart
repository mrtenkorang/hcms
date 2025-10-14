// import 'package:dropdown_search/dropdown_search.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:hcms_revived2/main.dart';
// import 'package:hcms_revived2/models/apimodels/communitymodel.dart';
// import 'package:hcms_revived2/models/apimodels/districtmodel.dart';
// import 'package:hcms_revived2/models/apimodels/forestdistrict.dart';
// import 'package:hcms_revived2/models/apimodels/regionmodel.dart';
// import 'package:hcms_revived2/models/apimodels/stool.dart';
// import 'package:hcms_revived2/utils/constants/colours.dart';
// import 'package:hcms_revived2/utils/constants/http_constructors.dart';
// import 'package:hcms_revived2/utils/customershimmerbuilder.dart';
// import 'package:hcms_revived2/utils/globals.dart';
// import 'package:hcms_revived2/utils/widgets/textFormats/text_formats.dart';
//
// class CommunitySelector extends StatefulWidget {
//   final String? pickedCommunityCode;
//   final bool showRegionSelector;
//   final bool showForestDistrictSelector;
//   final bool showStoolSelector;
//   final bool showDistrictSelector;
//   final bool showCommunitySelector;
//
//   const CommunitySelector({
//     super.key,
//     this.pickedCommunityCode,
//     required this.showRegionSelector,
//     required this.showForestDistrictSelector,
//     required this.showStoolSelector,
//     required this.showDistrictSelector,
//     required this.showCommunitySelector,
//   });
//
//   @override
//   _CommunitySelectorState createState() => _CommunitySelectorState();
// }
//
// class _CommunitySelectorState extends State<CommunitySelector> {
//   List<RegionJson> _regionValues = [];
//   List<DistrictsJson> _districtsValues = [];
//   List<ForestDistrictsJson> _forestDistrictsValues = [];
//   List<CommunityJson> _communityValues = [];
//   List<StoolJson> _stoolValues = [];
//
//   // for form validation
//   String? _disV;
//
//   String? _communityValue;
//
//   void _onCommunityChanged(String disVal, ctx) {
//     setState(() {
//       _disV = disVal;
//     });
//   }
//
//   Future<List<RegionJson>>? myRegionFuture;
//   Future<List<DistrictsJson>>? myDistrictFuture;
//   Future<List<ForestDistrictsJson>>? myForestDistrictFuture;
//   Future<List<CommunityJson>>? myCommunityFuture;
//   Future<List<StoolJson>>? myStoolFuture;
//
//   String? discode;
//   String? disName;
//
//   String? variantCommunity;
//
//   @override
//   void initState() {
//     super.initState();
//
//     // _communityValue = regSP?.getString("communitycode");
//     // variantCommunity = regSP?.getString("communityCommunityname").toString().isEmpty
//     //     ? dropDownEqualiser
//     //     : regSP!.getString("communityCommunityname");
//
//     _regionValues = [];
//     _districtsValues = [];
//     _forestDistrictsValues = [];
//     _communityValues = [];
//     _stoolValues = [];
//
//     myRegionFuture = regionListHttp.getRegionListService(context).then((value) {
//       return _regionValues =
//           value.map<RegionJson>(RegionJson.fromRegionJson).toList();
//     });
//
//     myDistrictFuture =
//         districtListHttp.getDistrictListService(context).then((value) {
//       return _districtsValues =
//           value.map<DistrictsJson>(DistrictsJson.fromJson).toList();
//     });
//
//     myForestDistrictFuture = forestdistrictListHttp
//         .getForestdistrictListService(context)
//         .then((value) {
//       return _forestDistrictsValues =
//           value.map<ForestDistrictsJson>(ForestDistrictsJson.fromJson).toList();
//     });
//
//     myCommunityFuture =
//         communityListHttp.getCommunityListService(context).then((value) {
//       return _communityValues =
//           value.map<CommunityJson>(CommunityJson.fromJson).toList();
//     });
//
//     stoolListHttp.getStoolListService(context).then((value) {
//       return _stoolValues = value.map<StoolJson>(StoolJson.fromJson).toList();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//
//     return Column(
//       children: [
//         // start of region selector
//         formFieldLabel("Select region", width: size.width * .9),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Expanded(
//               child: Container(
//                 width: size.width * .8,
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 10.0, vertical: 15.0),
//                   child: FutureBuilder<List<CommunityJson>>(
//                       future: myCommunityFuture,
//                       builder: (context, asyn) {
//                         if (asyn.connectionState == ConnectionState.waiting) {
//                           return shimmerWidgetDropdown(size);
//                         }
//                         if (asyn.hasData == false) {
//                           return const Text(
//                               "Operation failed. Refresh to sync data.",
//                               style: TextStyle(color: primaryError));
//                         }
//
//                         if (asyn.hasError) {
//                           return const Material(
//                             child: Text(
//                                 "Operation faced error. Refresh to sync data.",
//                                 style: TextStyle(
//                                     color: primaryError,
//                                     fontSize: 22.0,
//                                     fontWeight: FontWeight.bold)),
//                           );
//                         }
//                         if (!asyn.hasData) {
//                           return const Text(
//                               "Something happened. Refresh to sync data.",
//                               style: TextStyle(color: primaryError));
//                         }
//                         return DropdownSearch<String>(
//                           // child: DropdownButton<String>(
//                           // isExpanded: true,
//                           selectedItem: _disV,
//                           // dropdownColor: fillColour,
//                           dropdownDecoratorProps: DropDownDecoratorProps(
//                             dropdownSearchDecoration: InputDecoration(
//                               filled: true,
//                               fillColor: fillColour,
//                               counterText: "",
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(5),
//                                 borderSide:
//                                     const BorderSide(color: primaryBlack),
//                               ),
//                               focusedErrorBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(5),
//                                 borderSide: const BorderSide(
//                                   color: primaryError,
//                                 ),
//                               ),
//                               focusedBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(5),
//                                 borderSide: const BorderSide(
//                                   color: primaryColour,
//                                 ),
//                               ),
//                               disabledBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(5),
//                                 borderSide:
//                                     const BorderSide(color: primaryBlack),
//                               ),
//                               errorBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(5),
//                                 borderSide: const BorderSide(
//                                   color: primaryError,
//                                 ),
//                               ),
//                               errorStyle: const TextStyle(color: primaryError),
//                               prefixIconConstraints: const BoxConstraints(
//                                   minWidth: 0, minHeight: 0),
//                               labelStyle: const TextStyle(color: primaryBlack),
//                               hintText: widget.pickedCommunityCode ??
//                                   variantCommunity ??
//                                   "Select",
//                               hintStyle: const TextStyle(
//                                 fontSize: 14,
//                               ),
//                               iconColor: primaryBlack,
//                             ),
//                           ),
//                           dropdownButtonProps: const DropdownButtonProps(
//                             icon: Icon(
//                               CupertinoIcons.arrow_up_down,
//                               size: 17.5,
//                               color: primaryBlack,
//                             ),
//                           ),
//                           popupProps: PopupPropsMultiSelection.menu(
//                               showSelectedItems: true,
//                               showSearchBox: true,
//                               menuProps: MenuProps(
//                                   borderRadius: BorderRadius.circular(5.0))
//                               // disabledItemFn: (String s) => s.startsWith('I'),
//                               ),
//                           onChanged: (String? value) {
//                             _onCommunityChanged(value!, context);
//
//                             debugPrint("Search drop value $value");
//
//                             for (var v in _communityValues) {
//                               if (value.trim() == v.name!.toString().trim()) {
//                                 debugPrint("Printed is ${v.comcode}");
//                                 setState(() {
//                                   _communityValue = v.comcode.toString();
//
//                                   regSP?.setString('communitycode',
//                                       _communityValue.toString());
//                                   regSP?.setString('communityname', v.name!);
//
//                                   debugPrint(
//                                       "Community Code ${v.comcode.toString()} and ${regSP?.getString("communitycode")}");
//                                 });
//                               }
//                             }
//                           },
//                           items: _communityValues.map((value) {
//                             return value.name ?? "community name";
//                           }).toList(),
//                         );
//                       }),
//                 ),
//               ),
//             ),
//             IconButton(
//                 onPressed: () {
//                   setState(() {
//                     _communityValues = [];
//                     // myCommunityFuture = writeToCommunityFile(this.context);
//                     myCommunityFuture = communityListHttp
//                         .getCommunityListService(context)
//                         .then((value) {
//                       return _communityValues = value
//                           .map<CommunityJson>(CommunityJson.fromJson)
//                           .toList();
//                     });
//                   });
//                 },
//                 icon: const Icon(Icons.refresh))
//           ],
//         ),
//         // end of region selector
//
//         // start of forest district selector
//         formFieldLabel("Select Forest District", width: size.width * .9),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Expanded(
//               child: Container(
//                 width: size.width * .8,
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 10.0, vertical: 15.0),
//                   child: FutureBuilder<List<CommunityJson>>(
//                       future: myCommunityFuture,
//                       builder: (context, asyn) {
//                         if (asyn.connectionState == ConnectionState.waiting) {
//                           return shimmerWidgetDropdown(size);
//                         }
//                         if (asyn.hasData == false) {
//                           return const Text(
//                               "Operation failed. Refresh to sync data.",
//                               style: TextStyle(color: primaryError));
//                         }
//
//                         if (asyn.hasError) {
//                           return const Material(
//                             child: Text(
//                                 "Operation faced error. Refresh to sync data.",
//                                 style: TextStyle(
//                                     color: primaryError,
//                                     fontSize: 22.0,
//                                     fontWeight: FontWeight.bold)),
//                           );
//                         }
//                         if (!asyn.hasData) {
//                           return const Text(
//                               "Something happened. Refresh to sync data.",
//                               style: TextStyle(color: primaryError));
//                         }
//                         return DropdownSearch<String>(
//                           // child: DropdownButton<String>(
//                           // isExpanded: true,
//                           selectedItem: _disV,
//                           // dropdownColor: fillColour,
//                           dropdownDecoratorProps: DropDownDecoratorProps(
//                             dropdownSearchDecoration: InputDecoration(
//                               filled: true,
//                               fillColor: fillColour,
//                               counterText: "",
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(5),
//                                 borderSide:
//                                     const BorderSide(color: primaryBlack),
//                               ),
//                               focusedErrorBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(5),
//                                 borderSide: const BorderSide(
//                                   color: primaryError,
//                                 ),
//                               ),
//                               focusedBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(5),
//                                 borderSide: const BorderSide(
//                                   color: primaryColour,
//                                 ),
//                               ),
//                               disabledBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(5),
//                                 borderSide:
//                                     const BorderSide(color: primaryBlack),
//                               ),
//                               errorBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(5),
//                                 borderSide: const BorderSide(
//                                   color: primaryError,
//                                 ),
//                               ),
//                               errorStyle: const TextStyle(color: primaryError),
//                               prefixIconConstraints: const BoxConstraints(
//                                   minWidth: 0, minHeight: 0),
//                               labelStyle: const TextStyle(color: primaryBlack),
//                               hintText: widget.pickedCommunityCode ??
//                                   variantCommunity ??
//                                   "Select",
//                               hintStyle: const TextStyle(
//                                 fontSize: 14,
//                               ),
//                               iconColor: primaryBlack,
//                             ),
//                           ),
//                           dropdownButtonProps: const DropdownButtonProps(
//                             icon: Icon(
//                               CupertinoIcons.arrow_up_down,
//                               size: 17.5,
//                               color: primaryBlack,
//                             ),
//                           ),
//                           popupProps: PopupPropsMultiSelection.menu(
//                               showSelectedItems: true,
//                               showSearchBox: true,
//                               menuProps: MenuProps(
//                                   borderRadius: BorderRadius.circular(5.0))
//                               // disabledItemFn: (String s) => s.startsWith('I'),
//                               ),
//                           onChanged: (String? value) {
//                             _onCommunityChanged(value!, context);
//
//                             debugPrint("Search drop value $value");
//
//                             for (var v in _communityValues) {
//                               if (value.trim() == v.name!.toString().trim()) {
//                                 debugPrint("Printed is ${v.comcode}");
//                                 setState(() {
//                                   _communityValue = v.comcode.toString();
//
//                                   regSP?.setString('communitycode',
//                                       _communityValue.toString());
//                                   regSP?.setString('communityname', v.name!);
//
//                                   debugPrint(
//                                       "Community Code ${v.comcode.toString()} and ${regSP?.getString("communitycode")}");
//                                 });
//                               }
//                             }
//                           },
//                           items: _communityValues.map((value) {
//                             return value.name ?? "community name";
//                           }).toList(),
//                         );
//                       }),
//                 ),
//               ),
//             ),
//             IconButton(
//                 onPressed: () {
//                   setState(() {
//                     _communityValues = [];
//                     // myCommunityFuture = writeToCommunityFile(this.context);
//                     myCommunityFuture = communityListHttp
//                         .getCommunityListService(context)
//                         .then((value) {
//                       return _communityValues = value
//                           .map<CommunityJson>(CommunityJson.fromJson)
//                           .toList();
//                     });
//                   });
//                 },
//                 icon: const Icon(Icons.refresh))
//           ],
//         ),
//         // end of forest district selector
//
//         // start of stool selector
//         formFieldLabel("TA/Stool/Skin/Family", width: size.width * .9),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Expanded(
//               child: Container(
//                 width: size.width * .8,
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 10.0, vertical: 15.0),
//                   child: FutureBuilder<List<CommunityJson>>(
//                       future: myCommunityFuture,
//                       builder: (context, asyn) {
//                         if (asyn.connectionState == ConnectionState.waiting) {
//                           return shimmerWidgetDropdown(size);
//                         }
//                         if (asyn.hasData == false) {
//                           return const Text(
//                               "Operation failed. Refresh to sync data.",
//                               style: TextStyle(color: primaryError));
//                         }
//
//                         if (asyn.hasError) {
//                           return const Material(
//                             child: Text(
//                                 "Operation faced error. Refresh to sync data.",
//                                 style: TextStyle(
//                                     color: primaryError,
//                                     fontSize: 22.0,
//                                     fontWeight: FontWeight.bold)),
//                           );
//                         }
//                         if (!asyn.hasData) {
//                           return const Text(
//                               "Something happened. Refresh to sync data.",
//                               style: TextStyle(color: primaryError));
//                         }
//                         return DropdownSearch<String>(
//                           // child: DropdownButton<String>(
//                           // isExpanded: true,
//                           selectedItem: _disV,
//                           // dropdownColor: fillColour,
//                           dropdownDecoratorProps: DropDownDecoratorProps(
//                             dropdownSearchDecoration: InputDecoration(
//                               filled: true,
//                               fillColor: fillColour,
//                               counterText: "",
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(5),
//                                 borderSide:
//                                     const BorderSide(color: primaryBlack),
//                               ),
//                               focusedErrorBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(5),
//                                 borderSide: const BorderSide(
//                                   color: primaryError,
//                                 ),
//                               ),
//                               focusedBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(5),
//                                 borderSide: const BorderSide(
//                                   color: primaryColour,
//                                 ),
//                               ),
//                               disabledBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(5),
//                                 borderSide:
//                                     const BorderSide(color: primaryBlack),
//                               ),
//                               errorBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(5),
//                                 borderSide: const BorderSide(
//                                   color: primaryError,
//                                 ),
//                               ),
//                               errorStyle: const TextStyle(color: primaryError),
//                               prefixIconConstraints: const BoxConstraints(
//                                   minWidth: 0, minHeight: 0),
//                               labelStyle: const TextStyle(color: primaryBlack),
//                               hintText: widget.pickedCommunityCode ??
//                                   variantCommunity ??
//                                   "Select",
//                               hintStyle: const TextStyle(
//                                 fontSize: 14,
//                               ),
//                               iconColor: primaryBlack,
//                             ),
//                           ),
//                           dropdownButtonProps: const DropdownButtonProps(
//                             icon: Icon(
//                               CupertinoIcons.arrow_up_down,
//                               size: 17.5,
//                               color: primaryBlack,
//                             ),
//                           ),
//                           popupProps: PopupPropsMultiSelection.menu(
//                               showSelectedItems: true,
//                               showSearchBox: true,
//                               menuProps: MenuProps(
//                                   borderRadius: BorderRadius.circular(5.0))
//                               // disabledItemFn: (String s) => s.startsWith('I'),
//                               ),
//                           onChanged: (String? value) {
//                             _onCommunityChanged(value!, context);
//
//                             debugPrint("Search drop value $value");
//
//                             for (var v in _communityValues) {
//                               if (value.trim() == v.name!.toString().trim()) {
//                                 debugPrint("Printed is ${v.comcode}");
//                                 setState(() {
//                                   _communityValue = v.comcode.toString();
//
//                                   regSP?.setString('communitycode',
//                                       _communityValue.toString());
//                                   regSP?.setString('communityname', v.name!);
//
//                                   debugPrint(
//                                       "Community Code ${v.comcode.toString()} and ${regSP?.getString("communitycode")}");
//                                 });
//                               }
//                             }
//                           },
//                           items: _communityValues.map((value) {
//                             return value.name ?? "community name";
//                           }).toList(),
//                         );
//                       }),
//                 ),
//               ),
//             ),
//             IconButton(
//                 onPressed: () {
//                   setState(() {
//                     _communityValues = [];
//                     // myCommunityFuture = writeToCommunityFile(this.context);
//                     myCommunityFuture = communityListHttp
//                         .getCommunityListService(context)
//                         .then((value) {
//                       return _communityValues = value
//                           .map<CommunityJson>(CommunityJson.fromJson)
//                           .toList();
//                     });
//                   });
//                 },
//                 icon: const Icon(Icons.refresh))
//           ],
//         ),
//         // end of stool selector
//
//         // start of district selector
//         formFieldLabel("Select MMDAs", width: size.width * .9),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Expanded(
//               child: Container(
//                 width: size.width * .8,
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 10.0, vertical: 15.0),
//                   child: FutureBuilder<List<CommunityJson>>(
//                       future: myCommunityFuture,
//                       builder: (context, asyn) {
//                         if (asyn.connectionState == ConnectionState.waiting) {
//                           return shimmerWidgetDropdown(size);
//                         }
//                         if (asyn.hasData == false) {
//                           return const Text(
//                               "Operation failed. Refresh to sync data.",
//                               style: TextStyle(color: primaryError));
//                         }
//
//                         if (asyn.hasError) {
//                           return const Material(
//                             child: Text(
//                                 "Operation faced error. Refresh to sync data.",
//                                 style: TextStyle(
//                                     color: primaryError,
//                                     fontSize: 22.0,
//                                     fontWeight: FontWeight.bold)),
//                           );
//                         }
//                         if (!asyn.hasData) {
//                           return const Text(
//                               "Something happened. Refresh to sync data.",
//                               style: TextStyle(color: primaryError));
//                         }
//                         return DropdownSearch<String>(
//                           // child: DropdownButton<String>(
//                           // isExpanded: true,
//                           selectedItem: _disV,
//                           // dropdownColor: fillColour,
//                           dropdownDecoratorProps: DropDownDecoratorProps(
//                             dropdownSearchDecoration: InputDecoration(
//                               filled: true,
//                               fillColor: fillColour,
//                               counterText: "",
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(5),
//                                 borderSide:
//                                     const BorderSide(color: primaryBlack),
//                               ),
//                               focusedErrorBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(5),
//                                 borderSide: const BorderSide(
//                                   color: primaryError,
//                                 ),
//                               ),
//                               focusedBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(5),
//                                 borderSide: const BorderSide(
//                                   color: primaryColour,
//                                 ),
//                               ),
//                               disabledBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(5),
//                                 borderSide:
//                                     const BorderSide(color: primaryBlack),
//                               ),
//                               errorBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(5),
//                                 borderSide: const BorderSide(
//                                   color: primaryError,
//                                 ),
//                               ),
//                               errorStyle: const TextStyle(color: primaryError),
//                               prefixIconConstraints: const BoxConstraints(
//                                   minWidth: 0, minHeight: 0),
//                               labelStyle: const TextStyle(color: primaryBlack),
//                               hintText: widget.pickedCommunityCode ??
//                                   variantCommunity ??
//                                   "Select",
//                               hintStyle: const TextStyle(
//                                 fontSize: 14,
//                               ),
//                               iconColor: primaryBlack,
//                             ),
//                           ),
//                           dropdownButtonProps: const DropdownButtonProps(
//                             icon: Icon(
//                               CupertinoIcons.arrow_up_down,
//                               size: 17.5,
//                               color: primaryBlack,
//                             ),
//                           ),
//                           popupProps: PopupPropsMultiSelection.menu(
//                               showSelectedItems: true,
//                               showSearchBox: true,
//                               menuProps: MenuProps(
//                                   borderRadius: BorderRadius.circular(5.0))
//                               // disabledItemFn: (String s) => s.startsWith('I'),
//                               ),
//                           onChanged: (String? value) {
//                             _onCommunityChanged(value!, context);
//
//                             debugPrint("Search drop value $value");
//
//                             for (var v in _communityValues) {
//                               if (value.trim() == v.name!.toString().trim()) {
//                                 debugPrint("Printed is ${v.comcode}");
//                                 setState(() {
//                                   _communityValue = v.comcode.toString();
//
//                                   regSP?.setString('communitycode',
//                                       _communityValue.toString());
//                                   regSP?.setString('communityname', v.name!);
//
//                                   debugPrint(
//                                       "Community Code ${v.comcode.toString()} and ${regSP?.getString("communitycode")}");
//                                 });
//                               }
//                             }
//                           },
//                           items: _communityValues.map((value) {
//                             return value.name ?? "community name";
//                           }).toList(),
//                         );
//                       }),
//                 ),
//               ),
//             ),
//             IconButton(
//                 onPressed: () {
//                   setState(() {
//                     _communityValues = [];
//                     // myCommunityFuture = writeToCommunityFile(this.context);
//                     myCommunityFuture = communityListHttp
//                         .getCommunityListService(context)
//                         .then((value) {
//                       return _communityValues = value
//                           .map<CommunityJson>(CommunityJson.fromJson)
//                           .toList();
//                     });
//                   });
//                 },
//                 icon: const Icon(Icons.refresh))
//           ],
//         ),
//         // end of district selector
//
//         // start of community selector
//         formFieldLabel("Select Community", width: size.width * .9),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Expanded(
//               child: Container(
//                 width: size.width * .8,
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 10.0, vertical: 15.0),
//                   child: FutureBuilder<List<CommunityJson>>(
//                       future: myCommunityFuture,
//                       builder: (context, asyn) {
//                         if (asyn.connectionState == ConnectionState.waiting) {
//                           return shimmerWidgetDropdown(size);
//                         }
//                         if (asyn.hasData == false) {
//                           return const Text(
//                               "Operation failed. Refresh to sync data.",
//                               style: TextStyle(color: primaryError));
//                         }
//
//                         if (asyn.hasError) {
//                           return const Material(
//                             child: Text(
//                                 "Operation faced error. Refresh to sync data.",
//                                 style: TextStyle(
//                                     color: primaryError,
//                                     fontSize: 22.0,
//                                     fontWeight: FontWeight.bold)),
//                           );
//                         }
//                         if (!asyn.hasData) {
//                           return const Text(
//                               "Something happened. Refresh to sync data.",
//                               style: TextStyle(color: primaryError));
//                         }
//                         return DropdownSearch<String>(
//                           // child: DropdownButton<String>(
//                           // isExpanded: true,
//                           selectedItem: _disV,
//                           // dropdownColor: fillColour,
//                           dropdownDecoratorProps: DropDownDecoratorProps(
//                             dropdownSearchDecoration: InputDecoration(
//                               filled: true,
//                               fillColor: fillColour,
//                               counterText: "",
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(5),
//                                 borderSide:
//                                     const BorderSide(color: primaryBlack),
//                               ),
//                               focusedErrorBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(5),
//                                 borderSide: const BorderSide(
//                                   color: primaryError,
//                                 ),
//                               ),
//                               focusedBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(5),
//                                 borderSide: const BorderSide(
//                                   color: primaryColour,
//                                 ),
//                               ),
//                               disabledBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(5),
//                                 borderSide:
//                                     const BorderSide(color: primaryBlack),
//                               ),
//                               errorBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(5),
//                                 borderSide: const BorderSide(
//                                   color: primaryError,
//                                 ),
//                               ),
//                               errorStyle: const TextStyle(color: primaryError),
//                               prefixIconConstraints: const BoxConstraints(
//                                   minWidth: 0, minHeight: 0),
//                               labelStyle: const TextStyle(color: primaryBlack),
//                               hintText: widget.pickedCommunityCode ??
//                                   variantCommunity ??
//                                   "Select",
//                               hintStyle: const TextStyle(
//                                 fontSize: 14,
//                               ),
//                               iconColor: primaryBlack,
//                             ),
//                           ),
//                           dropdownButtonProps: const DropdownButtonProps(
//                             icon: Icon(
//                               CupertinoIcons.arrow_up_down,
//                               size: 17.5,
//                               color: primaryBlack,
//                             ),
//                           ),
//                           popupProps: PopupPropsMultiSelection.menu(
//                               showSelectedItems: true,
//                               showSearchBox: true,
//                               menuProps: MenuProps(
//                                   borderRadius: BorderRadius.circular(5.0))
//                               // disabledItemFn: (String s) => s.startsWith('I'),
//                               ),
//                           onChanged: (String? value) {
//                             _onCommunityChanged(value!, context);
//
//                             debugPrint("Search drop value $value");
//
//                             for (var v in _communityValues) {
//                               if (value.trim() == v.name!.toString().trim()) {
//                                 debugPrint("Printed is ${v.comcode}");
//                                 setState(() {
//                                   _communityValue = v.comcode.toString();
//
//                                   regSP?.setString('communitycode',
//                                       _communityValue.toString());
//                                   regSP?.setString('communityname', v.name!);
//
//                                   debugPrint(
//                                       "Community Code ${v.comcode.toString()} and ${regSP?.getString("communitycode")}");
//                                 });
//                               }
//                             }
//                           },
//                           items: _communityValues.map((value) {
//                             return value.name ?? "community name";
//                           }).toList(),
//                         );
//                       }),
//                 ),
//               ),
//             ),
//             IconButton(
//                 onPressed: () {
//                   setState(() {
//                     _communityValues = [];
//                     // myCommunityFuture = writeToCommunityFile(this.context);
//                     myCommunityFuture = communityListHttp
//                         .getCommunityListService(context)
//                         .then((value) {
//                       return _communityValues = value
//                           .map<CommunityJson>(CommunityJson.fromJson)
//                           .toList();
//                     });
//                   });
//                 },
//                 icon: const Icon(Icons.refresh))
//           ],
//         ),
//         // end of community
//       ],
//     );
//   }
// }
