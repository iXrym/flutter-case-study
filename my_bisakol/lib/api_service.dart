import 'dart:convert';
import 'package:http/http.dart' as http;

/// ApiService - centralizes all API calls to the provided domain.
///
/// Base URL: https://poltergeists.online/api
class ApiService {
  final String base = 'https://poltergeists.online/api';

  /// GET /get/group/information?group_name=...
  /// Returns a Map (group object) or null if not found/empty
  Future<Map<String, dynamic>?> getGroupInfo(String groupName) async {
    final uri = Uri.parse('$base/get/group/information')
        .replace(queryParameters: {'group_name': groupName});
    final res = await http.get(uri);
    if (res.statusCode == 200) {
      final decoded = jsonDecode(res.body);
      if (decoded == null) return null;
      if (decoded is Map && decoded.isNotEmpty) return Map<String, dynamic>.from(decoded);
      // if response is a list and empty -> treat as null
      return null;
    } else {
      throw Exception('Failed to fetch group info: ${res.statusCode}');
    }
  }

  /// POST /post/group/information
  /// Body: group_name, section
  /// Returns true if created (status 200), false otherwise
  Future<bool> createGroup({required String groupName, required String section}) async {
    final uri = Uri.parse('$base/post/group/information');
    final res = await http.post(uri, body: {
      'group_name': groupName,
      'section': section,
    });
    return res.statusCode == 200;
  }

  /// GET /get/members/{group_id}
  /// Returns List of members
  Future<List<Map<String, dynamic>>> getMembers(int groupId) async {
    final uri = Uri.parse('$base/get/members/$groupId');
    final res = await http.get(uri);
    if (res.statusCode == 200) {
      final decoded = jsonDecode(res.body);
      if (decoded is List) {
        return List<Map<String, dynamic>>.from(decoded.map((e) => Map<String, dynamic>.from(e)));
      }
      return [];
    } else {
      throw Exception('Failed to fetch members: ${res.statusCode}');
    }
  }

  /// POST /create/member/{group_id}
  /// Body: group_id, last_name, first_name, birthday, height, weight, bmi
  Future<bool> createMember({
    required int groupId,
    required String lastName,
    required String firstName,
    required String birthday,
    required String height,
    required String weight,
    required String bmi,
  }) async {
    final uri = Uri.parse('$base/create/member/$groupId');
    final res = await http.post(uri, body: {
      'group_id': groupId.toString(),
      'last_name': lastName,
      'first_name': firstName,
      'birthday': birthday,
      'height': height,
      'weight': weight,
      'bmi': bmi,
    });
    return res.statusCode == 200;
  }

  /// GET /get/wellness/plan/{group_id}/{member_id}
  Future<List<Map<String, dynamic>>> getWellnessPlans(int groupId, int memberId) async {
    final uri = Uri.parse('$base/get/wellness/plan/$groupId/$memberId');
    final res = await http.get(uri);
    if (res.statusCode == 200) {
      final decoded = jsonDecode(res.body);
      if (decoded is List) {
        return List<Map<String, dynamic>>.from(decoded.map((e) => Map<String, dynamic>.from(e)));
      }
      return [];
    } else {
      throw Exception('Failed to fetch wellness plans: ${res.statusCode}');
    }
  }

  /// POST /create/wellness/plan
  /// Body: group_id, member_id, dayofWeek, diet_plan, work_plan, tips
  Future<bool> createWellnessPlan({
    required int groupId,
    required int memberId,
    required String dayOfWeek,
    required String dietPlan,
    required String workPlan,
    required String tips,
  }) async {
    final uri = Uri.parse('$base/create/wellness/plan');
    final res = await http.post(uri, body: {
      'group_id': groupId.toString(),
      'member_id': memberId.toString(),
      'dayofWeek': dayOfWeek,
      'diet_plan': dietPlan,
      'work_plan': workPlan,
      'tips': tips,
    });
    return res.statusCode == 200;
  }
}
