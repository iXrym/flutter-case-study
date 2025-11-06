import 'package:flutter/material.dart';

void main() {
  runApp(const MyFirstApp());
}

class MyFirstApp extends StatelessWidget {
  const MyFirstApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Group Finder Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const HomePage(),
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSearch() {
    String groupName = _controller.text.trim();

    if (groupName.isEmpty) {
      setState(() {
        _groupExists = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a group name to search.')),
      );
      return;
    }

    // NOTE: This logic is hardcoded ('alpha'). In a real application,
    // you would connect to a database (like Firestore) here to check existence.
    if (groupName.toLowerCase() == 'alpha') {
      setState(() {
        _groupExists = true;
      });
      // Use showSnackBar outside of setState
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Group "$groupName" found!')));
      });
    } else {
      setState(() {
        _groupExists = false;
      });
      // Optionally show a failure SnackBar here too
    }
  }

  void _onAddGroup() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegistrationPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Group Search')),
      backgroundColor: Colors.grey[50],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // REVERTED: Using the image asset again, with a ClipRRect for styling.
              ClipRRect(
                borderRadius: BorderRadius.circular(20.0), // Rounded corners
                child: Image.asset(
                  'assets/images/bisaya.jpeg',
                  height: 120,
                  width: 120,
                  fit: BoxFit.cover,
                  // Fallback in case the asset doesn't load in the online environment
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.group_work,
                      size: 120,
                      color: Colors.teal,
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Find Your Study Group',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 30),

              Container(
                width: 500, // Constrain width for desktop view
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.teal.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.teal.shade50,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: "Search for a Group...",
                          border: InputBorder.none,
                        ),
                        onSubmitted: (_) => _onSearch(),
                      ),
                    ),
                    TextButton(
                      onPressed: _onSearch,
                      child: Text(
                        "Search",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.teal.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              if (_groupExists == false)
                Column(
                  children: [
                    const Text(
                      'Group not found. Would you like to create it?',
                      style: TextStyle(
                        color: Colors.red,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _onAddGroup,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 5,
                      ),
                      child: const Text(
                        ' + Add New Group',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              if (_groupExists == true)
                const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Group found! Redirecting...',
                    style: TextStyle(
                      color: Colors.teal,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final form = GlobalKey<FormState>();

  TextEditingController groupname = TextEditingController();
  TextEditingController section = TextEditingController();
  // Removed unused middleName controller for cleanup

  @override
  void dispose() {
    groupname.dispose();
    section.dispose();
    super.dispose();
  }

  void postData() {
    final data = {
      "Groupname": groupname.text.trim(),
      "Section": section.text.trim(),
    };
    // In a real app, this would be an API call or Firestore write operation.
    print(data);

    // Show confirmation and navigate back
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Group "${groupname.text}" registered successfully! (See console for data)',
        ),
      ),
    );
    // Optionally navigate back after successful registration
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Group Registration'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      backgroundColor: const Color.fromARGB(255, 246, 246, 246),
      body: SafeArea(
        child: Form(
          key: form,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    // FIXED: Removed the inner Column that contained Expanded widgets.
                    // Instead, we just list the form fields directly inside the Card's padding.
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: groupname,
                          decoration: const InputDecoration(
                            labelText: "Group Name:",
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.people),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Group name is required";
                            }
                            if (value.length < 2) {
                              return 'Minimum 2 characters required';
                            } else if (value.length > 32) {
                              return 'Maximum 32 characters allowed';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: section,
                          decoration: const InputDecoration(
                            labelText: "Section:",
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.class_),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Section is required";
                            }
                            if (value.length < 2) {
                              return 'Minimum 2 characters required';
                            } else if (value.length > 32) {
                              return 'Maximum 32 characters allowed';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (form.currentState!.validate()) {
                        postData();
                      }
                    },
                    icon: const Icon(Icons.check_circle),
                    label: const Text(
                      'Submit Group',
                      style: TextStyle(fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
