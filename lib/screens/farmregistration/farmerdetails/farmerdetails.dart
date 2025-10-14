import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/main.dart';
import 'package:hcms_revived2/screens/farmregistration/farmdetails/farmdetails.dart';
import 'package:hcms_revived2/screens/home/index.dart';

import 'components/personalDetails.dart';

class FarmerDetails extends StatefulWidget {
  final String? retfamerProfilePic;
  final String? retfarmerfirstName;
  final String? retfarmersurName;
  final String? retfarmerotherName;
  final String? retfarmerGender;
  final String? retfarmerDoB;
  final String? retfarmerPostal;
  final String? retfarmerPhoneNum;
  final String? retfarmerMail;
  final String? retkinName;
  final String? retkinPhoneNum;
  final String? retkinGender;
  final String? retkinPostal;
  final String? retkinDoB;
  final String? retkinRelationship;

  const FarmerDetails(
      {Key? key,
      this.retfamerProfilePic,
      this.retfarmerfirstName,
      this.retfarmersurName,
      this.retfarmerotherName,
      this.retfarmerGender,
      this.retfarmerDoB,
      this.retfarmerPostal,
      this.retfarmerPhoneNum,
      this.retfarmerMail,
      this.retkinName,
      this.retkinPhoneNum,
      this.retkinGender,
      this.retkinPostal,
      this.retkinDoB,
      this.retkinRelationship})
      : super(key: key);

  @override
  _FarmerDetailsState createState() => _FarmerDetailsState();
}

class _FarmerDetailsState extends State<FarmerDetails> {
  @override
  Widget build(BuildContext context) {
    return PersonalDetails(
      retfamerProfilePic: widget.retfamerProfilePic ?? "",
      retfarmerfirstName: widget.retfarmerfirstName,
      retfarmersurName: widget.retfarmersurName,
      retfarmerotherName: widget.retfarmerotherName,
      retfarmerGender: widget.retfarmerGender,
      retfarmerDoB: widget.retfarmerDoB,
      retfarmerPostal: widget.retfarmerPostal,
      retfarmerPhoneNum: widget.retfarmerPhoneNum,
      retfarmerMail: widget.retfarmerMail,
      retkinName: widget.retkinName,
      retkinPhoneNum: widget.retkinPhoneNum,
      retkinGender: widget.retkinGender,
      retkinPostal: widget.retkinPostal,
      retkinDoB: widget.retkinDoB,
      retkinRelationship: widget.retkinRelationship,
    );
  }
}
