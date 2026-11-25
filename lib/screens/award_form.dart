import 'package:flutter/material.dart';
import 'package:myportfolio_mobile/widgets/left_drawer.dart';

class AwardFormPage extends StatefulWidget {
  const AwardFormPage({super.key});

  @override
  State<AwardFormPage> createState() => _AwardFormPageState();
}

class _AwardFormPageState extends State<AwardFormPage> {
  final _formKey = GlobalKey<FormState>();

  DateTime? _awardedAt;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Add Award Form')),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),

      drawer: const LeftDrawer(),

      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: .start,
            children: [
              // === Award Title ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Award Title',
                    labelText: 'Award Title',
                    border: OutlineInputBorder(borderRadius: .circular(5.0)),
                  ),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Award title cannot be empty!';
                    }
                    return null;
                  },
                ),
              ),

              // === Issuer ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Award Issuer',
                    labelText: 'Award Issuer',
                    border: OutlineInputBorder(borderRadius: .circular(5.0)),
                  ),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Award issuer cannot be empty!';
                    }
                    return null;
                  },
                ),
              ),

              // === Description ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Award Description',
                    labelText: 'Award Description',
                    border: OutlineInputBorder(borderRadius: .circular(5.0)),
                  ),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Award description cannot be empty!';
                    }
                    return null;
                  },
                ),
              ),

              // === Awarded At ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FormField<DateTime>(
                  validator: (value) {
                    if (value == null) {
                      return 'Date time cannot be empty!';
                    }
                    return null;
                  },
                  builder: (FormFieldState<DateTime> field) {
                    return InkWell(
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: _awardedAt ?? DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );

                        if (picked != null) {
                          setState(() {
                            _awardedAt = picked;
                          });

                          field.didChange(picked);
                        }
                      },
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Awarded At',
                          border: OutlineInputBorder(
                            borderRadius: .circular(5.0),
                          ),
                          errorText: field.errorText,
                          suffixIcon: const Icon(Icons.calendar_today),
                        ),
                        child: Text(
                          _awardedAt == null
                              ? 'Select award date'
                              : '${_awardedAt!.day}/${_awardedAt!.month}/${_awardedAt!.year}',
                        ),
                      ),
                    );
                  },
                ),
              ),

              // === Save Button ===
              Align(
                alignment: .bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.indigo),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text(
                                'Award has been successfully added!',
                              ),
                              actions: [
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _formKey.currentState!.reset();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: const Text(
                      'Save',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
