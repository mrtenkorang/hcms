// widgets/species_expansion_tile.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/utils/constants/colours.dart';
import 'package:hcms_revived2/utils/widgets/textFields/custom_textfield.dart' show CustomFormField;


class SpeciesExpansionTile extends StatefulWidget {
  final String species;
  final TextEditingController quantityReceivedController;
  final TextEditingController quantityPlantedController;
  final Function(DateTime) onDateSelected;
  final String? plantingDate;

  const SpeciesExpansionTile({
    super.key,
    required this.species,
    required this.quantityReceivedController,
    required this.quantityPlantedController,
    required this.onDateSelected,
    this.plantingDate,
  });

  @override
  State<SpeciesExpansionTile> createState() => _SpeciesExpansionTileState();
}

class _SpeciesExpansionTileState extends State<SpeciesExpansionTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _isExpanded ? fPrimaryColour : Colors.grey[200]!,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ExpansionTile(
        key: Key(widget.species),
        onExpansionChanged: (expanded) {
          setState(() {
            _isExpanded = expanded;
          });
        },
        leading: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: fPrimaryColour.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.eco,
            color: fPrimaryColour,
            size: 18,
          ),
        ),
        title: Text(
          widget.species.replaceAll('_', ' '),
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: _isExpanded ? fPrimaryColour : Colors.black87,
            fontSize: 16,
          ),
        ),
        trailing: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: _isExpanded ? fPrimaryColour : Colors.grey[300],
            shape: BoxShape.circle,
          ),
          child: Icon(
            _isExpanded ? Icons.expand_less : Icons.expand_more,
            color: Colors.white,
            size: 16,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                CustomFormField(
                  controller: widget.quantityReceivedController,
                  label: 'Quantity Received',
                  hintText: 'Enter quantity received',
                  keyboardType: TextInputType.number,
                  prefixIcon: Icons.inventory_2,
                  isRequired: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter quantity received';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomFormField(
                  controller: widget.quantityPlantedController,
                  label: 'Quantity Planted',
                  hintText: 'Enter quantity planted',
                  keyboardType: TextInputType.number,
                  prefixIcon: Icons.agriculture,
                  isRequired: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter quantity planted';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildDateField(),
              ],
            ),
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
          'Date of Planting',
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
              context,
              showTitleActions: true,
              minTime: DateTime(2000, 1, 1),
              maxTime: DateTime.now(),
              onConfirm: (date) {
                widget.onDateSelected(date);
                setState(() {});
              },
              theme: const DatePickerTheme(
                backgroundColor: Colors.white,
                itemStyle: TextStyle(color: Colors.black87, fontSize: 18),
                doneStyle: TextStyle(color: fPrimaryColour, fontSize: 16),
                cancelStyle: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            );
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 20,
                  color: widget.plantingDate != null
                      ? fPrimaryColour
                      : Colors.grey[400],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.plantingDate != null
                        ? _formatDate(widget.plantingDate!)
                        : 'Select planting date',
                    style: TextStyle(
                      color: widget.plantingDate != null
                          ? Colors.black87
                          : Colors.grey[500],
                      fontSize: 14,
                    ),
                  ),
                ),
                if (widget.plantingDate != null)
                  Icon(
                    Icons.check_circle,
                    color: fPrimaryColour,
                    size: 20,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(String dateString) {
    try {
      final parts = dateString.split('-');
      if (parts.length == 3) {
        final year = parts[0];
        final month = parts[1];
        final day = parts[2];
        return '$day/$month/$year';
      }
      return dateString;
    } catch (e) {
      return dateString;
    }
  }
}