import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/boilerplate/widgets.dart';
import 'package:hcms_revived2/helpers/dbhelper.dart';
import 'package:hcms_revived2/providers/personalfarmerprovideroffline.dart';
import 'package:hcms_revived2/screens/farmregistration/farmdetails/farmdetails.dart';
import 'package:hcms_revived2/screens/farmregistration/farmerdetails/components/groupdetails.dart';
import 'package:hcms_revived2/screens/farmregistration/farmerdetails/components/personalDetails.dart';
import 'package:hcms_revived2/services/serverurls.dart';
import 'package:hcms_revived2/utils/constants/colours.dart';
import 'package:hcms_revived2/utils/widgets/buttons/custombuttons.dart';
import 'package:hcms_revived2/utils/widgets/textFields/generic_text_field.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../../../main.dart';

class TreeFarmerSearchandType extends StatefulWidget {
  const TreeFarmerSearchandType({Key? key}) : super(key: key);

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

  @override
  void initState() {
    super.initState();
    selectedFarmerType = regSP?.getString("_beneficiaryType") ?? "Individual";
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    _farmerContact.dispose();
    super.dispose();
  }

  // Existing data fetching methods remain the same...
  Future<dynamic> getIndiviFarmerFromFarmerOfflineLocalDB(farmercontact) async {
    print("traversing offline tree farmer instead");
    final db = await DBHelper.database();
    var count = await db.query("tree_farmer_offline",
        where: "tfoFarmerPhoneNum = ?",
        whereArgs: [farmercontact]).then((value) {
      if (value.isEmpty) {
        Navigator.pop(context);
        overlayNotification(
            'Account not found. Select other tab and search again.',
            "negative");
      } else {
        Navigator.pop(context);
        setState(() {
          retfamerProfilePic = "seen";
          retfarmerfirstName = value[0]["tfaFarmerfirstName"].toString();
          retfarmersurName = value[0]["tfaFarmersurName"].toString();
          retfarmerotherName = value[0]["tfaFarmerotherName"].toString();
          retfarmerGender = value[0]["tfaFarmerGender"].toString();
          retfarmerDoB = value[0]["tfaFarmerDoB"].toString();
          retfarmerPostal = value[0]["tfaFarmerPostal"].toString();
          retfarmerPhoneNum = value[0]["tfaFarmerPhoneNum"].toString();
          retfarmerMail = value[0]["tfaFarmerMail"].toString();
          retkinName = value[0]["tfaKinName"].toString();
          retkinPhoneNum = value[0]["tfaKinPhoneNum"].toString();
          retkinGender = value[0]["tfaKinGender"].toString();
          retkinPostal = value[0]["tfaKinPostal"].toString();
          retkinDoB = value[0]["tfaKinDoB"].toString();
          retkinRelationship = value[0]["tfaKinRelationShip"].toString();
        });
        overlayNotification('Record found', "positive");
      }
    });
    return count;
  }

  Future<dynamic> getGroupFarmerFromFarmerOfflineLocalDB(farmercontact) async {
    print("traversing offline tree farmer instead");
    final db = await DBHelper.database();
    var count = await db.query("tree_farmer_offline",
        where: "tfoGroupphoneNumber = ?",
        whereArgs: [farmercontact]).then((value) {
      if (value.isEmpty) {
        Navigator.pop(context);
        overlayNotification(
            'Account not found. Select other tab and search again.',
            "negative");
      } else {
        Navigator.pop(context);
        setState(() {
          retcompanyDirectors = value[0]["tfoGroupDirectors"].toString();
          retgroupName = value[0]["tfoGroupName"].toString();
          retgroupPresident = value[0]["tfoGroupPresident"].toString();
          retgroupSecretary = value[0]["tfoGroupSecretary"].toString();
          retgroupPhone = value[0]["tfoGroupphoneNumber"].toString();
          retgroupregNumb = value[0]["tfoGroupphoneNumber"].toString();
          retgroupEmail = value[0]["tfoGroupEmail"].toString();
          retgroupAddress = value[0]["tfoGroupAddress"].toString();
        });
        overlayNotification('Record found', "positive");
      }
    });
    return count;
  }

