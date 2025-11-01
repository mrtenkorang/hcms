// farmer_list_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/controller/models/farmer_from_server.dart';
import 'farmer_list_controller.dart';

class FarmerListScreen extends GetView<FarmerListController> {
  const FarmerListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(FarmerListController());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Farmers Directory',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: fPrimaryColour,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, size: 24),
            onPressed: controller.refreshList,
            tooltip: 'Refresh List',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildStatsBar(),
          const SizedBox(height: 8),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return _buildLoadingState();
              }

              if (controller.filteredFarmers.isEmpty) {
                return _buildEmptyState();
              }

              return _buildFarmerList();
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        onChanged: controller.searchFarmers,
        decoration: InputDecoration(
          hintText: 'Search by name, code, or community...',
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          // suffixIcon: Obx(() {
          //   if (controller.searchQuery.isNotEmpty) {
          //     return IconButton(
          //       icon: const Icon(Icons.clear, color: Colors.grey),
          //       onPressed: () {
          //         controller.searchFarmers('');
          //         // Clear the text field
          //         final textField = context.findAncestorWidgetOfExactType<TextField>();
          //         if (textField != null) {
          //           // You might need to use a TextEditingController for this
          //         }
          //       },
          //     );
          //   }
          //   return Container();
          // }),
        ),
      ),
    );
  }

  Widget _buildStatsBar() {
    return Obx(() {
      final totalFarmers = controller.filteredFarmers.length;
      final filteredCount = controller.filteredFarmers.length;
      final isFiltered = controller.searchQuery.isNotEmpty;

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              isFiltered ? 'Showing $filteredCount farmers' : 'Total: $totalFarmers farmers',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (isFiltered)
              Text(
                '${((filteredCount / totalFarmers) * 100).toStringAsFixed(1)}% of total',
                style: TextStyle(
                  color: fPrimaryColour,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
      );
    });
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(
            'Loading farmers...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            controller.searchQuery.isEmpty
                ? 'No farmers available'
                : 'No matching farmers found',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            controller.searchQuery.isEmpty
                ? 'Farmers will appear here once loaded'
                : 'Try a different search term',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          if (controller.searchQuery.isNotEmpty) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => controller.searchFarmers(''),
              style: ElevatedButton.styleFrom(
                backgroundColor: fPrimaryColour,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('Clear Search'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFarmerList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: controller.filteredFarmers.length,
      itemBuilder: (context, index) {
        final farmer = controller.filteredFarmers[index];
        return _buildFarmerCard(farmer);
      },
    );
  }

  Widget _buildFarmerCard(FarmerFromServerModel farmer) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _showFarmerDetails(farmer),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Avatar
              _buildFarmerAvatar(farmer),
              const SizedBox(width: 16),
              // Farmer Info
              Expanded(
                child: _buildFarmerInfo(farmer),
              ),
              // Action Arrow
              Icon(
                Icons.chevron_right,
                color: Colors.grey[400],
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFarmerAvatar(FarmerFromServerModel farmer) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: fPrimaryColour.withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: fPrimaryColour.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          farmer.farmerName?.isNotEmpty == true
              ? farmer.farmerName[0].toUpperCase()
              : 'F',
          style: TextStyle(
            color: fPrimaryColour,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildFarmerInfo(FarmerFromServerModel farmer) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Name
        Text(
          farmer.farmerName ?? 'Unknown Farmer',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.black87,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 6),
        // Farmer Code
        ...[
        _buildInfoRow(
          Icons.badge,
          'Code: ${farmer.farmercode}',
        ),
        const SizedBox(height: 4),
      ],
        // Contact
        ...[
        _buildInfoRow(
          Icons.phone,
          farmer.contact,
        ),
        const SizedBox(height: 4),
      ],
        // Community
      //   ...[
      //   _buildInfoRow(
      //     Icons.location_on,
      //     farmer.community,
      //   ),
      // ],
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: Colors.grey[500],
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 13,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  void _showFarmerDetails(FarmerFromServerModel farmer) {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [
              // Header
              _buildBottomSheetHeader(farmer),
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailSection(farmer),
                      const SizedBox(height: 24),
                      _buildActionButtons(farmer),
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

  Widget _buildBottomSheetHeader(FarmerFromServerModel farmer) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: fPrimaryColour,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(35),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 3,
              ),
            ),
            child: Center(
              child: Text(
                farmer.farmerName?.isNotEmpty == true
                    ? farmer.farmerName[0].toUpperCase()
                    : 'F',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Name and basic info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  farmer.farmerName ?? 'Unknown Farmer',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                ...[
                const SizedBox(height: 4),
                Text(
                  'Farmer Code: ${farmer.farmercode}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
              ],
              ],
            ),
          ),
          // Close button
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white, size: 24),
            onPressed: () => Navigator.pop(Get.context!),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailSection(FarmerFromServerModel farmer) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Contact Information
        ...[
        _buildDetailItem(
          icon: Icons.phone,
          title: 'Contact',
          value: farmer.contact,
        ),
        const SizedBox(height: 16),
      ],
        // Community
      //   ...[
      //   _buildDetailItem(
      //     icon: Icons.location_on,
      //     title: 'Community',
      //     value: farmer.community,
      //   ),
      //   const SizedBox(height: 16),
      // ],
        // Landscape
        ...[
        _buildDetailItem(
          icon: Icons.landscape,
          title: 'Landscape',
          value: farmer.landscape,
        ),
        const SizedBox(height: 16),
      ],
        // Gender
        ...[
        _buildDetailItem(
          icon: Icons.person,
          title: 'Gender',
          value: farmer.gender,
        ),
        const SizedBox(height: 16),
      ],
        // Age
        ...[
        _buildDetailItem(
          icon: Icons.cake,
          title: 'Age',
          value: '${farmer.age} years',
        ),
        const SizedBox(height: 16),
      ],
        // National ID
        ...[
        _buildDetailItem(
          icon: Icons.badge,
          title: 'National ID',
          value: farmer.nationalid,
        ),
        const SizedBox(height: 16),
      ],
        // Cocoa Card
        ...[
        _buildDetailItem(
          icon: Icons.credit_card,
          title: 'Cocoa Card',
          value: farmer.cocoaCard,
        ),
        const SizedBox(height: 16),
      ],
        // Membership RA
        _buildDetailItem(
          icon: Icons.group,
          title: 'Membership RA',
          value: farmer.membershipRa == true ? 'Yes' : 'No',
          valueColor: farmer.membershipRa == true ? Colors.green : Colors.grey,
        ),
      ],
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String title,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: fPrimaryColour.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 20,
            color: fPrimaryColour,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  color: valueColor ?? Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(FarmerFromServerModel farmer) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              Navigator.pop(Get.context!);
              Get.snackbar(
                'Contact Farmer',
                'Calling ${farmer.contact ?? "this farmer"}...',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            icon: const Icon(Icons.phone, size: 18),
            label: const Text('Call'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: BorderSide(color: fPrimaryColour),
            ),
          ),
        ),

      ],
    );
  }
}