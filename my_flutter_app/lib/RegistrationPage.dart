import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final form = GlobalKey<FormState>();

  TextEditingController groupname = TextEditingController();
  TextEditingController section = TextEditingController();

  postData() {
    final postData = {"Section": section.text, "Groupname": groupname.text};

    print(postData);
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
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(12),
                        child: TextFormField(
                          controller: groupname,
                          decoration: InputDecoration(labelText: "Group Name:"),
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

                      Padding(
                        padding: EdgeInsets.all(12),
                        child: TextFormField(
                          controller: section,
                          decoration: InputDecoration(labelText: "Section: "),
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
