import 'package:flutter/material.dart';

class DivineUpcomingEvents extends StatefulWidget {
  final List<Map<String, dynamic>> events;
  final void Function(Map<String, dynamic>) onEventTap;
  const DivineUpcomingEvents({
    super.key,
    required this.events,
    required this.onEventTap,
  });
  @override
  State<DivineUpcomingEvents> createState() => _UpcomingState();
}

class _UpcomingState extends State<DivineUpcomingEvents> {
  String filter = 'This Week';
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final weekEnd = today.add(const Duration(days: 7));
    final monthEnd = DateTime(today.year, today.month + 1, 1);
    final items = widget.events.where((event) {
      final date = DateTime.tryParse(event['date']?.toString() ?? '');
      if (date == null) return false;
      final day = DateTime(date.year, date.month, date.day);
      if (day.isBefore(today)) return false;
      if (filter == 'Today') return day == today;
      if (filter == 'Tomorrow') return day == tomorrow;
      if (filter == 'This Week') return day.isBefore(weekEnd);
      if (filter == 'This Month') return day.isBefore(monthEnd);
      return true;
    }).toList();
    items.sort((a, b) {
      DateTime time(Map<String, dynamic> e) {
        final date =
            DateTime.tryParse(e['date']?.toString() ?? '') ?? DateTime(2100);
        final parts = (e['startTime']?.toString() ?? '00:00').split(':');
        final hour = int.tryParse(parts.first) ?? 0;
        final minute = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
        return DateTime(date.year, date.month, date.day, hour, minute);
      }

      return time(a).compareTo(time(b));
    });
    const gold = Color(0xFFE8C57B);
    return Container(
      margin: const EdgeInsets.only(top: 18),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: gold, width: 1.15),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF87509B),
            Color(0xFF623478),
            Color(0xFF26153E),
            Color(0xFF10091E),
          ],
          stops: [0, .22, .48, 1],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Upcoming Events',
            style: TextStyle(
              color: gold,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final option in [
                  'Today',
                  'Tomorrow',
                  'This Week',
                  'This Month',
                  'All',
                ])
                  Padding(
                    padding: const EdgeInsets.only(right: 7),
                    child: ChoiceChip(
                      label: Text(option),
                      selected: filter == option,
                      onSelected: (_) => setState(() => filter = option),
                      selectedColor: gold,
                      backgroundColor: const Color(0xFF26153E),
                      side: const BorderSide(color: gold),
                      labelStyle: TextStyle(
                        color: filter == option
                            ? const Color(0xFF10091E)
                            : gold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          if (items.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'No upcoming events in this period',
                style: TextStyle(color: Colors.white70),
              ),
            )
          else
            for (final event in items)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: InkWell(
                  onTap: () => widget.onEventTap(event),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF211533),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: gold),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.event_note, color: gold),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                event['title']?.toString() ?? 'Untitled Event',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                '${event['date']?.toString().split('T').first ?? ''}  •  ${event['startTime']?.toString() ?? ''}',
                                style: const TextStyle(
                                  color: gold,
                                  fontSize: 12,
                                ),
                              ),
                              if ((event['location']?.toString() ?? '')
                                  .isNotEmpty)
                                Text(
                                  event['location'].toString(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right, color: gold),
                      ],
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