  Future<dynamic> getIndiviFarmerFromFarmerApiListLocalDB(farmercontact) async {
    print("traversing local tree farmer api list");
    final db = await DBHelper.database();
    var count = await db.query("tree_farmer_api_list",
        where: selectedFarmerType == "Individual"
            ? "tfaFarmerPhoneNum = ?"
            : "tfaGroupphoneNumber = ?",
        whereArgs: [farmercontact]).then((value) {
      if (value.isEmpty) {
        print("doing tree farmer offline check $selectedFarmerType");
        selectedFarmerType == "Individual"
            ? getIndiviFarmerFromFarmerOfflineLocalDB(farmercontact)
            : getGroupFarmerFromFarmerOfflineLocalDB(farmercontact);
      } else {
        print("It isn't empty $value");
        Navigator.pop(context);
        selectedFarmerType == "Individual"
            ? setState(() {
          retfamerProfilePic = "seen";
          retfarmerfirstName = value[0]["tfaFarmerfirstName"].toString();
          retfarmersurName = value[0]["tfaFarmersurName"].toString();
          retfarmerotherName = value[0]["tfaFarmerotherName"].toString();
          retfarmerGender = value[0]["tfaFarmerGender"].toString();
          retfarmerDoB = value[0]["tfaFarmerDoB"].toString();
          retfarmerPostal = value[0]["tfaFarmerPostal"].toString();
          retfarmerPhoneNum = value[0]["tfaFarmerPhoneNum"].toString();
          retfarmerMail = value[0]["tfaFarmerMail"].toString();
          retkinName = value[0]["tfaKinName"].toString();
          retkinPhoneNum = value[0]["tfaKinPhoneNum"].toString();
          retkinGender = value[0]["tfaKinGender"].toString();
          retkinPostal = value[0]["tfaKinPostal"].toString();
          retkinDoB = value[0]["tfaKinDoB"].toString();
          retkinRelationship = value[0]["tfaKinRelationShip"].toString();
        })
            : setState(() {
          retcompanyDirectors = value[0]["tfaGroupDirectors"].toString();
          retgroupName = value[0]["tfaGroupName"].toString();
          retgroupPresident = value[0]["tfaGroupPresident"].toString();
          retgroupSecretary = value[0]["tfaGroupSecretary"].toString();
          retgroupPhone = value[0]["tfaGroupphoneNumber"].toString();
          retgroupregNumb = value[0]["tfaGroupphoneNumber"].toString();
          retgroupEmail = value[0]["tfaGroupEmail"].toString();
          retgroupAddress = value[0]["tfaGroupAddress"].toString();
        });
        overlayNotification('Farmer details found.', "positive");
      }
    });
    return count;
  }

  Future _asyncSearchFarmerOnline(BuildContext ctx) async {
    setState(() {
      _isSearching = true;
    });

    submissionLoader(ctx, "Retrieving account", "Please wait a minute...");

    try {
      final response = await http.get(Uri.parse(
          "$stageBaseUrl/searchtreeregisterfarmer/?contact=${_farmerContact.text}"));

      final items = json.decode(response.body);
      final newVibe = items["farmerid"];
      final newBene = items["type_beneficiary"];

      if (newVibe != null) {
        Navigator.of(context).pop();
        regSP?.setString("farmerId", items["farmerid"]).then(
              (value) => newBene == "Individual"
              ? setState(() {
            selectedFarmerType = "Individual";
            regSP?.setString('_beneficiaryType', selectedFarmerType);
            retfamerProfilePic = "seen";
            retfarmerfirstName = items["indvi_first_name"];
            retfarmersurName = items["indvi_surname"];
            retfarmerotherName = items["indvi_other_names"];
            retfarmerGender = items["indvi_gender"];
            retfarmerDoB = items["indvi_dob"];
            retfarmerPostal = items["indvi_address"];
            retfarmerPhoneNum = items["indvi_phone_no"];
            retfarmerMail = items["indvi_email"];
            retkinName = items["indvi_next_of_kin"];
            retkinPhoneNum = items["indvi_next_of_kin_phone_no"];
            retkinGender = items["indvi_next_of_kin_gender"];
            retkinPostal = items["indvi_next_of_kin_address"];
            retkinDoB = items["indvi_next_of_kin_dob"];
            retkinRelationship = items["indvi_relationship"];
          })
              : setState(() {
            selectedFarmerType = "Group";
            regSP?.setString('_beneficiaryType', selectedFarmerType);
            retcompanyDirectors = items["group_directors"];
            retgroupName = items["group_name"];
            retgroupPresident = items["group_president"];
            retgroupSecretary = items["group_secretary"];
            retgroupPhone = items["group_phone"];
            retgroupregNumb = items["group_phone"];
            retgroupEmail = items["group_email"];
            retgroupAddress = items["group_company_add"];
          }),
        );
        overlayNotification('Record found.', "positive");
      } else {
        getIndiviFarmerFromFarmerApiListLocalDB(_farmerContact.text);
      }
    } on SocketException {
      overlayNotification(
          'No internet connection. Searching local database...', "negative");
      getIndiviFarmerFromFarmerApiListLocalDB(_farmerContact.text);
    } finally {
      setState(() {
        _isSearching = false;
      });
    }
  }

