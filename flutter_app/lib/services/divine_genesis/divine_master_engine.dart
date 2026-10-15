import 'ancient_ritual_composer.dart';
import 'ancient_civilization_vault.dart';
import '../divine_ritual_engine.dart';

enum DivineDomain {
  maat,
  heka,
  solar,
  lunar,
  sacredCalendar,
  ancestral,
  personalization,
}

class DivineDomainRegistry {
  static const Map<DivineDomain, String> names = {
    DivineDomain.maat: 'Maat Intelligence',
    DivineDomain.heka: 'Heka Ritual Intelligence',
    DivineDomain.solar: 'Solar Intelligence',
    DivineDomain.lunar: 'Lunar Intelligence',
    DivineDomain.sacredCalendar: 'Sacred Calendar Intelligence',
    DivineDomain.ancestral: 'Ancestral Intelligence',
    DivineDomain.personalization: 'Divine Personalization Intelligence',
  };
  static const Map<DivineDomain, String> purposes = {
    DivineDomain.maat: 'Truth, balance, justice, and ethical reflection',
    DivineDomain.heka: 'Intentions, affirmations, and symbolic ritual actions',
    DivineDomain.solar: 'Sunrise, daylight, sunset, and renewal practices',
    DivineDomain.lunar: 'Moon phases, reflection, and lunar-cycle practices',
    DivineDomain.sacredCalendar:
        'Seasonal observances, festivals, and life milestones',
    DivineDomain.ancestral:
        'Remembrance, family, heritage, and life transitions',
    DivineDomain.personalization: 'Personalized ritual selection and guidance',
  };
  static String name(DivineDomain domain) => names[domain] ?? 'Unknown';
  static String purpose(DivineDomain domain) => purposes[domain] ?? '';
}

class DivineMasterEngine {
  static List<Map<String, String>> ancientKnowledge(String civilization) {
    if (civilization != 'egypt' && civilization != 'china') {
      throw ArgumentError.value(civilization, 'civilization');
    }
    return AncientCivilizationVault.forCivilization(civilization);
  }

  static Map<String, String>? ancientTeaching(String key) {
    return AncientCivilizationVault.find(key);
  }

  static DivineRitual ceremony(DateTime date, String kind) {
    final birthday = kind == 'birthday';
    if (!birthday && kind != 'morning') {
      throw ArgumentError.value(kind, 'kind', 'Unknown ceremony');
    }
    final base = generate(
      date,
      category: birthday ? 'Moon & Manifestation' : 'Ancestors & Remembrance',
    );
    return DivineRitual(
      id: (birthday ? 'birthday_' : 'morning_') + base.id,
      title: birthday ? 'Kemetic Birthday Blessing' : 'Morning Gratitude of Ra',
      category: birthday ? 'Life Celebrations' : 'Solar & Gratitude',
      purpose: birthday
          ? 'Celebrate another year of life through renewal, balance, remembrance, and meaningful intentions.'
          : 'Welcome the morning through gratitude, clarity, and the principles of Maat.',
      frequency: birthday ? 'annual' : 'daily',
      affirmation: birthday
          ? 'I honor my journey, welcome renewal, and commit to living with wisdom and balance.'
          : 'As the morning light returns, I welcome gratitude, truth, and balance into my actions.',
      materials: birthday
          ? [
              'A quiet space',
              'Journal or paper',
              'Pen',
              'A meaningful keepsake (optional)',
            ]
          : [
              'A quiet space',
              'Natural morning light (optional)',
              'Journal (optional)',
            ],
      steps: birthday
          ? [
              'Create a quiet space and take three slow breaths.',
              'Reflect on the experiences and lessons of the past year.',
              'Honor the people and ancestors who helped shape your journey.',
              'Consider Maat: truth, balance, justice, and compassion.',
              'Write three intentions for the coming year.',
              'Speak your affirmation and choose one practical action.',
              'Close with gratitude for your life and future possibilities.',
            ]
          : [
              'Welcome the morning in a comfortable, quiet space.',
              'Take three slow breaths and notice the beginning of a new day.',
              'Reflect on the solar symbolism of Ra and renewal.',
              'Name three things you appreciate.',
              'Choose one action that supports truth and balance.',
              'Speak your affirmation aloud or silently.',
              'Close with a moment of gratitude.',
            ],
      reflection: birthday
          ? 'What will you carry forward, and what will you change this year?'
          : 'How can you bring gratitude and balance into your actions today?',
      durationMinutes: birthday ? 20 : 7,
    );
  }

