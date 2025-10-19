import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/boilerplate/widgets.dart';
import 'package:hcms_revived2/main.dart';
import 'package:hcms_revived2/screens/Deforestation/defquestions.dart';
import 'package:hcms_revived2/screens/Deforestation/viewdef.dart';
import 'package:hcms_revived2/screens/Notice%20Board/noticeboardview.dart';
import 'package:hcms_revived2/screens/Treespeciescatalogue/speciesgallery.dart';
import 'package:hcms_revived2/screens/farmregistration/farmdetails/farmdetails.dart';
import 'package:hcms_revived2/screens/farmregistration/farmerdetails/components/farmer_type_selection.dart';
import 'package:hcms_revived2/screens/treemonitoring/initialpage.dart';
import 'package:hcms_revived2/screens/viewsubmissions/viewpage.dart';
import 'package:hcms_revived2/utils/widgets/textFormats/text_formats.dart';
import 'package:websafe_svg/websafe_svg.dart';

class Options extends StatelessWidget {
  const Options({super.key});

  void _showBeneficiarySelector(BuildContext context, {bool isFromButton = false}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.5,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: fPrimaryColour.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.person_add, color: fPrimaryColour, size: 32),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Select Applicant Type',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Please choose what best describes the applicant',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),

              // Options
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      _buildBeneficiaryOption(
                        context: context,
                        icon: Icons.person,
                        title: 'Individual',
                        subtitle: 'Farmer / Developer / Individual',
                        beneficiaryType: 'Individual',
                        color: Colors.blue,
                      ),
                      const SizedBox(height: 12),
                      _buildBeneficiaryOption(
                        context: context,
                        icon: Icons.business,
                        title: 'Group',
                        subtitle: 'Company / Organization',
                        beneficiaryType: 'Group',
                        color: Colors.orange,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBeneficiaryOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required String beneficiaryType,
    required Color color,
  }) {
    return InkWell(
      onTap: () {
        regSP?.setString('_beneficiaryType', beneficiaryType);
        Navigator.pop(context);
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (BuildContext context) => FarmDetails(),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color.withOpacity(0.1), Colors.white],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3), width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildModernOptionCard(
          context: context,
          icon: Icons.forest,
          iconColor: Colors.green,
          gradientColors: [Colors.green[50]!, Colors.white],
          title: "Register Tree",
          description: "Register and manage tree data",
          buttonText: "View Registered Trees",
          onMainTap: () {
            regSP?.setString('_beneficiaryType', "Individual");
              Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (BuildContext context) => FarmDetails(),
            ),
          );},
          onButtonTap: () {

            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (BuildContext context) => ViewReport(),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        _buildModernOptionCard(
          context: context,
          icon: Icons.landscape,
          iconColor: Colors.teal,
          gradientColors: [Colors.teal[50]!, Colors.white],
          title: "Landscape Monitoring",
          description: "Monitor and track landscape changes",
          buttonText: "Monitoring Options",
          onMainTap: () {
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (BuildContext context) => TreeMonitoringDecider(),
              ),
            );
          },
          onButtonTap: () {
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (BuildContext context) => TreeMonitoringDecider(),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        _buildModernOptionCard(
          context: context,
          icon: Icons.warning_amber_rounded,
          iconColor: Colors.red,
          gradientColors: [Colors.red[50]!, Colors.white],
          title: "Deforestation Reports",
          description: "Track and report deforestation activities",
          buttonText: "View Reports",
          onMainTap: () {
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (BuildContext context) => DeforestationQuestions(),
              ),
            );
          },
          onButtonTap: () {
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (BuildContext context) => ViewDeforestationReports(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildModernOptionCard({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required List<Color> gradientColors,
    required String title,
    required String description,
    required String buttonText,
    required VoidCallback onMainTap,
    required VoidCallback onButtonTap,
  }) {
    return Card(
      elevation: 3,
      shadowColor: iconColor.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: onMainTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradientColors,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon Container
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [iconColor, iconColor.withOpacity(0.7)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: iconColor.withOpacity(0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(icon, color: Colors.white, size: 32),
                    ),
                    const SizedBox(width: 16),

                    // Title and Description
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: iconColor,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            description,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Add button
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: iconColor.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.add, color: iconColor, size: 24),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Action Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: iconColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: onButtonTap,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.visibility, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          buttonText,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Legacy card widgets for backward compatibility
class OptionsCard extends StatelessWidget {
  final String? title, description;
  final pressHandler;
  final Icon? icon;
  final Color? color, titleColor, descriptionColor;
  final borderColor;

  const OptionsCard({
    Key? key,
    this.title,
    this.description,
    this.pressHandler,
    this.icon,
    this.color,
    this.titleColor,
    this.descriptionColor,
    this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4.0),
      margin: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: borderColor ?? Colors.black12,
        ),
        color: color,
      ),
      child: ListTile(
        leading: icon,
        title: Text(
          title ?? "Title",
          style: TextStyle(color: titleColor),
        ),
        subtitle: Text(
          description ?? "Description",
          style: TextStyle(color: descriptionColor),
        ),
        onTap: pressHandler,
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 15.0),
      child: Container(
        padding: const EdgeInsets.all(4.0),
        margin: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: borderColor ?? Colors.black12,
          ),
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
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: leadingIconImage ?? const SizedBox(),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0.0),
                        child: Text(
                          tileTitle ?? '',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: fPrimaryColour,
                          ),
                        ),
                      ),
                    ],
                  ),
                  trailingIconImage ?? const SizedBox(),
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
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: borderColor ?? Colors.black12,
          ),
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
                    child: leadingIconImage ?? const SizedBox(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 5.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0.0),
                        child: Text(
                          tileTitle ?? '',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: fPrimaryColour,
                          ),
                        ),
                      ),
                      if (buttonTitle != null && buttonTitle!.isNotEmpty)
                        color == "green"
                            ? HardButton(
                          title: buttonTitle!,
                          onPress: secondaryPressHandler,
                        )
                            : LightButton(
                          title: buttonTitle!,
                          onPress: secondaryPressHandler,
                        ),
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
                  const SizedBox(),
                  if (trailingIconImage != null)
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: trailingIconImage!,
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