  void _toggleSearchBar() {
    setState(() {
      _showSearchBar = !_showSearchBar;
      if (_showSearchBar) {
        Future.delayed(const Duration(milliseconds: 300), () {
          _searchFocusNode.requestFocus();
        });
      } else {
        _farmerContact.clear();
      }
    });
  }

  Widget _buildSearchBar() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _showSearchBar ? 80 : 0,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: _showSearchBar
          ? Form(
        key: _formKey,
        child: Column(
          children: [
            TextFieldWidget(
              controller: _farmerContact,
              decoration: InputDecoration(
                labelText: "Enter Phone Number",
                prefixIcon: Icon(Icons.search, color: fPrimaryColour),
                suffixIcon: IconButton(
                  icon: Icon(Icons.close, color: Colors.grey),
                  onPressed: _toggleSearchBar,
                ),
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
          onTap: () {
            setState(() {
              selectedFarmerType = type;
              regSP?.setString('_beneficiaryType', type);
            });
          },
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
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        children: [
          if (_showSearchBar && _farmerContact.text.isNotEmpty)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSearching
                    ? null
                    : () {
                  if (_formKey.currentState!.validate()) {
                    _asyncSearchFarmerOnline(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: fPrimaryColour,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 0,
                ),
                child: _isSearching
                    ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                    : const Text(
                  "Search Farmer",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => FarmDetails()),
                );
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                side: BorderSide(color: fPrimaryColour),
              ),
              child: Text(
                "Continue to Farm Details",
                style: TextStyle(
                  color: fPrimaryColour,
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
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
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
                      "Farmer Registration",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: _toggleSearchBar,
                      icon: Icon(
                        _showSearchBar ? Icons.close : Icons.search,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  "Select farmer type and search for existing records",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          // Search Bar
          _buildSearchBar(),

          // Content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      "Select Farmer Type",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      "Choose the type of farmer you want to register",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Farmer Type Cards
                  _buildFarmerTypeCard(
                    "Individual",
                    "Single person farmer with personal details",
                    Icons.person_outline,
                  ),
                  _buildFarmerTypeCard(
                    "Group",
                    "Company or group of farmers with shared details",
                    Icons.group_outlined,
                  ),

                  const SizedBox(height: 30),

                  // Selected Farmer Details Preview
                  if ((selectedFarmerType == "Individual" && retfarmerfirstName != null) ||
                      (selectedFarmerType == "Group" && retgroupName != null))
                    _buildFarmerDetailsPreview(),

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
          if (selectedFarmerType == "Individual" && retfarmerfirstName != null)
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
            )
          else if (selectedFarmerType == "Group" && retgroupName != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  retgroupName!,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Phone: $retgroupPhone",
                  style: TextStyle(color: Colors.grey[700]),
                ),
                if (retgroupPresident != null && retgroupPresident!.isNotEmpty)
                  Text(
                    "President: $retgroupPresident",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
              ],
            ),
        ],
      ),
    );
  }

  Widget farmerTypeView(String selectedView) {
    switch (selectedView) {
      case "Individual":
        return PersonalDetails(
          retfamerProfilePic: retfamerProfilePic ?? "",
          retfarmerfirstName: retfarmerfirstName ?? "",
          retfarmersurName: retfarmersurName ?? "",
          retfarmerotherName: retfarmerotherName ?? "",
          retfarmerGender: retfarmerGender ?? "",
          retfarmerDoB: retfarmerDoB ?? "",
          retfarmerPostal: retfarmerPostal ?? "",
          retfarmerPhoneNum: retfarmerPhoneNum ?? "",
          retfarmerMail: retfarmerMail ?? "",
          retkinName: retkinName ?? "",
          retkinPhoneNum: retkinPhoneNum ?? "",
          retkinGender: retkinGender ?? "",
          retkinPostal: retkinPostal ?? "",
          retkinDoB: retkinDoB ?? "",
          retkinRelationship: retkinRelationship ?? "",
        );
      case "Group":
        return GroupDetails(
          retcompanyDirectors: retcompanyDirectors ?? "",
          retgroupName: retgroupName ?? "",
          retgroupPresident: retgroupPresident ?? "",
          retgroupSecretary: retgroupSecretary ?? "",
          retgroupPhone: retgroupPhone ?? "",
          retgroupregNumb: retgroupregNumb ?? "",
          retgroupEmail: retgroupEmail ?? "",
          retgroupAddress: retgroupAddress ?? "",
        );
      default:
        return const SizedBox();
    }
  }
}