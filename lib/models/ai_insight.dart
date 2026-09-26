/// Structured result returned by Jova's field analysis.
///
/// This is derived commentary and is never persisted.
/// It is regenerated on demand from the user's current application data.
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
    final rawHeadline = json['headline']?.toString().trim() ?? '';
    final rawNextMove = json['next_move']?.toString().trim() ?? '';

    final observations = (json['observations'] as List?)
            ?.map((item) => item.toString().trim())
            .where((item) => item.isNotEmpty)
            .take(4)
            .toList() ??
        <String>[];

    return AiInsight(
      headline: rawHeadline.isNotEmpty
          ? rawHeadline
          : 'No clear read on the data yet.',
      observations: observations,
      nextMove: rawNextMove,
      generatedAt: DateTime.now(),
    );
  }
}