import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/models/localdbmodel/localdbmodel.dart';
import 'package:hcms_revived2/providers/monitoring/alternativelivelihoodprovider.dart';
import 'package:hcms_revived2/screens/treemonitoring/alternativeLivelihood/history/edit/edit_alternative_livelihood.dart';

class AlternativeLivelihoodHistory extends StatelessWidget {
  const AlternativeLivelihoodHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Get.find<AlternativeLivelihoodProvider>();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Alternative Livelihood History'),
          backgroundColor: fPrimaryColour,
          foregroundColor: fPrimaryWhite,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => provider.fetchAndSetAlternativeLivelihood(),
              tooltip: 'Refresh',
            ),
          ],
          bottom: TabBar(
            indicatorColor: fPrimaryWhite,
            labelColor: fPrimaryWhite,
            unselectedLabelColor: fPrimaryWhite.withOpacity(0.7),
            tabs: const [
              Tab(icon: Icon(Icons.pending_actions), text: 'Pending'),
              Tab(icon: Icon(Icons.cloud_done), text: 'Submitted'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Pending Tab
            _buildPendingTab(provider),
            // Submitted Tab
            _buildSubmittedTab(provider),
          ],
        ),
      ),
    );
  }

  Widget _buildPendingTab(AlternativeLivelihoodProvider provider) {
    return Obx(() {
      final pendingRecords = provider.alLists
          .where((record) => record.alConStat.toLowerCase() != 'connected')
          .toList();

      if (pendingRecords.isEmpty) {
        return const _EmptyState(
          icon: Icons.pending_actions,
          title: 'No Pending Records',
          message: 'All records have been submitted successfully',
        );
      }

      return _buildRecordList(pendingRecords, provider, isPending: true);
    });
  }

  Widget _buildSubmittedTab(AlternativeLivelihoodProvider provider) {
    return Obx(() {
      final submittedRecords = provider.alLists
          .where((record) => record.alConStat.toLowerCase() == 'connected')
          .toList();

      if (submittedRecords.isEmpty) {
        return const _EmptyState(
          icon: Icons.cloud_done,
          title: 'No Submitted Records',
          message: 'Submitted records will appear here',
        );
      }

      return _buildRecordList(submittedRecords, provider, isPending: false);
    });
  }

  Widget _buildRecordList(
    List<AlternativeLivelihood> records,
    AlternativeLivelihoodProvider provider, {
    required bool isPending,
  }) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: records.length,
      itemBuilder: (context, index) {
        final record = records[index];
        return _buildRecordCard(
          context,
          record,
          provider,
          isPending: isPending,
        );
      },
    );
  }

  Widget _buildRecordCard(
    BuildContext context,
    AlternativeLivelihood record,
    AlternativeLivelihoodProvider provider, {
    required bool isPending,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                EditAlternativeLivelihoodScreen(alternativeLivelihood: record),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with farmer info and status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          record.alFarmerName.isNotEmpty
                              ? record.alFarmerName
                              : 'Unknown Farmer',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          record.alFarmerContact,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusChip(record.alConStat),
                ],
              ),

              const SizedBox(height: 16),

              // Activity Details
              _buildInfoRow(
                'Activity Type',
                _formatActivity(record.alAdditionalActivity),
              ),
              _buildInfoRow('Trainer Organization', record.alTrainerOrg),
              _buildInfoRow('Visit Date', record.alVisitDate),
              _buildInfoRow('Operations Started', record.alOperationsStartDate),

              const SizedBox(height: 12),

              // Investment Details
              _buildInfoRow(
                'Initial Investment',
                'GHS ${record.alInitialAmount}',
              ),
              _buildInfoRow(
                'Amount After ${record.alAmountType}',
                'GHS ${record.alAmount}',
              ),
              _buildInfoRow('LMB Contribution', 'GHS ${record.alAmountToLMB}'),
              _buildInfoRow(
                'Income Supports',
                _formatSupportActivity(record.alActivitySupported),
              ),

              const SizedBox(height: 16),

              // Footer with community and actions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Community: ${record.alCommunity}',
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        record.alTimeDisplay,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      // const SizedBox(width: 8),
                      // if (isPending) ...[
                      //   _buildActionButton(
                      //     icon: Icons.cloud_upload,
                      //     color: Colors.green,
                      //     tooltip: 'Submit Online',
                      //     onPressed: () => _showSubmitDialog(record, provider),
                      //   ),
                      //   const SizedBox(width: 4),
                      // ],
                      _buildActionButton(
                        icon: Icons.delete,
                        color: Colors.red,
                        tooltip: 'Delete Record',
                        onPressed: () => _showDeleteDialog(record, provider),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      icon: Icon(icon, size: 18),
      onPressed: onPressed,
      color: color,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      tooltip: tooltip,
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black54,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color backgroundColor;
    Color? textColor;
    String displayText;

    switch (status.toLowerCase()) {
      case 'connected':
        backgroundColor = Colors.green;
        textColor = Colors.white;
        displayText = 'Submitted';
        break;
      case 'not connected':
        backgroundColor = Colors.orange;
        textColor:
        Colors.white;
        displayText = 'Pending';
        break;
      case 'farmer offline':
        backgroundColor = Colors.blue;
        textColor = Colors.white;
        displayText = 'Offline Farmer';
        break;
      case 'exists online':
        backgroundColor = Colors.purple;
        textColor = Colors.white;
        displayText = 'Exists Online';
        break;
      default:
        backgroundColor = Colors.grey;
        textColor = Colors.white;
        displayText = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        displayText,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _formatActivity(String activity) {
    // Convert from database format to readable format
    final Map<String, String> activityMap = {
      'Snail_Rearing': 'Snail Rearing',
      'Vegetable_Farming': 'Vegetable Farming',
      'Food_Processing_And_Value_Addition': 'Food Processing',
      'Pig_Sty': 'Pig Sty',
      'Bee_Keeping': 'Bee Keeping',
      'Soap_Making': 'Soap Making',
    };

    return activityMap[activity] ?? activity.replaceAll('_', ' ');
  }

  String _formatSupportActivity(String support) {
    // Convert from database format to readable format
    final Map<String, String> supportMap = {
      'School_Fees': 'School Fees',
      'Home_Appliances': 'Home Appliances',
      'Medical_Bills': 'Medical Bills',
      'Buy_Farm_Inputs': 'Buy Farm Inputs',
    };

    return supportMap[support] ?? support.replaceAll('_', ' ');
  }

  void _showSubmitDialog(
    AlternativeLivelihood record,
    AlternativeLivelihoodProvider provider,
  ) {
    Get.dialog(
      AlertDialog(
        title: const Text('Submit Record'),
        content: Text(
          'Submit the record for ${record.alFarmerName.isNotEmpty ? record.alFarmerName : 'this farmer'} to the server?',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              Get.back();
              // Show loading
              Get.dialog(
                const Center(child: CircularProgressIndicator()),
                barrierDismissible: false,
              );

              try {
                // Simulate API call - replace with actual submission logic
                await Future.delayed(const Duration(seconds: 2));

                // Update record status to connected
                // Note: You'll need to add a method to update the record status in your provider
                // For now, we'll just show a message
                Get.back(); // Close loading dialog
                Get.snackbar(
                  'Success',
                  'Record submitted successfully',
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );

                // Refresh the list
                provider.fetchAndSetAlternativeLivelihood();
              } catch (e) {
                Get.back(); // Close loading dialog
                Get.snackbar(
                  'Error',
                  'Failed to submit record: $e',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.green),
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(
    AlternativeLivelihood record,
    AlternativeLivelihoodProvider provider,
  ) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Record'),
        content: Text(
          'Are you sure you want to delete the record for ${record.alFarmerName.isNotEmpty ? record.alFarmerName : 'this farmer'}?',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              provider.deleteAlternativeLivelihoodd(record.alId);
              Get.snackbar(
                'Deleted',
                'Record deleted successfully',
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const _EmptyState({
    required this.icon,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(title, style: const TextStyle(fontSize: 18, color: Colors.grey)),
          const SizedBox(height: 8),
          Text(
            message,
            style: const TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
