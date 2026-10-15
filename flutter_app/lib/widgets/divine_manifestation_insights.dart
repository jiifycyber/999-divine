import "package:flutter/material.dart";

class DivineManifestationInsights extends StatelessWidget {
  final List<Map<String, dynamic>> entries;
  const DivineManifestationInsights({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFFFD27C);
    final goals = entries
        .where((e) => e["category"] == "Manifestation Progress")
        .toList();
    final completed = goals
        .where((e) => e["manifestationStatus"] == "Completed")
        .length;
    final paused = goals
        .where((e) => e["manifestationStatus"] == "Paused")
        .length;
    final active = goals
        .where((e) => e["manifestationStatus"] == "In Progress")
        .length;
    double progress(Map<String, dynamic> e) =>
        ((e["manifestationProgress"] as num?)?.toDouble() ?? 0).clamp(
          0.0,
          100.0,
        );
    final average = goals.isEmpty
        ? 0.0
        : goals.map(progress).reduce((a, b) => a + b) / goals.length;
    final upcoming =
        goals.where((e) {
          final d = DateTime.tryParse(
            e["manifestationTarget"]?.toString() ?? "",
          );
          return d != null &&
              !d.isBefore(
                DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day,
                ),
              ) &&
              e["manifestationStatus"] != "Completed";
        }).toList()..sort(
          (a, b) => (a["manifestationTarget"]?.toString() ?? "").compareTo(
            b["manifestationTarget"]?.toString() ?? "",
          ),
        );
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
            "MANIFESTATION INTELLIGENCE",
            style: TextStyle(
              color: gold,
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            "Total intentions: ${goals.length}",
            style: const TextStyle(color: Colors.white),
          ),
          Text("Active: $active", style: const TextStyle(color: Colors.white)),
          Text(
            "Completed: $completed",
            style: const TextStyle(color: Colors.white),
          ),
          Text("Paused: $paused", style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 12),
          Text(
            "Average progress: ${average.round()}%",
            style: const TextStyle(color: gold),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: average / 100,
            minHeight: 9,
            borderRadius: BorderRadius.circular(8),
            backgroundColor: const Color(0xFF241333),
            color: gold,
          ),
          const SizedBox(height: 16),
          const Text(
            "UPCOMING TARGETS",
            style: TextStyle(color: gold, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          if (upcoming.isEmpty)
            const Text(
              "No upcoming targets yet.",
              style: TextStyle(color: Colors.white70),
            ),
          for (final goal in upcoming.take(5))
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    goal["manifestationIntention"]?.toString().isNotEmpty ==
                            true
                        ? goal["manifestationIntention"].toString()
                        : goal["title"]?.toString() ?? "Intention",
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    goal["manifestationTarget"]?.toString() ?? "",
                    style: const TextStyle(color: gold),
                  ),
                  LinearProgressIndicator(
                    value: progress(goal) / 100,
                    minHeight: 5,
                    backgroundColor: const Color(0xFF241333),
                    color: gold,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
