import 'package:flutter/material.dart';

import '../models/application.dart';
import '../theme/field_log_theme.dart';
import '../widgets/field_memo_card.dart';
import '../widgets/collapsible_section.dart';

class AnalyticsScreen extends StatelessWidget {
  final List<JobApplication> applications;

  const AnalyticsScreen({
    super.key,
    required this.applications,
  });

  int _reachedApplied() => applications.length;

  int _reachedScreening() => applications
      .where(
        (a) => [
          ApplicationStatus.screening,
          ApplicationStatus.interview,
          ApplicationStatus.offer,
        ].contains(a.status),
      )
      .length;

  int _reachedInterview() => applications
      .where(
        (a) => [
          ApplicationStatus.interview,
          ApplicationStatus.offer,
        ].contains(a.status),
      )
      .length;

  int _reachedOffer() => applications
      .where(
        (a) => a.status == ApplicationStatus.offer,
      )
      .length;

  int _rejected() => applications
      .where(
        (a) => a.status == ApplicationStatus.rejected,
      )
      .length;

  Map<String, int> _sourceBreakdown() {
    final map = <String, int>{};

    for (final app in applications) {
      final key = app.source.trim().isEmpty
          ? 'unspecified'
          : app.source.trim();

      map[key] = (map[key] ?? 0) + 1;
    }

    return map;
  }

  double _avgDaysSinceApplied() {
    if (applications.isEmpty) return 0;

    final now = DateTime.now();
    final today = DateTime(
      now.year,
      now.month,
      now.day,
    );

    final totalDays = applications
        .map(
          (app) => today
              .difference(
                DateTime(
                  app.appliedDate.year,
                  app.appliedDate.month,
                  app.appliedDate.day,
                ),
              )
              .inDays,
        )
        .fold<int>(
          0,
          (a, b) => a + b,
        );

    return totalDays / applications.length;
  }

  @override
  Widget build(BuildContext context) {
    final total = applications.length;

    final funnel = [
      (
        'Applied',
        _reachedApplied(),
        FieldLog.stageApplied,
      ),
      (
        'Screening',
        _reachedScreening(),
        FieldLog.stageScreening,
      ),
      (
        'Interview',
        _reachedInterview(),
        FieldLog.stageInterview,
      ),
      (
        'Offer',
        _reachedOffer(),
        FieldLog.stageOffer,
      ),
    ];

    final maxCount = total == 0 ? 1 : total;

    final sources = _sourceBreakdown();

    final maxSource = sources.values.isEmpty
        ? 1
        : sources.values.reduce(
            (a, b) => a > b ? a : b,
          );

    final interviewRate = total == 0
        ? 0.0
        : _reachedInterview() / total * 100;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          18,
          24,
          18,
          100,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Analytics',
              style: FieldLog.display(
                size: 22,
              ),
            ),

            const SizedBox(height: 10),

            Container(
              height: 1.5,
              color: FieldLog.border,
            ),

            const SizedBox(height: 18),

            Text(
              'overview',
              style: FieldLog.mono(
                size: 11,
                weight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _StatTile(
                    label: 'logged',
                    value: '$total',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _StatTile(
                    label: 'interviewing',
                    value: '${_reachedInterview()}',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _StatTile(
                    label: 'offers',
                    value: '${_reachedOffer()}',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _StatTile(
                    label: 'rejected',
                    value: '${_rejected()}',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: _StatTile(
                    label: 'interview rate',
                    value: total == 0
                        ? '—'
                        : '${interviewRate.toStringAsFixed(0)}%',
                    wide: true,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _StatTile(
                    label: 'avg. days open',
                    value: total == 0
                        ? '—'
                        : _avgDaysSinceApplied()
                            .toStringAsFixed(0),
                    wide: true,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 26),

            Text(
              'conversion funnel',
              style: FieldLog.mono(
                size: 11,
                weight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 12),

            if (total == 0)
              Text(
                'log an application to see the funnel',
                style: FieldLog.mono(
                  size: 12,
                ),
              )
            else
              ...funnel.map(
                (item) {
                  final (label, count, color) = item;

                  final fraction =
                      count / maxCount;

                  return Padding(
                    padding:
                        const EdgeInsets.only(
                      bottom: 12,
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,
                          children: [
                            Text(
                              label,
                              style: FieldLog.body(
                                size: 13,
                                weight:
                                    FontWeight.w500,
                              ),
                            ),
                            Text(
                              '$count',
                              style: FieldLog.mono(
                                size: 12,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 4),

                        LayoutBuilder(
                          builder:
                              (context, constraints) {
                            return Stack(
                              children: [
                                Container(
                                  height: 16,
                                  width: constraints
                                      .maxWidth,
                                  decoration:
                                      BoxDecoration(
                                    color: FieldLog
                                        .surfaceCard,
                                    border:
                                        Border.all(
                                      color:
                                          FieldLog
                                              .border,
                                    ),
                                    borderRadius:
                                        BorderRadius
                                            .circular(
                                      FieldLog
                                          .radiusControl,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 16,
                                  width: constraints
                                          .maxWidth *
                                      fraction,
                                  decoration:
                                      BoxDecoration(
                                    color: color,
                                    borderRadius:
                                        BorderRadius
                                            .circular(
                                      FieldLog
                                          .radiusControl,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),

            if (total > 0) ...[
              const SizedBox(height: 4),
              Text(
                '${_rejected()} of $total marked rejected along the way',
                style: FieldLog.mono(
                  size: 11,
                  color: FieldLog.textSecondary,
                ),
              ),
            ],

            const SizedBox(height: 26),

            Text(
              'source breakdown',
              style: FieldLog.mono(
                size: 11,
                weight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 12),

            if (sources.isEmpty)
              Text(
                'no sources logged yet',
                style: FieldLog.mono(
                  size: 12,
                ),
              )
            else
              ...sources.entries.map(
                (entry) {
                  final fraction =
                      entry.value / maxSource;

                  return Padding(
                    padding:
                        const EdgeInsets.only(
                      bottom: 10,
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 90,
                          child: Text(
                            entry.key,
                            style: FieldLog.mono(
                              size: 12,
                            ),
                            overflow:
                                TextOverflow.ellipsis,
                          ),
                        ),

                        Expanded(
                          child: LayoutBuilder(
                            builder:
                                (context, constraints) {
                              return Align(
                                alignment:
                                    Alignment.centerLeft,
                                child: Container(
                                  height: 10,
                                  width: constraints
                                          .maxWidth *
                                      fraction,
                                  decoration:
                                      BoxDecoration(
                                    color: FieldLog
                                        .stageInterview,
                                    borderRadius:
                                        BorderRadius
                                            .circular(
                                      FieldLog
                                          .radiusControl,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(width: 8),

                        Text(
                          '${entry.value}',
                          style: FieldLog.mono(
                            size: 11,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

            const SizedBox(height: 26),

            CollapsibleSection(
              title: 'AI Insights & Recommendations',
              accentColor:
                  FieldLog.stageInterview,
              child: FieldMemoCard(
                applications: applications,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final bool wide;

  const _StatTile({
    required this.label,
    required this.value,
    this.wide = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: wide ? 14 : 10,
        vertical: wide ? 14 : 12,
      ),
      decoration: BoxDecoration(
        color: FieldLog.surfaceCard,
        border: Border.all(
        color: FieldLog.textPrimary.withValues(alpha: 0.35),
        width: 1,
      ),
        borderRadius: BorderRadius.circular(
          FieldLog.radiusCard,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: FieldLog.display(
              size: wide ? 20 : 18,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: FieldLog.mono(
              size: 10,
              color: FieldLog.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}