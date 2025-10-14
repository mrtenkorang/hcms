import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/screens/farmregistration/farmdetails/farmdetails.dart';
import 'package:hcms_revived2/screens/home/index.dart';

import '../../../main.dart';
import 'components/groupdetails.dart';

class Group extends StatefulWidget {
  final String? retcompanyDirectors;
  final String? retgroupName;
  final String? retgroupPresident;
  final String? retgroupSecretary;
  final String? retgroupPhone;
  final String? retgroupregNumb;
  final String? retgroupEmail;
  final String? retgroupAddress;

  const Group(
      {Key? key,
      this.retcompanyDirectors,
      this.retgroupName,
      this.retgroupPresident,
      this.retgroupSecretary,
      this.retgroupPhone,
      this.retgroupregNumb,
      this.retgroupEmail,
      this.retgroupAddress})
      : super(key: key);
  @override
  _GroupState createState() => _GroupState();
}

class _GroupState extends State<Group> {
  @override
  Widget build(BuildContext context) {
    return GroupDetails(
      retcompanyDirectors: widget.retcompanyDirectors,
      retgroupName: widget.retgroupName,
      retgroupPresident: widget.retgroupPresident,
      retgroupSecretary: widget.retgroupSecretary,
      retgroupPhone: widget.retgroupPhone,
      retgroupregNumb: widget.retgroupregNumb,
      retgroupEmail: widget.retgroupEmail,
      retgroupAddress: widget.retgroupAddress,
    );
  }
}
