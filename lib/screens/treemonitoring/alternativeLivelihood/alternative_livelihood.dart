import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:get/get.dart';
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/boilerplate/widgets.dart';
import 'package:hcms_revived2/controller/models/farmer_from_server.dart';
import 'package:hcms_revived2/screens/home/index.dart';
import 'package:hcms_revived2/utils/widgets/textFields/generic_text_field.dart';
import 'package:hcms_revived2/utils/widgets/textFormats/text_formats.dart';
import 'alternative_livelihood_controller.dart';

class AlternativeLivelihoodScreen extends StatelessWidget {
  const AlternativeLivelihoodScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AlternativeLivelihoodController>(
      init: AlternativeLivelihoodController(),
      builder: (controller) =>
          _AlternativeLivelihoodView(controller: controller),
    );
  }
}

class _AlternativeLivelihoodView extends StatelessWidget {
  final AlternativeLivelihoodController controller;

  const _AlternativeLivelihoodView({Key? key, required this.controller})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.alternativeLivelihoodContext = context;
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [Expanded(child: _buildCompleteForm(context))],
          ),
        ),
      ),
    );
  }

  Widget _buildCompleteForm(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCommunityDropDown(context),
          const SizedBox(height: 24),
          // Header Card
          // _buildHeaderCard(),
          // const SizedBox(height: 24),

          // Visit Information Card
          _buildCard(
            icon: Icons.calendar_today,
            iconColor: Colors.blue,
            title: "Visit Information",
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDatePicker(
                  context: context,
                  label: "Date of visit",
                  isDateSelected: controller.isVisitDate.value,
                  dateString: controller.visitDateYearString.value,
                  onDateSelected: controller.setVisitDate,
                ),
                const SizedBox(height: 20),
                _buildSearchableDropdownField(
                  title: "Farmer",
                  selectedItem: controller.selectedFarmer.value,
                  displayText: controller.selectedFarmer.value != null
                      ? '${controller.selectedFarmer.value!.farmerName} - ${controller.selectedFarmer.value!.contact}'
                      : "Select Farmer",
                  onTap: () => _showFarmerSelectionBottomSheet(context),
                  isLoading: false,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Activity Details Card
          _buildCard(
            icon: Icons.work,
            iconColor: Colors.green,
            title: "Activity Details",
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildChipSelection(
                  title: "Type of livelihood activity",
                  options: const [
                    "Snail rearing",
                    "Vegetable farming",
                    "Food processing",
                    "Pig sty",
                    "Bee keeping",
                    "Soap making",
                  ],
                  selectedIndex: controller.selectedActivityRadio.value != null
                      ? controller.selectedActivityRadio.value! - 1
                      : -1,
                  onSelected: (index) =>
                      controller.setAdditionalActivity(index + 1),
                ),
                const SizedBox(height: 20),
                Text("Trainer organisation"),
                TextFieldWidget(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: "Trainer organisation",
                    prefixIcon: Icon(Icons.business, color: Colors.green),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  controller: controller.trainerOrganisation,
                  validator: (input) => input!.trim().isEmpty
                      ? 'Please enter organisation'
                      : null,
                ),
                const SizedBox(height: 20),
                _buildDatePicker(
                  context: context,
                  label: "Date operations started",
                  isDateSelected: controller.isOperationsDate.value,
                  dateString: controller.operationsDateString.value,
                  onDateSelected: controller.setOperationsDate,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Investment Details Card
          _buildCard(
            icon: Icons.money,
            iconColor: fSecondaryColour,
            title: "Investment Details",
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Initial amount invested"),
                TextFieldWidget(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Initial amount invested",
                    prefixIcon: Icon(Icons.savings, color: Colors.orange),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  controller: controller.initAmount,
                  validator: (input) =>
                      input!.trim().isEmpty ? 'Please enter amount' : null,
                ),
                const SizedBox(height: 20),
                _buildAmountTypeSelection(),
                const SizedBox(height: 20),
                Text("Amount contributed to LMB"),
                TextFieldWidget(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Amount contributed to LMB",
                    prefixIcon: Icon(
                      Icons.account_balance,
                      color: Colors.orange,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  controller: controller.amountToLmb,
                  validator: (input) =>
                      input!.trim().isEmpty ? 'Please enter amount' : null,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Income Support Card
          _buildCard(
            icon: Icons.support,
            iconColor: fred,
            title: "Income Support",
            child: _buildChipSelection(
              title: "Activity that income supports",
              options: const [
                "School fees",
                "Home appliances",
                "Medical bills",
                "Buy farm inputs",
              ],
              selectedIndex: controller.selectedSupportRadio.value != null
                  ? controller.selectedSupportRadio.value! - 1
                  : -1,
              onSelected: (index) => controller.setActivitySupport(index + 1),
            ),
          ),
          const SizedBox(height: 32),

          // Submission Buttons
          _buildSubmissionButtons(context),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildCommunityDropDown(BuildContext context) {
    return Obx(
      () => _buildSearchableDropdownField(
        title: "Community",
        selectedItem: controller.selectedCommunity.value,
        displayText:
            controller.selectedCommunity.value?.community ?? "Select Community",
        onTap: () => _showCommunitySelectionBottomSheet(context),
        isLoading: false,
        // isLoading: controller.isLoadingCommunities.value,
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
          const Text(
            "Alternative Livelihood",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
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

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return GetBuilder<AlternativeLivelihoodController>(
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
                      onChanged: (_) => controller.update(),
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

  Widget _buildHeaderCard() {
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
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [fPrimaryColour, fPrimaryColour.withOpacity(0.7)],
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: fPrimaryColour.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.trending_up, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Livelihood Survey',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: fPrimaryColour,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Track alternative income activities',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required Widget child,
  }) {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [iconColor.withOpacity(0.1), Colors.white],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: iconColor, size: 22),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: iconColor,
                  ),
                ),
              ],
            ),
          ),
          Padding(padding: const EdgeInsets.all(20), child: child),
        ],
      ),
    );
  }

  Widget _buildChipSelection({
    required String title,
    required List<String> options,
    required int selectedIndex,
    required Function(int) onSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: List.generate(options.length, (index) {
            final isSelected = index == selectedIndex;
            return ChoiceChip(
              label: Text(
                options[index],
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  onSelected(index);
                }
              },
              backgroundColor: Colors.grey[100],
              selectedColor: fPrimaryColour,
              side: BorderSide(
                color: isSelected ? fPrimaryColour : Colors.grey[300]!,
                width: 1.5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              labelPadding: const EdgeInsets.symmetric(horizontal: 4),
              elevation: isSelected ? 2 : 0,
              shadowColor: fPrimaryColour.withOpacity(0.3),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildDatePicker({
    required BuildContext context,
    required String label,
    required bool isDateSelected,
    required String dateString,
    required void Function(DateTime) onDateSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _showDatePicker(context, onDateSelected),
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
                  child: Icon(
                    Icons.calendar_today,
                    color: fPrimaryColour,
                    size: 18,
                  ),
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
        ),
      ],
    );
  }

  Widget _buildAmountTypeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Amount raised after",
          style: TextStyle(
            fontSize: 15,
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Obx(
          () => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey[50],
            ),
            child: DropdownButtonFormField<String>(
              value: controller.amountType.value,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: fPrimaryColour),
                ),
                filled: true,
                fillColor: Colors.grey[50],
                prefixIcon: Icon(Icons.schedule, color: Colors.orange),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
              items: controller.amountTypeValues.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: const TextStyle(fontSize: 15)),
                );
              }).toList(),
              onChanged: (String? value) {
                if (value != null) {
                  controller.amountType.value = value;
                }
              },
            ),
          ),
        ),
        const SizedBox(height: 16),
        Obx(
          () => controller.amountType.value != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Amount raised (${controller.amountType.value})",
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFieldWidget(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Enter amount raised",
                        prefixIcon: Icon(Icons.money, color: Colors.orange),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      controller: controller.amount,
                      validator: (input) =>
                          input!.trim().isEmpty ? 'Please enter amount' : null,
                    ),
                  ],
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildSubmissionButtons(BuildContext context) {
    return Obx(
      () => Container(
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
        child: Column(
          children: [
            if (controller.isLoading.value)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 12),
                    Text(
                      'Processing...',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
              ),
            Row(
              children: [
                // Expanded(
                //   child: _buildActionButton(
                //     text: "Clear",
                //     onPressed: controller.clearForm,
                //     isSecondary: true,
                //     icon: Icons.clear_all,
                //   ),
                // ),
                // const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: _buildActionButton(
                    text: "Finish",
                    onPressed: controller.isLoading.value
                        ? null
                        : () => _showSubmissionOptions(context),
                    // icon: Icons.send,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String text,
    required VoidCallback? onPressed,
    bool isSecondary = false,
    IconData? icon,
  }) {
    return SizedBox(
      height: 54,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isSecondary ? Colors.grey[600] : fPrimaryColour,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: isSecondary ? 0 : 2,
          shadowColor: isSecondary ? null : fPrimaryColour.withOpacity(0.4),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20),
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
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
      minTime: DateTime(2000),
      maxTime: DateTime.now(),
      onConfirm: onConfirm,
      locale: LocaleType.en,
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

  void _showSubmissionOptions(BuildContext context) {
    if (!controller.validateAllFields()) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        fPrimaryColour.withOpacity(0.2),
                        fPrimaryColour.withOpacity(0.1),
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.cloud_upload,
                    size: 48,
                    color: fPrimaryColour,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Finish",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text(
                  "Choose how you want to submit your data",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.blue[700],
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Online submission requires internet",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // const SizedBox(height: 24),
                // Row(
                //   children: [
                //     Expanded(
                //       child: _buildDialogButton(
                //         text: "Cancel",
                //         onPressed: () => Navigator.pop(context),
                //         isSecondary: true,
                //       ),
                //     ),
                //   ],
                // ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildDialogButton(
                        text: "Save Offline",
                        icon: Icons.save,
                        onPressed: () {
                          Navigator.pop(context);
                          controller.saveOffline();
                        },
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildDialogButton(
                        text: "Submit",
                        icon: Icons.cloud_upload,
                        onPressed: () {
                          Navigator.pop(context);
                          controller.submitOnline();
                        },
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDialogButton({
    required String text,
    required VoidCallback onPressed,
    bool isSecondary = false,
    Color? color,
    IconData? icon,
  }) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isSecondary
              ? Colors.grey[600]
              : color ?? fPrimaryColour,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: isSecondary ? 0 : 2,
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // if (icon != null) ...[
            //   Icon(icon, size: 18),
            //   const SizedBox(width: 8),
            // ],
            Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }

  void _showCommunitySelectionBottomSheet(BuildContext context) {
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
              const Text(
                'Select Community',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                child: controller.communities.isEmpty
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
                            trailing:
                                controller.selectedCommunity.value?.id ==
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
}
