import "divine_location_autocomplete.dart";

import 'package:flutter/material.dart';

class DivineEventEditor extends StatefulWidget {
  final DateTime initialDate;
  const DivineEventEditor({super.key, required this.initialDate});
  @override
  State<DivineEventEditor> createState() => _DivineEventEditorState();
}

class _DivineEventEditorState extends State<DivineEventEditor> {
  final title = TextEditingController();
  final notes = TextEditingController();
  final location = TextEditingController();
  late DateTime date;
  TimeOfDay start = const TimeOfDay(hour: 12, minute: 0);
  TimeOfDay end = const TimeOfDay(hour: 13, minute: 0);
  String type = "Event";
  String category = "General";
  String alert = "None";
  String repeat = "Never";
  @override
  void initState() {
    super.initState();
    date = widget.initialDate;
  }

  @override
  void dispose() {
    title.dispose();
    notes.dispose();
    location.dispose();
    super.dispose();
  }

  static const _gold = Color(0xFFE8C57B);
  static const _lavender = Color(0xFFF1E8F5);
  BoxDecoration _panelDecoration() => BoxDecoration(
    borderRadius: BorderRadius.circular(18),
    border: Border.all(color: _gold, width: 1.15),
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
      BoxShadow(color: _gold.withValues(alpha: .15), blurRadius: 18),
      BoxShadow(
        color: const Color(0xFFAA56FF).withValues(alpha: .15),
        blurRadius: 24,
      ),
    ],
  );
  Widget _panel(String label, IconData icon, Widget child) => Container(
    margin: const EdgeInsets.only(bottom: 14),
    padding: const EdgeInsets.all(16),
    decoration: _panelDecoration(),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 3, right: 14),
          child: Icon(icon, color: _gold, size: 24),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: _gold,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 9),
              child,
            ],
          ),
        ),
      ],
    ),
  );
  InputDecoration _input(String hint) => InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: Color(0xFFBCAACB)),
    filled: true,
    fillColor: const Color(0xFF1C102F),
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(13),
      borderSide: const BorderSide(color: Color(0xFF6F498E)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(13),
      borderSide: const BorderSide(color: Color(0xFF6F498E)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(13),
      borderSide: const BorderSide(color: _gold, width: 1.5),
    ),
  );
  Widget _pickerValue(String value) => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    decoration: BoxDecoration(
      color: const Color(0xFF1C102F),
      borderRadius: BorderRadius.circular(13),
      border: Border.all(color: const Color(0xFF6F498E)),
    ),
    child: Text(value, style: const TextStyle(color: _lavender, fontSize: 16)),
  );
  Widget _choice(
    String value,
    List<String> choices,
    ValueChanged<String?> changed,
  ) => DropdownButtonFormField<String>(
    initialValue: value,
    isExpanded: true,
    dropdownColor: const Color(0xFF26153E),
    style: const TextStyle(color: _lavender, fontSize: 16),
    decoration: _input("Select an option"),
    items: choices
        .map((v) => DropdownMenuItem(value: v, child: Text(v)))
        .toList(),
    onChanged: changed,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF10091E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF211533),
        foregroundColor: _gold,
        title: const Text(
          "Add Event or Reminder",
          style: TextStyle(fontFamily: "serif"),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(
                    value: "Event",
                    icon: Icon(Icons.event),
                    label: Text("Event"),
                  ),
                  ButtonSegment(
                    value: "Reminder",
                    icon: Icon(Icons.notifications_outlined),
                    label: Text("Reminder"),
                  ),
                ],
                selected: {type},
                style: ButtonStyle(
                  foregroundColor: WidgetStateProperty.resolveWith(
                    (states) => states.contains(WidgetState.selected)
                        ? const Color(0xFF211533)
                        : _gold,
                  ),
                  backgroundColor: WidgetStateProperty.resolveWith(
                    (states) => states.contains(WidgetState.selected)
                        ? _gold
                        : const Color(0xFF26153E),
                  ),
                  side: WidgetStateProperty.all(const BorderSide(color: _gold)),
                ),
                onSelectionChanged: (v) => setState(() => type = v.first),
              ),
              const SizedBox(height: 20),
              _panel(
                "Title *",
                Icons.description_outlined,
                TextField(
                  controller: title,
                  style: const TextStyle(color: _lavender),
                  decoration: _input("Enter event title"),
                ),
              ),
              _panel(
                "Notes",
                Icons.edit_note,
                TextField(
                  controller: notes,
                  maxLines: 3,
                  style: const TextStyle(color: _lavender),
                  decoration: _input("Add notes (optional)"),
                ),
              ),
              _panel(
                "Location",
                Icons.location_on_outlined,
                DivineLocationAutocomplete(controller: location),
              ),
              _panel(
                "Date *",
                Icons.calendar_month,
                InkWell(
                  onTap: () async {
                    final v = await showDatePicker(
                      context: context,
                      initialDate: date,
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100),
                    );
                    if (v != null) setState(() => date = v);
                  },
                  child: _pickerValue(date.toIso8601String().split("T").first),
                ),
              ),
              _panel(
                "Start Time *",
                Icons.schedule,
                InkWell(
                  onTap: () async {
                    final v = await showTimePicker(
                      context: context,
                      initialTime: start,
                    );
                    if (v != null) setState(() => start = v);
                  },
                  child: _pickerValue(start.format(context)),
                ),
              ),
              _panel(
                "End Time *",
                Icons.schedule,
                InkWell(
                  onTap: () async {
                    final v = await showTimePicker(
                      context: context,
                      initialTime: end,
                    );
                    if (v != null) setState(() => end = v);
                  },
                  child: _pickerValue(end.format(context)),
                ),
              ),
              _panel(
                "Category",
                Icons.sell_outlined,
                _choice(
                  category,
                  [
                    "General",
                    "Personal",
                    "Business",
                    "Ritual",
                    "Birthday",
                    "Important",
                  ],
                  (v) {
                    if (v != null) setState(() => category = v);
                  },
                ),
              ),
              _panel(
                "Alert Preference",
                Icons.notifications_outlined,
                _choice(
                  alert,
                  [
                    "None",
                    "At time",
                    "5 minutes before",
                    "15 minutes before",
                    "1 hour before",
                    "1 day before",
                  ],
                  (v) {
                    if (v != null) setState(() => alert = v);
                  },
                ),
              ),
              _panel(
                "Repeat Preference",
                Icons.repeat,
                _choice(
                  repeat,
                  ["Never", "Daily", "Weekly", "Monthly", "Yearly"],
                  (v) {
                    if (v != null) setState(() => repeat = v);
                  },
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _gold,
                  foregroundColor: const Color(0xFF211533),
                  minimumSize: const Size.fromHeight(56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                icon: const Icon(Icons.save_outlined),
                onPressed: () {
                  if (title.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Enter a title")),
                    );
                    return;
                  }
                  if (end.hour * 60 + end.minute <=
                      start.hour * 60 + start.minute) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("End time must be after start time"),
                      ),
                    );
                    return;
                  }
                  Navigator.pop(context, <String, dynamic>{
                    "id": DateTime.now().microsecondsSinceEpoch.toString(),
                    "title": title.text.trim(),
                    "notes": notes.text.trim(),
                    "location": location.text.trim(),
                    "date": date.toIso8601String(),
                    "startTime": [
                      start.hour.toString().padLeft(2, "0"),
                      start.minute.toString().padLeft(2, "0"),
                    ].join(":"),
                    "endTime": [
                      end.hour.toString().padLeft(2, "0"),
                      end.minute.toString().padLeft(2, "0"),
                    ].join(":"),
                    "type": type,
                    "category": category,
                    "alert": alert,
                    "repeat": repeat,
                  });
                },
                label: const Text(
                  "Save Event",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
