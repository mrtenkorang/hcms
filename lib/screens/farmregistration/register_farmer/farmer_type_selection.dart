import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/boilerplate/widgets.dart';
import 'package:hcms_revived2/helpers/dbhelper.dart';
import 'package:hcms_revived2/screens/farmregistration/tree_registration/tree_registration_screen.dart';
import 'package:hcms_revived2/services/serverurls.dart';
import 'package:hcms_revived2/utils/constants/colours.dart';
import 'package:hcms_revived2/utils/widgets/buttons/custombuttons.dart';
import 'package:hcms_revived2/utils/widgets/textFields/generic_text_field.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../../main.dart';

class TreeFarmerSearchandType extends StatefulWidget {
  const TreeFarmerSearchandType({Key? key, this.isEdit = false}) : super(key: key);

  final bool isEdit;

  @override
  _TreeFarmerSearchandTypeState createState() => _TreeFarmerSearchandTypeState();
}

class _TreeFarmerSearchandTypeState extends State<TreeFarmerSearchandType> {
  final _formKey = GlobalKey<FormState>();
  final _farmerContact = TextEditingController();
  final _searchFocusNode = FocusNode();

  // State variables for farmer data
  String? retfamerProfilePic;
  String? retfarmerfirstName;
  String? retfarmersurName;
  String? retfarmerotherName;
  String? retfarmerGender;
  String? retfarmerDoB;
  String? retfarmerPostal;
  String? retfarmerPhoneNum;
  String? retfarmerMail;
  String? retkinName;
  String? retkinPhoneNum;
  String? retkinGender;
  String? retkinPostal;
  String? retkinDoB;
  String? retkinRelationship;

  String? retcompanyDirectors;
  String? retgroupName;
  String? retgroupPresident;
  String? retgroupSecretary;
  String? retgroupPhone;
  String? retgroupregNumb;
  String? retgroupEmail;
  String? retgroupAddress;

  String selectedFarmerType = "Individual";
  bool _isSearching = false;
  bool _showSearchBar = false;
  bool _searchSuccessful = false;

  @override
  void initState() {
    super.initState();
    selectedFarmerType = regSP?.getString("_beneficiaryType") ?? "Individual";
    // For Individual type, show search bar by default
    _showSearchBar = selectedFarmerType == "Individual";
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    _farmerContact.dispose();
    super.dispose();
  }

  void _handleFarmerTypeChange(String type) {
    setState(() {
      selectedFarmerType = type;
      regSP?.setString('_beneficiaryType', type);

      // Reset search state when switching types
      _searchSuccessful = false;
      _farmerContact.clear();

      // Show search bar only for Individual type
      _showSearchBar = type == "Individual";
    });
  }

