import "package:flutter/material.dart";

class DivineDreamInsights extends StatelessWidget {
  final List<Map<String, dynamic>> entries;
  const DivineDreamInsights({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFFFD27C);
    final dreams = entries.where((e) => e["category"] == "Dreams").toList();
    final lucid = dreams.where((e) => e["dreamLucid"] == true).length;
    final recurring = dreams.where((e) => e["dreamRecurring"] == true).length;
    final clarity = dreams
        .map((e) => e["dreamClarity"])
        .whereType<num>()
        .toList();
    final average = clarity.isEmpty
        ? "Not rated"
        : (clarity.fold<double>(0, (sum, value) => sum + value.toDouble()) /
                  clarity.length)
              .toStringAsFixed(1);
    final symbols = <String, int>{};
    for (final dream in dreams) {
      final raw = dream["dreamSymbols"]?.toString() ?? "";
      final unique = raw
          .split(",")
          .map((s) => s.trim().toLowerCase())
          .where((s) => s.isNotEmpty)
          .toSet();
      for (final symbol in unique) {
        symbols[symbol] = (symbols[symbol] ?? 0) + 1;
      }
    }
    final ranked = symbols.entries.toList()
      ..sort((a, b) {
        final comparison = b.value.compareTo(a.value);
        return comparison != 0 ? comparison : a.key.compareTo(b.key);
      });
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
            "DREAM PATTERN INSIGHTS",
            style: TextStyle(
              color: gold,
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            "Dreams recorded: ${dreams.length}",
            style: const TextStyle(color: Colors.white),
          ),
          Text(
            "Lucid dreams: $lucid",
            style: const TextStyle(color: Colors.white),
          ),
          Text(
            "Recurring dreams: $recurring",
            style: const TextStyle(color: Colors.white),
          ),
          Text(
            "Average clarity: $average",
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 14),
          const Text(
            "MOST RECORDED SYMBOLS",
            style: TextStyle(color: gold, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          if (ranked.isEmpty)
            const Text(
              "Record dream symbols to discover patterns.",
              style: TextStyle(color: Colors.white70),
            ),
          for (final symbol in ranked.take(8))
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Text(
                "${symbol.key}  •  ${symbol.value} dream(s)",
                style: const TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}
