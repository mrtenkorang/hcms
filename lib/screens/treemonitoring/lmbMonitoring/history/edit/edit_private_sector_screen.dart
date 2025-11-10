import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:get/get.dart';
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/boilerplate/widgets.dart';
import 'package:hcms_revived2/models/localdbmodel/localdbmodel.dart';
import 'package:hcms_revived2/screens/home/index.dart';
import 'package:hcms_revived2/screens/treemonitoring/lmbMonitoring/history/edit/edit_private_sector_controller.dart';
import 'package:hcms_revived2/utils/widgets/textFields/generic_text_field.dart';
import 'package:hcms_revived2/utils/widgets/textFormats/text_formats.dart';

class EditPrivateSectorEngagementScreen extends StatefulWidget {
  const EditPrivateSectorEngagementScreen({super.key, required this.record});

  final LMBMonitoring record;

  @override
  State<EditPrivateSectorEngagementScreen> createState() => _EditPrivateSectorEngagementScreenState();
}

class _EditPrivateSectorEngagementScreenState extends State<EditPrivateSectorEngagementScreen> {
  late final EditPrivateSectorEngagementController controller;

  @override
  void initState() {
    super.initState();
    // Initialize controller once and set the record
    controller = Get.put(EditPrivateSectorEngagementController());
    controller.record = widget.record;

    // Initialize fields after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initializeFields();
    });
  }

  @override
  Widget build(BuildContext context) {
    return _PrivateSectorEngagementView(controller: controller);
  }
}

class _PrivateSectorEngagementView extends StatefulWidget {
  final EditPrivateSectorEngagementController controller;

  const _PrivateSectorEngagementView({required this.controller});

  @override
  State<_PrivateSectorEngagementView> createState() => _PrivateSectorEngagementViewState();
}

class _PrivateSectorEngagementViewState extends State<_PrivateSectorEngagementView> {
  @override
  void initState() {
    super.initState();
    // Set context and ensure fields are initialized
    widget.controller.lmbScreenContext = context;
  }

