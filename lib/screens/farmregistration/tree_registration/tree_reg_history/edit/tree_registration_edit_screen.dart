import 'dart:io';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:get/get.dart';
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/controller/models/communinty_model.dart';
import 'package:hcms_revived2/controller/models/district_region_model.dart';
import 'package:hcms_revived2/controller/models/establishment_type_model.dart';
import 'package:hcms_revived2/controller/models/farmer_from_server.dart';
import 'package:hcms_revived2/controller/models/mmda_model.dart';
import 'package:hcms_revived2/controller/models/tree_registration_model.dart';
import 'package:hcms_revived2/screens/addedMaps/dependencies/custom_button.dart';
import 'package:hcms_revived2/screens/addedMaps/dependencies/double_value_trimmer.dart';
import 'package:hcms_revived2/screens/addedMaps/dependencies/globals.dart';
import 'package:hcms_revived2/screens/addedMaps/dependencies/tree_picking_tool/pick_tree_map.dart';
import 'package:hcms_revived2/screens/farmregistration/tree_registration/tree_reg_history/edit/tree_registration_edit_controller.dart';
import 'package:hcms_revived2/utils/widgets/textFields/generic_text_field.dart';

class TreeRegistrationEditScreen extends StatefulWidget {
  const TreeRegistrationEditScreen({
    super.key,
    required this.isIndividual,
    required this.existingRegistration,
  });

  final bool isIndividual;
  final TreeRegistrationModel existingRegistration;

  @override
  State<TreeRegistrationEditScreen> createState() => _TreeRegistrationEditScreenState();
}

