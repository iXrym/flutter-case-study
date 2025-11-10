import 'package:flutter/material.dart';
import 'api_service.dart';

class AddMemberPage extends StatefulWidget {
  final int groupId;
  const AddMemberPage({super.key, required this.groupId});

  @override
  State<AddMemberPage> createState() => _AddMemberPageState();
}

class _AddMemberPageState extends State<AddMemberPage> {
  final _formKey = GlobalKey<FormState>();
  final _first = TextEditingController();
  final _last = TextEditingController();
  final _birthday = TextEditingController();
  final _height = TextEditingController();
  final _weight = TextEditingController();
  final _bmi = TextEditingController();
  bool _loading = false;

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final ok = await ApiService().createMember(
      groupId: widget.groupId,
      lastName: _last.text.trim(),
      firstName: _first.text.trim(),
      birthday: _birthday.text.trim(),
      height: _height.text.trim(),
      weight: _weight.text.trim(),
      bmi: _bmi.text.trim(),
    );

    setState(() => _loading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(ok ? 'Member created' : 'Failed to create member'),
      ),
    );
    if (ok) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Member')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _first,
                decoration: const InputDecoration(labelText: 'First Name'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _last,
                decoration: const InputDecoration(labelText: 'Last Name'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _birthday,
                decoration: const InputDecoration(
                  labelText: 'Birthday (YYYY-MM-DD)',
                ),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _height,
                decoration: const InputDecoration(labelText: 'Height (cm)'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _weight,
                decoration: const InputDecoration(labelText: 'Weight (kg)'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _bmi,
                decoration: const InputDecoration(labelText: 'BMI'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 18),
              _loading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _save,
                      child: const Text('Save Member'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
