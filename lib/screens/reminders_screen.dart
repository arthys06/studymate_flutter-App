import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../db/database_helper.dart';
import '../services/session.dart';
import '../services/notification_service.dart';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  List<Map<String, dynamic>> _reminders = [];

  @override
  void initState() {
    super.initState();
    NotificationService.instance.init();
    _loadReminders();
  }

  Future<void> _loadReminders() async {
    final rows = await DatabaseHelper.instance.getReminders(Session.currentUser!.id);
    setState(() => _reminders = rows);
  }

  Future<void> _addReminder() async {
    final titleController = TextEditingController();
    DateTime pickedDateTime = DateTime.now().add(const Duration(minutes: 1));

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('New Reminder'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'What should I remind you about?'),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: Text(DateFormat('d MMM yyyy, h:mm a').format(pickedDateTime))),
                  TextButton(
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: ctx,
                        initialDate: pickedDateTime,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (date == null) return;
                      final time = await showTimePicker(
                        context: ctx,
                        initialTime: TimeOfDay.fromDateTime(pickedDateTime),
                      );
                      if (time == null) return;
                      setDialogState(() {
                        pickedDateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
                      });
                    },
                    child: const Text('Pick'),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, {'title': titleController.text.trim(), 'datetime': pickedDateTime}),
              child: const Text('Set Reminder'),
            ),
          ],
        ),
      ),
    );

    if (result != null && (result['title'] as String).isNotEmpty) {
      final dateTime = result['datetime'] as DateTime;
      final id = await DatabaseHelper.instance.insertReminder({
        'user_id': Session.currentUser!.id,
        'title': result['title'],
        'datetime': dateTime.toIso8601String(),
      });

      await NotificationService.instance.scheduleReminder(
        id: id,
        title: result['title'] as String,
        dateTime: dateTime,
      );

      _loadReminders();
    }
  }

  Future<void> _deleteReminder(int id) async {
    await NotificationService.instance.cancelReminder(id);
    await DatabaseHelper.instance.deleteReminder(id);
    _loadReminders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reminders')),
      floatingActionButton: FloatingActionButton(onPressed: _addReminder, child: const Icon(Icons.add)),
      body: _reminders.isEmpty
          ? const Center(child: Text('No reminders yet. Tap + to add one.'))
          : ListView.builder(
              itemCount: _reminders.length,
              itemBuilder: (context, i) {
                final r = _reminders[i];
                final dt = DateTime.parse(r['datetime'] as String);
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: const Icon(Icons.notifications_active),
                    title: Text(r['title'] as String),
                    subtitle: Text(DateFormat('d MMM yyyy, h:mm a').format(dt)),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => _deleteReminder(r['id'] as int),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
