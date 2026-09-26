import 'dart:async';

import 'package:flutter/material.dart';

import '../models/application.dart';
import '../models/ai_insight.dart';
import '../services/ai_insights_service.dart';
import '../theme/field_log_theme.dart';

/// Body content for the "AI Insights & Recommendations" section.
///
/// Analysis is generated only when the user explicitly requests it.
/// This widget owns the idle, loading, ready, and error states.
class FieldMemoCard extends StatefulWidget {
  final List<JobApplication> applications;

  const FieldMemoCard({super.key, required this.applications});

  @override
  State<FieldMemoCard> createState() => _FieldMemoCardState();
}

enum _MemoState { idle, loading, ready, error }

class _FieldMemoCardState extends State<FieldMemoCard> {
  _MemoState _state = _MemoState.idle;
  AiInsight? _insight;
  String? _error;

  Future<void> _run() async {
    setState(() {
      _state = _MemoState.loading;
      _error = null;
    });

    try {
      final result = await AiInsightsService.analyze(widget.applications);

      if (!mounted) return;

      setState(() {
        _insight = result;
        _state = _MemoState.ready;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = e.toString();
        _state = _MemoState.error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (_state) {
      case _MemoState.idle:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'have the analyst take a pass over your log — reads the same '
              'data as the charts above and looks for patterns worth acting on.',
              style: FieldLog.body(size: 13, color: FieldLog.textSecondary),
            ),
            const SizedBox(height: 12),
            _RunButton(label: 'run field analysis', onTap: _run),
          ],
        );

      case _MemoState.loading:
        return const _TypingIndicator();

      case _MemoState.error:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _error ?? 'something went wrong.',
              style: FieldLog.mono(size: 12, color: FieldLog.stageRejected),
            ),
            const SizedBox(height: 12),
            _RunButton(label: 'try again', onTap: _run),
          ],
        );

      case _MemoState.ready:
        final insight = _insight!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(insight.headline, style: FieldLog.display(size: 15)),

            const SizedBox(height: 12),

            ...insight.observations.map(
              (observation) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '• ',
                      style: FieldLog.body(
                        size: 13,
                        color: FieldLog.textPrimary,
                        weight: FontWeight.w600,
                      ),
                    ),
                    Expanded(
                      child: Text(observation, style: FieldLog.body(size: 13)),
                    ),
                  ],
                ),
              ),
            ),

            if (insight.nextMove.isNotEmpty) ...[
              const SizedBox(height: 6),

              Container(height: 1, color: FieldLog.border),

              const SizedBox(height: 12),

              Text(
                '⭐ NEXT MOVE:',
                style: FieldLog.body(size: 11, weight: FontWeight.w700),
              ),

              const SizedBox(height: 5),

              Text(
                insight.nextMove,
                style: FieldLog.body(size: 13, weight: FontWeight.w500),
              ),
            ],

            const SizedBox(height: 14),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _timestamp(insight.generatedAt),
                  style: FieldLog.mono(size: 10, color: FieldLog.textSecondary),
                ),
                _RunButton(label: 're-run', onTap: _run, compact: true),
              ],
            ),
          ],
        );
    }
  }

  String _timestamp(DateTime d) {
    String two(int n) => n.toString().padLeft(2, '0');

    return 'filed ${two(d.hour)}:${two(d.minute)}';
  }
}

class _RunButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool compact;

  const _RunButton({
    required this.label,
    required this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 10 : 14,
            vertical: compact ? 6 : 10,
          ),
          decoration: BoxDecoration(
            color: FieldLog.textPrimary,
            borderRadius: BorderRadius.circular(FieldLog.radiusControl),
          ),
          child: Text(
            label,
            style: FieldLog.mono(
              size: compact ? 10 : 12,
              color: FieldLog.bgPage,
            ),
          ),
        ),
      ),
    );
  }
}

/// Typewriter-style loading state.
class _TypingIndicator extends StatefulWidget {
  const _TypingIndicator();

  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator> {
  late final Timer _timer;
  int _dots = 0;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(milliseconds: 420), (_) {
      if (!mounted) return;

      setState(() {
        _dots = (_dots + 1) % 4;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dots = '.' * _dots;

    return Text(
      'reading the log$dots',
      style: FieldLog.mono(size: 12, color: FieldLog.textSecondary),
    );
  }
}