  static const version = '1.0.0';
  static const domains = DivineDomain.values;
  static DivineRitual generate(
    DateTime date, {
    String category = 'Moon & Manifestation',
    String frequency = 'daily',
    String civilization = 'egypt',
  }) {
    if (civilization != 'egypt' && civilization != 'china') {
      throw ArgumentError.value(civilization, 'civilization');
    }

    const categoryFocus = <String, String>{
      'Money & Prosperity': 'prosperity',
      'Love & Relationships': 'love',
      'Protection & Cleansing': 'protection',
      'Moon & Manifestation': 'lunar',
      'Dreams & Intuition': 'dreams',
      'Ancestors & Remembrance': 'ancestors',
    };

    const titles = <String, String>{
      'prosperity': 'Prosperity and Responsible Stewardship',
      'love': 'Love, Reciprocity, and Respect',
      'protection': 'Protection, Boundaries, and Clarity',
      'lunar': 'Lunar Reflection and Intention Setting',
      'dreams': 'Dream Reflection and Symbol Journaling',
      'ancestors': 'Ancestral Remembrance and Gratitude',
    };

    const purposes = <String, String>{
      'prosperity': 'Reflect on resources, responsible choices, and one practical step toward greater stability.',
      'love': 'Cultivate respect, honest communication, compassion, and healthy relationships.',
      'protection': 'Reflect on personal boundaries, safety, clarity, and realistic protective actions.',
      'lunar': 'Use lunar symbolism as a framework for reflection, personal intentions, and meaningful action.',
      'dreams': 'Record dream details, explore personal associations, and distinguish reflection from prediction.',
      'ancestors': 'Remember people who shaped your life and identify values worth carrying forward.',
    };

    const affirmations = <String, String>{
      'prosperity': 'I act responsibly with my resources and build stability through consistent choices.',
      'love': 'I offer respect, communicate honestly, and honor the boundaries of others and myself.',
      'protection': 'I meet challenges with clarity and take practical steps to protect my well-being.',
      'lunar': 'I welcome change, set thoughtful intentions, and support them through action.',
      'dreams':
          'I approach my dreams with curiosity, reflection, and an open mind.',
      'ancestors': 'I honor those who came before me by carrying forward the lessons that serve life.',
    };

    const reflections = <String, String>{
      'prosperity': 'What resource can I manage more wisely, and what specific step will I take?',
      'love': 'What relationship would benefit from more honesty, care, or a clearer boundary?',
      'protection': 'What concern deserves attention, and what realistic action can I take?',
      'lunar': 'What intention matters most right now, and what is my next practical step?',
      'dreams': 'What details and emotions stood out, and what possible meanings can I explore?',
      'ancestors': 'Whom did I remember, what did I learn from them, and how can I honor that lesson?',
    };

    final focus = categoryFocus[category];
    if (focus == null) {
      throw ArgumentError.value(
        category,
        'category',
        'Unknown ritual category',
      );
    }
    if (!const ['daily', 'weekly', 'monthly'].contains(frequency)) {
      throw ArgumentError.value(frequency, 'frequency');
    }

    // Use one consistent composer for every ritual.
    final generatedSteps = AncientRitualComposer.compose(
      civilization: civilization,
      pathway: focus,
      date: date,
      frequency: frequency,
    );

    final tradition = civilization == 'egypt'
        ? 'Ancient Egyptian'
        : 'Ancient Chinese';

    final materials = <String>[
      "A quiet, comfortable space",
      "Journal or paper",
      "Pen",
      if (focus == "prosperity") ...[
        "Small bowl of clean water",
        "Coin, budget, or written financial goal (optional)",
      ],
      if (focus == "love") "Two flowers or small objects (optional; written qualities are an alternative)",
      if (focus == "protection") ...["Clean water", "Clean cloth or towel"],
      if (focus == "lunar") "Moon view or lunar calendar (optional; written reflection is an alternative)",
      if (focus == "dreams") "Dream journal or ordinary notebook",
      if (focus == "ancestors") "Photograph or keepsake (optional; written name or remembered story is an alternative)",
    ];
    final preparation = <String, String>{
      "prosperity": "PREPARATION: Set your journal and pen on a stable surface. Fill a small bowl with clean water to represent the Nile. Place a coin, budget, or written financial goal beside it if available. Otherwise, write down one resource you already have.",
      "love": "PREPARATION: Set out your journal and pen. Place two flowers or small objects side by side to symbolize mutual care, or write two qualities you value in a healthy relationship.",
      "protection": "PREPARATION: Gather clean water and a clean cloth. Wipe a small surface, wash or gently wipe your hands, and dry them before writing. This symbolic cleansing does not replace practical safety measures.",
      "lunar": "PREPARATION: Set out your journal and pen. Observe the Moon if visible, consult a lunar calendar, or write about a change occurring in your life. Outdoor observation is not required.",
      "dreams": "PREPARATION: Open your journal to a fresh page and write the date. Record a remembered dream and its emotions. If you remember no dream, write a recent thought or concern instead.",
      "ancestors": "PREPARATION: Place a photograph or keepsake nearby, write the name of someone you wish to remember, or recall a meaningful story. Keep your journal ready to record one memory or lesson.",
    };
    final invocations = <String, String>{
      "prosperity": "SPOKEN INVOCATION (modern composition): As the Nile nourished the land, may wisdom guide how I care for what I have. May I pursue prosperity without harming others, practice fairness in every exchange, and build stability through patient and responsible work. Let gratitude shape my choices and let my actions support a sustainable future.",
      "love": "SPOKEN INVOCATION (modern composition): May kindness guide my words and respect guide my actions. May I give care freely without seeking control, welcome affection without abandoning my boundaries, and recognize the dignity of every person. Let honesty, patience, and reciprocity strengthen the relationships I choose to nurture.",
      "protection": "SPOKEN INVOCATION (modern composition): May clarity steady my thoughts and courage support my decisions. May I recognize danger without surrendering to fear, honor my boundaries, and take wise steps toward safety. Let my words reflect truth, my actions reflect balance, and my choices protect the well-being of myself and others.",
      "lunar": "SPOKEN INVOCATION (modern composition): As the Moon moves through its changing phases, may I recognize the seasons of my own life. May I meet beginnings with purpose, uncertainty with patience, and endings with understanding. Let my intentions become practical actions and my reflections lead to meaningful growth.",
      "dreams": "SPOKEN INVOCATION (modern composition): May I approach the images of sleep with curiosity and discernment. Let me remember what I truly experienced, distinguish possibility from certainty, and seek wisdom without confusing symbols with proof. May reflection deepen my self-understanding and guide thoughtful choices in waking life.",
      "ancestors": "SPOKEN INVOCATION (modern composition): I remember those whose lives and teachings helped shape my path. May I honor their humanity, preserve what was wise, and learn from what was difficult. Let remembrance become compassion, gratitude become service, and the lessons of the past guide responsible action today.",
    };
    final closings = <String, String>{
      "prosperity": "CEREMONIAL CLOSING: Look at the bowl of water and acknowledge the resources supporting your life. Say: May gratitude accompany what I receive, fairness guide what I exchange, and wisdom guide what I preserve. Record your next financial action. Pour away the water respectfully and put the bowl away.",
      "love": "CEREMONIAL CLOSING: Look at your flowers, objects, or written qualities. Say: May my relationships be rooted in dignity, freely chosen affection, honesty, and mutual care. Record one act of kindness that respects your boundaries. Put your materials away.",
      "protection": "CEREMONIAL CLOSING: Place your clean cloth beside the water. Say: May clear judgment guide my steps, healthy boundaries protect my peace, and responsible action strengthen my safety. Record one practical protective measure. Put away your materials and leave the space clean.",
      "lunar": "CEREMONIAL CLOSING: Reflect on the Moon or the life transition you recorded. Say: I honor the changes behind me, the responsibilities before me, and the possibilities still unfolding. Write one next step and close your journal.",
      "dreams": "CEREMONIAL CLOSING: Read your dream notes without judgment. Say: I welcome insight with curiosity, examine meaning with care, and remain grounded in what I can know. Underline one useful reflection and close your notebook.",
      "ancestors": "CEREMONIAL CLOSING: Look at your keepsake or remembered name. Say: I carry forward what was wise, learn from what was difficult, and honor memory through compassionate action. Record one lesson to preserve and return your keepsake to its place if used.",
    };
    final weeklyObservances = <String, String>{
      "prosperity": "WEEKLY OBSERVANCE: Review seven days of spending, saving, giving, and obligations. Record one decision that supported stability and one that needs improvement. Choose a realistic financial action for the coming week.",
      "love": "WEEKLY OBSERVANCE: Reflect on how you offered and received care this week. Record one moment of healthy communication and one boundary worth strengthening. Choose a respectful act of appreciation.",
      "protection": "WEEKLY OBSERVANCE: Review your personal safety, privacy, and boundaries. Identify one precaution that worked and one vulnerability you can address. Write a practical safety action for the next seven days.",
      "lunar": "WEEKLY OBSERVANCE: Review how your intention developed during the past seven days. Note what changed, what remains unfinished, and one adjustment that better aligns your actions with your goals.",
      "dreams": "WEEKLY OBSERVANCE: Review your dream journal or reflection notes from the past week. Identify recurring emotions or themes without treating them as predictions. Write one question for further reflection.",
      "ancestors": "WEEKLY OBSERVANCE: Recall a family story, teaching, or memory. Write down one detail worth preserving and one constructive way to honor that lesson during the coming week.",
    };
    final monthlyObservances = <String, String>{
      "prosperity": "MONTHLY OBSERVANCE: Review your monthly income, expenses, responsibilities, and progress toward financial goals. Record three lessons and establish one measurable stewardship goal for the next month.",
      "love": "MONTHLY OBSERVANCE: Reflect on the relationships that shaped your month. Identify patterns of respect, communication, and reciprocity. Write one commitment that strengthens healthy connections while honoring boundaries.",
      "protection": "MONTHLY OBSERVANCE: Conduct a personal safety and boundaries review. Consider physical safety, digital privacy, and trusted support. Choose one realistic improvement and record when you will complete it.",
      "lunar": "MONTHLY OBSERVANCE: Review your intentions across the past lunar cycle or calendar month. Record what began, developed, and ended. Select one meaningful intention and three practical steps for the coming month.",
      "dreams": "MONTHLY OBSERVANCE: Read your dream and reflection notes from the past month. Compare recurring themes with ordinary life experiences. Record what you learned and one grounded question to explore next month.",
      "ancestors": "MONTHLY OBSERVANCE: Preserve one meaningful memory, family teaching, or historical detail in writing. Reflect on what should be carried forward and choose one act of remembrance or service for the coming month.",
    };
    final chineseProsperity = civilization == "china" && focus == "prosperity";
    final chineseProsperityPreparation =
        "PREPARATION: Place your journal and pen on a clear surface. Write down one resource you value and one responsibility requiring attention. Reflect on moderation and balance; no bowl of water or Nile symbolism is needed.";
    final chineseProsperityInvocation =
        "SPOKEN INVOCATION (modern Daoist-inspired composition): May I recognize when enough is enough, act without unnecessary force, and care wisely for the resources entrusted to me. May simplicity guide my choices, fairness guide my exchanges, and gratitude guide my daily work.";
    final chineseProsperityClosing =
        "CEREMONIAL CLOSING: Review the responsibility you recorded. Say: May I practice moderation, appreciate what sustains me, and act with care toward others. Record one achievable step, close your journal, and return your materials to their places.";
    final selectedMaterials = chineseProsperity
        ? <String>[
            "A quiet, comfortable space",
            "Journal or paper",
            "Pen",
            "Written financial goal or budget (optional)",
          ]
        : materials;
    final preparedSteps = <String>[
      for (final step in generatedSteps)
        if (step.startsWith("PREPARE:"))
          chineseProsperity ? chineseProsperityPreparation : preparation[focus]!
        else if (step.startsWith("SPEAK:"))
          chineseProsperity ? chineseProsperityInvocation : invocations[focus]!
        else if (step.startsWith("CLOSE:")) ...[
          if (frequency == "weekly") weeklyObservances[focus]!,
          if (frequency == "monthly") monthlyObservances[focus]!,
          chineseProsperity ? chineseProsperityClosing : closings[focus]!,
        ] else if (step.startsWith("WEEKLY REFLECTION:") ||
            step.startsWith("MONTHLY REFLECTION:"))
          ...[]
        else
          step,
    ];
    return DivineRitual(
      id:
          'genesis_${civilization}_composer'
          '_${frequency}_$focus',
      title: '$tradition ${titles[focus]}',
      category: category,
      purpose: purposes[focus]!,
      frequency: frequency,
      affirmation: affirmations[focus]!,
      materials: selectedMaterials,
      steps: preparedSteps,
      reflection: reflections[focus]!,
      durationMinutes: frequency == 'monthly'
          ? 20
          : frequency == 'weekly'
          ? 15
          : 10,
    );
  }
}
