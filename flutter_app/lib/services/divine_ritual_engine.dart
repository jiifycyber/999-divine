class DivineRitual {
  final String id;
  final String title;
  final String category;
  final String purpose;
  final String frequency;
  final String affirmation;
  final List<String> materials;
  final List<String> steps;
  final String reflection;
  final int durationMinutes;
  const DivineRitual({
    required this.id,
    required this.title,
    required this.category,
    required this.purpose,
    required this.frequency,
    required this.affirmation,
    required this.materials,
    required this.steps,
    required this.reflection,
    required this.durationMinutes,
  });
}

class DivineRitualEngine {
  static const categories = [
    "Money & Prosperity",
    "Love & Relationships",
    "Protection & Cleansing",
    "Moon & Manifestation",
    "Dreams & Intuition",
    "Ancestors & Remembrance",
  ];
  static const focuses = [
    "Clarity",
    "Gratitude",
    "Renewal",
    "Confidence",
    "Patience",
    "Balance",
    "Courage",
    "Reflection",
    "Compassion",
    "Purpose",
    "Release",
    "Growth",
    "Mindfulness",
    "Peace",
    "Hope",
    "Consistency",
  ];
  static const practices = [
    "Mindful Breathing",
    "Written Intention",
    "Guided Reflection",
    "Gratitude Practice",
    "Quiet Meditation",
    "Personal Affirmation",
    "Symbolic Visualization",
  ];
  static int _dayNumber(DateTime date) {
    final utc = DateTime.utc(date.year, date.month, date.day);
    return utc.difference(DateTime.utc(2020, 1, 1)).inDays;
  }

  static DivineRitual generate(
    DateTime date, {
    String category = "Money & Prosperity",
    String frequency = "daily",
  }) {
    if (!categories.contains(category)) {
      throw ArgumentError.value(
        category,
        "category",
        "Unknown ritual category",
      );
    }
    if (!const ["daily", "weekly", "monthly"].contains(frequency)) {
      throw ArgumentError.value(
        frequency,
        "frequency",
        "Unsupported frequency",
      );
    }
    final day = _dayNumber(date);
    final period = frequency == "monthly"
        ? date.year * 12 + date.month
        : frequency == "weekly"
        ? (day - (date.weekday - 1)) ~/ 7
        : day;
    final categoryIndex = categories.indexOf(category);
    final seed = period * 37 + categoryIndex * 101;
    final focus = focuses[(seed % focuses.length).abs()];
    final practice = practices[((seed ~/ 3) % practices.length).abs()];
    final duration = frequency == "monthly"
        ? 20
        : frequency == "weekly"
        ? 15
        : 7;
    final title = "$focus & $category";
    final id = "${frequency}_${period}_$categoryIndex";
    return DivineRitual(
      id: id,
      title: title,
      category: category,
      purpose: "A guided $frequency practice for $focus through $category.",
      frequency: frequency,
      affirmation:
          "I welcome $focus and take meaningful steps toward my intentions.",
      materials: const [
        "A quiet space",
        "Journal or paper (optional)",
        "Pen (optional)",
      ],
      steps: [
        "Find a comfortable, quiet space and take three slow breaths.",
        "Reflect on what $focus means to you within $category.",
        "Practice $practice for a few minutes without judging your thoughts.",
        "Write one clear intention connected to your current priorities.",
        "Identify one realistic action you can take toward that intention.",
        "Close with gratitude and repeat your affirmation aloud or silently.",
      ],
      reflection: "What did this practice reveal about your intentions, and what action will you take next?",
      durationMinutes: duration,
    );
  }

  static List<DivineRitual> dailyCollection(DateTime date) => [
    for (final category in categories) generate(date, category: category),
  ];
  static DivineRitual weekly(DateTime date, String category) =>
      generate(date, category: category, frequency: "weekly");
  static DivineRitual monthly(DateTime date, String category) =>
      generate(date, category: category, frequency: "monthly");
}
