import 'dart:convert';
import 'dart:io';

import 'package:hcms_revived2/helpers/dbhelper.dart';
import 'package:hcms_revived2/models/apimodels/communitymodel.dart';
import 'package:hcms_revived2/models/apimodels/forestdistrict.dart';
import 'package:hcms_revived2/models/apimodels/regionmodel.dart';
import 'package:hcms_revived2/models/apimodels/stool.dart';
import 'package:hcms_revived2/models/senddata/components/treefarminformationcomponents/farminformationarraydetails.dart';
import 'package:hcms_revived2/providers/monitoring/seedlingmonitoring2provider.dart';
import 'package:hcms_revived2/screens/seedlingmonitoring/3plantation_planted_details.dart';
import 'package:hcms_revived2/screens/seedlingmonitoring/components/treefarminformationcomponents/seedlingsmappingModel.dart';
import 'package:hcms_revived2/services/serverurls.dart';
import 'package:hcms_revived2/utils/constants/colours.dart';
import 'package:hcms_revived2/utils/widgets/textFields/generic_text_field.dart';
import 'package:hcms_revived2/utils/widgets/textFormats/text_formats.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/boilerplate/widgets.dart';
import 'package:hcms_revived2/models/apimodels/districtmodel.dart';
import 'package:hcms_revived2/screens/farmregistration/farmdetails/farmcordinates.dart';
import 'package:hcms_revived2/screens/home/index.dart';
import 'package:provider/provider.dart';

import '../../../main.dart';

class SeedlingMonitoringFinalPage extends StatefulWidget {
  @override
  _SeedlingMonitoringFinalPageState createState() =>
      _SeedlingMonitoringFinalPageState();
}

