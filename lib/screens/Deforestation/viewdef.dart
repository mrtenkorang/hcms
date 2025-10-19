import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/boilerplate/widgets.dart';
import 'package:hcms_revived2/helpers/dbhelper.dart';
import 'package:hcms_revived2/main.dart';
import 'package:hcms_revived2/providers/deforestationprovider.dart';
import 'package:hcms_revived2/screens/Deforestation/viewdetailsdef.dart';
import 'package:hcms_revived2/screens/home/index.dart';
import 'package:hcms_revived2/services/serverurls.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class ViewDeforestationReports extends StatefulWidget {
  final String? filterdate;
  const ViewDeforestationReports({Key? key, this.filterdate}) : super(key: key);

  @override
  _ViewDeforestationReportsState createState() =>
      _ViewDeforestationReportsState();
}

class _ViewDeforestationReportsState extends State<ViewDeforestationReports> {
  final _scrollController = ScrollController();
  bool _isRefreshing = false;

  Future<bool> _onbackPressed() {
    return Navigator.of(context)
        .pushReplacement(CupertinoPageRoute(builder: (c) => IndexPage()))
        .then((value) => value);
  }

  Future<void> _refreshData() async {
    setState(() {
      _isRefreshing = true;
    });

    await Provider.of<DeforestationProvider>(context, listen: false)
        .fetchAndSetDeforestationModel();

    setState(() {
      _isRefreshing = false;
    });
  }

  // Card styling constants
  final EdgeInsets _cardMargin = const EdgeInsets.symmetric(horizontal: 20, vertical: 6);
  final BorderRadius _cardBorderRadius = BorderRadius.circular(20);

