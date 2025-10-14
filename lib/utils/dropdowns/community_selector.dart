// import 'package:dropdown_search/dropdown_search.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:hcms_revived2/main.dart';
// import 'package:hcms_revived2/models/apimodels/communitymodel.dart';
// import 'package:hcms_revived2/utils/constants/colours.dart';
// import 'package:hcms_revived2/utils/constants/http_constructors.dart';
// import 'package:hcms_revived2/utils/customershimmerbuilder.dart';
// import 'package:hcms_revived2/utils/globals.dart';
//
// class CommunitySelector extends StatefulWidget {
//   final String? pickedCommunityCode;
//
//   const CommunitySelector({super.key, this.pickedCommunityCode});
//
//   @override
//   _CommunitySelectorState createState() => _CommunitySelectorState();
// }
//
// class _CommunitySelectorState extends State<CommunitySelector> {
//   List<CommunityJson> _communityValues = [];
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
//   Future<List<CommunityJson>>? myCommunityFuture;
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
//     _communityValues = [];
//
//     myCommunityFuture = communityListHttp.getCommunityListService(context).then(
//       (value) {
//         return _communityValues = value
//             .map<CommunityJson>(CommunityJson.fromJson)
//             .toList();
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//
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
//                     horizontal: 10.0,
//                     vertical: 15.0,
//                   ),
//                   child: FutureBuilder<List<CommunityJson>>(
//                     future: myCommunityFuture,
//                     builder: (context, asyn) {
//                       if (asyn.connectionState == ConnectionState.waiting) {
//                         return shimmerWidgetDropdown(size);
//                       }
//                       if (asyn.hasData == false) {
//                         return const Text(
//                           "Operation failed. Refresh to sync data.",
//                           style: TextStyle(color: primaryError),
//                         );
//                       }
//
//                       if (asyn.hasError) {
//                         return const Material(
//                           child: Text(
//                             "Operation faced error. Refresh to sync data.",
//                             style: TextStyle(
//                               color: primaryError,
//                               fontSize: 22.0,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         );
//                       }
//                       if (!asyn.hasData) {
//                         return const Text(
//                           "Something happened. Refresh to sync data.",
//                           style: TextStyle(color: primaryError),
//                         );
//                       }
//                       return DropdownSearch<CommunityJson>(
//                         selectedItem: _communityValues.firstWhere(
//                           (element) => element.comcode.toString() == _disV,
//                           orElse: () => CommunityJson(),
//                         ),
//                         popupProps: PopupProps.menu(
//                           showSelectedItems: true,
//                           showSearchBox: true,
//                           itemBuilder: (context, item, isSelected) {
//                             return ListTile(
//                               title: Text(item.name ?? 'No name'),
//                             );
//                           },
//                         ),
//                         dropdownDecoratorProps: DropDownDecoratorProps(
//                           dropdownSearchDecoration: InputDecoration(
//                             filled: true,
//                             fillColor: fillColour,
//                             counterText: "",
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(5),
//                               borderSide: const BorderSide(color: primaryBlack),
//                             ),
//                             focusedErrorBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(5),
//                               borderSide: const BorderSide(color: primaryError),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(5),
//                               borderSide: const BorderSide(
//                                 color: primaryColour,
//                               ),
//                             ),
//                             disabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(5),
//                               borderSide: const BorderSide(color: primaryBlack),
//                             ),
//                             errorBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(5),
//                               borderSide: const BorderSide(color: primaryError),
//                             ),
//                             errorStyle: const TextStyle(color: primaryError),
//                             prefixIconConstraints: const BoxConstraints(
//                               minWidth: 0,
//                               minHeight: 0,
//                             ),
//                             labelStyle: const TextStyle(color: primaryBlack),
//                             hintText:
//                                 widget.pickedCommunityCode ??
//                         onChanged: (CommunityJson? value) {
//                           if (value != null) {
//                             _onCommunityChanged(value.communitycode ?? '', context);
//                             debugPrint("Search drop value ${value.name}");
//
//                             setState(() {
//                               _communityValue = value.comcode.toString();
//                               _disV = value.communitycode;
//
//                               regSP?.setString(
//                                 'communitycode',
//                                 _communityValue.toString(),
//                               );
//                               regSP?.setString('communityname', value.name ?? '');
//
//                               debugPrint(
//                                 "Community Code ${value.comcode.toString()} and ${regSP?.getString("communitycode")}",
//                               );
//                             });
//                           }
//                         },
//                         itemAsString: (CommunityJson item) => item.name ?? 'No name',
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             ),
//             IconButton(
//               onPressed: () {
//                 setState(() {
//                   _communityValues = [];
//                   // myCommunityFuture = writeToCommunityFile(this.context);
//                   myCommunityFuture = communityListHttp
//                       .getCommunityListService(context)
//                       .then((value) {
//                         return _communityValues = value
//                             .map<CommunityJson>(CommunityJson.fromJson)
//                             .toList();
//                       });
//                 });
//               },
//               icon: const Icon(Icons.refresh),
//             ),
//           ],
//         ),
//         // end of community
//       ],
//     );
//   }
// }
