import 'package:flutter/material.dart';
import 'api_service.dart';
import 'AddMemberPage.dart';
import 'MemberPlanPage.dart';

class GroupPage extends StatefulWidget {
  final Map<String, dynamic> groupData;

  const GroupPage({required this.groupData, super.key});

  @override
  State<GroupPage> createState() => GroupPageState();
}

class GroupPageState extends State<GroupPage> {
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  List<Map<String, dynamic>> _groupMembers = [];
  late String _groupName;
  late String _groupId;

  @override
  void initState() {
    super.initState();
    // Use the keys returned from the searchGroup API call
    _groupName =
        widget.groupData['group_name'] ??
        widget.groupData['Groupname'] ??
        'Group Details';
    // Ensure group_id is a string, which is needed for URL paths
    _groupId = widget.groupData['group_id']?.toString() ?? '';
    _loadGroupMembers();
  }

  Future<void> _loadGroupMembers() async {
    if (_groupId.isEmpty) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    if (mounted) setState(() => _isLoading = true);

    // API Call: Fetch members using /get/members/{group_id}
    final fetchedMembers = await _apiService.getGroupMembers(_groupId);

    if (mounted) {
      setState(() {
        _groupMembers = fetchedMembers;
        _isLoading = false;
      });
    }
  }

  void _navigateToAddMember() async {
    if (_groupId.isEmpty) return;

    // Navigate to AddMemberPage, waiting for result to refresh list
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddMemberPage(groupId: _groupId)),
    );

    // If result is true (member added), refresh the list
    if (result == true) {
      _loadGroupMembers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Group: $_groupName'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _loadGroupMembers,
            tooltip: 'Refresh Members',
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Group Information Card
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.green.shade50,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$_groupName',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade800,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Section: ${widget.groupData['section'] ?? widget.groupData['Section'] ?? 'N/A'}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      'Group ID: $_groupId',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Text(
              'Group Members',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(indent: 16, endIndent: 16),

          // Member List View
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _groupMembers.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'No members assigned yet.',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        const SizedBox(height: 10),
                        // 2.3 Response data returned empty, show button to assist creation
                        ElevatedButton.icon(
                          onPressed: _navigateToAddMember,
                          icon: const Icon(Icons.group_add),
                          label: const Text('Add First Member'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade500,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _groupMembers.length,
                    itemBuilder: (context, index) {
                      final member = _groupMembers[index];
                      final memberName =
                          '${member['first_name'] ?? 'Member'} ${member['last_name'] ?? ''}';

                      // Member card that redirects to MemberPlanPage
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        elevation: 2,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.green.shade600,
                            child: const Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            memberName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'BMI: ${member['bmi'] ?? 'N/A'} | Height: ${member['height'] ?? 'N/A'} cm',
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                          ),
                          onTap: () {
                            // Redirect to Member Plan Page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MemberPlanPage(
                                  groupId: _groupId,
                                  memberData: member,
                                ),
                              ),
                            ).then(
                              (_) => _loadGroupMembers(),
                            ); // Refresh when returning
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      // Floating button to add members, always visible if not loading
      floatingActionButton: _isLoading && _groupMembers.isEmpty
          ? null
          : FloatingActionButton.extended(
              onPressed: _navigateToAddMember,
              icon: const Icon(Icons.group_add),
              label: const Text('Add Member'),
              backgroundColor: Colors.green.shade700,
              foregroundColor: Colors.white,
            ),
    );
  }
}
