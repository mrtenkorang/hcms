import 'package:flutter/foundation.dart';
import 'package:hcms_revived2/models/localdbmodel/localdbmodel.dart';
import '../../helpers/dbhelper.dart';

import 'package:intl/intl.dart';

class RegisteredFarmerProvider extends ChangeNotifier {
  static var newdate = DateTime.now();
  static var formatDate = DateFormat('MMM d, y');
  String formattedDat = formatDate.format(newdate);

  List<RegisteredFarmer> _foLists = [];

  List<RegisteredFarmer> get foLists {
    return [..._foLists];
  }

  RegisteredFarmer findById(String id) {
    return _foLists.firstWhere((monitoring) => monitoring.foId == id);
  }

  void addRegisteredFarmer(
    String pickedfoCommunity,
    String pickedfoFarmerName,
    String pickedfoContact,
    String pickedfoGender,
    String pickedfoDoB,
    String pickedfoHolderCategory,
    String pickedfoFarmSize,
    String pickedfoConStat,
  ) {
    final newRegisteredFarmer = RegisteredFarmer(
      foId: DateTime.now().toString(),
      foCommunity: pickedfoCommunity,
      foFarmerName: pickedfoFarmerName,
      foContact: pickedfoContact,
      foGender: pickedfoGender,
      foDoB: pickedfoDoB,
      foHolderCategory: pickedfoHolderCategory,
      foFarmSize: pickedfoFarmSize,
      foConStat: pickedfoConStat,
    );
    _foLists.add(newRegisteredFarmer);
    // _foLists.insert(0, newRegisteredFarmer);
    notifyListeners();

    DBHelper.insert('farmer_offline', {
      'id': newRegisteredFarmer.foId!,
      'foCommunity': newRegisteredFarmer.foCommunity!,
      'foFarmerName': newRegisteredFarmer.foFarmerName!,
      'foContact': newRegisteredFarmer.foContact!,
      'foGender': newRegisteredFarmer.foGender!,
      'foDoB': newRegisteredFarmer.foDoB!,
      'foHolderCategory': newRegisteredFarmer.foHolderCategory!,
      'foFarmSize': newRegisteredFarmer.foFarmSize!,
      'foConStat': newRegisteredFarmer.foConStat!,
    });
  }

  Future<void> fetchAndSetRegisteredFarmer() async {
    final dataList = await DBHelper.fetchData('farmer_offline');
    _foLists = dataList
        .map(
          (foLists) => RegisteredFarmer(
            foId: foLists['id'],
            foCommunity: foLists['foCommunity'],
            foFarmerName: foLists['foFarmerName'],
            foContact: foLists['foContact'],
            foGender: foLists['foGender'],
            foDoB: foLists['foDoB'],
            foHolderCategory: foLists['foHolderCategory'],
            foFarmSize: foLists['foFarmSize'],
            foConStat: foLists['foConStat'],
          ),
        )
        .toList();
    notifyListeners();
  }
}
