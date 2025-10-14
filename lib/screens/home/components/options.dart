import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/boilerplate/widgets.dart';
import 'package:hcms_revived2/main.dart';
import 'package:hcms_revived2/screens/Deforestation/defquestions.dart';
import 'package:hcms_revived2/screens/Deforestation/viewdef.dart';
import 'package:hcms_revived2/screens/Notice%20Board/noticeboardview.dart';
import 'package:hcms_revived2/screens/Treespeciescatalogue/speciesgallery.dart';
import 'package:hcms_revived2/screens/farmregistration/farmerdetails/components/farmer_type_selection.dart';
import 'package:hcms_revived2/screens/farmregistration/farmerdetails/components/groupdetails.dart';
import 'package:hcms_revived2/screens/farmregistration/farmerdetails/farmerdetails.dart';
import 'package:hcms_revived2/screens/farmregistration/farmerdetails/status.dart';
import 'package:hcms_revived2/screens/seedlingmonitoring/ssr_firstpage.dart';
import 'package:hcms_revived2/screens/seedlingmonitoring/viewsubmissions/view_seedling_monitoring_reports.dart';
import 'package:hcms_revived2/screens/treemonitoring/initialpage.dart';
import 'package:hcms_revived2/screens/viewsubmissions/viewpage.dart';
import 'package:hcms_revived2/utils/widgets/textFormats/text_formats.dart';
import 'package:websafe_svg/websafe_svg.dart';

