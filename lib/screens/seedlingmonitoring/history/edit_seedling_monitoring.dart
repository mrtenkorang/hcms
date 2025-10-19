// modern_seedling_monitoring_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:get/get.dart';
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/models/localdbmodel/seedling_monitoring_model.dart'
    show SeedlingMonitoringModel;
import 'package:hcms_revived2/screens/addedMaps/dependencies/custom_button.dart';
import 'package:hcms_revived2/screens/addedMaps/dependencies/style.dart';
import 'package:hcms_revived2/screens/addedMaps/dependencies/tree_picking_tool/pick_tree_map.dart';
import 'package:hcms_revived2/screens/addedMaps/dependencies/user_current_location.dart'
    show UserCurrentLocation;
import 'package:hcms_revived2/screens/addedMaps/farm_cord_drawing_map.dart';
import 'package:hcms_revived2/utils/constants/colours.dart';
import 'package:hcms_revived2/utils/widgets/appBars/section_header.dart'
    show SectionHeader;
import 'package:hcms_revived2/utils/widgets/expasion/specie_expansion_tile.dart';
import 'package:hcms_revived2/utils/widgets/textFields/custom_textfield.dart';

import 'edit_seedling_monitoring_controller.dart';

class EditSeedlingMonitoringScreen extends StatefulWidget {
  const EditSeedlingMonitoringScreen({super.key, this.seedlingMonitoring});

  final SeedlingMonitoringModel? seedlingMonitoring;

  @override
  State<EditSeedlingMonitoringScreen> createState() =>
      _EditSeedlingMonitoringScreenState();
}

