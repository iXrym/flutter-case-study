import 'package:flutter/material.dart';

class AddGroupPage extends StatefulWidget {
  const AddGroupPage({super.key}); // make constructor const

  @override
  State<AddGroupPage> createState() => _AddGroupPageState();
}

class _AddGroupPageState extends State<AddGroupPage> {
  final form = GlobalKey<FormState>();

  TextEditingController groupname = TextEditingController();
  TextEditingController section = TextEditingController();
  TextEditingController middleName = TextEditingController();

  void postData() {
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
      appBar: AppBar(title: const Text('Add Group')),
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
                          padding: const EdgeInsets.all(12),
                          child: TextFormField(
                            controller: groupname,
                            decoration: const InputDecoration(
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
                            padding: const EdgeInsets.all(12),
                            child: TextFormField(
                              controller: section,
                              decoration: const InputDecoration(
                                labelText: "Section:",
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
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (form.currentState!.validate()) {
                        postData();
                      }
                    },
                    icon: const Icon(Icons.send),
                    label: const Text('Submit Form'),
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
