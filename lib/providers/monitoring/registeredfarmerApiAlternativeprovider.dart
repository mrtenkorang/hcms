import 'package:flutter/foundation.dart';
import 'package:hcms_revived2/models/localdbmodel/localdbmodel.dart';
import '../../helpers/dbhelper.dart';

import 'package:intl/intl.dart';

class RegisteredFarmerListApiAlternativeApiProvider extends ChangeNotifier {
  static var newdate = DateTime.now();
  static var formatDate = DateFormat('MMM d, y');
  String formattedDat = formatDate.format(newdate);

  List<RegisteredFarmerListApiAlternative> _falALists = [];

  List<RegisteredFarmerListApiAlternative> get falALists {
    return [..._falALists];
  }

  RegisteredFarmerListApiAlternative findById(String id) {
    return _falALists.firstWhere((monitoring) => monitoring.falAId == id);
  }

  void addRegisteredFarmerListApiAlternative(
    String pickedid,
    String pickedfalAFarmerName,
    String pickedfalACommunityName,
    String pickedfalACommunityId,
    String pickedfalAContact,
    String pickedfalABaseline,
  ) {
    final newRegisteredFarmerListApiAlternative =
        RegisteredFarmerListApiAlternative(
      falAId: pickedid,
      falAFarmerName: pickedfalAFarmerName,
      falACommunityName: pickedfalACommunityName,
      falACommunityId: pickedfalACommunityId,
      falAContact: pickedfalAContact,
      falABaseline: pickedfalABaseline,
      dateCreated: DateTime.now().toString(),
    );
    _falALists.add(newRegisteredFarmerListApiAlternative);
    // _falALists.insert(0, newRegisteredFarmerListApiAlternative);
    notifyListeners();

    DBHelper.insert('farmer_api_list_alternative', {
      'id': newRegisteredFarmerListApiAlternative.falAId!,
      'falAFarmerName': newRegisteredFarmerListApiAlternative.falAFarmerName!,
      'falACommunityName':
          newRegisteredFarmerListApiAlternative.falACommunityName!,
      'falACommunityId': newRegisteredFarmerListApiAlternative.falACommunityId!,
      'falAContact': newRegisteredFarmerListApiAlternative.falAContact!,
      'falABaseline': newRegisteredFarmerListApiAlternative.falABaseline!,
      'dateCreated': newRegisteredFarmerListApiAlternative.dateCreated!,
    });
  }

  Future<void> fetchAndSetRegisteredFarmerListApiAlternative() async {
    final dataList = await DBHelper.fetchData('farmer_api_list_alternative');
    _falALists = dataList
        .map(
          (falALists) => RegisteredFarmerListApiAlternative(
            falAId: falALists['id'],
            falAFarmerName: falALists['falAFarmerName'],
            falACommunityName: falALists['falACommunityName'],
            falACommunityId: falALists['falACommunityId'],
            falAContact: falALists['falAContact'],
            falABaseline: falALists['falABaseline'],
            dateCreated: falALists['dateCreated'],
          ),
        )
        .toList();
    notifyListeners();
  }
}
