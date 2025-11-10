import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hcms_revived2/controller/models/farmer_local_model.dart';
import 'package:hcms_revived2/screens/farmregistration/register_farmer/register_farmer.dart';
import 'package:hcms_revived2/screens/farmregistration/register_farmer/history/register_farmer_history_controller.dart';
import 'package:hcms_revived2/screens/farmregistration/register_farmer/register_farmer_controller.dart';

class FarmerBiodataHistoryScreen extends StatefulWidget {

  FarmerBiodataHistoryScreen({super.key});

  @override
  State<FarmerBiodataHistoryScreen> createState() => _FarmerBiodataHistoryScreenState();
}

class _FarmerBiodataHistoryScreenState extends State<FarmerBiodataHistoryScreen> {
  final RegisterFarmerHistoryController controller = Get.put(RegisterFarmerHistoryController());

  Future<void> _showSyncConfirmation() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sync Pending Farmers'),
        content: const Text('Are you sure you want to sync all pending farmers to the server?'),
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

    if (confirmed == true) {
      await controller.syncAllPendingFarmers(context);
      // Refresh both lists
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Farmers History'),
          actions: [
            Obx(() => controller.isLoading.value
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
                    tooltip: 'Sync Pending Farmers',
                  ),
            ),
          ],
          bottom: const TabBar(
            unselectedLabelColor: Colors.grey,
            labelColor: Colors.white,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Pending'),
              Tab(text: 'Submitted'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildFarmerList('pending'),
            _buildFarmerList('submitted'),
          ],
        ),
      ),
    );
  }

  Widget _buildFarmerList(String status) {
    return FutureBuilder<List<FarmerBiodataModel>>(
      future: status == 'pending'
          ? controller.getPendingFarmerBiodata()
          : controller.getSubmittedFarmerBiodata(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final farmers = snapshot.data ?? [];

        if (farmers.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.people_outline,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No ${status == 'pending' ? 'Pending' : 'Submitted'} Farmers',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: farmers.length,
          itemBuilder: (context, index) {
            final farmer = farmers[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: CircleAvatar(
                  child: Text(farmer.farmerName?.substring(0, 1) ?? 'F'),
                ),
                title: Text(
                  farmer.farmerName ?? 'Unknown Farmer',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (farmer.contact != null) Text('Contact: ${farmer.contact}'),
                    if (farmer.community != null) Text('Community: ${farmer.community}'),
                    Text('Status: ${farmer.status?.toUpperCase()}'),
                    if (farmer.createdAt != null)
                      Text(
                        'Created: ${_formatDate(farmer.createdAt!)}',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                  ],
                ),
                trailing: status == 'pending'
                    ? PopupMenuButton(
                  itemBuilder: (context) => [
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
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 20, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Delete'),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) async {
                    if (value == 'edit') {
                      await Get.to(() => FarmerBiodataFormScreen(editId: farmer.id));
                      setState(() {});
                    } else if (value == 'delete') {
                      await _showDeleteDialog(farmer);
                    }
                  },
                )
                    : null,
                onTap: () {
                  // Show details or edit for submitted forms
                  if (status == 'submitted') {
                    _showFarmerDetails(farmer);
                  }
                },
              ),
            );
          },
        );
      },
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  Future<void> _showDeleteDialog(FarmerBiodataModel farmer) async {
    await Get.dialog(
      AlertDialog(
        title: const Text('Delete Farmer'),
        content: Text('Are you sure you want to delete ${farmer.farmerName ?? "this farmer"}?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: (){},
            // onPressed: () async {
            //   Get.back();
            //   await controller.deleteFarmerBiodata(farmer.id!);
            //   controller.getAllFarmerBiodata();
            // },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showFarmerDetails(FarmerBiodataModel farmer) {
    Get.dialog(
      AlertDialog(
        title: const Text('Farmer Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Name', farmer.farmerName),
              _buildDetailRow('Contact', farmer.contact),
              _buildDetailRow('Community', farmer.community?.toString()),
              _buildDetailRow('Farmer Code', farmer.farmercode),
              _buildDetailRow('National ID', farmer.nationalid),
              _buildDetailRow('Cocoa Card', farmer.cocoaCard),
              _buildDetailRow('Gender', farmer.gender),
              _buildDetailRow('Age', farmer.age?.toString()),
              _buildDetailRow('Farm Size', farmer.farmSize?.toString()),
              _buildDetailRow('Small Holder Category', farmer.smallHolderCategory),
              _buildDetailRow('Status', farmer.status?.toUpperCase()),
              _buildDetailRow('Created', _formatDate(farmer.createdAt!)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value ?? 'Not provided'),
          ),
        ],
      ),
    );
  }
}