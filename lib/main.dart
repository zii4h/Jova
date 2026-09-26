import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'theme/field_log_theme.dart';
import 'models/application.dart';
import 'data/supabase_service.dart';
import 'widgets/floating_dock.dart';
import 'widgets/application_form_sheet.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/calendar_screen.dart';
import 'screens/analytics_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const supabaseUrl =
      String.fromEnvironment('SUPABASE_URL');

  const supabasePublishableKey =
      String.fromEnvironment(
    'SUPABASE_PUBLISHABLE_KEY',
  );

  if (supabaseUrl.isEmpty ||
      supabasePublishableKey.isEmpty) {
    throw Exception(
      'Missing Supabase environment variables. '
      'Run Jova with --dart-define-from-file=env.json',
    );
  }

  await Supabase.initialize(
    url: supabaseUrl,
    publishableKey: supabasePublishableKey,
  );

  runApp(const JovaApp());
}

class JovaApp extends StatelessWidget {
  const JovaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jova',
      debugShowCheckedModeBanner: false,
      theme: FieldLog.themeData(),
      home: const AuthGate(),
    );
  }
}

// ============================================================
// AUTH GATE
// ============================================================

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() =>
      _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final SupabaseClient _client =
      Supabase.instance.client;

  StreamSubscription<AuthState>?
      _authSubscription;

  Session? _session;

  @override
  void initState() {
    super.initState();

    _session = _client.auth.currentSession;

    _authSubscription =
        _client.auth.onAuthStateChange.listen(
      (data) {
        if (!mounted) return;

        setState(() {
          _session = data.session;
        });
      },
      onError: (error, stackTrace) {
        debugPrint(
          'Supabase auth state error: $error',
        );
      },
    );
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_session == null) {
      return const LoginScreen();
    }

    return HomeShell(
      key: ValueKey(_session!.user.id),
    );
  }
}

