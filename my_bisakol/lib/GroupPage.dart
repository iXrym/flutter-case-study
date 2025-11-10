import 'package:flutter/material.dart';
import 'api_service.dart';
import 'AddMemberPage.dart';
import 'MemberPage.dart';

class GroupPage extends StatefulWidget {
  final Map<String, dynamic> groupData;
  const GroupPage({super.key, required this.groupData});

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  List<Map<String, dynamic>> _members = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadMembers();
  }

  Future<void> _loadMembers() async {
    setState(() => _loading = true);

    try {
      final gid =
          widget.groupData['group_id'] ??
          widget.groupData['groupId'] ??
          widget.groupData['id'];
      if (gid == null) throw Exception('group_id missing from server response');
      final data = await ApiService().getMembers(int.parse(gid.toString()));
      setState(() => _members = data);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error loading members: $e')));
    } finally {
      setState(() => _loading = false);
    }
  }

  void _openAddMember() {
    final gid =
        widget.groupData['group_id'] ??
        widget.groupData['groupId'] ??
        widget.groupData['id'];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddMemberPage(groupId: int.parse(gid.toString())),
      ),
    ).then((_) => _loadMembers());
  }

  @override
  Widget build(BuildContext context) {
    final groupName =
        widget.groupData['group_name'] ?? widget.groupData['name'] ?? 'Group';
    final section = widget.groupData['section'] ?? '';

    return Scaffold(
      appBar: AppBar(title: Text(groupName)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Card(
                    child: ListTile(
                      title: Text(groupName),
                      subtitle: Text('Section: $section'),
                      onTap: () {}, // taps could perhaps open more group detail
                    ),
                  ),
                ),
                Expanded(
                  child: _members.isEmpty
                      ? Center(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.person_add),
                            label: const Text('Add Member'),
                            onPressed: _openAddMember,
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _loadMembers,
                          child: ListView.builder(
                            itemCount: _members.length,
                            itemBuilder: (context, i) {
                              final m = _members[i];
                              final name =
                                  '${m['first_name'] ?? ''} ${m['last_name'] ?? ''}';
                              final bmi = m['bmi']?.toString() ?? '';
                              final memberId = m['member_id'] ?? m['id'];
                              return Card(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                child: ListTile(
                                  title: Text(name),
                                  subtitle: Text('BMI: $bmi'),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => MemberPage(
                                          groupId: int.parse(
                                            (widget.groupData['group_id'] ??
                                                    widget.groupData['id'])
                                                .toString(),
                                          ),
                                          memberId: int.parse(
                                            memberId.toString(),
                                          ),
                                          memberName: name,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
    );
  }
}
