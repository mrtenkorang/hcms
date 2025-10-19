import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:get/get.dart';
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/boilerplate/widgets.dart';
import 'package:hcms_revived2/main.dart';
import 'package:hcms_revived2/models/apimodels/communitymodel.dart';
import 'package:hcms_revived2/models/apimodels/farmerlistmodel.dart';
import 'package:hcms_revived2/screens/home/index.dart';
import 'package:hcms_revived2/screens/treemonitoring/initialpage.dart';
import 'package:hcms_revived2/utils/widgets/textFields/generic_text_field.dart';
import 'package:hcms_revived2/utils/widgets/textFormats/text_formats.dart';
import 'training_log_controller.dart';

class TrainingLogScreen extends StatelessWidget {
  const TrainingLogScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TrainingLogController>(
      init: TrainingLogController(),
      builder: (controller) => _TrainingLogView(controller: controller),
    );
  }
}

class _TrainingLogView extends StatelessWidget {
  final TrainingLogController controller;

  const _TrainingLogView({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: Column(
          children: [
            _buildProgressIndicator(),
            Expanded(
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: PageController(viewportFraction: 1),
                onPageChanged: (index) => controller.currentStep.value = index,
                children: [
                  _buildStep1(context),
                  _buildStep2(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      foregroundColor: Colors.white,
      automaticallyImplyLeading: false,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [fPrimaryColour, fPrimaryColour.withOpacity(0.8)],
          ),
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.school, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          const Text(
            "Training Log",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
      actions: [
        Tooltip(
          message: "Go to homepage",
          child: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.home, color: Colors.white, size: 20),
            ),
            onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) => const IndexPage()),
            ),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildProgressIndicator() {
    return Obx(() => Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildProgressStep(
              1,
              "Event Details",
              controller.currentStep.value >= 0,
              true,
            ),
          ),
          Expanded(
            child: Container(
              height: 2,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: controller.currentStep.value >= 1
                      ? [fPrimaryColour, fPrimaryColour]
                      : [Colors.grey[300]!, Colors.grey[300]!],
                ),
              ),
            ),
          ),
          Expanded(
            child: _buildProgressStep(
              2,
              "Participants",
              controller.currentStep.value >= 1,
              false,
            ),
          ),
        ],
      ),
    ));
  }

  Widget _buildProgressStep(int step, String label, bool isActive, bool isFirst) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            gradient: isActive
                ? LinearGradient(
              colors: [fPrimaryColour, fPrimaryColour.withOpacity(0.7)],
            )
                : null,
            color: isActive ? null : Colors.grey[300],
            shape: BoxShape.circle,
            boxShadow: isActive
                ? [
              BoxShadow(
                color: fPrimaryColour.withOpacity(0.4),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ]
                : null,
          ),
          child: Center(
            child: Icon(
              isFirst ? Icons.event_note : Icons.people,
              color: isActive ? Colors.white : Colors.grey[600],
              size: 24,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: isActive ? fPrimaryColour : Colors.grey[500],
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildStep1(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: controller.formKey,
        child: Column(
          children: [
            _buildInfoCard(
              icon: Icons.info_outline,
              title: "Event Information",
              description: "Please provide details about the training event",
            ),
            const SizedBox(height: 24),

            _buildModernCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader("Community Selection", Icons.location_on),
                  const SizedBox(height: 16),
                  _buildCommunityDropdown(),
                ],
              ),
            ),
            const SizedBox(height: 16),

            _buildModernCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader("Topic", Icons.topic),
                  const SizedBox(height: 16),
                  TextFieldWidget(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: "Enter training topic",
                      prefixIcon: Icon(Icons.subject, color: fPrimaryColour),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                    controller: controller.topic,
                    validator: (input) => input!.trim().isEmpty ? 'Please enter topic' : null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            _buildModernCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader("Event Date", Icons.calendar_today),
                  const SizedBox(height: 16),
                  _buildDatePicker(
                    context: context,
                    label: "Date event began",
                    isDateSelected: controller.isVisitDate.value,
                    dateString: controller.visitDateYearInString.value,
                    onTap: (date) => _showDatePicker(context, (selectedDate) {
                      controller.setVisitDate(selectedDate);
                    }),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            _buildModernCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader("Event Duration", Icons.timer),
                  const SizedBox(height: 16),
                  _buildDurationFields(),
                ],
              ),
            ),
            const SizedBox(height: 16),

            _buildModernCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader("Trainer Information", Icons.person),
                  const SizedBox(height: 16),
                  TextFieldWidget(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: "Name of trainer",
                      prefixIcon: Icon(Icons.person_outline, color: fPrimaryColour),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                    controller: controller.trainerName,
                    validator: (input) => input!.trim().isEmpty ? 'Please enter trainer name' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFieldWidget(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: "Trainer's organisation",
                      prefixIcon: Icon(Icons.business, color: fPrimaryColour),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                    controller: controller.trainerOrg,
                    validator: (input) => input!.trim().isEmpty ? 'Please enter organisation' : null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            _buildNavigationButton(
              text: "Next: Add Participants",
              icon: Icons.arrow_forward,
              onPressed: () {
                if (controller.validateStep1()) {
                  controller.setTLValues();
                  controller.nextStep();
                }
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildStep2(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildInfoCard(
                icon: Icons.group_add,
                title: "Add Participants",
                description: "Select farmers who attended the training",
              ),
              const SizedBox(height: 16),
              _buildModernCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader("Select Farmer", Icons.person_search),
                    const SizedBox(height: 16),
                    _buildFarmerDropdown(),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [fPrimaryColour.withOpacity(0.1), Colors.white],
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.people, color: fPrimaryColour, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        "PARTICIPANTS LIST",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: fPrimaryColour,
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: fPrimaryColour,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${controller.items.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: controller.items.isEmpty
                      ? _buildEmptyState()
                      : SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: _buildParticipantsTable(),
                  ),
                ),
              ],
            ),
          ),
        ),
        _buildStep2Buttons(),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_add_disabled, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'No participants added yet',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Select farmers from the dropdown above',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [fPrimaryColour.withOpacity(0.1), Colors.white],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: fPrimaryColour.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: fPrimaryColour.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: fPrimaryColour, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: fPrimaryColour,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: fPrimaryColour, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: fPrimaryColour,
          ),
        ),
      ],
    );
  }

  Widget _buildCommunityDropdown() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[50],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: FutureBuilder<List<CommunityJson>>(
        future: controller.myCFuture,
        builder: (context, AsyncSnapshot<List<CommunityJson>> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Padding(
              padding: EdgeInsets.all(12.0),
              child: Center(child: CircularProgressIndicator()),
            );
          } else if (!snapshot.hasData) {
            return const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text("Operation failed. Sync to get data."),
            );
          } else if (snapshot.hasData) {
            return DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: controller.community.value,
                isExpanded: true,
                icon: Icon(Icons.arrow_drop_down, color: fPrimaryColour),
                items: snapshot.data!.map((CommunityJson dvalue) {
                  return DropdownMenuItem<String>(
                    value: dvalue.name,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        dvalue.name!,
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (String? value) {
                  if (value != null) {
                    final selectedCommunity = snapshot.data!.firstWhere(
                          (element) => element.name == value,
                    );
                    controller.community.value = value;
                    controller.communityVal.value = selectedCommunity.comcode;
                    controller.onCommChanged(value, selectedCommunity.comcode!);
                  }
                },
              ),
            );
          } else {
            return const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text("Please sync data"),
            );
          }
        },
      ),
    );
  }

  Widget _buildFarmerDropdown() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[50],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: FutureBuilder<List<FarmerListJson>>(
        future: controller.myFlFuture,
        builder: (context, AsyncSnapshot<List<FarmerListJson>> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Padding(
              padding: EdgeInsets.all(12.0),
              child: Center(child: CircularProgressIndicator()),
            );
          } else if (!snapshot.hasData) {
            return const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text("Operation failed. Sync to get data."),
            );
          } else if (snapshot.hasData) {
            return DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: controller.ffarmerlist,
                isExpanded: true,
                hint: const Text("Select a farmer"),
                icon: Icon(Icons.arrow_drop_down, color: fPrimaryColour),
                items: snapshot.data!.map((FarmerListJson dvalue) {
                  return DropdownMenuItem<String>(
                    value: dvalue.farmerid.toString(),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        dvalue.farmername!,
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (String? value) {
                  if (value != null) {
                    final selectedFarmer = snapshot.data!.firstWhere(
                          (element) => element?.farmerid.toString() == value,
                    );
                    controller.onFarmerListChanged(value, selectedFarmer);
                  }
                },
              ),
            );
          } else {
            return const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text("Please sync data"),
            );
          }
        },
      ),
    );
  }

  Widget _buildDurationFields() {
    return Row(
      children: [
        Expanded(
          child: TextFieldWidget(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Hours",
              prefixIcon: Icon(Icons.access_time, color: fPrimaryColour),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey[50],
            ),
            controller: controller.durHours,
            validator: (input) => input!.trim().isEmpty ? 'Required' : null,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            ":",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: fPrimaryColour,
            ),
          ),
        ),
        Expanded(
          child: TextFieldWidget(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Minutes",
              prefixIcon: Icon(Icons.timer, color: fPrimaryColour),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey[50],
            ),
            controller: controller.durMins,
            validator: (input) => input!.trim().isEmpty ? 'Required' : null,
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker({
    BuildContext? context,
    required String label,
    required bool isDateSelected,
    required String dateString,
    required Function(DateTime) onTap,
  }) {
    return GestureDetector(
      onTap: () => _showDatePicker(context!, onTap),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[50],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: fPrimaryColour.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.calendar_today, color: fPrimaryColour, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                isDateSelected ? dateString : "Select date",
                style: TextStyle(
                  fontSize: 15,
                  color: isDateSelected ? Colors.black87 : Colors.grey[500],
                ),
              ),
            ),
            Icon(Icons.arrow_drop_down, color: fPrimaryColour),
          ],
        ),
      ),
    );
  }

  Widget _buildParticipantsTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        showCheckboxColumn: true,
        columnSpacing: 30.0,
        headingRowColor: MaterialStateProperty.all(fPrimaryColour.withOpacity(0.1)),
        columns: [
          DataColumn(
            label: Row(
              children: [
                Icon(Icons.person, color: fPrimaryColour, size: 18),
                const SizedBox(width: 8),
                const Text(
                  'Farmer Name',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          DataColumn(
            label: Row(
              children: [
                Icon(Icons.location_on, color: fPrimaryColour, size: 18),
                const SizedBox(width: 8),
                const Text(
                  'Community',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
        rows: controller.items.map((item) {
          final isSelected = controller.selectedPoints.contains(item);
          return DataRow(
            selected: isSelected,
            color: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                if (states.contains(MaterialState.selected)) {
                  return fPrimaryColour.withOpacity(0.1);
                }
                return null;
              },
            ),
            onSelectChanged: (selected) {
              if (selected != null) {
                controller.onSelectedRow(selected, item);
              }
            },
            cells: [
              DataCell(Text(item.farmerName.toString())),
              DataCell(Text(item.communityName ?? "not found")),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStep2Buttons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildNavigationButton(
              text: "Back",
              icon: Icons.arrow_back,
              onPressed: controller.previousStep,
              isSecondary: true,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Obx(() => _buildNavigationButton(
              text: "Finish",
              icon: Icons.check_circle,
              onPressed: controller.isLoading.value ? null : () => _showSubmissionOptions(),
              isLoading: controller.isLoading.value,
            )),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: controller.deleteSelected,
              icon: const Icon(Icons.delete_forever, color: Colors.red),
              tooltip: "Delete selected",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButton({
    required String text,
    required IconData icon,
    required VoidCallback? onPressed,
    bool isSecondary = false,
    bool isLoading = false,
  }) {
    return SizedBox(
      height: 54,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isSecondary ? Colors.grey[600] : fPrimaryColour,
          foregroundColor: Colors.white,
          elevation: isSecondary ? 0 : 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          shadowColor: isSecondary ? null : fPrimaryColour.withOpacity(0.4),
        ),
        onPressed: onPressed,
        child: isLoading
            ? const SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white,
          ),
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDatePicker(BuildContext context, Function(DateTime) onConfirm) {
    DatePicker.showDatePicker(
      context,
      theme: DatePickerTheme(
        backgroundColor: fPrimaryColour,
        itemStyle: const TextStyle(color: Color(0xFFf9f9f9)),
        cancelStyle: const TextStyle(color: Color(0xFFffe423)),
        doneStyle: const TextStyle(color: Color(0xFFf9f9f9)),
        containerHeight: 210.0,
      ),
      showTitleActions: true,
      minTime: DateTime(1800),
      maxTime: DateTime.now(),
      onConfirm: onConfirm,
      locale: LocaleType.en,
    );
  }

  void _showSubmissionOptions() {
    if (!controller.validateStep2()) {
      Get.snackbar(
        'Error',
        'Please add at least one participant',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        icon: const Icon(Icons.error_outline, color: Colors.white),
      );
      return;
    }

    controller.convertu();
    controller.getTLValues();

    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: fPrimaryColour.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.send, color: fPrimaryColour, size: 24),
              ),
              const SizedBox(width: 12),
              const Text(
                "Submit Training Log",
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Choose how you want to submit your training log:",
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Online submission requires internet connection",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onPressed: () {
                Navigator.pop(context);
                controller.saveToLocalDB("not connected");
                Get.snackbar(
                  'Success',
                  'Training log saved locally',
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                  snackPosition: SnackPosition.BOTTOM,
                  margin: const EdgeInsets.all(16),
                  borderRadius: 12,
                  icon: const Icon(Icons.check_circle, color: Colors.white),
                );
                controller.clearAndNavigate();
              },
              icon: const Icon(Icons.save, size: 18),
              label: const Text("Save Offline"),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onPressed: () {
                Navigator.pop(context);
                controller.attemptSignup(Get.context!);
              },
              icon: const Icon(Icons.cloud_upload, size: 18),
              label: const Text("Submit Online"),
            ),
          ],
        );
      },
    );
  }
}