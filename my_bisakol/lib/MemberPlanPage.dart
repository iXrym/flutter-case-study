import 'package:flutter/material.dart';
import 'api_service.dart';

class MemberPage extends StatefulWidget {
  final int groupId;
  final int memberId;
  final String memberName;

  const MemberPage({
    super.key,
    required this.groupId,
    required this.memberId,
    required this.memberName,
  });

  @override
  State<MemberPage> createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage> {
  List<Map<String, dynamic>> _plans = [];
  bool _loading = true;

  final _diet = TextEditingController();
  final _work = TextEditingController();
  final _tips = TextEditingController();
  String _day = 'Monday';
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadPlans();
  }

  Future<void> _loadPlans() async {
    setState(() => _loading = true);
    try {
      final data = await ApiService().getWellnessPlans(
        widget.groupId,
        widget.memberId,
      );
      setState(() => _plans = data);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error loading plans: $e')));
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _savePlan() async {
    setState(() => _saving = true);
    final ok = await ApiService().createWellnessPlan(
      groupId: widget.groupId,
      memberId: widget.memberId,
      dayOfWeek: _day,
      dietPlan: _diet.text.trim(),
      workPlan: _work.text.trim(),
      tips: _tips.text.trim(),
    );
    setState(() => _saving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(ok ? 'Plan saved' : 'Failed to save plan')),
    );
    if (ok) {
      _diet.clear();
      _work.clear();
      _tips.clear();
      _loadPlans();
    }
  }

  @override
  Widget build(BuildContext context) {
    final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];
    return Scaffold(
      appBar: AppBar(title: Text('${widget.memberName}')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _plans.isEmpty
                  ? const Center(child: Text('No wellness plans yet'))
                  : ListView.builder(
                      itemCount: _plans.length,
                      itemBuilder: (context, i) {
                        final p = _plans[i];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            title: Text(p['dayofWeek'] ?? 'Day'),
                            subtitle: Text(
                              'Diet: ${p['diet_plan'] ?? ''}\nWorkout: ${p['work_plan'] ?? ''}\nTips: ${p['tips'] ?? ''}',
                            ),
                          ),
                        );
                      },
                    ),
            ),
            const Divider(),
            const Text(
              'Create Wellness Plan (Mon–Fri)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _day,
              items: days
                  .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                  .toList(),
              onChanged: (v) => setState(() => _day = v ?? _day),
              decoration: const InputDecoration(labelText: 'Day of Week'),
            ),
            TextField(
              controller: _diet,
              decoration: const InputDecoration(labelText: 'Diet Plan'),
            ),
            TextField(
              controller: _work,
              decoration: const InputDecoration(labelText: 'Workout Plan'),
            ),
            TextField(
              controller: _tips,
              decoration: const InputDecoration(labelText: 'Tips'),
            ),
            const SizedBox(height: 8),
            _saving
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _savePlan,
                    child: const Text('Save Plan'),
                  ),
          ],
        ),
      ),
    );
  }
}
