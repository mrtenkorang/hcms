// import 'package:flutter/foundation.dart';
// import 'package:hcms_revived2/models/localdbmodel/localdbmodel.dart';
// import '../../helpers/dbhelper.dart';
//
// import 'package:intl/intl.dart';
//
// class TrainingLogProvider extends ChangeNotifier {
//   static var newdate = DateTime.now();
//   static var formatDate = DateFormat('MMM d, y');
//   String formattedDat = formatDate.format(newdate);
//
//   List<TrainingLog> _tlLists = [];
//
//   List<TrainingLog> get tlLists {
//     return [..._tlLists];
//   }
//
//   TrainingLog findById(String id) {
//     return _tlLists.firstWhere((monitoring) => monitoring.tlId == id);
//   }
//
//   void addTrainingLog(
//     String pickedtlCommunityName,
//     String pickedtlTopic,
//     String pickedtlEventDate,
//     String pickedtlDuration,
//     String pickedtlTrainerName,
//     String pickedtlTrainerOrg,
//     String pickedtlEnumeratorValue,
//     String pickedtlParticipantDetails,
//     String pickedtlConStat,
//   ) {
//     final newTrainingLog = TrainingLog(
//       tlId: DateTime.now().toString(),
//       tlTimeDisplay: formattedDat,
//       tlCommunityName: pickedtlCommunityName,
//       tlTopic: pickedtlTopic,
//       tlEventDate: pickedtlEventDate,
//       tlDuration: pickedtlDuration,
//       tlTrainerName: pickedtlTrainerName,
//       tlTrainerOrg: pickedtlTrainerOrg,
//       tlEnumeratorValue: pickedtlEnumeratorValue,
//       tlParticipantDetails: pickedtlParticipantDetails,
//       tlConStat: pickedtlConStat,
//     );
//     _tlLists.add(newTrainingLog);
//     // _tlLists.insert(0, newTrainingLog);
//     notifyListeners();
//
//     DBHelper.insert('training_log', {
//       'id': newTrainingLog.tlId!,
//       'tlTimeDisplay': newTrainingLog.tlTimeDisplay!,
//       'tlCommunityName': newTrainingLog.tlCommunityName!,
//       'tlTopic': newTrainingLog.tlTopic!,
//       'tlEventDate': newTrainingLog.tlEventDate!,
//       'tlDuration': newTrainingLog.tlDuration!,
//       'tlTrainerName': newTrainingLog.tlTrainerName!,
//       'tlTrainerOrg': newTrainingLog.tlTrainerOrg!,
//       'tlEnumeratorValue': newTrainingLog.tlEnumeratorValue!,
//       'tlParticipantDetails': newTrainingLog.tlParticipantDetails!,
//       'tlConStat': newTrainingLog.tlConStat!,
//     });
//   }
//
//   Future<void> fetchAndSetTrainingLog() async {
//     final dataList = await DBHelper.fetchData('training_log');
//     _tlLists = dataList
//         .map((tlLists) => TrainingLog(
//               tlId: tlLists['id'],
//               tlTimeDisplay: tlLists['tlTimeDisplay'],
//               tlCommunityName: tlLists['tlCommunityName'],
//               tlTopic: tlLists['tlTopic'],
//               tlEventDate: tlLists['tlEventDate'],
//               tlDuration: tlLists['tlDuration'],
//               tlTrainerName: tlLists['tlTrainerName'],
//               tlTrainerOrg: tlLists['tlTrainerOrg'],
//               tlEnumeratorValue: tlLists['tlEnumeratorValue'],
//               tlParticipantDetails: tlLists['tlParticipantDetails'],
//               tlConStat: tlLists['tlConStat'],
//             ))
//         .toList();
//     notifyListeners();
//   }
// }
