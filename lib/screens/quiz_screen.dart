import 'package:flutter/material.dart';
import '../data/quiz_questions.dart';
import '../db/database_helper.dart';
import '../services/session.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  String? _selectedTopic;
  int _currentIndex = 0;
  int _score = 0;
  int? _selectedOption;
  bool _showResult = false;

  void _startQuiz(String topic) {
    setState(() {
      _selectedTopic = topic;
      _currentIndex = 0;
      _score = 0;
      _selectedOption = null;
      _showResult = false;
    });
  }

  void _selectOption(int index, List<QuizQuestion> questions) {
    if (_selectedOption != null) return;
    setState(() => _selectedOption = index);

    final correct = index == questions[_currentIndex].correctIndex;
    if (correct) _score++;

    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      if (_currentIndex < questions.length - 1) {
        setState(() {
          _currentIndex++;
          _selectedOption = null;
        });
      } else {
        _finishQuiz(questions.length);
      }
    });
  }

  Future<void> _finishQuiz(int total) async {
    setState(() => _showResult = true);
    await DatabaseHelper.instance.insertQuizResult({
      'user_id': Session.currentUser!.id,
      'topic': _selectedTopic,
      'score': _score,
      'total': total,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedTopic == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('AI Quiz Generator')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Choose a topic:', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 16),
              ...quizBank.keys.map((topic) => Card(
                    child: ListTile(
                      title: Text(topic),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => _startQuiz(topic),
                    ),
                  )),
            ],
          ),
        ),
      );
    }

    final questions = quizBank[_selectedTopic]!;

    if (_showResult) {
      final percent = ((_score / questions.length) * 100).round();
      return Scaffold(
        appBar: AppBar(title: Text('$_selectedTopic — Result')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('You scored', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Text('$_score / ${questions.length} ($percent%)', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () => setState(() => _selectedTopic = null),
                  child: const Text('Back to Topics'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final q = questions[_currentIndex];

    return Scaffold(
      appBar: AppBar(title: Text('$_selectedTopic — Q${_currentIndex + 1}/${questions.length}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(q.question, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 20),
            ...List.generate(q.options.length, (i) {
              Color? color;
              if (_selectedOption != null) {
                if (i == q.correctIndex) {
                  color = Colors.green.shade200;
                } else if (i == _selectedOption) {
                  color = Colors.red.shade200;
                }
              }
              return Card(
                color: color,
                child: ListTile(
                  title: Text(q.options[i]),
                  onTap: () => _selectOption(i, questions),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
