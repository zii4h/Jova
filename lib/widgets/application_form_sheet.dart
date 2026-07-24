import 'package:flutter/material.dart';
import '../models/application.dart';
import '../theme/field_log_theme.dart';

/// Opens the guided add/edit form as a modal bottom sheet.
/// Pass an [existing] application to edit it, or leave null to create one.
Future<void> showApplicationFormSheet(
  BuildContext context, {
  JobApplication? existing,
  required void Function(JobApplication) onSave,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: FieldLog.bgPage,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
      child: _ApplicationForm(existing: existing, onSave: onSave),
    ),
  );
}

class _ApplicationForm extends StatefulWidget {
  final JobApplication? existing;
  final void Function(JobApplication) onSave;

  const _ApplicationForm({this.existing, required this.onSave});

  @override
  State<_ApplicationForm> createState() => _ApplicationFormState();
}

class _ApplicationFormState extends State<_ApplicationForm> {
  late final TextEditingController _company;
  late final TextEditingController _role;
  late final TextEditingController _source;
  late final TextEditingController _notes;
  late DateTime _date;
  late ApplicationStatus _status;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _company = TextEditingController(text: e?.company ?? '');
    _role = TextEditingController(text: e?.role ?? '');
    _source = TextEditingController(text: e?.source ?? '');
    _notes = TextEditingController(text: e?.notes ?? '');
    _date = e?.appliedDate ?? DateTime.now();
    _status = e?.status ?? ApplicationStatus.applied;
  }

  @override
  void dispose() {
    _company.dispose();
    _role.dispose();
    _source.dispose();
    _notes.dispose();
    super.dispose();
  }

  InputDecoration _decoration(String label) => InputDecoration(
        labelText: label,
        labelStyle: FieldLog.mono(size: 12),
        filled: true,
        fillColor: FieldLog.surfaceCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(FieldLog.radiusControl),
          borderSide: BorderSide(color: FieldLog.border),
        ),
      );

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _date = picked);
  }

  void _submit() {
    if (_company.text.trim().isEmpty || _role.text.trim().isEmpty) return;
    final app = JobApplication(
      id: widget.existing?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      company: _company.text.trim(),
      role: _role.text.trim(),
      appliedDate: _date,
      status: _status,
      source: _source.text.trim(),
      notes: _notes.text.trim(),
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
          Text(widget.existing == null ? 'log new application' : 'edit application',
              style: FieldLog.display(size: 18)),
          const SizedBox(height: 16),
          TextField(controller: _company, decoration: _decoration('company')),
          const SizedBox(height: 12),
          TextField(controller: _role, decoration: _decoration('role')),
          const SizedBox(height: 12),
          InkWell(
            onTap: _pickDate,
            child: InputDecorator(
              decoration: _decoration('applied date'),
              child: Text(
                '${_date.year}-${_date.month.toString().padLeft(2, '0')}-${_date.day.toString().padLeft(2, '0')}',
                style: FieldLog.mono(size: 13, color: FieldLog.textPrimary),
              ),
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<ApplicationStatus>(
            value: _status,
            decoration: _decoration('status'),
            items: ApplicationStatus.values
                .map((s) => DropdownMenuItem(value: s, child: Text(s.label, style: FieldLog.mono(size: 12))))
                .toList(),
            onChanged: (v) => setState(() => _status = v ?? _status),
          ),
          const SizedBox(height: 12),
          TextField(controller: _source, decoration: _decoration('source (job board, referral...)')),
          const SizedBox(height: 12),
          TextField(controller: _notes, decoration: _decoration('notes'), maxLines: 3),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: FieldLog.textPrimary,
                foregroundColor: FieldLog.bgPage,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(FieldLog.radiusControl)),
              ),
              child: Text(widget.existing == null ? 'save entry' : 'save changes', style: FieldLog.mono(size: 13)),
            ),
          ),
        ],
      ),
    );
  }
}
