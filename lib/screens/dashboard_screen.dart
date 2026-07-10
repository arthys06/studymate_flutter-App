import 'package:flutter/material.dart';
import '../services/session.dart';
import 'auth/login_screen.dart';
import 'profile_screen.dart';
import 'calendar_screen.dart';
import 'notes_screen.dart';
import 'reminders_screen.dart';
import 'quiz_screen.dart';
import 'weakness_screen.dart';
import 'interview_screen.dart';
import 'resume_screen.dart';
import 'doubt_chat_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Session.currentUser;

    final modules = <_ModuleItem>[
      _ModuleItem('Profile', Icons.person, (ctx) => const ProfileScreen()),
      _ModuleItem('Calendar', Icons.calendar_today, (ctx) => const CalendarScreen()),
      _ModuleItem('Notes', Icons.note_alt, (ctx) => const NotesScreen()),
      _ModuleItem('Reminders', Icons.notifications_active, (ctx) => const RemindersScreen()),
      _ModuleItem('AI Quiz', Icons.quiz, (ctx) => const QuizScreen()),
      _ModuleItem('Weakness Detection ⭐', Icons.psychology, (ctx) => const WeaknessScreen()),
      _ModuleItem('Interview Practice ⭐', Icons.record_voice_over, (ctx) => const InterviewScreen()),
      _ModuleItem('Resume Builder ⭐', Icons.description, (ctx) => const ResumeScreen()),
      _ModuleItem('AI Doubt Chat', Icons.chat, (ctx) => const DoubtChatScreen()),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('StudyMate'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              Session.logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Welcome, ${user?.name ?? 'Student'} 👋',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.3,
              ),
              itemCount: modules.length,
              itemBuilder: (context, i) {
                final m = modules[i];
                return Card(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: m.builder),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(m.icon, size: 32),
                          const SizedBox(height: 8),
                          Text(m.label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ModuleItem {
  final String label;
  final IconData icon;
  final Widget Function(BuildContext) builder;
  _ModuleItem(this.label, this.icon, this.builder);
}
