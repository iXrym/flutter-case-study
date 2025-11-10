import 'package:flutter/material.dart';
import 'api_service.dart';
import 'AddGroupPage.dart';
import 'GroupPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness Group Finder',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const LandingAsMain(),
    );
  }
}

/// Landing page acts as the Google-like search landing page.
/// The search field is submitted under the parameter name `group_name`.
class LandingAsMain extends StatefulWidget {
  const LandingAsMain({super.key});
  @override
  State<LandingAsMain> createState() => _LandingAsMainState();
}

class _LandingAsMainState extends State<LandingAsMain> {
  final TextEditingController _groupController = TextEditingController();
  final TextEditingController _sectionController = TextEditingController();
  bool _loading = false;
  bool _showCreateButton = false;
  Map<String, dynamic>? _foundGroup;

  Future<void> _search() async {
    final groupName = _groupController.text.trim();
    final section = _sectionController.text.trim();

    if (groupName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter group name')),
      );
      return;
    }

    setState(() {
      _loading = true;
      _showCreateButton = false;
      _foundGroup = null;
    });

    try {
      final data = await ApiService().getGroupInfo(groupName);
      // data is null when server returns empty / not found
      if (data == null || data.isEmpty) {
        setState(() {
          _showCreateButton = true;
        });
      } else {
        // Expecting something like { "group_id": 1, "group_name": "...", "section": "..." }
        setState(() {
          _foundGroup = data;
        });
        // Navigate to group page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => GroupPage(
              groupData: data,
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error searching group: $e')),
      );
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  void _openCreateGroup() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddGroupPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Google-like simple centered UI
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          width: 560,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Fitness Groups',
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w400,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 28),
              Material(
                elevation: 2,
                borderRadius: BorderRadius.circular(40),
                child: TextField(
                  controller: _groupController,
                  decoration: InputDecoration(
                    hintText: 'Search group name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    suffixIcon: _loading
                        ? const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        : IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: _search,
                          ),
                  ),
                  onSubmitted: (_) => _search(),
                ),
              ),
              const SizedBox(height: 12),
              // optional section input
              TextField(
                controller: _sectionController,
                decoration: const InputDecoration(
                  labelText: 'Section (optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              if (_showCreateButton)
                ElevatedButton.icon(
                  onPressed: _openCreateGroup,
                  icon: const Icon(Icons.add),
                  label: const Text('Create Group'),
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