// ============================================================
// MAIN APP
// ============================================================

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() =>
      _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  final SupabaseService _supabase =
      SupabaseService();

  int _tabIndex = 0;

  List<JobApplication> _applications = [];

  List<ApplicationStatus> _stageOrder = [
    ApplicationStatus.applied,
    ApplicationStatus.screening,
    ApplicationStatus.interview,
    ApplicationStatus.offer,
    ApplicationStatus.rejected,
  ];

  Map<ApplicationStatus, String>
      _stageLabels = {
    for (final status
        in ApplicationStatus.values)
      status: status.label,
  };

  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final results = await Future.wait([
        _supabase.getApplications(),
        _supabase.getStages(),
      ]);

      final applications =
          results[0] as List<JobApplication>;

      final stages =
          results[1] as List<StageConfig>;

      if (!mounted) return;

      setState(() {
        _applications = applications;

        if (stages.isNotEmpty) {
          _stageOrder = stages
              .map(
                (stage) => stage.status,
              )
              .toList();

          _stageLabels = {
            for (final stage in stages)
              stage.status:
                  stage.displayName,
          };
        }

        _loading = false;
        _error = null;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _loading = false;
        _error = error.toString();
      });
    }
  }

  Future<void> _addApplication(
    JobApplication app,
  ) async {
    try {
      await _supabase.addApplication(app);

      if (!mounted) return;

      setState(() {
        _applications = [
          ..._applications,
          app,
        ];
      });
    } catch (error) {
      if (!mounted) return;

      _showError(
        'Could not save application.',
      );
    }
  }

  Future<void> _updateApplication(
    JobApplication app,
  ) async {
    try {
      await _supabase.updateApplication(app);

      if (!mounted) return;

      setState(() {
        _applications = _applications
            .map(
              (existing) =>
                  existing.id == app.id
                      ? app
                      : existing,
            )
            .toList();
      });
    } catch (error) {
      if (!mounted) return;

      _showError(
        'Could not update application.',
      );
    }
  }

  Future<void> _deleteApplication(
    String id,
  ) async {
    try {
      await _supabase.deleteApplication(id);

      if (!mounted) return;

      setState(() {
        _applications = _applications
            .where(
              (app) => app.id != id,
            )
            .toList();
      });
    } catch (error) {
      if (!mounted) return;

      _showError(
        'Could not delete application.',
      );
    }
  }

  Future<void> _updateStages(
    List<ApplicationStatus> order,
    Map<ApplicationStatus, String> labels,
  ) async {
    try {
      await _supabase.updateStages(
        order,
        labels,
      );

      if (!mounted) return;

      setState(() {
        _stageOrder =
            List<ApplicationStatus>.from(
          order,
        );

        _stageLabels =
            Map<ApplicationStatus, String>.from(
          labels,
        );
      });
    } catch (error) {
      if (!mounted) return;

      _showError(
        'Could not save stage changes.',
      );
    }
  }

  Future<void> _signOut() async {
    try {
      await Supabase.instance.client.auth
          .signOut();
    } catch (error) {
      if (!mounted) return;

      _showError(
        'Could not sign out.',
      );
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: FieldLog.bgPage,
        body: const Center(
          child: CircularProgressIndicator(
            color: FieldLog.textPrimary,
          ),
        ),
      );
    }

    if (_error != null) {
      return Scaffold(
        backgroundColor: FieldLog.bgPage,
        body: Center(
          child: Padding(
            padding:
                const EdgeInsets.all(24),
            child: Column(
              mainAxisSize:
                  MainAxisSize.min,
              children: [
                Text(
                  'Could not load Jova.',
                  style: FieldLog.display(
                    size: 18,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _error!,
                  textAlign:
                      TextAlign.center,
                  style: FieldLog.body(
                    size: 12,
                    color:
                        FieldLog.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _loading = true;
                      _error = null;
                    });

                    _loadData();
                  },
                  child:
                      const Text('Retry'),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: _signOut,
                  child:
                      const Text('Sign out'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final screens = [
      DashboardScreen(
        applications: _applications,
        stageOrder: _stageOrder,
        stageLabels: _stageLabels,
        onStagesChanged: _updateStages,
        onAdd: _addApplication,
        onUpdate: _updateApplication,
        onDelete: _deleteApplication,
      ),
      CalendarScreen(
        applications: _applications,
        onUpdate: _updateApplication,
      ),
      AnalyticsScreen(
        applications: _applications,
      ),
    ];

    return Scaffold(
      backgroundColor: FieldLog.bgPage,
      body: Stack(
        children: [
          IndexedStack(
            index: _tabIndex,
            children: screens,
          ),

          // Account
          Positioned(
            top: 18,
            right: 18,
            child: SafeArea(
              child: _AccountButton(
                onSignOut: _signOut,
              ),
            ),
          ),

          // Add application
          if (_tabIndex == 0)
            Positioned(
              right: 24,
              bottom: 96,
              child: _AddButton(
                onTap: () {
                  showApplicationFormSheet(
                    context,
                    onSave:
                        _addApplication,
                  );
                },
              ),
            ),

          // Navigation
          Align(
            alignment:
                Alignment.bottomCenter,
            child: FloatingDock(
              selectedIndex: _tabIndex,
              onSelect: (index) {
                setState(() {
                  _tabIndex = index;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// ACCOUNT BUTTON
// ============================================================

class _AccountButton extends StatelessWidget {
  final Future<void> Function() onSignOut;

  const _AccountButton({
    required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    final user =
        Supabase.instance.client.auth.currentUser;

    final email =
        user?.email ?? 'Account';

    return PopupMenuButton<String>(
      tooltip: 'Account',
      onSelected: (value) {
        if (value == 'logout') {
          onSignOut();
        }
      },
      color: FieldLog.surfaceCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          FieldLog.radiusCard,
        ),
        side: const BorderSide(
          color: FieldLog.border,
        ),
      ),
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          enabled: false,
          child: SizedBox(
            width: 210,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  email,
                  overflow: TextOverflow.ellipsis,
                  style: FieldLog.body(
                    size: 12,
                    color: FieldLog.textPrimary,
                    weight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Signed in with Google',
                  style: FieldLog.body(
                    size: 10,
                    color: FieldLog.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem<String>(
          value: 'logout',
          child: Row(
            children: [
              const Icon(
                Icons.logout_rounded,
                size: 17,
              ),
              const SizedBox(width: 10),
              Text(
                'Sign out',
                style: FieldLog.body(
                  size: 13,
                ),
              ),
            ],
          ),
        ),
      ],
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: FieldLog.surfaceCard,
          borderRadius:
              BorderRadius.circular(
            FieldLog.radiusControl,
          ),
          border: Border.all(
            color: FieldLog.border,
          ),
        ),
        alignment: Alignment.center,
        child: const Icon(
          Icons.person_outline_rounded,
          size: 19,
          color: FieldLog.textPrimary,
        ),
      ),
    );
  }
}

// ============================================================
// ADD BUTTON
// ============================================================

class _AddButton extends StatefulWidget {
  final VoidCallback onTap;

  const _AddButton({
    required this.onTap,
  });

  @override
  State<_AddButton> createState() =>
      _AddButtonState();
}

class _AddButtonState
    extends State<_AddButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor:
          SystemMouseCursors.click,
      onEnter: (_) {
        setState(() {
          _hovering = true;
        });
      },
      onExit: (_) {
        setState(() {
          _hovering = false;
        });
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(
            milliseconds: 120,
          ),
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: _hovering
                ? FieldLog.textPrimary
                : FieldLog.bgPage,
            borderRadius:
                BorderRadius.circular(
              FieldLog.radiusCard,
            ),
            border: Border.all(
              color:
                  FieldLog.textPrimary,
              width: 2,
            ),
            boxShadow: _hovering
                ? const [
                    BoxShadow(
                      color:
                          Color(0x33000000),
                      blurRadius: 8,
                      offset:
                          Offset(0, 2),
                    ),
                  ]
                : const [],
          ),
          alignment: Alignment.center,
          child: Icon(
            Icons.add_rounded,
            size: 26,
            color: _hovering
                ? FieldLog.bgPage
                : FieldLog.textPrimary,
          ),
        ),
      ),
    );
  }
}