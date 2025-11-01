import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/screens/Deforestation/deforestation_report_controller.dart';
import 'package:hcms_revived2/screens/Deforestation/widgets/deforstation_widgets.dart';
import 'package:hcms_revived2/utils/widgets/textFields/generic_text_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

class DeforestationScreen extends StatelessWidget {
  final DeforestationController controller = Get.put(DeforestationController());
  final CameraService cameraService = Get.put(CameraService());

  DeforestationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: fPrimaryColour,
        leading: IconButton(
          onPressed: () async {
            // RESET FORM STATE BEFORE GOING BACK
            await controller.resetFormState();
            cameraService.clearPhoto();
            controller.updatePhotoBase64('');
            Get.back();
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: const Text(
          "Deforestation Report",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
          ),
        ),

      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return _buildLoadingScreen();
        }

        return DeforestationForm(
          controller: controller,
          cameraService: cameraService,
        );
      }),
    );
  }

  Widget _buildLoadingScreen() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(
            'Loading...',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  void _handleMenuAction(String choice) {
    switch (choice) {
      case 'clear':
        _showClearFormDialog();
        break;
      case 'history':
      // Navigate to history screen
      // Get.to(() => DeforestationHistoryScreen());
        break;
    }
  }

  void _showClearFormDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Clear Form'),
        content: const Text('Are you sure you want to clear all form data?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              await controller.resetFormState(); // UPDATED
            },
            child: const Text(
              'Clear',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

class BuildSectionCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;

  const BuildSectionCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16.0),
    this.backgroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: padding!,
        child: child,
      ),
    );
  }
}

class DeforestationForm extends StatelessWidget {
  final DeforestationController controller;
  final CameraService cameraService;

  const DeforestationForm({
    super.key,
    required this.controller,
    required this.cameraService,
  });

