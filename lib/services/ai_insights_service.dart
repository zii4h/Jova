import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/application.dart';
import '../models/ai_insight.dart';
import '../config/env.dart';

/// Dev note:
/// Talks to the Gemini free-tier API to turn the raw application log into
/// a short "field analysis" — the AI reading the same file a human case
/// handler would, and saying what it actually means.
///
/// This is deliberately separate from AnalyticsScreen's funnel/source
/// math: those numbers are computed locally and are always correct by
/// construction. This service is interpretation layered on top of that
/// ground truth, called only when the user asks for it (never on a timer
/// or on screen load) so it never surprises anyone with a network call or
/// silently burns free-tier quota.
class AiInsightsService {
  static const _model = 'gemini-2.5-flash';

  static Uri get _endpoint => Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/$_model:generateContent');

  static Future<AiInsight> analyze(List<JobApplication> applications) async {
    if (!Env.hasGeminiKey) {
      throw const AiInsightsException(
        'No GEMINI_API_KEY found. Run the app with '
        '--dart-define=GEMINI_API_KEY=your_key to enable field analysis.',
      );
    }
    if (applications.isEmpty) {
      throw const AiInsightsException('Log at least one application first.');
    }

    final prompt = _buildPrompt(applications);

    late final http.Response response;
    try {
      response = await http
          .post(
            _endpoint,
            headers: {
              'Content-Type': 'application/json',
              'x-goog-api-key': Env.geminiApiKey,
            },
            body: jsonEncode({
              'contents': [
                {
                  'role': 'user',
                  'parts': [
                    {'text': prompt},
                  ],
                },
              ],
              'generationConfig': {
                'temperature': 0.6,
                'responseMimeType': 'application/json',
              },
            }),
          )
          .timeout(const Duration(seconds: 20));
    } catch (_) {
      throw const AiInsightsException(
          'Could not reach Gemini. Check your connection and try again.');
    }

    if (response.statusCode != 200) {
      throw AiInsightsException(
        'Gemini request failed (${response.statusCode}). ${_extractError(response.body)}',
      );
    }

    Map<String, dynamic> decoded;
    try {
      decoded = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (_) {
      throw const AiInsightsException('Gemini returned an unreadable response.');
    }

    final text = _extractText(decoded);
    if (text == null || text.trim().isEmpty) {
      throw const AiInsightsException('Gemini returned an empty analysis.');
    }

    try {
      final parsed = jsonDecode(text) as Map<String, dynamic>;
      return AiInsight.fromJson(parsed);
    } catch (_) {
      throw const AiInsightsException(
          'Gemini returned analysis in an unexpected shape. Try re-running.');
    }
  }

  static String? _extractText(Map<String, dynamic> decoded) {
    final candidates = decoded['candidates'] as List?;
    if (candidates == null || candidates.isEmpty) return null;
    final content = candidates.first['content'] as Map<String, dynamic>?;
    final parts = content?['parts'] as List?;
    if (parts == null || parts.isEmpty) return null;
    return parts.first['text'] as String?;
  }

  static String _extractError(String body) {
    try {
      final decoded = jsonDecode(body) as Map<String, dynamic>;
      return (decoded['error']?['message'] as String?) ?? body;
    } catch (_) {
      return body;
    }
  }

  static String _buildPrompt(List<JobApplication> applications) {
    final now = DateTime.now();
    final rows = applications.map((a) {
      final daysAgo = DateTime(now.year, now.month, now.day)
          .difference(DateTime(a.appliedDate.year, a.appliedDate.month, a.appliedDate.day))
          .inDays;
      final src = a.source.trim().isEmpty ? 'unspecified' : a.source.trim();
      return '- ${a.company} | ${a.role} | status: ${a.status.label} | '
          'source: $src | applied $daysAgo day(s) ago';
    }).join('\n');

    return '''
You are a blunt, practical career coach reviewing a job hunter's application log.
Below is their current tracker data, one line per application:

$rows

Write a short field analysis of their job search based ONLY on this data.
Do not invent companies, numbers, or events not in the log.
Be specific — reference actual company names, statuses, or timeframes where useful.
Keep it encouraging but honest; call out real problems (e.g. stale applications,
one-sided sourcing, silence after interview) if the data shows them.

Respond with ONLY minified JSON, no markdown fences, matching exactly this shape:
{"headline": "one sentence, at most 18 words, the single biggest takeaway",
 "observations": ["2 to 4 short specific observations, each at most 22 words"],
 "next_move": "one concrete, specific action to take next, at most 22 words"}
''';
  }
}

class AiInsightsException implements Exception {
  final String message;
  const AiInsightsException(this.message);
  @override
  String toString() => message;
}
