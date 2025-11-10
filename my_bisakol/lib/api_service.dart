import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "https://poltergeists.online";

  Future<Map<String, dynamic>?> fetchGroupInfo(
    String groupName,
    String section,
  ) async {
    final url = Uri.parse('$baseUrl/post/group/information');
    final response = await http.post(
      url,
      body: {'group_name': groupName, 'section': section},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data == null || data.isEmpty) return null;
      return data;
    } else {
      print('Error fetching group info: ${response.statusCode}');
      return null;
    }
  }

  Future<bool> createGroup(String groupName, String section) async {
    final url = Uri.parse('$baseUrl/create/group');
    final response = await http.post(
      url,
      body: {'group_name': groupName, 'section': section},
    );
    return response.statusCode == 200;
  }

  Future<List<dynamic>> fetchGroupMembers(int groupId) async {
    final url = Uri.parse('$baseUrl/get/members/$groupId');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data ?? [];
    } else {
      print('Error fetching members: ${response.statusCode}');
      return [];
    }
  }

  Future<bool> createMember({
    required int groupId,
    required String firstName,
    required String lastName,
    required String birthday,
    required String height,
    required String weight,
    required String bmi,
  }) async {
    final url = Uri.parse('$baseUrl/create/member/group_id');
    final response = await http.post(
      url,
      body: {
        'group_id': groupId.toString(),
        'first_name': firstName,
        'last_name': lastName,
        'birthday': birthday,
        'height': height,
        'weight': weight,
        'bmi': bmi,
      },
    );
    return response.statusCode == 200;
  }

  Future<bool> createWellnessPlan({
    required int groupId,
    required int memberId,
    required String dayOfWeek,
    required String dietPlan,
    required String workPlan,
    required String tips,
  }) async {
    final url = Uri.parse('$baseUrl/create/wellness/plan');
    final response = await http.post(
      url,
      body: {
        'group_id': groupId.toString(),
        'member_id': memberId.toString(),
        'dayofWeek': dayOfWeek,
        'diet_plan': dietPlan,
        'work_plan': workPlan,
        'tips': tips,
      },
    );
    return response.statusCode == 200;
  }
}
