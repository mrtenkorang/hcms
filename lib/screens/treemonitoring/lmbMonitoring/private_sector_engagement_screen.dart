import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:get/get.dart';
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/boilerplate/widgets.dart';
import 'package:hcms_revived2/screens/home/index.dart';
import 'package:hcms_revived2/utils/widgets/textFields/generic_text_field.dart';
import 'package:hcms_revived2/utils/widgets/textFormats/text_formats.dart';
import 'private_sector_engagement_screen_controller.dart';

class PrivateSectorEngagementScreen extends StatelessWidget {
  const PrivateSectorEngagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PrivateSectorEngagementController>(
      init: PrivateSectorEngagementController(),
      builder: (controller) => _PrivateSectorEngagementView(controller: controller),
    );
  }
}

class _PrivateSectorEngagementView extends StatelessWidget {
  final PrivateSectorEngagementController controller;

  const _PrivateSectorEngagementView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    controller.lmbScreenContext = context;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      foregroundColor: fPrimaryWhite,
      backgroundColor: fPrimaryColour,
      elevation: 0,
      title: Row(
        children: [
          Text(
            "Private Sector Engagement",
            style: TextStyle(
              color: fPrimaryWhite,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Header Card
          // _buildHeaderCard(),
          // SizedBox(height: 24),

          // Main Form
          _buildForm(context),
        ],
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [fPrimaryColour.withOpacity(0.8), fPrimaryColour],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: fPrimaryWhite, size: 20),
                SizedBox(width: 8),
                Text(
                  "Engagement Information",
                  style: TextStyle(
                    color: fPrimaryWhite,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              "Please fill in the details about your sector engagement. All fields are required.",
              style: TextStyle(
                color: fPrimaryWhite.withOpacity(0.9),
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: Column(
        children: [
          // LMB Name Field
          _buildSection(
            title: "Basic Information",
            icon: Icons.business,
            children: [_buildLmbNameField(context)],
          ),

          // Engagement Type
          _buildSection(
            title: "Engagement Type",
            icon: Icons.category,
            children: [_buildEngagementType()],
          ),

          // Common Fields
          _buildSection(
            title: "Organization Details",
            icon: Icons.account_balance,
            children: _buildCommonFields(context),
          ),

          // Conditional Fields based on Sector
          Obx(() {
            if (controller.sector.value == "Private") {
              return _buildSection(
                title: "Partnership Details",
                icon: Icons.group,
                children: _buildPrivateSectorFields(context),
              );
            } else if (controller.sector.value == "Financial") {
              return _buildSection(
                title: "Financial Services",
                icon: Icons.monetization_on,
                children: _buildFinancialSectorFields(context),
              );
            }
            return const SizedBox.shrink();
          }),


          _buildSubmitButton(context),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: fPrimaryColour, size: 20),
                SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildLmbNameField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel("LMB Name"),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: TextFieldWidget(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              hintText: "Enter LMB name",
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              suffixIcon: Icon(Icons.business_center, color: Colors.grey[500]),
            ),
            controller: controller.lmbName,
            validator: (input) => input!.trim().isEmpty ? 'Please enter LMB name' : null,
          ),
        ),
      ],
    );
  }

  Widget _buildEngagementType() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel("Select Engagement Type"),
        SizedBox(height: 12),
        Obx(() => Row(
          children: [
            Expanded(
              child: _buildEngagementTypeCard(
                title: "Private Sector",
                subtitle: "Business partnerships",
                icon: Icons.business,
                isSelected: controller.selectedVisitRadio.value == 1,
                onTap: () {
                  controller.selectedVisitRadio.value = 1;
                  controller.toggleSectorValue("Private");
                },
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildEngagementTypeCard(
                title: "Financial Sector",
                subtitle: "Loans & services",
                icon: Icons.attach_money,
                isSelected: controller.selectedVisitRadio.value == 2,
                onTap: () {
                  controller.selectedVisitRadio.value = 2;
                  controller.toggleSectorValue("Financial");
                },
              ),
            ),
          ],
        )),
      ],
    );
  }

  Widget _buildEngagementTypeCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? fPrimaryColour.withOpacity(0.1) : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? fPrimaryColour : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? fPrimaryColour : Colors.grey[600], size: 24),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isSelected ? fPrimaryColour : Colors.grey[800],
              ),
            ),
            SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? fPrimaryColour.withOpacity(0.8) : Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCommonFields(BuildContext context) {
    return [
      Obx(() => _buildFieldLabel(
        controller.sector.value == "Private"
            ? "Private Sector Name"
            : "Financial Institution Name",
      )),
      SizedBox(height: 8),
      Obx(() => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: TextFieldWidget(
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            hintText: controller.sector.value == "Private"
                ? "Enter private sector name"
                : "Enter financial institution name",
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            suffixIcon: Icon(Icons.account_balance, color: Colors.grey[500]),
          ),
          controller: controller.sector.value == "Private"
              ? controller.privateName
              : controller.financialName,
          validator: (input) => input!.trim().isEmpty ? 'Please enter a name' : null,
        ),
      )),
      SizedBox(height: 16),
      _buildDatePicker(context),
    ];
  }

  Widget _buildDatePicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel("Date of First Engagement"),
        SizedBox(height: 8),
        Obx(() => InkWell(
          onTap: () {
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
              onConfirm: (date) => controller.setEngagementDate(date),
              locale: LocaleType.en,
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: fPrimaryColour,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    controller.isVisitDate.value && controller.visitDateYearInString.value.isNotEmpty
                        ? controller.visitDateYearInString.value
                        : "Select engagement date",
                    style: TextStyle(
                      color: controller.isVisitDate.value ? Colors.grey[800] : Colors.grey[500],
                      fontSize: 16,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: Colors.grey[500],
                ),
              ],
            ),
          ),
        )),
      ],
    );
  }

  List<Widget> _buildPrivateSectorFields(BuildContext context) {
    return [
      _buildTextFieldWithLabel(
        label: "Type of Partnership",
        hint: "e.g., Joint venture, Supply agreement",
        controller: controller.partnershipType,
        icon: Icons.handshake,
      ),
      const SizedBox(height: 16),
      _buildTextFieldWithLabel(
        label: "Duration of Partnership",
        hint: "e.g., 2 years, Permanent",
        controller: controller.partnershipDuration,
        icon: Icons.schedule,
      ),
      const SizedBox(height: 16),
      _buildTextFieldWithLabel(
        label: "MoU Signed?",
        hint: "Yes/No and details",
        controller: controller.mouSigned,
        icon: Icons.description,
      ),
    ];
  }

  List<Widget> _buildFinancialSectorFields(BuildContext context) {
    return [
      _buildTextFieldWithLabel(
        label: "Type of Loan/Financial Service",
        hint: "e.g., Agricultural loan, Microcredit",
        controller: controller.typeLoanService,
        icon: Icons.credit_card,
      ),
      const SizedBox(height: 16),
      Row(
        children: [
          Expanded(
            child: _buildTextFieldWithLabel(
              label: "Loan Duration (years)",
              hint: "e.g., 5",
              controller: controller.loanDuration,
              icon: Icons.timelapse,
              keyboardType: TextInputType.number,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildTextFieldWithLabel(
              label: "Interest Rate (%)",
              hint: "e.g., 12.5",
              controller: controller.loanInterest,
              icon: Icons.percent,
              keyboardType: TextInputType.number,
            ),
          ),
        ],
      ),
      const SizedBox(height: 20),
      _buildBeneficiarySection(),
    ];
  }

  Widget _buildBeneficiarySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Number of Farmers Benefitting",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          "Enter the number of farmers benefiting from this engagement",
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildBeneficiaryField(
                label: "Male",
                controller: controller.maleBenefitting,
                color: Colors.transparent,
                iconColor: Colors.transparent,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildBeneficiaryField(
                label: "Female",
                controller: controller.femaleBenefitting,
                color: Colors.transparent,
                iconColor: Colors.transparent,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildBeneficiaryField(
                label: "Youth",
                controller: controller.youthBenefitting,
                color: Colors.transparent,
                iconColor: Colors.transparent,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBeneficiaryField({
    required String label,
    required TextEditingController controller,
    required Color color,
    required Color iconColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            // color: color,
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: "0",
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              // suffixIcon: Icon(Icons.people, size: 16, color: iconColor),
            ),
            validator: (input) => input!.trim().isEmpty ? 'Enter number' : null,
          )
        ),
      ],
    );
  }

  Widget _buildTextFieldWithLabel({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel(label),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: TextFieldWidget(
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              suffixIcon: Icon(icon, color: Colors.grey[500]),
            ),
            controller: controller,
            validator: (input) => input!.trim().isEmpty ? 'This field is required' : null,
          ),
        ),
      ],
    );
  }

  Widget _buildFieldLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.grey[700],
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return Row(
      children: [
        // Save Offline button
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.save_alt, size: 20),
              label: const Text('Save'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: () {
                Navigator.pop(context);
                controller.saveLocally();
              },
            ),
          ),
        ),
        // Submit button
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.cloud_upload, size: 20),
            label: const Text('Submit'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onPressed: () async {
              // Navigator.pop(context);
              await controller.attemptLMBUpload();
            },
          ),
        ),
      ],
    );
  }

}