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

class _TreeRegHistoryState extends State<TreeRegHistory>
    with SingleTickerProviderStateMixin {
  final controller = Get.put(TreeRegHistoryController());
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: controller.selectedTabIndex,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.treeRegHistoryScreenContext = context;
      controller.loadTreeData();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    Get.delete<TreeRegHistoryController>();
    super.dispose();
  }

  Future<void> _showSyncConfirmation() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sync Pending Registrations'),
        content: const Text('Are you sure you want to sync all pending tree registrations to the server?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('SYNC'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await controller.syncAllPendingTrees(context);
    }
  }

  @override
  Widget build(BuildContext context) {
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
        actions: [
          Obx(() => controller.isSyncing
              ? const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                )
              : IconButton(
                  icon: const Icon(Icons.sync),
                  onPressed: _showSyncConfirmation,
                  tooltip: 'Sync Pending Registrations',
                ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTabContent(isPending: false),
                _buildTabContent(isPending: true),

              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        onTap: (index) => controller.changeTab(index),
        labelColor: Colors.green,
        unselectedLabelColor: Colors.grey,
        indicatorColor: Colors.green,
        tabs: [

          Tab(
            icon: Icon(Icons.cloud_done, size: 18),
            text: 'Submitted',
          ),
          Tab(
            icon: Icon(Icons.cloud_upload, size: 18),
            text: 'Pending',
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent({required bool isPending}) {
    return Obx(() {
      if (controller.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      final data = isPending ? controller.unsyncedData : controller.syncedData;

      if (data.isEmpty) {
        return _buildEmptyState(isPending: isPending);
      }

      return RefreshIndicator(
        onRefresh: () => controller.loadTreeData(),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: data.length,
          itemBuilder: (context, index) => _buildTreeCard(data[index]),
        ),
      );
    });
  }

  Widget _buildEmptyState({required bool isPending}) {
    return RefreshIndicator(
      onRefresh: () async => controller.loadTreeData(),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isPending ? Icons.cloud_upload : Icons.cloud_done,
                    size: 72,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    isPending
                        ? 'No Pending Registrations'
                        : 'No Submitted Registrations',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isPending
                        ? 'Tree registrations waiting to be synced will appear here.'
                        : 'All your submitted tree registrations will appear here.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () => controller.loadTreeData(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Refresh'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: fPrimaryColour,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTreeCard(TreeRegistrationModel registration) {
    return InkWell(
      onTap: () => Get.to(
            () => TreeRegistrationEditScreen(
          isIndividual:
          registration.farmerId != null && registration.farmerId! > 0,
          registrationId: registration.id!,
          registrationModel: registration,
        ),
      ),
      child: Card(
        elevation: 3,
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCardHeader(registration),
              const SizedBox(height: 10),
              _buildCardInfo(registration),
              const SizedBox(height: 12),
              _buildActionButtons(registration),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardHeader(TreeRegistrationModel reg) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Registration #${reg.id ?? 'N/A'}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildCardInfo(TreeRegistrationModel reg) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (reg.farmerId != null && reg.farmerId! > 0)
          _buildInfoRow('Farmer ID', '${reg.farmerId}'),
        if (reg.groupName?.isNotEmpty ?? false)
          _buildInfoRow('Group', reg.groupName!),
        _buildInfoRow('Establishment', reg.establishmentType ?? 'N/A'),
        _buildInfoRow('Trees', controller.getTreeCountText(reg)),
        Row(
          children: [
            Expanded(
              child: _buildInfoRow(
                'Created',
                controller.formatDate(reg.createdAt),
              ),
            ),
            Expanded(
              child: _buildInfoRow(
                'Updated',
                controller.formatDate(reg.updatedAt),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(TreeRegistrationModel reg) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _showDeleteDialog(reg),
            icon: const Icon(Icons.delete, size: 16),
            label: const Text('Delete'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: BorderSide(color: Colors.red.shade300),
            ),
          ),
        ),
      ],
    );
  }

  void _showDeleteDialog(TreeRegistrationModel reg) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Registration'),
        content: const Text(
          'Are you sure you want to delete this tree registration? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              await controller.deleteRegistration(reg);
              setState(() {});
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
