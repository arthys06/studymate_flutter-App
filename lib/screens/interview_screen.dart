import 'package:flutter/material.dart';
import '../data/interview_questions.dart';

class InterviewScreen extends StatefulWidget {
  const InterviewScreen({super.key});

  @override
  State<InterviewScreen> createState() => _InterviewScreenState();
}

class _InterviewScreenState extends State<InterviewScreen> {
  String? _selectedTopic;
  int _currentIndex = 0;
  bool _showAnswer = false;
  final _answerController = TextEditingController();

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  void _startTopic(String topic) {
    setState(() {
      _selectedTopic = topic;
      _currentIndex = 0;
      _showAnswer = false;
      _answerController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedTopic == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('AI Interview Practice')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Choose a topic for your mock interview:', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 16),
              ...interviewBank.keys.map((topic) => Card(
                    child: ListTile(
                      title: Text(topic),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => _startTopic(topic),
                    ),
                  )),
            ],
          ),
        ),
      );
    }

    final questions = interviewBank[_selectedTopic]!;
    final q = questions[_currentIndex];

    return Scaffold(
      appBar: AppBar(title: Text('$_selectedTopic Interview — Q${_currentIndex + 1}/${questions.length}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(q.question, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _answerController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Type your answer here',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: () => setState(() => _showAnswer = true),
              icon: const Icon(Icons.lightbulb_outline),
              label: const Text('Show sample answer & tip'),
            ),
            if (_showAnswer) ...[
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Sample Answer', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text(q.sampleAnswer),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Card(
                color: Colors.amber.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Tip', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text(q.tip),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (_currentIndex < questions.length - 1)
                  FilledButton(
                    onPressed: () => setState(() {
                      _currentIndex++;
                      _showAnswer = false;
                      _answerController.clear();
                    }),
                    child: const Text('Next Question'),
                  )
                else
                  FilledButton(
                    onPressed: () => setState(() => _selectedTopic = null),
                    child: const Text('Finish'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
