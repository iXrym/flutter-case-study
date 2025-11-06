import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'group_models.dart';
import 'registrationpage.dart';

void main() {
  runApp(MyFirstApp());
}

class MyFirstApp extends StatelessWidget {
  const MyFirstApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: HomePage(), // Start at the new HomePage
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();
  bool? _groupExists;

  void _onSearch() {
    String groupName = _controller.text.trim();

    if (groupName.isEmpty) return;

    if (groupName.toLowerCase() == 'alpha') {
      setState(() {
        _groupExists = true;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Group "$groupName" found!')));
    } else {
      setState(() {
        _groupExists = false;
      });
    }
  }

  //ADD BUTTON ROUTE TO REGISTER PAGE
  void _onAddGroup() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegistrationPage()),
    );
  }
class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController controller = TextEditingController();
  // null = initial/loading, false = not found
  bool? groupExists; 
  bool isLoading = false;

  Future<void> onSearch() async {
    String groupName = controller.text.trim();
    if (groupName.isEmpty) return;

    setState(() {
      isLoading = true;
      groupExists = null;
    });

    final String url = '$baseUrl/get/group/information?group_name=$groupName';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        
        // Check if the response contains valid group data (e.g., group_id)
        if (jsonResponse is Map && jsonResponse.containsKey('group_id')) {
            final Group foundGroup = Group.fromJson(jsonResponse);

            setState(() {
              groupExists = true;
              isLoading = false;
            });
            
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Group "${foundGroup.groupName}" found!')));

            // Navigate to the details page on success
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GroupDetailsPage(group: foundGroup)),
            );
            
        } else {
            // API returned 200 but data was missing (Group not found by server logic)
            setState(() {
              groupExists = false; 
              isLoading = false;
            });
        }
      } else {
        // Server returned 404/500
        setState(() { 
          groupExists = false; 
          isLoading = false;
        });
      }
    } catch (e) {
      // Network/Connection error
      setState(() { 
        groupExists = false; 
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Network Error: Failed to connect or data error.')));
    }
  }

  // Route to Registration Page
  void onAddGroup() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegistrationPage()),
    );
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
              // Placeholder for the image
              const Text('FITNESS GROUP PLANNER', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepPurple)),

              SizedBox(height: 20),

              Container(
                width: 500,
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.grey.shade300),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey[600]),
                    SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: controller,
                        decoration: InputDecoration(
                          hintText: "Search for a Group...", 
                          border: InputBorder.none,
                        ),
                        onSubmitted: (_) => onSearch(),
                      ),
                    ),
                    TextButton(
                      onPressed: isLoading ? null : onSearch,
                      child: isLoading 
                        ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                        : Text(
                            "Search",
                            style: TextStyle(fontSize: 16, color: Colors.blue[700]),
                          ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 30),

              // Conditional UI elements
              if (groupExists == false && !isLoading)
                Column(
                  children: [
                    Text('Group not found. Would you like to create one?', style: TextStyle(color: Colors.red)),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: onAddGroup,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(' + Create Group'),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}