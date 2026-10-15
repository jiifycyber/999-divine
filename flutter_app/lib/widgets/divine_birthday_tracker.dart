import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";

class DivineBirthdayTracker extends StatefulWidget {
  const DivineBirthdayTracker({super.key});
  @override
  State<DivineBirthdayTracker> createState() => _DivineBirthdayTrackerState();
}

class _DivineBirthdayTrackerState extends State<DivineBirthdayTracker> {
  static const gold = Color(0xFFFFD27C);
  static const storageKey = "justice_divine_birthday_23_intentions_v1";
  List<String> intentions = List.filled(23, "");
  List<bool> completed = List.filled(23, false);
  bool loading = true;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final names = prefs.getStringList(storageKey) ?? [];
    final states = prefs.getStringList("${storageKey}_completed") ?? [];
    if (!mounted) return;
    setState(() {
      intentions = List.generate(23, (i) => i < names.length ? names[i] : "");
      completed = List.generate(
        23,
        (i) => i < states.length && states[i] == "true",
      );
      loading = false;
    });
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(storageKey, intentions);
    await prefs.setStringList(
      "${storageKey}_completed",
      completed.map((v) => v.toString()).toList(),
    );
  }

  Future<void> editIntention(int index) async {
    final controller = TextEditingController(text: intentions[index]);
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF28153E),
        title: Text(
          "Intention ${index + 1}",
          style: const TextStyle(color: gold),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLength: 200,
          maxLines: 3,
          decoration: const InputDecoration(hintText: "Write your intention"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: const Text("Save"),
          ),
        ],
      ),
    );
    controller.dispose();
    if (result == null || !mounted) return;
    setState(() {
      intentions[index] = result;
      if (result.isEmpty) completed[index] = false;
    });
    await save();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator(color: gold));
    }
    final count = completed.where((v) => v).length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          "23 INTENTIONS",
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: gold,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          "$count of 23 completed",
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white70),
        ),
        const SizedBox(height: 12),
        LinearProgressIndicator(
          value: count / 23,
          minHeight: 10,
          borderRadius: BorderRadius.circular(12),
          color: gold,
          backgroundColor: const Color(0xFF39204E),
        ),
        const SizedBox(height: 20),
        for (var i = 0; i < 23; i++)
          Card(
            color: const Color(0xFF38204F),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: const BorderSide(color: gold, width: 0.6),
            ),
            child: ListTile(
              leading: Checkbox(
                value: completed[i],
                activeColor: gold,
                onChanged: intentions[i].isEmpty
                    ? null
                    : (value) async {
                        setState(() => completed[i] = value ?? false);
                        await save();
                      },
              ),
              title: Text(
                intentions[i].isEmpty
                    ? "Intention ${i + 1} — Tap to write"
                    : intentions[i],
                style: TextStyle(
                  color: Colors.white,
                  decoration: completed[i] ? TextDecoration.lineThrough : null,
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.edit_outlined, color: gold),
                onPressed: () => editIntention(i),
              ),
              onTap: () => editIntention(i),
            ),
          ),
      ],
    );
  }
}
