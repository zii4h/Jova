/// Dev note:
/// Structured shape for a single AI-generated field analysis. Kept separate
/// from JobApplication since this is derived commentary, not source data —
/// it's never persisted, just regenerated on demand from whatever the
/// tracker currently looks like.
class AiInsight {
  final String headline;
  final List<String> observations;
  final String nextMove;
  final DateTime generatedAt;

  AiInsight({
    required this.headline,
    required this.observations,
    required this.nextMove,
    required this.generatedAt,
  });

  factory AiInsight.fromJson(Map<String, dynamic> json) {
    return AiInsight(
      headline: (json['headline'] as String?)?.trim().isNotEmpty == true
          ? (json['headline'] as String).trim()
          : 'No clear read on the data yet.',
      observations: (json['observations'] as List?)
              ?.map((e) => e.toString().trim())
              .where((s) => s.isNotEmpty)
              .toList() ??
          const [],
      nextMove: (json['next_move'] as String?)?.trim() ?? '',
      generatedAt: DateTime.now(),
    );
  }
}
