import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MemberPlanPage extends StatefulWidget {
  final int groupId;
  final Map member;
  MemberPlanPage({required this.groupId, required this.member});

  @override
  State<MemberPlanPage> createState() => _MemberPlanPageState();
}

class _MemberPlanPageState extends State<MemberPlanPage> {
  final TextEditingController _dietPlan = TextEditingController();
  final TextEditingController _workPlan = TextEditingController();
  final TextEditingController _tips = TextEditingController();
  String _selectedDay = 'Monday';

  Future<void> createPlan() async {
    final url = Uri.parse(
      'https://poltergeists.online/api/create/wellness/plan',
    );
    final response = await http.post(
      url,
      body: {
        'group_id': widget.groupId.toString(),
        'member_id': widget.member['member_id'].toString(),
        'dayofWeek': _selectedDay,
        'diet_plan': _dietPlan.text,
        'work_plan': _workPlan.text,
        'tips': _tips.text,
      },
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Plan created!')));
      _dietPlan.clear();
      _workPlan.clear();
      _tips.clear();
    } else {
      throw Exception('Failed to create plan');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.member['first_name']} ${widget.member['last_name']}',
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            DropdownButtonFormField<String>(
              value: _selectedDay,
              items:
                  [
                        'Monday',
                        'Tuesday',
                        'Wednesday',
                        'Thursday',
                        'Friday',
                        'Saturday',
                        'Sunday',
                      ]
                      .map(
                        (day) => DropdownMenuItem(value: day, child: Text(day)),
                      )
                      .toList(),
              onChanged: (val) => setState(() => _selectedDay = val!),
              decoration: InputDecoration(labelText: 'Day of Week'),
            ),
            TextField(
              controller: _dietPlan,
              decoration: InputDecoration(labelText: 'Diet Plan'),
            ),
            TextField(
              controller: _workPlan,
              decoration: InputDecoration(labelText: 'Workout Plan'),
            ),
            TextField(
              controller: _tips,
              decoration: InputDecoration(labelText: 'Tips'),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: createPlan, child: Text('Save Plan')),
          ],
        ),
      ),
    );
  }
}
