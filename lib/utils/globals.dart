import 'package:intl/date_symbol_data_file.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

// SharedPreferences? regSP;

// Future<SharedPreferences> initiateSharedPreferences() async {
//   return regSP = await SharedPreferences.getInstance();
// }

// AppLocalizations? localizationsInit(ctx) {
//   appLocalizations = AppLocalizations.of(ctx);
//   return appLocalizations;
// }

var newdate = DateTime.now();
var formatDate = DateFormat('y-MM-dd');
var formatDateReadable = DateFormat('dd MMMM, y');
var formatDateAlt = DateFormat('dd-MM-y');
var formatDateOfBirth = DateFormat('dd/MM/y');
var formatDateOfBirthAlt = DateFormat('dd-MM-y');
var formatTime = DateFormat('hh:mma', "en_GB");

// for custom version control
// var formatDateCodedVersioning =
//     DateFormat('v.dd.MM.y-H.m-b.$currentDatabaseVersion');

NumberFormat currencyformatter =
    NumberFormat.currency(name: "", decimalDigits: 2);
// NumberFormat currencyformatter =
//     NumberFormat.currency(name: "GHS ", decimalDigits: 2);

// for Mr. Ernest api
// for sending over to the api
String formattedDate = formatDate.format(newdate);

// for user readability
String readableformattedDate = formatDateReadable.format(newdate);

var uuid = Uuid();

String? dropDownEqualiser;

int notificationCount = 0;

NumberFormat numberformatter = NumberFormat("###,###.0#");

int weeksBetween(DateTime from, DateTime to) {
  from = DateTime.utc(from.year, from.month, from.day);
  to = DateTime.utc(to.year, to.month, to.day);
  return (to.difference(from).inDays / 7).ceil();
}

final now = DateTime.now();
final firstJan = DateTime(now.year, 1, 1);
final weekNumber = weeksBetween(firstJan, now);

String firstLetterCap(String value) {
  return toBeginningOfSentenceCase(value)!;
}

// void initLocale() {
//   initializeDateFormatting('en_GB');
// }
