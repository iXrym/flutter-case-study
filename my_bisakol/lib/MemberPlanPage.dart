import 'package:flutter/material.dart';
import 'api_service.dart';

class MemberPlanPage extends StatefulWidget {
  final String groupId;
  final Map<String, dynamic> memberData;

  const MemberPlanPage({
    required this.groupId,
    required this.memberData,
    super.key,
  });

  @override
  State<MemberPlanPage> createState() => _MemberPlanPageState();
}

class _MemberPlanPageState extends State<MemberPlanPage>
    with SingleTickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();

  late TabController _tabController;

  bool _isLoadingPlans = true;
  List<Map<String, dynamic>> _wellnessPlans = [];
  bool _isSubmittingPlan = false;

  late String _memberId;
  late String _memberName;
  late String _memberBMI;

  String? _selectedDay;
  final TextEditingController dietController = TextEditingController();
  final TextEditingController workController = TextEditingController();
  final TextEditingController tipsController = TextEditingController();

  final List<String> daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _memberId = widget.memberData['member_id']?.toString() ?? 'N/A';
    _memberName =
        '${widget.memberData['first_name'] ?? ''} ${widget.memberData['last_name'] ?? 'Member'}';
    _memberBMI = widget.memberData['bmi']?.toString() ?? 'N/A';

    _loadWellnessPlans();
  }

  @override
  void dispose() {
    _tabController.dispose();
    dietController.dispose();
    workController.dispose();
    tipsController.dispose();
    super.dispose();
  }

  // API Call: /get/wellness/plan/{group_id}/{member_id}
  Future<void> _loadWellnessPlans() async {
    if (_memberId == 'N/A') {
      if (mounted) setState(() => _isLoadingPlans = false);
      return;
    }

    if (mounted) setState(() => _isLoadingPlans = true);

    final fetchedPlans = await _apiService.getWellnessPlans(
      widget.groupId,
      _memberId,
    );

    if (mounted) {
      setState(() {
        // Sort plans by day of week for consistent viewing
        _wellnessPlans = _sortPlansByDay(fetchedPlans);
        _isLoadingPlans = false;
      });
    }
  }

  // Sort plans based on the defined order of days
  List<Map<String, dynamic>> _sortPlansByDay(List<Map<String, dynamic>> plans) {
    final dayOrder = {
      'Monday': 0,
      'Tuesday': 1,
      'Wednesday': 2,
      'Thursday': 3,
      'Friday': 4,
      'Saturday': 5,
      'Sunday': 6,
    };
    plans.sort((a, b) {
      final orderA = dayOrder[a['day_of_week'] ?? ''] ?? 7;
      final orderB = dayOrder[b['day_of_week'] ?? ''] ?? 7;
      return orderA.compareTo(orderB);
    });
    return plans;
  }

  // API Call: /create/wellness/plan
  void submitPlan() async {
    if (formKey.currentState!.validate() && _selectedDay != null) {
      setState(() {
        _isSubmittingPlan = true;
      });

      final planData = {
        'group_id': widget.groupId,
        'member_id': _memberId,
        // FIX: Key is 'dayofWeek' in prompt, using 'day_of_week' for consistency, but if API fails, change to 'dayofWeek'
        'dayofWeek': _selectedDay,
        'diet_plan': dietController.text,
        // FIX: Key is 'work_plan' in prompt, using 'workout_plan' for consistency, but if API fails, change to 'work_plan'
        'work_plan': workController.text,
        'tips': tipsController.text,
      };

      final success = await _apiService.createWellnessPlan(planData);

      if (mounted) {
        setState(() {
          _isSubmittingPlan = false;
        });

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Plan created successfully for $_selectedDay!'),
            ),
          );
          _loadWellnessPlans();
          dietController.clear();
          workController.clear();
          tipsController.clear();
          setState(() {
            _selectedDay = null;
          });
          _tabController.animateTo(1); // Switch to View Plans tab
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to create wellness plan.')),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields and select a day.'),
        ),
      );
    }
  }

  Widget _buildMemberCard() {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.teal.shade50,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$_memberName\'s Fitness Plan',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.teal.shade800,
              ),
            ),
            const Divider(color: Colors.teal),
            _buildPlanDetail('Member ID:', _memberId),
            _buildPlanDetail('Group ID:', widget.groupId),
            _buildPlanDetail('BMI:', _memberBMI),
            // Add other member details here if needed
          ],
        ),
      ),
    );
  }

  Widget _buildPlanDetail(String title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 5),
          Expanded(child: Text(value?.toString() ?? 'N/A')),
        ],
      ),
    );
  }

  Widget _buildCreatePlanTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Create Plan for $_memberName',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),

            // Dropdown Day of the Week
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Day of the Week',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.calendar_today),
              ),
              value: _selectedDay,
              items: daysOfWeek
                  .map((day) => DropdownMenuItem(value: day, child: Text(day)))
                  .toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedDay = newValue;
                });
              },
              validator: (v) => v == null ? 'Day is required' : null,
            ),
            const SizedBox(height: 16),

            // Diet Plan
            TextFormField(
              controller: dietController,
              decoration: const InputDecoration(
                labelText: 'Diet Plan',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.local_dining),
              ),
              validator: (v) => v!.isEmpty ? 'Diet plan is required' : null,
            ),
            const SizedBox(height: 16),

            // Workout Plan
            TextFormField(
              controller: workController,
              decoration: const InputDecoration(
                labelText: 'Workout Plan',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.fitness_center),
              ),
              // FIX: Key is 'work_plan' in the prompt
              validator: (v) => v!.isEmpty ? 'Workout plan is required' : null,
            ),
            const SizedBox(height: 16),

            // Tips
            TextFormField(
              controller: tipsController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Tips',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lightbulb_outline),
              ),
              validator: (v) => v!.isEmpty ? 'Tips are required' : null,
            ),

            const SizedBox(height: 30),

            // Save Button
            ElevatedButton.icon(
              onPressed: _isSubmittingPlan ? null : submitPlan,
              icon: _isSubmittingPlan
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.save),
              label: Text(
                _isSubmittingPlan ? 'Saving Plan...' : 'Save Wellness Plan',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildViewPlansTab() {
    if (_isLoadingPlans) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_wellnessPlans.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'No wellness plans created yet.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () => _tabController.animateTo(0),
              icon: const Icon(Icons.add),
              label: const Text('Create the First Plan'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _wellnessPlans.length,
      itemBuilder: (context, index) {
        final plan = _wellnessPlans[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  // FIX: Key is 'dayofWeek' in the prompt
                  plan['dayofWeek'] ?? 'Plan',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Colors.teal.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(),
                _buildPlanDetail('Diet Plan:', plan['diet_plan']),
                // FIX: Key is 'work_plan' in the prompt
                _buildPlanDetail('Workout Plan:', plan['work_plan']),
                _buildPlanDetail('Tips:', plan['tips']),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Plan for $_memberName'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.edit), text: 'Create Plan'),
            Tab(icon: Icon(Icons.list), text: 'View Plans'),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildMemberCard(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_buildCreatePlanTab(), _buildViewPlansTab()],
            ),
          ),
        ],
      ),
    );
  }
}
