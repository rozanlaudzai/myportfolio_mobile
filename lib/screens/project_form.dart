import 'package:flutter/material.dart';
import 'package:myportfolio_mobile/models/project.dart';
import 'package:myportfolio_mobile/services/api_client.dart';
import 'package:myportfolio_mobile/services/auth_state.dart';
import 'package:myportfolio_mobile/widgets/auth_guard.dart';
import 'package:provider/provider.dart';

class ProjectFormPage extends StatefulWidget {
  const ProjectFormPage({super.key});

  @override
  State<ProjectFormPage> createState() => _ProjectFormPageState();
}

class _ProjectFormPageState extends State<ProjectFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  String _techStack = '';
  String _projectUrl = '';
  String _imageUrl = '';
  bool _isSubmitting = false;

  Future<void> _submit() async {
    if (_isSubmitting || !_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    final auth = context.read<AuthState>();
    final api = context.read<ApiClient>();
    setState(() => _isSubmitting = true);
    try {
      if (!await ensureLoggedIn(context) || !mounted) return;
      final token = auth.token;
      if (token == null) return;
      final project = await api.createProject(
        Project(
          title: _title,
          description: _description,
          techStack: _techStack,
          projectUrl: _projectUrl,
          projectImageUrl: _imageUrl,
        ),
        token: token,
      );
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Project added'),
          content: Text(project.title),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      if (mounted) _formKey.currentState!.reset();
    } on ApiException catch (error) {
      if (!mounted) return;
      if (error.statusCode == 401) {
        await signOut(context);
        if (!mounted) return;
        _showMessage('Your session expired. Log in and save again.');
        await ensureLoggedIn(context);
      } else if (error.statusCode == 403) {
        _showMessage('Only the portfolio owner can add projects.');
      } else {
        _showMessage('Could not save the project (HTTP ${error.statusCode}).');
      }
    } on Exception {
      if (mounted) _showMessage('Could not contact the server.');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  String? _requiredText(String? value) =>
      value == null || value.trim().isEmpty ? 'This field is required.' : null;

  String? _validateUrl(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return null;
    final uri = Uri.tryParse(text);
    if (uri == null ||
        (uri.scheme != 'http' && uri.scheme != 'https') ||
        uri.host.isEmpty) {
      return 'Enter an HTTP or HTTPS URL.';
    }
    return null;
  }

  Widget _field(
    String label,
    ValueChanged<String> save, {
    required FormFieldValidator<String> validator,
    int maxLines = 1,
    int? maxLength,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        enabled: !_isSubmitting,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        maxLines: maxLines,
        maxLength: maxLength,
        keyboardType: keyboardType,
        validator: validator,
        onSaved: (value) => save(value!.trim()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isSubmitting,
      child: Scaffold(
        appBar: AppBar(title: const Text('Add Project')),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _field(
                  'Title',
                  (value) => _title = value,
                  validator: _requiredText,
                  maxLength: 255,
                ),
                _field(
                  'Description',
                  (value) => _description = value,
                  validator: _requiredText,
                  maxLines: 5,
                ),
                _field(
                  'Tech Stack',
                  (value) => _techStack = value,
                  validator: _requiredText,
                  maxLength: 255,
                ),
                _field(
                  'Project URL (optional)',
                  (value) => _projectUrl = value,
                  validator: _validateUrl,
                  maxLength: 200,
                  keyboardType: TextInputType.url,
                ),
                _field(
                  'Project Image URL (optional)',
                  (value) => _imageUrl = value,
                  validator: _validateUrl,
                  maxLength: 255,
                  keyboardType: TextInputType.url,
                ),
                ElevatedButton(
                  onPressed: _isSubmitting ? null : _submit,
                  child: Text(_isSubmitting ? 'Saving…' : 'Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
