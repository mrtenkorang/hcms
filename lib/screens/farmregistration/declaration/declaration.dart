import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart' hide DatePickerTheme;
// import 'package:flutter_spinkit/flutter_spinkit.dart' as spinkit;
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/boilerplate/widgets.dart';
import 'package:hcms_revived2/helpers/dbhelper.dart';
import 'package:hcms_revived2/models/senddata/components/treefarminformationcomponents/farminformationarraydetails.dart';
import 'package:hcms_revived2/providers/personalfarmerprovider.dart';
import 'package:hcms_revived2/providers/personalfarmerprovideroffline.dart';
import 'package:hcms_revived2/screens/farmregistration/declaration/components/signatureoptions.dart';
import 'package:hcms_revived2/screens/home/index.dart';
import 'package:hcms_revived2/services/http/updatetreefarmerlist.dart';
import 'package:hcms_revived2/services/serverurls.dart';
import 'package:hcms_revived2/utils/constants/colours.dart';
import 'package:hcms_revived2/utils/widgets/textFields/generic_text_field.dart';
import 'package:hcms_revived2/utils/widgets/textFormats/text_formats.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../../main.dart';
import 'components/witsignatureoptions.dart';

class Declaration extends StatefulWidget {
  final List? list;

  const Declaration({Key? key, this.list}) : super(key: key);
  @override
  _DeclarationState createState() => _DeclarationState();
}

class _DeclarationState extends State<Declaration>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  int? enumeratorvalue;

  Future<dynamic> getEnumeratorValue(String? table) async {
    final db = await DBHelper.database();
    var count =
        await db.rawQuery('SELECT enumeratorValue FROM first_time_user');

    var list = count.toList();

    setState(() {
      enumeratorvalue = int.parse(list[0]['enumeratorValue'].toString());
    });
    print("Enummem - $enumeratorvalue");
  }

  final _witnessName = TextEditingController();
  final _witnessPhone = TextEditingController();
  bool errorMessage = false;

// skipped confirmation
  bool _hasfarmerSkipped = false;
  bool _hasfarmcordSkipped = false;
  bool _hasfarmdetSkipped = false;
  bool _hascskippped = false;

//beneficiary Type
  String? _beneficiaryType;

