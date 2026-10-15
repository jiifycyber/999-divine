import "package:flutter/material.dart";

class DivineGratitudeInsights extends StatelessWidget {
  final List<Map<String, dynamic>> entries;
  const DivineGratitudeInsights({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFFFD27C);
    final gratitude = entries
        .where((e) => e["category"] == "Gratitude")
        .toList();
    final days = <DateTime>{};
    for (final entry in gratitude) {
      final raw = entry["createdAt"]?.toString();
      final date = raw == null ? null : DateTime.tryParse(raw);
      if (date != null) days.add(DateTime(date.year, date.month, date.day));
    }
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final yesterday = todayDate.subtract(const Duration(days: 1));
    var streak = 0;
    var cursor = days.contains(todayDate) ? todayDate : yesterday;
    while (days.contains(cursor)) {
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    final lastSeven = List.generate(
      7,
      (i) => todayDate.subtract(Duration(days: i)),
    );
    final weekCount = lastSeven.where(days.contains).length;
    final sortedDays = days.toList()..sort((a, b) => b.compareTo(a));
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: gold),
        gradient: const LinearGradient(
          colors: [Color(0xFF70428B), Color(0xFF211234)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "GRATITUDE INTELLIGENCE",
            style: TextStyle(
              color: gold,
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            "Total reflections: ${gratitude.length}",
            style: const TextStyle(color: Colors.white),
          ),
          Text(
            "Days practiced: ${days.length}",
            style: const TextStyle(color: Colors.white),
          ),
          Text(
            "Current streak: $streak days",
            style: const TextStyle(color: Colors.white),
          ),
          Text(
            "Last 7 days: $weekCount / 7",
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 14),
          const Text(
            "RECENT GRATITUDE DAYS",
            style: TextStyle(color: gold, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          if (sortedDays.isEmpty)
            const Text(
              "Your gratitude journey begins with one reflection.",
              style: TextStyle(color: Colors.white70),
            ),
          for (final day in sortedDays.take(5))
            Text(
              "${day.month}/${day.day}/${day.year}",
              style: const TextStyle(color: Colors.white),
            ),
        ],
      ),
    );
  }
}
