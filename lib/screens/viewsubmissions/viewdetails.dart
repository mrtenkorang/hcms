// import 'dart:convert';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart' hide DatePickerTheme;
// import 'package:hcms_revived2/boilerplate/constants.dart';
// import 'package:hcms_revived2/boilerplate/widgets.dart';
// import 'package:hcms_revived2/helpers/dbhelper.dart';
// import 'package:hcms_revived2/providers/personalfarmerprovider.dart';
// import 'package:hcms_revived2/screens/home/index.dart';
// import 'package:hcms_revived2/screens/history/viewpage.dart';

// import 'package:provider/provider.dart';

// class DetailDisplay extends StatefulWidget {
//   static const routeName = '/detail_display';
//   final Function() notifyParent;

//   const DetailDisplay({Key key, this.notifyParent}) : super(key: key);

//   @override
//   _DetailDisplayState createState() => _DetailDisplayState();
// }

// class _DetailDisplayState extends State<DetailDisplay> {
//   final _formKey = GlobalKey<FormState>();
//   bool buildC = false;

//   Future<bool> reload() {
//     if (buildC == !buildC)
//       setState(() {
//         buildC = !buildC;
//       });
//   }

//   final groupName = TextEditingController();
//   final groupPresident = TextEditingController();
//   final groupSecretary = TextEditingController();
//   final groupDirectors = TextEditingController();
//   final groupPhoneNum = TextEditingController();
//   final groupEmail = TextEditingController();
//   final groupAddress = TextEditingController();

//   final farmerFirstName = TextEditingController();
//   final farmerOtherName = TextEditingController();
//   final farmerLastName = TextEditingController();
//   final farmerPhoneNum = TextEditingController();
//   final farmerGender = TextEditingController();
//   final farmerDoB = TextEditingController();
//   final farmerMail = TextEditingController();
//   final farmerAddress = TextEditingController();
//   final kinName = TextEditingController();
//   final kinRelation = TextEditingController();
//   final kinGender = TextEditingController();
//   final kinDoB = TextEditingController();
//   final kinPhoneNum = TextEditingController();
//   final kinAddress = TextEditingController();

//   final farmArea = TextEditingController();

//   final witnessName = TextEditingController();
//   final witnessPhone = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     final id = ModalRoute.of(context).settings.arguments;
//     final selectedPlace =
//         Provider.of<PersonalFarmerProvider>(context, listen: false)
//             .findById(id);

