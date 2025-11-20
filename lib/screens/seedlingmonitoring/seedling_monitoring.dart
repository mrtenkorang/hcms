import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:get/get.dart';
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/controller/models/communinty_model.dart';
import 'package:hcms_revived2/controller/models/farmer_from_server.dart';
import 'package:hcms_revived2/screens/addedMaps/dependencies/custom_button.dart';
import 'package:hcms_revived2/screens/addedMaps/dependencies/style.dart';
import 'package:hcms_revived2/screens/addedMaps/dependencies/tree_picking_tool/pick_tree_map.dart';
import 'package:hcms_revived2/screens/addedMaps/dependencies/tree_picking_tool/pick_tree_map_controller.dart';
import 'package:hcms_revived2/screens/addedMaps/dependencies/user_current_location.dart'
    show UserCurrentLocation;
import 'package:hcms_revived2/screens/addedMaps/farm_cord_drawing_map.dart';
import 'package:hcms_revived2/utils/constants/colours.dart';
import 'package:hcms_revived2/utils/widgets/appBars/section_header.dart'
    show SectionHeader;
import 'package:hcms_revived2/utils/widgets/expasion/specie_expansion_tile.dart';
import 'package:hcms_revived2/utils/widgets/textFields/custom_textfield.dart';

import 'seedling_monitoring_controller.dart';

class SeedlingMonitoringScreen extends StatefulWidget {
  const SeedlingMonitoringScreen({super.key});

  @override
  State<SeedlingMonitoringScreen> createState() =>
      _SeedlingMonitoringScreenState();
}

class _SeedlingMonitoringScreenState extends State<SeedlingMonitoringScreen> {
  final SeedlingMonitoringController controller = Get.put(
    SeedlingMonitoringController(),
  );

