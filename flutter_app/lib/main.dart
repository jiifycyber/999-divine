import 'services/justice_local_lock.dart';
import 'widgets/justice_profile_page.dart';
import 'services/justice_guidance_content.dart';
import 'services/justice_sacred_letters.dart';
import 'services/divine_genesis/divine_ritual_snapshot_store.dart';
import 'services/divine_genesis/divine_master_engine.dart';
import 'widgets/divine_upcoming_events.dart';
import 'services/divine_ritual_engine.dart';
import 'widgets/divine_premium_kpi_card.dart';

import 'package:flutter/material.dart';

import 'widgets/divine_event_editor.dart';

import "services/divine_event_store.dart";
import "widgets/divine_journal_page.dart";
import "services/divine_moon_service.dart";

void main() => runApp(const DivineApp());
const bg = Color(0xFF10091F),
    panel = Color(0xFF28153E),
    gold = Color(0xFFFFD27C),
    lavender = Color(0xFFE4B8F9);

class CelestialStarfield extends StatelessWidget {
  const CelestialStarfield({super.key});
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(painter: _CelestialPainter(), size: Size.infinite),
    );
  }
}

class _CelestialPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFFD782).withValues(alpha: 0.48);
    for (var i = 0; i < 85; i++) {
      final x = ((i * 137.5) % 997) / 997 * size.width;
      final y = ((i * 211.7) % 991) / 991 * size.height;
      canvas.drawCircle(Offset(x, y), i % 9 == 0 ? 1.8 : 0.7, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DivineLotusPainter extends CustomPainter {
  const DivineLotusPainter();
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height * .63;
    final goldPaint = Paint()
      ..color = const Color(0xFFFFD782)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2;
    final glow = Paint()
      ..color = const Color(0xFFFFD782).withValues(alpha: .13)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
    canvas.drawCircle(Offset(cx, cy), 42, glow);
    for (var i = -3; i <= 3; i++) {
      canvas.save();
      canvas.translate(cx, cy);
      canvas.rotate(i * .31);
      final path = Path()
        ..moveTo(0, 0)
        ..quadraticBezierTo(-23, -31, 0, -68)
        ..quadraticBezierTo(23, -31, 0, 0);
      canvas.drawPath(path, goldPaint);
      canvas.restore();
    }
    for (var i = 0; i < 11; i++) {
      final x = (i * 47.0 + 13) % size.width;
      final y = (i * 29.0 + 7) % size.height;
      canvas.drawCircle(Offset(x, y), i % 3 == 0 ? 1.7 : 1.0, goldPaint);
    }
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx, cy + 7), width: 110, height: 35),
      0,
      3.14159,
      false,
      goldPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DivineApp extends StatelessWidget {
  const DivineApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Justice Divine',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bg,
      colorScheme: ColorScheme.fromSeed(
        seedColor: gold,
        brightness: Brightness.dark,
      ),
    ),
    home: const JusticeLocalLock(child: DivineHome()),
  );
}

class DivineHome extends StatefulWidget {
  const DivineHome({super.key});
  @override
  State<DivineHome> createState() => _DivineHomeState();
}

