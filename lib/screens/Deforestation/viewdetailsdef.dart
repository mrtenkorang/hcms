// import 'dart:convert';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart' hide DatePickerTheme;
// import 'package:hcms_revived2/boilerplate/constants.dart';
// import 'package:hcms_revived2/boilerplate/widgets.dart';
// import 'package:hcms_revived2/providers/deforestationprovider.dart';
// import 'package:hcms_revived2/screens/home/index.dart';
// import 'package:provider/provider.dart';
//
// class ViewDeforestationReportDetails extends StatefulWidget {
//   static const routeName = '/view_def_report_details';
//   final Function()? notifyParent;
//
//   const ViewDeforestationReportDetails({Key? key, this.notifyParent})
//       : super(key: key);
//
//   @override
//   _DetailDisplayState createState() => _DetailDisplayState();
// }
//
// class _DetailDisplayState extends State<ViewDeforestationReportDetails> {
//   final _formKey = GlobalKey<FormState>();
//   bool _isImageExpanded = false;
//
//   Widget _buildDetailCard({
//     required String title,
//     required String value,
//     required IconData icon,
//     Color? iconColor,
//   }) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//         border: Border.all(
//           color: Colors.grey[100]!,
//           width: 1,
//         ),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             width: 40,
//             height: 40,
//             decoration: BoxDecoration(
//               color: (iconColor ?? fPrimaryColour).withOpacity(0.1),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Icon(
//               icon,
//               color: iconColor ?? fPrimaryColour,
//               size: 20,
//             ),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.grey[700],
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   value.isNotEmpty ? value : 'Not specified',
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.black87,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSectionHeader(String title, IconData icon) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: fPrimaryColour.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Icon(
//               icon,
//               color: fPrimaryColour,
//               size: 20,
//             ),
//           ),
//           const SizedBox(width: 12),
//           Text(
//             title,
//             style: const TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Colors.black87,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStatusIndicator(String status, String date) {
//     final isSent = status.toLowerCase().contains('connected');
//
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: isSent ? Colors.green[50] : Colors.orange[50],
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: isSent ? Colors.green[200]! : Colors.orange[200]!,
//         ),
//       ),
//       child: Row(
//         children: [
//           Icon(
//             isSent ? Icons.cloud_done : Icons.cloud_upload,
//             color: isSent ? Colors.green : Colors.orange,
//             size: 24,
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   isSent ? 'Report Submitted' : 'Pending Upload',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: isSent ? Colors.green[700] : Colors.orange[700],
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   'Created: $date',
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final id = ModalRoute.of(context)!.settings.arguments;
//     final selectedPlace = Provider.of<DeforestationProvider>(context, listen: false)
//         .findById(id.toString());
//
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(
//         foregroundColor: fPrimaryWhite,
//         backgroundColor: fPrimaryColour,
//         elevation: 0,
//         title: const Text(
//           "Report Details",
//           style: TextStyle(
//             color: fPrimaryWhite,
//             fontSize: 20,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: fPrimaryWhite),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         // actions: [
//         //   IconButton(
//         //     icon: const Icon(Icons.home, color: fPrimaryWhite),
//         //     onPressed: () => Navigator.of(context).pushAndRemoveUntil(
//         //       MaterialPageRoute(builder: (context) => const IndexPage()),
//         //           (route) => false,
//         //     ),
//         //     tooltip: "Go to Homepage",
//         //   ),
//         // ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             // Header Image Section
//             Container(
//               margin: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.1),
//                     blurRadius: 10,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(20),
//                 child: GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       _isImageExpanded = !_isImageExpanded;
//                     });
//                   },
//                   child: AnimatedContainer(
//                     duration: const Duration(milliseconds: 300),
//                     height: _isImageExpanded
//                         ? MediaQuery.of(context).size.height * 0.6
//                         : 200,
//                     width: double.infinity,
//                     child: Stack(
//                       children: [
//                         Image.memory(
//                           base64Decode(selectedPlace.image),
//                           fit: BoxFit.cover,
//                           width: double.infinity,
//                           height: double.infinity,
//                           errorBuilder: (context, error, stackTrace) {
//                             return Container(
//                               color: Colors.grey[200],
//                               child: const Center(
//                                 child: Icon(
//                                   Icons.photo_library,
//                                   color: Colors.grey,
//                                   size: 50,
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                         if (!_isImageExpanded)
//                           Positioned(
//                             bottom: 10,
//                             right: 10,
//                             child: Container(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 8,
//                                 vertical: 4,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: Colors.black.withOpacity(0.6),
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               child: const Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Icon(
//                                     Icons.zoom_in,
//                                     color: Colors.white,
//                                     size: 14,
//                                   ),
//                                   SizedBox(width: 4),
//                                   Text(
//                                     'Tap to expand',
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 12,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//
//             // Status Indicator
//             _buildStatusIndicator(selectedPlace.conStat, selectedPlace.timeDisplay),
//
//             // Report Details Section
//             _buildSectionHeader('Report Information', Icons.assignment),
//
//             _buildDetailCard(
//               title: 'Date of Report',
//               value: selectedPlace.timeDisplay,
//               icon: Icons.calendar_today,
//               iconColor: Colors.blue,
//             ),
//
//             _buildDetailCard(
//               title: 'Community',
//               value: selectedPlace.community,
//               icon: Icons.location_on,
//               iconColor: Colors.green,
//             ),
//
//             // GFW Information
//             _buildSectionHeader('GFW Information', Icons.map),
//
//             _buildDetailCard(
//               title: 'Directed by Global Forest Watch',
//               value: selectedPlace.gfwDirected,
//               icon: Icons.navigation,
//               iconColor: Colors.orange,
//             ),
//
//             // Deforestation Assessment
//             _buildSectionHeader('Deforestation Assessment', Icons.forest),
//
//             _buildDetailCard(
//               title: 'Deforestation Observed',
//               value: selectedPlace.seeDeforestation,
//               icon: Icons.visibility,
//               iconColor: Colors.purple,
//             ),
//
//             if (selectedPlace.seeDeforestation.toLowerCase() == 'yes')
//               _buildDetailCard(
//                 title: 'Causes of Deforestation',
//                 value: selectedPlace.deforestationCause
//                     .replaceAll("[", "")
//                     .replaceAll("]", "")
//                     .replaceAll(",", ", "),
//                 icon: Icons.warning_amber,
//                 iconColor: Colors.red,
//               ),
//
//             // Action Recommendations
//             _buildSectionHeader('Action Recommendations', Icons.recommend),
//
//             _buildDetailCard(
//               title: 'Further Action Required',
//               value: selectedPlace.takeAction,
//               icon: Icons.thumb_up,
//               iconColor: Colors.teal,
//             ),
//
//             if (selectedPlace.takeAction.toLowerCase() == 'yes' &&
//                 selectedPlace.actionReason.isNotEmpty)
//               _buildDetailCard(
//                 title: 'Reason for Action',
//                 value: selectedPlace.actionReason,
//                 icon: Icons.lightbulb_outline,
//                 iconColor: Colors.amber,
//               ),
//
//             // Location Information
//             _buildSectionHeader('Location Data', Icons.gps_fixed),
//
//             if (selectedPlace.latitude.isNotEmpty && selectedPlace.longitude.isNotEmpty)
//               Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.blue[50],
//                   borderRadius: BorderRadius.circular(16),
//                   border: Border.all(color: Colors.blue[200]!),
//                 ),
//                 child: Row(
//                   children: [
//                     Icon(
//                       Icons.gps_fixed,
//                       color: Colors.blue[700],
//                       size: 24,
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text(
//                             'GPS Coordinates',
//                             style: TextStyle(
//                               fontWeight: FontWeight.w600,
//                               color: Colors.black87,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             'Lat: ${selectedPlace.latitude}, Lng: ${selectedPlace.longitude}',
//                             style: TextStyle(
//                               color: Colors.grey[700],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//             // Empty space at bottom
//             const SizedBox(height: 40),
//           ],
//         ),
//       ),
//
//       // Floating Action Button for quick actions
//       // floatingActionButton: FloatingActionButton(
//       //   onPressed: () {
//       //     // Show action options
//       //     _showActionOptions(context, selectedPlace);
//       //   },
//       //   backgroundColor: fPrimaryColour,
//       //   child: const Icon(Icons.more_vert, color: Colors.white),
//       // ),
//     );
//   }
//
//   void _showActionOptions(BuildContext context, selectedPlace) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       builder: (context) {
//         return Container(
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(20),
//               topRight: Radius.circular(20),
//             ),
//           ),
//           child: SafeArea(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 // Drag handle
//                 Container(
//                   margin: const EdgeInsets.only(top: 12),
//                   width: 40,
//                   height: 4,
//                   decoration: BoxDecoration(
//                     color: Colors.grey[300],
//                     borderRadius: BorderRadius.circular(2),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 const Text(
//                   "Report Actions",
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//
//                 // // Action Options
//                 // _buildActionOption(
//                 //   icon: Icons.share,
//                 //   label: "Share Report",
//                 //   color: Colors.blue,
//                 //   onTap: () {
//                 //     Navigator.pop(context);
//                 //     _shareReport(selectedPlace);
//                 //   },
//                 // ),
//                 //
//                 // _buildActionOption(
//                 //   icon: Icons.print,
//                 //   label: "Print Report",
//                 //   color: Colors.purple,
//                 //   onTap: () {
//                 //     Navigator.pop(context);
//                 //     _printReport(selectedPlace);
//                 //   },
//                 // ),
//                 //
//                 // if (selectedPlace.conStat.toLowerCase().contains('not'))
//                 //   _buildActionOption(
//                 //     icon: Icons.cloud_upload,
//                 //     label: "Upload Now",
//                 //     color: Colors.green,
//                 //     onTap: () {
//                 //       Navigator.pop(context);
//                 //       _uploadReport(selectedPlace);
//                 //     },
//                 //   ),
//
//                 _buildActionOption(
//                   icon: Icons.close,
//                   label: "Close",
//                   color: Colors.grey,
//                   onTap: () => Navigator.pop(context),
//                 ),
//
//                 const SizedBox(height: 20),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildActionOption({
//     required IconData icon,
//     required String label,
//     required Color color,
//     required VoidCallback onTap,
//   }) {
//     return ListTile(
//       leading: Container(
//         padding: const EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           color: color.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Icon(icon, color: color),
//       ),
//       title: Text(
//         label,
//         style: const TextStyle(fontWeight: FontWeight.w500),
//       ),
//       trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
//       onTap: onTap,
//     );
//   }
//
//   // void _shareReport(selectedPlace) {
//   //   // Implement share functionality
//   //   overlayNotification('Share functionality coming soon', 'positive');
//   // }
//   //
//   // void _printReport(selectedPlace) {
//   //   // Implement print functionality
//   //   overlayNotification('Print functionality coming soon', 'positive');
//   // }
//
//   // void _uploadReport(selectedPlace) {
//   //   // Implement upload functionality
//   //   overlayNotification('Upload functionality coming soon', 'positive');
//   // }
// }