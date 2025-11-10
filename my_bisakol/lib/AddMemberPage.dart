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
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController birthday = TextEditingController();
  final TextEditingController height = TextEditingController();
  final TextEditingController weight = TextEditingController();
  final TextEditingController bmi = TextEditingController();

  void _saveMember() async {
    if (_formKey.currentState!.validate()) {
      final success = await ApiService().createMember(
        groupId: widget.groupId,
        firstName: firstName.text,
        lastName: lastName.text,
        birthday: birthday.text,
        height: height.text,
        weight: weight.text,
        bmi: bmi.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? "Member added!" : "Failed to add member"),
        ),
      );

      if (success) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Member")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: firstName,
                decoration: const InputDecoration(labelText: "First Name"),
              ),
              TextFormField(
                controller: lastName,
                decoration: const InputDecoration(labelText: "Last Name"),
              ),
              TextFormField(
                controller: birthday,
                decoration: const InputDecoration(labelText: "Birthday"),
              ),
              TextFormField(
                controller: height,
                decoration: const InputDecoration(labelText: "Height"),
              ),
              TextFormField(
                controller: weight,
                decoration: const InputDecoration(labelText: "Weight"),
              ),
              TextFormField(
                controller: bmi,
                decoration: const InputDecoration(labelText: "BMI"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveMember,
                child: const Text("Save Member"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
