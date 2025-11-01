import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/controller/models/training_log_model.dart';
import 'package:hcms_revived2/screens/treemonitoring/trainingLog/history/edit/edit_training_log_screen.dart';
import 'package:hcms_revived2/screens/treemonitoring/trainingLog/history/training_log_history_screen_controller.dart';

class TrainingLogHistoryScreen extends StatefulWidget {
  const TrainingLogHistoryScreen({super.key});

  @override
  State<TrainingLogHistoryScreen> createState() =>
      _TrainingLogHistoryScreenState();
}

class _TrainingLogHistoryScreenState extends State<TrainingLogHistoryScreen> {
  final controller = Get.put(TrainingLogHistoryScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Training Log History',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: fPrimaryColour,
        foregroundColor: Colors.black,
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Container(
              color: Colors.white,
              child: TabBar(
                labelColor: fPrimaryColour,
                unselectedLabelColor: Colors.grey,
                indicatorColor: fPrimaryColour,
                indicatorWeight: 3,
                tabs: const [
                  Tab(text: 'Submitted'),
                  Tab(text: 'Pending'),
                ],
                onTap: (index) => controller.selectedTabIndex.value = index,
              ),
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                final logs = controller.selectedTabIndex.value == 0
                    ? controller.syncedLogs
                    : controller.pendingLogs;

                if (logs.isEmpty) {
                  return Center(
                    child: Text(
                      controller.selectedTabIndex.value == 0
                          ? 'No submitted training logs found'
                          : 'No pending training logs',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: controller.loadTrainingLogs,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: logs.length,
                    itemBuilder: (context, index) {
                      final log = logs[index];
                      return _buildLogCard(context, log);
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogCard(BuildContext context, TrainingLogModel log) {
    return InkWell(
      onTap: () {
        Get.to(() => EditTrainingLogHistoryScreen(trainingLog: log,));
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: log.isSynced
                ? Colors.green.withOpacity(0.3)
                : Colors.orange.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      log.trainingTopic,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          // Confirm delete
                          Get.defaultDialog(
                            title: "Delete Training Log",
                            middleText:
                                "Are you sure you want to delete this training log?",
                            confirm: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () {
                                controller.deleteLog(log);
                                setState(() {});
                                Get.back();
                              },
                              child: const Text("Delete"),
                            ),
                            cancel: ElevatedButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: const Text("Cancel"),
                            ),
                          );
                        },
                        child: const Icon(Icons.delete, color: Colors.red),
                      ),
                      SizedBox(width: 15),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: log.isSynced
                              ? Colors.green[50]
                              : Colors.orange[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: log.isSynced ? Colors.green : Colors.orange,
                            width: 0.5,
                          ),
                        ),
                        child: Text(
                          log.isSynced ? 'Submitted' : 'Pending',
                          style: TextStyle(
                            color: log.isSynced
                                ? Colors.green[800]
                                : Colors.orange[800],
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildInfoRow(Icons.calendar_today, 'Date', log.eventDate),
              _buildInfoRow(Icons.access_time, 'Duration', log.eventDuration),
              _buildInfoRow(Icons.location_on, 'Community', log.communityName),
              _buildInfoRow(Icons.person, 'Trainer', log.trainerName),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black87, fontSize: 14),
                children: [
                  TextSpan(
                    text: '$label: ',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  TextSpan(
                    text: value ?? 'N/A',
                    style: const TextStyle(fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
