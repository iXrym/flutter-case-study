// File: addgrouppage.dart

import 'package:flutter/material.dart';
import 'api_service.dart'; // Ensure you have this import
import 'grouppage.dart'; // Ensure you have this import

class AddGroupPage extends StatefulWidget {
  // 1. Define the required parameter
  final String groupName;

  // 2. Define the constructor to accept the named parameter
  const AddGroupPage({super.key, required this.groupName});

  @override
  State<AddGroupPage> createState() => _AddGroupPageState();
}

class _AddGroupPageState extends State<AddGroupPage> {
  final TextEditingController _sectionController = TextEditingController();
  final ApiService _apiService = ApiService();

  Future<void> createGroup() async {
    // Basic validation
    if (_sectionController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a section.')));
      return;
    }

    try {
      final success = await _apiService.createGroup(
        groupName: widget.groupName,
        section: _sectionController.text,
      );

      if (success) {
        // After creation, attempt to fetch the new group's data to navigate to the GroupPage
        final groupData = await _apiService.getGroupInfo(widget.groupName);
        if (groupData != null) {
          // Navigate to the GroupPage, replacing the current page in the stack
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => GroupPage(groupData: groupData)),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to create group. Check API/network.'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create New Group')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Group Name (Locked): ${widget.groupName}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _sectionController,
              decoration: const InputDecoration(
                labelText: 'Section', // Form parameter: section
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: createGroup,
              child: const Text('Submit Group'),
            ),
          ],
        ),
      ),
    );
  }
}
