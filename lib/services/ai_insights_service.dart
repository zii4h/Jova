import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/application.dart';
import '../models/ai_insight.dart';

/// Sends only the application fields needed for Jova's field analysis.
///
/// Gemini is never called directly from Flutter. The Gemini API key and
/// analysis instructions remain inside the Supabase Edge Function.
///
/// Company and role are included so an insight can identify a useful
/// application naturally. Recruiter information, notes, salary, URLs,
/// and other application details are not sent.
class AiInsightsService {
  static Future<AiInsight> analyze(
    List<JobApplication> applications,
  ) async {
    if (applications.isEmpty) {
      throw const AiInsightsException(
        'Log at least one application first.',
      );
    }

    final now = DateTime.now();
    final today = DateTime(
      now.year,
      now.month,
      now.day,
    );

    final sanitizedApplications = applications.map((app) {
      final appliedDate = DateTime(
        app.appliedDate.year,
        app.appliedDate.month,
        app.appliedDate.day,
      );

      final daysSinceApplied =
          today.difference(appliedDate).inDays;

      return {
        'company': app.company.trim(),
        'role': app.role.trim(),
        'status': app.status.label,
        'source': app.source.trim().isEmpty
            ? 'unspecified'
            : app.source.trim(),
        'daysSinceApplied':
            daysSinceApplied < 0 ? 0 : daysSinceApplied,
      };
    }).toList();

    try {
      final response =
          await Supabase.instance.client.functions.invoke(
        'analyze-applications',
        body: {
          'applications': sanitizedApplications,
        },
      );

      final data = response.data;

      if (data == null) {
        throw const AiInsightsException(
          'The analysis service returned no data.',
        );
      }

      if (data is Map && data['error'] != null) {
        throw AiInsightsException(
          data['error'].toString(),
        );
      }

      if (data is! Map) {
        throw const AiInsightsException(
          'The analysis service returned an unexpected response.',
        );
      }

      return AiInsight.fromJson(
        Map<String, dynamic>.from(data),
      );
    } on FunctionException catch (error) {
      throw AiInsightsException(
        'Field analysis failed (${error.status}). Try again.',
      );
    } on AiInsightsException {
      rethrow;
    } catch (_) {
      throw const AiInsightsException(
        'Could not run field analysis. '
        'Check your connection and try again.',
      );
    }
  }
}

class AiInsightsException implements Exception {
  final String message;

  const AiInsightsException(this.message);

  @override
  String toString() => message;
}