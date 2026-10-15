class DivineJournalSearch {
  static const fields = [
    "title",
    "body",
    "mood",
    "dreamSymbols",
    "gratitudeBlessings",
    "gratitudeMeaning",
    "gratitudeAction",
    "manifestationIntention",
    "manifestationMilestone",
    "manifestationTarget",
    "manifestationStatus",
  ];

  static bool matches(Map<String, dynamic> entry, String query) {
    final terms = query
        .trim()
        .toLowerCase()
        .split(RegExp(r"\s+"))
        .where((term) => term.isNotEmpty);
    if (terms.isEmpty) return true;
    final searchable = fields
        .map((field) => entry[field]?.toString() ?? "")
        .join(" ")
        .toLowerCase();
    return terms.every(searchable.contains);
  }
}
