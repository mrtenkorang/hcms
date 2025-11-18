import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hcms_revived2/controller/api/init_methods/init_methods.dart';
import 'package:hcms_revived2/screens/home/index.dart';
import '../version/version_check_screen.dart';

class SyncPage extends StatefulWidget {
  const SyncPage({super.key});

  @override
  _SyncPageState createState() => _SyncPageState();
}

class _SyncPageState extends State<SyncPage> with SingleTickerProviderStateMixin {
  int _currentStep = 0;
  bool _isSyncing = false;
  int _retryCount = 0;
  final Set<int> _failedSteps = {};
  final Map<int, String> _syncStatusMessages = {};
  late AnimationController _animationController;
  bool _versionCheckComplete = false;

  final List<SyncStep> _syncSteps = [
    SyncStep(
      title: "App Version",
      function: InitMethods().checkAppVersion,
      isVersionCheck: true,
      icon: Icons.phone_iphone,
    ),
    SyncStep(
      title: "Communities",
      function: InitMethods().fetchCommunities,
      icon: Icons.location_city,
    ),
    SyncStep(
      title: "Regions and Districts",
      function: InitMethods().fetchDistrictAndRegion,
      icon: Icons.location_city,
    ),
    SyncStep(
      title: "Stool Data",
      function: InitMethods().fetchTypes,
      icon: Icons.leaderboard,
    ),
    SyncStep(
      title: "Small Holder Category",
      function: InitMethods().fetchSmallHolderCategory,
      icon: Icons.leaderboard,
    ),
    SyncStep(
      title: "Tree Species Data",
      function: InitMethods().fetchTreeSpecies,
      icon: Icons.leaderboard,
    ),
    SyncStep(
      title: "Tree Species Data for Seedling",
      function: InitMethods().fetchTreeSpeciesSeedling,
      icon: Icons.leaderboard,
    ),
    SyncStep(
      title: "Farmers Data",
      function: InitMethods().fetAllFarmers,
      icon: Icons.people,
    ),
    SyncStep(
      title: "MMDA Data",
      function: InitMethods().fetchMMDA,
      icon: Icons.people,
    ),
    SyncStep(
      title: "Establishment Types",
      function: InitMethods().fetchEstaTypes,
      icon: Icons.people,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startSync();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _startSync({bool retryOnlyFailed = false}) async {
    setState(() {
      _isSyncing = true;
      if (!retryOnlyFailed) {
        _currentStep = 0;
        _failedSteps.clear();
        _syncStatusMessages.clear();
        _retryCount = 0;
        _versionCheckComplete = false;
      }
    });

    List<int> stepsToSync = retryOnlyFailed ? _failedSteps.toList() :
    List.generate(_syncSteps.length, (index) => index);
    stepsToSync.sort();

    for (int index in stepsToSync) {
      if (!mounted) return;

      final step = _syncSteps[index];
      setState(() {
        _currentStep = index;
        _syncStatusMessages[index] = "Starting...";
      });

      try {
        setState(() {
          _syncStatusMessages[index] = "Syncing...";
        });

        final result = await step.function();

        if (step.isVersionCheck) {
          await _handleVersionCheck(result, index);
          if (!_versionCheckComplete) return;
        } else {
          if (mounted) {
            setState(() {
              _syncStatusMessages[index] = "Success";
              _failedSteps.remove(index);
            });
          }
        }
      } catch (e, stackTrace) {
        debugPrint("Sync error: $e\nStack trace: $stackTrace");
        await _handleSyncError(e, index, step.title);
      }

      await Future.delayed(const Duration(milliseconds: 300));
    }

    await _completeSyncProcess();
  }

  Future<void> _handleVersionCheck(bool result, int index) async {
    debugPrint("Version check result: $result");

    if (result) {
      setState(() {
        _syncStatusMessages[index] = "Update required";
        _isSyncing = false;
        _versionCheckComplete = false;
      });
      Get.offAll(() => const VersionCheckScreen());
    } else {
      setState(() {
        _syncStatusMessages[index] = "Version check complete";
        _versionCheckComplete = true;
      });
    }
  }

  Future<void> _handleSyncError(dynamic error, int index, String stepTitle) async {
    String errorMessage = "Failed";
    if (error is String) {
      errorMessage = error;
    } else if (error.toString().isNotEmpty) {
      errorMessage = error.toString().split('\n').first;
    }

    if (mounted) {
      setState(() {
        _syncStatusMessages[index] = errorMessage;
        _failedSteps.add(index);
      });
    }
  }

  Future<void> _completeSyncProcess() async {
    if (!mounted) return;

    setState(() {
      _isSyncing = false;
    });

    if (_failedSteps.isEmpty) {
      _navigateToHome();
    } else if (_retryCount < 2) {
      _retryCount++;
    } else {
      _navigateToHome();
    }
  }

  void _navigateToHome() {
    if (mounted) {
      Get.offAll(() => const IndexPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.primaryColor,
                    theme.primaryColor.withOpacity(0.8),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.cloud_sync,
                        color: theme.colorScheme.onPrimary,
                        size: 32,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "Data Sync",
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          color: theme.colorScheme.onPrimary,
                        ),
                        onPressed: _navigateToHome,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: _syncSteps.isEmpty ? 0 : (_currentStep + 1) / _syncSteps.length,
                    backgroundColor: theme.colorScheme.onPrimary.withOpacity(0.3),
                    color: theme.colorScheme.onPrimary,
                    borderRadius: BorderRadius.circular(10),
                    minHeight: 6,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${((_currentStep + 1) / _syncSteps.length * 100).toStringAsFixed(0)}% Complete",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onPrimary.withOpacity(0.9),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // Sync Steps
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      "Syncing Your Data",
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Please wait while we update your information",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),

                    // Steps List
                    Expanded(
                      child: ListView.separated(
                        itemCount: _syncSteps.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final step = _syncSteps[index];
                          final isFailed = _failedSteps.contains(index);
                          final isSynced = _syncStatusMessages[index] == "Success";
                          final isSyncing = _syncStatusMessages[index] == "Syncing...";
                          final isCurrent = index == _currentStep && _isSyncing;
                          final isPending = _syncStatusMessages[index] == null ||
                              _syncStatusMessages[index] == "Starting...";

                          return _buildStepCard(
                            theme: theme,
                            step: step,
                            isFailed: isFailed,
                            isSynced: isSynced,
                            isSyncing: isSyncing,
                            isCurrent: isCurrent,
                            isPending: isPending,
                            statusMessage: _syncStatusMessages[index],
                          );
                        },
                      ),
                    ),

                    // Action Buttons
                    if (_failedSteps.isNotEmpty && _retryCount < 2 && !_isSyncing)
                      _buildRetrySection(theme),

                    if ((_failedSteps.isNotEmpty && _retryCount >= 2) ||
                        (_failedSteps.length == 1 && _failedSteps.contains(0)) && !_isSyncing)
                      _buildContinueButton(theme),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepCard({
    required ThemeData theme,
    required SyncStep step,
    required bool isFailed,
    required bool isSynced,
    required bool isSyncing,
    required bool isCurrent,
    required bool isPending,
    required String? statusMessage,
  }) {
    final isDark = theme.brightness == Brightness.dark;

    Color getStatusColor() {
      if (isFailed) return Colors.red;
      if (isSynced) return Colors.green;
      if (isCurrent) return theme.primaryColor;
      return theme.colorScheme.onSurface.withOpacity(0.3);
    }

    IconData getStatusIcon() {
      if (isFailed) return Icons.error_outline;
      if (isSynced) return Icons.check_circle;
      if (isCurrent) return Icons.autorenew;
      return Icons.schedule;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon Container
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: getStatusColor().withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              step.icon,
              color: getStatusColor(),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  statusMessage ?? "Waiting...",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isFailed
                        ? Colors.red
                        : theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),

          // Status Indicator
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: getStatusColor().withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: isCurrent && !isFailed
                  ? SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(getStatusColor()),
                ),
              )
                  : Icon(
                getStatusIcon(),
                color: getStatusColor(),
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRetrySection(ThemeData theme) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Text(
          "Some syncs failed. Would you like to retry?",
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _navigateToHome,
                style: OutlinedButton.styleFrom(
                  foregroundColor: theme.primaryColor,
                  side: BorderSide(color: theme.primaryColor),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Continue Anyway"),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () => _startSync(retryOnlyFailed: true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  foregroundColor: theme.colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.refresh, size: 20),
                    const SizedBox(width: 8),
                    Text("Retry (${2 - _retryCount} left)"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContinueButton(ThemeData theme) {
    return Column(
      children: [
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _navigateToHome,
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.primaryColor,
              foregroundColor: theme.colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Enter App",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward, size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class SyncStep {
  final String title;
  final Future<dynamic> Function() function;
  final bool isVersionCheck;
  final IconData icon;

  SyncStep({
    required this.title,
    required this.function,
    this.isVersionCheck = false,
    required this.icon,
  });
}