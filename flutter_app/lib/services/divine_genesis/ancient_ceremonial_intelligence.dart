import 'ancient_civilization_vault.dart';

class AncientCeremonialIntelligence {
  static List<String> generateSteps(String civilization, String focus) {
    final egypt = civilization == 'egypt';
    if (!egypt && civilization != 'china') {
      throw ArgumentError.value(civilization);
    }
    if (egypt) {
      const pathways = <String, List<String>>{
        'prosperity': [
          'Prepare a clean space and place a small bowl of water as a symbol of the Nile and renewal.',
          'Study Hapi and the importance of the Nile inundation to agricultural abundance.',
          'Reflect on Ma’at: prosperity should be pursued through fair dealing and responsibility.',
          'Name a resource you can steward more wisely.',
          'Write one concrete action toward sustainable prosperity.',
          'Close with gratitude for the resources that support life.',
        ],
        'love': [
          'Prepare a peaceful space and consider the symbolism of Hathor.',
          'Reflect on Hathor as a goddess associated with music, celebration, affection, and joy.',
          'Consider how mutual respect and honest communication sustain relationships.',
          'Write down one quality you wish to cultivate in your relationships.',
          'Choose one respectful action that expresses care without attempting to control another person.',
          'Close with appreciation for companionship and community.',
        ],
        'lunar': [
          'Observe the current Moon phase if it is visible, or consult the lunar calendar.',
          'Study Khonsu and Thoth in relation to lunar symbolism and timekeeping.',
          'Reflect on how ancient Egyptian calendars organized religious and seasonal life.',
          'Choose a personal intention appropriate to your present circumstances.',
          'Record a practical step toward that intention.',
          'Close by acknowledging change and the passage of time.',
        ],
        'dreams': [
          'Prepare a journal before sleeping or reviewing a recent dream.',
          'Consider the documented importance of dreams and their interpretation in ancient Egypt.',
          'Reflect on the relationship between Thoth, writing, and knowledge.',
          'Record the dream carefully without assuming every symbol predicts an event.',
          'Identify possible personal meanings and distinguish them from historical interpretations.',
          'Close with a question for further reflection rather than a claim of certainty.',
        ],
        'ancestors': [
          'Prepare a respectful remembrance space with a meaningful keepsake if available.',
          'Study Egyptian remembrance traditions and the concept of the akh.',
          'Recall a person whose actions or teachings influenced your life.',
          'Speak or write their name if you wish.',
          'Consider a value worth carrying into your own actions.',
          'Close with a moment of gratitude and remembrance.',
        ],
      };
      final pathway = pathways[focus];
      if (pathway != null) {
        return _complete(civilization, focus, pathway);
      }
      if (focus == 'protection') {
        return _complete(civilization, focus, [
          'Prepare a clean space and wash your hands as a symbolic purification.',
          'Study the protective symbolism of the Eye of Horus.',
          'Reflect on Heka as sacred speech and ritual action.',
          'Speak a personal intention for protection and balance.',
          'Close by reflecting on Maat and right conduct.',
        ]);
      }
      if (focus == 'solar') {
        return [
          'Welcome the daylight and reflect on the solar journey of Ra.',
          'Consider renewal and the restoration of cosmic order.',
          'Name three things for which you are grateful.',
          'Choose one action aligned with truth and balance.',
        ];
      }
      return [
        'Prepare a quiet space for reflection.',
        'Consider Egyptian traditions of remembrance and offerings.',
        'Honor the memory of those who shaped your life.',
        'Record one lesson you wish to carry forward.',
      ];
    }
    const chinesePathways = <String, List<String>>{
      'prosperity': [
        'Prepare a quiet space and consider the Five Phases as a framework of changing relationships.',
        'Reflect on how resources circulate through work, community, and nature.',
        'Consider the importance of moderation and responsible stewardship.',
        'Identify one financial or practical responsibility requiring attention.',
        'Choose a concrete action that supports sustainable well-being.',
        'Close with gratitude rather than promises of supernatural wealth.',
      ],
      'love': [
        'Prepare a calm space for reflection on relationships.',
        'Consider the Confucian concepts of ren, humaneness, and li, appropriate conduct.',
        'Reflect on reciprocity, trust, and responsibility in relationships.',
        'Identify a relationship where clearer communication may help.',
        'Choose one respectful action without attempting to control another person.',
        'Close by considering how your conduct contributes to harmony.',
      ],
      'protection': [
        'Prepare a clean and orderly space as a modern symbolic purification.',
        'Study the historical diversity of Daoist purification and protective traditions.',
        'Consider the importance of ethical conduct and personal boundaries.',
        'Name a practical safety concern that deserves attention.',
        'Choose one realistic protective action you can take.',
        'Close with a moment of calm and clarity.',
      ],
      'lunar': [
        'Consult the current lunar date or observe the Moon when visible.',
        'Reflect on the relationship between lunar months and seasonal observances in Chinese calendrical traditions.',
        'Consider how cycles of change appear in the Yijing and classical cosmology.',
        'Record an intention suited to your present season of life.',
        'Choose one practical action aligned with that intention.',
        'Close by acknowledging change and continuity.',
      ],
      'dreams': [
        'Prepare a journal and record a recent dream as accurately as possible.',
        'Consider the butterfly dream in the Zhuangzi as a philosophical reflection on perception.',
        'Distinguish philosophical interpretation from claims of supernatural prediction.',
        'Reflect on the emotions and questions raised by the dream.',
        'Write one insight worth examining in waking life.',
        'Close without treating the dream as certain evidence of future events.',
      ],
      'ancestors': [
        'Prepare a respectful space with a photograph or keepsake if desired.',
        'Reflect on the long history of ancestral veneration in Chinese traditions.',
        'Recall a person whose teachings or actions shaped your life.',
        'Express remembrance through words, writing, or a symbolic gesture.',
        'Consider a responsibility or value you wish to carry forward.',
        'Close with gratitude and respect.',
      ],
    };
    final chinesePathway = chinesePathways[focus];
    if (chinesePathway != null) {
      return _complete(civilization, focus, chinesePathway);
    }
    if (focus == 'five_phases') {
      return [
        'Reflect on Wood, Fire, Earth, Metal, and Water as interacting processes.',
        'Consider which qualities need balance in your present circumstances.',
        'Write one practical action that supports harmony.',
      ];
    }
    if (focus == 'ancestors') {
      return [
        'Prepare a respectful space for remembrance.',
        'Reflect on Chinese traditions of ancestral veneration.',
        'Recall a lesson or value passed down through generations.',
        'Close with gratitude and respectful reflection.',
      ];
    }
    return [
      'Find a quiet place for contemplation.',
      'Reflect on the Daoist principle of harmony with natural processes.',
      'Observe your breathing without forcing it.',
      'Consider one simple action that reduces unnecessary struggle.',
    ];
  }

