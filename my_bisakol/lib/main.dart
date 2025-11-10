import 'package:flutter/material.dart';
import 'dart:math';

// =========================================================================
// 1. DATA MODELS
// =========================================================================

class Group {
  final String groupId;
  final String groupName;
  final String section;

  Group({
    required this.groupId,
    required this.groupName,
    required this.section,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      groupId: json['group_id'] as String,
      groupName: json['group_name'] as String,
      section: json['section'] as String,
    );
  }
}

class Member {
  final String memberId;
  final String groupId;
  final String firstName;
  final String lastName;
  final String birthday;
  final double height; // cm
  final double weight; // kg
  final double bmi;

  Member({
    required this.memberId,
    required this.groupId,
    required this.firstName,
    required this.lastName,
    required this.birthday,
    required this.height,
    required this.weight,
    required this.bmi,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      memberId: json['member_id'] as String,
      groupId: json['group_id'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      birthday: json['birthday'] as String,
      height: (json['height'] as num).toDouble(),
      weight: (json['weight'] as num).toDouble(),
      bmi: (json['bmi'] as num).toDouble(),
    );
  }
}

class WellnessPlan {
  final String dayofWeek;
  final String dietPlan;
  final String workPlan;
  final String tips;

  WellnessPlan({
    required this.dayofWeek,
    required this.dietPlan,
    required this.workPlan,
    required this.tips,
  });

  factory WellnessPlan.fromJson(Map<String, dynamic> json) {
    return WellnessPlan(
      dayofWeek: json['dayofWeek'] as String,
      dietPlan: json['diet_plan'] as String,
      workPlan: json['work_plan'] as String,
      tips: json['tips'] as String,
    );
  }
}
