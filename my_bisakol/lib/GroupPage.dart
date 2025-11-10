import 'package:flutter/material.dart';
import 'addmemberpage.dart';
import 'memberplanpage.dart';
import 'api_service.dart';

class GroupPage extends StatefulWidget {
  final Map<String, dynamic> groupData;
  const GroupPage({super.key, required this.groupData});

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  List members = [];
  final ApiService _apiService = ApiService();

  Future<void> fetchMembers() async {
    final groupId = widget.groupData['group_id'];
    try {
      final fetchedMembers = await _apiService.getMembers(groupId);
      if (mounted) {
        setState(() {
          members = fetchedMembers;
        });
      }
    } catch (e) {
      print('Error fetching members: $e');
      if (mounted) {
        setState(() {
          members = [];
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchMembers();
  }

  @override
  Widget build(BuildContext context) {
    final group = widget.groupData;
    final groupId = group['group_id'];
    return Scaffold(
      appBar: AppBar(title: Text('Group: ${group['group_name']}')),
      body: RefreshIndicator(
        onRefresh: fetchMembers,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Card(
                child: ListTile(
                  title: Text('Group: ${group['group_name']}'),
                  subtitle: Text('Section: ${group['section']} (ID: $groupId)'),
                  onTap: () {
                    // Group Card Tap action
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Add Member button appears if there are no members
              if (members.isEmpty)
                ElevatedButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddMemberPage(groupId: groupId),
                      ),
                    );
                    fetchMembers(); // Refresh the member list
                  },
                  child: const Text('Add Member'),
                ),

              if (members.isNotEmpty)
                const Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'Group Members:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),

              Expanded(
                child: ListView.builder(
                  itemCount: members.length,
                  itemBuilder: (_, index) {
                    final member = members[index];
                    return Card(
                      child: ListTile(
                        title: Text(
                          '${member['first_name']} ${member['last_name']}',
                        ),
                        subtitle: Text('BMI: ${member['bmi']}'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MemberPlanPage(
                                groupId: groupId,
                                member: member,
                              ),
                            ),
                          ).then((_) => fetchMembers()); // Refresh on return
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
