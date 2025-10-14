// modern_seedling_monitoring_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:get/get.dart';
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/screens/addedMaps/dependencies/custom_button.dart';
import 'package:hcms_revived2/screens/addedMaps/farm_cord_drawing_map.dart';
import 'package:hcms_revived2/utils/constants/colours.dart';
import 'package:hcms_revived2/utils/widgets/appBars/section_header.dart'
    show SectionHeader;
import 'package:hcms_revived2/utils/widgets/expasion/specie_expansion_tile.dart';
import 'package:hcms_revived2/utils/widgets/textFields/custom_textfield.dart';

import 'seedling_monitoring_provider.dart';

class SeedlingMonitoringScreen extends StatefulWidget {
  const SeedlingMonitoringScreen({super.key});

  @override
  State<SeedlingMonitoringScreen> createState() =>
      _SeedlingMonitoringScreenState();
}

class _SeedlingMonitoringScreenState extends State<SeedlingMonitoringScreen> {
  final SeedlingMonitoringProviderr controller = Get.put(
    SeedlingMonitoringProviderr(),
  );
  late final PageController _pageController;

  // @override
  // void initState() {
  //   super.initState();
  //   _pageController = PageController(initialPage: 0);
  //
  //   // Listen to currentPage changes and update PageView
  //   ever(controller.currentPage, (int page) {
  //     if (_pageController.hasClients) {
  //       _pageController.animateToPage(
  //         page,
  //         duration: const Duration(milliseconds: 300),
  //         curve: Curves.easeInOut,
  //       );
  //     }
  //   });
  // }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    controller.loadCommunities();
    controller.initializeControllers();
    _pageController = PageController(initialPage: 0);

    // Listen to currentPage changes and update PageView
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
  Widget build(BuildContext context) {
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
      backgroundColor: Colors.white,
      elevation: 1,
      centerTitle: true,
      iconTheme: const IconThemeData(color: fPrimaryColour),
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
            subtitle:
                'Enter the registered farmer\'s contact number to begin monitoring',
          ),
          const SizedBox(height: 32),
          CustomFormField(
            controller: controller.farmerContact,
            label: 'Farmer Contact Number',
            hintText: 'Enter 10-digit phone number',
            keyboardType: TextInputType.phone,
            maxLength: 10,
            prefixIcon: Icons.phone,
            validator: (value) {
              if (value?.isEmpty ?? true) return 'Please enter contact number';
              if (value!.length != 10)
                return 'Please enter valid 10-digit number';
              return null;
            },
          ),
          const SizedBox(height: 24),
          Obx(
            () => controller.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : _buildSearchButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: controller.searchFarmer,
        style: ElevatedButton.styleFrom(
          backgroundColor: fPrimaryColour,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Search Farmer',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
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
          CustomFormField(
            controller: controller.surveyorName,
            label: 'Surveyor Name',
            hintText: 'Enter your full name',
            prefixIcon: Icons.person,
          ),
          const SizedBox(height: 16),
          _buildDateField(),
          const SizedBox(height: 16),
          _buildCommunityField(),
          const SizedBox(height: 16),
          CustomFormField(
            controller: controller.farmerNameController,
            label: 'Farmer Name',
            hintText: 'Farmer name',
            prefixIcon: Icons.agriculture,
            readOnly: true,
          ),
          const SizedBox(height: 16),
          CustomFormField(
            readOnly: true,
            controller: controller.farmerIDNumber,
            label: 'Farmer ID Number',
            hintText: 'Enter ID number',
            prefixIcon: Icons.badge,
            maxLength: 13,
          ),
        ],
      ),
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: controller.community.value.isEmpty
                      ? null
                      : controller.community.value,
                  isExpanded: true,
                  hint: const Text('Select community'),
                  items: controller.communities.map((community) {
                    return DropdownMenuItem<String>(
                      value: community.comcode?.toString() ?? '',
                      child: Text(community.name ?? ''),
                    );
                  }).toList(),
                  onChanged: (value) {
                    controller.community.value = value ?? '';
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
            CustomFormField(
              controller: controller.communityName,
              label: 'Community Name',
              hintText: 'Enter community name',
              prefixIcon: Icons.location_city,
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
    const plantationTypes = [
      "Cocoa Farm",
      "Woodlot",
      "Degraded Area",
      "Riparian",
      "Others",
    ];

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
              () => DropdownButton<String>(
                value: controller.plantationType.value.isEmpty
                    ? null
                    : controller.plantationType.value,
                isExpanded: true,
                hint: const Text('Select plantation type'),
                items: plantationTypes.map((type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  controller.plantationType.value = value ?? '';
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSpeciesCheckboxes() {
    final speciesList = [
      "Prekese",
      "Kokrodua_Afromosia",
      "Dahoma",
      "Edinam",
      "Emire",
      "Ofram",
      "Mahogany_Dubini",
      "Mansonia_Oprono",
      "Okoro",
      "Efoobodedwo_Utile",
      "Bako",
    ];

    return Obx(
      () => Wrap(
        spacing: 8,
        runSpacing: 8,
        children: speciesList.map((species) {
          final isSelected = controller.speciesProvidedPlanted.contains(
            species,
          );
          return FilterChip(
            selected: isSelected,
            label: Text(species.replaceAll('_', ' ')),
            onSelected: (selected) {
              controller.toggleSpeciesSelection(species, selected);
            },
            selectedColor: fPrimaryColour.withOpacity(0.2),
            checkmarkColor: fPrimaryColour,
            labelStyle: TextStyle(
              color: isSelected ? fPrimaryColour : Colors.black87,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSpeciesDetailsPage() {
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
          // Back button
          Expanded(
            child: Obx(
              () => ElevatedButton(
                onPressed: controller.currentPage.value == 0
                    ? null
                    : () => _pageController.previousPage(
                        duration: const Duration(milliseconds: 1),
                        curve: Curves.easeInOut,
                      ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: fPrimaryColour,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: fPrimaryColour),
                  ),
                  elevation: 0,
                ),
                child: const Text('Back'),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Next/Submit button
          Expanded(
            child: Obx(
              () => ElevatedButton(
                onPressed: () => controller.nextPage(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: fPrimaryColour,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  controller.currentPage.value == 7 ? 'Submit' : 'Next',
                  style: const TextStyle(
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
  }

  // Placeholder methods for remaining pages
  Widget _buildMappedAreaPage() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10.0),

    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Farm Mapping',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),

        CustomButton(
          horizontalPadding: 10,
          verticalPadding: 10,
          backgroundColor: fPrimaryColour,
          onTap: () {
            MapFarmController().usePolygonDrawingTool();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Icon(Icons.map), SizedBox(width: 5), Text('Map Farm')],
          ),
        ),

        SizedBox(height: 20),
        CustomFormField(
          readOnly: true,
          controller: controller.totalSizeAcres,
          label: 'Total Size (Acres) - computed after mapping',
          hintText: 'Enter plantation size',
          keyboardType: TextInputType.number,
          prefixIcon: Icons.square_foot,
        ),
      ],
    ),
  );
  Widget _buildSeedlingSurvivalPage() =>
      _buildPlaceholderPage('Seedling Survival');
  Widget _buildEnvironmentalConditionsPage() =>
      _buildPlaceholderPage('Environmental Conditions');
  Widget _buildFinalObservationsPage() =>
      _buildPlaceholderPage('Final Observations');

  Widget _buildPlaceholderPage(String title) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.construction, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            '$title Page',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text('Under development', style: TextStyle(color: Colors.grey[500])),
        ],
      ),
    );
  }
}
