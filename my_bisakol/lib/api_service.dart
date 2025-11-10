class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // --- MOCK DATABASE ---
  static final List<Group> _groupsDb = [
    Group(groupId: 'g1', groupName: 'IronTeam', section: 'A-2025'),
    Group(groupId: 'g2', groupName: 'FitSquad', section: 'B-2025'),
  ];
  static final Map<String, List<Member>> _membersDb = {
    'g1': [
      Member(
        memberId: 'm1',
        groupId: 'g1',
        firstName: 'Alex',
        lastName: 'Johnson',
        birthday: '1998-05-15',
        height: 175,
        weight: 70,
        bmi: 22.9,
      ),
      Member(
        memberId: 'm2',
        groupId: 'g1',
        firstName: 'Ben',
        lastName: 'Clark',
        birthday: '1995-11-20',
        height: 185,
        weight: 90,
        bmi: 26.3,
      ),
    ],
    'g2': [],
  };
  static final Map<String, List<WellnessPlan>> _plansDb = {
    'm1': [
      WellnessPlan(
        dayofWeek: 'Monday',
        dietPlan: 'High Protein',
        workPlan: 'Leg Day',
        tips: 'Stretch well.',
      ),
      WellnessPlan(
        dayofWeek: 'Tuesday',
        dietPlan: 'Low Carb',
        workPlan: 'Cardio & Abs',
        tips: 'Hydrate every hour.',
      ),
    ],
  };
  // ---------------------

  Future<List<Group>> searchGroup(String groupName) async {
    // /get/group/information
    await Future.delayed(const Duration(milliseconds: 500));
    final found = _groupsDb
        .where((g) => g.groupName.toLowerCase() == groupName.toLowerCase())
        .toList();
    return found;
  }

  Future<Group> createGroup(String groupName, String section) async {
    // /post/group/information
    await Future.delayed(const Duration(milliseconds: 500));
    final newGroup = Group(
      groupId: 'g${_groupsDb.length + 1}',
      groupName: groupName,
      section: section,
    );
    _groupsDb.add(newGroup);
    _membersDb[newGroup.groupId] = [];
    return newGroup;
  }

  Future<List<Member>> getMembers(String groupId) async {
    // /get/members/group_id
    await Future.delayed(const Duration(milliseconds: 500));
    return _membersDb[groupId] ?? [];
  }

  Future<Member> createMember(
    String groupId,
    String firstName,
    String lastName,
    String birthday,
    double height,
    double weight,
  ) async {
    // /create/member/group_id
    await Future.delayed(const Duration(milliseconds: 500));
    final double bmi = weight / pow(height / 100, 2);

    final newMember = Member(
      memberId: 'm${Random().nextInt(10000)}',
      groupId: groupId,
      firstName: firstName,
      lastName: lastName,
      birthday: birthday,
      height: height,
      weight: weight,
      bmi: double.parse(bmi.toStringAsFixed(1)),
    );

    _membersDb[groupId]?.add(newMember);
    _plansDb[newMember.memberId] = [];
    return newMember;
  }

  Future<List<WellnessPlan>> getWellnessPlan(String memberId) async {
    // /get/wellness/plan/group_id/member_id
    await Future.delayed(const Duration(milliseconds: 500));
    return _plansDb[memberId] ?? [];
  }

  Future<bool> createWellnessPlan(String memberId, WellnessPlan plan) async {
    // /create/wellness/plan
    await Future.delayed(const Duration(milliseconds: 500));
    if (!_plansDb.containsKey(memberId)) {
      _plansDb[memberId] = [];
    }
    // Remove existing plan for the day, then add new one
    _plansDb[memberId]!.removeWhere((p) => p.dayofWeek == plan.dayofWeek);
    _plansDb[memberId]!.add(plan);
    return true;
  }
}
