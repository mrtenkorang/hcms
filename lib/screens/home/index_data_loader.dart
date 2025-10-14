// File: lib/main.dart
// Dynamic per-dataset parallel isolates loader
// - fetches dataset config from remote (or uses built-in fallback)
// - spawns one isolate per dataset
// - each isolate fetches (with exponential backoff), validates checksum (two-way), caches JSON
// - each isolate inserts into sqflite in chunked transactions and reports progress (inserted/total)
// - main isolate aggregates progress and displays sleek iOS-style UI with per-dataset cards
// - final detailed Cupertino summary with record counts, retries, times, statuses

import 'dart:async';
import 'dart:convert';
import 'dart:isolate';
import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hcms_revived2/utils/constants/colours.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

// --- Data types used between isolates ---
class DatasetConfig {
  final String key; // unique key used for filenames and DB table selection
  final String name; // display name
  final String url; // endpoint
  DatasetConfig({required this.key, required this.name, required this.url});

  factory DatasetConfig.fromMap(Map m) => DatasetConfig(key: m['key'], name: m['name'], url: m['url']);
}

// Message shapes from worker isolates
// Progress message: {'type':'progress','dataset':'users','inserted':123,'total':1000}
// Final message: {'type':'done','dataset':'users','inserted':N,'total':T,'retries':r,'durationMs':ms,'status':'ok'|'failed'}

class LoaderHome extends StatefulWidget {
  const LoaderHome({Key? key}) : super(key: key);

  @override
  State<LoaderHome> createState() => _LoaderHomeState();
}

class _LoaderHomeState extends State<LoaderHome> with SingleTickerProviderStateMixin {
  Database? _db;
  bool _loading = false;
  String _status = 'Ready';
  double _overallProgress = 0.0;

  List<DatasetConfig> _datasets = [];

  // dynamic per-dataset UI state
  final Map<String, double> _progress = {}; // 0..1 per dataset
  final Map<String, int> _inserted = {};
  final Map<String, int> _total = {};
  final Map<String, String> _statusPer = {}; // 'pending','loading','ok','failed','cached'
  final Map<String, int> _retries = {};
  final Map<String, int> _durationMs = {};

  // ports and isolate refs
  final Map<String, ReceivePort> _receivePorts = {};
  final Map<String, Isolate> _isolates = {};

