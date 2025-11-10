import 'package:flutter/material.dart';
import 'api_service.dart';

class AddGroupPage extends StatefulWidget {
  const AddGroupPage({super.key});
  @override
  State<AddGroupPage> createState() => _AddGroupPageState();
}

class _AddGroupPageState extends State<AddGroupPage> {
  final _nameCtrl = TextEditingController();
  final _sectionCtrl = TextEditingController();
  bool _loading = false;

  Future<void> _create() async {
    final name = _nameCtrl.text.trim();
    final section = _sectionCtrl.text.trim();
    if (name.isEmpty || section.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill both name and section')),
      );
      return;
    }
    setState(() => _loading = true);
    final ok = await ApiService().createGroup(
      groupName: name,
      section: section,
    );
    setState(() => _loading = false);
    if (ok) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Group created')));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to create group')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Group')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: 'Group Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _sectionCtrl,
              decoration: const InputDecoration(labelText: 'Section'),
            ),
            const SizedBox(height: 18),
            _loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _create,
                    child: const Text('Create Group'),
                  ),
          ],
        ),
      ),
    );
  }
}
