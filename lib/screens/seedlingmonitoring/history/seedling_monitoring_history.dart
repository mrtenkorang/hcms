import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/helpers/services/seedling_monitoring_services.dart';
import 'package:hcms_revived2/models/localdbmodel/seedling_monitoring_model.dart';
import 'package:hcms_revived2/screens/seedlingmonitoring/history/edit_seedling_monitoring.dart';
import 'package:hcms_revived2/screens/treemonitoring/initialpage.dart';
import 'package:get/get.dart';

class SeedlingMonitoringViewInit extends StatefulWidget {
  final String? filterdate;
  const SeedlingMonitoringViewInit({super.key, this.filterdate});
  @override
  _SeedlingMonitoringViewInitState createState() =>
      _SeedlingMonitoringViewInitState();
}

class _SeedlingMonitoringViewInitState extends State<SeedlingMonitoringViewInit> {
  void _navigateToEditScreen(SeedlingMonitoringModel monitoring) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditSeedlingMonitoringScreen(
          seedlingMonitoring: monitoring,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final SeedlingMonitoringService monitoringService = Get.find();
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Seedling Monitoring History',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: fPrimaryColour,
        elevation: 0,

      ),
      body: Container(
        decoration: const BoxDecoration(

        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: FutureBuilder<List<SeedlingMonitoringModel>>(
                    future: monitoringService.getAllMonitorings(),
                    builder: (context, snapshot) {
                      // Loading state
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return _buildLoadingState();
                      }

                      // Error state
                      if (snapshot.hasError) {
                        return _buildErrorState(snapshot.error.toString());
                      }

                      // Data loaded successfully
                      if (snapshot.hasData) {
                        final monitorings = snapshot.data!;

                        // Empty state
                        if (monitorings.isEmpty) {
                          return _buildEmptyState();
                        }

                        // Data state
                        return _buildDataState(monitorings, monitoringService);
                      }

                      // Default empty state
                      return _buildEmptyState();
                    },
                  ),
                ),
                const SizedBox(height: 20),
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
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(fPrimaryColour),
          ),
          const SizedBox(height: 16),
          Text(
            'Loading monitoring records...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[300],
            ),
            const SizedBox(height: 16),
            const Text(
              'Unable to load data',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Error: $error',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {});
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: fPrimaryColour,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Try Again',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assignment_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            const Text(
              'No Monitoring Records',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Start by creating your first seedling monitoring record',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to create new monitoring screen
                // Get.to(() => CreateSeedlingMonitoringScreen());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: fPrimaryColour,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              ),
              child: const Text(
                'Create New Record',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataState(List<SeedlingMonitoringModel> monitorings, SeedlingMonitoringService service) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      itemCount: monitorings.length,
      itemBuilder: (context, index) {
        final monitoring = monitorings[index];
        return _buildMonitoringCard(monitoring, index);
      },
    );
  }

  Widget _buildMonitoringCard(SeedlingMonitoringModel monitoring, int index) {
    // Extract data from monitoring object
    final farmerName = monitoring.farmerName ?? 'Unknown Farmer';
    final dateOfSurvey = monitoring.dateOfSurvey ?? 'No Date';
    final submissionStatus = monitoring.submissionStatus ?? 'draft';
    final totalSeedlingsAlive = monitoring.totalSeedlingsAlive?.toString() ?? 'N/A';
    final community = monitoring.community ?? 'Unknown Community';

    // Status colors and text
    final isSubmitted = submissionStatus == 'submitted';
    final statusColor = isSubmitted ? Colors.green : Colors.orange;
    final statusText = isSubmitted ? 'Submitted' : 'Draft';
    final statusIcon = isSubmitted ? Icons.cloud_done : Icons.edit;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          _navigateToEditScreen(monitoring);
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: fSecondaryColour.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              // Status Indicator
              Container(
                width: 4,
                height: 60,
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 16),

              // Farmer Avatar
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: fPrimaryColour.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    farmerName.isNotEmpty ? farmerName[0].toUpperCase() : 'F',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: fPrimaryColour,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Monitoring Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      farmerName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: fPrimaryBlackColour,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      community,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          dateOfSurvey,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Right side - Status and Action
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Status Badge with Delete Button
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Status Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              statusIcon,
                              size: 14,
                              color: statusColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              statusText,
                              style: TextStyle(
                                color: statusColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Delete Button
                      GestureDetector(
                        onTap: () {
                          _showDeleteConfirmation(monitoring, context);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.delete_outline,
                            size: 18,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Seedlings Count
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.eco,
                        size: 14,
                        color: Colors.green[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$totalSeedlingsAlive alive',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.green[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Edit Icon
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: fPrimaryColour.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: fPrimaryColour,
                    ),
                  ),
                ],
              ),
            ]),
          ),
        ),
      );

  }

  Future<void> _showDeleteConfirmation(SeedlingMonitoringModel monitoring, BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Monitoring Record'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Are you sure you want to delete this monitoring record?'),
                SizedBox(height: 8),
                Text('This action cannot be undone.',
                    style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                try {
                  final SeedlingMonitoringService monitoringService = Get.find();
                  await monitoringService.deleteMonitoring(monitoring);
                  if (mounted) {
                    setState(() {
                      // This will trigger a rebuild of the widget
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Monitoring record deleted'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error deleting record: $e')),
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }}