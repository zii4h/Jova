import 'package:flutter/material.dart';
import 'theme/field_log_theme.dart';
import 'models/application.dart';
import 'data/mock_applications.dart';
import 'widgets/floating_dock.dart';
import 'widgets/application_form_sheet.dart';
import 'screens/dashboard_screen.dart';
import 'screens/calendar_screen.dart';
import 'screens/analytics_screen.dart';

void main() {
  runApp(const JecordApp());
}

class JecordApp extends StatelessWidget {
  const JecordApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jecord',
      debugShowCheckedModeBanner: false,
      theme: FieldLog.themeData(),
      home: const HomeShell(),
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _tabIndex = 0;
  late List<JobApplication> _applications;

  @override
  void initState() {
    super.initState();

    // Dev note: Seed data, will swap this for a real Supabase read once that's wired in.

    _applications = buildMockApplications();
  }

  void _addApplication(JobApplication app) {
    setState(() => _applications = [..._applications, app]);
  }

  void _updateApplication(JobApplication app) {
    setState(() {
      _applications = _applications.map((a) => a.id == app.id ? app : a).toList();
    });
  }

  void _deleteApplication(String id) {
    setState(() {
      _applications = _applications.where((a) => a.id != id).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      DashboardScreen(
        applications: _applications,
        onAdd: _addApplication,
        onUpdate: _updateApplication,
        onDelete: _deleteApplication,
      ),
      CalendarScreen(applications: _applications, onUpdate: _updateApplication),
      AnalyticsScreen(applications: _applications),
    ];

    return Scaffold(
      backgroundColor: FieldLog.bgPage,
      body: Stack(
        children: [
          IndexedStack(index: _tabIndex, children: screens),
          if (_tabIndex == 0)
            Positioned(
              right: 24,
              bottom: 96,
              child: _AddButton(
                onTap: () => showApplicationFormSheet(context, onSave: _addApplication),
              ),
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child: FloatingDock(
              selectedIndex: _tabIndex,
              onSelect: (i) => setState(() => _tabIndex = i),
            ),
          ),
        ],
      ),
    );
  }
}

/// Dev note:
/// Container wrapping Text('+') centered by `alignment: center` 

class _AddButton extends StatefulWidget {
  final VoidCallback onTap;
  const _AddButton({required this.onTap});

  @override
  State<_AddButton> createState() => _AddButtonState();
}

class _AddButtonState extends State<_AddButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: _hovering ? FieldLog.textPrimary : FieldLog.bgPage,
            shape: BoxShape.circle,
            border: Border.all(color: FieldLog.textPrimary, width: 2),
            boxShadow: _hovering
                ? const [BoxShadow(color: Color(0x33000000), blurRadius: 8, offset: Offset(0, 2))]
                : const [],
          ),
          alignment: Alignment.center,
          child: Icon(
            Icons.add_rounded,
            size: 26,
            color: _hovering ? FieldLog.bgPage : FieldLog.textPrimary,
          ),
        ),
      ),
    );
  }
}
