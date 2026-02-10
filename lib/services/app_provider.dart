import 'package:flutter/material.dart';
import '../models/assignment.dart';
import '../models/academic_session.dart';
import 'storage_service.dart';

class AppProvider with ChangeNotifier {
  List<Assignment> _assignments = [];
  List<AcademicSession> _sessions = [];
  bool _isLoading = false;

  List<Assignment> get assignments => _assignments;
  List<AcademicSession> get sessions => _sessions;
  bool get isLoading => _isLoading;

  // Get assignments due within next 7 days
  List<Assignment> get upcomingAssignments {
    final now = DateTime.now();
    final weekFromNow = now.add(const Duration(days: 7));
    return _assignments
        .where((assignment) => 
            !assignment.isCompleted &&
            assignment.dueDate.isAfter(now) &&
            assignment.dueDate.isBefore(weekFromNow))
        .toList();
  }

  // Get pending assignments count
  int get pendingAssignmentsCount {
    return _assignments.where((assignment) => !assignment.isCompleted).length;
  }

  // Get today's sessions
  List<AcademicSession> get todaySessions {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    
    return _sessions.where((session) => 
        session.date.isAfter(today.subtract(const Duration(seconds: 1))) &&
        session.date.isBefore(tomorrow)).toList();
  }

  // Calculate attendance percentage
  double get attendancePercentage {
    if (_sessions.isEmpty) return 100.0;
    
    final totalSessions = _sessions.where((session) => session.isOverdue).length;
    if (totalSessions == 0) return 100.0;
    
    final attendedSessions = _sessions
        .where((session) => session.isOverdue && session.isPresent)
        .length;
    
    return (attendedSessions / totalSessions) * 100;
  }

  // Check if attendance is below 75%
  bool get hasLowAttendance => attendancePercentage < 75;

  // Get current academic week number
  int get currentAcademicWeek {
    final now = DateTime.now();
    final academicYearStart = DateTime(now.year, 9, 1); // Assuming academic year starts Sept 1
    final daysSinceStart = now.difference(academicYearStart).inDays;
    return (daysSinceStart / 7).floor() + 1;
  }

  // Initialize data from storage
  Future<void> initializeData() async {
    _isLoading = true;
    notifyListeners();

    try {
      _assignments = await StorageService.getAssignments();
      _sessions = await StorageService.getSessions();
    } catch (e) {
      // Handle error
      print('Error initializing data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Assignment methods
  Future<void> addAssignment(Assignment assignment) async {
    _assignments.add(assignment);
    await StorageService.addAssignment(assignment);
    notifyListeners();
  }

  Future<void> updateAssignment(Assignment assignment) async {
    final index = _assignments.indexWhere((a) => a.id == assignment.id);
    if (index != -1) {
      _assignments[index] = assignment;
      await StorageService.updateAssignment(assignment);
      notifyListeners();
    }
  }

  Future<void> deleteAssignment(String assignmentId) async {
    _assignments.removeWhere((a) => a.id == assignmentId);
    await StorageService.deleteAssignment(assignmentId);
    notifyListeners();
  }

  Future<void> toggleAssignmentCompletion(String assignmentId) async {
    final assignment = _assignments.firstWhere((a) => a.id == assignmentId);
    final updatedAssignment = assignment.copyWith(isCompleted: !assignment.isCompleted);
    await updateAssignment(updatedAssignment);
  }

  // Session methods
  Future<void> addSession(AcademicSession session) async {
    _sessions.add(session);
    await StorageService.addSession(session);
    notifyListeners();
  }

  Future<void> updateSession(AcademicSession session) async {
    final index = _sessions.indexWhere((s) => s.id == session.id);
    if (index != -1) {
      _sessions[index] = session;
      await StorageService.updateSession(session);
      notifyListeners();
    }
  }

  Future<void> deleteSession(String sessionId) async {
    _sessions.removeWhere((s) => s.id == sessionId);
    await StorageService.deleteSession(sessionId);
    notifyListeners();
  }

  Future<void> toggleSessionAttendance(String sessionId) async {
    final session = _sessions.firstWhere((s) => s.id == sessionId);
    final updatedSession = session.copyWith(isPresent: !session.isPresent);
    await updateSession(updatedSession);
  }

  // Get sessions for a specific week
  List<AcademicSession> getSessionsForWeek(DateTime weekStart) {
    final weekEnd = weekStart.add(const Duration(days: 7));
    return _sessions.where((session) => 
        session.date.isAfter(weekStart.subtract(const Duration(seconds: 1))) &&
        session.date.isBefore(weekEnd)).toList();
  }

  // Sort assignments by due date
  List<Assignment> get assignmentsSortedByDueDate {
    final sortedAssignments = List<Assignment>.from(_assignments);
    sortedAssignments.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    return sortedAssignments;
  }
}