import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../db/database_helper.dart';
import '../services/session.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  List<Map<String, dynamic>> _notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final rows = await DatabaseHelper.instance.getNotes(Session.currentUser!.id);
    setState(() => _notes = rows);
  }

  Future<void> _addNote() async {
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('New Note'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Title')),
              const SizedBox(height: 8),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(labelText: 'Content'),
                maxLines: 5,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Save')),
        ],
      ),
    );

    if (saved == true && titleController.text.trim().isNotEmpty) {
      await DatabaseHelper.instance.insertNote({
        'user_id': Session.currentUser!.id,
        'title': titleController.text.trim(),
        'content': contentController.text.trim(),
        'created_at': DateTime.now().toIso8601String(),
      });
      _loadNotes();
    }
  }

  Future<void> _deleteNote(int id) async {
    await DatabaseHelper.instance.deleteNote(id);
    _loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notes')),
      floatingActionButton: FloatingActionButton(onPressed: _addNote, child: const Icon(Icons.add)),
      body: _notes.isEmpty
          ? const Center(child: Text('No notes yet. Tap + to add one.'))
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.85,
              ),
              itemCount: _notes.length,
              itemBuilder: (context, i) {
                final note = _notes[i];
                final created = DateTime.tryParse(note['created_at'] as String? ?? '');
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                note['title'] as String,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            InkWell(
                              onTap: () => _deleteNote(note['id'] as int),
                              child: const Icon(Icons.close, size: 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Expanded(
                          child: Text(
                            note['content'] as String? ?? '',
                            maxLines: 6,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (created != null)
                          Text(
                            DateFormat('d MMM, h:mm a').format(created),
                            style: const TextStyle(fontSize: 10, color: Colors.grey),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
