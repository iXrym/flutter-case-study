import 'package:flutter/material.dart';
import 'api_service.dart';
import 'GroupPage.dart';
import 'AddGroupPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Group Finder',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const LandingPage(),
    );
  }
}

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final TextEditingController _groupController = TextEditingController();
  final TextEditingController _sectionController = TextEditingController();
  bool _showCreateButton = false;
  bool _isLoading = false;

  void _searchGroup() async {
    setState(() {
      _isLoading = true;
      _showCreateButton = false;
    });

    String groupName = _groupController.text.trim();
    String section = _sectionController.text.trim();

    if (groupName.isEmpty || section.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter both group name and section'),
        ),
      );
      setState(() => _isLoading = false);
      return;
    }

    final groupData = await ApiService().fetchGroupInfo(groupName, section);

    setState(() => _isLoading = false);

    if (groupData != null && groupData['group_id'] != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => GroupPage(groupData: groupData)),
      );
    } else {
      setState(() {
        _showCreateButton = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Group Finder",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _groupController,
                decoration: const InputDecoration(
                  labelText: "Group Name",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _sectionController,
                decoration: const InputDecoration(
                  labelText: "Section",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _searchGroup,
                      child: const Text("Search"),
                    ),
              const SizedBox(height: 20),
              if (_showCreateButton)
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AddGroupPage()),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Create Group"),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
