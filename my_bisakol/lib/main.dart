import 'package:flutter/material.dart';
import 'AddGroupPage.dart';
import 'GroupPage.dart';
import 'api_service.dart';

void main() {
  runApp(const DietPlannerApp());
}

class DietPlannerApp extends StatelessWidget {
  const DietPlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fitness Group Planner',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
        // Global text input decoration style
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.green.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.green.shade700, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
      home: const LandingPage(),
      // Define route for group creation
      routes: {'/addGroup': (context) => const AddGroupPage()},
    );
  }
}

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final TextEditingController _controller = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isSearching = false;

  void _onSearch() async {
    String query = _controller.text.trim();
    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a group name to search.')),
      );
      return;
    }

    if (mounted) setState(() => _isSearching = true);

    // 1. Search for group using /get/group/information?group_name=...
    final groupData = await _apiService.searchGroup(query);

    if (!mounted) return;

    setState(() => _isSearching = false);

    if (groupData != null) {
      // 1.2 After successful submission, redirect to GroupPage
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GroupPage(groupData: groupData),
        ),
      );
    } else {
      // 1.3 Response data returned empty, show button to assist group creation
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text('Group Not Found: "$query"'),
          content: const Text(
            'The group was not found on the server. Would you like to create it now?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context); // Close dialog
                // Navigate to AddGroupPage and wait for refresh result
                final result = await Navigator.pushNamed(context, '/addGroup');
                if (result == true) {
                  // Optional: Re-run search if a group was successfully created
                  _onSearch();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
              ),
              child: const Text(
                'Create Group',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 🥗 Logo + Title
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(25),
                    child: Icon(
                      Icons.fitness_center_rounded,
                      color: Colors.green.shade800,
                      size: 80,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    "Fitness Group Planner",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Colors.green.shade800,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Search for your group to get started",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                ],
              ),

              const SizedBox(height: 60),

              // 🔍 Search Bar (TextField named group_name - as a controller)
              Container(
                width: 400,
                constraints: const BoxConstraints(maxWidth: 500),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.green.shade300, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: TextField(
                          controller: _controller,
                          // 1.1 Textfield should be named group_name (controller handles value)
                          // The actual variable name is 'query' in the _onSearch function
                          decoration: const InputDecoration(
                            hintText: "Group Name",
                            border: InputBorder.none,
                          ),
                          onSubmitted: (_) => _onSearch(),
                        ),
                      ),
                    ),
                    // Search Button with loading indicator
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ElevatedButton(
                        onPressed: _isSearching ? null : _onSearch,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade700,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 15,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: _isSearching
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                "Search",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