//     return Scaffold(
//       appBar: AppBar( foregroundColor: fPrimaryWhite,
//         title: Text("Report Details"),
//         actions: [
//           Tooltip(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 12.0),
//               child: InkWell(
//                 child: Icon(Icons.home,  color: fPrimaryWhite),
//                 onTap: () => Navigator.of(context).push(
//                   MaterialPageRoute(
//                     builder: (BuildContext context) => IndexPage(),
//                   ),
//                 ),
//               ),
//             ),
//             message: "Takes you back to homepage",
//           )
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: FutureBuilder(
//             future: reload(),
//             builder: (context, snapshot) {
//               return Container(
//                 height: MediaQuery.of(context).size.height,
//                 margin: EdgeInsets.all(0.0),
//                 child: ListView(children: [
//                   Form(
//                     key: _formKey,
//                     child: Column(
//                       children: [
//                         selectedPlace.beneficiaryType == "Group"
//                             ? Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Material(
//                                   elevation: 0,
//                                   child: Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 8.0, vertical: 20.0),
//                                     child: Column(
//                                       children: [
//                                         Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.center,
//                                           children: [
//                                             Expanded(
//                                               child: Text(
//                                                 "Group/ Company Details",
//                                                 style: TextStyle(
//                                                     fontWeight: FontWeight.bold,
//                                                     fontSize: 24.0),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                         BoilerTextFieldWidget(
//                                           readonly: false,
//                                           hintText: "Input text here",
//                                           labelText: "Group/ Company Name",
//                                           controller: groupName.text.isEmpty
//                                               ? TextEditingController(
//                                                   text: selectedPlace.groupName)
//                                               : groupName,
//                                           suffixIconData: Icons.edit,
//                                           validator: (value) {
//                                             setState(() {
//                                               groupName.text = value;
//                                             });
//                                           },
//                                           // onClicked: () {
//                                           //   _submissionLoading(
//                                           //     context,
//                                           //     label: "Group/ Company Name",
//                                           //     id: selectedPlace.id,
//                                           //     init: selectedPlace.groupName,
//                                           //     colVal: "groupName",
//                                           //   );
//                                           // },
//                                         ),
//                                         BoilerTextFieldWidget(
//                                           readonly: false,
//                                           hintText: "Input text here",
//                                           labelText: "Group President",
//                                           controller:
//                                               groupPresident.text.isEmpty
//                                                   ? TextEditingController(
//                                                       text: selectedPlace
//                                                           .groupPresident)
//                                                   : groupPresident,
//                                           suffixIconData: Icons.edit,
//                                           validator: (value) {
//                                             setState(() {
//                                               groupPresident.text = value;
//                                             });
//                                           },
//                                         ),
//                                         BoilerTextFieldWidget(
//                                           readonly: false,
//                                           hintText: "Input text here",
//                                           labelText: "Group Secretary",
//                                           controller:
//                                               groupSecretary.text.isEmpty
//                                                   ? TextEditingController(
//                                                       text: selectedPlace
//                                                           .groupSecretary)
//                                                   : groupSecretary,
//                                           suffixIconData: Icons.edit,
//                                           validator: (value) {
//                                             setState(() {
//                                               groupSecretary.text = value;
//                                             });
//                                           },
//                                         ),
//                                         BoilerTextFieldWidget(
//                                           readonly: false,
//                                           hintText: "Input text here",
//                                           labelText: "Company directors",
//                                           controller:
//                                               groupDirectors.text.isEmpty
//                                                   ? TextEditingController(
//                                                       text: selectedPlace
//                                                           .groupDirectors)
//                                                   : groupDirectors,
//                                           suffixIconData: Icons.edit,
//                                           validator: (value) {
//                                             setState(() {
//                                               groupDirectors.text = value;
//                                             });
//                                           },
//                                         ),
//                                         BoilerTextFieldWidget(
//                                           type: TextInputType.phone,
//                                           readonly: false,
//                                           hintText: "Input text here",
//                                           labelText: "Mobile number",
//                                           maxlength: 10,
//                                           controller: groupPhoneNum.text.isEmpty
//                                               ? TextEditingController(
//                                                   text: selectedPlace
//                                                       .groupphoneNumber)
//                                               : groupPhoneNum,
//                                           suffixIconData: Icons.edit,
//                                           validator: (value) {
//                                             setState(() {
//                                               groupPhoneNum.text = value;
//                                             });
//                                           },
//                                         ),
//                                         BoilerTextFieldWidget(
//                                           type: TextInputType.emailAddress,
//                                           readonly: false,
//                                           hintText: "Input text here",
//                                           labelText: "Email Address",
//                                           controller: groupEmail.text.isEmpty
//                                               ? TextEditingController(
//                                                   text:
//                                                       selectedPlace.groupEmail)
//                                               : groupEmail,
//                                           suffixIconData: Icons.edit,
//                                           validator: (value) {
//                                             setState(() {
//                                               groupEmail.text = value;
//                                             });
//                                           },
//                                         ),
//                                         BoilerTextFieldWidget(
//                                           readonly: false,
//                                           hintText: "Input text here",
//                                           labelText: "Postal Address",
//                                           controller: groupAddress.text.isEmpty
//                                               ? TextEditingController(
//                                                   text: selectedPlace
//                                                       .groupAddress)
//                                               : groupAddress,
//                                           suffixIconData: Icons.edit,
//                                           validator: (value) {
//                                             setState(() {
//                                               groupAddress.text = value;
//                                             });
//                                           },
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               )
//                             : Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Material(
//                                   elevation: 0,
//                                   child: Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 8.0, vertical: 20.0),
//                                     child: Column(
//                                       children: [
//                                         Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.center,
//                                           children: [
//                                             Expanded(
//                                               child: Text(
//                                                 "Farmer Details",
//                                                 style: TextStyle(
//                                                     fontWeight: FontWeight.bold,
//                                                     fontSize: 24.0),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                         Container(
//                                           width: 170,
//                                           height: 170,
//                                           child: ClipRRect(
//                                             borderRadius:
//                                                 BorderRadius.circular(30),
//                                             child: Image.memory(
//                                               base64.decode(
//                                                   selectedPlace.farmerPic64),
//                                               fit: BoxFit.fill,
//                                               colorBlendMode: BlendMode.color,
//                                             ),
//                                           ),
//                                         ),
//                                         BoilerTextFieldWidget(
//                                           readonly: false,
//                                           hintText: "Input text here",
//                                           labelText: "First Name",
//                                           controller:
//                                               farmerFirstName.text.isEmpty
//                                                   ? TextEditingController(
//                                                       text: selectedPlace
//                                                           .farmerfirstName)
//                                                   : farmerFirstName,
//                                           suffixIconData: Icons.edit,
//                                           validator: (value) {
//                                             setState(() {
//                                               farmerFirstName.text = value;
//                                             });
//                                           },
//                                         ),
//                                         BoilerTextFieldWidget(
//                                           readonly: false,
//                                           hintText: "Input text here",
//                                           labelText: "Other Names",
//                                           controller:
//                                               farmerOtherName.text.isEmpty
//                                                   ? TextEditingController(
//                                                       text: selectedPlace
//                                                           .farmerotherName)
//                                                   : farmerOtherName ?? "None",
//                                           suffixIconData: Icons.edit,
//                                           validator: (value) {
//                                             setState(() {
//                                               farmerOtherName.text = value;
//                                             });
//                                           },
//                                         ),
//                                         BoilerTextFieldWidget(
//                                           readonly: false,
//                                           hintText: "Input text here",
//                                           labelText: "Surname",
//                                           controller:
//                                               farmerLastName.text.isEmpty
//                                                   ? TextEditingController(
//                                                       text: selectedPlace
//                                                           .farmersurName)
//                                                   : farmerLastName,
//                                           suffixIconData: Icons.edit,
//                                           validator: (value) {
//                                             setState(() {
//                                               farmerLastName.text = value;
//                                             });
//                                           },
//                                         ),
//                                         BoilerTextFieldWidget(
//                                           readonly: false,
//                                           hintText: "Input text here",
//                                           labelText: "Gender",
//                                           controller: farmerGender.text.isEmpty
//                                               ? TextEditingController(
//                                                   text: selectedPlace
//                                                       .farmerGender)
//                                               : farmerGender,
//                                           suffixIconData: Icons.edit,
//                                           validator: (value) {
//                                             setState(() {
//                                               farmerGender.text = value;
//                                             });
//                                           },
//                                         ),
//                                         BoilerTextFieldWidget(
//                                           readonly: false,
//                                           maxlength: 10,
//                                           hintText: "Input text here",
//                                           labelText: "Mobile Number",
//                                           controller:
//                                               farmerPhoneNum.text.isEmpty
//                                                   ? TextEditingController(
//                                                       text: selectedPlace
//                                                           .farmerPhoneNum)
//                                                   : farmerPhoneNum,
//                                           type: TextInputType.phone,
//                                           suffixIconData: Icons.edit,
//                                           validator: (value) {
//                                             setState(() {
//                                               farmerPhoneNum.text = value;
//                                             });
//                                           },
//                                         ),
//                                         BoilerTextFieldWidget(
//                                           hintText: "Input text here",
//                                           labelText: "Date of Birth",
//                                           controller: farmerDoB.text.isEmpty
//                                               ? TextEditingController(
//                                                   text: selectedPlace.farmerDoB)
//                                               : farmerDoB,
//                                           // suffixIconData: Icons.edit,
//                                           validator: (value) {
//                                             setState(() {
//                                               farmerDoB.text = value;
//                                             });
//                                           },
//                                         ),
//                                         BoilerTextFieldWidget(
//                                           readonly: false,
//                                           hintText: "Input text here",
//                                           labelText: "Email Address",
//                                           controller: farmerMail.text.isEmpty
//                                               ? TextEditingController(
//                                                   text:
//                                                       selectedPlace.farmerMail)
//                                               : farmerMail,
//                                           suffixIconData: Icons.edit,
//                                           validator: (value) {
//                                             setState(() {
//                                               farmerMail.text = value;
//                                             });
//                                           },
//                                         ),
//                                         BoilerTextFieldWidget(
//                                           readonly: false,
//                                           hintText: "Input text here",
//                                           labelText: "Postal Address",
//                                           controller: farmerAddress.text.isEmpty
//                                               ? TextEditingController(
//                                                   text: selectedPlace
//                                                       .farmerPostal)
//                                               : farmerAddress,
//                                           suffixIconData: Icons.edit,
//                                           validator: (value) {
//                                             setState(() {
//                                               farmerAddress.text = value;
//                                             });
//                                           },
//                                         ),
//                                         Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.center,
//                                           children: [
//                                             Expanded(
//                                               child: Text(
//                                                 "Kin Details",
//                                                 style: TextStyle(
//                                                     fontWeight: FontWeight.bold,
//                                                     fontSize: 24.0),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                         BoilerTextFieldWidget(
//                                           readonly: false,
//                                           hintText: "Input text here",
//                                           labelText: "Next of kin",
//                                           controller: kinName.text.isEmpty
//                                               ? TextEditingController(
//                                                   text: selectedPlace.kinName)
//                                               : kinName,
//                                           suffixIconData: Icons.edit,
//                                           validator: (value) {
//                                             setState(() {
//                                               kinName.text = value;
//                                             });
//                                           },
//                                         ),
//                                         BoilerTextFieldWidget(
//                                           readonly: false,
//                                           hintText: "Input text here",
//                                           labelText: "Relationship",
//                                           controller: kinRelation.text.isEmpty
//                                               ? TextEditingController(
//                                                   text: selectedPlace
//                                                       .kinRelationShip)
//                                               : kinRelation,
//                                           suffixIconData: Icons.edit,
//                                           validator: (value) {
//                                             setState(() {
//                                               kinRelation.text = value;
//                                             });
//                                           },
//                                         ),
//                                         BoilerTextFieldWidget(
//                                           readonly: false,
//                                           hintText: "Input text here",
//                                           labelText: "Gender",
//                                           controller: kinGender.text.isEmpty
//                                               ? TextEditingController(
//                                                   text: selectedPlace.kinGender)
//                                               : kinGender,
//                                           suffixIconData: Icons.edit,
//                                           validator: (value) {
//                                             setState(() {
//                                               kinGender.text = value;
//                                             });
//                                           },
//                                         ),
//                                         BoilerTextFieldWidget(
//                                           hintText: "Input text here",
//                                           labelText: "Date of Birth",
//                                           controller: kinDoB.text.isEmpty
//                                               ? TextEditingController(
//                                                   text: selectedPlace.kinDoB)
//                                               : kinDoB,
//                                           // suffixIconData: Icons.edit,
//                                           validator: (value) {
//                                             setState(() {
//                                               kinDoB.text = value;
//                                             });
//                                           },
//                                         ),
//                                         BoilerTextFieldWidget(
//                                           type: TextInputType.phone,
//                                           readonly: false,
//                                           hintText: "Input text here",
//                                           maxlength: 10,
//                                           labelText: "Phone number",
//                                           controller: kinPhoneNum.text.isEmpty
//                                               ? TextEditingController(
//                                                   text:
//                                                       selectedPlace.kinPhoneNum)
//                                               : kinPhoneNum,
//                                           suffixIconData: Icons.edit,
//                                           validator: (value) {
//                                             setState(() {
//                                               kinPhoneNum.text = value;
//                                             });
//                                           },
//                                         ),
//                                         BoilerTextFieldWidget(
//                                           readonly: false,
//                                           hintText: "Input text here",
//                                           labelText: "Postal Address",
//                                           controller: kinAddress.text.isEmpty
//                                               ? TextEditingController(
//                                                   text: selectedPlace.kinPostal)
//                                               : kinAddress,
//                                           suffixIconData: Icons.edit,
//                                           validator: (value) {
//                                             setState(() {
//                                               kinAddress.text = value;
//                                             });
//                                           },
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Material(
//                             elevation: 0,
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 8.0, vertical: 20.0),
//                               child: Column(
//                                 children: [
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Expanded(
//                                         child: Text(
//                                           "Tree Farm Information",
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 24.0),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   BoilerTextFieldWidget(
//                                     hintText: selectedPlace.id,
//                                     labelText: "Region",
//                                     initialVal: selectedPlace.region,
//                                     // suffixIconData: Icons.edit,
//                                   ),
//                                   BoilerTextFieldWidget(
//                                     hintText: selectedPlace.id,
//                                     labelText: "Forest District",
//                                     initialVal: selectedPlace.forestDistrict,
//                                     // suffixIconData: Icons.edit,
//                                   ),
//                                   BoilerTextFieldWidget(
//                                     hintText: selectedPlace.id,
//                                     labelText: "TA/Stool/Skin/Family",
//                                     initialVal: selectedPlace.family,
//                                     // suffixIconData: Icons.edit,
//                                   ),
//                                   BoilerTextFieldWidget(
//                                     hintText: selectedPlace.id,
//                                     labelText: "MMDAS",
//                                     initialVal: selectedPlace.mddas,
//                                     // suffixIconData: Icons.edit,
//                                   ),
//                                   BoilerTextFieldWidget(
//                                     hintText: selectedPlace.id,
//                                     labelText: "Community",
//                                     initialVal: selectedPlace.community,
//                                     // suffixIconData: Icons.edit,
//                                   ),
//                                   BoilerTextFieldWidget(
//                                     hintText: selectedPlace.id,
//                                     labelText: "Type of Establishment",
//                                     initialVal:
//                                         selectedPlace.typeofEstablishment,
//                                     // suffixIconData: Icons.edit,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Material(
//                             elevation: 0,
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 8.0, vertical: 20.0),
//                               child: Column(
//                                 children: [
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Expanded(
//                                         child: Text(
//                                           "Plot/ Farm Information",
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 24.0),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   // BoilerTextFieldWidget(
//                                   //   type: TextInputType.number,
//                                   //   readonly: false,
//                                   //   hintText: "Input text here",
//                                   //   labelText: "Tree Farm Area (Plot) (Ha)",
//                                   //   controller: farmArea.text.isEmpty
//                                   //       ? TextEditingController(
//                                   //           text: selectedPlace.farmArea)
//                                   //       : farmArea,
//                                   //   suffixIconData: Icons.edit,
//                                   //   validator: (value) {
//                                   //     setState(() {
//                                   //       farmArea.text = value;
//                                   //     });
//                                   //   },
//                                   // ),
//                                   BoilerTextFieldWidget(
//                                     hintText: selectedPlace.id,
//                                     labelText: "Farm Cordinate",