class Options extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          NewOptionsCard(
            leadingIconImage: Icon(
              Icons.notifications,
              size: 35.0,
              color: fPrimaryColour,
            ),
            trailingIconImage: CircleAvatar(
                backgroundColor: fPrimaryColour,
                child: IconButton(
                  icon: Icon(Icons.arrow_forward_ios),
                  color: fPrimaryWhite,
                  onPressed: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (BuildContext context) => NoticeBoard(),
                      ),
                    );
                  },
                )),
            tileTitle: "Notice Board",
            // escription: "",
            pressHandler: () {
              Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (BuildContext context) => NoticeBoard(),
                ),
              );
            },
          ),
          NewOptionsCard2(
            leadingIconImage: WebsafeSvg.asset(
              "lib/libassets/uxImages/tree_icon.svg",
              fit: BoxFit.cover,
              width: 35,
            ),
            trailingIconImage: CircleAvatar(
                backgroundColor: fPrimaryColour,
                child: IconButton(
                  icon: Icon(Icons.add),
                  color: fPrimaryWhite,
                  onPressed: () {
                    String? _beneficiaryType;

                    showModalBottomSheet(
                      context: context,
                      isScrollControlled:
                          false, // Important for full-height sheets
                      builder: (context) {
                        return DraggableScrollableSheet(
                          initialChildSize: 0.5, // Start at 50% height
                          minChildSize: 0.25, // Minimum 25% height
                          maxChildSize: 0.9, // Maximum 90% height
                          expand: false, // Set to true for full-screen behavior
                          builder: (BuildContext context,
                              ScrollController scrollController) {
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(16)),
                              ),
                              child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  // controller: scrollController,
                                  children: [
                                    titleOne(
                                        "Please select what best describes applicant",
                                        fontSize: 18.0),
                                    ListTile(
                                      leading: Image.asset(
                                        "assets/uxImages/farmer.png",
                                        fit: BoxFit.cover,
                                        width: 30,
                                      ),
                                      title: Text(
                                          'Farmer / Developer / Individual'),
                                      onTap: () {
                                        _beneficiaryType = "Individual";
                                        regSP?.setString('_beneficiaryType',
                                            _beneficiaryType!);

                                        Navigator.pop(context);

                                        Navigator.of(context).push(
                                          CupertinoPageRoute(
                                            builder: (BuildContext context) =>
                                                TreeFarmerSearchandType(),
                                          ),
                                        );
                                      },
                                      trailing: CircleAvatar(
                                          backgroundColor: fPrimaryColour,
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.arrow_forward_ios,
                                              size: 15.0,
                                            ),
                                            color: fPrimaryWhite,
                                            onPressed: () {
                                              _beneficiaryType = "Individual";
                                              regSP?.setString(
                                                  '_beneficiaryType',
                                                  _beneficiaryType!);

                                              Navigator.pop(context);

                                              Navigator.of(context).push(
                                                CupertinoPageRoute(
                                                  builder: (BuildContext
                                                          context) =>
                                                      TreeFarmerSearchandType(),
                                                ),
                                              );
                                            },
                                          )),
                                    ),
                                    ListTile(
                                      leading: Image.asset(
                                        "assets/uxImages/enterprise.png",
                                        fit: BoxFit.cover,
                                        width: 30,
                                      ),
                                      title: Text('Group / Company'),
                                      onTap: () {
                                        _beneficiaryType = "Group";
                                        regSP?.setString('_beneficiaryType',
                                            _beneficiaryType!);

                                        Navigator.pop(context);

                                        Navigator.of(context).push(
                                          CupertinoPageRoute(
                                            builder: (BuildContext context) =>
                                                TreeFarmerSearchandType(),
                                          ),
                                        );
                                      },
                                      trailing: CircleAvatar(
                                          backgroundColor: fPrimaryColour,
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.arrow_forward_ios,
                                              size: 15.0,
                                            ),
                                            color: fPrimaryWhite,
                                            onPressed: () {
                                              _beneficiaryType = "Group";
                                              regSP?.setString(
                                                  '_beneficiaryType',
                                                  _beneficiaryType!);

                                              Navigator.pop(context);

                                              Navigator.of(context).push(
                                                CupertinoPageRoute(
                                                  builder: (BuildContext
                                                          context) =>
                                                      TreeFarmerSearchandType(),
                                                ),
                                              );
                                            },
                                          )),
                                    ),
                                  ]),
                            );
                          },
                        );
                      },
                    );
                    // Navigator.of(context).push(
                    //   CupertinoPageRoute(
                    //     builder: (BuildContext context) => BeneficiaryStatus(),
                    //   ),
                    // );
                  },
                )),
            tileTitle: "Register Tree",
            buttonTitle: "View Registered Trees",
            color: "green",
            pressHandler: () {
              String? _beneficiaryType;

              showModalBottomSheet(
                context: context,
                isScrollControlled: false, // Important for full-height sheets
                builder: (context) {
                  return DraggableScrollableSheet(
                    initialChildSize: 0.5, // Start at 50% height
                    minChildSize: 0.25, // Minimum 25% height
                    maxChildSize: 0.9, // Maximum 90% height
                    expand: false, // Set to true for full-screen behavior
                    builder: (BuildContext context,
                        ScrollController scrollController) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(16)),
                        ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            // controller: scrollController,
                            children: [
                              titleOne(
                                  "Please select what best describes applicant",
                                  fontSize: 18.0),
                              ListTile(
                                leading: Image.asset(
                                  "assets/uxImages/farmer.png",
                                  fit: BoxFit.cover,
                                  width: 30,
                                ),
                                title: Text('Farmer / Developer / Individual'),
                                onTap: () {
                                  _beneficiaryType = "Individual";
                                  regSP?.setString(
                                      '_beneficiaryType', _beneficiaryType!);
                                },
                                trailing: CircleAvatar(
                                    backgroundColor: fPrimaryColour,
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.arrow_forward_ios,
                                        size: 15.0,
                                      ),
                                      color: fPrimaryWhite,
                                      onPressed: () {
                                        Navigator.pop(context);

                                        Navigator.of(context).push(
                                          CupertinoPageRoute(
                                            builder: (BuildContext context) =>
                                                TreeFarmerSearchandType(),
                                          ),
                                        );
                                      },
                                    )),
                              ),
                              ListTile(
                                leading: Image.asset(
                                  "assets/uxImages/enterprise.png",
                                  fit: BoxFit.cover,
                                  width: 30,
                                ),
                                title: Text('Group / Company'),
                                onTap: () {
                                  _beneficiaryType = "Group";
                                  regSP?.setString(
                                      '_beneficiaryType', _beneficiaryType!);

                                  Navigator.pop(context);

                                  Navigator.of(context).push(
                                    CupertinoPageRoute(
                                      builder: (BuildContext context) =>
                                          TreeFarmerSearchandType(),
                                    ),
                                  );
                                },
                                trailing: CircleAvatar(
                                    backgroundColor: fPrimaryColour,
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.arrow_forward_ios,
                                        size: 15.0,
                                      ),
                                      color: fPrimaryWhite,
                                      onPressed: () {
                                        _beneficiaryType = "Group";
                                        regSP?.setString('_beneficiaryType',
                                            _beneficiaryType!);

                                        Navigator.pop(context);

                                        Navigator.of(context).push(
                                          CupertinoPageRoute(
                                            builder: (BuildContext context) =>
                                                TreeFarmerSearchandType(),
                                          ),
                                        );
                                      },
                                    )),
                              ),
                            ]),
                      );
                    },
                  );
                },
              );
              // Navigator.of(context).push(
              //   CupertinoPageRoute(
              //     builder: (BuildContext context) => BeneficiaryStatus(),
              //   ),
              // );
            },
            secondaryPressHandler: () {
              Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (BuildContext context) => ViewReport(),
                ),
              );
            },
          ),
          // NewOptionsCard2(
          //   leadingIconImage: Image.asset(
          //     "lib/libassets/uxImages/plant-seedling.png",
          //     fit: BoxFit.cover,
          //     width: 35,
          //   ),
          //   trailingIconImage: CircleAvatar(
          //       backgroundColor: fPrimaryColour,
          //       child: IconButton(
          //         icon: Icon(Icons.add),
          //         color: fPrimaryWhite,
          //         onPressed: () {
          //           Navigator.of(context).push(
          //             CupertinoPageRoute(
          //               builder: (BuildContext context) => SeedlingSurvivalRateFirstPage(),
          //             ),
          //           );
          //         },
          //       )),
          //   tileTitle: "Seedling Survival Rate Survey",
          //   buttonTitle: "View Monitored Seedlings",
          //   color: "green",
          //   pressHandler: () {
          //     Navigator.of(context).push(
          //       CupertinoPageRoute(
          //         builder: (BuildContext context) => SeedlingSurvivalRateFirstPage(),
          //       ),
          //     );
          //   },
          //   secondaryPressHandler: () {
          //     Navigator.of(context).push(
          //       CupertinoPageRoute(
          //         builder: (BuildContext context) => SeedlingMonitoringViewReports(),
          //       ),
          //     );
          //   },
          // ),
          NewOptionsCard2(
            // leadingIconImage: Icon(
            //   Icons.leaderboard_rounded,
            //   size: 35.0,
            //   color: fPrimaryColour,
            // ),
            leadingIconImage: Image.asset(
              "lib/libassets/uxImages/plant-seedling.png",
              fit: BoxFit.cover,
              width: 35,
            ),
            // trailingIconImage: CircleAvatar(
            //     backgroundColor: fPrimaryColour,
            //     child: IconButton(
            //       icon: Icon(Icons.add),
            //       color: fPrimaryWhite,
            //       onPressed: () {
            //         Navigator.of(context).push(
            //           CupertinoPageRoute(
            //             builder: (BuildContext context) => BeneficiaryStatus(),
            //           ),
            //         );
            //       },
            //     )),
            tileTitle: "Landscape Monitoring",
            buttonTitle: "Monitoring Options",
            color: "green",
            pressHandler: () {
              Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (BuildContext context) => TreeMonitoringDecider(),
                ),
              );
            },
            secondaryPressHandler: () {
              Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (BuildContext context) => TreeMonitoringDecider(),
                ),
              );
            },
          ),
          NewOptionsCard(
            leadingIconImage: Image.asset(
              "assets/uxImages/species.png",
              fit: BoxFit.cover,
              width: 35,
            ),
            trailingIconImage: CircleAvatar(
                backgroundColor: fPrimaryColour,
                child: IconButton(
                  icon: Icon(Icons.arrow_forward_ios),
                  color: fPrimaryWhite,
                  onPressed: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (BuildContext context) => SpeciesGallery(),
                      ),
                    );
                  },
                )),
            tileTitle: "View Tree Species",
            // escription: "",
            pressHandler: () {
              Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (BuildContext context) => SpeciesGallery(),
                ),
              );
            },
          ),
          NewOptionsCard2(
            leadingIconImage: Image.asset(
              "assets/uxImages/deforestation.png",
              fit: BoxFit.cover,
              width: 35,
            ),
            trailingIconImage: CircleAvatar(
                backgroundColor: fPrimaryColour,
                child: IconButton(
                  icon: Icon(Icons.add),
                  color: fPrimaryWhite,
                  onPressed: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (BuildContext context) =>
                            DeforestationQuestions(),
                      ),
                    );
                  },
                )),
            tileTitle: "Deforestation",
            buttonTitle: "View Reports",
            color: "green",
            pressHandler: () {
              Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (BuildContext context) => DeforestationQuestions(),
                ),
              );
            },
            secondaryPressHandler: () {
              Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (BuildContext context) => ViewDeforestationReports(),
                ),
              );
            },
          ),
          // OptionsCard(
          //   iconImage: WebsafeSvg.asset(
          //     "lib/libassets/uxImages/tree_icon.svg",
          //     fit: BoxFit.cover,
          //     width: 35,
          //   ),
          //   title: "Landscape Monitoring",
          //   description: "Click to monitor landscape",
          //   pressHandler: () {
          //     Navigator.of(context).push(
          //       CupertinoPageRoute(
          //         builder: (BuildContext context) => TreeMonitoringDecider(),
          //       ),
          //     );
          //   },
          // ),
          // OptionsCard(
          //   iconImage: WebsafeSvg.asset(
          //     "lib/libassets/icons/bg.svg",
          //     fit: BoxFit.cover,
          //     width: double.infinity,
          //   ),
          //   title: "Notice Board",
          //   description: "Click for latest news and updates",
          //   pressHandler: () {
          //     Navigator.of(context).push(
          //       CupertinoPageRoute(
          //         builder: (BuildContext context) => NoticeBoard(),
          //       ),
          //     );
          //   },
          // ),
        ],
      ),
    );
  }
}