  static List<String> _complete(
    String civilization,
    String focus,
    List<String> sourceSteps,
  ) {
    const intentions = <String, String>{
      "prosperity": "May I use my resources wisely and build stability through responsible action.",
      "love": "May I act with compassion, honesty, reciprocity, and respect for every person.",
      "protection": "May I meet challenges with clear judgment, healthy boundaries, and practical care.",
      "lunar": "May I accept change with patience and turn thoughtful intentions into action.",
      "dreams": "May I approach dreams with curiosity, discernment, and an open mind.",
      "ancestors": "May I honor those who came before me by carrying forward the lessons that serve life.",
    };
    final steps = <String>[
      "PREPARE: Find a quiet, comfortable space and gather the optional materials listed for this practice.",
      "OPEN: Settle comfortably, breathe naturally, and name the intention you bring to this spiritual practice.",
      ...sourceSteps,
      "SPEAK: ${intentions[focus] ?? "May I act with wisdom, care, and clarity."}",
      "COMMIT: Choose one respectful, practical action that reflects your intention and decide when to take it.",
      "CLOSE: Take a quiet moment of gratitude, record your intention, and end the practice when you feel ready.",
    ];
    return List<String>.unmodifiable(steps);
  }

  static String historicalContext(String civilization) {
    final entries = AncientCivilizationVault.forCivilization(civilization);
    return entries.map((entry) => entry['teaching'] ?? '').join(' ');
  }
}
