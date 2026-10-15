import 'ancient_knowledge_v2.dart';
import 'ancient_ceremonial_intelligence.dart';

class AncientRitualComposer {
  static List<String> compose({
    required String civilization,
    required String pathway,
    required DateTime date,
    String frequency = 'daily',
  }) {
    final records = AncientKnowledgeV2.forPathway(civilization, pathway);
    if (records.isEmpty) {
      throw ArgumentError.value(
        pathway,
        'pathway',
        'No historical knowledge available',
      );
    }
    final record = records.first;
    final ceremony = AncientCeremonialIntelligence.generateSteps(
      civilization,
      pathway,
    );
    final dateLabel = date.toIso8601String().split('T').first;
    return [
      'CEREMONY DATE: $dateLabel',
      'TRADITION: ${record['tradition']}',
      'HISTORICAL FOUNDATION: ${record['historicalContext']}',
      'SOURCE: ${record['sourceReference']}',
      'PRACTICE TYPE: Modern guided adaptation; not a verbatim historical liturgy.',
      ...ceremony,
      if (frequency == 'weekly') 'WEEKLY REFLECTION: Review how your actions aligned with this teaching over the past week.',
      if (frequency == 'monthly') 'MONTHLY REFLECTION: Record what changed this month and identify a longer-term intention.',
    ];
  }
}
