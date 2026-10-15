class AncientCivilizationVault {
  static const List<Map<String, String>> entries = [
    {
      'civilization': 'egypt',
      'key': 'maat',
      'title': 'Maat and Cosmic Order',
      'teaching': 'Truth, justice, balance, and right conduct were central to Egyptian religious and ethical thought.',
      'sources': 'Instructions of Ptahhotep; Book of the Dead, Spell 125',
    },
    {
      'civilization': 'egypt',
      'key': 'heka',
      'title': 'Heka and Sacred Speech',
      'teaching': 'Heka was understood as a divine force connected with ritual action, spoken formulas, and protection.',
      'sources': 'Coffin Texts; Egyptian magical papyri',
    },
    {
      'civilization': 'egypt',
      'key': 'solar',
      'title': 'Solar Renewal',
      'teaching': 'The daily solar journey of Ra expressed cosmic renewal and the maintenance of order.',
      'sources': 'Amduat; Book of Gates',
    },
    {
      'civilization': 'egypt',
      'key': 'protection',
      'title': 'Protective Symbolism',
      'teaching': 'The Eye of Horus and protective amulets were associated with restoration, safeguarding, and well-being.',
      'sources': 'Egyptian amulets; Book of the Dead',
    },
    {
      'civilization': 'egypt',
      'key': 'ancestral',
      'title': 'Ancestors and the Akh',
      'teaching': 'Egyptian mortuary traditions included remembrance, offerings, and concepts of transformed existence.',
      'sources': 'Pyramid Texts; Coffin Texts',
    },
    {
      'civilization': 'china',
      'key': 'dao',
      'title': 'Dao and Natural Harmony',
      'teaching': 'Classical Daoist thought explores the Dao, non-forcing, simplicity, and alignment with natural processes.',
      'sources': 'Dao De Jing; Zhuangzi',
    },
    {
      'civilization': 'china',
      'key': 'yijing',
      'title': 'Changes and Cycles',
      'teaching': 'The Yijing explores patterns of change through hexagrams and interpretive traditions.',
      'sources': 'Yijing',
    },
    {
      'civilization': 'china',
      'key': 'ancestors',
      'title': 'Ancestral Veneration',
      'teaching': 'Ancestral remembrance and offerings have long histories in Chinese religious and family traditions.',
      'sources': 'Shang oracle-bone inscriptions; later ritual texts',
    },
    {
      'civilization': 'china',
      'key': 'five_phases',
      'title': 'Five Phases',
      'teaching': 'Wood, Fire, Earth, Metal, and Water describe interacting processes in classical Chinese cosmology.',
      'sources': 'Classical wuxing traditions',
    },
    {
      'civilization': 'china',
      'key': 'ritual',
      'title': 'Daoist Ceremonial Traditions',
      'teaching': 'Daoist ritual traditions include offerings, liturgy, purification, and talismanic practices that vary by lineage.',
      'sources': 'Daoist ritual literature and historical studies',
    },
  ];
  static List<Map<String, String>> forCivilization(String civilization) =>
      entries.where((entry) => entry['civilization'] == civilization).toList();
  static Map<String, String>? find(String key) {
    for (final entry in entries) {
      if (entry['key'] == key) return entry;
    }
    return null;
  }
}
