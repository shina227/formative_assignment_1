enum SessionType { lesson, masterySession, studyGroup, pslMeeting }

extension SessionTypeExtension on SessionType {
  String get displayName {
    switch (this) {
      case SessionType.lesson:
        return 'lesson';
      case SessionType.masterySession:
        return 'Mastery Session';
      case SessionType.studyGroup:
        return 'Study Group';
      case SessionType.pslMeeting:
        return 'PSL Meeting';
    }
  }

  static SessionType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'lesson':
        return SessionType.lesson;
      case 'mastery session':
      case 'masterysession':
        return SessionType.masterySession;
      case 'study group':
      case 'studygroup':
        return SessionType.studyGroup;
      case 'psl meeting':
      case 'pslmeeting':
        return SessionType.pslMeeting;
      default:
        return SessionType.lesson;
    }
  }

  Map<String, dynamic> toJson() {
    return {'type': name};
  }

  static SessionType fromJson(Map<String, dynamic> json) {
    return fromString(json['type'] ?? 'lesson');
  }
}

class AcademicSession {
  final String id;
  final String title;
  final DateTime date;
  final DateTime startTime;
  final DateTime endTime;
  final String? location;
  final SessionType type;
  final bool isPresent;

  AcademicSession({
    required this.id,
    required this.title,
    required this.date,
    required this.startTime,
    required this.endTime,
    this.location,
    required this.type,
    this.isPresent = false,
  });

  AcademicSession copyWith({
    String? id,
    String? title,
    DateTime? date,
    DateTime? startTime,
    DateTime? endTime,
    String? location,
    SessionType? type,
    bool? isPresent,
  }) {
    return AcademicSession(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      location: location ?? this.location,
      type: type ?? this.type,
      isPresent: isPresent ?? this.isPresent,
    );
  }

  bool get isOverdue => DateTime.now().isAfter(endTime);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(),
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'location': location,
      'type': type.name,
      'isPresent': isPresent,
    };
  }

  factory AcademicSession.fromJson(Map<String, dynamic> json) {
    return AcademicSession(
      id: json['id'],
      title: json['title'],
      date: DateTime.parse(json['date']),
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      location: json['location'],
      type: SessionTypeExtension.fromJson({'type': json['type']}),
      isPresent: json['isPresent'] ?? false,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AcademicSession && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