class _EditSeedlingMonitoringScreenState
    extends State<EditSeedlingMonitoringScreen> {
  final EditSeedlingMonitoringController controller = Get.put(
    EditSeedlingMonitoringController(),
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
    
    // Initialize page controller first
    _pageController = PageController(initialPage: 0);
    
    // Set the monitoring model
    controller.seedlingMonitoringModel = widget.seedlingMonitoring;
    
    // Initialize controllers and load data after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Initialize data after the widget is built
      controller.initializeData();
      
      // Load communities
      controller.loadCommunities();
      
      // Initialize controllers
      controller.initializeControllers();
      
      // Request location
      final userCurrentLocation = UserCurrentLocation(context: context);
      userCurrentLocation.getUserLocation(
        forceEnableLocation: true,
        onLocationEnabled: (isEnabled, pos) {
          if (isEnabled==true) {
            debugPrint("Location enabled: $pos");
          }
        },
      );
    });

    // Set up page change listener
    // ever(controller.currentPage);
  }

  @override
  Widget build(BuildContext context) {
    controller.seedlingMonitoringScreenContext = context;
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
                // _buildFarmerSearchPage(),
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
        'Edit Seedling Monitoring',
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
      ),
      backgroundColor: fPrimaryColour,
      elevation: 1,
      centerTitle: true,
      // iconTheme: const IconThemeData(color: fPrimaryColour),
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
              if (value!.length != 10) {
                return 'Please enter valid 10-digit number';
              }
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
                    : () {
                        final prevPage = controller.currentPage.value - 1;
                        controller.currentPage.value = prevPage;
                        _pageController.animateToPage(
                          prevPage,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
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
          Obx(
            () => controller.currentPage.value < 7
                ? Expanded(
                    child: ElevatedButton(
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
                      child: const Text(
                        'Next',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
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
          backgroundColor: fSecondaryColour,

          onTap: () {
            Map<String, dynamic> farm = {"bounds": controller.polygon!.points};

            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (BuildContext context) => PickTreesMap(
                  farm: farm,
                  survivedSeedlings: controller.speciesAlive,
                  isViewMode: true,
                ),
              ),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.remove_red_eye, color: Colors.black),
              SizedBox(width: 5),
              Text(
                'View Mapped Farm',
                style: TextStyle(
                  color: controller.totalSizeAcres.text.isNotEmpty
                      ? Colors.black
                      : Colors.white,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        CustomButton(
          horizontalPadding: 10,
          verticalPadding: 10,
          backgroundColor: fPrimaryColour,

          onTap: () {
            controller.usePolygonDrawingTool();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.map),
              SizedBox(width: 5),
              Text(
                'Map Farm',
                style: TextStyle(
                  color: controller.totalSizeAcres.text.isNotEmpty
                      ? Colors.black
                      : Colors.white,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 20),
        CustomFormField(
          readOnly: true,
          controller: controller.totalSizeAcres,
          label: 'Total Size (ha) - computed after mapping',
          hintText: 'Map farm to compute farm size',
          keyboardType: TextInputType.number,
          prefixIcon: Icons.square_foot,
        ),
      ],
    ),
  );
  Widget _buildSeedlingSurvivalPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Seedling Survival',
            subtitle:
                'Monitor the survival status of seedlings and identify causes of mortality',
          ),
          const SizedBox(height: 24),

          // Total Seedlings Alive
          CustomFormField(
            controller: controller.totalSeedlingsAlive,
            label: 'Total Number of Seedlings Alive',
            hintText: 'Enter total number of seedlings alive at time of survey',
            keyboardType: TextInputType.number,
            prefixIcon: Icons.eco,
            isRequired: true,
            validator: (value) {
              if (value?.isEmpty ?? true) return 'Please enter total number';
              if (int.tryParse(value!) == null) {
                return 'Please enter a valid number';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),

          // Species Alive Section
          _buildSpeciesAliveSection(),
          const SizedBox(height: 24),

          // Reasons for Death Section
          _buildReasonsForDeathSection(),
          const SizedBox(height: 24),

          // Seedling Mapping Button
          _buildSeedlingMappingButton(),
        ],
      ),
    );
  }

  Widget _buildSpeciesAliveSection() {
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Species of Seedlings Alive',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Select all species that are currently alive',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 16),
        Obx(
          () => Wrap(
            spacing: 8,
            runSpacing: 8,
            children: speciesList.map((species) {
              final isSelected = controller.speciesAlive.contains(species);
              return FilterChip(
                selected: isSelected,
                label: Text(
                  species.replaceAll('_', ' '),
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                  ),
                ),
                onSelected: (selected) {
                  controller.toggleSpeciesAlive(species, selected);
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
          () => controller.speciesAlive.isEmpty
              ? const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Please select at least one species',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                )
              : const SizedBox(),
        ),
      ],
    );
  }

  Widget _buildReasonsForDeathSection() {
    final reasonsList = [
      "Disease",
      "Drought",
      "Pest",
      "Vandalism",
      "Transportation_Shocks",
    ];

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
            children: reasonsList.map((reason) {
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
          backgroundColor: fSecondaryColour,
          verticalPadding: 16.0,
          onTap: () {
            if (_validateSeedlingSurvivalPage()) {
              _navigateToSeedlingMappingView();
            }
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.remove_red_eye, color: Colors.black, size: 20),
              SizedBox(width: 8),
              Text(
                'View Mapped Surviving Seedlings',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        CustomButton(
          horizontalPadding: 10,
          isFullWidth: true,
          backgroundColor: fPrimaryColour,
          verticalPadding: 16.0,
          onTap: () {
            if (_validateSeedlingSurvivalPage()) {
              _navigateToSeedlingMapping();
            }
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.map, color: Colors.white, size: 20),
              SizedBox(width: 8),
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
      ],
    );
  }

  bool _validateSeedlingSurvivalPage() {
    if (controller.totalSeedlingsAlive.text.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please enter total number of seedlings alive',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (controller.speciesAlive.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please select at least one species that is alive',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (controller.reasonForDeath.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please select at least one reason for death',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    return true;
  }

  void _navigateToSeedlingMapping() {
    Map<String, dynamic> farm = {"bounds": controller.polygon!.points};
    // Save current data
    controller.saveSeedlingSurvivalData();

    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (BuildContext context) => PickTreesMap(
          farm: farm,
          survivedSeedlings: controller.speciesAlive,
        ),
      ),
    );
  }

  void _navigateToSeedlingMappingView() {
    Map<String, dynamic> farm = {"bounds": controller.polygon!.points};
    // Save current data
    controller.saveSeedlingSurvivalData();

    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (BuildContext context) => PickTreesMap(
          farm: farm,
          survivedSeedlings: controller.speciesAlive,
          treeData: controller.monitoringService.currentMonitoring.value.treeData ?? [],
          isViewMode: true,
          isViewModePolygon: true,
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

          // Source of Water Section
          _buildWaterSourceSection(),
          const SizedBox(height: 24),

          // Watering Frequency Section
          _buildWateringFrequencySection(),
          const SizedBox(height: 24),

          // Extreme Weather Section
          _buildExtremeWeatherSection(),
          const SizedBox(height: 24),

          // Other Specification (if needed)
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
    final waterSources = [
      "Rain_Fed",
      "Manual_Watering",
      "Irrigation_With_Pumps",
    ];

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
            children: waterSources.map((source) {
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
    final frequencyOptions = [
      {"label": "Daily", "value": "Daily"},
      {"label": "Weekly", "value": "Weekly"},
      {"label": "Monthly", "value": "Monthly"},
      {"label": "Rarely/Never", "value": "Rarely_Never"},
    ];

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
            children: frequencyOptions.map((option) {
              return RadioListTile<String>(
                title: Text(option["label"]!),
                value: option["value"]!,
                groupValue: controller.waterFrequency.value,
                onChanged: (value) {
                  controller.waterFrequency.value = value!;
                },
                activeColor: fPrimaryColour,
                contentPadding: EdgeInsets.zero,
              );
            }).toList(),
          ),
        ),
        Obx(
          () => controller.waterFrequency.isEmpty
              ? const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Please select watering frequency',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                )
              : const SizedBox(),
        ),
      ],
    );
  }

  Widget _buildExtremeWeatherSection() {
    final weatherEvents = ["Drought", "Flooding", "Fire", "Other"];

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

        // Yes/No Radio Buttons
        Obx(
          () => Row(
            children: [
              Expanded(
                child: RadioListTile<bool>(
                  title: const Text('Yes'),
                  value: true,
                  groupValue: controller.hasExtremeWeather.value,
                  onChanged: (value) {
                    controller.hasExtremeWeather.value = value!;
                  },
                  activeColor: fPrimaryColour,
                ),
              ),
              Expanded(
                child: RadioListTile<bool>(
                  title: const Text('No'),
                  value: false,
                  groupValue: controller.hasExtremeWeather.value,
                  onChanged: (value) {
                    controller.hasExtremeWeather.value = value!;
                    // Clear extreme weathers if "No" is selected
                    if (value == false) {
                      controller.extremeWeathers.clear();
                    }
                  },
                  activeColor: fPrimaryColour,
                ),
              ),
            ],
          ),
        ),

        // Extreme Weather Selection (only show if Yes is selected)
        Obx(
          () => controller.hasExtremeWeather.value == true
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
                      children: weatherEvents.map((weather) {
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
                          controller.hasExtremeWeather.value == true &&
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        CustomFormField(
          controller: controller.otherController,
          label: 'Specify Other Extreme Weather',
          hintText: 'Please describe the extreme weather event',
          prefixIcon: Icons.warning,
          maxLines: 2,
          validator: (value) {
            if (controller.extremeWeathers.contains("Other") &&
                (value?.isEmpty ?? true)) {
              return 'Please specify the extreme weather event';
            }
            return null;
          },
        ),
      ],
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

          // Pest and Disease Section
          _buildPestAndDiseaseSection(),
          const SizedBox(height: 24),

          // Maintenance and Care Section
          _buildMaintenanceSection(),
          const SizedBox(height: 24),

          // Additional Observations
          _buildAdditionalObservationsSection(),
          const SizedBox(height: 24),

          // Submit Button
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

        // Pests Around
        _buildYesNoQuestion(
          title: 'Have you noticed any pests on or around the seedlings?',
          value: controller.pestsAround.value,
          onChanged: (value) {
            controller.pestsAround.value = value ?? false;
            if (!value!) {
              controller.pestDescription.clear();
            }
          },
          descriptionController: controller.pestDescription,
          descriptionLabel: 'Specify pest description',
          descriptionHint: 'Describe the pests observed...',
        ),
        const SizedBox(height: 20),

        // Signs of Disease
        _buildYesNoQuestion(
          title: 'Have you noticed any signs of disease on the seedlings?',
          value: controller.signsOfDisease.value,
          onChanged: (value) {
            controller.signsOfDisease.value = value ?? false;
            if (!value!) {
              controller.diseaseDescription.clear();
            }
          },
          descriptionController: controller.diseaseDescription,
          descriptionLabel: 'Specify disease signs',
          descriptionHint: 'Describe the disease symptoms observed...',
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

        // Fertilizer Applied
        _buildYesNoQuestion(
          title: 'Were any fertilizers or any soil amendments applied?',
          value: controller.fertiliserApplied.value,
          onChanged: (value) {
            controller.fertiliserApplied.value = value ?? false;
            if (!value!) {
              controller.fertiliserType.clear();
            }
          },
          descriptionController: controller.fertiliserType,
          descriptionLabel: 'Specify fertilizer type',
          descriptionHint: 'Describe the fertilizer or soil amendment used...',
        ),
        const SizedBox(height: 20),

        // Pesticide/Herbicide Applied
        _buildYesNoQuestion(
          title: 'Were any pesticide or herbicide applied?',
          value: controller.pesticideApplied.value,
          onChanged: (value) {
            controller.pesticideApplied.value = value ?? false;
            if (!value!) {
              controller.pesticideType.clear();
            }
          },
          descriptionController: controller.pesticideType,
          descriptionLabel: 'Specify pesticide/herbicide type',
          descriptionHint: 'Describe the pesticide or herbicide used...',
        ),
      ],
    );
  }

  Widget _buildYesNoQuestion({
    required String title,
    required bool? value,
    required ValueChanged<bool?> onChanged,
    required TextEditingController descriptionController,
    required String descriptionLabel,
    required String descriptionHint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: RadioListTile<bool>(
                title: const Text('Yes'),
                value: true,
                groupValue: value,
                onChanged: onChanged,
                activeColor: fPrimaryColour,
                contentPadding: EdgeInsets.zero,
              ),
            ),
            Expanded(
              child: RadioListTile<bool>(
                title: const Text('No'),
                value: false,
                groupValue: value,
                onChanged: onChanged,
                activeColor: fPrimaryColour,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (value == true)
          CustomFormField(
            controller: descriptionController,
            label: descriptionLabel,
            hintText: descriptionHint,
            prefixIcon: Icons.description,
            maxLines: 3,
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Please provide details';
              }
              return null;
            },
          ),
      ],
    );
  }

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
        CustomFormField(
          controller: controller.additionalObservations,
          label: 'Additional Observations',
          hintText:
              'Enter any additional observations, comments, or recommendations...',
          prefixIcon: Icons.comment,
          maxLines: 4,
          validator: (value) {
            // This field is optional, so no validation required
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Column(
      children: [
        CustomButton(
          horizontalPadding: 10,
          isFullWidth: true,
          backgroundColor: fPrimaryColour,
          verticalPadding: 16.0,
          onTap: () {
            debugPrint("Submit button pressed");
            // if (_validateFinalObservationsPage()) {
            _showSubmissionDialog();
            // }
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.cloud_upload, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text(
                'Submit Monitoring Data',
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
          'Review all data before submission',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontStyle: FontStyle.italic,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  void _showSubmissionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Submit Data'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.wifi, size: 48, color: Colors.blue),
              SizedBox(height: 16),
              Text(
                'Do you have internet connection?',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'Choose how you want to submit the monitoring data',
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: fPrimaryColour,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Submit to server'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: fSecondaryColour,
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                await controller.saveDataOffline();
              },
              child: Text(
                'Save Offline',
                style: TextStyle(color: AppColor.black),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('CANCEL'),
            ),
          ],
        );
      },
    );
  }
}
