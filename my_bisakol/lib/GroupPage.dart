import 'package:flutter/material.dart';
import 'api_service.dart';
import 'AddMemberPage.dart';
import 'MemberPlanPage.dart';

class GroupPage extends StatefulWidget {
  final Map<String, dynamic> groupData;
  const GroupPage({super.key, required this.groupData});

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  List<dynamic> members = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMembers();
  }

  Future<void> _loadMembers() async {
    final data = await ApiService().fetchGroupMembers(
      widget.groupData['group_id'],
    );
    setState(() {
      members = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.groupData['group_name'] ?? 'Group Info'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : members.isEmpty
          ? Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.person_add),
                label: const Text("Add Member"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          AddMemberPage(groupId: widget.groupData['group_id']),
                    ),
                  );
                },
              ),
            )
          : ListView.builder(
              itemCount: members.length,
              itemBuilder: (context, index) {
                final member = members[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(
                      "${member['first_name']} ${member['last_name']}",
                    ),
                    subtitle: Text("BMI: ${member['bmi']}"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MemberPlanPage(
                            groupId: widget.groupData['group_id'],
                            memberId: member['member_id'],
                            memberName:
                                "${member['first_name']} ${member['last_name']}",
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
