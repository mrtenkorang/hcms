import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/controller/models/deforestation_model.dart';
import 'package:hcms_revived2/screens/Deforestation/history/edit/edit_deforstation_screen.dart';
import 'deforestation_history_controller.dart';

class DeforestationHistoryScreen extends StatelessWidget {
  final DeforestationHistoryController controller = Get.put(
    DeforestationHistoryController(),
  );

  DeforestationHistoryScreen({Key? key}) : super(key: key);

  Future<void> _showSyncConfirmation(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sync Pending Reports'),
        content: const Text(
          'Are you sure you want to sync all pending deforestation reports to the server?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text('SYNC'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await controller.submitAllPendingReports(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: fPrimaryColour,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        title: const Text(
          "Deforestation Reports",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Obx(() {
            if (controller.currentTabIndex.value == 0 &&
                controller.hasPendingReports) {
              return IconButton(
                icon:
                    // controller.isSyncing.value
                    //     ?
                    const Icon(Icons.cloud_upload, color: Colors.white),
                // : const Icon(Icons.cloud_upload, color: Colors.white),
                onPressed: () => _showSyncConfirmation(context),
                tooltip: 'Sync Pending Reports',
              );
            }
            return const SizedBox();
          }),
        ],
      ),
      body: Column(
        children: [
          // Tab Bar
          Container(
            color: Colors.white,
            child: Obx(
              () => TabBar(
                controller: TabController(
                  length: 2,
                  initialIndex: controller.currentTabIndex.value,
                  vsync: Navigator.of(context),
                ),
                onTap: controller.changeTab,
                labelColor: fPrimaryColour,
                unselectedLabelColor: Colors.grey,
                indicatorColor: fPrimaryColour,
                tabs: const [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.pending, size: 20),
                        SizedBox(width: 8),
                        Text('Pending'),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle, size: 20),
                        SizedBox(width: 8),
                        Text('Submitted'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Tab Count Indicators
          // Obx(() => Container(
          //   padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          //   color: Colors.grey[100],
          //   child: Row(
          //     children: [
          //       _buildTabCount(
          //         'Pending: ${controller.pendingReports.length}',
          //         Colors.orange,
          //       ),
          //       const SizedBox(width: 16),
          //       _buildTabCount(
          //         'Submitted: ${controller.submittedReports.length}',
          //         Colors.green,
          //       ),
          //     ],
          //   ),
          // )),

          // Content
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.allReports.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.errorMessage.isNotEmpty) {
                return _buildErrorWidget();
              }

              return _buildTabContent();
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildTabCount(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'Error Loading Reports',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              controller.errorMessage.value,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[500]),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: controller.refreshReports,
            style: ElevatedButton.styleFrom(backgroundColor: fPrimaryColour),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    final reports = controller.currentTabReports;

    if (reports.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: controller.refreshReports,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: reports.length,
        itemBuilder: (context, index) {
          return _buildReportCard(reports[index]);
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    final isPendingTab = controller.currentTabIndex.value == 0;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isPendingTab ? Icons.pending_actions : Icons.assignment_turned_in,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            isPendingTab ? 'No Pending Reports' : 'No Submitted Reports',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isPendingTab
                ? 'Reports waiting to be submitted will appear here'
                : 'Successfully submitted reports will appear here',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard(DeforestationReportModel report) {
    final isPending = report.submissionStatus == 'pending';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with status and actions
            Row(
              children: [
                _buildStatusChip(isPending),
                const Spacer(),
                if (isPending) _buildPendingActions(report),
                _buildActionsMenu(report),
              ],
            ),

            const SizedBox(height: 12),

            // Report details
            _buildDetailRow(
              Icons.location_on,
              'Location',
              '${report.latitude?.toStringAsFixed(4)}, ${report.longitude?.toStringAsFixed(4)}',
            ),

            if (report.community != null) ...[
              const SizedBox(height: 8),
              _buildDetailRow(Icons.people, 'Community', report.community!),
            ],

            const SizedBox(height: 8),
            _buildDetailRow(
              Icons.date_range,
              'Created',
              _formatDate(report.createdAt),
            ),

            if (report.seeDeforestation == 'yes' &&
                report.deforestationCauses != null &&
                report.deforestationCauses!.isNotEmpty) ...[
              const SizedBox(height: 8),
              _buildDetailRow(
                Icons.warning,
                'Causes',
                report.deforestationCauses!.join(', '),
                maxLines: 2,
              ),
            ],

            if (report.furtherActionRequired == 'yes' &&
                report.reasonForAction != null &&
                report.reasonForAction!.isNotEmpty) ...[
              const SizedBox(height: 8),
              _buildDetailRow(
                Icons.lightbulb,
                'Action Reason',
                report.reasonForAction!,
                maxLines: 2,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(bool isPending) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isPending
            ? Colors.orange.withOpacity(0.1)
            : Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isPending ? Colors.orange : Colors.green),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPending ? Icons.pending : Icons.check_circle,
            size: 14,
            color: isPending ? Colors.orange : Colors.green,
          ),
          const SizedBox(width: 4),
          Text(
            isPending ? 'Pending' : 'Submitted',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isPending ? Colors.orange : Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingActions(DeforestationReportModel report) {
    return Row(
      children: [
        // IconButton(
        //   icon: const Icon(Icons.cloud_upload, size: 20),
        //   onPressed: () => controller.submitPendingReport(report.id!),
        //   tooltip: 'Submit Now',
        //   color: fPrimaryColour,
        // ),
        IconButton(
          icon: const Icon(Icons.edit, size: 20),
          onPressed: () => _navigateToEdit(report),
          tooltip: 'Edit',
          color: fPrimaryColour,
        ),
      ],
    );
  }

  Widget _buildActionsMenu(DeforestationReportModel report) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      onSelected: (value) => _handleMenuAction(value, report),
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'view',
          child: Row(
            children: [
              Icon(Icons.visibility, size: 20),
              SizedBox(width: 8),
              Text('View Details'),
            ],
          ),
        ),
        if (report.submissionStatus == 'pending') ...[
          const PopupMenuItem(
            value: 'edit',
            child: Row(
              children: [
                Icon(Icons.edit, size: 20),
                SizedBox(width: 8),
                Text('Edit'),
              ],
            ),
          ),
          // const PopupMenuItem(
          //   value: 'submit',
          //   child: Row(
          //     children: [
          //       Icon(Icons.cloud_upload, size: 20),
          //       SizedBox(width: 8),
          //       Text('Submit Now'),
          //     ],
          //   ),
          // ),
        ],
        const PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete, color: Colors.red, size: 20),
              SizedBox(width: 8),
              Text('Delete', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(
    IconData icon,
    String label,
    String value, {
    int maxLines = 1,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: maxLines,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _handleMenuAction(String action, DeforestationReportModel report) {
    switch (action) {
      case 'view':
        _showReportDetails(report);
        break;
      case 'edit':
        _navigateToEdit(report);
        break;
      case 'submit':
        controller.submitPendingReport(report.id!);
        break;
      case 'delete':
        controller.deleteReport(report.id!);
        break;
    }
  }

  void _navigateToEdit(DeforestationReportModel report) {
    Get.to(() => DeforestationEditScreen(report: report));
  }

  void _showReportDetails(DeforestationReportModel report) {
    showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        title: const Text('Report Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailItem(
                'Community',
                report.community ?? 'Not specified',
              ),
              _buildDetailItem(
                'GFW Directed',
                report.directedByGfw ?? 'Not specified',
              ),
              _buildDetailItem(
                'See Deforestation',
                report.seeDeforestation ?? 'Not specified',
              ),
              if (report.deforestationCauses != null &&
                  report.deforestationCauses!.isNotEmpty)
                _buildDetailItem(
                  'Causes',
                  report.deforestationCauses!.join(', '),
                ),
              _buildDetailItem(
                'Further Action',
                report.furtherActionRequired ?? 'Not specified',
              ),
              if (report.reasonForAction != null &&
                  report.reasonForAction!.isNotEmpty)
                _buildDetailItem('Action Reason', report.reasonForAction!),
              _buildDetailItem(
                'Location',
                '${report.latitude}, ${report.longitude}',
              ),
              _buildDetailItem('Created', _formatDate(report.createdAt)),
              _buildDetailItem('Status', report.submissionStatus ?? 'pending'),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Close')),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Unknown';
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