//farmer Details
  String? _farmerId;
  String? _farmerfirstName;
  String? _farmerotherName;
  String? _farmersurName;
  String? _farmerGender;
  String? _farmerPhoneNum;
  String? _farmerDoB;
  String? _farmerMail;
  String? _farmerPostal;
  String? _kinName;
  String? _kinRelationShip;
  String? _kinDoB;
  String? _kinGender;
  String? _kinPhoneNum;
  String? _kinPostal;
  String? _farmerPic64;

  String? _companyDirectors;
  String? _groupName;
  String? _groupPresident;
  String? _groupSecretary;
  String? _groupPhone;
  // String? _groupregNumb;
  String? _groupEmail;
  String? _groupAddress;

  //farm Details
  String? _region;
  String? _forestDistrict;
  int? _mddas;
  String? _mddasName;
  String? _community;
  String? _family;
  List _toEstablishment = [];

  //farm Cordinates
  String? _farmID;
  String? _farmArea;
  String? _pointsGet;
  List<FarmInformationArray> decodedfarmInfoArray = [];
  List<FarmInformationArray> addedfarmInfoArray = [];
  var _decodedPoints;

  //tree Plantation Detail
  String? _c2treePlantationDetail;
  String? _c3treePlantationDetail;
  var _decodedTree;

  // declaration Signatures - one more should be added
  String? _declarationSig;
  String? _witnessDeclarationSig;

  void hasSkipped() async {
    _hasfarmerSkipped = (regSP?.getBool("farmerskipped") ?? false);
    _hasfarmcordSkipped = (regSP?.getBool("farmcordskipped") ?? false);
    _hasfarmdetSkipped = (regSP?.getBool("farmdetskipped") ?? false);
    _hascskippped = (regSP?.getBool("cskipped") ?? false);
  }

  void getSPValues() async {
//beneficiary Type
    _beneficiaryType = (regSP?.getString("_beneficiaryType") ?? "");

//farmer Details
    _farmerId = (regSP?.getString('farmerId') ?? "");
    _farmerfirstName = (regSP?.getString('farmerfirstName') ?? "");
    _farmerotherName = (regSP?.getString('farmerotherName') ?? "");
    _farmersurName = (regSP?.getString('farmersurName') ?? "");
    _farmerGender = (regSP?.getString('farmerGender') ?? "");
    _farmerPhoneNum = (regSP?.getString('farmerPhoneNum') ?? "");
    _farmerDoB = (regSP?.getString('farmerDoB') ?? "");
    _farmerMail = (regSP?.getString('farmerMail') ?? "");
    _farmerPostal = (regSP?.getString('farmerPostal') ?? "");
    _kinName = (regSP?.getString('kinName') ?? "");
    _kinRelationShip = (regSP?.getString("kinRelationship") ?? "");
    _kinDoB = (regSP?.getString('kinDoB') ?? "");
    _kinGender = (regSP?.getString('kinGender') ?? "");
    _kinPhoneNum = (regSP?.getString('kinPhoneNum') ?? "");
    _kinPostal = (regSP?.getString('kinPostal') ?? "");
    _farmerPic64 = (regSP?.getString('farmerPic') ?? "");

    _companyDirectors = (regSP?.getString('companyDirectors') ?? "");
    _groupName = (regSP?.getString('groupName') ?? "");
    _groupPresident = (regSP?.getString('groupPresident') ?? "");
    _groupSecretary = (regSP?.getString('groupSecretary') ?? "");
    _groupPhone = (regSP?.getString('groupPhone') ?? "");
    // _groupregNumb = (regSP?.getString('groupregNumb') ?? "");
    _groupEmail = (regSP?.getString('groupEmail') ?? "");
    _groupAddress = (regSP?.getString('groupAddress') ?? "");

//farm Details
    _region = (regSP?.getString('region') ?? "");
    _forestDistrict = (regSP?.getString('forestDistrict') ?? "");
    _mddas = (regSP?.getInt('mddas') ?? 0);
    _mddasName = (regSP?.getString('mddasName') ?? "");
    _community = (regSP?.getString('community') ?? "");
    _family = (regSP?.getString("family") ?? "");
    _toEstablishment = (regSP?.getStringList("est") ?? []);

//farm Cordinates
    _farmID = (regSP?.getString('farmID') ?? "");
    _farmArea = (regSP?.getString('farmArea') ?? "");
    _pointsGet = (regSP?.getString('pointsString') ?? "");

//tree Plantation Detail
    _c2treePlantationDetail =
        (regSP?.getString('c2treeplantationDetail') ?? "");
    _c3treePlantationDetail =
        (regSP?.getString('c3treeplantationDetail') ?? "");

//declaration Signature
    _declarationSig = (regSP?.getString('base64signature') ?? "");
    _witnessDeclarationSig = (regSP?.getString('witnessbase64signature') ?? "");

    print("Getting worked shared preference worked");
    print("Items again ${widget.list}");
  }

  // authenticatingLoader() {
  //   showDialog(
  //       barrierColor: Colors.white38,
  //       context: context,
  //       builder: (BuildContext context) {
  //         return Container(
  //           child: Center(
  //             child: spinkit.SpinKitChasingDots(
  //               color: Colors.orange,
  //               size: 80.0,
  //             ),
  //           ),
  //         );
  //       });
  // }

  File? _farmerSig;
  File? _witnessSig;

  void _farmerSign(File pickedImage) {
    _farmerSig = pickedImage;
  }

  void _witnessSign(File pickedImage) {
    _witnessSig = pickedImage;
  }

  convertr() {
    decodedfarmInfoArray = FarmInformationArray.decode(_pointsGet!);
    print("Decoded Points1 $_pointsGet");
    print("Decoded Points1 type ${_pointsGet.runtimeType}");
    print("Decoded Points2 ${[_pointsGet]}");
    print("Decoded Points2 type ${[_pointsGet].runtimeType}");
  }

  convertc2() {
    print("Decoded Tree1 $_c2treePlantationDetail");
    print("Decoded Tree1 type ${_c2treePlantationDetail.runtimeType}");
    print("Decoded Tree2 $_c2treePlantationDetail");
    print("Decoded Tree2 type ${[_c2treePlantationDetail].runtimeType}");
  }

  convertc3() {
    print("Decoded Treec3 $_c3treePlantationDetail");
    print("Decoded Treec3 type ${_c3treePlantationDetail.runtimeType}");
    print("Decoded Treec3 $_c3treePlantationDetail");
    print("Decoded Treec3 type ${[_c3treePlantationDetail].runtimeType}");
  }

  void _submissionLoading() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(7.0),
            child: Container(
              // width: 5000,
              child: AlertDialog(
                title: new Text(
                  "Registering Data",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w400),
                ),
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new CircularProgressIndicator(
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(fPrimaryColour),
                    ),
                    new Text(
                      "Please wait a minute...",
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w100),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void saveToLocalDB(String? con) {
    // this saves the entire record being sent
    Provider.of<PersonalFarmerProvider>(context, listen: false)
        .addPersonalFarmer(
      _farmerId.toString(),
      _beneficiaryType.toString(),
      enumeratorvalue.toString(),
      _farmerfirstName.toString(),
      _farmerotherName.toString(),
      _farmersurName.toString(),
      _farmerGender.toString(),
      _farmerPhoneNum.toString(),
      _farmerDoB.toString(),
      _farmerMail.toString(),
      _farmerPostal.toString(),
      _kinName.toString(),
      _kinRelationShip.toString(),
      _kinDoB.toString(),
      _kinGender.toString(),
      _kinPhoneNum.toString(),
      _kinPostal.toString(),
      _farmerPic64.toString(),
      _groupName.toString(),
      _groupPresident.toString(),
      _groupSecretary.toString(),
      _groupPhone.toString(),
      _companyDirectors.toString(),
      _groupEmail.toString(),
      _groupAddress.toString(),
      _region.toString(),
      _forestDistrict.toString(),
      _mddas.toString(),
      _mddasName.toString(),
      _community.toString(),
      _family.toString(),
      json.encode(_toEstablishment),
      _farmID.toString(),
      _farmArea.toString(),
      _pointsGet.toString(),
      _c2treePlantationDetail.toString(),
      _c3treePlantationDetail.toString(),
      _declarationSig.toString(),
      _witnessDeclarationSig.toString(),
      _witnessName.text,
      _witnessPhone.text,
      con.toString(),
    );

    // this takes the farmer bio-data and saves it in the local farmer data
    Provider.of<PersonalFarmerProviderOffline>(context, listen: false)
        .addPersonalFarmerOffline(
            _beneficiaryType.toString(),
            enumeratorvalue.toString(),
            _farmerfirstName.toString(),
            _farmerotherName.toString(),
            _farmersurName.toString(),
            _farmerGender.toString(),
            _farmerPhoneNum.toString(),
            _farmerDoB.toString(),
            _farmerMail.toString(),
            _farmerPostal.toString(),
            _kinName.toString(),
            _kinRelationShip.toString(),
            _kinDoB.toString(),
            _kinGender.toString(),
            _kinPhoneNum.toString(),
            _kinPostal.toString(),
            _farmerPic64.toString(),
            _groupName.toString(),
            _groupPresident.toString(),
            _groupSecretary.toString(),
            _groupPhone.toString(),
            _companyDirectors.toString(),
            _groupEmail.toString(),
            _groupAddress.toString(),
            _declarationSig.toString(),
            con.toString());

    print("Successfully saved to local DB");
  }

// get and save tree farmer api list offline
  UpdateTreeFarmerList updateTreeFarmerList = UpdateTreeFarmerList();

  attemptSignup(BuildContext ctx) async {
    _submissionLoading();
    getEnumeratorValue('first_time_user');
    convertr();
    convertc2();
    convertc3();

    List<FarmInformationArray> item;

    _pointsGet!.isNotEmpty
        ? item = FarmInformationArray.decode(_pointsGet!)
        : item = [];
    item.insert(item.length, item.first);

    final String? encodedData = FarmInformationArray.encode(item);

    final farmCords = _pointsGet!.isNotEmpty
        ? json.decode(encodedData!).cast<Map<String, dynamic>>()
        : Map();
    final treeInfo0Option = _c2treePlantationDetail!.isNotEmpty
        ? json.decode(_c2treePlantationDetail!).cast<Map<String, dynamic>>()
        : Map();
    final treeInfo2Option = _c3treePlantationDetail!.isNotEmpty
        ? json.decode(_c3treePlantationDetail!).cast<Map<String, dynamic>>()
        : Map();

    print("Tree info: $treeInfo2Option");
    overlayNotification('Data uploading... Please wait.', "positive");
    try {
      // List<TreeInformationOption0Array> listOfDistricts =
      //     treeInfo0Option.map<TreeInformationOption0Array>((json) {
      //   return TreeInformationOption0Array.fromJson(json);
      // }).toList();
      print("trying");
      print("listOfDistricts again again ${treeInfo0Option.runtimeType}");
      print("Itema again again $treeInfo0Option");
      print("$_beneficiaryType");
      var individualdata = {
        "beneficiaryDetails": {
          "farmerid": _farmerId,
          "dateOfBirth": "$_farmerDoB",
          "firstName": "$_farmerfirstName",
          "enumerator": enumeratorvalue,
          "gender": "$_farmerGender",
          "nextOfKin": {
            "dateOfBirth": "$_kinDoB",
            "gender": "$_kinGender",
            "name": "$_kinName",
            "phoneNumber": "$_kinPhoneNum",
            "relationship": "$_kinRelationShip",
            "address": "$_kinPostal"
          },
          "otherNames": "$_farmerotherName",
          "passportImageBase64String": "$_farmerPic64",
          "surname": "$_farmersurName",
          "beneficiaryType": "$_beneficiaryType",
          "phoneNumber": "$_farmerPhoneNum",
          "address": "$_farmerPostal",
          "email": "$_farmerMail"
        },
        "declaration": {
          "signatureOrThumbprintBase64String": "$_declarationSig",
          "witness": {
            "date": "${formattedDate.toString()}",
            "name": "${_witnessName.text}",
            "phoneNumber": "${_witnessPhone.text}",
            "witnessSignatureOrThumbprintBase64String":
                "$_witnessDeclarationSig"
          }
        },
        "location": {
          "community": "$_community",
          "family": "$_family",
          "forestDistrict": "$_forestDistrict",
          "mmdas": _mddas,
          "region": "$_region"
        },
        "treeFarmInformationArray": [
          {
            "farmId": "$_farmID",
            "farmInformationArray": farmCords,
            "treeFarmArea": _farmArea,
            "treeInformationOption1Array": treeInfo0Option,
            "treeInformationOption2Array": treeInfo2Option,
            "typeOfEstablishments": _toEstablishment
          },
        ]
      };

      var groupdata = {
        "beneficiaryDetails": {
          "farmerid": _farmerId,
          "enumerator": enumeratorvalue,
          "companyDirectors": ["$_companyDirectors"],
          "groupName": "$_groupName",
          "groupPresident": "$_groupPresident",
          "groupSecretary": "$_groupSecretary",
          "beneficiaryType": "$_beneficiaryType",
          "phoneNumber": "$_groupPhone",
          "address": "$_groupAddress",
          "email": "$_groupEmail",
          "passportImageBase64String": "$_declarationSig"
        },
        "declaration": {
          "signatureOrThumbprintBase64String": "$_declarationSig",
          "witness": {
            "date": "${formattedDate.toString()}",
            "name": "${_witnessName.text}",
            "phoneNumber": "${_witnessPhone.text}",
            "witnessSignatureOrThumbprintBase64String":
                "$_witnessDeclarationSig"
          }
        },
        "location": {
          "community": "$_community",
          "family": "$_family",
          "forestDistrict": "$_forestDistrict",
          "mmdas": _mddas,
          "region": "$_region"
        },
        "treeFarmInformationArray": [
          {
            "farmId": "$_farmID",
            "farmInformationArray": farmCords,
            // "treeFarmArea": _farmArea,
            "treeInformationOption1Array": treeInfo0Option,
            "treeInformationOption2Array": treeInfo2Option,
            "typeOfEstablishments": _toEstablishment
          }
        ]
      };

      var url = '$stageBaseUrl/saverecords/';

      var body = _beneficiaryType == "Individual"
          ? json.encode(individualdata)
          : json.encode(groupdata);

//here jsonEncode(data) return String? bt in http body you are passing Map value

//So you have to convert String? to Map
      var bodyMap = jsonDecode(body);
      print(body);

// your nested json data
      var bodyData = bodyMap;

      var res = await http.post(Uri.parse(url), body: body);
      print("uploading...");
      print("Statuscode is ${res.statusCode}");
      print("MMDDAASS $_mddas");

      final itemss = json.decode(res.body);

      print("itemss $body");
      print(itemss["status"]);
      var status = itemss["status"];

      if (status == "Done") {
        saveToLocalDB("connected");
        overlayNotification(
            'Data sent successfully with status: $status.', "positive");

        updateTreeFarmerList.saveTreeFarmerApiList(context);

        regSP?.clear();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => const IndexPage(),
          ),
        );
        // return res.statusCode;
      } else if (status == "exist") {
        overlayNotification('Data already: $status.', "positive");
        Navigator.pop(context);
      } else {
        overlayNotification(
            'Error occured with error: ${itemss["error"]}', "negative");
        Navigator.pop(context);
        print('Error occured with error: ${itemss["error"]}');
        // return res.statusCode;
      }
      // newVibe = items[0]["status"];
    } on SocketException catch (e) {
      print("e === $e");
      saveToLocalDB("not connected");
      overlayNotification(
          'Oops! Internet error. Please make sure you\'re connected to the internet and try again from "View Registered Trees".',
          "negative");
      regSP?.clear();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => const IndexPage(),
        ),
      );
    } catch (i) {
      print("i ===> ${i.toString()}");
      overlayNotification(i, "negative");
      Navigator.of(context).pop();
    }
  }

  String? _predeclarationSig;
  void getSig() {
    _beneficiaryType = (regSP?.getString("_beneficiaryType") ?? "");
    _farmerfirstName = (regSP?.getString('farmerfirstName') ?? "");
    _farmerotherName = (regSP?.getString('farmerotherName') ?? "");
    _farmersurName = (regSP?.getString('farmersurName') ?? "");
    _farmerPhoneNum = (regSP?.getString('farmerPhoneNum') ?? "");

    _groupName = (regSP?.getString('groupName') ?? "");
    _groupPhone = (regSP?.getString('groupPhone') ?? "");

    _predeclarationSig = (regSP?.getString('witnessbase64signature') ?? "");

    print("Base declare $_predeclarationSig");
  }

  @override
  void initState() {
    super.initState();
    print("Items declaration ${widget.list}");
    getSig();
    getEnumeratorValue("first_time_user");
    hasSkipped();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: primaryColour,
      // appBar: AppBar(
      //   foregroundColor: fPrimaryWhite,
      //   automaticallyImplyLeading: false,
      //   backgroundColor: fPrimaryColour,
      //   title: const Text(
      //     "Farm Registration",
      //     style: TextStyle(color: fPrimaryWhite),
      //   ),
      //   actions: [
      //     Tooltip(
      //       child: Padding(
      //         padding: const EdgeInsets.symmetric(horizontal: 12.0),
      //         child: InkWell(
      //           child: const Icon(Icons.home, color: fPrimaryWhite),
      //           onTap: () => Navigator.of(context).pushReplacement(
      //             MaterialPageRoute(
      //               builder: (BuildContext context) => const IndexPage(),
      //             ),
      //           ),
      //         ),
      //       ),
      //       message: "Takes you back to homepage",
      //     )
      //   ],
      // ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Material(
                  elevation: 0.0,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(12.0),
                  ),
                  color: primaryColour,
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: primaryWhite,
                        size: 40.0,
                      )),
                ),
                Text(
                  "Declaration".toUpperCase(),
                  style: const TextStyle(
                    color: primaryWhite,
                    fontSize: 20.0,
                  ),
                ),
                Tooltip(
                  message: "Takes you back to homepage",
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: InkWell(
                      child: const Icon(Icons.home, color: fPrimaryWhite),
                      onTap: () => Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (BuildContext context) => const IndexPage(),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: size.height * .86,
              decoration: const BoxDecoration(
                color: primaryWhite,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    topRight: Radius.circular(25.0)),
              ),
              margin: const EdgeInsets.all(0.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Material(
                            elevation: 0,
                            color: primaryWhite,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(25.0),
                                topRight: Radius.circular(25.0)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // const Row(
                                  //   mainAxisAlignment: MainAxisAlignment.center,
                                  //   children: [
                                  //     Text(
                                  //       "Declaration",
                                  //       style: TextStyle(
                                  //           fontWeight: FontWeight.bold,
                                  //           fontSize: 24.0),
                                  //     ),
                                  //   ],
                                  // ),
                                  // const SizedBox(
                                  //   height: 30.0,
                                  // ),
                                  // Row(
                                  //   children: [
                                  //     Container(
                                  //       width:
                                  //           MediaQuery.of(context).size.width -
                                  //               30,
                                  //       child: const Text(
                                  //         "Farmer/ Group/ Company rep. Signature/ Thumbprint",
                                  //         softWrap: true,
                                  //         overflow: TextOverflow.clip,
                                  //         style: TextStyle(
                                  //             // fontWeight: FontWeight.bold,
                                  //             fontSize: 17.0),
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                  formFieldLabel(width: size.width * .9, 
                                      "Farmer/ Group/ Company rep. Signature/ Thumbprint"),
                                  const SizedBox(
                                    height: 30.0,
                                  ),
                                  SignatureOptions(_farmerSign, alreadyVal: ""),
                                  const SizedBox(
                                    height: 30.0,
                                  ),
                                  formFieldLabel(width: size.width * .9, "Farmer/ Group Name"),
                                  TextFieldWidget(
                                    readonly: true,
                                    decoration: const InputDecoration(
                                      labelText: "",
                                      enabled: false,
                                      disabledBorder: InputBorder.none,
                                    ),
                                    controller: _beneficiaryType == "Individual"
                                        ? TextEditingController(
                                            text:
                                                "$_farmerfirstName $_farmerotherName $_farmersurName",
                                          )
                                        : TextEditingController(
                                            text: "$_groupName",
                                          ),
                                  ),
                                  formFieldLabel(width: size.width * .9, "Contact number"),
                                  TextFieldWidget(
                                    readonly: true,
                                    decoration: const InputDecoration(
                                      labelText: "",
                                      enabled: false,
                                      disabledBorder: InputBorder.none,
                                    ),
                                    controller: _beneficiaryType == "Individual"
                                        ? TextEditingController(
                                            text: "$_farmerPhoneNum",
                                          )
                                        : TextEditingController(
                                            text: "$_groupPhone",
                                          ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 18.0),
                                    child: Row(
                                      // mainAxisAlignment:
                                      //     MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Date: $formattedDate",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 60,
                                    child: Divider(
                                        // color: Colors.grey,
                                        ),
                                  ),
                                  const Row(
                                    children: [
                                      Text(
                                        "Witness Signature/ Thumbprint",
                                        style: TextStyle(
                                            // fontWeight: FontWeight.bold,
                                            fontSize: 18.0),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 30.0,
                                  ),
                                  WitSignatureOptions(
                                      _witnessSign, _predeclarationSig,
                                      alreadyval: ""),
                                  const SizedBox(
                                    height: 30.0,
                                  ),
                                  formFieldLabel(width: size.width * .9, "Name"),
                                  TextFieldWidget(
                                    decoration:
                                        const InputDecoration(labelText: ""),
                                    controller: _witnessName,
                                    validator: (input) => input!.trim().isEmpty
                                        ? 'Please enter a name'
                                        : null,
                                  ),
                                  formFieldLabel(width: size.width * .9, "Phone Number"),
                                  TextFieldWidget(
                                    keyboardType: TextInputType.phone,
                                    maxLength: 10,
                                    decoration:
                                        const InputDecoration(labelText: ""),
                                    controller: _witnessPhone,
                                    validator: (input) => input!.trim().length <
                                            10
                                        ? 'Number must be up to 10 digits'
                                        : input.length > 10
                                            ? 'Number is more than 10 digits'
                                            : null,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 18.0),
                                    child: Row(
                                      // mainAxisAlignment:
                                      //     MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Date: $formattedDate",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 30.0),
                                  _hasfarmerSkipped == true ||
                                          _hasfarmcordSkipped == true ||
                                          _hasfarmdetSkipped == true ||
                                          _hascskippped == true
                                      ? Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                          height: 50.00,
                                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20.0,
                                                        vertical: 15.0),
                                                elevation: 0.0,
                                                backgroundColor: fPrimaryColour,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                textStyle: const TextStyle(
                                                    color: Colors.white),
                                                // shadowColor: fPrimaryColour,
                                                side: const BorderSide(
                                                    width: 1.0,
                                                    color: fPrimaryColour),
                                              ),
                                              child: const Text(
                                                "Save and Close",
                                                style: TextStyle(
                                                    color: fPrimaryWhite,
                                                    fontSize: 17.0,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                              onPressed: () async {
                                                getSPValues();
                                                submissionOptions(
                                                  context,
                                                  "Save as Incomplete",
                                                  "Save",
                                                  "Cancel",
                                                  "Back to Home",
                                                  approvePress: () {
                                                    Navigator.pop(context);
                                                    saveToLocalDB("incomplete");
                                                    overlayNotification(
                                                        'Successfully saved. Please go to "View Registered Trees" to access data',
                                                        "negative");
                                                    Navigator.of(context)
                                                        .pushReplacement(
                                                      MaterialPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            const IndexPage(),
                                                      ),
                                                    );
                                                    regSP?.clear();
                                                  },
                                                  editPress: () => null,
                                                  disapprovePress: () =>
                                                      Navigator.of(context)
                                                          .pushReplacement(
                                                    MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          const IndexPage(),
                                                    ),
                                                  ),
                                                );
                                              }),
                                        )
                                      : Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width ,
                                          height: 50.00,
                                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20.0,
                                                      vertical: 15.0),
                                              elevation: 0.0,
                                              backgroundColor: fPrimaryColour,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              textStyle: const TextStyle(
                                                  color: Colors.white),
                                              // shadowColor: fPrimaryColour,
                                              side: const BorderSide(
                                                  width: 1.0,
                                                  color: fPrimaryColour),
                                            ),
                                            child: const Text(
                                              "Finish",
                                              style: TextStyle(
                                                  color: fPrimaryWhite,
                                                  fontSize: 17.0,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                            onPressed: () async {
                                              getSPValues();
                                              if (_declarationSig!
                                                      .trim()
                                                      .isEmpty ||
                                                  _witnessDeclarationSig!
                                                      .trim()
                                                      .isEmpty) {
                                                overlayNotification(
                                                    'Please upload a signature',
                                                    "negative");
                                              } else if (_formKey.currentState!
                                                  .validate()) {
                                                submissionOptions(
                                                  context,
                                                  "Do you have internet data?",
                                                  "Send with internet",
                                                  "Send later",
                                                  "Cancel",
                                                  approvePress: () =>
                                                      attemptSignup(context),
                                                  editPress: () {
                                                    Navigator.pop(context);
                                                    saveToLocalDB(
                                                        "not connected");
                                                    overlayNotification(
                                                        'Successfully saved. Please go to "View Registered Trees" to send data',
                                                        "negative");
                                                    Navigator.of(context)
                                                        .pushReplacement(
                                                      MaterialPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            const IndexPage(),
                                                      ),
                                                    );
                                                    regSP?.clear();
                                                  },
                                                  disapprovePress: () => null,
                                                );
                                              }
                                              // convertr();
                                              // convertc2();
                                              // convertc3();
                                              // saveToLocalDB("not connected");
                                            },
                                          ),
                                        )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
