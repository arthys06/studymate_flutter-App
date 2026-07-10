import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../db/database_helper.dart';
import '../services/session.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _visibleMonth = DateTime(DateTime.now().year, DateTime.now().month);
  DateTime _selectedDate = DateTime.now();
  Map<String, List<String>> _eventsByDate = {}; // 'yyyy-MM-dd' -> [titles]

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    final userId = Session.currentUser!.id;
    final rows = await DatabaseHelper.instance.getCalendarEvents(userId);
    final map = <String, List<String>>{};
    for (final row in rows) {
      final date = row['date'] as String;
      map.putIfAbsent(date, () => []).add(row['title'] as String);
    }
    setState(() => _eventsByDate = map);
  }

  String _fmt(DateTime d) => DateFormat('yyyy-MM-dd').format(d);

  Future<void> _addEvent() async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Add event on ${DateFormat('d MMM yyyy').format(_selectedDate)}'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Event title'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, controller.text.trim()), child: const Text('Add')),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      await DatabaseHelper.instance.insertCalendarEvent({
        'user_id': Session.currentUser!.id,
        'date': _fmt(_selectedDate),
        'title': result,
      });
      _loadEvents();
    }
  }

  @override
  Widget build(BuildContext context) {
    final firstDayOfMonth = DateTime(_visibleMonth.year, _visibleMonth.month, 1);
    final daysInMonth = DateTime(_visibleMonth.year, _visibleMonth.month + 1, 0).day;
    final startWeekday = firstDayOfMonth.weekday % 7; // 0 = Sunday

    final selectedKey = _fmt(_selectedDate);
    final selectedEvents = _eventsByDate[selectedKey] ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text('Calendar')),
      floatingActionButton: FloatingActionButton(
        onPressed: _addEvent,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () => setState(() {
                    _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month - 1);
                  }),
                ),
                Text(
                  DateFormat('MMMM yyyy').format(_visibleMonth),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () => setState(() {
                    _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month + 1);
                  }),
                ),
              ],
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
            itemCount: daysInMonth + startWeekday,
            itemBuilder: (context, index) {
              if (index < startWeekday) return const SizedBox.shrink();
              final day = index - startWeekday + 1;
              final date = DateTime(_visibleMonth.year, _visibleMonth.month, day);
              final key = _fmt(date);
              final hasEvent = _eventsByDate.containsKey(key);
              final isSelected = key == selectedKey;

              return GestureDetector(
                onTap: () => setState(() => _selectedDate = date),
                child: Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: isSelected ? Theme.of(context).colorScheme.primary : null,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$day',
                        style: TextStyle(color: isSelected ? Colors.white : null),
                      ),
                      if (hasEvent)
                        Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.white : Theme.of(context).colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Events on ${DateFormat('d MMM yyyy').format(_selectedDate)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: selectedEvents.isEmpty
                ? const Center(child: Text('No events. Tap + to add one.'))
                : ListView(
                    children: selectedEvents.map((e) => ListTile(title: Text(e))).toList(),
                  ),
          ),
        ],
      ),
    );
  }
}
