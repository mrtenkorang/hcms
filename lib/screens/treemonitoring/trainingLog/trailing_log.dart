import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:get/get.dart';
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/utils/widgets/textFields/generic_text_field.dart';
import 'training_log_controller.dart';

class TrainingLogScreen extends StatelessWidget {
  const TrainingLogScreen({super.key});

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

  const _TrainingLogView({required this.controller});

  @override
  Widget build(BuildContext context) {
    controller.trainingLogScreenContext = context;
    controller.loadCommunities();


    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    children: [
                      _buildEventDetailsSection(),
                      const SizedBox(height: 24),
                      _buildParticipantsSection(),
                      const SizedBox(height: 24),
                      _buildActionButtons(),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
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
      title: const Text(
        "Training Log",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      centerTitle: true,
    );
  }

  void _showCommunitySelectionBottomSheet() {
    showModalBottomSheet(
      context: controller.trainingLogScreenContext!,
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
              const Text(
                'Select Community',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search communities...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (query) {
                  // Implement search if needed
                },
              ),
              const SizedBox(height: 16),
              Expanded(
                child: controller.isLoadingCommunities.value
                    ? const Center(child: CircularProgressIndicator())
                    : controller.communities.isEmpty
                    ? const Center(child: Text('No communities available'))
                    : ListView.builder(
                  itemCount: controller.communities.length,
                  itemBuilder: (context, index) {
                    final community = controller.communities[index];
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
                        community.community ?? 'Unknown Community',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: controller.selectedCommunity.value?.id ==
                          community.id
                          ? Icon(
                        Icons.check_circle,
                        color: fPrimaryColour,
                      )
                          : null,
                      onTap: () {
                        controller.selectCommunity(community);
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

  void _showFarmerSelectionBottomSheet() {
    if (controller.selectedCommunity.value == null) {
      Get.snackbar(
        'Error',
        'Please select a community first',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    showModalBottomSheet(
      context: controller.trainingLogScreenContext!,
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
                'Select Farmer (${controller.selectedCommunity.value?.community ?? ''})',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search farmers...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (query) {
                  controller.farmers.clear();
                  controller.isLoadingFarmers.value = true;
                  controller.loadFarmersByCommunity(controller.selectedCommunity.value!.community!);
                },
              ),
              const SizedBox(height: 16),
              Expanded(
                child: controller.isLoadingFarmers.value
                    ? const Center(child: CircularProgressIndicator())
                    : controller.farmers.isEmpty
                    ? const Center(child: Text('No farmers available'))
                    : ListView.builder(
                  itemCount: controller.farmers.length,
                  itemBuilder: (context, index) {
                    final farmer = controller.farmers[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      leading: CircleAvatar(
                        backgroundColor: fPrimaryColour,
                        child: const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        farmer.farmerName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        farmer.contact ?? '',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      trailing: controller.selectedFarmer.value?.id ==
                          farmer.id
                          ? Icon(
                        Icons.check_circle,
                        color: fPrimaryColour,
                      )
                          : null,
                      onTap: () {
                        controller.selectFarmer(farmer);

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

  Widget _buildSearchableDropdownField({
    required String title,
    required dynamic selectedItem,
    required String displayText,
    required VoidCallback onTap,
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

  Widget _buildRequiredLabel(String text) {
    return Text.rich(
      TextSpan(
        text: text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
        children: const [
          TextSpan(
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

  Widget _buildEventDetailsSection() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Topic
          _buildFormField(
            label: "Training Topic *",
            child: TextFieldWidget(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: "Enter training topic",
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
          ),
          const SizedBox(height: 16),

          // Event Date
          _buildFormField(
            label: "Event Date *",
            child: _buildDatePicker(
              context: controller.trainingLogScreenContext,
              label: "Date event began",
              isDateSelected: controller.isVisitDate.value,
              dateString: controller.visitDateYearInString.value,
              onTap: (date) => _showDatePicker(controller.trainingLogScreenContext!, (selectedDate) {
                controller.setVisitDate(selectedDate);
              }),
            ),
          ),
          const SizedBox(height: 16),

          // Event Duration
          _buildFormField(
            label: "Event Duration *",
            child: _buildDurationFields(),
          ),
          const SizedBox(height: 16),

          // Trainer Information
          _buildFormField(
            label: "Trainer Name *",
            child: TextFieldWidget(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: "Name of trainer",
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
          ),
          const SizedBox(height: 16),

          _buildFormField(
            label: "Trainer's Organisation *",
            child: TextFieldWidget(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: "Trainer's organisation",
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
          ),
        ],
      ),
    );
  }

  Widget _buildParticipantsSection() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Community Selection
          Obx(
                () => _buildSearchableDropdownField(
              title: "Community",
              selectedItem: controller.selectedCommunity.value,
              displayText: controller.selectedCommunity.value?.community ??
                  "Select Community",
              onTap: _showCommunitySelectionBottomSheet,
              isLoading: controller.isLoadingCommunities.value,
            ),
          ),
          const SizedBox(height: 16),
          _buildSectionHeader("Participants", Icons.group),
          const SizedBox(height: 20),

          // Add Farmer Section
          _buildFormField(
            label: "Add Participant",
            child: _buildFarmerDropdown(),
          ),
          const SizedBox(height: 20),

          // Participants List
          _buildParticipantsList(),
        ],
      ),
    );
  }

  Widget _buildParticipantsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
            if (controller.participants.isNotEmpty)
              IconButton(
                onPressed: controller.deleteSelected,
                icon: const Icon(Icons.delete_forever, color: Colors.red),
                tooltip: "Delete selected",
              ),
          ],
        ),
        const SizedBox(height: 12),

        controller.selectedParticipant.isEmpty
            ? _buildEmptyState()
            : _buildParticipantsTable(),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          Icon(Icons.person_add_disabled, size: 60, color: Colors.grey[300]),
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
            'Select farmers from the dropdown above to add them',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParticipantsTable() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
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
                  Icon(Icons.phone, color: fPrimaryColour, size: 18),
                  const SizedBox(width: 8),
                  const Text(
                    'Contact',
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
                    'Community ID',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
          rows: controller.selectedParticipant.map((farmer) {
            final isSelected = controller.selectedParticipant.any((selected) => selected.id == farmer.id);
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
                  controller.onSelectedRow(selected, farmer);
                }
              },
              cells: [
                DataCell(Text(farmer.farmerName )),
                DataCell(Text(farmer.contact)),
                DataCell(Text(farmer.communityId.toString())),
              ],
            );
          }).toList(),
        ),
      ),

    );
  }

  Widget _buildActionButtons() {
    return Obx(() => Row(
      children: [
        Expanded(
          child: _buildActionButton(
            text: "Save",
            icon: Icons.save,
            onPressed: () {
              controller.saveTrainingLogOffline();
            },
            backgroundColor: Colors.orange,
            isLoading: controller.isLoading.value,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionButton(
            text: "Submit",
            icon: Icons.cloud_upload,
            onPressed: () {
              controller.submitTrainingLog();
            },
            backgroundColor: Colors.green,
            isLoading: controller.isLoading.value,
          ),
        ),
      ],
    ));
  }

  Widget _buildActionButton({
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
    required Color backgroundColor,
    bool isLoading = false,
  }) {
    return SizedBox(
      height: 54,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          shadowColor: backgroundColor.withOpacity(0.4),
        ),
        onPressed: isLoading ? null : onPressed,
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

  Widget _buildCard({required Widget child}) {
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
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: fPrimaryColour.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: fPrimaryColour, size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: fPrimaryColour,
          ),
        ),
      ],
    );
  }

  Widget _buildFormField({
    required String label,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  Widget _buildFarmerDropdown() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[50],
      ),
      child: Obx(() {
        final selectedFarmer = controller.selectedFarmer.value;

        return ListTile(
          title: Text(
            selectedFarmer?.farmerName ?? 'Select a farmer',
            style: TextStyle(
              color: selectedFarmer == null ? Colors.grey[600] : Colors.black87,
              fontSize: 16,
            ),
          ),
          subtitle: selectedFarmer?.contact != null
              ? Text(selectedFarmer!.contact)
              : null,
          trailing: const Icon(Icons.arrow_drop_down, color: Colors.grey),
          onTap: _showFarmerSelectionBottomSheet,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        );
      }),
    );
  }

  Widget _buildDurationFields() {
    return Row(
      children: [
        Expanded(
          child: TextFieldWidget(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: "Hours",
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
              hintText: "Minutes",
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

}