class OptionsCard extends StatelessWidget {
  final String? title, description;
  final pressHandler;
  final Icon? icon;
  final Color? color, titleColor, descriptionColor;
  final borderColor;

  const OptionsCard(
      {Key? key,
      this.title,
      this.description,
      this.pressHandler,
      this.icon,
      this.color,
      this.titleColor,
      this.descriptionColor,
      this.borderColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      // height: size.height * .21,
      child: Container(
        padding: const EdgeInsets.all(4.0),
        margin: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          border: Border(
            top: BorderSide(
                color: borderColor != null ? borderColor : Colors.black12),
            bottom: BorderSide(
                color: borderColor != null ? borderColor : Colors.black12),
            left: BorderSide(
                color: borderColor != null ? borderColor : Colors.black12),
            right: BorderSide(
                color: borderColor != null ? borderColor : Colors.black12),
          ),
          // color: fSecondaryColour,
          color: color,
        ),
        child: ListTile(
          leading: icon,
          title: Text(title ?? "Title",
              style: TextStyle(color: titleColor != null ? titleColor : null)),
          subtitle: Text(description ?? "Description",
              style: TextStyle(
                  color: descriptionColor != null ? descriptionColor : null)),
          onTap: pressHandler,
        ),
      ),
    );
  }
}

