import 'package:flutter/material.dart';
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/screens/Deforestation/deforestation_report_controller.dart';


// Reusable widgets for the deforestation form
class BuildSectionCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;

  const BuildSectionCard({
    super.key,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class BuildSectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;

  const BuildSectionTitle({
    super.key,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            subtitle!,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ],
    );
  }
}

class BuildChoiceChips extends StatelessWidget {
  final String label;
  final List<Map<String, String>> options;
  final String? selectedValue;
  final Function(String) onSelected;

  const BuildChoiceChips({
    super.key,
    required this.label,
    required this.options,
    required this.selectedValue,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: options.map((option) {
            final value = option['value']!;
            final displayText = option['label']!;
            final isSelected = selectedValue == value;

            return InkWell(
              onTap: () => onSelected(value),
              borderRadius: BorderRadius.circular(25),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? fPrimaryColour : Colors.grey[100],
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: isSelected ? fPrimaryColour : Colors.grey[300]!,
                    width: 2,
                  ),
                ),
                child: Text(
                  displayText,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class DeforestationCausesGrid extends StatelessWidget {
  final DeforestationController controller;

  const DeforestationCausesGrid({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final causes = [
      {
        'label': 'Bush Burning',
        'value': 'Bush_Burning',
        'icon': Icons.local_fire_department,
      },
      {
        'label': 'Mining',
        'value': 'Mining',
        'icon': Icons.landscape,
      },
      {
        'label': 'Logging',
        'value': 'Logging',
        'icon': Icons.park,
      },
      {
        'label': 'Farming',
        'value': 'Farming',
        'icon': Icons.agriculture,
      },
      {
        'label': 'Charcoal Production',
        'value': 'Charcoal',
        'icon': Icons.fireplace,
      },
      {
        'label': 'Other',
        'value': 'Other',
        'icon': Icons.more_horiz,
      },
    ];

    return Column(
      children: [
        ...causes.map((cause) {
          debugPrint("THE CAUSE :::::::::::: ${cause}");
          final isSelected = controller.isCauseSelected(cause['value'].toString());

          return Column(
            children: [
              BuildCauseChip(
                label: cause['label']!.toString(),
                isSelected: isSelected,
                onChanged: (value) => controller.toggleDeforestationCause(
                  cause['value']!.toString(),
                  value,
                ),
                icon: cause['icon'] as IconData,
              ),
              if (cause['value'] == 'Other' && isSelected) ...[
                const SizedBox(height: 16),
                TextField(
                  onChanged: controller.updateOtherCause,
                  decoration: InputDecoration(
                    hintText: "Please specify the cause",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 12),
            ],
          );
        }).toList(),
      ],
    );
  }
}

class BuildCauseChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Function(bool) onChanged;
  final IconData icon;

  const BuildCauseChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onChanged,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!isSelected),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.blue : Colors.grey[600],
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.blue : Colors.black87,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: Colors.blue, size: 24),
          ],
        ),
      ),
    );
  }
}