class _DivineHomeState extends State<DivineHome> {
  List<Map<String, dynamic>> calendarEvents = [];
  bool calendarEventsLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadCalendarEvents();
  }

  Future<void> _loadCalendarEvents() async {
    try {
      final loaded = await DivineEventStore.load();
      if (!mounted) return;
      setState(() {
        calendarEvents = loaded;
        calendarEventsLoaded = true;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => calendarEventsLoaded = true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Calendar loading failed: \$error")),
      );
    }
  }

  int selected = 0;
  int year = 2026;
  bool calendarYearView = false;
  int month = 10;
  int day = 14;
  final tabs = [
    'Home',
    'Rituals',
    'Calendar',
    'Journal',
    'Guidance',
    'Profile',
  ];
  final icons = [
    Icons.home_outlined,
    Icons.auto_awesome_outlined,
    Icons.calendar_month_outlined,
    Icons.menu_book_outlined,
    Icons.nightlight_outlined,
    Icons.person_outline,
  ];
  final ritualNames = [
    'Money & Prosperity',
    'Love & Relationships',
    'Protection & Cleansing',
    'Moon & Manifestation',
    'Dreams & Intuition',
    'Ancestors & Remembrance',
  ];
  final ritualSub = [
    'Attract abundance, opportunity and financial growth',
    'Self-love, romance, harmony and emotional healing',
    'Ground yourself and create peaceful energy',
    'Set intentions and reflect with lunar cycles',
    'Explore dreams and inner wisdom',
    'Honor your heritage and remember loved ones',
  ];
  final ritualIcons = [
    Icons.paid,
    Icons.favorite,
    Icons.shield_outlined,
    Icons.nightlight_round,
    Icons.diamond_outlined,
    Icons.local_florist,
  ];
  final guide = [
    'Daily Affirmations',
    'Moon Phases',
    'Meditations',
    'Spiritual Tools',
    'Articles & Lessons',
    'Voice Guidance',
  ];
  final guideIcons = [
    Icons.wb_twilight,
    Icons.brightness_2,
    Icons.self_improvement,
    Icons.diamond,
    Icons.auto_stories,
    Icons.mic,
  ];
  Future<void> saveGenesisRitual(DivineRitual ritual) async {
    try {
      final saved = await DivineRitualSnapshotStore.load();
      final fingerprint = DivineRitualSnapshotStore.encode(ritual).toString();
      final exists = saved.any(
        (item) =>
            DivineRitualSnapshotStore.encode(item).toString() == fingerprint,
      );
      if (exists) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Ceremony already saved")));
        return;
      }
      await DivineRitualSnapshotStore.save([...saved, ritual]);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Ceremony saved successfully")),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Could not save ceremony: $error")),
      );
    }
  }

  void showDetail(String title, String body, {DivineRitual? ritual}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF10091E),
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (ctx) => FractionallySizedBox(
        heightFactor: 0.88,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 4, 18, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 25,
                  color: gold,
                  fontFamily: "serif",
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (ritual != null)
                ElevatedButton.icon(
                  onPressed: () => saveGenesisRitual(ritual),
                  icon: const Icon(Icons.bookmark_add_outlined),
                  label: const Text("Save Ceremony"),
                ),
              const SizedBox(height: 18),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (final section in body.split(
                        String.fromCharCode(10) + String.fromCharCode(10),
                      ))
                        Container(
                          margin: const EdgeInsets.only(bottom: 14),
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: gold.withValues(alpha: .85),
                              width: 1.15,
                            ),
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
                              BoxShadow(
                                color: gold.withValues(alpha: .16),
                                blurRadius: 20,
                              ),
                              BoxShadow(
                                color: const Color(0xFFAA56FF)
                                    .withValues(alpha: .18),
                                blurRadius: 26,
                              ),
                            ],
                          ),
                          child: Text(
                            section,
                            style: const TextStyle(
                              color: Color(0xFFF1E8F5),
                              fontSize: 15,
                              height: 1.5,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 50,
                child: FilledButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text("Close"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget tile(
    String title,
    String subtitle,
    IconData icon, {
    VoidCallback? action,
  }) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: gold.withValues(alpha: .85), width: 1.15),
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
        BoxShadow(color: gold.withValues(alpha: .16), blurRadius: 20),
        BoxShadow(
          color: const Color(0xFFAA56FF).withValues(alpha: .18),
          blurRadius: 26,
        ),
      ],
    ),
    child: Material(
      type: MaterialType.transparency,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
        leading: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6E377B), Color(0xFF26133B)],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: gold, size: 29),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: gold,
            fontFamily: 'serif',
            fontSize: 17,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 12, color: Color(0xFFDBD0E5)),
        ),
        trailing: const Icon(Icons.chevron_right, color: gold),
        onTap:
            action ??
            () => showDetail(
              title,
              'A detailed guided experience for this section is coming next.',
            ),
      ),
    ),
  );
  Widget heading(String name, String subtitle) => Column(
    children: [
      Text(
        name,
        textAlign: TextAlign.center,
        style: const TextStyle(color: gold, fontSize: 33, fontFamily: 'serif'),
      ),
      const SizedBox(height: 5),
      Text(
        subtitle,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 12, color: lavender),
      ),
      const SizedBox(height: 22),
    ],
  );
  Widget ic391HomeHero() => Container(
    width: double.infinity,
    height: 112,
    margin: const EdgeInsets.only(bottom: 18),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: gold.withValues(alpha: .90), width: 1.2),
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF26113F),
          Color(0xFF472260),
          Color(0xFF241238),
          Color(0xFF130921),
        ],
        stops: [0, .34, .72, 1],
      ),
      boxShadow: [
        BoxShadow(color: gold.withValues(alpha: .24), blurRadius: 24),
        BoxShadow(
          color: const Color(0xFFAA56FF).withValues(alpha: .20),
          blurRadius: 30,
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(17),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 2,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [gold, const Color(0xFFAA56FF), gold],
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 15),
            child: Row(
              children: [
                Icon(Icons.auto_awesome, color: gold, size: 35),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "CELESTIAL COMMAND",
                        style: TextStyle(
                          color: gold,
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "JUSTICE DIVINE INTELLIGENCE",
                        style: TextStyle(
                          color: Color(0xFFF9F1FF),
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: .7,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "LUNAR CYCLES  •  RITUALS  •  GUIDANCE",
                        style: TextStyle(
                          color: lavender,
                          fontSize: 8,
                          letterSpacing: .5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
  Widget home() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      ic391HomeHero(),
      const SizedBox(height: 10),
      SizedBox(
        height: 172,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: DivinePremiumKpiCard(
                value: "29.5",
                label: "LUNAR CYCLE",
                icon: Icons.nightlight_round,
                color: gold,
                variant: 0,
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: DivinePremiumKpiCard(
                value: "12",
                label: "MOON PHASES",
                icon: Icons.auto_awesome,
                color: Color(0xFFD08BFF),
                variant: 1,
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: DivinePremiumKpiCard(
                value: "6",
                label: "SECTIONS",
                icon: Icons.grid_view_rounded,
                color: Color(0xFFE8C779),
                variant: 2,
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: DivinePremiumKpiCard(
                value: "999",
                label: "DIVINE ENERGY",
                icon: Icons.bolt_rounded,
                color: Color(0xFFB86AFF),
                variant: 3,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 14),
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 3),
        child: Row(
          children: [
            Icon(Icons.auto_awesome, color: gold, size: 19),
            SizedBox(width: 9),
            Expanded(
              child: Text(
                "DIVINE COMMAND CENTER",
                style: TextStyle(
                  color: gold,
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.1,
                ),
              ),
            ),
            Text(
              "LIVE DASHBOARD",
              style: TextStyle(color: lavender, fontSize: 9),
            ),
          ],
        ),
      ),
      const SizedBox(height: 12),
      Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: gold.withValues(alpha: .85), width: 1.15),
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
            BoxShadow(color: gold.withValues(alpha: .16), blurRadius: 20),
            BoxShadow(
              color: const Color(0xFFAA56FF).withValues(alpha: .18),
              blurRadius: 26,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.workspace_premium, color: gold, size: 24),
            SizedBox(height: 9),
            Text(
              DateTime.now().month == 10 && DateTime.now().day == 14
                  ? 'Happy Birthday, Justice!'
                  : 'Welcome, Justice',
              style: TextStyle(fontFamily: 'serif', color: gold, fontSize: 20),
            ),
            SizedBox(height: 8),
            Text(
              DateTime.now().month == 10 && DateTime.now().day == 14
                  ? 'Happy Birthday! Today is a new chapter. You are powerful, guided, and exactly where you need to be.'
                  : 'A new day brings new possibilities. Trust your journey, honor your growth, and move forward with intention.',
            ),
          ],
        ),
      ),
      const SizedBox(height: 4),
      tile(
        '${["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"][DateTime.now().weekday - 1]}, ${["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"][DateTime.now().month - 1]} ${DateTime.now().day}',
        DateTime.now().month == 10 && DateTime.now().day == 14
            ? 'Your birthday • A fresh start for new intentions'
            : 'Your daily calendar • Set your intentions',
        Icons.calendar_today,
        action: () => setState(() {
          selected = 2;
          year = DateTime.now().year;
          month = DateTime.now().month;
          day = DateTime.now().day;
        }),
      ),
      tile(
        'Daily Inspiration',
        'You are the creator of your reality. Everything you desire begins within your reach.',
        Icons.favorite_outline,
        action: () => showDetail(
          "Daily Inspiration",
          "You are the creator of your reality. Everything you desire begins within your reach. Take a moment to breathe, recognize your strengths, and choose one meaningful intention for today.",
        ),
      ),
      tile(
        'Quick Actions',
        'New Ritual  •  Set Intention  •  Write Journal',
        Icons.bolt,
        action: () => showModalBottomSheet(
          context: context,
          backgroundColor: panel,
          builder: (ctx) => SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text("Explore Rituals"),
                  leading: const Icon(Icons.auto_awesome, color: gold),
                  onTap: () {
                    Navigator.pop(ctx);
                    setState(() => selected = 1);
                  },
                ),
                ListTile(
                  title: const Text("Set Intention"),
                  leading: const Icon(Icons.favorite_border, color: gold),
                  onTap: () {
                    Navigator.pop(ctx);
                    showDetail(
                      "Set Intention",
                      "Write down one clear intention, reflect on why it matters, and choose one action you can take toward it today.",
                    );
                  },
                ),
                ListTile(
                  title: const Text("Write Journal"),
                  leading: const Icon(Icons.edit_note, color: gold),
                  onTap: () {
                    Navigator.pop(ctx);
                    setState(() => selected = 3);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
  Future<void> openSavedCeremonies() async {
    try {
      final saved = await DivineRitualSnapshotStore.load();
      if (!mounted) return;
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (routeContext) => Scaffold(
            backgroundColor: bg,
            appBar: AppBar(
              backgroundColor: bg,
              foregroundColor: gold,
              title: const Text("Saved Ceremonies"),
            ),
            body: SafeArea(
              child: saved.isEmpty
                  ? const Center(child: Text("No saved ceremonies yet"))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: saved.length,
                      itemBuilder: (ctx, index) {
                        final ritual = saved[index];
                        return Card(
                          color: panel,
                          child: ListTile(
                            title: Text(
                              ritual.title,
                              style: const TextStyle(color: gold),
                            ),
                            subtitle: Text(ritual.category),
                            trailing: const Icon(
                              Icons.chevron_right,
                              color: gold,
                            ),
                            onTap: () {
                              final nl = String.fromCharCode(10);
                              final gap = nl + nl;
                              final steps = ritual.steps
                                  .asMap()
                                  .entries
                                  .map((e) => "${e.key + 1}. ${e.value}")
                                  .join(nl);
                              showDetail(
                                ritual.title,
                                "PURPOSE$nl${ritual.purpose}${gap}MATERIALS$nl${ritual.materials.join(nl)}${gap}GUIDED STEPS$nl$steps${gap}AFFIRMATION$nl${ritual.affirmation}${gap}REFLECTION$nl${ritual.reflection}",
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
          ),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Could not load saved ceremonies: $error")),
      );
    }
  }

  Widget sacredStones() {
    const stones = <(String, String, String)>[
      (
        "Jade",
        "Prosperity, abundance, harmony, financial wisdom.",
        "Prosperity and Responsible Stewardship",
      ),
      (
        "Tiger's Eye",
        "Protection, courage, confidence, grounding.",
        "Protection and Cleansing",
      ),
      (
        "Amethyst",
        "Intuition, calm, spiritual clarity, reflection.",
        "Protection and Cleansing; Dreams and Intuition",
      ),
      (
        "Rose Quartz",
        "Love, compassion, emotional harmony, self-love.",
        "Love and Relationships",
      ),
      (
        "Moonstone",
        "Lunar cycles, renewal, intuition, transformation.",
        "Moon and Manifestation",
      ),
      (
        "Black Onyx",
        "Grounding, resilience, ancestral remembrance.",
        "Ancestors and Remembrance",
      ),
      (
        "Citrine",
        "Success, optimism, creativity, opportunity.",
        "Prosperity; Moon and Manifestation",
      ),
      (
        "Clear Quartz",
        "Clarity, focus, concentration, intention.",
        "All six rituals",
      ),
      (
        "Labradorite",
        "Transformation, insight, self-discovery, imagination.",
        "Dreams and Intuition; Moon and Manifestation",
      ),
      (
        "Lapis Lazuli",
        "Wisdom, truth, knowledge, self-expression.",
        "Dreams and Intuition; Ancestors and Remembrance",
      ),
      (
        "Black Obsidian",
        "Protection, reflection, releasing burdens.",
        "Protection and Cleansing",
      ),
      (
        "Malachite",
        "Transformation, personal growth, renewal.",
        "Moon and Manifestation; Prosperity",
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 24, bottom: 10),
          child: Text(
            "SACRED STONES",
            style: TextStyle(
              color: gold,
              fontWeight: FontWeight.w900,
              fontSize: 15,
              letterSpacing: 1.2,
            ),
          ),
        ),
        for (final stone in stones)
          tile(
            stone.$1,
            stone.$2,
            Icons.diamond_outlined,
            action: () => showDetail(
              stone.$1,
              "SPIRITUAL MEANING\n${stone.$2}\n\nRECOMMENDED RITUAL\n${stone.$3}\n\nThese are symbolic spiritual associations, not scientifically established properties.",
            ),
          ),
      ],
    );
  }

  Widget rituals() {
    final today = DateTime.now();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        heading(
          "Rituals",
          "Six sacred ceremonies honoring the Creator of the Universe.",
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: ElevatedButton.icon(
            onPressed: openSavedCeremonies,
            icon: const Icon(Icons.bookmarks_outlined),
            label: const Text("Saved Ceremonies"),
          ),
        ),
        ...[
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 10),
            child: Text(
              "SACRED RITUALS",
              style: const TextStyle(
                color: gold,
                fontWeight: FontWeight.w900,
                fontSize: 15,
                letterSpacing: 1.2,
              ),
            ),
          ),
          for (final category in DivineRitualEngine.categories)
            Builder(
              builder: (context) {
                final ritual = DivineMasterEngine.generate(
                  today,
                  category: category,
                  frequency: "daily",
                );
                return tile(
                  ritual.title,
                  "${ritual.durationMinutes} min • ${ritual.category}",
                  Icons.auto_awesome,
                  action: () => showDetail(
                    ritual.title,
                    JusticeSacredLetters.details(category) ??
                        "PURPOSE\n${ritual.purpose}\n\nMATERIALS\n${ritual.materials.join("\n")}\n\nGUIDED STEPS\n${ritual.steps.where((step) => !step.startsWith("CEREMONY DATE:") && !step.startsWith("TRADITION:") && !step.startsWith("HISTORICAL FOUNDATION:") && !step.startsWith("SOURCE:") && !step.startsWith("PRACTICE TYPE:") && !step.startsWith("WEEKLY REFLECTION:") && !step.startsWith("MONTHLY REFLECTION:")).toList().asMap().entries.map((e) => "${e.key + 1}. ${e.value}").join("\n")}\n\nAFFIRMATION\n${ritual.affirmation}\n\nREFLECTION\n${ritual.reflection}\n\nUNIVERSAL CLOSING\nBringing harm to none as it comes.\nThis I accept, so mote it be.",
                    ritual: ritual,
                  ),
                );
              },
            ),
        ],
        sacredStones(),
      ],
    );
  }

  BoxDecoration premiumCalendarDecoration() => BoxDecoration(
    borderRadius: BorderRadius.circular(18),
    border: Border.all(color: gold.withValues(alpha: .85), width: 1.15),
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
      BoxShadow(color: gold.withValues(alpha: .16), blurRadius: 20),
      BoxShadow(
        color: const Color(0xFFAA56FF).withValues(alpha: .18),
        blurRadius: 26,
      ),
    ],
  );
  Widget calendar() => Column(
    children: [
      heading('Calendar', 'Plan your rituals and spiritual reminders.'),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () => setState(() => calendarYearView = false),
            child: Text(
              "Month",
              style: TextStyle(color: calendarYearView ? lavender : gold),
            ),
          ),
          TextButton(
            onPressed: () => setState(() => calendarYearView = true),
            child: Text(
              "Year",
              style: TextStyle(color: calendarYearView ? gold : lavender),
            ),
          ),
        ],
      ),
      if (calendarYearView)
        yearOverview()
      else ...[
        Container(
          padding: const EdgeInsets.all(12),
          decoration: premiumCalendarDecoration(),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => setState(() {
                      final d = DateTime(year, month - 1, 1);
                      year = d.year;
                      month = d.month;
                      day = 1;
                    }),
                    icon: const Icon(Icons.chevron_left, color: gold),
                  ),
                  Text(
                    '${['', 'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'][month]} $year',
                    style: const TextStyle(
                      fontSize: 19,
                      color: gold,
                      fontFamily: 'serif',
                    ),
                  ),
                  IconButton(
                    onPressed: () => setState(() {
                      final d = DateTime(year, month + 1, 1);
                      year = d.year;
                      month = d.month;
                      day = 1;
                    }),
                    icon: const Icon(Icons.chevron_right, color: gold),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  for (final d in ['S', 'M', 'T', 'W', 'T', 'F', 'S'])
                    Text(d, style: TextStyle(color: lavender)),
                ],
              ),
              const SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisExtent: 66,
                ),
                itemCount:
                    (((DateTime(year, month, 1).weekday % 7) +
                            DateTime(year, month + 1, 0).day +
                            6) ~/
                        7) *
                    7,
                itemBuilder: (ctx, i) {
                  final n = i - (DateTime(year, month, 1).weekday % 7) + 1;
                  final daysInMonth = DateTime(year, month + 1, 0).day;
                  if (n < 1 || n > daysInMonth) return const SizedBox.shrink();
                  final date = DateTime(year, month, n);
                  final moon = DivineMoonService.symbol(date);
                  final illumination =
                      (DivineMoonService.illumination(date) * 100).round();
                  return InkWell(
                    onTap: () {
                      setState(() => day = n);
                      openDailyDetails(DateTime(year, month, n));
                    },
                    child: Container(
                      margin: const EdgeInsets.all(2),
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      decoration: BoxDecoration(
                        color: n == day
                            ? gold.withValues(alpha: .25)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(9),
                        border: Border.all(
                          color: n == day ? gold : Colors.transparent,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            n.toString(),
                            style: TextStyle(
                              color: n == day ? gold : Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          Text(moon, style: const TextStyle(fontSize: 16)),
                          Text(
                            illumination.toString() + String.fromCharCode(37),
                            style: const TextStyle(
                              color: lavender,
                              fontSize: 9,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        tile(
          'Birthday Blessing Ritual',
          'October 14 • Set 23 intentions for a new year',
          Icons.cake_outlined,
          action: () => openGenesisCeremony('birthday'),
        ),
        tile(
          'Morning Gratitude',
          'A mindful way to begin the day',
          Icons.wb_sunny_outlined,
          action: () => openGenesisCeremony('morning'),
        ),
        const SizedBox(height: 12),
        Text(
          "Saved Events",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        if (!calendarEventsLoaded)
          const CircularProgressIndicator()
        else if (calendarEvents.where((e) {
          final date = DateTime.tryParse(e["date"]?.toString() ?? "");
          return date != null &&
              date.year == year &&
              date.month == month &&
              date.day == day;
        }).isEmpty)
          const Text("No events scheduled for this date")
        else
          ...calendarEvents
              .where((e) {
                final date = DateTime.tryParse(e["date"]?.toString() ?? "");
                return date != null &&
                    date.year == year &&
                    date.month == month &&
                    date.day == day;
              })
              .map(
                (e) => tile(
                  e["title"]?.toString() ?? "Untitled Event",
                  e["notes"]?.toString() ?? "",
                  Icons.event_note,
                ),
              ),
        tile(
          'Add Event',
          'Create rituals, appointments, birthdays and reminders',
          Icons.add_alert,
          action: () => openEventEditor(),
        ),
        DivineUpcomingEvents(
          events: calendarEvents,
          onEventTap: (event) {
            final date = DateTime.tryParse(event['date']?.toString() ?? '');
            if (date == null) return;
            setState(() {
              year = date.year;
              month = date.month;
              day = date.day;
              calendarYearView = false;
            });
            openDailyDetails(date);
          },
        ),
      ],
    ],
  );
  void openGenesisCeremony(String kind) {
    final ritual = DivineMasterEngine.ceremony(
      DateTime(year, month, day),
      kind,
    );
    final nl = String.fromCharCode(10);
    final gap = nl + nl;
    final steps = ritual.steps
        .asMap()
        .entries
        .map((entry) => '${entry.key + 1}. ${entry.value}')
        .join(nl);
    showDetail(
      ritual.title,
      'PURPOSE$nl${ritual.purpose}${gap}MATERIALS$nl${ritual.materials.join(nl)}${gap}GUIDED STEPS$nl$steps${gap}AFFIRMATION$nl${ritual.affirmation}${gap}REFLECTION$nl${ritual.reflection}',
    );
  }

  void openDailyDetails(DateTime date) {
    final phase = DivineMoonService.phaseName(date);
    final illumination = DivineMoonService.illumination(date);
    final age = DivineMoonService.age(date);
    final direction = phase.startsWith("Waxing")
        ? "Waxing"
        : phase.startsWith("Waning")
        ? "Waning"
        : "Transition";
    final events = calendarEvents.where((e) {
      final d = DateTime.tryParse(e["date"]?.toString() ?? "");
      return d != null &&
          d.year == date.year &&
          d.month == date.month &&
          d.day == date.day;
    }).toList();
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (routeContext) => Scaffold(
          backgroundColor: bg,
          appBar: AppBar(
            backgroundColor: bg,
            foregroundColor: gold,
            title: const Text("Daily Details"),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Text(
                      DivineMoonService.symbol(date),
                      style: const TextStyle(fontSize: 90),
                    ),
                  ),
                  Text(
                    phase,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: gold,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    DateTime(
                      date.year,
                      date.month,
                      date.day,
                    ).toIso8601String().split("T").first,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: lavender),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: premiumCalendarDecoration(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "LUNAR INTELLIGENCE",
                          style: TextStyle(
                            color: gold,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          [
                            "Illumination:",
                            (illumination * 100).round().toString(),
                            String.fromCharCode(37),
                          ].join(" "),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 10),
                        LinearProgressIndicator(
                          value: illumination,
                          color: gold,
                          backgroundColor: Colors.white12,
                          minHeight: 8,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          [
                            "Lunar Age:",
                            age.toStringAsFixed(1),
                            "days",
                          ].join(" "),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          ["Cycle Direction:", direction].join(" "),
                          style: const TextStyle(color: lavender, fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Lunar Month: approximately 29.53 days",
                          style: TextStyle(color: lavender),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "My Schedule",
                    style: TextStyle(
                      color: gold,
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (events.isEmpty)
                    const Text(
                      "No events scheduled for this date",
                      style: TextStyle(color: lavender),
                    ),
                  ...events.map(
                    (e) => Card(
                      color: panel,
                      child: ListTile(
                        title: Text(
                          e["title"]?.toString() ?? "Untitled",
                          style: const TextStyle(color: gold),
                        ),
                        subtitle: Text(
                          e["notes"]?.toString() ?? "",
                          style: const TextStyle(color: lavender),
                        ),
                        leading: const Icon(Icons.event, color: gold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(routeContext);
                      openEventEditor();
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("Add Event or Reminder"),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: premiumCalendarDecoration(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Spiritual Meaning",
                          style: TextStyle(color: gold, fontSize: 21),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          direction == "Waxing"
                              ? "A time for setting intentions, personal growth, and nurturing new beginnings."
                              : direction == "Waning"
                              ? "A time for reflection, gratitude, and releasing what no longer serves you."
                              : "A moment of renewal, balance, and reflection.",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Lunar values are approximate astronomical calculations.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: lavender, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> openEventEditor() async {
    final event = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(
        builder: (_) =>
            DivineEventEditor(initialDate: DateTime(year, month, day)),
      ),
    );
    if (!mounted || event == null) return;
    final updated = [...calendarEvents, event];
    try {
      await DivineEventStore.save(updated);
      if (!mounted) return;
      final eventDate = DateTime.parse(event["date"] as String);
      setState(() {
        calendarEvents = updated;
        year = eventDate.year;
        month = eventDate.month;
        day = eventDate.day;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Event saved successfully")));
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Could not save event: $error")));
    }
  }

  Widget yearOverview() => Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => setState(() => year--),
            icon: const Icon(Icons.chevron_left, color: gold),
          ),
          Text("$year", style: const TextStyle(color: gold, fontSize: 25)),
          IconButton(
            onPressed: () => setState(() => year++),
            icon: const Icon(Icons.chevron_right, color: gold),
          ),
        ],
      ),
      GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2.1,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: 12,
        itemBuilder: (context, index) {
          final m = index + 1;
          const names = [
            "January",
            "February",
            "March",
            "April",
            "May",
            "June",
            "July",
            "August",
            "September",
            "October",
            "November",
            "December",
          ];
          return InkWell(
            onTap: () => setState(() {
              month = m;
              day = 1;
              calendarYearView = false;
            }),
            child: Container(
              alignment: Alignment.center,
              decoration: premiumCalendarDecoration(),
              child: Text(
                names[index],
                style: const TextStyle(color: gold, fontSize: 15),
              ),
            ),
          );
        },
      ),
    ],
  );
  void openJournal(String category) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => DivineJournalPage(category: category),
      ),
    );
  }

  Widget journal() => Column(
    children: [
      heading('Journal', 'Your private space for reflection and growth.'),
      tile(
        'New Entry',
        'Write, reflect, or record your thoughts',
        Icons.edit_note,
        action: () => openJournal("New Entry"),
      ),
      tile(
        'My 23rd Birthday',
        'I am grateful for this new chapter...',
        Icons.cake,
        action: () => openJournal("My 23rd Birthday"),
      ),
      tile(
        'Dreams',
        'Capture the stories from your sleep',
        Icons.bedtime_outlined,
        action: () => openJournal("Dreams"),
      ),
      tile(
        'Gratitude',
        'Three things I appreciate today',
        Icons.favorite_border,
        action: () => openJournal("Gratitude"),
      ),
      tile(
        'Manifestation Progress',
        'Track your intentions and growth',
        Icons.auto_awesome,
        action: () => openJournal("Manifestation Progress"),
      ),
    ],
  );
  Widget guidance() => Column(
    children: [
      heading('Guidance', 'Tools, wisdom, and insight for your journey.'),
      for (var i = 0; i < guide.length; i++)
        tile(
          guide[i],
          [
            'Positive words for your mind and spirit',
            'Explore lunar cycles and reflection',
            'Guided practices for peace and focus',
            'Crystals, herbs, candles and more',
            'Explore spiritual traditions and lessons',
            'Listen to affirmations and meditations',
          ][i],
          guideIcons[i],
          action: () => showDetail(guide[i], JusticeGuidanceContent.details(i)),
        ),
    ],
  );
  Widget profile() => const JusticeProfileV1();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF271039), bg, Color(0xFF170D29)],
            ),
          ),
          child: Stack(
            children: [
              const Positioned.fill(child: CelestialStarfield()),
              ListView(
                padding: const EdgeInsets.fromLTRB(18, 20, 18, 12),
                children: [
                  if (selected == 0) home(),
                  if (selected == 1) rituals(),
                  if (selected == 2) calendar(),
                  if (selected == 3) journal(),
                  if (selected == 4) guidance(),
                  if (selected == 5) profile(),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: SizedBox(
          height: 83,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                top: 10,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF35134E),
                        Color(0xFF1C0B31),
                        Color(0xFF0D071B),
                      ],
                    ),
                    border: Border(top: BorderSide(color: gold, width: 1.4)),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFB86AFF).withValues(alpha: .30),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: 49,
                    height: 28,
                    decoration: BoxDecoration(
                      color: const Color(0xFF24103C),
                      border: Border.all(color: gold, width: 1.2),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(28),
                        topRight: Radius.circular(28),
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: gold.withValues(alpha: .30),
                          blurRadius: 15,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.auto_awesome,
                      color: gold,
                      size: 18,
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                top: 19,
                child: Row(
                  children: [
                    for (var i = 0; i < tabs.length; i++)
                      Expanded(
                        child: InkWell(
                          onTap: () => setState(() => selected = i),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                icons[i],
                                size: 22,
                                color: selected == i
                                    ? gold
                                    : const Color(0xFFC6A6EC),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                tabs[i],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: selected == i
                                      ? gold
                                      : const Color(0xFFC6A6EC),
                                  fontSize: 10,
                                  fontWeight: selected == i
                                      ? FontWeight.w800
                                      : FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 5),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                height: 3,
                                width: selected == i ? 30 : 0,
                                decoration: BoxDecoration(
                                  color: gold,
                                  borderRadius: BorderRadius.circular(4),
                                  boxShadow: [
                                    BoxShadow(
                                      color: gold.withValues(alpha: .65),
                                      blurRadius: 9,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
