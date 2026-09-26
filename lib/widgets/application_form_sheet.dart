import 'package:flutter/material.dart';

import '../models/application.dart';
import '../theme/field_log_theme.dart';

Future<void> showApplicationFormSheet(
  BuildContext context, {
  JobApplication? existing,
  ApplicationStatus? initialStatus,
  required void Function(JobApplication) onSave,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: FieldLog.bgPage,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(
          FieldLog.radiusLarge,
        ),
      ),
    ),
    builder: (ctx) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(ctx).viewInsets.bottom,
      ),
      child: _ApplicationForm(
        existing: existing,
        initialStatus: initialStatus,
        onSave: onSave,
      ),
    ),
  );
}

class _ApplicationForm extends StatefulWidget {
  final JobApplication? existing;
  final ApplicationStatus? initialStatus;
  final void Function(JobApplication) onSave;

  const _ApplicationForm({
    this.existing,
    this.initialStatus,
    required this.onSave,
  });

  @override
  State<_ApplicationForm> createState() => _ApplicationFormState();
}

class _ApplicationFormState extends State<_ApplicationForm> {
  int _tab = 0;

  String _currency = 'PHP';

static const List<String> _currencies = [
  'PHP',
  'USD',
  'EUR',
  'GBP',
  'JPY',
  'AUD',
  'CAD',
  'SGD',
];

  late final TextEditingController _company;
  late final TextEditingController _role;
  late final TextEditingController _source;
  late final TextEditingController _location;
  late final TextEditingController _jobType;
  late final TextEditingController _salary;
  late final TextEditingController _description;
  late final TextEditingController _recruiterName;
  late final TextEditingController _recruiterEmail;
  late final TextEditingController _recruiterLinkedIn;
  late final TextEditingController _notes;

  late DateTime _date;
  DateTime? _lastContacted;
  late ApplicationStatus _status;

  @override
  void initState() {
    super.initState();

    final e = widget.existing;

    _company = TextEditingController(text: e?.company ?? '');
    _role = TextEditingController(text: e?.role ?? '');
    _source = TextEditingController(text: e?.source ?? '');
    _location = TextEditingController(text: e?.location ?? '');
    _jobType = TextEditingController(text: e?.jobType ?? '');
    _salary = TextEditingController(text: e?.salary ?? '');
    _description = TextEditingController(text: e?.description ?? '');

    _recruiterName = TextEditingController(text: e?.recruiterName ?? '');
    _recruiterEmail = TextEditingController(text: e?.recruiterEmail ?? '');
    _recruiterLinkedIn = TextEditingController(
      text: e?.recruiterLinkedIn ?? '',
    );
    _notes = TextEditingController(text: e?.notes ?? '');

    _date = e?.appliedDate ?? DateTime.now();
    _lastContacted = e?.lastContacted;
    _status = e?.status ?? widget.initialStatus ?? ApplicationStatus.applied;
  }

  @override
  void dispose() {
    _company.dispose();
    _role.dispose();
    _source.dispose();
    _location.dispose();
    _jobType.dispose();
    _salary.dispose();
    _description.dispose();
    _recruiterName.dispose();
    _recruiterEmail.dispose();
    _recruiterLinkedIn.dispose();
    _notes.dispose();

    super.dispose();
  }