  late final PageController _pageController;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      UserCurrentLocation? userCurrentLocation = UserCurrentLocation(
        context: context,
      );
      userCurrentLocation.getUserLocation(
        forceEnableLocation: true,
        onLocationEnabled: (isEnabled, pos) {
          if (isEnabled == true) {
            debugPrint("THE LOCATION IS ENABLED::::: $pos");
          }
        },
      );
    });

    super.initState();
    controller.loadCommunities();
    _pageController = PageController(initialPage: 0);

    ever(controller.currentPage, (int page) {
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          page,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    controller.seedlingMonitoringScreenContext = context;
    controller.loadFarmerData();
    controller.loadUser();
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildProgressIndicator(),
          Expanded(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              onPageChanged: (index) => controller.currentPage.value = index,
              children: [
                _buildFarmerSearchPage(),
                _buildGeneralInfoPage(),
                _buildPlantationDetailsPage(),
                _buildSpeciesDetailsPage(),
                _buildMappedAreaPage(),
                _buildSeedlingSurvivalPage(),
                _buildEnvironmentalConditionsPage(),
                _buildFinalObservationsPage(),
              ],
            ),
          ),
          _buildNavigationButtons(),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(
        'Seedling Monitoring',
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
      ),
      elevation: 1,
      centerTitle: true,
      iconTheme: IconThemeData(color: fPrimaryColour),
      actions: [
        TextButton(
          onPressed: () async {
            bool? confirmed = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Save and Continue Later'),
                content: const Text(
                  'Are you sure you want to save and continue later?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Save'),
                  ),
                ],
              ),
            );

            if (confirmed == true) {
              controller.saveDataOffline();
            }
          },
          child: Text(
            "Save",
            style: TextStyle(color: AppColor.white, fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressIndicator() {
    return Obx(
      () => Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(
              value: (controller.currentPage.value + 1) / 8,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(fPrimaryColour),
              minHeight: 6,
              borderRadius: BorderRadius.circular(3),
            ),
            const SizedBox(height: 8),
            Text(
              'Step ${controller.currentPage.value + 1} of 8',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFarmerSearchPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Find Farmer',
            subtitle: 'Select farmer from the list and proceed',
          ),
          const SizedBox(height: 24),
          _buildSearchableDropdownField(
            title: "Farmer",
            selectedItem: controller.selectedFarmer.value,
            displayText: controller.selectedFarmer.value != null
                ? '${controller.selectedFarmer.value!.farmerName} - ${controller.selectedFarmer.value!.contact}'
                : "Select Farmer",
            onTap: () => _showFarmerSelectionBottomSheet(context),
            isLoading: false,
          ),
          const SizedBox(height: 16),
          Obx(
            () => controller.selectedFarmer.value != null
                ? _buildFarmerDetailsCard()
                : const SizedBox(),
          ),
        ],
      ),
    );
  }

  Widget _buildFarmerDetailsCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Selected Farmer Details',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: fPrimaryColour,
              ),
            ),
            const SizedBox(height: 12),
            _buildFarmerDetailRow(
              'Name',
              controller.selectedFarmer.value!.farmerName,
            ),
            _buildFarmerDetailRow(
              'Contact',
              controller.selectedFarmer.value!.contact,
            ),
            _buildFarmerDetailRow(
              'Farmer Code',
              controller.selectedFarmer.value!.farmercode,
            ),

            _buildFarmerDetailRow(
              'Community',
              controller.selectedFarmer.value!.communityName,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFarmerDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(width: 8),
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
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
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
      ],
    );
  }

  void _showFarmerSelectionBottomSheet(BuildContext context) {
    _showSearchableBottomSheet<FarmerFromServerModel>(
      context: context,
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
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(farmer.contact, style: TextStyle(color: Colors.grey[600])),
            Text(
              farmer.communityName,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
        trailing: controller.selectedFarmer.value?.id == farmer.id
            ? Icon(Icons.check_circle, color: fPrimaryColour)
            : null,
      ),
      onItemSelected: (farmer) {
        controller.selectFarmer(farmer);
        setState(() {});
        Navigator.pop(context);
      },
      filter: (farmer, query) {
        return farmer.farmerName.toLowerCase().contains(query.toLowerCase()) ||
            (farmer.contact).contains(query) ||
            (farmer.farmercode).toString().contains(query) ||
            (farmer.communityName).contains(query);
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
    required BuildContext context,
  }) {
    final TextEditingController searchController = TextEditingController();
    final RxList<T> filteredItems = items.obs;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
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
                  onChanged: (query) {
                    filteredItems.assignAll(
                      items.where((item) => filter(item, query)).toList(),
                    );
                  },
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
              Obx(
                () => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Text(
                        "Found ${filteredItems.length} item(s)",
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Obx(
                  () => filteredItems.isEmpty
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
  }

  Widget _buildGeneralInfoPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'General Information',
            subtitle: 'Basic details about the monitoring survey',
          ),
          const SizedBox(height: 24),
          _buildReactiveTextField(
            // readOnly: true,
            controller: controller.surveyorNameController,
            label: 'Enumerator Name',
            hintText: 'Enter your full name',
            prefixIcon: Icons.person,
            value: controller.surveyorNameController.text,
            onChanged: (value) =>
                controller.surveyorNameController.text = value,
          ),
          const SizedBox(height: 16),
          _buildDateField(),
          const SizedBox(height: 16),
          _buildCommunityField(),
          const SizedBox(height: 16),
          _buildReactiveTextField(
            controller: controller.farmerNameController,
            label: 'Farmer Name',
            hintText: 'Farmer name',
            prefixIcon: Icons.agriculture,
            value: controller.farmerNameController.text,
            onChanged: (value) => controller.farmerNameController.text = value,
            readOnly: true,
          ),
          const SizedBox(height: 16),
          _buildReactiveTextField(
            controller: controller.farmerIDNumberController,
            label: 'Farmer ID Number',
            hintText: 'Enter ID number',
            prefixIcon: Icons.badge,
            value: controller.farmerIDNumberController.text,
            onChanged: (value) =>
                controller.farmerIDNumberController.text = value,
            readOnly: true,
            maxLength: 13,
          ),
        ],
      ),
    );
  }

  Widget _buildReactiveTextField({
    Key? key,
    required String label,
    required String hintText,
    required IconData prefixIcon,
    required String value,
    required ValueChanged<String> onChanged,
    String? Function(String?)? validator,
    TextEditingController? controller,
    bool readOnly = false,
    int? maxLength,
  }) {
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          validator: validator,
          controller: controller,
          onChanged: onChanged,
          readOnly: readOnly,
          maxLength: maxLength,
          decoration: InputDecoration(
            filled: readOnly,
            fillColor: readOnly ? Colors.grey[200] : Colors.white,
            hintText: hintText,
            prefixIcon: Icon(prefixIcon),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Date of Survey',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            DatePicker.showDatePicker(
              Get.context!,
              showTitleActions: true,
              minTime: DateTime(2000, 1, 1),
              maxTime: DateTime.now(),
              onConfirm: (date) {
                controller.dateOfSurvey.value =
                    '${date.year}-${date.month}-${date.day}';
              },
              theme: const DatePickerTheme(
                backgroundColor: Colors.white,
                itemStyle: TextStyle(color: Colors.black87),
                doneStyle: TextStyle(color: fPrimaryColour, fontSize: 16),
                cancelStyle: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, size: 20, color: Colors.grey),
                const SizedBox(width: 12),
                Obx(
                  () => Text(
                    controller.dateOfSurvey.isEmpty
                        ? 'Select survey date'
                        : controller.dateOfSurvey.value,
                    style: TextStyle(
                      color: controller.dateOfSurvey.isEmpty
                          ? Colors.grey
                          : Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCommunityField() {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!controller.communityNotFound.value) ...[
            const Text(
              'Community',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonHideUnderline(
              child: Obx(
                () => DropdownButtonFormField<CommunityModel>(
                  value: controller.selectedCommunity.value,
                  isExpanded: true,
                  hint: const Text('Select community'),
                  items: controller.communities.map((community) {
                    return DropdownMenuItem<CommunityModel>(
                      value: community,
                      child: Text(community.community ?? ''),
                    );
                  }).toList(),
                  onChanged: (community) {
                    if (community != null) {
                      controller.selectCommunity(community);
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Checkbox(
                  value: controller.communityNotFound.value,
                  onChanged: (value) {
                    controller.communityNotFound.value = value ?? false;
                  },
                ),
                const Text('Community not found in list'),
              ],
            ),
          ] else ...[
            _buildReactiveTextField(
              label: 'Community Name',
              hintText: 'Enter community name',
              prefixIcon: Icons.location_city,
              value: controller.customCommunityName.value,
              onChanged: (value) =>
                  controller.customCommunityName.value = value,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Checkbox(
                  value: controller.communityNotFound.value,
                  onChanged: (value) {
                    controller.communityNotFound.value = value ?? false;
                  },
                ),
                const Text('Community not found in list'),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPlantationDetailsPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Plantation Details',
            subtitle: 'Information about the plantation area and species',
          ),
          const SizedBox(height: 24),
          _buildPlantationTypeField(),
          const SizedBox(height: 24),
          const Text(
            'Species Provided and Planted',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          _buildSpeciesCheckboxes(),
        ],
      ),
    );
  }

  Widget _buildPlantationTypeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Type of Plantation',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: DropdownButtonHideUnderline(
            child: Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownButton<String>(
                    value: controller.plantationType.value.isEmpty
                        ? null
                        : controller.plantationType.value,
                    isExpanded: true,
                    hint: const Text('Select plantation type'),
                    items: controller.plantationTypes.map((type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (value) {
                      controller.plantationType.value = value ?? '';
                      // Clear other plantation type when changing selection
                      if (value != 'Other') {
                        controller.otherPlantationType.value = '';
                      }
                    },
                  ),
                  if (controller.plantationType.value == 'Other')
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: TextField(
                        controller:
                            TextEditingController(
                                text: controller.otherPlantationType.value,
                              )
                              ..selection = TextSelection.collapsed(
                                offset:
                                    controller.otherPlantationType.value.length,
                              ),
                        decoration: const InputDecoration(
                          hintText: 'Please specify plantation type',
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                        onChanged: (value) {
                          controller.otherPlantationType.value = value;
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSpeciesCheckboxes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextFormField(
            controller: controller.searchController,
            decoration: InputDecoration(
              hintText: 'Search species...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 16,
              ),
            ),
            onChanged: (value) {
              controller.filterSpecies(value);
            },
          ),
        ),
        const SizedBox(height: 8),
        Obx(() {
          return Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ...controller.filteredSpeciesList.map((species) {
                final isSelected = controller.speciesProvidedPlanted.contains(
                  species,
                );
                final isOther = species == 'Other';
                final otherIsSelected = isOther && controller.isOtherSelected();

                return FilterChip(
                  key: ValueKey('$species-${controller.isOtherSelected()}'),
                  selected: isSelected || otherIsSelected,
                  label: Text(species.replaceAll('_', ' ')),
                  onSelected: (selected) {
                    controller.toggleSpeciesSelection(species, selected);
                    if (isOther && selected) {
                      // Focus on the text field when 'Other' is selected
                      FocusScope.of(context).requestFocus(FocusNode());
                    } else if (!isOther) {
                      controller.toggleSpeciesAlive(species, selected);
                    }
                  },
                  selectedColor: fPrimaryColour.withOpacity(0.2),
                  checkmarkColor: fPrimaryColour,
                  labelStyle: TextStyle(
                    color: (isSelected || otherIsSelected)
                        ? fPrimaryColour
                        : Colors.black87,
                  ),
                );
              }),

              // Show text field if 'Other' is selected or has text
              // if (controller.isOtherSelected())
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 4.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Specify other species if not provided"),
                        SizedBox(height: 5,),
                        TextField(
                          controller: controller.otherSpeciesController,
                          decoration: InputDecoration(
                            hintText: 'Specify other species',
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                            border: const OutlineInputBorder(),
                            isDense: true,
                            suffixIcon:
                                controller
                                    .otherSpeciesController
                                    .text
                                    .isNotEmpty
                                ? IconButton(
                                    icon: const Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                    ),
                                    onPressed: () {
                                      // Add the custom species when checkmark is pressed
                                      if (controller.otherSpeciesController.text
                                          .trim()
                                          .isNotEmpty) {
                                        controller.addCustomSpecies(
                                          controller.otherSpeciesController.text
                                              .trim(),
                                        );
                                      }
                                    },
                                  )
                                : null,
                          ),
                          onSubmitted: (value) {
                            if (value.trim().isNotEmpty) {
                              controller.addCustomSpecies(value.trim());
                            }
                          },
                          onChanged: (value) {
                            // Update the 'Other' chip selection based on whether there's text
                            if (value.trim().isEmpty) {
                              controller.toggleSpeciesSelection('Other', false);
                            } else if (!controller.speciesProvidedPlanted
                                .contains('Other')) {
                              controller.toggleSpeciesSelection('Other', true);
                            }
                          },
                        ),

                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () {
                            controller.filteredSpeciesList.add(
                              controller.otherSpeciesController.text.trim(),
                            );
                            controller.toggleSpeciesSelection(
                              controller.otherSpeciesController.text.trim(),
                              true,
                            );
                            controller.speciesList.add(
                              controller.otherSpeciesController.text.trim(),
                            );
                            setState(() {
                              controller.otherSpeciesController.clear();
                            });
                          },
                          child: Text('Add to species'),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildSpeciesDetailsPage() {
    controller.speciesProvidedPlanted.remove('Other');
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Species Planting Details',
            subtitle: 'Detailed information about each planted species',
          ),
          const SizedBox(height: 24),
          Obx(
            () => Column(
              children: controller.speciesProvidedPlanted.map((species) {
                return SpeciesExpansionTile(
                  species: species,
                  quantityReceivedController:
                      controller.quantityReceivedControllers[species]!,
                  quantityPlantedController:
                      controller.quantityPlantedControllers[species]!,
                  // onQuantityReceivedChanged: (value) => controller.setQuantityReceived(species, value),
                  // onQuantityPlantedChanged: (value) => controller.setQuantityPlanted(species, value),
                  onDateSelected: (date) {
                    controller.setPlantingDate(species, date);
                  },
                  plantingDate: controller.plantingDates[species],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMappedAreaPage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Farm Mapping',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),
          CustomButton(
            horizontalPadding: 10,
            verticalPadding: 10,
            backgroundColor: fPrimaryColour,
            onTap: () {
              controller.usePolygonDrawingTool();
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Icon(Icons.map), SizedBox(width: 5), Text('Map Farm')],
            ),
          ),
          const SizedBox(height: 20),
          _buildReactiveTextField(
            onChanged: (value) {
              controller.setTotalSizeAcres(value);
            },
            value: controller.farmSizeController.text,
            controller: controller.farmSizeController,
            label: 'Total Size (Acres) - computed after mapping',
            hintText: 'Map farm to compute farm size',
            prefixIcon: Icons.square_foot,
            readOnly: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSeedlingSurvivalPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // const SectionHeader(
          //   title: 'Seedling Survival',
          //   subtitle:
          //       'Monitor the survival status of seedlings and identify causes of mortality',
          // ),
          // const SizedBox(height: 24),
          _buildSeedlingMappingButton(),
          const SizedBox(height: 24),
          _buildReasonsForDeathSection(),
        ],
      ),
    );
  }
  //
  // Widget _buildSpeciesAliveSection() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       const Text(
  //         'Species of Seedlings Alive',
  //         style: TextStyle(
  //           fontWeight: FontWeight.w600,
  //           fontSize: 16,
  //           color: Colors.black87,
  //         ),
  //       ),
  //       const SizedBox(height: 8),
  //       const Text(
  //         'Select all species that are currently alive',
  //         style: TextStyle(fontSize: 14, color: Colors.grey),
  //       ),
  //       const SizedBox(height: 16),
  //       Obx(
  //         () => Wrap(
  //           spacing: 8,
  //           runSpacing: 8,
  //           children: controller.speciesList.map((species) {
  //             final isSelected = controller.speciesAlive.contains(species);
  //             return FilterChip(
  //               selected: isSelected,
  //               label: Text(
  //                 species.replaceAll('_', ' '),
  //                 style: TextStyle(
  //                   color: isSelected ? Colors.white : Colors.black87,
  //                 ),
  //               ),
  //               onSelected: (selected) {
  //                 controller.toggleSpeciesAlive(species, selected);
  //               },
  //               selectedColor: fPrimaryColour,
  //               checkmarkColor: Colors.white,
  //               backgroundColor: Colors.grey[100],
  //               showCheckmark: true,
  //             );
  //           }).toList(),
  //         ),
  //       ),
  //       Obx(
  //         () => controller.speciesAlive.isEmpty
  //             ? const Padding(
  //                 padding: EdgeInsets.only(top: 8.0),
  //                 child: Text(
  //                   'Please select at least one species',
  //                   style: TextStyle(color: Colors.red, fontSize: 12),
  //                 ),
  //               )
  //             : const SizedBox(),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildReasonsForDeathSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Suspected Reason for Death',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Select all applicable reasons for seedling mortality',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 16),
        Obx(
          () => Wrap(
            spacing: 8,
            runSpacing: 8,
            children: controller.deathReasons.map((reason) {
              final isSelected = controller.reasonForDeath.contains(reason);
              return FilterChip(
                selected: isSelected,
                label: Text(
                  reason.replaceAll('_', ' '),
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                  ),
                ),
                onSelected: (selected) {
                  controller.toggleReasonForDeath(reason, selected);
                },
                selectedColor: Colors.red[400],
                checkmarkColor: Colors.white,
                backgroundColor: Colors.grey[100],
                showCheckmark: true,
              );
            }).toList(),
          ),
        ),
        Obx(
          () => controller.reasonForDeath.isEmpty
              ? const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Please select at least one reason',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                )
              : const SizedBox(),
        ),
      ],
    );
  }

  Widget _buildSeedlingMappingButton() {
    return Column(
      children: [
        CustomButton(
          horizontalPadding: 10,
          isFullWidth: true,
          backgroundColor: controller.treeData.isEmpty
              ? fSecondaryColour
              : fPrimaryColour,
          verticalPadding: 16.0,
          onTap: () {
            // if (_validateSeedlingSurvivalPage()) {
            _navigateToSeedlingMapping();
            // }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                controller.treeData.isEmpty ? Icons.map : Icons.check,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Map Surviving Seedlings',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Map the locations of surviving seedlings for detailed monitoring',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontStyle: FontStyle.italic,
          ),
          textAlign: TextAlign.center,
        ),
        Obx(
          () => controller.treeData.isEmpty
              ? const Text(
                  'Tree data is empty',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.red,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                )
              : const SizedBox(),
        ),
      ],
    );
  }

  // bool _validateSeedlingSurvivalPage() {
  //   if (controller.speciesAlive.isEmpty) {
  //     Get.snackbar(
  //       'Validation Error',
  //       'Please select at least one species that is alive',
  //       backgroundColor: Colors.red,
  //       colorText: Colors.white,
  //     );
  //     return false;
  //   }
  //
  //   if (controller.reasonForDeath.isEmpty) {
  //     Get.snackbar(
  //       'Validation Error',
  //       'Please select at least one reason for death',
  //       backgroundColor: Colors.red,
  //       colorText: Colors.white,
  //     );
  //     return false;
  //   }
  //
  //   return true;
  // }

  void _navigateToSeedlingMapping() {
    final mappedFarm = {"bounds": controller.polygon!.points};
    controller.speciesList.remove("Other");

    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (BuildContext context) => PickTreesMap(
          survivedSeedlings: controller.speciesList,
          farm: mappedFarm,
        ),
      ),
    );
  }

  Widget _buildEnvironmentalConditionsPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Environmental Conditions',
            subtitle:
                'Monitor water sources, irrigation frequency, and extreme weather events',
          ),
          const SizedBox(height: 24),
          _buildWaterSourceSection(),
          const SizedBox(height: 24),

          Obx(
            () => controller.sourceOfWater.contains("Rain_Fed")
                ? const SizedBox.shrink()
                : _buildWateringFrequencySection(),
          ),
          const SizedBox(height: 24),
          _buildExtremeWeatherSection(),
          const SizedBox(height: 24),
          Obx(
            () => controller.extremeWeathers.contains("Other")
                ? _buildOtherSpecificationField()
                : const SizedBox(),
          ),
        ],
      ),
    );
  }

  Widget _buildWaterSourceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Source of Water',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Select all water sources used for irrigation',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 16),
        Obx(
          () => Wrap(
            spacing: 8,
            runSpacing: 8,
            children: controller.waterSources.map((source) {
              final isSelected = controller.sourceOfWater.contains(source);
              return FilterChip(
                selected: isSelected,
                label: Text(
                  source.replaceAll('_', ' '),
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                  ),
                ),
                onSelected: (selected) {
                  debugPrint("THE SELECTED SOURCE IS $source");
                  controller.toggleWaterSource(source, selected);
                },
                selectedColor: fPrimaryColour,
                checkmarkColor: Colors.white,
                backgroundColor: Colors.grey[100],
                showCheckmark: true,
              );
            }).toList(),
          ),
        ),
        Obx(
          () => controller.sourceOfWater.isEmpty
              ? const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Please select at least one water source',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                )
              : const SizedBox(),
        ),
      ],
    );
  }

  Widget _buildWateringFrequencySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Average Watering Frequency',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'How often are the seedlings watered?',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 16),
        Obx(
          () => Column(
            children: controller.frequencyOptions.map((option) {
              return RadioListTile<String>(
                title: Text(option["label"]!),
                value: option["value"]!,
                groupValue: controller.waterFrequency.value,
                onChanged: (value) {
                  controller.setWaterFrequency(value!);
                },
                activeColor: fPrimaryColour,
                contentPadding: EdgeInsets.zero,
              );
            }).toList(),
          ),
        ),
        // Obx(
        //   () => controller.waterFrequency.isEmpty
        //       ? const Padding(
        //           padding: EdgeInsets.only(top: 8.0),
        //           child: Text(
        //             'Please select watering frequency',
        //             style: TextStyle(color: Colors.red, fontSize: 12),
        //           ),
        //         )
        //       : const SizedBox(),
        // ),
      ],
    );
  }

  Widget _buildExtremeWeatherSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Extreme Weather Events',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Have there been any extreme weather events since the seedlings were planted?',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 16),
        Obx(
          () => Row(
            children: [
              Expanded(
                child: RadioListTile<String>(
                  title: const Text('Yes'),
                  value: "Yes",
                  groupValue: controller.hasExtremeWeather!.value,
                  onChanged: (value) {
                    controller.setHasExtremeWeather(value!);
                  },
                  activeColor: fPrimaryColour,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              Expanded(
                child: RadioListTile<String>(
                  title: const Text('No'),
                  value: "No",
                  groupValue: controller.hasExtremeWeather!.value,
                  onChanged: (value) {
                    controller.setHasExtremeWeather(value!);
                  },
                  activeColor: fPrimaryColour,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ),
        Obx(
          () => controller.hasExtremeWeather!.value == "Yes"
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    const Text(
                      'What type of extreme weather events occurred?',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: controller.weatherEvents.map((weather) {
                        final isSelected = controller.extremeWeathers.contains(
                          weather,
                        );
                        return FilterChip(
                          selected: isSelected,
                          label: Text(
                            weather,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                            ),
                          ),
                          onSelected: (selected) {
                            controller.toggleExtremeWeather(weather, selected);
                          },
                          selectedColor: Colors.orange[400],
                          checkmarkColor: Colors.white,
                          backgroundColor: Colors.grey[100],
                          showCheckmark: true,
                        );
                      }).toList(),
                    ),
                    Obx(
                      () =>
                          controller.hasExtremeWeather!.value == "Yes" &&
                              controller.extremeWeathers.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: Text(
                                'Please select at least one weather event',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                            )
                          : const SizedBox(),
                    ),
                  ],
                )
              : const SizedBox(),
        ),
      ],
    );
  }

  Widget _buildOtherSpecificationField() {
    return _buildReactiveTextField(
      label: 'Specify Other Extreme Weather',
      hintText: 'Please describe the extreme weather event',
      prefixIcon: Icons.warning,
      value: controller.otherExtremeWeather.value,
      onChanged: (value) => controller.otherExtremeWeather.value = value,
    );
  }

  Widget _buildFinalObservationsPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Final Observations',
            subtitle:
                'Record pest and disease observations, maintenance activities, and additional comments',
          ),
          const SizedBox(height: 24),

          _buildPestAndDiseaseSection(),
          const SizedBox(height: 24),
          _buildMaintenanceSection(),
          const SizedBox(height: 24),
          _buildAdditionalObservationsSection(),
          const SizedBox(height: 24),
          _buildSubmitButton(),
        ],
      ),
    );
  }

  Widget _buildPestAndDiseaseSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pest and Disease Observation',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        const Text('Have you noticed any pests on or around the seedlings?'),
        Obx(
          () => Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Yes'),
                      value: "Yes",
                      groupValue: controller.pestsAround!.value,
                      onChanged: (value) {
                        controller.setPestsAround(value!);
                      },
                      activeColor: fPrimaryColour,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('No'),
                      value: "No",
                      groupValue: controller.pestsAround!.value,
                      onChanged: (value) {
                        controller.setPestsAround(value!);
                      },
                      activeColor: fPrimaryColour,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),

              if (controller.pestsAround!.value == "Yes")
                _buildReactiveTextField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'required';
                    }
                    return null;
                  },
                  label: "Specify pest description",
                  hintText: "Describe the pests observed...",
                  prefixIcon: Icons.description,
                  value: controller.pestDescription.value,
                  onChanged: (value) =>
                      controller.pestDescription.value = value,
                ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text('Have you noticed any signs of disease on the seedlings?'),
        Obx(
          () => Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Yes'),
                      value: "Yes",
                      groupValue: controller.signsOfDisease!.value,
                      onChanged: (value) {
                        controller.setSignsOfDisease(value!);
                      },
                      activeColor: fPrimaryColour,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('No'),
                      value: "No",
                      groupValue: controller.signsOfDisease!.value,
                      onChanged: (value) {
                        controller.setSignsOfDisease(value!);
                      },
                      activeColor: fPrimaryColour,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),

              if (controller.signsOfDisease!.value == "Yes")
                _buildReactiveTextField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'required';
                    }
                    return null;
                  },
                  label: "Specify disease signs",
                  hintText: "Describe the disease symptoms observed...",
                  prefixIcon: Icons.description,
                  value: controller.diseaseDescription.value,
                  onChanged: (value) =>
                      controller.diseaseDescription.value = value,
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMaintenanceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Maintenance and Care',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        const Text('Were any fertilizers or any soil amendments applied?'),
        Obx(
          () => Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Yes'),
                      value: "Yes",
                      groupValue: controller.fertiliserApplied!.value,
                      onChanged: (value) {
                        controller.setFertiliserApplied(value!);
                      },
                      activeColor: fPrimaryColour,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('No'),
                      value: "No",
                      groupValue: controller.fertiliserApplied!.value,
                      onChanged: (value) {
                        controller.setFertiliserApplied(value!);
                      },
                      activeColor: fPrimaryColour,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),

              if (controller.fertiliserApplied!.value == "Yes")
                _buildReactiveTextField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'required';
                    }
                    return null;
                  },
                  label: "Specify fertilizer type",
                  hintText: "Describe the fertilizer or soil amendment used...",
                  prefixIcon: Icons.description,
                  value: controller.fertiliserType.value,
                  onChanged: (value) => controller.fertiliserType.value = value,
                ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text('Were any pesticide or herbicide applied?'),
        Obx(
          () => Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Yes'),
                      value: "Yes",
                      groupValue: controller.pesticideApplied!.value,
                      onChanged: (value) {
                        controller.setPesticideApplied(value!);
                      },
                      activeColor: fPrimaryColour,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('No'),
                      value: "No",
                      groupValue: controller.pesticideApplied!.value,
                      onChanged: (value) {
                        controller.setPesticideApplied(value!);
                      },
                      activeColor: fPrimaryColour,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),

              if (controller.pesticideApplied!.value == "Yes")
                _buildReactiveTextField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'required';
                    }
                    return null;
                  },
                  label: "Specify pesticide/herbicide type",
                  hintText: "Describe the pesticide or herbicide used...",
                  prefixIcon: Icons.description,
                  value: controller.pesticideType.value,
                  onChanged: (value) => controller.pesticideType.value = value,
                ),
            ],
          ),
        ),
      ],
    );
  }

  // Widget _buildReactiveYesNoQuestion({
  //   required String title,
  //   required bool value,
  //   required ValueChanged<bool> onChanged,
  //   required String descriptionValue,
  //   required ValueChanged<String> onDescriptionChanged,
  //   required String descriptionLabel,
  //   required String descriptionHint,
  // }) {
  //   // Use a local state to track the radio button value
  //   return StatefulBuilder(
  //     builder: (BuildContext context, StateSetter setState) {
  //       return Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text(
  //             title,
  //             style: const TextStyle(
  //               fontWeight: FontWeight.w500,
  //               fontSize: 16,
  //               color: Colors.black87,
  //             ),
  //           ),
  //           const SizedBox(height: 12),
  //
  //
  //
  //           const SizedBox(height: 12),
  //           if (value)
  //             AnimatedSwitcher(
  //               duration: const Duration(milliseconds: 200),
  //               child: _buildReactiveTextField(
  //                 key: ValueKey<bool>(value),
  //                 label: descriptionLabel,
  //                 hintText: descriptionHint,
  //                 prefixIcon: Icons.description,
  //                 value: descriptionValue,
  //                 onChanged: onDescriptionChanged,
  //               ),
  //             ),
  //         ],
  //       );
  //     },
  //   );
  // }

  Widget _buildAdditionalObservationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Additional Observations and Comments',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Please provide any other observations, comments or recommendations for improving the survival rate of the seedlings',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 16),
        _buildReactiveTextField(
          label: 'Additional Observations',
          hintText:
              'Enter any additional observations, comments, or recommendations...',
          prefixIcon: Icons.comment,
          value: controller.additionalObservations.value,
          onChanged: (value) => controller.additionalObservations.value = value,
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Row(
      children: [
        Expanded(
          child: CustomButton(
            horizontalPadding: 10,
            isFullWidth: true,
            borderColor: fPrimaryColour,
            backgroundColor: AppColor.white,
            verticalPadding: 16.0,
            onTap: () {
              controller.saveDataOffline();
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon(Icons.cloud_upload, color: Colors.white, size: 20),
                // SizedBox(width: 8),
                Text(
                  'Save',
                  style: TextStyle(
                    color: fPrimaryColour,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: CustomButton(
            horizontalPadding: 10,
            isFullWidth: true,
            backgroundColor: fPrimaryColour,
            verticalPadding: 16.0,
            onTap: () {
              controller.submitDataOnline();
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon(Icons.cloud_upload, color: Colors.white, size: 20),
                // SizedBox(width: 8),
                Text(
                  'Submit',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Obx(
              () => ElevatedButton(
                onPressed: controller.currentPage.value == 0
                    ? null
                    : () => _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: controller.currentPage.value == 0
                      ? Colors.grey[300]
                      : Colors.white,
                  foregroundColor: controller.currentPage.value == 0
                      ? Colors.grey[500]
                      : fPrimaryColour,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: controller.currentPage.value == 0
                          ? Colors.grey[300]!
                          : fPrimaryColour,
                    ),
                  ),
                  elevation: 0,
                ),
                child: const Text('Back'),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Obx(() {
            bool isNextEnabled = controller.currentPage.value == 0
                ? controller.selectedFarmer.value != null
                : true;

            return controller.currentPage.value < 7
                ? Expanded(
                    child: ElevatedButton(
                      onPressed: isNextEnabled
                          ? () => controller.nextPage()
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isNextEnabled
                            ? fPrimaryColour
                            : Colors.grey[300],
                        foregroundColor: isNextEnabled
                            ? Colors.white
                            : Colors.grey[500],
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Next',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}
