import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/boilerplate/widgets.dart';
import 'package:hcms_revived2/screens/home/components/options.dart';
import 'package:hcms_revived2/screens/seedlingmonitoring/combined_seedling_monitoring.dart';
import 'package:hcms_revived2/screens/seedlingmonitoring/ssr_firstpage.dart';
import 'package:hcms_revived2/screens/home/components/middlesectiontitle.dart';
import 'package:hcms_revived2/screens/home/index.dart';
import 'package:hcms_revived2/screens/treemonitoring/alternativeLivelihood/beforeFirst.dart';
import 'package:hcms_revived2/screens/treemonitoring/lmbMonitoring/lmbmonitoring.dart';
import 'package:hcms_revived2/screens/treemonitoring/trainingLog/eventDetails.dart';
import 'package:hcms_revived2/screens/treemonitoring/view/viewmonitored.dart';

class TreeMonitoringDecider extends StatefulWidget {
  const TreeMonitoringDecider({super.key});

  @override
  _TreeMonitoringDeciderState createState() => _TreeMonitoringDeciderState();
}

class _TreeMonitoringDeciderState extends State<TreeMonitoringDecider> {
  // Pre-computed navigation methods for better performance
  late final List<MonitoringOption> _monitoringOptions;

  @override
  void initState() {
    super.initState();
    _initializeMonitoringOptions();
  }

  void _initializeMonitoringOptions() {
    _monitoringOptions = [
      MonitoringOption(
        title: "Seedlings Monitoring",
        description: "Provide monitoring data for tree seedlings",
        icon: Icons.eco,
        createRoute: () => SeedlingMonitoringScreen(),
        historyRoute: (){
          return Container();
        },
        // historyRoute: () => const ViewMonitoredTrees(filter: 'seedlings'),
      ),
      MonitoringOption(
        title: "Private Sector Engagement",
        description: "Monitoring private sector engagement",
        icon: Icons.business,
        createRoute: () => const LmbMonitoring(),
        historyRoute: (){
          return Container();
        },
        // historyRoute: () => const ViewMonitoredTrees(filter: 'private_sector'),
      ),
      MonitoringOption(
        title: "Alternative Livelihood",
        description: "Provide monitoring data for alternative livelihood",
        icon: Icons.work,
        createRoute: () => const AlternativeLivingBeforeFirst(),
        historyRoute: (){
          return Container();
        },
        // historyRoute: () => const ViewMonitoredTrees(filter: 'alternative_livelihood'),
      ),
      MonitoringOption(
        title: "Training Log",
        description: "Provide monitoring data for training log",
        icon: Icons.school,
        createRoute: () => const TrainingLog(),
        historyRoute: (){
          return Container();
        },
        // historyRoute: () => const ViewMonitoredTrees(filter: 'training_log'),
      ),
    ];
  }

  // Optimized navigation
  Future<bool> _onBackPressed() {
    return Navigator.of(context)
        .pushAndRemoveUntil(
      CupertinoPageRoute(builder: (c) => const IndexPage()),
          (route) => false,
    )
        .then((value) => value ?? false);
  }

  void _navigateTo(Widget route) {
    Navigator.of(context).push(CupertinoPageRoute(builder: (context) => route));
  }

  void _showActionBottomSheet(MonitoringOption option) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildBottomSheetContent(option),
    );
  }

  Widget _buildBottomSheetContent(MonitoringOption option) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: fPrimaryColour.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Icon(option.icon, size: 40, color: fPrimaryColour),
                const SizedBox(height: 8),
                Text(
                  option.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  option.description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Action Buttons
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildActionButton(
                  icon: Icons.add_circle_outline,
                  title: "Create New",
                  subtitle: "Start a new monitoring entry",
                  color: fPrimaryColour,
                  onTap: () {
                    Navigator.pop(context);
                    _navigateTo(option.createRoute());
                  },
                ),
                const SizedBox(height: 16),
                _buildActionButton(
                  icon: Icons.history,
                  title: "View History",
                  subtitle: "See previous monitoring data",
                  color: Colors.blueGrey,
                  onTap: () {
                    Navigator.pop(context);
                    _navigateTo(option.historyRoute());
                  },
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      borderRadius: BorderRadius.circular(12),
      color: color.withOpacity(0.1),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
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
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: color,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToViewMonitored() {
    _navigateTo(const ViewMonitoredTrees());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        body: Center(
          child: SafeArea(
            child: _buildContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height * .9,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // const SizedBox(height: 20),
            const MiddleSectionTitle(text: "Select monitoring option"),
            _buildMonitoringOptions(),
            const SizedBox(height: 30),
            _buildViewMonitoredSection(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMonitoringOptions() {
    return Column(
      children: [
        for (int i = 0; i < _monitoringOptions.length; i++) ...[
          _buildOptionCard(_monitoringOptions[i]),
          if (i < _monitoringOptions.length - 1) const SizedBox(height: 5.0),
        ],
      ],
    );
  }

  Widget _buildOptionCard(MonitoringOption option) {
    return OptionsCard(
      icon: Icon(option.icon, color: Colors.redAccent, size: 26),
      title: option.title,
      description: option.description,
      pressHandler: () => _showActionBottomSheet(option),
    );
  }

  Widget _buildViewMonitoredSection() {
    return Column(
      children: [
        const MiddleSectionTitle(text: "View monitored data"),
        const SizedBox(height: 10),
        OptionsCard(
          color: fPrimaryColour,
          titleColor: const Color(0xFFffffff),
          descriptionColor: const Color(0xFFffffff),
          icon: const Icon(Icons.view_list, color: Color(0xFFffffff), size: 26),
          title: "View All Monitoring Data",
          description: "Click to view all monitored trees and activities",
          pressHandler: _navigateToViewMonitored,
        ),
      ],
    );
  }
}

// Enhanced helper class for monitoring options
class MonitoringOption {
  final String title;
  final String description;
  final IconData icon;
  final Widget Function() createRoute;
  final Widget Function() historyRoute;

  MonitoringOption({
    required this.title,
    required this.description,
    required this.icon,
    required this.createRoute,
    required this.historyRoute,
  });
}