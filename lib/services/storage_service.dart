import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/assignment.dart';
import '../models/academic_session.dart';

class StorageService {
  static const String _assignmentsKey = 'assignments';
  static const String _sessionsKey = 'academic_sessions';
  static const String _boxName = 'formative_box';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(_boxName);
  }

  static Box _getBox() => Hive.box(_boxName);

  static Future<List<Assignment>> getAssignments() async {
    try {
      final box = _getBox();
      final assignmentsJson =
          box.get(_assignmentsKey, defaultValue: <String>[]) as List;

      return assignmentsJson
          .map((json) => Assignment.fromJson(jsonDecode(json)))
          .toList();
    } catch (e) {
      return [];
    }
  }

  static Future<void> saveAssignments(List<Assignment> assignments) async {
    try {
      final box = _getBox();
      final assignmentsJson = assignments
          .map((assignment) => jsonEncode(assignment.toJson()))
          .toList();

      await box.put(_assignmentsKey, assignmentsJson);
    } catch (e) {
      // Handle error appropriately in production
      print('Error saving assignments: $e');
    }
  }

  static Future<List<AcademicSession>> getSessions() async {
    try {
      final box = _getBox();
      final sessionsJson =
          box.get(_sessionsKey, defaultValue: <String>[]) as List;

      return sessionsJson
          .map((json) => AcademicSession.fromJson(jsonDecode(json)))
          .toList();
    } catch (e) {
      return [];
    }
  }

  static Future<void> saveSessions(List<AcademicSession> sessions) async {
    try {
      final box = _getBox();
      final sessionsJson = sessions
          .map((session) => jsonEncode(session.toJson()))
          .toList();

      await box.put(_sessionsKey, sessionsJson);
    } catch (e) {
      // Handle error appropriately in production
      print('Error saving sessions: $e');
    }
  }

  static Future<void> addAssignment(Assignment assignment) async {
    final assignments = await getAssignments();
    assignments.add(assignment);
    await saveAssignments(assignments);
  }

  static Future<void> updateAssignment(Assignment assignment) async {
    final assignments = await getAssignments();
    final index = assignments.indexWhere((a) => a.id == assignment.id);
    if (index != -1) {
      assignments[index] = assignment;
      await saveAssignments(assignments);
    }
  }

  static Future<void> deleteAssignment(String assignmentId) async {
    final assignments = await getAssignments();
    assignments.removeWhere((a) => a.id == assignmentId);
    await saveAssignments(assignments);
  }

  static Future<void> addSession(AcademicSession session) async {
    final sessions = await getSessions();
    sessions.add(session);
    await saveSessions(sessions);
  }

  static Future<void> updateSession(AcademicSession session) async {
    final sessions = await getSessions();
    final index = sessions.indexWhere((s) => s.id == session.id);
    if (index != -1) {
      sessions[index] = session;
      await saveSessions(sessions);
    }
  }

  static Future<void> deleteSession(String sessionId) async {
    final sessions = await getSessions();
    sessions.removeWhere((s) => s.id == sessionId);
    await saveSessions(sessions);
  }

  static Future<void> clearAllData() async {
    try {
      final box = _getBox();
      await box.delete(_assignmentsKey);
      await box.delete(_sessionsKey);
    } catch (e) {
      print('Error clearing data: $e');
    }
  }
}
