import 'package:flutter/material.dart';
import 'api_service.dart';

class AddGroupPage extends StatefulWidget {
  const AddGroupPage({super.key});

  @override
  State<AddGroupPage> createState() => _AddGroupPageState();
}

class _AddGroupPageState extends State<AddGroupPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _sectionController = TextEditingController();

  void _createGroup() async {
    final success = await ApiService().createGroup(
      _nameController.text,
      _sectionController.text,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? "Group created!" : "Failed to create group"),
      ),
    );

    if (success) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Group")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Group Name"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _sectionController,
              decoration: const InputDecoration(labelText: "Section"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createGroup,
              child: const Text("Create"),
            ),
          ],
        ),
      ),
    );
  }
}
