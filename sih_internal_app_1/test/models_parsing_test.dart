// Basic JSON parsing tests for models
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:sih_internal_app_1/src/models/assessment_category.dart';
import 'package:sih_internal_app_1/src/models/leaderboard_entry.dart';
import 'package:sih_internal_app_1/src/models/notification.dart';
import 'package:sih_internal_app_1/src/models/results.dart';

void main() {
  test('AssessmentCategory.fromJson', () {
    final jsonMap = json.decode('''
      {"title":"Vertical Jump","icon":"arrow_upward","color":"#FF6B6B","subtitle":"Explosive Power","duration":"2 min","description":"Measures leg power","isPopular":true}
    ''') as Map<String, dynamic>;
    final m = AssessmentCategory.fromJson(jsonMap);
    expect(m.title, 'Vertical Jump');
    expect(m.iconKey, 'arrow_upward');
    expect(m.colorHex, '#FF6B6B');
    expect(m.isPopular, true);
  });

  test('LeaderboardEntry.fromJson', () {
    final jsonMap = json.decode('''
      {"rank":1,"name":"Alice","points":980,"change":5}
    ''') as Map<String, dynamic>;
    final m = LeaderboardEntry.fromJson(jsonMap);
    expect(m.rank, 1);
    expect(m.name, 'Alice');
    expect(m.points, 980);
    expect(m.change, 5);
  });

  test('NotificationItem.fromJson', () {
    final jsonMap = json.decode('''
      {"id":"n1","title":"Result Ready","message":"Your jump results are ready","type":"result","timestamp":"2025-09-15T10:00:00Z","isRead":false}
    ''') as Map<String, dynamic>;
    final m = NotificationItem.fromJson(jsonMap);
    expect(m.id, 'n1');
    expect(m.type, NotificationType.result);
    expect(m.isRead, false);
  });

  test('ResultSummary.fromJson and JumpEntry.fromJson', () {
    final summaryMap = json.decode('''
      {"total_jumps":10,"best_jump_height":45.6,"best_jump_distance":120.3,"best_jump_flight_time":0.45,"average_height":35.2,"average_distance":100.1,"average_knee_angle":120.0,"average_flight_time":0.40}
    ''') as Map<String, dynamic>;
    final s = ResultSummary.fromJson(summaryMap);
    expect(s.totalJumps, 10);
    expect(s.bestJumpHeight, 45.6);

    final jumpMap = json.decode('''
      {"Jump Height (relative)":30.5,"Jump Distance (relative)":110.2,"Knee Angle at crouch":118.0,"Flight Time (s)":0.38}
    ''') as Map<String, dynamic>;
    final j = JumpEntry.fromJson(jumpMap);
    expect(j.heightRelative, 30.5);
    expect(j.flightTime, 0.38);
  });
}
