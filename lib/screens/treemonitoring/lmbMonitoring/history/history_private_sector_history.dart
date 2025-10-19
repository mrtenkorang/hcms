import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/models/localdbmodel/localdbmodel.dart';
import 'package:hcms_revived2/screens/treemonitoring/lmbMonitoring/history/edit/edit_private_sector_screen.dart';
import 'package:hcms_revived2/screens/treemonitoring/lmbMonitoring/history/history_private_sector_controller.dart';
import 'package:intl/intl.dart';

class HistoryPrivateSectorHistory extends StatelessWidget {
  const HistoryPrivateSectorHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HistoryPrivateSectorController());
    controller.historyPrivateSectorHistoryContext = context;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Private Sector History'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Pending', icon: Icon(Icons.pending_actions)),
              Tab(text: 'Submitted', icon: Icon(Icons.cloud_done)),
            ],
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: controller.refreshData,
              tooltip: 'Refresh',
            ),
          ],
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.errorMessage.value.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error loading data',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: Colors.red),
                  ),
                  const SizedBox(height: 8),
                  Text(controller.errorMessage.value),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: controller.refreshData,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return TabBarView(
            children: [
              // Pending Tab
              _buildRecordsList(
                context,
                controller.pendingRecords,
                isPending: true,
                onRefresh: controller.refreshData,
                onSubmitted: controller.submitRecord,
              ),
              // Submitted Tab
              _buildRecordsList(
                context,
                controller.submittedRecords,
                isPending: false,
                onRefresh: controller.refreshData,
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildRecordsList(
    BuildContext context,
    List<LMBMonitoring> records, {
    required bool isPending,
    required Future<void> Function() onRefresh,
    Future<void> Function(LMBMonitoring)? onSubmitted,
  }) {
    if (records.isEmpty) {
      return Center(
        child: Text(
          'No ${isPending ? 'pending' : 'submitted'} records found',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: records.length,
        itemBuilder: (context, index) {
          final record = records[index];
          return _buildRecordCard(context, record, isPending, onSubmitted);
        },
      ),
    );
  }

  Widget _buildRecordCard(
    BuildContext context,
    LMBMonitoring record,
    bool isPending,
    Future<void> Function(LMBMonitoring)? onSubmitted,
  ) {
    final date = DateFormat(
      'MMM d, y',
    ).format(DateTime.parse(record.lmbFirstEngagement));
    final bool isPrivateSector = record.lmbSector.toLowerCase().contains(
      'private',
    );

    // Color scheme based on sector type
    final Color primaryColor = isPrivateSector ? Colors.blue : Colors.green;
    final Color backgroundColor = isPrivateSector
        ? Colors.blue[50]!
        : Colors.green[50]!;
    final Color accentColor = isPrivateSector
        ? Colors.blue[100]!
        : Colors.green[100]!;
    final IconData sectorIcon = isPrivateSector
        ? Icons.business
        : Icons.account_balance;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                EditPrivateSectorEngagementScreen(record: record),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        elevation: 0.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: fSecondaryColour),
            // gradient: LinearGradient(
            //   begin: Alignment.topLeft,
            //   end: Alignment.bottomRight,
            //   colors: [
            //     backgroundColor,
            //     Colors.white,
            //   ],
            // ),
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row with Icon and Status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Icon(
                            sectorIcon,
                            color: primaryColor,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              record.lmbSector,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: primaryColor,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                                vertical: 2.0,
                              ),
                              decoration: BoxDecoration(
                                color: isPending
                                    ? Colors.orange[100]
                                    : Colors.green[100],
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text(
                                isPending ? 'Pending' : 'Submitted',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: isPending
                                      ? Colors.orange[800]
                                      : Colors.green[800],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // if (isPending && onSubmitted != null)
                    //   Container(
                    //     decoration: BoxDecoration(
                    //       color: Colors.green,
                    //       borderRadius: BorderRadius.circular(12.0),
                    //       boxShadow: [
                    //         BoxShadow(
                    //           color: Colors.green.withOpacity(0.3),
                    //           blurRadius: 4,
                    //           offset: const Offset(0, 2),
                    //         ),
                    //       ],
                    //     ),
                    //     child: IconButton(
                    //       icon: const Icon(Icons.cloud_upload, color: Colors.white, size: 20),
                    //       onPressed: () => onSubmitted(record),
                    //       tooltip: 'Submit to server',
                    //     ),
                    //   ),
                  ],
                ),

                const SizedBox(height: 16),

                // Organization Name
                Text(
                  record.lmbPrivateName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 12),

                // Details Grid
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: fPrimaryColour.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Column(
                    children: [
                      _buildDetailRow(
                        icon: Icons.calendar_today,
                        label: 'Engagement Date',
                        value: date,
                      ),
                      const SizedBox(height: 8),
                      if (record.lmbPartnershipType.isNotEmpty)
                        _buildDetailRow(
                          icon: Icons.handshake,
                          label: 'Partnership Type',
                          value: record.lmbPartnershipType,
                        ),
                      if (record.lmbPartnershipType.isNotEmpty)
                        const SizedBox(height: 8),
                      if (record.lmbTypeLoanService.isNotEmpty)
                        _buildDetailRow(
                          icon: Icons.credit_card,
                          label: 'Financial Service',
                          value: record.lmbTypeLoanService,
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Beneficiaries Section (if available)
                if (record.lmbMaleBenefit.isNotEmpty ||
                    record.lmbFemaleBenefit.isNotEmpty ||
                    record.lmbYouthBenefit.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Beneficiaries',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          if (record.lmbMaleBenefit.isNotEmpty)
                            _buildBeneficiaryChip(
                              count: record.lmbMaleBenefit,
                              label: 'Male',
                              color: Colors.blue,
                            ),
                          if (record.lmbFemaleBenefit.isNotEmpty)
                            _buildBeneficiaryChip(
                              count: record.lmbFemaleBenefit,
                              label: 'Female',
                              color: Colors.pink,
                            ),
                          if (record.lmbYouthBenefit.isNotEmpty)
                            _buildBeneficiaryChip(
                              count: record.lmbYouthBenefit,
                              label: 'Youth',
                              color: Colors.orange,
                            ),
                        ],
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper widget for detail rows
  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
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
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Helper widget for beneficiary chips
  Widget _buildBeneficiaryChip({
    required String count,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            count,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
