import 'package:flutter/material.dart';
import 'api_service.dart';

class MemberPlanPage extends StatefulWidget {
  final int groupId;
  final int memberId;
  final String memberName;

  const MemberPlanPage({
    super.key,
    required this.groupId,
    required this.memberId,
    required this.memberName,
  });

  @override
  State<MemberPlanPage> createState() => _MemberPlanPageState();
}

class _MemberPlanPageState extends State<MemberPlanPage> {
  final TextEditingController diet = TextEditingController();
  final TextEditingController work = TextEditingController();
  final TextEditingController tips = TextEditingController();
  String selectedDay = "Monday";

  void _savePlan() async {
    final success = await ApiService().createWellnessPlan(
      groupId: widget.groupId,
      memberId: widget.memberId,
      dayOfWeek: selectedDay,
      dietPlan: diet.text,
      workPlan: work.text,
      tips: tips.text,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(success ? "Plan saved!" : "Failed to save plan")),
    );

    if (success) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${widget.memberName}'s Wellness Plan")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            DropdownButtonFormField<String>(
              value: selectedDay,
              items:
                  const ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
                      .map(
                        (day) => DropdownMenuItem(value: day, child: Text(day)),
                      )
                      .toList(),
              onChanged: (val) => setState(() => selectedDay = val!),
              decoration: const InputDecoration(labelText: "Day of the Week"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: diet,
              decoration: const InputDecoration(labelText: "Diet Plan"),
            ),
            TextField(
              controller: work,
              decoration: const InputDecoration(labelText: "Workout Plan"),
            ),
            TextField(
              controller: tips,
              decoration: const InputDecoration(labelText: "Tips"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _savePlan,
              child: const Text("Save Plan"),
            ),
          ],
        ),
      ),
    );
  }
}
