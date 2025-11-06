import 'package:flutter/material.dart';

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
