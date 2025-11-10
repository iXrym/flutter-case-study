import 'package:flutter/material.dart';
import 'api_service.dart'; // Ensure ApiService is available

class AddMemberPage extends StatefulWidget {
  final int groupId;

  // Use const constructor
  const AddMemberPage({super.key, required this.groupId});

  @override
  State<AddMemberPage> createState() => _AddMemberPageState();
}

class _AddMemberPageState extends State<AddMemberPage> {
  // Use private fields for controllers
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _bmiController = TextEditingController();

  final ApiService _apiService = ApiService();

  Future<void> createMember() async {
    // Basic validation to prevent empty submissions
    if (_firstNameController.text.isEmpty || _lastNameController.text.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill in first and last name.')),
        );
      }
      return;
    }

    try {
      final success = await _apiService.createMember(
        groupId: widget.groupId,
        lastName: _lastNameController.text,
        firstName: _firstNameController.text,
        birthday: _birthdayController.text,
        height: _heightController.text,
        weight: _weightController.text,
        bmi: _bmiController.text,
      );

      if (success) {
        if (mounted) {
          // Go back to the group page
          Navigator.pop(context);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to create member. Status not 200.'),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error creating member: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Member to Group ${widget.groupId}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: _firstNameController,
              decoration: const InputDecoration(labelText: 'First Name'),
            ),
            TextField(
              controller: _lastNameController,
              decoration: const InputDecoration(labelText: 'Last Name'),
            ),
            TextField(
              controller: _birthdayController,
              decoration: const InputDecoration(
                labelText: 'Birthday (YYYY-MM-DD)',
              ),
            ),
            TextField(
              controller: _heightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Height (cm)'),
            ),
            TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Weight (kg)'),
            ),
            TextField(
              controller: _bmiController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'BMI'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: createMember,
              child: const Text('Add Member'),
            ),
          ],
        ),
      ),
    );
  }
}