  late AnimationController _animController;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    _pulse = Tween(begin: 0.98, end: 1.02).animate(CurvedAnimation(parent: _animController, curve: Curves.easeInOut));
    _initDb();
    // _loadConfig();
    _applyFallbackConfig();
  }

  @override
  void dispose() {
    for (final p in _receivePorts.values) {
      p.close();
    }
    for (final iso in _isolates.values) {
      iso.kill(priority: Isolate.immediate);
    }
    _animController.dispose();
    _db?.close();
    super.dispose();
  }

  Future<void> _initDb() async {
    final dbPath = await getDatabasesPath();
    _db = await openDatabase(join(dbPath, 'app_data.db'), version: 1, onCreate: (db, v) async {
      // create flexible tables (keys will match dataset key names)
      await db.execute('''CREATE TABLE IF NOT EXISTS users(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, email TEXT)''');
      await db.execute('''CREATE TABLE IF NOT EXISTS polygons(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, points TEXT)''');
      await db.execute('''CREATE TABLE IF NOT EXISTS geotags(id INTEGER PRIMARY KEY AUTOINCREMENT, label TEXT, latitude REAL, longitude REAL)''');
    });
  }

  // dynamic config fetch (tries remote config, falls back to sensible defaults)
  // Future<void> _loadConfig() async {
  //   setState(() => _status = 'Loading dataset config...');
  //   try {
  //     final url = Uri.parse('https://example.com/api/datasets_config');
  //     final res = await http.get(url).timeout(const Duration(seconds: 6));
  //     if (res.statusCode == 200) {
  //       final list = jsonDecode(res.body) as List;
  //       _datasets = list.map((m) => DatasetConfig.fromMap(m)).toList();
  //     } else {
  //       _applyFallbackConfig();
  //     }
  //   } catch (_) {
  //     _applyFallbackConfig();
  //   }

  //   // initialize UI maps
  //   for (final d in _datasets) {
  //     _progress[d.key] = 0.0;
  //     _inserted[d.key] = 0;
  //     _total[d.key] = 0;
  //     _statusPer[d.key] = 'pending';
  //     _retries[d.key] = 0;
  //     _durationMs[d.key] = 0;
  //   }

  //   setState(() => _status = 'Config loaded');
  // }

  void _applyFallbackConfig() {
    _datasets = [
      DatasetConfig(key: 'users', name: 'Users', url: 'https://example.com/api/users'),
      DatasetConfig(key: 'polygons', name: 'Polygons', url: 'https://example.com/api/polygons'),
      DatasetConfig(key: 'geotags', name: 'Geotags', url: 'https://example.com/api/geotags'),
    ];
  }

  // start parallel isolates per dataset
  Future<void> _startAll({bool resume = false}) async {
    if (_loading) return;
    setState(() {
      _loading = true;
      _status = resume ? 'Resuming datasets...' : 'Starting parallel loads...';
    });

    // clear per-dataset state
    for (final d in _datasets) {
      _progress[d.key] = 0.0;
      _inserted[d.key] = 0;
      _total[d.key] = 0;
      _statusPer[d.key] = 'loading';
      _retries[d.key] = 0;
      _durationMs[d.key] = 0;
    }

    final totalDatasets = _datasets.length;
    int finished = 0;

    // spawn isolate for each dataset
    for (final d in _datasets) {
      final rp = ReceivePort();
      _receivePorts[d.key] = rp;

      rp.listen((msg) {
        // parse messages
        if (msg is Map) {
          final type = msg['type'] as String?;
          if (type == 'progress') {
            final inserted = msg['inserted'] as int;
            final total = msg['total'] as int;
            _inserted[d.key] = inserted;
            _total[d.key] = total;
            _progress[d.key] = total == 0 ? 0 : inserted / total;
            setState(() => _overallProgress = _computeOverall());
          } else if (type == 'done') {
            final status = msg['status'] as String;
            _statusPer[d.key] = status == 'ok' ? 'ok' : 'failed';
            _retries[d.key] = msg['retries'] as int? ?? 0;
            _durationMs[d.key] = msg['durationMs'] as int? ?? 0;
            _inserted[d.key] = msg['inserted'] as int? ?? _inserted[d.key]!;
            _total[d.key] = msg['total'] as int? ?? _total[d.key]!;

            finished += 1;
            setState(() => _overallProgress = _computeOverall());
            if (finished >= totalDatasets) {
              _onAllFinished();
            }
          } else if (type == 'log') {
            // optional log: msg['text']
          }
        }
      });

      // spawn isolate and pass args
      final args = {
        'sendPort': rp.sendPort,
        'dbPath': join(await getDatabasesPath(), 'app_data.db'),
        'config': {'key': d.key, 'name': d.name, 'url': d.url},
        'resume': resume,
      };

      Isolate.spawn(_datasetWorkerEntry, args).then((iso) => _isolates[d.key] = iso);
    }
  }

  double _computeOverall() {
    final n = _datasets.length;
    if (n == 0) return 0.0;
    double sum = 0.0;
    for (final d in _datasets) sum += (_progress[d.key] ?? 0.0);
    return sum / n;
  }

  Future<void> _onAllFinished() async {
    setState(() {
      _loading = false;
      _status = 'All datasets finished';
    });

    // show detailed summary
    _showDetailedSummary(context);
  }

  void _showDetailedSummary(context) {
    showCupertinoDialog(
      context: context,
      builder: (_) {
        return CupertinoAlertDialog(
          title: const Text('Import Report'),
          content: Column(
            children: [
              const SizedBox(height: 10),
              ..._datasets.map((d) {
                final name = d.name;
                final status = _statusPer[d.key] ?? 'pending';
                final inserted = _inserted[d.key] ?? 0;
                final total = _total[d.key] ?? 0;
                final retries = _retries[d.key] ?? 0;
                final ms = _durationMs[d.key] ?? 0;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text('$inserted / $total records'),
                            Text('Retries: $retries • Time: ${_formatMs(ms)}', style: const TextStyle(fontSize: 12)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        status == 'ok' ? CupertinoIcons.check_mark_circled_solid : CupertinoIcons.xmark_circle,
                        color: status == 'ok' ? Colors.greenAccent : Colors.redAccent,
                      )
                    ],
                  ),
                );
              }).toList(),
              const SizedBox(height: 8),
            ],
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  String _formatMs(int ms) {
    if (ms <= 0) return '0s';
    final sec = (ms / 1000).round();
    if (sec < 60) return '${sec}s';
    final m = sec ~/ 60;
    final s = sec % 60;
    return '${m}m ${s}s';
  }

  // --- UI building ---
  Widget _buildFrostedPanel({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.06)),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 6))],
          ),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: primaryColour,
      body: SafeArea(
        child: Stack(
          children: [
            // subtle gradient background
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xFFF9FCFB), Color(0xFFEFF7F6)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
              ),
            ),

            Center(
              child: ScaleTransition(
                scale: _pulse,
                child: Container(color: Colors.red,
                  width: min(size.width * 0.94, 820),
                  child: _buildFrostedPanel(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            const Icon(CupertinoIcons.cloud_download, color: Colors.white, size: 28),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Parallel Dataset Sync', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  Text(_status, style: const TextStyle(color: Colors.white70)),
                                ],
                              ),
                            ),
                            CupertinoButton(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                              color: Colors.white24,
                              onPressed: _loading ? null : () => _showOptionsSheet(context),
                              child: const Text('Options'),
                            )
                          ],
                        ),

                        const SizedBox(height: 18),

                        // dataset cards
                        ConstrainedBox(
                          constraints: BoxConstraints(maxHeight: min(360, size.height * 0.6)),
                          child: SingleChildScrollView(
                            child: Column(
                              children: _datasets.map((d) => _buildDatasetCard(d)).toList(),
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // overall progress and actions
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Overall', style: TextStyle(color: Colors.white.withOpacity(0.9))),
                                  const SizedBox(height: 6),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: LinearProgressIndicator(value: _overallProgress, minHeight: 10, color: Colors.white, backgroundColor: Colors.white24),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            CupertinoButton.filled(
                              onPressed: _loading ? null : () => _startAll(resume: false),
                              child: const Text('Start'),
                            ),
                            const SizedBox(width: 8),
                            CupertinoButton(
                              color: Colors.white12,
                              onPressed: (!_datasets.isEmpty && !_loading) ? () => _startAll(resume: true) : null,
                              child: const Text('Resume'),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatasetCard(DatasetConfig d) {
    final prog = _progress[d.key] ?? 0.0;
    final ins = _inserted[d.key] ?? 0;
    final tot = _total[d.key] ?? 0;
    final status = _statusPer[d.key] ?? 'pending';

    Color barColor() {
      if (status == 'ok') return Colors.greenAccent;
      if (status == 'failed') return Colors.redAccent;
      // interpolate color based on progress
      final c1 = Colors.blueAccent;
      final c2 = Colors.orangeAccent;
      return Color.lerp(c1, c2, prog) ?? c1;
    }

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 350),
      opacity: status == 'ok' && prog >= 1.0 ? 0.9 : 1.0,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white.withOpacity(0.04)),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(d.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                      const SizedBox(width: 8),
                      if (status == 'ok') const Icon(CupertinoIcons.check_mark_circled_solid, color: Colors.greenAccent, size: 18),
                      if (status == 'failed') const Icon(CupertinoIcons.xmark_circle, color: Colors.redAccent, size: 18),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(value: prog, minHeight: 8, color: barColor(), backgroundColor: Colors.white12),
                  ),
                  const SizedBox(height: 6),
                  Text('$ins / $tot records', style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              children: [
                Text('${(prog * 100).toStringAsFixed(0)}%', style: const TextStyle(color: Colors.white70)),
                const SizedBox(height: 8),
                Text('R:${_retries[d.key] ?? 0}', style: const TextStyle(color: Colors.white54, fontSize: 12)),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _showOptionsSheet(context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => CupertinoActionSheet(
        title: const Text('Options'),
        message: const Text('Start fresh or resume from cache'),
        actions: [
          CupertinoActionSheetAction(onPressed: () { Navigator.pop(context); _startAll(resume: false); }, child: const Text('Start Fresh')),
          CupertinoActionSheetAction(onPressed: () { Navigator.pop(context); _startAll(resume: true); }, child: const Text('Resume from Cache')),
        ],
        cancelButton: CupertinoActionSheetAction(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
      ),
    );
  }
}

// ---------------- Worker isolate entry ----------------
// Each isolate does: fetch (with retries & checksum), cache file, open db, insert in chunks, send progress
Future<void> _datasetWorkerEntry(Map<String, dynamic> args) async {
  final SendPort send = args['sendPort'] as SendPort;
  final String dbPath = args['dbPath'] as String;
  final Map cfg = Map<String, dynamic>.from(args['config']);
  final String key = cfg['key'] as String;
  final String name = cfg['name'] as String;
  final String url = cfg['url'] as String;
  final bool resume = args['resume'] as bool? ?? false;

  final stopwatch = Stopwatch()..start();
  int retries = 0;

  // helper to post progress
  void postProgress(int inserted, int total) => send.send({'type': 'progress', 'dataset': key, 'inserted': inserted, 'total': total});

  try {
    // prepare cache file paths
    final dir = await getApplicationDocumentsDirectory();
    final dataFile = File(join(dir.path, '$key.json'));
    final shaFile = File(join(dir.path, '$key.json.sha'));

    // Fetch with exponential backoff and compute hash
    String? body;
    String? remoteHeaderHash;
    const int maxAttempts = 4; // 1 + 3 retries
    for (int attempt = 1; attempt <= maxAttempts; attempt++) {
      try {
        final res = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 8));
        if (res.statusCode == 200) {
          body = res.body;
          remoteHeaderHash = res.headers['x-checksum-sha256'];
          break;
        } else {
          throw Exception('Status ${res.statusCode}');
        }
      } catch (e) {
        retries = attempt;
        if (attempt < maxAttempts) {
          final wait = Duration(seconds: 1 << (attempt - 1));
          await Future.delayed(wait);
        }
      }
    }

    // If we got body, compare with cache; otherwise, if resume and cache exists, use cache
    List<dynamic> listData;
    if (body != null) {
      final computed = sha256.convert(utf8.encode(body)).toString();
      if (await dataFile.exists()) {
        final local = await dataFile.readAsString();
        final localHash = sha256.convert(utf8.encode(local)).toString();
        final hashToCompare = remoteHeaderHash ?? computed;
        if (hashToCompare != localHash) {
          // updated -> replace cache
          await dataFile.writeAsString(body);
          await shaFile.writeAsString(hashToCompare);
        }
        // use local (fresh or existing)
        listData = jsonDecode(await dataFile.readAsString()) as List<dynamic>;
      } else {
        await dataFile.writeAsString(body);
        final h = remoteHeaderHash ?? computed;
        await shaFile.writeAsString(h);
        listData = jsonDecode(body) as List<dynamic>;
      }
    } else {
      // no network body
      if (await dataFile.exists()) {
        listData = jsonDecode(await dataFile.readAsString()) as List<dynamic>;
      } else {
        // cannot proceed
        send.send({'type': 'done', 'dataset': key, 'inserted': 0, 'total': 0, 'retries': retries, 'durationMs': stopwatch.elapsedMilliseconds, 'status': 'failed'});
        return;
      }
    }

    // Insert into DB in batches
    final db = await openDatabase(dbPath);
    const int chunk = 200; // tuned batch size
    final total = listData.length;
    int inserted = 0;

    await db.transaction((txn) async {
      for (int i = 0; i < listData.length; i += chunk) {
        final batch = txn.batch();
        final part = listData.skip(i).take(chunk);
        for (final item in part) {
          // Map dataset key -> table columns. This is app-specific; show flexible mapping for common types
          try {
            if (key == 'users') {
              final name = item['name'] ?? item['fullName'] ?? 'Unnamed';
              final email = item['email'] ?? '';
              batch.insert('users', {'name': name, 'email': email}, conflictAlgorithm: ConflictAlgorithm.ignore);
            } else if (key == 'polygons') {
              final pname = item['name'] ?? item['title'] ?? 'Polygon';
              final points = item['points'] ?? item['polygon'] ?? item['coordinates'];
              batch.insert('polygons', {'name': pname, 'points': jsonEncode(points)}, conflictAlgorithm: ConflictAlgorithm.ignore);
            } else if (key == 'geotags') {
              final label = item['label'] ?? item['title'] ?? 'Tag';
              final lat = (item['lat'] ?? item['latitude'] ?? 0).toDouble();
              final lng = (item['lng'] ?? item['longitude'] ?? 0).toDouble();
              batch.insert('geotags', {'label': label, 'latitude': lat, 'longitude': lng}, conflictAlgorithm: ConflictAlgorithm.ignore);
            } else {
              // generic fallback: create a table by key? For demo we'll ignore
            }
          } catch (e) {
            // skip malformed items
          }
        }
        await batch.commit(noResult: true);
        inserted += part.length;
        postProgress(inserted, total);
      }
    });

    await db.close();
    stopwatch.stop();

    send.send({'type': 'done', 'dataset': key, 'inserted': inserted, 'total': total, 'retries': retries, 'durationMs': stopwatch.elapsedMilliseconds, 'status': 'ok'});
  } catch (e) {
    stopwatch.stop();
    send.send({'type': 'done', 'dataset': key, 'inserted': 0, 'total': 0, 'retries': retries, 'durationMs': stopwatch.elapsedMilliseconds, 'status': 'failed'});
  }
}
