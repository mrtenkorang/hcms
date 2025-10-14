import 'package:hcms_revived2/helpers/dbhelper.dart';

// enumerator data
int? enumeratorvalue;
String displayname = "";
String enumeratorDesignation = "";

Future<dynamic> getEnumeratorValue() async {
  final db = await DBHelper.database();
  var count = await db.rawQuery('SELECT * FROM first_time_user');

  var list = count.toList();

  list.isNotEmpty
      ? enumeratorvalue = int.parse(list[0]['enumeratorValue'].toString())
      : null;
  list.isNotEmpty
      ? displayname =
          "${list[0]['firstName'].toString()} ${list[0]['lastName'].toString()}"
      : null;
  list.isNotEmpty
      ? enumeratorDesignation = list[0]['enumeratorDesignation'].toString()
      : null;

  print("Enummem - $enumeratorvalue");

  return list;
}
// end of enumerator value
