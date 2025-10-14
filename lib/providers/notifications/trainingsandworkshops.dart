import 'package:flutter/foundation.dart';
import 'package:hcms_revived2/models/localdbmodel/localdbmodel.dart';
import './/helpers/dbhelper.dart';

import 'package:intl/intl.dart';

class TrainingWorkShopsProvider extends ChangeNotifier {
  static var newdate = DateTime.now();
  static var formatDate = DateFormat('MMM d, y');
  String formattedDat = formatDate.format(newdate);

  List<WorkShops> _workShopsLists = [];

  List<WorkShops> get workShopsLists {
    return [..._workShopsLists];
  }

  WorkShops findById(String id) {
    return _workShopsLists.firstWhere((workshops) => workshops.wsId == id);
  }

  void addTrainingsWorkshops(
    String caughtTitle,
    String caughtContent,
  ) {
    final newWorkShopsList = WorkShops(
      wsId: DateTime.now().toString(),
      wsTimeDisplay: formattedDat,
      wsTitle: caughtTitle,
      wsContent: caughtContent,
    );
    // _workShopsLists.add(newWorkShopsList);
    _workShopsLists.insert(0, newWorkShopsList);
    notifyListeners();

    DBHelper.insert('workshops', {
      'id': newWorkShopsList.wsId,
      'wsTimeDisplay': newWorkShopsList.wsTimeDisplay,
      'wsTitle': newWorkShopsList.wsTitle,
      'wsContent': newWorkShopsList.wsContent,
    });
  }

  Future<void> fetchAndSetWorkShops() async {
    final dataList = await DBHelper.fetchData('workshops');
    _workShopsLists = dataList
        .map((newWorkShopsLists) => WorkShops(
              wsId: newWorkShopsLists['id'],
              wsTimeDisplay: newWorkShopsLists['wsTimeDisplay'],
              wsTitle: newWorkShopsLists['wsTitle'],
              wsContent: newWorkShopsLists['wsContent'],
            ))
        .toList();
    notifyListeners();
  }
}
