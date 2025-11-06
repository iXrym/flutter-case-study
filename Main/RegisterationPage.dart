import 'package:flutter/material.dart';

void main() {
  runApp(MyFirstApp());
}

class MyFirstApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
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

  void _onAddGroup() {
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
              Image.asset('assets/images/bisaya.png', height: 100),

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
                        controller: _controller,
                        decoration: InputDecoration(
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
                        style: TextStyle(fontSize: 16, color: Colors.blue[700]),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 30),

              if (_groupExists == false)
                ElevatedButton(
                  child: Text(' + Add Group'),
                  onPressed: _onAddGroup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              if (_groupExists == true)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Group found!',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
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
  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final form = GlobalKey<FormState>();

  TextEditingController groupname = TextEditingController();
  TextEditingController section = TextEditingController();
  TextEditingController middleName = TextEditingController();

  postData() {
    final post_data = {
      "Section": section.text,
      "middle_name": middleName.text,
      "Groupname": groupname.text,
    };
    print(post_data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registration')),
      backgroundColor: const Color.fromARGB(255, 246, 246, 246),
      body: SafeArea(
        child: Form(
          key: form,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: TextFormField(
                            controller: groupname,
                            decoration: InputDecoration(
                              labelText: "Group Name:",
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Groupname is required";
                              }
                              if (value.length < 2) {
                                return 'Minimum 2 characters required';
                              } else if (value.length > 32) {
                                return 'Maximum 32 characters allowed';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),

                      Expanded(
                        child: Card(
                          margin: EdgeInsets.zero,
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: TextFormField(
                              controller: section,
                              decoration: InputDecoration(
                                labelText: "Section: ",
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
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (form.currentState!.validate()) {
                        postData();
                      }
                    },
                    icon: Icon(Icons.send),
                    label: Text('Submit Form'),
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
