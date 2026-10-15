import "package:flutter/material.dart";

import "../services/divine_journal_store.dart";
import "../services/divine_journal_search.dart";
import "divine_birthday_tracker.dart";
import "divine_dream_insights.dart";
import "divine_gratitude_insights.dart";
import "divine_manifestation_insights.dart";

class DivineJournalPage extends StatefulWidget {
  final String category;
  const DivineJournalPage({super.key, required this.category});
  @override
  State<DivineJournalPage> createState() => _DivineJournalPageState();
}

class _DivineJournalPageState extends State<DivineJournalPage> {
  static const gold = Color(0xFFFFD27C);
  static const bg = Color(0xFF10091F);
  static const lavender = Color(0xFFE4B8F9);
  BoxDecoration premiumDecoration() => BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: gold, width: 1.2),
    gradient: const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFF87509B),
        Color(0xFF623478),
        Color(0xFF26153E),
        Color(0xFF10091E),
      ],
      stops: [0.0, 0.22, 0.48, 1.0],
    ),
    boxShadow: [
      BoxShadow(color: gold.withValues(alpha: 0.16), blurRadius: 20),
      BoxShadow(
        color: const Color(0xFFAA56FF).withValues(alpha: 0.18),
        blurRadius: 26,
      ),
    ],
  );
  Widget premiumCard(Widget child) => Container(
    width: double.infinity,
    margin: const EdgeInsets.only(bottom: 18),
    padding: const EdgeInsets.all(20),
    decoration: premiumDecoration(),
    child: child,
  );

  List<Map<String, dynamic>> entries = [];
  String searchQuery = "";
  final searchController = TextEditingController();
  bool showFavoritesOnly = false;
  String selectedMoodFilter = "All Moods";
  bool loading = true;
  String? error;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    refresh();
  }

  Future<void> refresh() async {
    try {
      final all = await DivineJournalStore.load();
      if (!mounted) return;
      setState(() {
        entries = all.where((e) => e["category"] == widget.category).toList();
        loading = false;
        error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        loading = false;
        error = e.toString();
      });
    }
  }

  String get prompt {
    switch (widget.category) {
      case "My 23rd Birthday":
        return "What am I grateful for, and what intentions am I setting for this new chapter?";
      case "Dreams":
        return "What did I dream? What emotions, symbols, or memories stood out?";
      case "Gratitude":
        return "What three things am I grateful for today, and why?";
      case "Manifestation Progress":
        return "What is my intention? What progress have I made, and what comes next?";
      default:
        return "What is on my heart and mind today?";
    }
  }

  Future<void> edit([Map<String, dynamic>? existing]) async {
    final title = TextEditingController(
      text: existing?["title"]?.toString() ?? "",
    );
    final body = TextEditingController(
      text: existing?["body"]?.toString() ?? "",
    );
    String selectedMood = existing?["mood"]?.toString() ?? "Peaceful";
    final gratitudeBlessings = TextEditingController(
      text: existing?["gratitudeBlessings"]?.toString() ?? "",
    );
    final gratitudeMeaning = TextEditingController(
      text: existing?["gratitudeMeaning"]?.toString() ?? "",
    );
    final gratitudeAction = TextEditingController(
      text: existing?["gratitudeAction"]?.toString() ?? "",
    );
    final manifestationIntention = TextEditingController(
      text: existing?["manifestationIntention"]?.toString() ?? "",
    );
    final manifestationMilestone = TextEditingController(
      text: existing?["manifestationMilestone"]?.toString() ?? "",
    );
    final manifestationTarget = TextEditingController(
      text: existing?["manifestationTarget"]?.toString() ?? "",
    );
    double manifestationProgress =
        ((existing?["manifestationProgress"] as num?)?.toDouble() ?? 0).clamp(
          0.0,
          100.0,
        );
    String manifestationStatus =
        existing?["manifestationStatus"]?.toString() ?? "In Progress";
    if (![
      "Not Started",
      "In Progress",
      "Completed",
      "Paused",
    ].contains(manifestationStatus)) {
      manifestationStatus = "In Progress";
    }
    final dreamSymbols = TextEditingController(
      text: existing?["dreamSymbols"]?.toString() ?? "",
    );
    bool dreamLucid = existing?["dreamLucid"] == true;
    bool dreamRecurring = existing?["dreamRecurring"] == true;
    double dreamClarity = (existing?["dreamClarity"] as num?)?.toDouble() ?? 3;
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: bg,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, updateMood) => Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            18,
            20,
            MediaQuery.viewInsetsOf(ctx).bottom + 20,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(ctx).height * 0.88,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 48,
                      height: 5,
                      decoration: BoxDecoration(
                        color: gold,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: premiumDecoration(),
                    child: Row(
                      children: [
                        const Icon(Icons.auto_awesome, color: gold, size: 24),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            widget.category.toUpperCase(),
                            style: const TextStyle(
                              color: gold,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    existing == null
                        ? "New Journal Entry"
                        : "Edit Journal Entry",
                    style: const TextStyle(
                      color: gold,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    prompt,
                    style: const TextStyle(color: Color(0xFFE4B8F9)),
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    controller: title,
                    maxLength: 120,
                    decoration: InputDecoration(
                      labelText: "Entry title",
                      filled: true,
                      fillColor: const Color(0xFF211331),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFF8E6AAB)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFF8E6AAB)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Color(0xFFFFD27C),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: body,
                    minLines: 6,
                    maxLines: 12,
                    decoration: InputDecoration(
                      labelText: "Your reflections",
                      filled: true,
                      fillColor: const Color(0xFF211331),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFF8E6AAB)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFF8E6AAB)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Color(0xFFFFD27C),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  if (widget.category == "Dreams") ...[
                    const Text(
                      "DREAM INTELLIGENCE",
                      style: TextStyle(
                        color: gold,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SwitchListTile(
                      title: const Text("Lucid dream"),
                      value: dreamLucid,
                      onChanged: (v) => updateMood(() => dreamLucid = v),
                    ),
                    SwitchListTile(
                      title: const Text("Recurring dream"),
                      value: dreamRecurring,
                      onChanged: (v) => updateMood(() => dreamRecurring = v),
                    ),
                    const Text("Dream clarity"),
                    Slider(
                      value: dreamClarity,
                      min: 1,
                      max: 5,
                      divisions: 4,
                      label: dreamClarity.round().toString(),
                      onChanged: (v) => updateMood(() => dreamClarity = v),
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (widget.category == "Dreams") ...[
                    const SizedBox(height: 12),
                    TextField(
                      controller: dreamSymbols,
                      maxLength: 300,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: "Dream symbols",
                        hintText: "Water, birds, numbers, places...",
                        border: OutlineInputBorder(),
                        helperText: "Separate symbols with commas",
                      ),
                    ),
                  ],
                  if (widget.category == "Gratitude") ...[
                    const Text(
                      "DAILY GRATITUDE REFLECTION",
                      style: TextStyle(
                        color: gold,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: gratitudeBlessings,
                      minLines: 2,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: "1. What are you grateful for today?",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: gratitudeMeaning,
                      minLines: 2,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: "2. Why does it matter to you?",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: gratitudeAction,
                      minLines: 2,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: "3. How will you express gratitude?",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 18),
                  ],
                  if (widget.category == "Manifestation Progress") ...[
                    const Text(
                      "MANIFESTATION INTELLIGENCE",
                      style: TextStyle(
                        color: gold,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: manifestationIntention,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: "My intention or goal",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: manifestationMilestone,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: "Next milestone",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: manifestationTarget,
                      decoration: const InputDecoration(
                        labelText: "Target date (YYYY-MM-DD)",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Progress: ${manifestationProgress.round()}%",
                      style: const TextStyle(color: gold),
                    ),
                    Slider(
                      value: manifestationProgress,
                      min: 0,
                      max: 100,
                      divisions: 20,
                      label: manifestationProgress.round().toString(),
                      onChanged: (v) =>
                          updateMood(() => manifestationProgress = v),
                    ),
                    DropdownButtonFormField<String>(
                      initialValue: manifestationStatus,
                      decoration: const InputDecoration(
                        labelText: "Manifestation status",
                        border: OutlineInputBorder(),
                      ),
                      items:
                          ["Not Started", "In Progress", "Completed", "Paused"]
                              .map(
                                (v) =>
                                    DropdownMenuItem(value: v, child: Text(v)),
                              )
                              .toList(),
                      onChanged: (v) {
                        if (v != null) {
                          updateMood(() => manifestationStatus = v);
                        }
                      },
                    ),
                    const SizedBox(height: 18),
                  ],
                  const Text(
                    "How are you feeling?",
                    style: TextStyle(color: gold, fontSize: 17),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final mood in [
                        "Peaceful",
                        "Happy",
                        "Grateful",
                        "Hopeful",
                        "Reflective",
                        "Anxious",
                        "Sad",
                        "Excited",
                      ])
                        ChoiceChip(
                          label: Text(mood),
                          selected: selectedMood == mood,
                          selectedColor: gold,
                          labelStyle: TextStyle(
                            color: selectedMood == mood ? bg : lavender,
                          ),
                          onSelected: (_) =>
                              updateMood(() => selectedMood = mood),
                        ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  FilledButton.icon(
                    onPressed: () async {
                      if (body.text.trim().isEmpty &&
                          !(widget.category == "Gratitude" &&
                              (gratitudeBlessings.text.trim().isNotEmpty ||
                                  gratitudeMeaning.text.trim().isNotEmpty ||
                                  gratitudeAction.text.trim().isNotEmpty)) &&
                          !(widget.category == "Manifestation Progress" &&
                              manifestationIntention.text.trim().isNotEmpty)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Write something before saving"),
                          ),
                        );
                        return;
                      }
                      final now = DateTime.now();
                      final entry = <String, dynamic>{
                        ...?existing,
                        "id":
                            existing?["id"] ??
                            now.microsecondsSinceEpoch.toString(),
                        "category": widget.category,
                        "mood": selectedMood,
                        if (widget.category == "Manifestation Progress")
                          "manifestationIntention": manifestationIntention.text
                              .trim(),
                        if (widget.category == "Manifestation Progress")
                          "manifestationMilestone": manifestationMilestone.text
                              .trim(),
                        if (widget.category == "Manifestation Progress")
                          "manifestationTarget": manifestationTarget.text
                              .trim(),
                        if (widget.category == "Manifestation Progress")
                          "manifestationProgress": manifestationProgress
                              .round(),
                        if (widget.category == "Manifestation Progress")
                          "manifestationStatus": manifestationStatus,
                        if (widget.category == "Gratitude")
                          "gratitudeBlessings": gratitudeBlessings.text.trim(),
                        if (widget.category == "Gratitude")
                          "gratitudeMeaning": gratitudeMeaning.text.trim(),
                        if (widget.category == "Gratitude")
                          "gratitudeAction": gratitudeAction.text.trim(),
                        if (widget.category == "Dreams")
                          "dreamSymbols": dreamSymbols.text.trim(),
                        if (widget.category == "Dreams")
                          "dreamLucid": dreamLucid,
                        if (widget.category == "Dreams")
                          "dreamRecurring": dreamRecurring,
                        if (widget.category == "Dreams")
                          "dreamClarity": dreamClarity,
                        "title": title.text.trim().isEmpty
                            ? widget.category
                            : title.text.trim(),
                        "body": body.text.trim(),
                        "createdAt":
                            existing?["createdAt"] ?? now.toIso8601String(),
                        "updatedAt": now.toIso8601String(),
                      };
                      try {
                        await DivineJournalStore.upsert(entry);
                        if (ctx.mounted) Navigator.pop(ctx, true);
                      } catch (e) {
                        if (ctx.mounted) {
                          ScaffoldMessenger.of(ctx).showSnackBar(
                            SnackBar(
                              content: Text("Save failed; please try again"),
                            ),
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.save_outlined),
                    label: const Text("Save Entry"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    title.dispose();
    body.dispose();
    dreamSymbols.dispose();
    gratitudeBlessings.dispose();
    gratitudeMeaning.dispose();
    gratitudeAction.dispose();
    manifestationIntention.dispose();
    manifestationMilestone.dispose();
    manifestationTarget.dispose();
    if (saved == true) await refresh();
  }

  Future<void> toggleFavorite(Map<String, dynamic> entry) async {
    try {
      await DivineJournalStore.upsert({
        ...entry,
        "favorite": entry["favorite"] != true,
        "updatedAt": DateTime.now().toIso8601String(),
      });
      await refresh();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Could not update favorite")),
        );
      }
    }
  }

  Future<void> remove(Map<String, dynamic> entry) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete entry?"),
        content: const Text("This action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await DivineJournalStore.delete(entry["id"].toString());
      await refresh();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Delete failed; please try again")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: bg,
    appBar: AppBar(
      backgroundColor: const Color(0xFF26113F),
      foregroundColor: gold,
      centerTitle: true,
      title: Text(widget.category),
    ),
    floatingActionButton: FloatingActionButton.extended(
      onPressed: () => edit(),
      icon: const Icon(Icons.edit_note),
      label: const Text("New Entry"),
    ),
    body: loading
        ? const Center(child: CircularProgressIndicator())
        : error != null
        ? Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text("Could not load journal; please try again"),
            ),
          )
        : ListView(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 100),
            children: [
              premiumCard(
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.auto_awesome, color: gold, size: 32),
                    const SizedBox(height: 12),
                    Text(
                      widget.category,
                      style: const TextStyle(
                        color: gold,
                        fontFamily: "serif",
                        fontSize: 26,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      prompt,
                      style: const TextStyle(
                        color: lavender,
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (entries.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Center(
                    child: Text(
                      "Your journal is ready. Tap New Entry to begin.",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              if (widget.category == "Dreams") const SizedBox(height: 20),
              if (widget.category == "Dreams")
                DivineDreamInsights(entries: entries),
              if (widget.category == "Dreams") const SizedBox(height: 24),
              if (widget.category == "Gratitude") const SizedBox(height: 20),
              if (widget.category == "Gratitude")
                DivineGratitudeInsights(entries: entries),
              if (widget.category == "Gratitude") const SizedBox(height: 24),
              if (widget.category == "Manifestation Progress")
                const SizedBox(height: 20),
              if (widget.category == "Manifestation Progress")
                DivineManifestationInsights(entries: entries),
              if (widget.category == "Manifestation Progress")
                const SizedBox(height: 24),
              if (widget.category == "My 23rd Birthday")
                const DivineBirthdayTracker(),
              if (widget.category == "My 23rd Birthday")
                const SizedBox(height: 24),
              TextField(
                controller: searchController,
                onChanged: (value) => setState(() => searchQuery = value),
                decoration: const InputDecoration(
                  labelText: "Search journal entries",
                  prefixIcon: Icon(Icons.search, color: gold),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  FilterChip(
                    label: const Text("Favorites Only"),
                    avatar: const Icon(Icons.star, color: gold, size: 18),
                    selected: showFavoritesOnly,
                    selectedColor: const Color(0xFF87509B),
                    checkmarkColor: gold,
                    onSelected: (value) =>
                        setState(() => showFavoritesOnly = value),
                  ),
                  DropdownButton<String>(
                    value: selectedMoodFilter,
                    dropdownColor: const Color(0xFF26113F),
                    style: const TextStyle(color: gold),
                    items:
                        const [
                              "All Moods",
                              "Peaceful",
                              "Happy",
                              "Grateful",
                              "Hopeful",
                              "Reflective",
                              "Anxious",
                              "Sad",
                              "Excited",
                            ]
                            .map(
                              (mood) => DropdownMenuItem(
                                value: mood,
                                child: Text(mood),
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => selectedMoodFilter = value);
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "${entries.where((entry) => DivineJournalSearch.matches(entry, searchQuery) && (!showFavoritesOnly || entry["favorite"] == true) && (selectedMoodFilter == "All Moods" || entry["mood"] == selectedMoodFilter)).length} of ${entries.length} entries",
                      style: const TextStyle(
                        color: gold,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      searchController.clear();
                      setState(() {
                        searchQuery = "";
                        showFavoritesOnly = false;
                        selectedMoodFilter = "All Moods";
                      });
                    },
                    icon: const Icon(Icons.filter_alt_off, color: gold),
                    label: const Text(
                      "Clear Filters",
                      style: TextStyle(color: gold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              for (final entry in entries.where(
                (entry) =>
                    DivineJournalSearch.matches(entry, searchQuery) &&
                    (!showFavoritesOnly || entry["favorite"] == true) &&
                    (selectedMoodFilter == "All Moods" ||
                        entry["mood"] == selectedMoodFilter),
              ))
                Card(
                  color: const Color(0xFF623478),
                  elevation: 8,
                  shadowColor: gold.withValues(alpha: 0.2),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: gold),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  margin: const EdgeInsets.only(bottom: 14),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry["title"]?.toString() ?? widget.category,
                          style: const TextStyle(
                            color: gold,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          entry["body"]?.toString() ?? "",
                          style: const TextStyle(fontSize: 15, height: 1.5),
                        ),
                        // JOURNAL STRUCTURED DETAILS
                        if (widget.category == "Gratitude")
                          for (final field in const [
                            ("gratitudeBlessings", "GRATEFUL FOR"),
                            ("gratitudeMeaning", "WHY IT MATTERS"),
                            ("gratitudeAction", "GRATITUDE IN ACTION"),
                          ])
                            if ((entry[field.$1]?.toString() ?? "")
                                .trim()
                                .isNotEmpty) ...[
                              const SizedBox(height: 12),
                              Text(
                                field.$2,
                                style: const TextStyle(
                                  color: gold,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                entry[field.$1].toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  height: 1.5,
                                ),
                              ),
                            ],
                        if (widget.category == "Dreams") ...[
                          if ((entry["dreamSymbols"]?.toString() ?? "")
                              .trim()
                              .isNotEmpty) ...[
                            const SizedBox(height: 12),
                            const Text(
                              "DREAM SYMBOLS",
                              style: TextStyle(
                                color: gold,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              entry["dreamSymbols"].toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                          if (entry["dreamLucid"] == true)
                            const Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: Text(
                                "✦ Lucid Dream",
                                style: TextStyle(color: gold),
                              ),
                            ),
                          if (entry["dreamRecurring"] == true)
                            const Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: Text(
                                "↻ Recurring Dream",
                                style: TextStyle(color: gold),
                              ),
                            ),
                          if (entry["dreamClarity"] is num)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                "Clarity: ${entry["dreamClarity"]} / 5",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                        ],
                        if (widget.category == "Manifestation Progress") ...[
                          for (final field in const [
                            ("manifestationIntention", "INTENTION"),
                            ("manifestationMilestone", "NEXT MILESTONE"),
                            ("manifestationTarget", "TARGET DATE"),
                            ("manifestationStatus", "STATUS"),
                          ])
                            if ((entry[field.$1]?.toString() ?? "")
                                .trim()
                                .isNotEmpty) ...[
                              const SizedBox(height: 10),
                              Text(
                                field.$2,
                                style: const TextStyle(
                                  color: gold,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                entry[field.$1].toString(),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          if (entry["manifestationProgress"] is num) ...[
                            const SizedBox(height: 12),
                            Text(
                              "Progress: ${(entry["manifestationProgress"] as num).round()}%",
                              style: const TextStyle(color: gold),
                            ),
                            const SizedBox(height: 6),
                            LinearProgressIndicator(
                              value:
                                  ((entry["manifestationProgress"] as num)
                                              .toDouble() /
                                          100)
                                      .clamp(0.0, 1.0),
                              minHeight: 7,
                              backgroundColor: const Color(0xFF241333),
                              color: gold,
                            ),
                          ],
                        ],
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () => toggleFavorite(entry),
                              icon: Icon(
                                entry["favorite"] == true
                                    ? Icons.star
                                    : Icons.star_border,
                                color: gold,
                              ),
                              tooltip: "Toggle favorite",
                            ),
                            TextButton.icon(
                              onPressed: () => edit(entry),
                              icon: const Icon(Icons.edit_outlined),
                              label: const Text("Edit"),
                            ),
                            IconButton(
                              onPressed: () => remove(entry),
                              icon: const Icon(Icons.delete_outline),
                              tooltip: "Delete",
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
  );
}
