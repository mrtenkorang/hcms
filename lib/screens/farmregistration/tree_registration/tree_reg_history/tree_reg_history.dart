import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/controller/models/tree_registration_model.dart';
import 'package:hcms_revived2/screens/farmregistration/tree_registration/tree_reg_history/edit/tree_registration_edit_screen.dart';
import 'package:hcms_revived2/screens/farmregistration/tree_registration/tree_reg_history/tree_reg_history_controller.dart';

class TreeRegHistory extends StatefulWidget {
  const TreeRegHistory({super.key});

  @override
  State<TreeRegHistory> createState() => _TreeRegHistoryState();
}

class _TreeRegHistoryState extends State<TreeRegHistory> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TreeRegHistoryController());
    controller.treeRegHistoryScreenContext = context;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tree Registration History',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: fPrimaryColour,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          // Tab Bar
          _buildTabBar(controller),
          // Tab Content
          Expanded(child: _buildTabContent(controller)),
        ],
      ),
    );
  }

  Widget _buildTabBar(TreeRegHistoryController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: TabController(
          length: 2,
          initialIndex: controller.selectedTabIndex,
          vsync: Navigator.of(controller.treeRegHistoryScreenContext!),
        ),
        onTap: controller.changeTab,
        labelColor: Colors.green,
        unselectedLabelColor: Colors.grey,
        indicatorColor: Colors.green,
        tabs: [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.cloud_done, size: 18),
                const SizedBox(width: 6),
                Text('Submitted (${controller.syncedData.length})'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.cloud_upload, size: 18),
                const SizedBox(width: 6),
                Text('Pending (${controller.unsyncedData.length})'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent(TreeRegHistoryController controller) {
    return Obx(() {
      if (controller.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      final currentData = controller.selectedTabIndex == 0
          ? controller.syncedData
          : controller.unsyncedData;

      if (currentData.isEmpty) {
        return _buildEmptyState(controller);
      }

      return RefreshIndicator(
        onRefresh: controller.loadTreeData,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: currentData.length,
          itemBuilder: (context, index) {
            return _buildTreeCard(currentData[index], controller);
          },
        ),
      );
    });
  }

  Widget _buildEmptyState(TreeRegHistoryController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            controller.selectedTabIndex == 0
                ? Icons.cloud_done
                : Icons.cloud_upload,
            size: 64,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            controller.selectedTabIndex == 0
                ? 'No Synced Registrations'
                : 'No Pending Registrations',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            controller.selectedTabIndex == 0
                ? 'All your synced tree registrations will appear here'
                : 'Tree registrations waiting to be synced will appear here',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
          const SizedBox(height: 20),
          if (controller.selectedTabIndex == 1)
            ElevatedButton.icon(
              onPressed: controller.loadTreeData,
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh'),
            ),
        ],
      ),
    );
  }

  Widget _buildTreeCard(
    TreeRegistrationModel registration,
    TreeRegHistoryController controller,
  ) {
    return InkWell(
      onTap: () async {
        Get.to(
          () => TreeRegistrationEditScreen(
            isIndividual:
                registration.farmerId != null ||
                registration.farmerId.toString() != '',
            registrationModel: registration,
            registrationId: registration.id!,
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Registration #${registration.id ?? 'N/A'}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: controller
                          .getStatusColor(registration)
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: controller
                            .getStatusColor(registration)
                            .withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      controller.getStatusText(registration),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: controller.getStatusColor(registration),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Farmer Info
              _buildInfoRow('Farmer ID', '${registration.farmerId}'),
              _buildInfoRow(
                'Establishment',
                registration.establishmentType ?? 'N/A',
              ),
              _buildInfoRow('Trees', controller.getTreeCountText(registration)),

              // Dates
              Row(
                children: [
                  Expanded(
                    child: _buildInfoRow(
                      'Created',
                      controller.formatDate(registration.createdAt),
                    ),
                  ),
                  Expanded(
                    child: _buildInfoRow(
                      'Updated',
                      controller.formatDate(registration.updatedAt),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Action Buttons
              if (controller.selectedTabIndex ==
                  1) // Only show actions for pending sync
                Row(
                  children: [
                    // Expanded(
                    //   child: OutlinedButton.icon(
                    //     onPressed: () => controller.retrySync(registration),
                    //     icon: const Icon(Icons.sync, size: 16),
                    //     label: const Text('Retry Sync'),
                    //     style: OutlinedButton.styleFrom(
                    //       foregroundColor: Colors.orange,
                    //       side: BorderSide(color: Colors.orange.shade300),
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () =>
                            _showDeleteDialog(registration, controller),
                        icon: const Icon(Icons.delete, size: 16),
                        label: const Text('Delete'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: BorderSide(color: Colors.red.shade300),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(
    TreeRegistrationModel registration,
    TreeRegHistoryController controller,
  ) {
    showDialog(
      context: controller.treeRegHistoryScreenContext!,
      builder: (context) => AlertDialog(
        title: const Text('Delete Registration'),
        content: const Text(
          'Are you sure you want to delete this tree registration? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              controller.deleteRegistration(registration);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
