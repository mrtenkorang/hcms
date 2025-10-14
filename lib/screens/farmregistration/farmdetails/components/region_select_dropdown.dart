// import 'package:dropdown_search/dropdown_search.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:hcms_revived2/models/apimodels/regionmodel.dart';
// import 'package:hcms_revived2/utils/constants/http_constructors.dart';
// import 'package:hcms_revived2/utils/globals.dart';

// class RegionSelector extends StatefulWidget {
//   final String? pickedRegionCode;

//   const RegionSelector({super.key, this.pickedRegionCode = null});

//   @override
//   _RegionSelectorState createState() => _RegionSelectorState();
// }

// class _RegionSelectorState extends State<RegionSelector> {
//   List<RegionJson> _regionValues = [];

//   // for form validation
//   String? _disV;

//   String? _regionValue;

//   void _onParcelChanged(String disVal, ctx) {
//     setState(() {
//       _disV = disVal;
//     });
//   }

//   Future<List<RegionJson>>? myRegionFuture;

//   String? discode;
//   String? disName;

//   String? variantParcel;

//   @override
//   void initState() {
//     super.initState();

//     _regionValue = regSP?.getString("regioncode");
//     variantParcel = regSP!.getString("regionParcelname").toString().isEmpty
//         ? dropDownEqualiser
//         : regSP!.getString("regionParcelname");

//     _regionValues = [];

//     myRegionFuture = regionListHttp.getRegionListService(context).then((value) {
//       return _regionValues =
//           value.map<RegionJson>(RegionJson.fromRegionJson).toList();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;

//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Expanded(
//               child: Container(
//                 width: size.width * .8,
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 10.0, vertical: 15.0),
//                   child: FutureBuilder<List<RegionJson>>(
//                       future: myRegionFuture,
//                       builder: (context, asyn) {
//                         if (asyn.connectionState == ConnectionState.waiting) {
//                           return shimmerWidgetDropdown(size);
//                         }
//                         if (asyn.hasData == false) {
//                           return const Text(
//                               "Operation failed. Refresh to sync data.",
//                               style: TextStyle(color: primaryError));
//                         }

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
//                               fillColor: tertiaryHighlight,
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
//                               hintText: widget.pickedRegionCode ??
//                                   variantParcel ??
//                                   "${localizationsInit(context)?.select}",
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
//                             _onParcelChanged(value!, context);

//                             debugPrint("Search drop value $value");

//                             for (var v in _regionValues) {
//                               if (value.trim() ==
//                                   v.regionParcel!.toString().trim()) {
//                                 debugPrint("Printed is ${v.regionCode}");
//                                 setState(() {
//                                   _regionValue = v.regionCode.toString();

//                                   regSP?.setString(
//                                       'regioncode', _regionValue.toString());
//                                   regSP?.setString(
//                                       'regionParcelname', v.regionParcel!);

//                                   debugPrint(
//                                       "Parcel Code ${v.regionCode.toString()}");
//                                 });
//                               }
//                             }
//                           },
//                           items: _regionValues.map((value) {
//                             return value.regionParcel ?? "parcel";
//                           }).toList(),
//                         );
//                       }),
//                 ),
//               ),
//             ),
//             IconButton(
//                 onPressed: () {
//                   setState(() {
//                     _regionValues = [];
//                     // myRegionFuture = writeToParcelFile(this.context);
//                     myRegionFuture = regionListHttp
//                         .getRegionListService(context)
//                         .then((value) {
//                       return _regionValues = value
//                           .map<RegionJson>(RegionJson.fromParcelList)
//                           .toList();
//                     });
//                   });
//                 },
//                 icon: const Icon(Icons.refresh))
//           ],
//         ),
//         // end of region
//       ],
//     );
//   }
// }
