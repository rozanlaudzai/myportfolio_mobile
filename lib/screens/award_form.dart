import 'package:flutter/material.dart';
import 'package:myportfolio_mobile/models/award.dart';
import 'package:myportfolio_mobile/services/api_client.dart';
import 'package:myportfolio_mobile/services/auth_state.dart';
import 'package:myportfolio_mobile/widgets/auth_guard.dart';
import 'package:provider/provider.dart';

Future<bool> openAwardForm(BuildContext context) async {
  if (!await ensureLoggedIn(context) || !context.mounted) return false;
  return await Navigator.of(
        context,
      ).push<bool>(MaterialPageRoute(builder: (_) => const AwardFormPage())) ??
      false;
}

class AwardFormPage extends StatefulWidget {
  const AwardFormPage({super.key});

  @override
  State<AwardFormPage> createState() => _AwardFormPageState();
}

class _AwardFormPageState extends State<AwardFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _issuer = '';
  String _description = '';
  DateTime? _awardedAt;
  bool _saving = false;

  Future<void> _save() async {
    if (_saving || !_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    final auth = context.read<AuthState>();
    final api = context.read<ApiClient>();
    setState(() => _saving = true);
    try {
      if (!await ensureLoggedIn(context) || !mounted) return;
      final token = auth.token;
      if (token == null) return;
      final award = await api.createAward(
        Award(
          title: _title,
          issuer: _issuer,
          description: _description,
          awardedAt: _awardedAt!.toIso8601String().split('T').first,
        ),
        token: token,
      );
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Award added'),
          content: Text(award.title),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      if (mounted) Navigator.pop(context, true);
    } on ApiException catch (error) {
      if (!mounted) return;
      if (error.statusCode == 401) {
        await signOut(context);
        if (!mounted) return;
        _showError('Your session expired. Log in and save again.');
        await ensureLoggedIn(context);
      } else {
        _showError(switch (error.statusCode) {
          400 => 'Django rejected the award details. Check your entries.',
          403 => 'Only the portfolio owner can add awards.',
          _ => 'Could not save the award (HTTP ${error.statusCode}).',
        });
      }
    } on Exception {
      if (mounted) _showError('Could not contact the server.');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _textField(
    String label,
    ValueChanged<String> save, {
    int lines = 1,
    int? maxLength,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        enabled: !_saving,
        maxLines: lines,
        maxLength: maxLength,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) => value == null || value.trim().isEmpty
            ? 'This field is required.'
            : null,
        onSaved: (value) => save(value!.trim()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_saving,
      child: Scaffold(
        appBar: AppBar(title: const Text('Add Award')),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _textField(
                  'Award Title',
                  (value) => _title = value,
                  maxLength: 255,
                ),
                _textField(
                  'Award Issuer',
                  (value) => _issuer = value,
                  maxLength: 255,
                ),
                _textField(
                  'Award Description',
                  (value) => _description = value,
                  lines: 4,
                ),
                FormField<DateTime>(
                  onSaved: (value) => _awardedAt = value,
                  validator: (value) =>
                      value == null ? 'Select an award date.' : null,
                  builder: (field) => InkWell(
                    onTap: _saving
                        ? null
                        : () async {
                            final today = DateUtils.dateOnly(DateTime.now());
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: field.value ?? today,
                              firstDate: DateTime(1900),
                              lastDate: today,
                            );
                            if (field.mounted && picked != null) {
                              field.didChange(picked);
                            }
                          },
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Awarded At',
                        border: const OutlineInputBorder(),
                        errorText: field.errorText,
                        suffixIcon: const Icon(Icons.calendar_today),
                      ),
                      child: Text(
                        field.value == null
                            ? 'Select award date'
                            : MaterialLocalizations.of(context)
                                  .formatMediumDate(field.value!),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _saving ? null : _save,
                  child: Text(_saving ? 'Saving…' : 'Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