  InputDecoration _decoration(String label) {
    return InputDecoration(
      labelText: label,

      labelStyle: FieldLog.body(size: 12, color: FieldLog.textSecondary),

      floatingLabelStyle: FieldLog.body(
        size: 12,
        color: FieldLog.textPrimary,
        weight: FontWeight.w500,
      ),

      filled: true,
      fillColor: FieldLog.surfaceCard,

      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),

      // Important:
      // Explicit borders keep the input boxes visible in every state.
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(FieldLog.radiusControl),
        borderSide: const BorderSide(color: FieldLog.borderStrong, width: 1),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(FieldLog.radiusControl),
        borderSide: const BorderSide(color: FieldLog.borderStrong, width: 1),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(FieldLog.radiusControl),
        borderSide: const BorderSide(color: FieldLog.textPrimary, width: 1.4),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() => _date = picked);
    }
  }

  Future<void> _pickLastContacted() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _lastContacted ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() => _lastContacted = picked);
    }
  }

  bool get _canSubmit =>
      _company.text.trim().isNotEmpty && _role.text.trim().isNotEmpty;

  void _submit() {
    if (!_canSubmit) return;

    final app = JobApplication(
      id:
          widget.existing?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      company: _company.text.trim(),
      role: _role.text.trim(),
      appliedDate: _date,
      status: _status,
      source: _source.text.trim(),
      notes: _notes.text.trim(),
      location: _location.text.trim(),
      jobType: _jobType.text.trim(),
      
      salary: _salary.text.trim().isEmpty
    ? ''
    : '$_currency ${_salary.text.trim()}',

      description: _description.text.trim(),
      recruiterName: _recruiterName.text.trim(),
      recruiterEmail: _recruiterEmail.text.trim(),
      recruiterLinkedIn: _recruiterLinkedIn.text.trim(),
      lastContacted: _lastContacted,
    );

    widget.onSave(app);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ---------------------------------------------------------------
          // Header
          // ---------------------------------------------------------------

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.existing == null
                    ? 'Log new application'
                    : 'Edit application',
                style: FieldLog.display(size: 19, weight: FontWeight.w600),
              ),
              IconButton(
                tooltip: 'Close',
                onPressed: () => Navigator.of(context).pop(),
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.close_rounded, size: 20),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // ---------------------------------------------------------------
          // Tabs
          // ---------------------------------------------------------------
          _TabToggle(
            index: _tab,
            onChanged: (i) {
              setState(() => _tab = i);
            },
          ),

          const SizedBox(height: 20),

          // IndexedStack keeps data entered on either tab alive.
          IndexedStack(
            index: _tab,
            alignment: Alignment.topLeft,
            children: [_detailsTab(), _recruiterTab()],
          ),

          const SizedBox(height: 24),

          // ---------------------------------------------------------------
          // Footer
          // ---------------------------------------------------------------
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: FieldLog.textPrimary,
                    backgroundColor: FieldLog.surfaceCard,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    side: const BorderSide(
                      color: FieldLog.textPrimary,
                      width: 1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        FieldLog.radiusControl,
                      ),
                    ),
                  ),
                  child: Text(
                    'Cancel',
                    style: FieldLog.body(
                      size: 13,
                      color: FieldLog.textPrimary,
                      weight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: ElevatedButton(
                  onPressed: _canSubmit ? _submit : null,
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: FieldLog.textPrimary,
                    foregroundColor: Colors.white,

                    disabledBackgroundColor: FieldLog.textPrimary.withValues(
                      alpha: 0.25,
                    ),

                    disabledForegroundColor: Colors.white.withValues(
                      alpha: 0.75,
                    ),

                    padding: const EdgeInsets.symmetric(vertical: 15),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        FieldLog.radiusControl,
                      ),
                    ),
                  ),
                  child: Text(
                    widget.existing == null ? 'Save entry' : 'Save changes',
                    style: FieldLog.body(
                      size: 13,
                      color: Colors.white,
                      weight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _detailsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _role,
          style: FieldLog.body(size: 13),
          decoration: _decoration('Job title *'),
          onChanged: (_) => setState(() {}),
        ),

        const SizedBox(height: 12),

        TextField(
          controller: _company,
          style: FieldLog.body(size: 13),
          decoration: _decoration('Company *'),
          onChanged: (_) => setState(() {}),
        ),

        const SizedBox(height: 12),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: InkWell(
                onTap: _pickDate,
                borderRadius: BorderRadius.circular(FieldLog.radiusControl),
                child: InputDecorator(
                  decoration: _decoration('Applied date'),
                  child: Text(
                    _formatDate(_date),
                    style: FieldLog.body(size: 13, color: FieldLog.textPrimary),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: DropdownButtonFormField<ApplicationStatus>(
                value: _status,
                decoration: _decoration('Status'),
                style: FieldLog.body(size: 13, color: FieldLog.textPrimary),
                dropdownColor: FieldLog.surfaceCard,
                items: ApplicationStatus.values
                    .map(
                      (status) => DropdownMenuItem(
                        value: status,
                        child: Text(
                          status.label,
                          style: FieldLog.body(
                            size: 12,
                            color: FieldLog.textPrimary,
                          ),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _status = value ?? _status;
                  });
                },
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        TextField(
          controller: _location,
          style: FieldLog.body(size: 13),
          decoration: _decoration('Location (optional)'),
        ),

        const SizedBox(height: 12),

        TextField(
          controller: _jobType,
          style: FieldLog.body(size: 13),
          decoration: _decoration(
            'Job type (optional — e.g. internship, remote)',
          ),
        ),

        const SizedBox(height: 12),

        TextField(
          controller: _salary,
          style: FieldLog.body(size: 13),
          keyboardType: const TextInputType.numberWithOptions(
            decimal: true,
          ),
          decoration: _decoration('Salary (optional)').copyWith(
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _currency,
                  dropdownColor: FieldLog.surfaceCard,
                  icon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 17,
                  ),
                  style: FieldLog.body(
                    size: 12,
                    color: FieldLog.textPrimary,
                    weight: FontWeight.w600,
                  ),
                  items: _currencies
                      .map(
                        (currency) => DropdownMenuItem<String>(
                          value: currency,
                          child: Text(currency),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) return;

                    setState(() {
                      _currency = value;
                    });
                  },
                ),
              ),
            ),
            suffixIconConstraints: const BoxConstraints(
              minWidth: 76,
            ),
          ),
        ),

        const SizedBox(height: 12),

        TextField(
          controller: _source,
          style: FieldLog.body(size: 13),
          decoration: _decoration('Source (job board, referral...)'),
        ),

        const SizedBox(height: 12),

        TextField(
          controller: _description,
          style: FieldLog.body(size: 13),
          decoration: _decoration('Description (optional)'),
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _recruiterTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _recruiterName,
          style: FieldLog.body(size: 13),
          decoration: _decoration('Recruiter name (optional)'),
        ),

        const SizedBox(height: 12),

        TextField(
          controller: _recruiterEmail,
          style: FieldLog.body(size: 13),
          keyboardType: TextInputType.emailAddress,
          decoration: _decoration('Email (optional)'),
        ),

        const SizedBox(height: 12),

        TextField(
          controller: _recruiterLinkedIn,
          style: FieldLog.body(size: 13),
          keyboardType: TextInputType.url,
          decoration: _decoration('LinkedIn URL (optional)'),
        ),

        const SizedBox(height: 12),

        InkWell(
          onTap: _pickLastContacted,
          borderRadius: BorderRadius.circular(FieldLog.radiusControl),
          child: InputDecorator(
            decoration: _decoration('Last contacted (optional)'),
            child: Text(
              _lastContacted == null ? 'Not set' : _formatDate(_lastContacted!),
              style: FieldLog.body(
                size: 13,
                color: _lastContacted == null
                    ? FieldLog.textSecondary
                    : FieldLog.textPrimary,
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        TextField(
          controller: _notes,
          style: FieldLog.body(size: 13),
          decoration: _decoration('Notes (optional)'),
          maxLines: 3,
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }
}

class _TabToggle extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChanged;

  const _TabToggle({required this.index, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F2F4),
        borderRadius: BorderRadius.circular(FieldLog.radiusControl),
      ),
      child: Row(
        children: [
          _segment(0, 'Details', Icons.description_outlined),
          _segment(1, 'Recruiter', Icons.person_outline_rounded),
        ],
      ),
    );
  }

  Widget _segment(int i, String label, IconData icon) {
    final active = i == index;

    return Expanded(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => onChanged(i),
          behavior: HitTestBehavior.opaque,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(vertical: 9),
            decoration: BoxDecoration(
              color: active ? FieldLog.surfaceCard : Colors.transparent,
              borderRadius: BorderRadius.circular(FieldLog.radiusControl - 2),
              boxShadow: active
                  ? const [
                      BoxShadow(
                        color: Color(0x10000000),
                        blurRadius: 4,
                        offset: Offset(0, 1),
                      ),
                    ]
                  : const [],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 15,
                  color: active ? FieldLog.textPrimary : FieldLog.textSecondary,
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: FieldLog.body(
                    size: 12,
                    color: active
                        ? FieldLog.textPrimary
                        : FieldLog.textSecondary,
                    weight: active ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
