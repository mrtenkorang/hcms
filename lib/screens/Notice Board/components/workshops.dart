import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/boilerplate/widgets.dart';
import 'package:hcms_revived2/helpers/dbhelper.dart';
import 'package:hcms_revived2/providers/notifications/trainingsandworkshops.dart';
import 'package:hcms_revived2/screens/home/index.dart';
import 'package:provider/provider.dart';

class WorkShops extends StatefulWidget {
  const WorkShops({Key? key}) : super(key: key);

  @override
  State<WorkShops> createState() => _WorkShopsState();
}

class _WorkShopsState extends State<WorkShops> {
  @override
  void initState() {
    super.initState();
  }

  var refreshKey = GlobalKey<RefreshIndicatorState>();

  Future<bool> _onbackPressed() {
    return Navigator.of(context)
        .pushAndRemoveUntil(
            CupertinoPageRoute(builder: (c) => IndexPage()), (route) => false)
        .then((value) => value);
    // Navigator.popUntil(context, true);

    // throw ("wrong here");
  }

  @override
  Widget build(BuildContext context) {
    Future<Null> refreshList() async {
      refreshKey.currentState?.show(atTop: true);
      await Future.delayed(Duration(seconds: 2));
      setState(() {
        WillPopScope(
          onWillPop: _onbackPressed,
          child: Container(
            child: Material(
              child: FutureBuilder(
                future: Provider.of<TrainingWorkShopsProvider>(context,
                        listen: false)
                    .fetchAndSetWorkShops(),
                builder: (ctx, snapshot) => snapshot.connectionState ==
                        ConnectionState.waiting
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Consumer<TrainingWorkShopsProvider>(
                        child: Center(
                          child: const Text('No Scheduled Workshops.'),
                        ),
                        builder: (ctx, wsNotif, ch) => Container(
                          height: MediaQuery.of(context).size.height,
                          child: wsNotif.workShopsLists.length <= 0
                              ? ch
                              : RefreshIndicator(
                                  key: refreshKey,
                                  onRefresh: refreshList,
                                  child: ListView.builder(
                                      physics: ScrollPhysics(
                                          parent:
                                              AlwaysScrollableScrollPhysics()),
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount: wsNotif.workShopsLists.length,
                                      itemBuilder: (ctx, i) {
                                        int itemCount =
                                            wsNotif.workShopsLists.length;
                                        int reversedIndex = itemCount - 1 - i;

                                        return SingleChildScrollView(
                                          child: Column(
                                            children: <Widget>[
                                              SizedBox(height: 10),
                                              // Container(
                                              //   height: 160,
                                              //   decoration: BoxDecoration(),
                                              // ),

                                              Container(
                                                // padding: const EdgeInsets.all(2.0),
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5.0,
                                                        vertical: 5.0),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              10.0)),
                                                  border: Border(
                                                    top: BorderSide(
                                                        width: .5,
                                                        color: fPrimaryColour),
                                                    bottom: BorderSide(
                                                        width: .5,
                                                        color: fPrimaryColour),
                                                    left: BorderSide(
                                                        width: .5,
                                                        color: fPrimaryColour),
                                                    right: BorderSide(
                                                        width: .5,
                                                        color: fPrimaryColour),
                                                  ),
                                                  // color: fSecondaryColour,
                                                  // color: color,
                                                ),
                                                child: ListTile(
                                                  leading: CircleAvatar(
                                                    radius: 23.0,
                                                    backgroundColor:
                                                        fPrimarySilver,
                                                    child: CircleAvatar(
                                                      radius: 22.0,
                                                      backgroundColor:
                                                          fPrimaryWhite,
                                                      child: Icon(Icons.mail,
                                                          color:
                                                              fPrimaryColour),
                                                    ),
                                                  ),
                                                  title: Row(
                                                    children: [
                                                      Text(
                                                        wsNotif
                                                            .workShopsLists[
                                                                reversedIndex]
                                                            .wsTitle,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w800),
                                                      ),
                                                      Text(
                                                        wsNotif
                                                            .workShopsLists[
                                                                reversedIndex]
                                                            .wsTimeDisplay,
                                                        style: TextStyle(
                                                            fontSize: 11.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      ),
                                                    ],
                                                  ),
                                                  subtitle: Text(wsNotif
                                                      .workShopsLists[
                                                          reversedIndex]
                                                      .wsContent),
                                                  trailing: IconButton(
                                                      onPressed: () {
                                                        submissionOptions(
                                                            context,
                                                            "Are you sure you want to delete?",
                                                            "Yes",
                                                            "",
                                                            "No",
                                                            approvePress: () {
                                                          DBHelper.deleteMV(
                                                              "workshops",
                                                              wsNotif
                                                                  .workShopsLists[
                                                                      reversedIndex]
                                                                  .wsId);

                                                          Provider.of<TrainingWorkShopsProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .fetchAndSetWorkShops();
                                                        },
                                                            editPress: () {},
                                                            disapprovePress:
                                                                () {});
                                                      },
                                                      icon: Icon(
                                                          Icons.delete_forever,
                                                          color: Colors
                                                              .redAccent)),
                                                ),
                                              ),
                                              // Divider(
                                              //   thickness: 2.0,
                                              // )
                                            ],
                                          ),
                                        );
                                      }),
                                ),
                        ),
                      ),
              ),
            ),
          ),
        );
      });
    }

    return WillPopScope(
      onWillPop: _onbackPressed,
      child: Container(
        child: Material(
          child: FutureBuilder(
            future:
                Provider.of<TrainingWorkShopsProvider>(context, listen: false)
                    .fetchAndSetWorkShops(),
            builder: (ctx, snapshot) => snapshot.connectionState ==
                    ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Consumer<TrainingWorkShopsProvider>(
                    child: Center(
                      child: const Text('No Scheduled Workshops.'),
                    ),
                    builder: (ctx, wsNotif, ch) => Container(
                      height: MediaQuery.of(context).size.height,
                      child: wsNotif.workShopsLists.length <= 0
                          ? ch
                          : RefreshIndicator(
                              key: refreshKey,
                              onRefresh: refreshList,
                              child: ListView.builder(
                                  physics: ScrollPhysics(
                                      parent: AlwaysScrollableScrollPhysics()),
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: wsNotif.workShopsLists.length,
                                  itemBuilder: (ctx, i) {
                                    int itemCount =
                                        wsNotif.workShopsLists.length;
                                    int reversedIndex = itemCount - 1 - i;

                                    return SingleChildScrollView(
                                      child: Column(
                                        children: <Widget>[
                                          SizedBox(height: 10),
                                          // Container(
                                          //   height: 160,
                                          //   decoration: BoxDecoration(),
                                          // ),
                                          Container(
                                            // padding: const EdgeInsets.all(2.0),
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 5.0, vertical: 5.0),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0)),
                                              border: Border(
                                                top: BorderSide(
                                                    width: .5,
                                                    color: fPrimaryColour),
                                                bottom: BorderSide(
                                                    width: .5,
                                                    color: fPrimaryColour),
                                                left: BorderSide(
                                                    width: .5,
                                                    color: fPrimaryColour),
                                                right: BorderSide(
                                                    width: .5,
                                                    color: fPrimaryColour),
                                              ),
                                              // color: fSecondaryColour,
                                              // color: color,
                                            ),
                                            child: ListTile(
                                              leading: CircleAvatar(
                                                radius: 23.0,
                                                backgroundColor: fPrimarySilver,
                                                child: CircleAvatar(
                                                  radius: 22.0,
                                                  backgroundColor:
                                                      fPrimaryWhite,
                                                  child: Icon(Icons.mail,
                                                      color: fPrimaryColour),
                                                ),
                                              ),
                                              title: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    wsNotif
                                                        .workShopsLists[
                                                            reversedIndex]
                                                        .wsTitle,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w800),
                                                  ),
                                                  Text(
                                                    wsNotif
                                                        .workShopsLists[
                                                            reversedIndex]
                                                        .wsTimeDisplay,
                                                    style: TextStyle(
                                                        fontSize: 11.0,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ],
                                              ),
                                              subtitle: Text(wsNotif
                                                  .workShopsLists[reversedIndex]
                                                  .wsContent),
                                              trailing: IconButton(
                                                  onPressed: () {
                                                    submissionOptions(
                                                        context,
                                                        "Are you sure you want to delete?",
                                                        "Yes",
                                                        "",
                                                        "No", approvePress: () {
                                                      DBHelper.deleteMV(
                                                          "workshops",
                                                          wsNotif
                                                              .workShopsLists[
                                                                  reversedIndex]
                                                              .wsId);

                                                      Provider.of<TrainingWorkShopsProvider>(
                                                              context,
                                                              listen: false)
                                                          .fetchAndSetWorkShops();
                                                    },
                                                        editPress: () {},
                                                        disapprovePress: () {});
                                                  },
                                                  icon: Icon(
                                                      Icons.delete_forever,
                                                      color: Colors.redAccent)),
                                            ),
                                          ),
                                          // Divider(
                                          //   thickness: 2.0,
                                          // )
                                        ],
                                      ),
                                    );
                                  }),
                            ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
