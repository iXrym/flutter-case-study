import 'package:flutter/material.dart';

class GroupPage extends StatefulWidget {
  @override
  State<GroupPage> createState() => GroupPageState();
}

class GroupPageState extends State<GroupPage> {
  bool _isLoading = true;
  List<String> _groupMembers = [];
  String _groupName = '';

  @override
  void initState() {
    super.initState();
    _loadGroupData();
  }

  // A method to simulate loading group data
  void _loadGroupData() async {
    // Replace this with your actual API call or database query
    await Future.delayed(const Duration(seconds: 2));

    // Update the state to refresh the UI
    setState(() {
      _groupName = 'The Flutter Wizards';
      _groupMembers = ['Alex', 'Ben', 'Chloe', 'David'];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_groupName.isNotEmpty ? _groupName : 'Loading Group...'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _groupMembers.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(_groupMembers[index]),
                  subtitle: const Text('Group Member'),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle adding a new member or action
          print('Add New Member button pressed!');
        },
        child: const Icon(Icons.group_add),
      ),
    );
  }
}