  Widget _buildReportCard({
    required BuildContext context,
    required String community,
    required String date,
    required String gfwDirected,
    required String image,
    required bool isNotSent,
    required VoidCallback onMorePressed,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: _cardMargin,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: _cardBorderRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: _cardBorderRadius,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image/Avatar Section
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xff42E695),
                        Color(0xff3BB2B8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: image.isNotEmpty
                        ? Image.memory(
                      base64Decode(image),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildPlaceholderAvatar(community);
                      },
                    )
                        : _buildPlaceholderAvatar(community),
                  ),
                ),
                const SizedBox(width: 16),

                // Content Section
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  community,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black87,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                _buildInfoRow(
                                  Icons.calendar_today_outlined,
                                  date,
                                ),
                                const SizedBox(height: 6),
                                _buildInfoRow(
                                  Icons.map_outlined,
                                  "GFW: ${gfwDirected.toLowerCase() == 'yes' ? 'Yes' : 'No'}",
                                ),
                              ],
                            ),
                          ),
                          // More Button
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: IconButton(
                              onPressed: onMorePressed,
                              icon: Icon(
                                Icons.more_vert_rounded,
                                color: fPrimaryColour,
                                size: 20,
                              ),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Status Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isNotSent
                              ? Colors.orange.withOpacity(0.1)
                              : Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isNotSent
                                ? Colors.orange
                                : Colors.green,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isNotSent
                                  ? Icons.cloud_upload_outlined
                                  : Icons.check_circle_outline,
                              size: 16,
                              color: isNotSent
                                  ? Colors.orange[700]
                                  : Colors.green[700],
                            ),
                            const SizedBox(width: 6),
                            Text(
                              isNotSent ? "Pending Upload" : "Uploaded",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: isNotSent
                                    ? Colors.orange[700]
                                    : Colors.green[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholderAvatar(String community) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [
            Color(0xff667eea),
            Color(0xff764ba2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Text(
          community.isNotEmpty ? community[0].toUpperCase() : '?',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return RefreshIndicator(
      onRefresh: _refreshData,
      color: fPrimaryColour,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.forest_outlined,
                    size: 70,
                    color: Colors.grey[400],
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  "No Reports Found",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    "When you submit deforestation reports, they will appear here for review and management",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[500],
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _refreshData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: fPrimaryColour,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  icon: const Icon(Icons.refresh, color: Colors.white, size: 20),
                  label: const Text(
                    "Refresh",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
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

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(fPrimaryColour),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Loading Reports",
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Please wait while we fetch your data",
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 28,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onbackPressed,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          elevation: 0,
          backgroundColor: fPrimaryColour,
          leading: IconButton(
            onPressed: () => _onbackPressed(),
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 22),
          ),
          title: const Text(
            "Deforestation Reports",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        body: FutureBuilder(
          future: Provider.of<DeforestationProvider>(context, listen: false)
              .fetchAndSetDeforestationModel(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingState();
            }

            return Consumer<DeforestationProvider>(
              child: _buildEmptyState(),
              builder: (ctx, alDetails, ch) {
                if (alDetails.deforestationLists.isEmpty) {
                  return _buildEmptyState();
                }

                final reports = alDetails.deforestationLists;
                final pendingUploads = reports.where((r) => r.conStat == "not connected").length;

                return RefreshIndicator(
                  onRefresh: _refreshData,
                  color: fPrimaryColour,
                  child: Column(
                    children: [

                      // Reports List
                      Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.only(bottom: 20, top: 8),
                          itemCount: reports.length,
                          itemBuilder: (ctx, i) {
                            int itemCount = reports.length;
                            int reversedIndex = itemCount - 1 - i;
                            final report = reports[reversedIndex];
                            final isNotSent = report.conStat == "not connected";

                            return _buildReportCard(
                              context: context,
                              community: report.community,
                              date: report.timeDisplay,
                              gfwDirected: report.gfwDirected,
                              image: report.image,
                              isNotSent: isNotSent,
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  ViewDeforestationReportDetails.routeName,
                                  arguments: report.id,
                                );
                              },
                              onMorePressed: () {
                                if (isNotSent) {
                                  _showNotSentOptions(context, report, alDetails);
                                } else {
                                  _showSentOptions(context, report, alDetails);
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _showNotSentOptions(BuildContext context, report, alDetails) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return _buildBottomSheet(
          title: "Report Options",
          options: [
            _BottomSheetOption(
              icon: Icons.cloud_upload_rounded,
              label: "Upload Now",
              description: "Send this report to the server",
              color: fPrimaryColour,
              onTap: () {
                Navigator.pop(context);
                _reUpload(
                  context,
                  communityVal: report.community,
                  gfwDirection: report.gfwDirected,
                  seeDeforestation: report.seeDeforestation,
                  deforestationCause: report.deforestationCause,
                  actionRequired: report.takeAction,
                  whyAction: report.actionReason,
                  latitude: report.latitude,
                  longitude: report.longitude,
                  speciesbase64Image: report.image,
                  itemID: report.id,
                );
              },
            ),
            _BottomSheetOption(
              icon: Icons.visibility_rounded,
              label: "View Details",
              description: "See full report information",
              color: Colors.blue,
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).pushNamed(
                  ViewDeforestationReportDetails.routeName,
                  arguments: report.id,
                );
              },
            ),
            _BottomSheetOption(
              icon: Icons.delete_rounded,
              label: "Delete Report",
              description: "Permanently remove this report",
              color: Colors.red,
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmation(context, report.id, alDetails);
              },
            ),
          ],
        );
      },
    );
  }

  void _showSentOptions(BuildContext context, report, alDetails) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return _buildBottomSheet(
          title: "Report Options",
          options: [
            _BottomSheetOption(
              icon: Icons.visibility_rounded,
              label: "View Details",
              description: "See full report information",
              color: Colors.blue,
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).pushNamed(
                  ViewDeforestationReportDetails.routeName,
                  arguments: report.id,
                );
              },
            ),
            _BottomSheetOption(
              icon: Icons.delete_rounded,
              label: "Delete Report",
              description: "Permanently remove this report",
              color: Colors.red,
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmation(context, report.id, alDetails);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildBottomSheet({
    required String title,
    required List<_BottomSheetOption> options,
  }) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            // Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Choose an action for this report",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 20),
            // Options
            ...options.map((option) => _buildBottomSheetOption(option)),
            const SizedBox(height: 20),
            // Cancel button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: BorderSide(color: Colors.grey[300]!),
                  ),
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSheetOption(_BottomSheetOption option) {
    return InkWell(
      onTap: option.onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: option.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                option.icon,
                color: option.color,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.label,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    option.description,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.grey[400],
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, id, alDetails) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.delete_rounded,
                    color: Colors.red,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 16),
                // Title
                const Text(
                  "Delete Report?",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                // Description
                const Text(
                  "This action cannot be undone. The report will be permanently removed from your device.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 24),
                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: BorderSide(color: Colors.grey[300]!),
                        ),
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          DBHelper.deleteMV("deforestation", id);
                          Provider.of<DeforestationProvider>(context, listen: false)
                              .fetchAndSetDeforestationModel();
                          overlayNotification("Report deleted successfully", "positive");
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          "Delete",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future _reUpload(
      BuildContext ctx, {
        String? communityVal,
        String? gfwDirection,
        String? seeDeforestation,
        String? deforestationCause,
        String? actionRequired,
        String? whyAction,
        String? latitude,
        String? longitude,
        String? speciesbase64Image,
        itemID,
      }) async {
    submissionLoader(ctx, "Uploading Report", "Please wait...");

    overlayNotification('Uploading report...', "positive");

    try {
      var deforestationdata = {
        "community": int.parse(communityVal!),
        "directed_by_gfw": gfwDirection,
        "do_u_see_deforestation": seeDeforestation,
        "cause_deforestation": deforestationCause
            .toString()
            .replaceAll("[", "")
            .replaceAll("]", ""),
        "further_action_taken": actionRequired,
        "reason_further_action_taken": whyAction,
        "latitude": double.parse(latitude ?? "0.0"),
        "longitude": double.parse(longitude ?? "0.0"),
        "photos": speciesbase64Image
      };

      var url = '$stageBaseUrl/deforestationapi/';
      var body = json.encode(deforestationdata);

      var res = await http.post(Uri.parse(url), body: body);

      final response = json.decode(res.body);
      var status = response["status"];

      if (status == "done") {
        Navigator.pop(context);
        overlayNotification('Report uploaded successfully!', "positive");
        regSP?.clear();
        DBHelper.updateMView("deforestation", "conStat", "connected", itemID);
        _refreshData();
      } else if (status == "exist") {
        Navigator.pop(context);
        overlayNotification('Report already exists on server', "positive");
        regSP?.clear();
        DBHelper.updateMView("deforestation", "conStat", "connected", itemID);
        _refreshData();
      } else {
        Navigator.pop(context);
        overlayNotification('Upload failed: ${response["error"]}', "negative");
      }
    } on SocketException catch (e) {
      Navigator.pop(context);
      overlayNotification(
        'No internet connection. Please check your connection and try again.',
        "negative",
      );
    } catch (i) {
      Navigator.pop(context);
      overlayNotification('Upload failed. Please try again.', "negative");
    }
  }
}

class _BottomSheetOption {
  final IconData icon;
  final String label;
  final String description;
  final Color color;
  final VoidCallback onTap;

  _BottomSheetOption({
    required this.icon,
    required this.label,
    required this.description,
    required this.color,
    required this.onTap,
  });
}