
import 'package:flutter/material.dart';

class ModuleDisplayLayout{
  static int grid = 0;
  static int list = 1;
}

class ModuleImageDisplayType{
  static int icon = 0;
  static int backgroundImage = 1;
}

class AlertDialogStatus{
  static int error = 0;
  static int info = 1;
  static int success = 2;
}

// class UserIsLoggedIn{
//   static int yes = 1;
//   static int no = 0;
// }


class SharedPref{
  static String user = 'user';
  static String loggedIn = 'loggedIn';
  static String serverURL = 'serverURL';
  static String appVersionFromServer = 'appVersionFromServer';
  static String activationTimestamp = 'activationTimestamp';
  static String buildNumber = 'buildNumber';
  


  // static String hasSubscribedToMessagingTopic = 'hasSubscribedToMessagingTopic';
}


class Gender{
  static String none = "none";
  static String male = "Male";
  static String female = "female";
}


class TMTRequestStatus{
  static String pending = "0";
  static String approved = "1";
  static String deleted = "2";
  static String rejected = "3";
  static String collected = "4";

  String getStatus(status) {
    if (status == pending){
      return "Pending";
    }else if (status == approved){
      return "Approved";
    }else if (status == deleted){
      return "Deleted";
    }else if (status == rejected){
      return "Rejected";
    }else if (status == collected){
      return "Collected";
    }else{
      return "Unknown";
    }
  }

  Color getStatusColor(status) {
    if (status == pending){
      return Colors.amber;
    }else if (status == approved){
      return Colors.green;
    }else if (status == deleted){
      return Colors.blueGrey;
    }else if (status == rejected){
      return Colors.red;
    }else if (status == collected){
      return Colors.green;
    }else{
      return Colors.white;
    }
  }

}


class TMTTagHasBatchNumber{
  static String yes = "1";
  static String no = "0";
}