class NewOptionsCard extends StatelessWidget {
  final Widget? leadingIconImage, trailingIconImage;
  final String? tileTitle, buttonTitle;
  final Widget? bottomIconButton;
  final pressHandler;
  final Color? color, titleColor, descriptionColor;
  final borderColor;

  const NewOptionsCard({
    Key? key,
    this.leadingIconImage,
    this.trailingIconImage,
    this.tileTitle,
    this.buttonTitle,
    this.bottomIconButton,
    this.pressHandler,
    this.color,
    this.titleColor,
    this.descriptionColor,
    this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      // height: size.height * .21,
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 15.0),
      child: Container(
        padding: const EdgeInsets.all(4.0),
        margin: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          border: Border(
            top: BorderSide(
                color: borderColor != null ? borderColor : Colors.black12),
            bottom: BorderSide(
                color: borderColor != null ? borderColor : Colors.black12),
            left: BorderSide(
                color: borderColor != null ? borderColor : Colors.black12),
            right: BorderSide(
                color: borderColor != null ? borderColor : Colors.black12),
          ),
          // color: fSecondaryColour,
          // color: color,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Container(
                          child: leadingIconImage,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: .0),
                        child: Container(
                          child: Text(
                            tileTitle.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: fPrimaryColour),
                          ),
                        ),
                      ),
                    ],
                  ),
                  trailingIconImage != null
                      ? SizedBox(
                          child: trailingIconImage,
                        )
                      : SizedBox(
                          child: Text(""),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NewOptionsCard2 extends StatelessWidget {
  final Widget? leadingIconImage, trailingIconImage;
  final String? tileTitle, buttonTitle, color;
  final Widget? bottomIconButton;
  final pressHandler, secondaryPressHandler;
  final Color? titleColor, descriptionColor;
  final borderColor;

  const NewOptionsCard2({
    Key? key,
    this.leadingIconImage,
    this.trailingIconImage,
    this.tileTitle,
    this.buttonTitle = "",
    this.bottomIconButton,
    this.pressHandler,
    this.secondaryPressHandler,
    this.color,
    this.titleColor,
    this.descriptionColor,
    this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      height: size.height * .18,
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 15.0),
      child: Container(
        padding: const EdgeInsets.all(4.0),
        margin: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          border: Border(
            top: BorderSide(
                color: borderColor != null ? borderColor : Colors.black12),
            bottom: BorderSide(
                color: borderColor != null ? borderColor : Colors.black12),
            left: BorderSide(
                color: borderColor != null ? borderColor : Colors.black12),
            right: BorderSide(
                color: borderColor != null ? borderColor : Colors.black12),
          ),
          // color: fSecondaryColour,
          // color: color,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Container(
                      child: leadingIconImage,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: .0, vertical: 5.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: .0),
                        child: Container(
                          child: Text(
                            tileTitle.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: fPrimaryColour),
                          ),
                        ),
                      ),
                      buttonTitle!.isNotEmpty
                          ? Container(
                              child: color == "green"
                                  ? HardButton(
                                      title: buttonTitle.toString(),
                                      onPress: secondaryPressHandler,
                                    )
                                  : LightButton(
                                      title: buttonTitle.toString(),
                                      onPress: secondaryPressHandler,
                                    ))
                          : SizedBox(),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    child: Text(""),
                  ),
                  trailingIconImage != null
                      ? Align(
                          alignment: Alignment.bottomLeft,
                          child: SizedBox(
                            child: trailingIconImage,
                          ),
                        )
                      : SizedBox(
                          child: Text(""),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