  Widget _buildSearchBar() {
    // Only show search bar for Individual farmer type
    if (selectedFarmerType != "Individual") {
      return const SizedBox();
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      // height: _showSearchBar ? 80 : 0,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: _showSearchBar
          ? Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Enter Farmer ID, Phone Number or Name"),
            TextFieldWidget(
              controller: _farmerContact,
              // focusNode: _searchFocusNode,
              decoration: InputDecoration(
                // labelText: "Enter Phone Number",
                // hintText: "Enter Phone Number",
                prefixIcon: Icon(Icons.search, color: fPrimaryColour),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: fPrimaryColour, width: 2),
                ),
              ),
              validator: (input) {
                if (input!.trim().isEmpty) {
                  return 'Please enter a phone number';
                }
                return null;
              },
            ),
          ],
        ),
      )
          : const SizedBox(),
    );
  }

  Widget _buildFarmerTypeCard(String type, String description, IconData icon) {
    final isSelected = selectedFarmerType == type;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? fPrimaryColour : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isSelected ? fPrimaryColour : Colors.grey[300]!,
          width: 2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _handleFarmerTypeChange(type),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : fPrimaryColour.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: isSelected ? fPrimaryColour : Colors.grey[700],
                    size: 30,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        type,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 14,
                          color: isSelected ? Colors.white.withOpacity(0.9) : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    color: Colors.white,
                    size: 24,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton() {
    // For Individual: Only enable continue if search was successful
    // For Group: Always enable continue
    final canContinue = selectedFarmerType == "Group" ||
        (selectedFarmerType == "Individual"
            // && _searchSuccessful
        );

    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Show search button only for Individual type when search bar is visible
          // if (_showSearchBar && selectedFarmerType == "Individual")
          //   SizedBox(
          //     width: double.infinity,
          //     child: ElevatedButton(
          //       onPressed: _isSearching
          //           ? null
          //           : () {
          //         if (_formKey.currentState!.validate()) {
          //           _asyncSearchFarmerOnline(context);
          //         }
          //       },
          //       style: ElevatedButton.styleFrom(
          //         backgroundColor: fPrimaryColour,
          //         padding: const EdgeInsets.symmetric(vertical: 16),
          //         shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(15),
          //         ),
          //         elevation: 0,
          //       ),
          //       child: _isSearching
          //           ? SizedBox(
          //         width: 20,
          //         height: 20,
          //         child: CircularProgressIndicator(
          //           strokeWidth: 2,
          //           valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          //         ),
          //       )
          //           : const Text(
          //         "Search Farmer",
          //         style: TextStyle(
          //           color: Colors.white,
          //           fontSize: 16,
          //           fontWeight: FontWeight.w600,
          //         ),
          //       ),
          //     ),
          //   ),
          // if (_showSearchBar && selectedFarmerType == "Individual")
          //   const SizedBox(height: 10),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: canContinue
                  ? () {
                if (selectedFarmerType == "Individual") {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => TreeRegistrationScreen(
                      isIndividual: true,
                    )),
                  );
                } else {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => TreeRegistrationScreen(
                      isIndividual: false,
                    )),
                  );
                }
              }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: canContinue ? fPrimaryColour : Colors.grey[400],
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 0,
              ),
              child: Text(
                "Continue",
                style: TextStyle(
                  color: canContinue ? Colors.white : Colors.grey[600],
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 60,
              bottom: 20,
              left: 20,
              right: 20,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  fPrimaryColour,
                  fPrimaryColour.withOpacity(0.8),
                ],
              ),
              // borderRadius: const BorderRadius.only(
              //   bottomLeft: Radius.circular(30),
              //   bottomRight: Radius.circular(30),
              // ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const Text(
                      "Farmer Type",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                   ],
                ),
                const SizedBox(height: 10),
                Text(
                  selectedFarmerType == "Individual"
                      ? "Register trees for individual farmer"
                      : "Register trees for group farmers",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          // Search Bar (only for Individual type)
          // _buildSearchBar(),

          // Content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // const SizedBox(height: 20),
                  // const Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: 24),
                  //   child: Text(
                  //     "Select Farmer Type",
                  //     style: TextStyle(
                  //       fontSize: 18,
                  //       fontWeight: FontWeight.bold,
                  //       color: Colors.black87,
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(height: 8),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 24),
                  //   child: Text(
                  //     selectedFarmerType == "Individual"
                  //         ? "Search for existing individual farmer or register new"
                  //         : "Register a new group farmer company",
                  //     style: TextStyle(
                  //       fontSize: 14,
                  //       color: Colors.grey[600],
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(height: 20),

                  // Farmer Type Cards
                  _buildFarmerTypeCard(
                    "Individual",
                    "Register trees for individual",
                    Icons.person_outline,
                  ),
                  _buildFarmerTypeCard(
                    "Group",
                    "Register trees for group",
                    Icons.group_outlined,
                  ),

                  const SizedBox(height: 30),

                  // Selected Farmer Details Preview (only for Individual after successful search)
                  if (selectedFarmerType == "Individual" && _searchSuccessful && retfarmerfirstName != null)
                    _buildFarmerDetailsPreview(),

                  // Info message for Group type
                  // if (selectedFarmerType == "Group")
                  //   _buildGroupInfoMessage(),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Action Buttons
          _buildActionButton(),
        ],
      ),
    );
  }

  Widget _buildFarmerDetailsPreview() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.green[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green[700], size: 20),
              const SizedBox(width: 8),
              Text(
                "Farmer Found",
                style: TextStyle(
                  color: Colors.green[700],
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$retfarmerfirstName $retfarmersurName",
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Phone: $retfarmerPhoneNum",
                style: TextStyle(color: Colors.grey[700]),
              ),
              if (retfarmerMail != null && retfarmerMail!.isNotEmpty)
                Text(
                  "Email: $retfarmerMail",
                  style: TextStyle(color: Colors.grey[700]),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGroupInfoMessage() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
              const SizedBox(width: 8),
              Text(
                "Group Registration",
                style: TextStyle(
                  color: Colors.blue[700],
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "You can continue to register a new group farmer. All group details will be collected in the next step.",
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // Widget farmerTypeView(String selectedView) {
  //   switch (selectedView) {
  //     case "Individual":
  //       return PersonalDetails(
  //         retfamerProfilePic: retfamerProfilePic ?? "",
  //         retfarmerfirstName: retfarmerfirstName ?? "",
  //         retfarmersurName: retfarmersurName ?? "",
  //         retfarmerotherName: retfarmerotherName ?? "",
  //         retfarmerGender: retfarmerGender ?? "",
  //         retfarmerDoB: retfarmerDoB ?? "",
  //         retfarmerPostal: retfarmerPostal ?? "",
  //         retfarmerPhoneNum: retfarmerPhoneNum ?? "",
  //         retfarmerMail: retfarmerMail ?? "",
  //         retkinName: retkinName ?? "",
  //         retkinPhoneNum: retkinPhoneNum ?? "",
  //         retkinGender: retkinGender ?? "",
  //         retkinPostal: retkinPostal ?? "",
  //         retkinDoB: retkinDoB ?? "",
  //         retkinRelationship: retkinRelationship ?? "",
  //       );
  //     case "Group":
  //       return GroupDetails(
  //         retcompanyDirectors: retcompanyDirectors ?? "",
  //         retgroupName: retgroupName ?? "",
  //         retgroupPresident: retgroupPresident ?? "",
  //         retgroupSecretary: retgroupSecretary ?? "",
  //         retgroupPhone: retgroupPhone ?? "",
  //         retgroupregNumb: retgroupregNumb ?? "",
  //         retgroupEmail: retgroupEmail ?? "",
  //         retgroupAddress: retgroupAddress ?? "",
  //       );
  //     default:
  //       return const SizedBox();
  //   }
  // }
}