class _TreeRegistrationEditScreenState extends State<TreeRegistrationEditScreen> {
  final TreeRegistrationEditController controller = Get.put(
    TreeRegistrationEditController(),
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.treeRegisterScreenContext = context;
      // Load all data first
      controller.loadAllData();
      // Initialize controller with existing data
      controller.initializeWithData(widget.existingRegistration);
    });
  }

  @override
  Widget build(BuildContext context) {
    controller.initializeWithData(widget.existingRegistration);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Get.back();
            controller.resetForm();
            controller.clearAllTrees();
          },
        ),
        title: const Text("Edit Tree Registration"),
        backgroundColor: fPrimaryColour,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.isIndividual) _buildFarmerSelectionSection(),
            const SizedBox(height: 20),
            _buildLocationSection(),
            const SizedBox(height: 20),
            _buildEstablishmentTypeSection(),
            const SizedBox(height: 20),
            widget.isIndividual
                ? _buildNextOfKinSection()
                : _buildGroupOnlySection(),
            const SizedBox(height: 20),
            _buildMappingSection(),
            const SizedBox(height: 20),
            _buildTreeDataSection(),
            const SizedBox(height: 20),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildTreeDataSection() {
    return GetBuilder<TreeRegistrationEditController>(
      builder: (controller) {
        return Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Tree Data",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Number of trees: ${controller.treeData.length}",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                if (controller.treeData.isNotEmpty)
                  ...controller.treeData.map((tree) {
                    debugPrint("THE TREE :::::::::::: ${tree}");
                    return ListTile(
                      leading: const Icon(Icons.park, color: Colors.green),
                      title: Text(tree['tree_name'] ?? 'Unknown Species'),
                      subtitle: Text('Size: ${tree['size'] ?? 'N/A'}'),
                      // trailing: IconButton(
                      //   icon: const Icon(Icons.delete, color: Colors.red),
                      //   onPressed: () {
                      //     controller.removeTree(tree['id'].toString());
                      //   },
                      // ),
                    );
                  }),
                if (controller.treeData.isEmpty)
                  const Center(
                    child: Text(
                      "No trees added yet",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGroupOnlySection() {
    return Column(
      children: [
        _buildTextField(
          title: "Group/Company Name",
          controller: controller.groupNameController,
        ),
        _buildTextField(
          title: "Group President",
          controller: controller.groupPresidentController,
        ),
        _buildTextField(
          title: "Group Secretary",
          controller: controller.groupSecretaryController,
        ),
        _buildTextField(
          title: "Company Directors",
          controller: controller.groupDirectorsController,
        ),
        _buildTextField(
          title: "Mobile Number",
          controller: controller.groupPhoneController,
          keyboardType: TextInputType.phone,
          maxLength: 10,
        ),
        _buildTextField(
          title: "Registration Number",
          controller: controller.groupregNumbController,
          isRequired: false,
        ),
        _buildTextField(
          title: "Email Address",
          controller: controller.groupEmailController,
          keyboardType: TextInputType.emailAddress,
        ),
        _buildTextField(
          title: "Postal Address",
          controller: controller.groupAddressController,
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String title,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    bool isRequired = false,
    int? maxLength,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            if (isRequired)
              const Text(
                ' *',
                style: TextStyle(color: Colors.red, fontSize: 14),
              ),
          ],
        ),
        const SizedBox(height: 8),
        TextFieldWidget(
          keyboardType: keyboardType,
          controller: controller,
          maxLength: maxLength,
          decoration: InputDecoration(
            hintText: 'Enter $title',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: fPrimaryColour, width: 2),
            ),
          ),
          validator: (input) {
            if (isRequired && (input == null || input.trim().isEmpty)) {
              return 'Please enter $title';
            }
            if (keyboardType == TextInputType.phone && input != null) {
              if (input.trim().length < 10) {
                return 'Phone number must be 10 digits';
              }
              if (input.trim().length > 10) {
                return 'Phone number cannot exceed 10 digits';
              }
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildMappingSection() {
    return GetBuilder<TreeRegistrationEditController>(
      builder: (controller) {
        final hasPolygon =
            controller.polygon.value != null &&
                controller.polygon.value!.points.isNotEmpty;

        return Column(
          children: [
            if (!hasPolygon) _buildEmptyMappingState(),
            if (hasPolygon) _buildMappingResult(context),
            const SizedBox(height: 16),
            _buildMapTreesButton(),
          ],
        );
      },
    );
  }

  Widget _buildMapTreesButton() {
    return GetBuilder<TreeRegistrationEditController>(
      builder: (controller) {
        return Container(
          width: double.maxFinite,
          padding: const EdgeInsets.symmetric(horizontal: 9),
          decoration: BoxDecoration(
            color: controller.treeData.isNotEmpty
                ? fPrimaryColour.withOpacity(0.1)
                : fSecondaryColour.withOpacity(0.1),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: controller.treeData.isNotEmpty
                  ? fPrimaryColour
                  : fSecondaryColour,
            ),
          ),
          child: CustomButton(
            isFullWidth: true,
            horizontalPadding: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (controller.treeData.isNotEmpty)
                  const Icon(Icons.check_circle, color: fPrimaryColour, size: 24),
                const SizedBox(width: 5),
                Text(
                  "Add more trees",
                  style: TextStyle(
                    color: controller.treeData.isNotEmpty
                        ? fPrimaryColour
                        : fSecondaryColour,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            onTap: () {
              controller.navigateToMap();
            },
          ),
        );
      },
    );
  }

  Widget _buildMappingResult(BuildContext ctx) {
    return GetBuilder<TreeRegistrationEditController>(
      builder: (controller) {
        return Material(
          elevation: 4,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            width: double.maxFinite,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, color: fPrimaryColour, size: 60),
                const SizedBox(height: 15),
                const Text(
                  "Boundary Mapped",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Mapped area estimates in hectares',
                        style: TextStyle(color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 15),
                      Text(
                        '${(controller.totalSizeAcres.value?.isNotEmpty ?? false) ? (double.tryParse(controller.totalSizeAcres.value ?? '0.0') ?? 0.0).truncateToDecimalPlaces(6).toString() : "0.0"} ha',
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),

                CustomButton(
                  horizontalPadding: 10,
                  isFullWidth: true,
                  backgroundColor: Colors.green,
                  verticalPadding: 16,
                  onTap: () {
                    Globals().primaryConfirmDialog(
                      context: ctx,
                      title: "Edit Boundary",
                      content: const Text(
                        "Please take note that proceeding means you are going to remap the farm boundary.",
                      ),
                      okayTap: () {
                        Navigator.pop(ctx);
                        controller.usePolygonDrawingTool();
                      },
                    );
                  },
                  child: const Text(
                    'Edit Boundary',
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
      },
    );
  }

  Widget _buildEmptyMappingState() {
    return Material(
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.map_outlined, color: Colors.grey[400], size: 60),
            const SizedBox(height: 15),
            const Text(
              "No Boundary Mapped",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Use the mapping tool to draw your farm boundary",
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 25),
            CustomButton(
              horizontalPadding: 10,
              isFullWidth: true,
              backgroundColor: fPrimaryColour,
              verticalPadding: 16,
              onTap: () {
                controller.usePolygonDrawingTool();
              },
              child: const Text(
                'Map Farm Boundary',
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

  Widget _buildFarmerSelectionSection() {
    return Obx(
          () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // _buildSectionTitle("Select Farmer"),
          const SizedBox(height: 12),
          _buildSearchableDropdownField(
            title: "Farmer",
            selectedItem: controller.selectedFarmer.value,
            displayText: controller.selectedFarmer.value != null
                ? '${controller.selectedFarmer.value!.farmerName} - ${controller.selectedFarmer.value!.contact}'
                : "Select Farmer",
            onTap: _showFarmerSelectionBottomSheet,
            isLoading: false,
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Region Dropdown
        Obx(
              () => _buildSearchableDropdownField(
            title: "Region",
            selectedItem: controller.selectedRegion.value,
            displayText:
            controller.selectedRegion.value?.regionName ?? "Select Region",
            onTap: () => _showRegionSelectionBottomSheet(),
            isLoading: controller.isLoadingRegions.value,
          ),
        ),
        const SizedBox(height: 16),
        // District Dropdown
        Obx(
              () => _buildSearchableDropdownField(
            title: "District",
            selectedItem: controller.selectedDistrict.value,
            displayText:
            controller.selectedDistrict.value?.districtName ??
                "Select District",
            onTap: controller.selectedRegion.value != null
                ? () => _showDistrictSelectionBottomSheet()
                : null,
            isLoading: controller.isLoadingDistricts.value,
            enabled: controller.selectedRegion.value != null,
            disabledMessage: controller.selectedRegion.value == null
                ? 'Please select a region first'
                : null,
          ),
        ),
        const SizedBox(height: 16),
        // MMDA Dropdown
        Obx(
              () => _buildSearchableDropdownField(
            title: "MMDA",
            selectedItem: controller.selectedMMDA.value,
            displayText: controller.selectedMMDA.value?.mmda ?? "Select MMDA",
            onTap: controller.selectedDistrict.value != null
                ? () => _showMMDASelectionBottomSheet()
                : null,
            isLoading: controller.isLoadingMMDAs.value,
            enabled: controller.selectedDistrict.value != null,
            disabledMessage: controller.selectedDistrict.value == null
                ? 'Please select a district first'
                : null,
          ),
        ),
        const SizedBox(height: 16),
        // Community Dropdown
        Obx(
              () => _buildSearchableDropdownField(
            title: "Community",
            selectedItem: controller.selectedCommunity.value,
            displayText:
            controller.selectedCommunity.value?.community ??
                "Select Community",
            onTap: () => _showCommunitySelectionBottomSheet(),
            isLoading: controller.isLoadingCommunities.value,
            enabled: controller.selectedMMDA.value != null,
            disabledMessage: controller.selectedMMDA.value == null
                ? 'Please select an MMDA first'
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchableDropdownField({
    required String title,
    required dynamic selectedItem,
    required String displayText,
    required VoidCallback? onTap,
    required bool isLoading,
    bool enabled = true,
    String? disabledMessage,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRequiredLabel(title),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: enabled ? onTap : null,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(
                color: enabled ? Colors.grey.shade400 : Colors.grey.shade300,
              ),
              borderRadius: BorderRadius.circular(8),
              color: enabled ? Colors.white : Colors.grey.shade100,
            ),
            child: Row(
              children: [
                if (isLoading)
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: fPrimaryColour,
                    ),
                  )
                else
                  Expanded(
                    child: Text(
                      displayText,
                      style: TextStyle(
                        fontSize: 16,
                        color: enabled
                            ? (selectedItem != null
                            ? Colors.black87
                            : Colors.grey)
                            : Colors.grey.shade500,
                      ),
                    ),
                  ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_drop_down,
                  color: enabled ? Colors.grey : Colors.grey.shade400,
                ),
              ],
            ),
          ),
        ),
        if (!enabled && disabledMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              disabledMessage,
              style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _buildEstablishmentTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Obx(
              () => _buildSearchableDropdownField(
            title: "Establishment Type",
            selectedItem: controller.selectedEstablishmentType.value,
            displayText:
            controller.selectedEstablishmentType.value?.esta_type ??
                "Select Establishment Type",
            onTap: () => _showEstablishmentTypeSelectionBottomSheet(),
            isLoading: controller.isLoadingEstablishmentTypes.value,
            enabled: !controller.isLoadingEstablishmentTypes.value,
          ),
        ),
      ],
    );
  }

  Widget _buildNextOfKinSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        _buildRequiredLabel("Next of Kin Name"),
        const SizedBox(height: 8),
        TextFieldWidget(
          decoration: const InputDecoration(
            hintText: "Enter next of kin full name",
            border: OutlineInputBorder(),
          ),
          controller: controller.nextOfKinNameController,
        ),
        const SizedBox(height: 16),
        _buildRequiredLabel("Relationship"),
        const SizedBox(height: 8),
        TextFieldWidget(
          decoration: const InputDecoration(
            hintText: "Enter relationship",
            border: OutlineInputBorder(),
          ),
          controller: controller.relationShipWithNextOfKinController,
        ),
        const SizedBox(height: 16),
        _buildKinDateOfBirthField(),
        const SizedBox(height: 16),
        _buildKinGenderField(),
        const SizedBox(height: 16),
        _buildRequiredLabel("Phone Number"),
        const SizedBox(height: 8),
        TextFieldWidget(
          keyboardType: TextInputType.phone,
          maxLength: 10,
          decoration: const InputDecoration(
            hintText: "Enter phone number",
            border: OutlineInputBorder(),
          ),
          controller: controller.phoneNumberController,
        ),
        const SizedBox(height: 16),
        _buildRequiredLabel("Postal Address"),
        const SizedBox(height: 8),
        TextFieldWidget(
          decoration: const InputDecoration(
            hintText: "Enter postal address",
            border: OutlineInputBorder(),
          ),
          controller: controller.postalAddressController,
        ),
      ],
    );
  }

  Widget _buildKinDateOfBirthField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRequiredLabel("Date of Birth"),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            DatePicker.showDatePicker(
              context,
              theme: const DatePickerTheme(
                backgroundColor: fPrimaryColour,
                itemStyle: TextStyle(color: Color(0xFFf9f9f9)),
                cancelStyle: TextStyle(color: Color(0xFFffe423)),
                doneStyle: TextStyle(color: Color(0xFFf9f9f9)),
                containerHeight: 210.0,
              ),
              showTitleActions: true,
              minTime: DateTime(1800, 1, 1),
              maxTime: DateTime.now(),
              onConfirm: (date) {
                controller.dobController.text =
                '${date.year}-${date.month}-${date.day}';
              },
              locale: LocaleType.en,
            );
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  controller.dobController.text.isEmpty
                      ? "Select Date of Birth"
                      : controller.dobController.text,
                  style: TextStyle(
                    color: controller.dobController.text.isEmpty
                        ? Colors.grey
                        : Colors.black87,
                  ),
                ),
                Icon(Icons.calendar_today, color: fPrimaryColour),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildKinGenderField() {
    return GetBuilder<TreeRegistrationEditController>(
      builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRequiredLabel("Gender"),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                _buildGenderChip("Male", "male"),
                _buildGenderChip("Female", "female"),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildGenderChip(String label, String value) {
    return GetBuilder<TreeRegistrationEditController>(
      builder: (controller) {
        final isSelected = controller.genderController.text == value;
        return ChoiceChip(
          label: Text(label),
          selected: isSelected,
          onSelected: (selected) {
            controller.genderController.text = selected ? value : '';
          },
          selectedColor: fPrimaryColour,
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
          ),
        );
      },
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () async {
              if (controller.validateForm()) {
                await controller.updateTreeData();
              } else {
                Get.snackbar(
                  'Validation Error',
                  "Please fill all required fields",
                  snackPosition: SnackPosition.TOP,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              }
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: BorderSide(color: fPrimaryColour),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Update',
              style: TextStyle(
                color: fPrimaryColour,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () async {
              if (controller.validateForm()) {
                await controller.submitUpdatedTreeData();
              } else {
                Get.snackbar(
                  'Validation Error',
                  "Please fill all required fields",
                  snackPosition: SnackPosition.TOP,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: fPrimaryColour,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Submit',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Helper widgets
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildRequiredLabel(String text) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const TextSpan(
            text: ' *',
            style: TextStyle(
              color: Colors.red,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // Bottom Sheet Methods (same as original, but using EditController)
  void _showFarmerSelectionBottomSheet() {
    _showSearchableBottomSheet<FarmerFromServerModel>(
      title: "Select Farmer",
      items: controller.farmerData,
      searchHint: "Search by name...",
      itemBuilder: (farmer) => ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        leading: CircleAvatar(
          backgroundColor: fPrimaryColour,
          child: const Icon(Icons.person, color: Colors.white),
        ),
        title: Text(
          farmer.farmerName,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          farmer.contact,
          style: TextStyle(color: Colors.grey[600]),
        ),
        trailing: controller.selectedFarmer.value?.id == farmer.id
            ? Icon(Icons.check_circle, color: fPrimaryColour)
            : null,
      ),
      onItemSelected: (farmer) {
        controller.selectFarmer(farmer);
        Navigator.pop(context);
      },
      filter: (farmer, query) {
        return (farmer.farmerName).toLowerCase().contains(query.toLowerCase());
      },
    );
  }

  void _showRegionSelectionBottomSheet() {
    _showSearchableBottomSheet<DistrictModel>(
      title: "Select Region",
      items: controller.regionsData,
      searchHint: "Search regions...",
      itemBuilder: (region) => ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        leading: CircleAvatar(
          backgroundColor: fPrimaryColour,
          child: const Icon(Icons.map, color: Colors.white),
        ),
        title: Text(
          region.regionName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        trailing: controller.selectedRegion.value?.id == region.id
            ? Icon(Icons.check_circle, color: fPrimaryColour)
            : null,
      ),
      onItemSelected: (region) {
        controller.selectRegion(region);
        Navigator.pop(context);
      },
      filter: (region, query) {
        return (region.regionName).toLowerCase().contains(query.toLowerCase());
      },
    );
  }

  void _showDistrictSelectionBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Obx(() {
        return Container(
          padding: const EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
            children: [
              Text(
                'Select District (${controller.selectedRegion.value?.regionName ?? ''})',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: controller.isLoadingDistricts.value
                    ? const Center(child: CircularProgressIndicator())
                    : controller.filteredDistricts.isEmpty
                    ? const Center(child: Text('No districts available'))
                    : ListView.builder(
                  itemCount: controller.filteredDistricts.length,
                  itemBuilder: (context, index) {
                    final district = controller.filteredDistricts[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      leading: CircleAvatar(
                        backgroundColor: fPrimaryColour,
                        child: const Icon(
                          Icons.location_city,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        district.districtName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing:
                      controller.selectedDistrict.value?.districtId ==
                          district.districtId
                          ? Icon(
                        Icons.check_circle,
                        color: fPrimaryColour,
                      )
                          : null,
                      onTap: () {
                        controller.selectDistrict(district);
                        Navigator.pop(context);
                      },
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

  void _showMMDASelectionBottomSheet() {
    _showSearchableBottomSheet<MMDAModel>(
      title: "Select MMDA",
      items: controller.mmdasData,
      searchHint: "Search MMDAs...",
      itemBuilder: (mmda) => ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        leading: CircleAvatar(
          backgroundColor: fPrimaryColour,
          child: const Icon(Icons.account_balance, color: Colors.white),
        ),
        title: Text(
          mmda.mmda ?? 'Unknown MMDA',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        trailing: controller.selectedMMDA.value?.id == mmda.id
            ? Icon(Icons.check_circle, color: fPrimaryColour)
            : null,
      ),
      onItemSelected: (mmda) {
        controller.selectMMDA(mmda);
        Navigator.pop(context);
      },
      filter: (mmda, query) {
        return (mmda.mmda ?? '').toLowerCase().contains(query.toLowerCase());
      },
    );
  }

  void _showCommunitySelectionBottomSheet() {
    _showSearchableBottomSheet<CommunityModel>(
      title: "Select Community",
      items: controller.communitiesData,
      searchHint: "Search communities...",
      itemBuilder: (community) => ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        leading: CircleAvatar(
          backgroundColor: fPrimaryColour,
          child: const Icon(Icons.people, color: Colors.white),
        ),
        title: Text(
          community.community ?? 'Unknown Community',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        trailing: controller.selectedCommunity.value?.id == community.id
            ? Icon(Icons.check_circle, color: fPrimaryColour)
            : null,
      ),
      onItemSelected: (community) {
        controller.selectCommunity(community);
        Navigator.pop(context);
      },
      filter: (community, query) {
        return (community.community ?? '').toLowerCase().contains(
          query.toLowerCase(),
        );
      },
    );
  }

  void _showEstablishmentTypeSelectionBottomSheet() {
    _showSearchableBottomSheet<EstaTypeModel>(
      title: "Select Establishment Type",
      items: controller.establishmentTypesData,
      searchHint: "Search establishment types...",
      itemBuilder: (type) => ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        leading: CircleAvatar(
          backgroundColor: fPrimaryColour,
          child: const Icon(Icons.category, color: Colors.white),
        ),
        title: Text(
          type.esta_type ?? 'Unknown Type',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        trailing: controller.selectedEstablishmentType.value?.id == type.id
            ? Icon(Icons.check_circle, color: fPrimaryColour)
            : null,
      ),
      onItemSelected: (type) {
        controller.selectEstablishmentType(type);
        Navigator.pop(context);
      },
      filter: (type, query) {
        return (type.esta_type ?? '').toLowerCase().contains(
          query.toLowerCase(),
        );
      },
    );
  }

  void _showSearchableBottomSheet<T>({
    required String title,
    required List<T> items,
    required String searchHint,
    required Widget Function(T) itemBuilder,
    required Function(T) onItemSelected,
    required bool Function(T, String) filter,
  }) {
    final TextEditingController searchController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return GetBuilder<TreeRegistrationEditController>(
          builder: (controller) {
            List<T> filteredItems = items.where((item) {
              if (searchController.text.isEmpty) return true;
              return filter(item, searchController.text);
            }).toList();

            return Container(
              height: MediaQuery.of(context).size.height * 0.8,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: fPrimaryColour,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Colors.white, size: 24),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextField(
                      controller: searchController,
                      // onChanged: (_) => controller!.update(),
                      decoration: InputDecoration(
                        hintText: searchHint,
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Text(
                          "Found ${filteredItems.length} item(s)",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: filteredItems.isEmpty
                        ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            "No items found",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    )
                        : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: InkWell(
                            onTap: () => onItemSelected(item),
                            child: itemBuilder(item),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          side: BorderSide(color: fPrimaryColour),
                        ),
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            color: fPrimaryColour,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}