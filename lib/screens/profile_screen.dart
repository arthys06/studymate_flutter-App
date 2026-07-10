import 'package:flutter/material.dart';
import '../services/session.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Session.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: user == null
          ? const Center(child: Text('No user logged in.'))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 48,
                    child: Text(
                      user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                      style: const TextStyle(fontSize: 36),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                _InfoTile(label: 'Name', value: user.name),
                _InfoTile(label: 'Email', value: user.email),
                _InfoTile(label: 'College', value: user.college.isEmpty ? '-' : user.college),
                _InfoTile(label: 'Department', value: user.department.isEmpty ? '-' : user.department),
                _InfoTile(label: 'Semester', value: user.semester.isEmpty ? '-' : user.semester),
              ],
            ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;
  const _InfoTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value),
      ),
    );
  }
}
