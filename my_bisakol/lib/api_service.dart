import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Use the base URL provided in the instructions
  static const String _baseUrl = 'https://poltergeists.online/api';

  // 1. /get/group/information?group_name=...
  Future<Map<String, dynamic>?> searchGroup(String groupName) async {
    // URL construction with query parameter
    final url = Uri.parse(
      '$_baseUrl/get/group/information?group_name=$groupName',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final dynamic decodedBody = json.decode(response.body);

        // API is expected to return a single Map or an empty response
        if (decodedBody is Map<String, dynamic> && decodedBody.isNotEmpty) {
          return decodedBody;
        }
        // If it returns a list, take the first element (common API pattern)
        else if (decodedBody is List && decodedBody.isNotEmpty) {
          return decodedBody.first as Map<String, dynamic>;
        }
        // Handle empty or unexpected response
        return null;
      }
      return null;
    } catch (e) {
      print('Error searching group: $e');
      return null;
    }
  }

  // 2. /post/group/information
  // Form parameters: group_name, section
  Future<bool> createGroup(String groupName, String section) async {
    final url = Uri.parse('$_baseUrl/post/group/information');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        // Use the required form parameters
        body: json.encode({'group_name': groupName, 'section': section}),
      );

      // Status 200 or 201 indicates successful creation
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error creating group: $e');
      return false;
    }
  }

  // 3. /get/members/{group_id}
  Future<List<Map<String, dynamic>>> getGroupMembers(String groupId) async {
    // URL construction with path parameter
    final url = Uri.parse('$_baseUrl/get/members/$groupId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final dynamic decodedBody = json.decode(response.body);

        // Expecting a list of members
        if (decodedBody is List) {
          return decodedBody.cast<Map<String, dynamic>>();
        }
        return [];
      }
      return [];
    } catch (e) {
      print('Error fetching members: $e');
      return [];
    }
  }

  // 4. /create/member/{group_id}
  // Form parameters: last_name, first_name, birthday, height, weight, bmi (and others like sex)
  Future<bool> createMember(
    String groupId,
    Map<String, dynamic> memberData,
  ) async {
    // URL construction with path parameter
    final url = Uri.parse('$_baseUrl/create/member/$groupId');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        // memberData already contains all form fields
        body: json.encode(memberData),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error creating member: $e');
      return false;
    }
  }

  // 5. /get/wellness/plan/{group_id}/{member_id}
  Future<List<Map<String, dynamic>>> getWellnessPlans(
    String groupId,
    String memberId,
  ) async {
    // URL construction with two path parameters
    final url = Uri.parse('$_baseUrl/get/wellness/plan/$groupId/$memberId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final dynamic decodedBody = json.decode(response.body);

        // Expecting a list of wellness plans
        if (decodedBody is List) {
          return decodedBody.cast<Map<String, dynamic>>();
        }
        return [];
      }
      return [];
    } catch (e) {
      print('Error fetching plans: $e');
      return [];
    }
  }

  // 6. /create/wellness/plan
  // Form parameters: group_id, member_id, dayofWeek, diet_plan, work_plan, tips
  Future<bool> createWellnessPlan(Map<String, dynamic> planData) async {
    // URL construction without path parameters (data included in body)
    final url = Uri.parse('$_baseUrl/create/wellness/plan');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        // planData already contains all required form fields
        body: json.encode(planData),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error creating plan: $e');
      return false;
    }
  }
}