  @override
  Widget build(BuildContext context) {
    controller.startAutomaticLocationCapture();
    return Form(
      child: Column(
        children: [
          Obx(() {
            if (controller.errorMessage.isNotEmpty) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        controller.errorMessage.value,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 16, color: Colors.red),
                      onPressed: () => controller.errorMessage.value = '',
                    ),
                  ],
                ),
              );
            }
            return const SizedBox();
          }),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // GPS Coordinates Section
                  // Obx(() => BuildSectionCard(
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       Row(
                  //         children: [
                  //           Icon(
                  //             Icons.location_on,
                  //             color: fPrimaryColour,
                  //             size: 28,
                  //           ),
                  //           const SizedBox(width: 12),
                  //           const Text(
                  //             "GPS Coordinates",
                  //             style: TextStyle(
                  //               fontSize: 18,
                  //               fontWeight: FontWeight.bold,
                  //               color: Colors.black87,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //       const SizedBox(height: 16),
                  //       _buildLocationStatus(),
                  //       const SizedBox(height: 16),
                  //       _buildLocationDetails(),
                  //     ],
                  //   ),
                  // )),
                  //
                  const SizedBox(height: 16),

                  Obx(
                        () => _buildSearchableDropdownField(
                      title: "Community",
                      selectedItem: controller.selectedCommunity.value,
                      displayText: controller.selectedCommunity.value?.community ?? "Select Community",
                      onTap: () => _showCommunitySelectionBottomSheet(context),
                      isLoading: controller.isLoadingCommunities.value,
                      enabled: !controller.isLoadingCommunities.value,
                    ),
                  ),

                  // GFW Direction Question
                  BuildSectionCard(
                    child: Obx(() => BuildChoiceChips(
                      label: "Were you directed to this location by Global Forest Watch (GFW)?",
                      options: [
                        {'value': 'yes', 'label': 'Yes'},
                        {'value': 'no', 'label': 'No'},
                      ],
                      selectedValue: controller.formData.value.gfwDirection,
                      onSelected: controller.updateGfwDirection,
                    )),
                  ),

                  // Deforestation Question
                  BuildSectionCard(
                    child: Obx(() => BuildChoiceChips(
                      label: "Do you see deforestation at this location?",
                      options: [
                        {'value': 'yes', 'label': 'Yes'},
                        {'value': 'no', 'label': 'No'},
                      ],
                      selectedValue: controller.formData.value.seeDeforestation,
                      onSelected: controller.updateSeeDeforestation,
                    )),
                  ),

                  // Causes Section (only show if deforestation is seen)
                  Obx(() {
                    if (controller.formData.value.seeDeforestation == "yes") {
                      return Column(
                        children: [
                          BuildSectionCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                BuildSectionTitle(
                                  title: "Deforestation Causes",
                                  subtitle: "Select all causes that apply",
                                ),
                              ],
                            ),
                          ),
                          BuildSectionCard(
                            padding: const EdgeInsets.all(16),
                            child: DeforestationCausesGrid(controller: controller),
                          ),
                        ],
                      );
                    }
                    return const SizedBox();
                  }),

                  // Further Action Section
                  BuildSectionCard(
                    child: Obx(() => BuildChoiceChips(
                      label: "Do you think further action should be taken?",
                      options: [
                        {'value': 'yes', 'label': 'Yes'},
                        {'value': 'no', 'label': 'No'},
                      ],
                      selectedValue: controller.formData.value.actionRequired,
                      onSelected: controller.updateActionRequired,
                    )),
                  ),

                  // Why Action Section (only show if action is required)
                  Obx(() {
                    if (controller.formData.value.actionRequired == "yes") {
                      return BuildSectionCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Why should action be taken?",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextFieldWidget(
                              controller: TextEditingController(
                                text: controller.formData.value.whyAction ?? '',
                              ),
                              onChanged: controller.updateWhyAction,
                              decoration: InputDecoration(
                                hintText: "Explain why action is needed...",
                                filled: true,
                                fillColor: Colors.grey[50],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.grey[300]!,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: fPrimaryColour,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox();
                  }),

                  // Photo Section
                  BuildSectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.camera_alt,
                              color: fPrimaryColour,
                              size: 28,
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              "Photo Evidence",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildPhotoSection(),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Submit Button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              child: Obx(() => ElevatedButton(
                onPressed: () => _showSubmissionOptions(context),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: fPrimaryColour,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: controller.isLoading.value
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                    : const Text(
                  "Finish",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchableDropdownField({
    required String title,
    required dynamic selectedItem,
    required String displayText,
    required VoidCallback onTap,
    required bool isLoading,
    required bool enabled,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: enabled ? onTap : null,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: enabled ? Colors.white : Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: enabled ? Colors.grey[300]! : Colors.grey[200]!,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      displayText,
                      style: TextStyle(
                        color: enabled ? Colors.black87 : Colors.grey[500],
                        fontSize: 15,
                      ),
                    ),
                  ),
                  if (isLoading)
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  else
                    Icon(
                      Icons.arrow_drop_down,
                      color: enabled ? Colors.grey[600] : Colors.grey[400],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCommunitySelectionBottomSheet(BuildContext context) {
    final controller = Get.find<DeforestationController>();
    final searchController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Obx(() {
        final filteredCommunities = searchController.text.isEmpty
            ? controller.communities
            : controller.searchCommunities(searchController.text);

        return Container(
          padding: const EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height * 0.6,
          child: Column(
            children: [
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search community...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onChanged: (_) => controller.update(),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: controller.isLoadingCommunities.value
                    ? const Center(child: CircularProgressIndicator())
                    : filteredCommunities.isEmpty
                    ? const Center(child: Text('No communities found'))
                    : ListView.builder(
                  itemCount: filteredCommunities.length,
                  itemBuilder: (context, index) {
                    final community = filteredCommunities[index];
                    return ListTile(
                      title: Text(community.community ?? ''),
                      onTap: () {
                        controller.setSelectedCommunity(community);
                        Navigator.pop(context);
                      },
                      selected: controller.selectedCommunity.value?.id == community.id,
                      selectedTileColor: Colors.blue[50],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildLocationStatus() {
    final location = controller.formData.value.location;
    final isAccurate = controller.isLocationAccurate;
    final isListening = controller.locationService.isListening.value;

    if (location == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.orange[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.orange),
        ),
        child: Row(
          children: [
            const CircularProgressIndicator(strokeWidth: 2),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Acquiring GPS Signal",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.orange,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Please wait while we get your location...",
                    style: TextStyle(fontSize: 12, color: Colors.orange),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    Color statusColor = isAccurate ? Colors.green : Colors.orange;
    IconData statusIcon = isAccurate ? Icons.check_circle : Icons.gps_fixed;
    String statusText = isAccurate ? 'Location Ready' : 'Improving Accuracy';
    String accuracyText = 'Accuracy: ${location.accuracy?.toStringAsFixed(2)}m';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor),
      ),
      child: Row(
        children: [
          Icon(statusIcon, color: statusColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  statusText,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  accuracyText,
                  style: TextStyle(fontSize: 12, color: statusColor),
                ),
                if (isListening && !isAccurate) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Searching for better signal...',
                    style: TextStyle(fontSize: 12, color: statusColor),
                  ),
                ],
              ],
            ),
          ),
          if (!isAccurate)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: controller.recaptureLocation,
              tooltip: 'Recapture Location',
            ),
        ],
      ),
    );
  }

  Widget _buildLocationDetails() {
    final location = controller.formData.value.location;
    if (location == null) return const SizedBox();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        children: [
          _buildCoordinateRow("Latitude", location.latitude.toStringAsFixed(6)),
          const SizedBox(height: 8),
          _buildCoordinateRow("Longitude", location.longitude.toStringAsFixed(6)),
          if (location.altitude != null) ...[
            const SizedBox(height: 8),
            _buildCoordinateRow("Altitude", "${location.altitude!.toStringAsFixed(2)}m"),
          ],
          const SizedBox(height: 8),
          _buildCoordinateRow("Accuracy", "${location.accuracy?.toStringAsFixed(2)}m"),
        ],
      ),
    );
  }

  Widget _buildPhotoSection() {
    return Obx(() {
      final hasPhoto = cameraService.capturedImageBase64.isNotEmpty;

      return Column(
        children: [
          GestureDetector(
            onTap: _showPhotoOptions,
            child: Container(
              height: 200, // Fixed height for consistency
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(
                  color: hasPhoto ? Colors.green : Colors.grey[300]!,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
                color: hasPhoto ? Colors.green[50] : Colors.grey[50],
              ),
              child: hasPhoto
                  ? _buildPhotoPreview()
                  : _buildNoPhotoPlaceholder(),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => cameraService.capturePhoto(),
                  icon: const Icon(Icons.camera_alt, size: 20),
                  label: const Text("Take Photo"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: fPrimaryColour,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => cameraService.pickFromGallery(),
                  icon: const Icon(Icons.photo_library, size: 20),
                  label: const Text("Gallery"),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (hasPhoto) ...[
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () {
                cameraService.clearPhoto();
                controller.updatePhotoBase64('');
              },
              icon: const Icon(Icons.delete, size: 16, color: Colors.red),
              label: const Text(
                "Remove Photo",
                style: TextStyle(color: Colors.red),
              ),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ],
      );
    });
  }

  Widget _buildPhotoPreview() {
    return Stack(
      children: [
        // Display the actual captured image
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.memory(
              base64Decode(cameraService.capturedImageBase64.value),
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[200],
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, color: Colors.grey, size: 48),
                      SizedBox(height: 8),
                      Text(
                        'Failed to load image',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        // Overlay with photo info
        Positioned(
          bottom: 8,
          left: 8,
          right: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Photo Captured',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '${cameraService.imageSizeKB.toStringAsFixed(1)} KB',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
        // Tap to view overlay
        Positioned(
          top: 8,
          right: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'Tap to view',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNoPhotoPlaceholder() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.photo_camera, size: 48, color: Colors.grey),
        SizedBox(height: 12),
        Text(
          "No Photo Captured",
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Text(
          "Tap to capture a photo of the deforestation area",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  void _showPhotoOptions() {
    if (cameraService.hasPhoto) {
      Get.dialog(
        AlertDialog(
          title: const Text('Photo Options'),
          content: const Text('What would you like to do with the photo?'),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
                _showPhotoPreview();
              },
              child: const Text('View Photo'),
            ),
            TextButton(
              onPressed: () {
                Get.back();
                cameraService.capturePhoto();
              },
              child: const Text('Retake Photo'),
            ),
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Cancel'),
            ),
          ],
        ),
      );
    } else {
      cameraService.capturePhoto();
    }
  }

  void _showPhotoPreview() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(Get.context!).size.width * 0.9,
            maxHeight: MediaQuery.of(Get.context!).size.height * 0.8,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Captured Photo',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.memory(
                      base64Decode(cameraService.capturedImageBase64.value),
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.error_outline, color: Colors.grey, size: 64),
                              SizedBox(height: 16),
                              Text(
                                'Failed to load image',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.close),
                      label: const Text('Close'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Get.back();
                        cameraService.capturePhoto();
                      },
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Retake'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: fPrimaryColour,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCoordinateRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.grey[700], fontSize: 14, fontWeight: FontWeight.w500),
        ),
        Text(
          value,
          style: const TextStyle(
            color: fPrimaryColour,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  void _showSubmissionOptions(BuildContext context) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Column(
          children: [
            Icon(Icons.cloud_upload, size: 48, color: fPrimaryColour),
            SizedBox(height: 8),
            Text(
              "Submit Report",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "How would you like to submit this deforestation report?",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            SizedBox(height: 16),
          ],
        ),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      Get.back();
                      await controller.submitReportToServer();
                      cameraService.clearPhoto();
                      controller.updatePhotoBase64('');
                    },
                    icon: const Icon(Icons.wifi, size: 20),
                    label: const Text("Submit"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: fPrimaryColour,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      Get.back();
                      await controller.saveReportLocally();
                      cameraService.clearPhoto();
                      controller.updatePhotoBase64('');
                    },
                    icon: const Icon(Icons.save, size: 20),
                    label: const Text("Save"),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text("Cancel"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CameraService extends GetxController {
  final RxString capturedImageBase64 = ''.obs;
  final RxBool isCapturing = false.obs;
  final RxString errorMessage = ''.obs;

  final ImagePicker _picker = ImagePicker();

  // Capture photo from camera
  Future<void> capturePhoto() async {
    try {
      isCapturing.value = true;
      errorMessage.value = '';

      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (photo != null) {
        await _processImage(File(photo.path));
        // Update the controller with the captured photo
        final deforestationController = Get.find<DeforestationController>();
        deforestationController.updatePhotoBase64(capturedImageBase64.value);
      } else {
        errorMessage.value = 'No photo was taken';
      }
    } catch (e) {
      errorMessage.value = 'Failed to capture photo: $e';
    } finally {
      isCapturing.value = false;
    }
  }

  // Pick photo from gallery
  Future<void> pickFromGallery() async {
    try {
      isCapturing.value = true;
      errorMessage.value = '';

      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        await _processImage(File(image.path));
        // Update the controller with the captured photo
        final deforestationController = Get.find<DeforestationController>();
        deforestationController.updatePhotoBase64(capturedImageBase64.value);
      } else {
        errorMessage.value = 'No image was selected';
      }
    } catch (e) {
      errorMessage.value = 'Failed to pick image: $e';
    } finally {
      isCapturing.value = false;
    }
  }

  // Process and compress image
  Future<void> _processImage(File imageFile) async {
    try {
      // Read image file
      final originalBytes = await imageFile.readAsBytes();

      // Decode image
      final originalImage = img.decodeImage(originalBytes);
      if (originalImage == null) {
        throw Exception('Failed to decode image');
      }

      // Resize image to max 1200px width while maintaining aspect ratio
      final resizedImage = img.copyResize(
        originalImage,
        width: 1200,
        height: (originalImage.height * 1200 / originalImage.width).round(),
      );

      // Convert to JPEG and compress
      final jpegBytes = img.encodeJpg(resizedImage, quality: 80);

      // Convert to base64
      capturedImageBase64.value = base64Encode(jpegBytes);

    } catch (e) {
      errorMessage.value = 'Failed to process image: $e';
      rethrow;
    }
  }

  // Clear captured photo - ENHANCED
  void clearPhoto() {
    capturedImageBase64.value = '';
    errorMessage.value = '';
    isCapturing.value = false;
  }

  // NEW METHOD: Complete reset
  void reset() {
    clearPhoto();
  }

  @override
  void onClose() {
    reset();
    super.onClose();
  }

  // Get image file size in KB
  double get imageSizeKB {
    if (capturedImageBase64.isEmpty) return 0;
    return (capturedImageBase64.value.length * 3 / 4) / 1024;
  }

  bool get hasPhoto => capturedImageBase64.isNotEmpty;
}