class _SeedlingMonitoringFinalPageState
    extends State<SeedlingMonitoringFinalPage> {
  final _formKey = GlobalKey<FormState>();

  String? _pestsAroundYesNoValue;
  int? _pestsAroundYesNoRadio;

  String? _fertiliserAppliedYesNoValue;
  int? _fertiliserAppliedYesNoRadio;

  String? _pesticideHerbicideAppliedYesNoValue;
  int? _pesticideHerbicideAppliedYesNoRadio;

  String? _signsDiseaseYesNoValue;
  int? _signsDiseaseYesNoRadio;

  final TextEditingController _additionalObservations = TextEditingController();
  final TextEditingController _pestDescription = TextEditingController();
  final TextEditingController _fertiliserType = TextEditingController();
  final TextEditingController _pesticideHerbicideType = TextEditingController();
  final TextEditingController _diseaseDescription = TextEditingController();

  // saved preference
  void setSSR7ValuesT() {
    // regSP?.setStringList("ssr_sourceOfWater", _sourceOfWater);
    // regSP?.setString("ssr_wateringFrequency", _pestsAroundYesNoValue ?? "null");
    // regSP?.setString("ssr_anyExtremeSigns", _yesNoValue ?? "null");
    // regSP?.setStringList("ssr_extremeWeathers", _extremeWeathers);

    print("Tree Information values gotten!");
  }

  // get all saved values
  TextEditingController surveyorName = TextEditingController();
  String? _dateOfSurvey;
  String? _community;
  TextEditingController farmerName = TextEditingController();
  TextEditingController farmerIDNumber = TextEditingController();

  // 2nd
  String? _typeOfPlantation;
  final TextEditingController _totalSizeAcres = TextEditingController();
  List<String> _speciesProvidedPlanted = [];

  // 3rd
  // prekese
  TextEditingController pr_quantityReceived = TextEditingController();
  TextEditingController pr_quantityPlanted = TextEditingController();
  String? pr_farmerdOB;

  // Kokrodua
  TextEditingController ka_quantityReceived = TextEditingController();
  TextEditingController ka_quantityPlanted = TextEditingController();
  String? ka_farmerdOB;

  // Dahoma
  TextEditingController da_quantityReceived = TextEditingController();
  TextEditingController da_quantityPlanted = TextEditingController();
  String? da_farmerdOB;

  // Edinam
  TextEditingController ed_quantityReceived = TextEditingController();
  TextEditingController ed_quantityPlanted = TextEditingController();
  String? ed_farmerdOB;

  // Emire
  TextEditingController em_quantityReceived = TextEditingController();
  TextEditingController em_quantityPlanted = TextEditingController();
  String? em_farmerdOB;

  // Ofram
  TextEditingController of_quantityReceived = TextEditingController();
  TextEditingController of_quantityPlanted = TextEditingController();
  String? of_farmerdOB;

  // Mahogany
  TextEditingController md_quantityReceived = TextEditingController();
  TextEditingController md_quantityPlanted = TextEditingController();
  String? md_farmerdOB;

  // Mansonia
  TextEditingController mo_quantityReceived = TextEditingController();
  TextEditingController mo_quantityPlanted = TextEditingController();
  String? mo_farmerdOB;

  // Okoro
  TextEditingController ok_quantityReceived = TextEditingController();
  TextEditingController ok_quantityPlanted = TextEditingController();
  String? ok_farmerdOB;

  // Efoobodedwo
  TextEditingController eu_quantityReceived = TextEditingController();
  TextEditingController eu_quantityPlanted = TextEditingController();
  String? eu_farmerdOB;

  // Bako
  TextEditingController ba_quantityReceived = TextEditingController();
  TextEditingController ba_quantityPlanted = TextEditingController();
  String? ba_farmerdOB;

  // 4th
  var mappedFarmBoundaries;

  // 5th
  final TextEditingController _totalSeedlingsAliveController =
      TextEditingController();
  List<String> _speciesAlive = [];
  List<String> _reasonForDeath = [];

  // 6th
  var mappedSurvidedSeedlings;

  // 7th
  List<String> _sourceOfWater = [];
  String? waterignFrequency = "";
  String? anyExtremeSigns = "";
  List<String> _extremeWeathers = [];

  void getAllSSRValuesT() {
    surveyorName.text = regSP?.getString("ssr_nameOfSurveyor") ?? "";
    _dateOfSurvey = regSP?.getString("ssr_dateOfSurvey") ?? "";
    _community = regSP?.getString("ssr_community") ?? "";
    farmerName.text = regSP?.getString("ssr_farmerName") ?? "";
    farmerIDNumber.text = regSP?.getString("ssr_farmerIDNumber") ?? "";

    // 2nd
    _typeOfPlantation = regSP?.getString("ssr_typeOfPlantation") ?? "";
    _totalSizeAcres.text = regSP?.getString("ssr_totalSizeAcres") ?? "";
    _speciesProvidedPlanted =
        regSP?.getStringList("ssr_speciesProvidedPlanted") ?? [];

    // 3rd
    pr_quantityReceived.text = regSP?.getString("pr_quantityReceived") ?? "";
    pr_quantityPlanted.text = regSP?.getString("pr_quantityPlanted") ?? "";
    pr_farmerdOB = regSP?.getString("pr_farmerdOB") ?? "";
    ka_quantityReceived.text = regSP?.getString("ka_quantityReceived") ?? "";
    ka_quantityPlanted.text = regSP?.getString("ka_quantityPlanted") ?? "";
    ka_farmerdOB = regSP?.getString("ka_farmerdOB") ?? "";
    da_quantityReceived.text = regSP?.getString("da_quantityReceived") ?? "";
    da_quantityPlanted.text = regSP?.getString("da_quantityPlanted") ?? "";
    da_farmerdOB = regSP?.getString("da_farmerdOB") ?? "";
    ed_quantityReceived.text = regSP?.getString("ed_quantityReceived") ?? "";
    ed_quantityPlanted.text = regSP?.getString("ed_quantityPlanted") ?? "";
    ed_farmerdOB = regSP?.getString("ed_farmerdOB") ?? "";
    em_quantityReceived.text = regSP?.getString("em_quantityReceived") ?? "";
    em_quantityPlanted.text = regSP?.getString("em_quantityPlanted") ?? "";
    em_farmerdOB = regSP?.getString("em_farmerdOB") ?? "";
    of_quantityReceived.text = regSP?.getString("of_quantityReceived") ?? "";
    of_quantityPlanted.text = regSP?.getString("of_quantityPlanted") ?? "";
    of_farmerdOB = regSP?.getString("of_farmerdOB") ?? "";
    md_quantityReceived.text = regSP?.getString("md_quantityReceived") ?? "";
    md_quantityPlanted.text = regSP?.getString("md_quantityPlanted") ?? "";
    md_farmerdOB = regSP?.getString("md_farmerdOB") ?? "";
    mo_quantityReceived.text = regSP?.getString("mo_quantityReceived") ?? "";
    mo_quantityPlanted.text = regSP?.getString("mo_quantityPlanted") ?? "";
    mo_farmerdOB = regSP?.getString("mo_farmerdOB") ?? "";
    ok_quantityReceived.text = regSP?.getString("ok_quantityReceived") ?? "";
    ok_quantityPlanted.text = regSP?.getString("ok_quantityPlanted") ?? "";
    ok_farmerdOB = regSP?.getString("ok_farmerdOB") ?? "";
    eu_quantityReceived.text = regSP?.getString("eu_quantityReceived") ?? "";
    eu_quantityPlanted.text = regSP?.getString("eu_quantityPlanted") ?? "";
    eu_farmerdOB = regSP?.getString("eu_farmerdOB") ?? "";
    ba_quantityReceived.text = regSP?.getString("ba_quantityReceived") ?? "";
    ba_quantityPlanted.text = regSP?.getString("ba_quantityPlanted") ?? "";
    ba_farmerdOB = regSP?.getString("ba_farmerdOB") ?? "";

    // 4th
    mappedFarmBoundaries = regSP?.getString("ssr_mappedFarmBoundaries") ?? "";

    // 5th
    _totalSeedlingsAliveController.text =
        regSP?.getString("ssr_totalAlive") ?? "";
    _speciesAlive = regSP?.getStringList("ssr_speciesAlive") ?? [];
    _reasonForDeath = regSP?.getStringList("ssr_reasonsForDeath") ?? [""];

    // 6th
    mappedSurvidedSeedlings = regSP?.getString("ssr_mappedSurvidedSeedlings");

    // 7th
    _sourceOfWater = regSP?.getStringList("ssr_sourceOfWater") ?? [];
    waterignFrequency = regSP?.getString("ssr_wateringFrequency") ?? "";
    anyExtremeSigns = regSP?.getString("ssr_anyExtremeSigns") ?? "";
    _extremeWeathers = regSP?.getStringList("ssr_extremeWeathers") ?? [];

    // 8th
    // here
  }

  @override
  void initState() {
    super.initState();
    _pestsAroundYesNoRadio = 0;

    getAllSSRValuesT();

    // forestdistrictFileInit();
    // stoolFileInit();
    // districtFileInit();
    // commFileInit();
    // regionFileInit();

    // myDFuture = writeToDistrictFile(this.context);
    // myFDFuture = writeToForestDistrictFile(this.context);
    // mySFuture = writeToStoolFile(this.context);
    // myCFuture = writeToCommFile(this.context);
    // myRFuture = writeToRegionFile(this.context);

    // _mmdas = 96;
  }

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
                  "Submitting Monitoring Data",
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

  List<SeedlingsMappingModel> decodedfarmInfoArray = [];

  convertr() {
    decodedfarmInfoArray =
        SeedlingsMappingModel.decode(mappedSurvidedSeedlings!);
    // print("Decoded Points1 $_pointsGet");
    // print("Decoded Points1 type ${_pointsGet.runtimeType}");
    // print("Decoded Points2 ${[_pointsGet]}");
    // print("Decoded Points2 type ${[_pointsGet].runtimeType}");
  }

  void saveToLocalDB(String con) {
    Provider.of<SeedlingMonitoring2Provider>(context, listen: false)
        .addSeedlingMonitoring2(
      _community ?? "",
      _dateOfSurvey ?? "",
      enumeratorvalue.toString(),
      "false",
      enumeratorvalue.toString(),
      _dateOfSurvey ?? "",
      _community ?? "",
      farmerName.text,
      farmerIDNumber.text,
      _typeOfPlantation ?? "",
      "acres",
      json.encode(_speciesProvidedPlanted),
      pr_quantityReceived.text,
      pr_quantityPlanted.text,
      pr_farmerdOB ?? "",
      ka_quantityReceived.text,
      ka_quantityPlanted.text,
      ka_farmerdOB ?? "",
      da_quantityReceived.text,
      da_quantityPlanted.text,
      da_farmerdOB ?? "",
      ed_quantityReceived.text,
      ed_quantityPlanted.text,
      ed_farmerdOB ?? "",
      em_quantityReceived.text,
      em_quantityPlanted.text,
      em_farmerdOB ?? "",
      of_quantityReceived.text,
      of_quantityPlanted.text,
      of_farmerdOB ?? "",
      md_quantityReceived.text,
      md_quantityPlanted.text,
      md_farmerdOB ?? "",
      mo_quantityReceived.text,
      mo_quantityPlanted.text,
      mo_farmerdOB ?? "",
      ok_quantityReceived.text,
      ok_quantityPlanted.text,
      ok_farmerdOB ?? "",
      eu_quantityReceived.text,
      eu_quantityPlanted.text,
      eu_farmerdOB ?? "",
      ba_quantityReceived.text,
      ba_quantityPlanted.text,
      ba_farmerdOB ?? "",
      mappedFarmBoundaries,
      json.encode(_speciesAlive),
      mappedSurvidedSeedlings,
      _totalSeedlingsAliveController.text,
      json.encode(_reasonForDeath),
      json.encode(_sourceOfWater),
      waterignFrequency ?? "",
      anyExtremeSigns ?? "",
      json.encode(_extremeWeathers),
      _pestsAroundYesNoValue ?? "",
      _pestDescription.text,
      _signsDiseaseYesNoValue ?? "",
      _diseaseDescription.text,
      _fertiliserAppliedYesNoValue ?? "",
      _fertiliserType.text,
      _pesticideHerbicideAppliedYesNoValue ?? "",
      _pesticideHerbicideType.text,
      _additionalObservations.text,
      con,
    );

    print("Successfully saved to local DB");
  }

  attemptUpload(BuildContext ctx) async {
    _submissionLoading();
    getEnumeratorValue('first_time_user');
    convertr();
    // convertc2();
    // convertc3();

    List<FarmInformationArray> item;

    mappedSurvidedSeedlings!.isNotEmpty
        ? item = FarmInformationArray.decode(mappedSurvidedSeedlings!)
        : item = [];
    item.insert(item.length, item.first);

    final String? encodedData = FarmInformationArray.encode(item);

    final farmCords = mappedSurvidedSeedlings!.isNotEmpty
        ? json.decode(encodedData!).cast<Map<String, dynamic>>()
        : Map();
    // final treeInfo0Option = _c2treePlantationDetail!.isNotEmpty
    //     ? json.decode(_c2treePlantationDetail!).cast<Map<String, dynamic>>()
    //     : Map();
    // final treeInfo2Option = _c3treePlantationDetail!.isNotEmpty
    //     ? json.decode(_c3treePlantationDetail!).cast<Map<String, dynamic>>()
    //     : Map();

    // print("Tree info: $treeInfo2Option");
    overlayNotification('Data uploading... Please wait.', "positive");
    try {
      // List<TreeInformationOption0Array> listOfDistricts =
      //     treeInfo0Option.map<TreeInformationOption0Array>((json) {
      //   return TreeInformationOption0Array.fromJson(json);
      // }).toList();
      debugPrint("trying");
      // print("listOfDistricts again again ${treeInfo0Option.runtimeType}");
      // print("Itema again again $treeInfo0Option");
      // print("$_beneficiaryType");
      var seedlingSurvivalRateMonitoring = {
        "name_of_surveyor": enumeratorvalue,
        "date_of_survey": _dateOfSurvey,
        "name_of_community": _community,
        "name_of_farmer": farmerName.text,
        "farmer_id_number": farmerIDNumber.text,
        "type_of_plantation": _typeOfPlantation,
        "species_provided_planted": _speciesProvidedPlanted,
        "planted_species": [
          {
            "species": "prekese",
            "quantity_received": pr_quantityReceived.text,
            "quantity_planted": pr_quantityPlanted.text,
            "date_of_planting": pr_farmerdOB
          },
          {
            "species": "kokrodua_afromosia",
            "quantity_received": ka_quantityReceived.text,
            "quantity_planted": ka_quantityPlanted.text,
            "date_of_planting": ka_farmerdOB
          },
          {
            "species": "dahoma",
            "quantity_received": da_quantityReceived.text,
            "quantity_planted": da_quantityPlanted.text,
            "date_of_planting": da_farmerdOB
          },
          {
            "species": "edinam",
            "quantity_received": ed_quantityReceived.text,
            "quantity_planted": ed_quantityPlanted.text,
            "date_of_planting": ed_farmerdOB
          },
          {
            "species": "emire",
            "quantity_received": em_quantityReceived.text,
            "quantity_planted": em_quantityPlanted.text,
            "date_of_planting": em_farmerdOB
          },
          {
            "species": "ofram",
            "quantity_received": of_quantityReceived.text,
            "quantity_planted": of_quantityPlanted.text,
            "date_of_planting": of_farmerdOB
          },
          {
            "species": "mahogany_dubini",
            "quantity_received": md_quantityReceived.text,
            "quantity_planted": md_quantityPlanted.text,
            "date_of_planting": md_farmerdOB
          },
          {
            "species": "mansonia_oprono",
            "quantity_received": mo_quantityReceived.text,
            "quantity_planted": mo_quantityPlanted.text,
            "date_of_planting": mo_farmerdOB
          },
          {
            "species": "okoro",
            "quantity_received": ok_quantityReceived.text,
            "quantity_planted": ok_quantityPlanted.text,
            "date_of_planting": ok_farmerdOB
          },
          {
            "species": "efoobodedwo_utile",
            "quantity_received": eu_quantityReceived.text,
            "quantity_planted": eu_quantityPlanted.text,
            "date_of_planting": eu_farmerdOB
          },
          {
            "species": "bako",
            "quantity_received": ba_quantityReceived.text,
            "quantity_planted": ba_quantityPlanted.text,
            "date_of_planting": ba_farmerdOB
          }
        ],
        "farm_boundary": mappedFarmBoundaries,
        "species_alive": _speciesAlive,
        "living_species_records": farmCords,
        "total_seedlings_alive": _totalSeedlingsAliveController.text,
        "reason_for_death": _reasonForDeath,
        "source_of_water": _sourceOfWater,
        "avg_watering_frequency": waterignFrequency,
        "any_extreme_weather": anyExtremeSigns,
        "extreme_weather_type": _extremeWeathers,
        "any_pests_around": _pestsAroundYesNoValue,
        "pest_description": _pestDescription.text,
        "any_signs_of_disease": _signsDiseaseYesNoValue,
        "disease_signs_description": _diseaseDescription.text,
        "any_fertiliser_applied": _fertiliserAppliedYesNoValue,
        "fertiliser_type": _fertiliserType.text,
        "any_pesticide_herbicide": _pesticideHerbicideAppliedYesNoValue,
        "pesticide_herbicide_type": _pesticideHerbicideType.text,
        "additional_observations": _additionalObservations.text
      };

      var url = '$stageBaseUrl/api/v2/monitoring/';

      var body = json.encode(seedlingSurvivalRateMonitoring);

//here jsonEncode(data) return String? bt in http body you are passing Map value

//So you have to convert String? to Map
      var bodyMap = jsonDecode(body);
      print(body);

// your nested json data
      var bodyData = bodyMap;

      var res = await http.post(Uri.parse(url), body: body);
      print("uploading...");
      print("Statuscode is ${res.statusCode}");
      // print("MMDDAASS $_mddas");

      final itemss = json.decode(res.body);

      print("itemss $body");
      print("api itemss $itemss");
      print(itemss["status"]);
      var status1 = itemss["success"];
      var status2 = itemss["created"];

      if (status2 == true) {
        saveToLocalDB("connected");
        overlayNotification(
            'Data sent successfully with status: $status2.', "positive");

        // updateTreeFarmerList.saveTreeFarmerApiList(context);

        regSP?.clear();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => const IndexPage(),
          ),
        );
        return res.statusCode;
      } else if (status2 == false) {
        // overlayNotification('Data already: $status2.', "positive");
        overlayNotification('Data already: $status2.', "positive");
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
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(
      //     builder: (BuildContext context) => IndexPage(),
      //   ),
      // );
    } catch (i) {
      print("i ===> ${i.toString()}");
      overlayNotification(i, "negative");
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: fPrimaryColour,

      // appBar: AppBar(
      //   foregroundColor: fPrimaryWhite,
      //   automaticallyImplyLeading: false,
      //   backgroundColor: fPrimaryColour,
      //   title: const Text(
      //     "Seedling Monitoring",
      //     style: TextStyle(color: fPrimaryWhite),
      //   ),
      //   actions: [
      //     PopupMenuButton<String>(
      //       offset: const Offset(2.00, 3.00),
      //       color: Colors.black,
      //       onSelected: (String _downChoice) {
      //         if (_downChoice == Constants.home) {
      //           Navigator.of(context).pushReplacement(
      //             MaterialPageRoute(
      //               builder: (BuildContext context) => const IndexPage(),
      //             ),
      //           );
      //         } else if (_downChoice == Constants.load) {
      //           Navigator.pushReplacement(
      //               context,
      //               MaterialPageRoute(
      //                   builder: (BuildContext context) => this.widget));
      //           // setState(() {
      //           //   getApplicationDocumentsDirectory().then(
      //           //     (Directory directory) async {
      //           //       dir = directory;
      //           //       districtjsonFile =
      //           //           new File(dir!.path + "/" + districtfileName);
      //           //       districtfileExists = await districtjsonFile.exists();
      //           //       forestdistrictjsonFile =
      //           //           new File(dir!.path + "/" + forestdistrictfileName);
      //           //       forestdistrictfileExists =
      //           //           await forestdistrictjsonFile.exists();
      //           //       stooljsonFile = new File(dir!.path + "/" + stoolfileName);
      //           //       stoolfileExists = await stooljsonFile.exists();

      //           //       if (forestdistrictfileExists &&
      //           //           districtfileExists &&
      //           //           stoolfileExists) {
      //           //         forestdistrictfileContent = await json.decode(
      //           //             await forestdistrictjsonFile!.readAsString());

      //           //         districtfileContent = await json
      //           //             .decode(await districtjsonFile!.readAsString());

      //           //         stoolfileContent = await json
      //           //             .decode(await stooljsonFile!.readAsString());
      //           //       }
      //           //       //else {}
      //           //       // if (districtfileExists) {
      //           //       //   districtfileContent =
      //           //       //       await json.decode(await districtjsonFile!.readAsString());
      //           //       // } else {}
      //           //       // if (stoolfileExists) {
      //           //       //   stoolfileContent =
      //           //       //       await json.decode(await stooljsonFile!.readAsString());
      //           //       // } else {}
      //           //     },
      //           //   );
      //           // });
      //         } else if (_downChoice == Constants.saveskip) {
      //           regSP?.setBool("farmdetskipped", true);
      //           // if (_establishment.isEmpty) {
      //           //   overlayNotification(
      //           //       'Please select type of establishment', "negative");
      //           // } else {
      //           setSSR7ValuesT();
      //           Navigator.of(context).push(
      //             CupertinoPageRoute(
      //               builder: (BuildContext context) => FarmCordinates(),
      //             ),
      //           );

      //           // print("Selected types are $_establishment");
      //           // }
      //         } else if (_downChoice == Constants.saveclose) {
      //           // regSP?.setBool("closed", true);
      //           // setSSR7ValuesT();
      //           // Navigator.of(context).push(
      //           //   CupertinoPageRoute(
      //           //     builder: (BuildContext context) => FarmCordinates(),
      //           //   ),
      //           // );
      //         }
      //       },
      //       itemBuilder: (BuildContext context) {
      //         return Constants.downChoices.map((String _downChoice) {
      //           return PopupMenuItem<String>(
      //             value: _downChoice,
      //             child: Container(
      //               margin: const EdgeInsets.only(right: 0),
      //               child: Text(
      //                 _downChoice,
      //                 style: const TextStyle(color: Color(0xFFFFFFFF)),
      //               ),
      //             ),
      //           );
      //         }).toList();
      //       },
      //     ),
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
                  "Seedling Monitoring".toUpperCase(),
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
                      child: const Icon(
                        Icons.home,
                        color: fPrimaryWhite,
                        size: 40.0,
                      ),
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
          SafeArea(
            top: false,
            child: Align(
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: fDefaultPadding),
                              child: Center(
                                child: Text(
                                  "Pest and Disease Observation",
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(0.0),
                                        child: SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: const Text(
                                            "Have you noticed any pests on or around the seedlings?",
                                            softWrap: true,
                                            overflow: TextOverflow.clip,
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          GenderRadioButton(
                                            value: 1,
                                            group: _pestsAroundYesNoRadio,
                                            selected: (val) {
                                              print(val);
                                              setState(() {
                                                _pestsAroundYesNoRadio = val;
                                                print(val);
                                                _pestsAroundYesNoValue = "Yes";
                                              });
                                            },
                                          ),
                                          const Text(
                                            "Yes",
                                            // style: TextStyle(
                                            //     color: Color(0xFFf9f9f9)),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          GenderRadioButton(
                                            value: 2,
                                            group: _pestsAroundYesNoRadio,
                                            selected: (val) {
                                              print(val);
                                              setState(() {
                                                _pestsAroundYesNoRadio = val;
                                                _pestsAroundYesNoValue = "No";
                                              });
                                            },
                                          ),
                                          const Text(
                                            "No",
                                            // style: TextStyle(
                                            //     color:
                                            //         Color(0xFFf9f9f9))
                                          ),
                                        ],
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            // left: 10.0,
                                            // right: 10.0,
                                            bottom: 8.0),
                                        child: TextFieldWidget(
                                          readonly:
                                              _pestsAroundYesNoValue == "Yes"
                                                  ? false
                                                  : true,
                                          decoration: const InputDecoration(
                                            hintText: "(Specify)",
                                            hintStyle: TextStyle(
                                                fontStyle: FontStyle.italic),
                                          ),
                                          labelText: "(Specify)",
                                          controller: _pestDescription,
                                          // validator: (input) => _establishment
                                          //         .contains("Other")
                                          //     ? input!.trim().isEmpty
                                          //         ? 'Please specify type of establishment'
                                          //         : null
                                          //     : null,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(
                                    height: 10,
                                    child: Divider(
                                      color: Colors.transparent,
                                    ),
                                  ),
                                  // any diseases
                                  Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(0.0),
                                        child: SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: const Text(
                                            "Have you noticed any signs of disease on the seedlings?",
                                            softWrap: true,
                                            overflow: TextOverflow.clip,
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          GenderRadioButton(
                                            value: 1,
                                            group: _signsDiseaseYesNoRadio,
                                            selected: (val) {
                                              print(val);
                                              setState(() {
                                                _signsDiseaseYesNoRadio = val;
                                                print(val);
                                                _signsDiseaseYesNoValue = "Yes";
                                              });
                                            },
                                          ),
                                          const Text(
                                            "Yes",
                                            // style: TextStyle(
                                            //     color: Color(0xFFf9f9f9)),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          GenderRadioButton(
                                            value: 2,
                                            group: _signsDiseaseYesNoRadio,
                                            selected: (val) {
                                              print(val);
                                              setState(() {
                                                _signsDiseaseYesNoRadio = val;
                                                _signsDiseaseYesNoValue = "No";
                                              });
                                            },
                                          ),
                                          const Text(
                                            "No",
                                            // style: TextStyle(
                                            //     color:
                                            //         Color(0xFFf9f9f9))
                                          ),
                                        ],
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            // left: 10.0,
                                            // right: 10.0,
                                            bottom: 8.0),
                                        child: TextFieldWidget(
                                          readonly:
                                              _signsDiseaseYesNoValue == "Yes"
                                                  ? false
                                                  : true,
                                          decoration: const InputDecoration(
                                            hintText: "(Specify)",
                                            hintStyle: TextStyle(
                                                fontStyle: FontStyle.italic),
                                          ),
                                          labelText: "(Specify)",
                                          controller: _diseaseDescription,
                                          // validator: (input) => _establishment
                                          //         .contains("Other")
                                          //     ? input!.trim().isEmpty
                                          //         ? 'Please specify type of establishment'
                                          //         : null
                                          //     : null,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                              child: Divider(
                                color: Colors.transparent,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: fDefaultPadding),
                              child: Center(
                                child: Text(
                                  "Maintenance and Care",
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(0.0),
                                        child: SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: const Text(
                                            "Were any fertilizers or any soil ammendments applied?",
                                            softWrap: true,
                                            overflow: TextOverflow.clip,
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          GenderRadioButton(
                                            value: 1,
                                            group: _fertiliserAppliedYesNoRadio,
                                            selected: (val) {
                                              print(val);
                                              setState(() {
                                                _fertiliserAppliedYesNoRadio =
                                                    val;
                                                print(val);
                                                _fertiliserAppliedYesNoValue =
                                                    "Yes";
                                              });
                                            },
                                          ),
                                          const Text(
                                            "Yes",
                                            // style: TextStyle(
                                            //     color: Color(0xFFf9f9f9)),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          GenderRadioButton(
                                            value: 2,
                                            group: _fertiliserAppliedYesNoRadio,
                                            selected: (val) {
                                              print(val);
                                              setState(() {
                                                _fertiliserAppliedYesNoRadio =
                                                    val;
                                                _fertiliserAppliedYesNoValue =
                                                    "No";
                                              });
                                            },
                                          ),
                                          const Text(
                                            "No",
                                            // style: TextStyle(
                                            //     color:
                                            //         Color(0xFFf9f9f9))
                                          ),
                                        ],
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            // left: 10.0,
                                            // right: 10.0,
                                            bottom: 8.0),
                                        child: TextFieldWidget(
                                          readonly:
                                              _fertiliserAppliedYesNoValue ==
                                                      "Yes"
                                                  ? false
                                                  : true,
                                          decoration: const InputDecoration(
                                            hintText: "(Specify)",
                                            hintStyle: TextStyle(
                                                fontStyle: FontStyle.italic),
                                          ),
                                          labelText: "(Specify)",
                                          controller: _fertiliserType,
                                          // validator: (input) => _establishment
                                          //         .contains("Other")
                                          //     ? input!.trim().isEmpty
                                          //         ? 'Please specify type of establishment'
                                          //         : null
                                          //     : null,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                              child: Divider(
                                color: Colors.transparent,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(0.0),
                                        child: SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: const Text(
                                            "Were any pesticide or herbicide applied?",
                                            softWrap: true,
                                            overflow: TextOverflow.clip,
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          GenderRadioButton(
                                            value: 1,
                                            group:
                                                _pesticideHerbicideAppliedYesNoRadio,
                                            selected: (val) {
                                              print(val);
                                              setState(() {
                                                _pesticideHerbicideAppliedYesNoRadio =
                                                    val;
                                                print(val);
                                                _pesticideHerbicideAppliedYesNoValue =
                                                    "Yes";
                                              });
                                            },
                                          ),
                                          const Text(
                                            "Yes",
                                            // style: TextStyle(
                                            //     color: Color(0xFFf9f9f9)),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          GenderRadioButton(
                                            value: 2,
                                            group:
                                                _pesticideHerbicideAppliedYesNoRadio,
                                            selected: (val) {
                                              print(val);
                                              setState(() {
                                                _pesticideHerbicideAppliedYesNoRadio =
                                                    val;
                                                _pesticideHerbicideAppliedYesNoValue =
                                                    "No";
                                              });
                                            },
                                          ),
                                          const Text(
                                            "No",
                                            // style: TextStyle(
                                            //     color:
                                            //         Color(0xFFf9f9f9))
                                          ),
                                        ],
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            // left: 10.0,
                                            // right: 10.0,
                                            bottom: 8.0),
                                        child: TextFieldWidget(
                                          readonly:
                                              _pesticideHerbicideAppliedYesNoValue ==
                                                      "Yes"
                                                  ? false
                                                  : true,
                                          decoration: const InputDecoration(
                                            hintText: "(Specify)",
                                            hintStyle: TextStyle(
                                                fontStyle: FontStyle.italic),
                                          ),
                                          labelText: "(Specify)",
                                          controller: _pesticideHerbicideType,
                                          // validator: (input) => _establishment
                                          //         .contains("Other")
                                          //     ? input!.trim().isEmpty
                                          //         ? 'Please specify type of establishment'
                                          //         : null
                                          //     : null,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                              child: Divider(
                                color: Colors.transparent,
                              ),
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.symmetric(
                            //       vertical: fDefaultPadding),
                            //   child: Center(
                            //     child: Text(
                            //       "Additional Observations and Comments",
                            //       style: TextStyle(
                            //           fontSize: 20.0, fontWeight: FontWeight.bold),
                            //     ),
                            //   ),
                            // ),
                            // titleOne("Additional Observations and Comments"),

                            Container(
                              margin: const EdgeInsets.all(8.0),
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: const Text(
                                        "Please provide any other observations, comments or recommendations for improving the survival rate of the seedlings",
                                        softWrap: true,
                                        overflow: TextOverflow.clip,
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // formFieldLabel(width: size.width * .9, 
                            //     "Please provide any other observations, comments or recommendations for improving the survival rate of the seedlings"),
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 10.0, right: 10.0, bottom: 8.0),
                              child: TextFieldWidget(
                                readonly: false,
                                decoration: const InputDecoration(
                                  labelText:
                                      "Please provide any other observations, comments or recommendations for improving the survival rate of the seedlings",
                                  hintStyle:
                                      TextStyle(fontStyle: FontStyle.italic),
                                ),
                                controller: _additionalObservations,
                                // validator: (input) => _establishment
                                //         .contains("Other")
                                //     ? input!.trim().isEmpty
                                //         ? 'Please specify type of establishment'
                                //         : null
                                //     : null,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              color: const Color(0xFFFFFFFF),
                              child: Column(
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 50.00,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10.0),
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
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
                                                "Submit Data",
                                                style: TextStyle(
                                                    color: fPrimaryWhite,
                                                    fontSize: 17.0,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                              onPressed: () async {
                                                getAllSSRValuesT();
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  submissionOptions(
                                                    context,
                                                    "Do you have internet data?",
                                                    "Send with internet",
                                                    "Send later",
                                                    "Cancel",
                                                    approvePress: () =>
                                                        attemptUpload(context),
                                                    editPress: () {
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
                                                              IndexPage(),
                                                        ),
                                                      );
                                                      regSP?.clear();
                                                    },
                                                    disapprovePress: () => null,
                                                  );
                                                }
                                              },
                                            ),
                                          ),
                                          // Container(
                                          //   width:
                                          //       MediaQuery.of(context).size.width / 3,
                                          //   height: 50.00,
                                          //   child: ElevatedButton(
                                          //     style: ElevatedButton.styleFrom(
                                          //       elevation: 0.0,
                                          //       backgroundColor: fPrimaryColour,
                                          //       shape: RoundedRectangleBorder(
                                          //         borderRadius:
                                          //             BorderRadius.circular(10.0),
                                          //       ),
                                          //       textStyle: const TextStyle(
                                          //           color: Colors.white),
                                          //       // shadowColor: fPrimaryColour,
                                          //       side: const BorderSide(
                                          //           width: 1.0,
                                          //           color: fPrimaryColour),
                                          //     ),
                                          //     child: Text(
                                          //       "Skip",
                                          //       style: TextStyle(
                                          //           color: fPrimaryWhite,
                                          //           fontSize: 17.0,
                                          //           fontWeight: FontWeight.normal),
                                          //     ),
                                          //     onPressed: () async {
                                          //       regSP?.setBool(
                                          //           "farmdetskipped", true);
                                          //       // if (_establishment.isEmpty) {
                                          //       //   overlayNotification(
                                          //       //       'Please select type of establishment',
                                          //       //       "negative");
                                          //       // } else {
                                          //       setSSR7ValuesT();
                                          //       Navigator.of(context).push(
                                          //         CupertinoPageRoute(
                                          //           builder: (BuildContext context) =>
                                          //               SeedlingMonitoringPlantedDetails(),
                                          //         ),
                                          //       );

                                          //       // print(
                                          //       //     "Selected types are $_establishment");
                                          //       // }
                                          //     },
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
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
          ),
        ],
      ),
    );
  }
}
