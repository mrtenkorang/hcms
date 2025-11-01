import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/boilerplate/widgets.dart';
import 'package:hcms_revived2/screens/home/components/options.dart';
import 'package:hcms_revived2/screens/seedlingmonitoring/seedling_monitoring.dart';
import 'package:hcms_revived2/screens/home/components/middlesectiontitle.dart';
import 'package:hcms_revived2/screens/home/index.dart';
import 'package:hcms_revived2/screens/treemonitoring/alternativeLivelihood/history/alternative_livelihood_history.dart';
import 'package:hcms_revived2/screens/treemonitoring/lmbMonitoring/history/history_private_sector_history.dart';
import 'package:hcms_revived2/screens/treemonitoring/lmbMonitoring/lmbmonitoring.dart';
import 'package:hcms_revived2/screens/treemonitoring/lmbMonitoring/private_sector_engagement_screen.dart';
import 'package:hcms_revived2/screens/seedlingmonitoring/history/seedling_monitoring_history.dart';
import 'package:hcms_revived2/screens/treemonitoring/trainingLog/history/training_log_history_screen.dart';
import 'package:hcms_revived2/screens/treemonitoring/trainingLog/trailing_log.dart';
import 'package:hcms_revived2/screens/treemonitoring/view/viewmonitored.dart' show ViewMonitoredTrees;

import 'alternativeLivelihood/alternative_livelihood.dart';

class TreeMonitoringDecider extends StatefulWidget {
  const TreeMonitoringDecider({super.key});

  @override
  _TreeMonitoringDeciderState createState() => _TreeMonitoringDeciderState();
}

