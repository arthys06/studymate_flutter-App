import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../services/session.dart';

class WeaknessScreen extends StatefulWidget {
  const WeaknessScreen({super.key});

  @override
  State<WeaknessScreen> createState() => _WeaknessScreenState();
}

class _WeaknessScreenState extends State<WeaknessScreen> {
  Map<String, _TopicStat> _stats = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _analyze();
  }

  Future<void> _analyze() async {
    final results = await DatabaseHelper.instance.getQuizResults(Session.currentUser!.id);

    final Map<String, _TopicStat> stats = {};
    for (final r in results) {
      final topic = r['topic'] as String;
      final score = r['score'] as int;
      final total = r['total'] as int;
      stats.putIfAbsent(topic, () => _TopicStat());
      stats[topic]!.totalScore += score;
      stats[topic]!.totalPossible += total;
      stats[topic]!.attempts += 1;
    }

    setState(() {
      _stats = stats;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Weakness Detection')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_stats.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Weakness Detection')),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Text(
              'No quiz attempts yet.\nTake a few AI Quizzes first — this report is built from your real quiz history.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    // Sort weakest first.
    final sortedTopics = _stats.keys.toList()
      ..sort((a, b) => _percentFor(_stats[a]!).compareTo(_percentFor(_stats[b]!)));

    return Scaffold(
      appBar: AppBar(title: const Text('Weakness Detection')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Based on your quiz history, here is where to focus next:',
            style: TextStyle(fontSize: 15),
          ),
          const SizedBox(height: 16),
          ...sortedTopics.map((topic) {
            final stat = _stats[topic]!;
            final percent = _percentFor(stat);
            final isWeak = percent < 60;

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(topic, style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text('$percent%', style: TextStyle(color: isWeak ? Colors.red : Colors.green)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    LinearProgressIndicator(
                      value: percent / 100,
                      color: isWeak ? Colors.red : Colors.green,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${stat.attempts} quiz attempt(s) taken',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    if (isWeak) ...[
                      const SizedBox(height: 6),
                      Text(
                        'Suggestion: practice more $topic quizzes and review core concepts before your exam.',
                        style: const TextStyle(fontSize: 13, fontStyle: FontStyle.italic),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  int _percentFor(_TopicStat stat) {
    if (stat.totalPossible == 0) return 0;
    return ((stat.totalScore / stat.totalPossible) * 100).round();
  }
}

class _TopicStat {
  int totalScore = 0;
  int totalPossible = 0;
  int attempts = 0;
}