  @override
  Widget build(BuildContext context) {
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(16),
        ),
      ),
      title: Row(
        children: [
          Icon(Icons.handshake_outlined, size: 24),
          SizedBox(width: 12),
          Text(
            "Edit Sector Engagement",
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
          // Main Form
          _buildForm(context),
        ],
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: widget.controller.formKey,
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
            if (widget.controller.sector.value.toLowerCase() == "private") {
              return Column(
                children: [
                  _buildSection(
                    title: "Partnership Details",
                    icon: Icons.group,
                    children: _buildPrivateSectorFields(context),
                  ),
                  if (!(widget.controller.record!.lmbConStat == "connected"))
                    _buildSubmitButton(context),
                ],
              );
            } else if (widget.controller.sector.value == "financial") {
              return Column(
                children: [
                  _buildSection(
                    title: "Financial Services",
                    icon: Icons.monetization_on,
                    children: _buildFinancialSectorFields(context),
                  ),
                  _buildSection(
                    title: "Beneficiary Information",
                    icon: Icons.people,
                    children: [_buildBeneficiarySection()],
                  ),
                  _buildSubmitButton(context),
                ],
              );
            }
            return const SizedBox.shrink();
          }),
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
            controller: widget.controller.lmbName,
            validator: (input) => input!.trim().isEmpty ? 'Please enter LMB name' : null,
          ),
        ),
      ],
    );
  }

  Widget _buildEngagementType() {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel("Select Engagement Type"),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildEngagementTypeCard(
                title: "Private Sector",
                subtitle: "Business partnerships",
                icon: Icons.business,
                isSelected: widget.controller.selectedVisitRadio.value == 1,
                onTap: () {
                  widget.controller.selectedVisitRadio.value = 1;
                  widget.controller.toggleSectorValue("Private");
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildEngagementTypeCard(
                title: "Financial Sector",
                subtitle: "Loans & services",
                icon: Icons.attach_money,
                isSelected: widget.controller.selectedVisitRadio.value == 2,
                onTap: () {
                  widget.controller.selectedVisitRadio.value = 2;
                  widget.controller.toggleSectorValue("Financial");
                },
              ),
            ),
          ],
        ),
      ],
    ));
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
        widget.controller.sector.value.toLowerCase() == "Private".toLowerCase()
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
            hintText: widget.controller.sector.value.toLowerCase() == "Private".toLowerCase()
                ? "Enter private sector name"
                : "Enter financial institution name",
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            suffixIcon: Icon(Icons.account_balance, color: Colors.grey[500]),
          ),
          controller: widget.controller.sector.value.toLowerCase() == "Private".toLowerCase()
              ? widget.controller.privateName
              : widget.controller.financialName,
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
            // Set initial date to current date or the existing date if available
            DateTime initialDate = DateTime.now();
            if (widget.controller.firstEngagement.value.isNotEmpty) {
              try {
                initialDate = DateTime.parse(widget.controller.firstEngagement.value);
              } catch (e) {
                debugPrint('Error parsing initial date: $e');
              }
            }

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
              currentTime: initialDate,
              onConfirm: (date) => widget.controller.setEngagementDate(date),
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
                    widget.controller.firstEngagement.value.isNotEmpty
                        ? widget.controller.visitDateYearInString.value
                        : "Select engagement date",
                    style: TextStyle(
                      color: widget.controller.firstEngagement.value.isNotEmpty ? Colors.grey[800] : Colors.grey[500],
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
        controller: widget.controller.partnershipType,
        icon: Icons.handshake,
      ),
      const SizedBox(height: 16),
      _buildTextFieldWithLabel(
        label: "Duration of Partnership",
        hint: "e.g., 2 years, Permanent",
        controller: widget.controller.partnershipDuration,
        icon: Icons.schedule,
      ),
      const SizedBox(height: 16),
      _buildTextFieldWithLabel(
        label: "MoU Signed?",
        hint: "Yes/No and details",
        controller: widget.controller.mouSigned,
        icon: Icons.description,
      ),
    ];
  }

  List<Widget> _buildFinancialSectorFields(BuildContext context) {
    return [
      _buildTextFieldWithLabel(
        label: "Type of Loan/Financial Service",
        hint: "e.g., Agricultural loan, Microcredit",
        controller: widget.controller.typeLoanService,
        icon: Icons.credit_card,
      ),
      const SizedBox(height: 16),
      Row(
        children: [
          Expanded(
            child: _buildTextFieldWithLabel(
              label: "Loan Duration (years)",
              hint: "e.g., 5",
              controller: widget.controller.loanDuration,
              icon: Icons.timelapse,
              keyboardType: TextInputType.number,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildTextFieldWithLabel(
              label: "Interest Rate (%)",
              hint: "e.g., 12.5",
              controller: widget.controller.loanInterest,
              icon: Icons.percent,
              keyboardType: TextInputType.number,
            ),
          ),
        ],
      ),
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
                controller: widget.controller.maleBenefitting,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildBeneficiaryField(
                label: "Female",
                controller: widget.controller.femaleBenefitting,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildBeneficiaryField(
                label: "Youth",
                controller: widget.controller.youthBenefitting,
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
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: "0",
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
            validator: (input) => input!.trim().isEmpty ? 'Enter number' : null,
          ),
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
                widget.controller.saveLocally();
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
              await widget.controller.attemptLMBUpload();
            },
          ),
        ),
      ],
    );
  }

  void _showSubmissionDialog() {
    if (!widget.controller.formKey.currentState!.validate()) {
      return;
    }

    showDialog(
      context: widget.controller.lmbScreenContext!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Submission"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Choose how you want to submit the data:"),
              const SizedBox(height: 20),
              Row(
                children: [
                  // Save Offline button
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.save_alt, size: 20),
                        label: const Text('Update Offline'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          widget.controller.saveLocally();
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
                      onPressed: () {
                        widget.controller.attemptLMBUpload();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }
}