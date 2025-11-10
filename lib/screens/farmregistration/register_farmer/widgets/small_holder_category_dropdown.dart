// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:hcms_revived2/screens/farmregistration/register_farmer/register_farmer_controller.dart';
//
// class SmallHolderCategoryDropdown extends StatelessWidget {
//   final FarmerBiodataController controller;
//
//   const SmallHolderCategoryDropdown({
//     Key? key,
//     required this.controller,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return _buildDropdown(
//       label: 'Small Holder Category',
//       value: controller.farmer.value.smallHolderCategory,
//       items: controller.smallHolderCategories,
//       onChanged: controller.updateSmallHolderCategory,
//     );
//   }
//
//   Widget _buildDropdown({
//     required String label,
//     required String? value,
//     required List<String> items,
//     required Function(String?) onChanged,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         const SizedBox(height: 8),
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 12),
//           decoration: BoxDecoration(
//             border: Border.all(color: Colors.grey.shade300),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: DropdownButtonHideUnderline(
//             child: DropdownButton<String>(
//               value: value,
//               isExpanded: true,
//               icon: const Icon(Icons.arrow_drop_down),
//               iconSize: 24,
//               elevation: 16,
//               style: const TextStyle(color: Colors.black87, fontSize: 16),
//               onChanged: onChanged,
//               items: items.map<DropdownMenuItem<String>>((String value) {
//                 return DropdownMenuItem<String>(
//                   value: value,
//                   child: Text(value),
//                 );
//               }).toList(),
//             ),
//           ),
//         ),
//         const SizedBox(height: 16),
//       ],
//     );
//   }
// }