//                                     controller: TextEditingController(
//                                         text: selectedPlace.pointsGet),
//                                     // suffixIconData: Icons.edit,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Material(
//                             elevation: 0,
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 8.0, vertical: 20.0),
//                               child: Column(
//                                 children: [
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Expanded(
//                                         child: Text(
//                                           "Tree Information on Planted Species",
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 24.0),
//                                           softWrap: true,
//                                           overflow: TextOverflow.clip,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   BoilerTextFieldWidget(
//                                     hintText: selectedPlace.id,
//                                     labelText: "C2",
//                                     initialVal:
//                                         selectedPlace.c2treePlantationDetail,
//                                     // suffixIconData: Icons.edit,
//                                   ),
//                                   BoilerTextFieldWidget(
//                                     hintText: selectedPlace.id,
//                                     labelText: "C3",
//                                     initialVal:
//                                         selectedPlace.c3treePlantationDetail,
//                                     // suffixIconData: Icons.edit,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Material(
//                             elevation: 0,
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 8.0, vertical: 20.0),
//                               child: Column(
//                                 children: [
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Expanded(
//                                         child: Text(
//                                           "Declaration",
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 24.0),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   BoilerTextFieldWidget(
//                                     hintText: selectedPlace.id,
//                                     labelText: "Date",
//                                     initialVal: selectedPlace.timeDisplay,
//                                     // suffixIconData: Icons.edit,
//                                   ),
//                                   BoilerTextFieldWidget(
//                                     readonly: false,
//                                     hintText: "Input text here",
//                                     labelText: "Witness Name",
//                                     controller: witnessName.text.isEmpty
//                                         ? TextEditingController(
//                                             text: selectedPlace.witnessName)
//                                         : witnessName,
//                                     suffixIconData: Icons.edit,
//                                     validator: (value) {
//                                       setState(() {
//                                         witnessName.text = value;
//                                       });
//                                     },
//                                   ),
//                                   BoilerTextFieldWidget(
//                                     type: TextInputType.phone,
//                                     readonly: false,
//                                     hintText: "Input text here",
//                                     labelText: "Witness Contact",
//                                     maxlength: 10,
//                                     controller: witnessPhone.text.isEmpty
//                                         ? TextEditingController(
//                                             text: selectedPlace.witnessPhone)
//                                         : witnessPhone,
//                                     suffixIconData: Icons.edit,
//                                     validator: (value) {
//                                       setState(() {
//                                         witnessPhone.text = value;
//                                       });
//                                     },
//                                   ),
//                                   Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Expanded(
//                                         child: Container(
//                                           width: 90,
//                                           height: 90,
//                                           decoration: BoxDecoration(
//                                             border: Border.all(
//                                               color: Color(0xFFfc1d20),
//                                             ),
//                                           ),
//                                           child: ClipRRect(
//                                             borderRadius:
//                                                 BorderRadius.circular(30),
//                                             child: Image.memory(
//                                               base64.decode(selectedPlace
//                                                   .farmerdeclarationSig),
//                                               fit: BoxFit.contain,
//                                               colorBlendMode: BlendMode.color,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         width: 30.0,
//                                       ),
//                                       Expanded(
//                                         child: Container(
//                                           width: 90,
//                                           height: 90,
//                                           decoration: BoxDecoration(
//                                             border: Border.all(
//                                               color: Color(0xFFfc1d20),
//                                             ),
//                                           ),
//                                           child: ClipRRect(
//                                             borderRadius:
//                                                 BorderRadius.circular(30),
//                                             child: Image.memory(
//                                               base64.decode(selectedPlace
//                                                   .witnessdeclarationSig),
//                                               fit: BoxFit.contain,
//                                               colorBlendMode: BlendMode.color,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Expanded(
//                                         child: Padding(
//                                           padding: const EdgeInsets.only(
//                                             left: 8.0,
//                                             right: 8.0,
//                                             top: 18.0,
//                                           ),
//                                           child: Container(
//                                             width: 90,
//                                             height: 90,
//                                             child: Text(
//                                               "Farmer Signature",
//                                               style: TextStyle(
//                                                   fontWeight: FontWeight.bold),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         width: 30.0,
//                                       ),
//                                       Expanded(
//                                         child: Padding(
//                                           padding: const EdgeInsets.only(
//                                             left: 8.0,
//                                             right: 8.0,
//                                             top: 18.0,
//                                           ),
//                                           child: Container(
//                                             width: 90,
//                                             height: 90,
//                                             child: Text(
//                                               "Witness Signature",
//                                               style: TextStyle(
//                                                   fontWeight: FontWeight.bold),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   selectedPlace.conStat == "not connected"
//                                       ? Container(
//                                           child: selectedPlace
//                                                       .beneficiaryType ==
//                                                   "Group"
//                                               ? RaisedButton(
//                                                   elevation: 0,
//                                                   shape: RoundedRectangleBorder(
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             10.0),
//                                                   ),
//                                                   child: Text(
//                                                     "Save Changes",
//                                                     style: TextStyle(
//                                                         fontSize: 17.0,
//                                                         fontWeight:
//                                                             FontWeight.normal),
//                                                   ),
//                                                   color: fPrimaryColour,
//                                                   textColor: Colors.white,
//                                                   onPressed: () async {
//                                                     if (_formKey.currentState
//                                                         .validate()) {
//                                                       DBHelper.updateGroupBeforeSend(
//                                                               groupName.text,
//                                                               groupPresident
//                                                                   .text,
//                                                               groupSecretary
//                                                                   .text,
//                                                               groupDirectors
//                                                                   .text,
//                                                               groupPhoneNum
//                                                                   .text,
//                                                               groupEmail.text,
//                                                               groupAddress.text,
//                                                               farmArea.text,
//                                                               witnessName.text,
//                                                               witnessPhone.text,
//                                                               selectedPlace.id)
//                                                           .then(
//                                                         (value) => Navigator.of(
//                                                                 context)
//                                                             .pushReplacement(
//                                                           CupertinoPageRoute(
//                                                             builder: (context) =>
//                                                                 ViewReport(),
//                                                           ),
//                                                         ),
//                                                       );
//                                                     }
//                                                     // setState(() {
//                                                     //   buildC = !buildC;
//                                                     //   widget.notifyParent();
//                                                     // });
//                                                   },
//                                                 )
//                                               : RaisedButton(
//                                                   elevation: 0,
//                                                   shape: RoundedRectangleBorder(
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             10.0),
//                                                   ),
//                                                   child: Text(
//                                                     "Save Changes",
//                                                     style: TextStyle(
//                                                         fontSize: 17.0,
//                                                         fontWeight:
//                                                             FontWeight.normal),
//                                                   ),
//                                                   color: fPrimaryColour,
//                                                   textColor: Colors.white,
//                                                   onPressed: () async {
//                                                     if (_formKey.currentState
//                                                         .validate()) {
//                                                       DBHelper.updateIndBeforeSend(
//                                                               farmerFirstName
//                                                                   .text,
//                                                               farmerOtherName
//                                                                   .text,
//                                                               farmerLastName
//                                                                   .text,
//                                                               farmerPhoneNum
//                                                                   .text,
//                                                               farmerGender.text,
//                                                               farmerMail.text,
//                                                               farmerAddress
//                                                                   .text,
//                                                               kinName.text,
//                                                               kinRelation.text,
//                                                               kinGender.text,
//                                                               kinPhoneNum.text,
//                                                               kinAddress.text,
//                                                               farmArea.text,
//                                                               witnessName.text,
//                                                               witnessPhone.text,
//                                                               selectedPlace.id)
//                                                           .then(
//                                                         (value) => Navigator.of(
//                                                                 context)
//                                                             .pushReplacement(
//                                                           CupertinoPageRoute(
//                                                             builder: (context) =>
//                                                                 ViewReport(),
//                                                           ),
//                                                         ),
//                                                       );
//                                                     }
//                                                   },
//                                                 ),
//                                         )
//                                       : Container(),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                         SizedBox(
//                           height: 100,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ]),
//               );
//             }),
//       ),
//     );
//   }
// }