class _TreeMonitoringDeciderState extends State<TreeMonitoringDecider>
    with SingleTickerProviderStateMixin {
  late final List<MonitoringOption> _monitoringOptions;
  late final AnimationController _animationController;
  late final Animation<double> _fadeIn;
  late final Animation<double> _scaleIn;
  late final Animation<Offset> _slideIn;

  @override
  void initState() {
    super.initState();
    _initializeMonitoringOptions();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeIn = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );

    _scaleIn = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
      ),
    );

    _slideIn = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _initializeMonitoringOptions() {
    _monitoringOptions = [
      MonitoringOption(
        title: "Seedlings Monitoring",
        description: "Provide monitoring data for tree seedlings",
        icon: Icons.eco,
        color: Colors.green,
        gradient: [Colors.green[400]!, Colors.green[600]!],
        createRoute: () => SeedlingMonitoringScreen(),
        historyRoute: () => SeedlingMonitoringViewInit(),
      ),
      MonitoringOption(
        title: "Private Sector Engagement",
        description: "Monitoring private sector engagement",
        icon: Icons.business_center,
        color: Colors.blue,
        gradient: [Colors.blue[400]!, Colors.blue[600]!],
        createRoute: () => const PrivateSectorEngagementScreen(),
        historyRoute: () => HistoryPrivateSectorHistory(),
      ),
      MonitoringOption(
        title: "Alternative Livelihood",
        description: "Provide monitoring data for alternative livelihood",
        icon: Icons.work_outline,
        color: Colors.orange,
        gradient: [Colors.orange[400]!, Colors.orange[600]!],
        createRoute: () => const AlternativeLivelihoodScreen(),
        historyRoute: () => AlternativeLivelihoodHistory(),
      ),
      MonitoringOption(
        title: "Training Log",
        description: "Provide monitoring data for training log",
        icon: Icons.school_outlined,
        color: Colors.purple,
        gradient: [Colors.purple[400]!, Colors.purple[600]!],
        createRoute: () => const TrainingLogScreen(),
        historyRoute: () => const TrainingLogHistoryScreen(),
      ),
    ];
  }

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
    return DraggableScrollableSheet(
      initialChildSize: 0.38,
      minChildSize: 0.2,
      maxChildSize: 0.9,
      builder: (context, controller) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: ListView(
            controller: controller,
            children: [
              // Drag handle
              Center(
                child: Container(
                  height: 5,
                  width: 40,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              // Header with gradient background
              // Container(
              //   padding: const EdgeInsets.all(16),
              //   // decoration: BoxDecoration(
              //   //   gradient: LinearGradient(
              //   //     begin: Alignment.topLeft,
              //   //     end: Alignment.bottomRight,
              //   //     colors: option.gradient,
              //   //   ),
              //   //   borderRadius: BorderRadius.circular(16),
              //   // ),
              //   child: Row(
              //     children: [
              //       CircleAvatar(
              //         radius: 24,
              //         backgroundColor: Colors.white.withOpacity(0.2),
              //         child: Icon(option.icon, size: 26, color: Colors.white),
              //       ),
              //       const SizedBox(width: 12),
              //       Expanded(
              //         child: Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             Text(
              //               option.title,
              //               style: const TextStyle(
              //                 color: Colors.white,
              //                 fontSize: 18,
              //                 fontWeight: FontWeight.w700,
              //               ),
              //             ),
              //             const SizedBox(height: 4),
              //             Text(
              //               option.description,
              //               style: TextStyle(
              //                 color: Colors.white.withOpacity(0.9),
              //                 fontSize: 14,
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              //
              // const SizedBox(height: 20),

              // Big CTA: Create New
              _ActionTile(
                icon: Icons.add_circle_outlined,
                title: 'Create New Entry',
                subtitle: 'Start a new monitoring record',
                color: option.color,
                gradient: option.gradient,
                onTap: () {
                  Navigator.pop(context);
                  _navigateTo(option.createRoute());
                },
              ),

              const SizedBox(height: 12),

              // Secondary: View History
              _ActionTile(
                icon: Icons.history_toggle_off,
                title: 'View History',
                subtitle: 'Browse previous monitoring data',
                color: Colors.blueGrey,
                gradient: [Colors.blueGrey[400]!, Colors.blueGrey[600]!],
                onTap: () {
                  Navigator.pop(context);
                  _navigateTo(option.historyRoute());
                },
              ),

              // const SizedBox(height: 20),
              //
              // // Help section
              // Container(
              //   padding: const EdgeInsets.all(16),
              //   decoration: BoxDecoration(
              //     color: Colors.grey[50],
              //     borderRadius: BorderRadius.circular(12),
              //     border: Border.all(color: Colors.grey[200]!),
              //   ),
              //   child: Row(
              //     children: [
              //       Icon(Icons.help_outline, color: option.color, size: 20),
              //       const SizedBox(width: 12),
              //       Expanded(
              //         child: Text(
              //           'Need help choosing? Tap "Create New" to start monitoring or "View History" to review past records.',
              //           style: TextStyle(
              //             color: Colors.grey[700],
              //             fontSize: 13,
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),

              const SizedBox(height: 16),

              // Cancel button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Cancel'),
                ),
              ),

              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: SafeArea(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeIn,
                child: ScaleTransition(
                  scale: _scaleIn,
                  child: child,
                ),
              );
            },
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: mq.size.height - mq.padding.vertical,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 24),

                    // Header Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [fPrimaryColour, fPrimaryColour.withOpacity(0.8)],
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Icon(Icons.monitor_heart, color: Colors.white, size: 28),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Monitoring Dashboard',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.grey[800],
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Choose your monitoring activity',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                tooltip: 'Back to Home',
                                onPressed: () => _onBackPressed(),
                                icon: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.close, color: Colors.grey[600], size: 20),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 4,
                            width: 60,
                            decoration: BoxDecoration(
                              color: fPrimaryColour,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Monitoring Options Grid
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        children: [
                          Wrap(
                            spacing: 16,
                            runSpacing: 16,
                            children: _monitoringOptions
                                .map((opt) => SlideTransition(
                              position: _slideIn,
                              child: _MonitoringOptionCard(
                                option: opt,
                                onPressed: () => _showActionBottomSheet(opt),
                              ),
                            ))
                                .toList(),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    //   child: Column(
                    //     children: [
                    //       // Section label
                    //       Padding(
                    //         padding: const EdgeInsets.only(bottom: 16.0),
                    //         child: Row(
                    //           children: [
                    //             Container(
                    //               height: 16,
                    //               width: 4,
                    //               decoration: BoxDecoration(
                    //                 color: Colors.grey[400],
                    //                 borderRadius: BorderRadius.circular(2),
                    //               ),
                    //             ),
                    //             const SizedBox(width: 8),
                    //             Text(
                    //               'DATA MANAGEMENT',
                    //               style: TextStyle(
                    //                 fontSize: 12,
                    //                 fontWeight: FontWeight.w600,
                    //                 color: Colors.grey[500],
                    //                 letterSpacing: 1.2,
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //
                    //       // View All Button with enhanced visual design
                    //       Container(
                    //         width: double.infinity,
                    //         decoration: BoxDecoration(
                    //           gradient: LinearGradient(
                    //             begin: Alignment.topLeft,
                    //             end: Alignment.bottomRight,
                    //             colors: [Colors.grey[800]!, Colors.grey[900]!],
                    //           ),
                    //           borderRadius: BorderRadius.circular(16),
                    //           boxShadow: [
                    //             BoxShadow(
                    //               color: Colors.black.withOpacity(0.2),
                    //               blurRadius: 12,
                    //               offset: const Offset(0, 4),
                    //             ),
                    //           ],
                    //         ),
                    //         child: Material(
                    //           color: Colors.transparent,
                    //           borderRadius: BorderRadius.circular(16),
                    //           child: InkWell(
                    //             borderRadius: BorderRadius.circular(16),
                    //             onTap: _navigateToViewMonitored,
                    //             child: Container(
                    //               padding: const EdgeInsets.all(20),
                    //               child: Row(
                    //                 children: [
                    //                   Container(
                    //                     padding: const EdgeInsets.all(12),
                    //                     decoration: BoxDecoration(
                    //                       color: Colors.white.withOpacity(0.1),
                    //                       shape: BoxShape.circle,
                    //                     ),
                    //                     child: const Icon(Icons.analytics_outlined, color: Colors.white, size: 24),
                    //                   ),
                    //                   const SizedBox(width: 16),
                    //                   Expanded(
                    //                     child: Column(
                    //                       crossAxisAlignment: CrossAxisAlignment.start,
                    //                       children: [
                    //                         Text(
                    //                           'View All Monitoring Data',
                    //                           style: const TextStyle(
                    //                             color: Colors.white,
                    //                             fontSize: 18,
                    //                             fontWeight: FontWeight.w700,
                    //                           ),
                    //                         ),
                    //                         const SizedBox(height: 4),
                    //                         Text(
                    //                           'Access comprehensive monitoring records and analytics',
                    //                           style: TextStyle(
                    //                             color: Colors.white.withOpacity(0.8),
                    //                             fontSize: 13,
                    //                           ),
                    //                         ),
                    //                       ],
                    //                     ),
                    //                   ),
                    //                   Container(
                    //                     padding: const EdgeInsets.all(8),
                    //                     decoration: BoxDecoration(
                    //                       color: Colors.white.withOpacity(0.2),
                    //                       shape: BoxShape.circle,
                    //                     ),
                    //                     child: const Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                    //                   ),
                    //                 ],
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Enhanced Monitoring Option Card with gradient design
class _MonitoringOptionCard extends StatelessWidget {
  final MonitoringOption option;
  final VoidCallback onPressed;

  const _MonitoringOptionCard({required this.option, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width - 64) / 2,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onPressed,
          child: Container(
            height: 160,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: option.color.withOpacity(0.1),
              border: Border.all(color: option.color.withOpacity(0.6)),
              // gradient: LinearGradient(
              //   begin: Alignment.topLeft,
              //   end: Alignment.bottomRight,
              //   colors: option.gradient,
              // ),
              borderRadius: BorderRadius.circular(20),
              // boxShadow: [
              //   BoxShadow(
              //     color: option.color.withOpacity(0.3),
              //     blurRadius: 12,
              //     offset: const Offset(0, 4),
              //   ),
              // ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    // color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(option.icon, size: 24),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      option.title,
                      style: const TextStyle(
                        // color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      option.description,
                      style: TextStyle(
                        // color: Colors.white.withOpacity(0.9),
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Enhanced Action Tile for bottom sheet
class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final List<Color> gradient;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: color.withOpacity(0.2)),
            // gradient: LinearGradient(
            //   begin: Alignment.centerLeft,
            //   end: Alignment.centerRight,
            //   colors: gradient,
            // ),
            borderRadius: BorderRadius.circular(16),
            // boxShadow: [
            //   BoxShadow(
            //     color: color.withOpacity(0.3),
            //     blurRadius: 8,
            //     offset: const Offset(0, 2),
            //   ),
            // ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        // color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        // color: Colors.white.withOpacity(0.9),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_forward, color: Colors.white, size: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Enhanced MonitoringOption class with color and gradient support
class MonitoringOption {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final List<Color> gradient;
  final Widget Function() createRoute;
  final Widget Function() historyRoute;

  MonitoringOption({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.gradient,
    required this.createRoute,
    required this.historyRoute,
  });
}