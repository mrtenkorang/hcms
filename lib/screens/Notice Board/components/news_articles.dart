import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/boilerplate/widgets.dart';
import 'package:hcms_revived2/helpers/dbhelper.dart';
import 'package:hcms_revived2/providers/notifications/newsandarticlesprovider.dart';
import 'package:hcms_revived2/screens/home/index.dart';
import 'package:provider/provider.dart';

class NewsArticles extends StatefulWidget {
  const NewsArticles({Key? key}) : super(key: key);

  @override
  State<NewsArticles> createState() => _NewsArticlesState();
}

class _NewsArticlesState extends State<NewsArticles> {
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
      refreshKey.currentState?.show(atTop: false);
      await Future.delayed(Duration(seconds: 2));
      setState(() {
        WillPopScope(
          onWillPop: _onbackPressed,
          child: Container(
            child: Material(
              child: FutureBuilder(
                future:
                    Provider.of<NewsAndArticlesProvider>(context, listen: false)
                        .fetchAndSetNewsAndArticles(),
                builder: (ctx, snapshot) => snapshot.connectionState ==
                        ConnectionState.waiting
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Consumer<NewsAndArticlesProvider>(
                        child: Center(
                          child: const Text('No News Articles.'),
                        ),
                        builder: (ctx, naNotif, ch) => Container(
                          height: MediaQuery.of(context).size.height,
                          child: naNotif.newsArticlesLists.length <= 0
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
                                      itemCount:
                                          naNotif.newsArticlesLists.length,
                                      itemBuilder: (ctx, i) {
                                        int itemCount =
                                            naNotif.newsArticlesLists.length;
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
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        naNotif
                                                            .newsArticlesLists[
                                                                reversedIndex]
                                                            .naTitle,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w800),
                                                      ),
                                                      Text(
                                                        naNotif
                                                            .newsArticlesLists[
                                                                reversedIndex]
                                                            .naTimeDisplay,
                                                        style: TextStyle(
                                                            fontSize: 13.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      ),
                                                    ],
                                                  ),
                                                  subtitle: Text(naNotif
                                                      .newsArticlesLists[
                                                          reversedIndex]
                                                      .naContent),
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
                                                              "news_and_articles",
                                                              naNotif
                                                                  .newsArticlesLists[
                                                                      reversedIndex]
                                                                  .naId);

                                                          Provider.of<NewsAndArticlesProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .fetchAndSetNewsAndArticles();
                                                        },
                                                            editPress: () {},
                                                            disapprovePress:
                                                                () {});
                                                      },
                                                      icon: Icon(Icons.delete,
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
            future: Provider.of<NewsAndArticlesProvider>(context, listen: false)
                .fetchAndSetNewsAndArticles(),
            builder: (ctx, snapshot) => snapshot.connectionState ==
                    ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Consumer<NewsAndArticlesProvider>(
                    child: Center(
                      child: const Text('No News Articles.'),
                    ),
                    builder: (ctx, naNotif, ch) => Container(
                      height: MediaQuery.of(context).size.height,
                      child: naNotif.newsArticlesLists.length <= 0
                          ? ch
                          : RefreshIndicator(
                              key: refreshKey,
                              onRefresh: refreshList,
                              child: ListView.builder(
                                  // reverse: true,
                                  physics: ScrollPhysics(
                                      parent: AlwaysScrollableScrollPhysics()),
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: naNotif.newsArticlesLists.length,
                                  itemBuilder: (ctx, i) {
                                    int itemCount =
                                        naNotif.newsArticlesLists.length;
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
                                              title: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    naNotif
                                                        .newsArticlesLists[
                                                            reversedIndex]
                                                        .naTitle,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w800),
                                                  ),
                                                  Text(
                                                    naNotif
                                                        .newsArticlesLists[
                                                            reversedIndex]
                                                        .naTimeDisplay,
                                                    style: TextStyle(
                                                        fontSize: 13.0,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ],
                                              ),
                                              subtitle: Text(naNotif
                                                  .newsArticlesLists[
                                                      reversedIndex]
                                                  .naContent),
                                              trailing: IconButton(
                                                  onPressed: () {
                                                    submissionOptions(
                                                        context,
                                                        "Are you sure you want to delete?",
                                                        "Yes",
                                                        "",
                                                        "No", approvePress: () {
                                                      DBHelper.deleteMV(
                                                          "news_and_articles",
                                                          naNotif
                                                              .newsArticlesLists[
                                                                  reversedIndex]
                                                              .naId);

                                                      Provider.of<NewsAndArticlesProvider>(
                                                              context,
                                                              listen: false)
                                                          .fetchAndSetNewsAndArticles();
                                                    },
                                                        editPress: () {},
                                                        disapprovePress: () {});
                                                  },
                                                  icon: Icon(Icons.delete,
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
