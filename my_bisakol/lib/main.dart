import 'package:flutter/material.dart';
import 'grouppage.dart';
import 'addgrouppage.dart';
import 'api_service.dart';

void main() => runApp(const FitnessApp());

class FitnessApp extends StatelessWidget {
  const FitnessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fitness App',
      theme: ThemeData(primarySwatch: Colors.blue),
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
  final TextEditingController _controller = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _groupExists = true;
  Map<String, dynamic>? _groupData;

  Future<void> searchGroup(String groupName) async {
    if (groupName.isEmpty) return;

    try {
      final data = await _apiService.getGroupInfo(groupName);

      if (data != null) {
        setState(() {
          _groupExists = true;
          _groupData = data;
        });
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => GroupPage(groupData: _groupData!)),
        );
      } else {
        setState(() {
          _groupExists = false;
        });
      }
    } catch (e) {
      print('Error searching group: $e');
      setState(() {
        _groupExists = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                'https://upload.wikimedia.org/wikipedia/commons/2/2f/Google_2015_logo.svg',
                height: 100,
              ),
              const SizedBox(height: 40),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.grey.shade300),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Search your group (group_name)',
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () => searchGroup(_controller.text),
                    ),
                  ),
                  onSubmitted: (value) => searchGroup(value),
                ),
              ),

              const SizedBox(height: 20),

              if (!_groupExists)
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            AddGroupPage(groupName: _controller.text),
                      ),
                    );
                  },
                  child: const Text('Create Group'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
