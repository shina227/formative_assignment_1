import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/assignment.dart';
import '../models/academic_session.dart';
import '../utils/app_colors.dart';

class DashboardCard extends StatelessWidget {
  final String title;
  final Widget child;
  final Color? backgroundColor;

  const DashboardCard({
    Key? key,
    required this.title,
    required this.child,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(8),
      color: backgroundColor ?? AppColors.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class AttendanceIndicator extends StatelessWidget {
  final double percentage;
  final bool showWarning;

  const AttendanceIndicator({
    Key? key,
    required this.percentage,
    required this.showWarning,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: LinearProgressIndicator(
            value: percentage / 100,
            backgroundColor: AppColors.background,
            color: showWarning ? AppColors.accent : AppColors.success,
            minHeight: 8,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          '${percentage.toStringAsFixed(1)}%',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: showWarning ? AppColors.accent : AppColors.text,
          ),
        ),
        if (showWarning) ...[
          const SizedBox(width: 8),
          const Icon(Icons.warning, color: AppColors.accent, size: 20),
        ],
      ],
    );
  }
}

class AssignmentListItem extends StatelessWidget {
  final Assignment assignment;
  final VoidCallback onTap;
  final VoidCallback onToggle;

  const AssignmentListItem({
    Key? key,
    required this.assignment,
    required this.onTap,
    required this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final priorityColor = _getPriorityColor(assignment.priority);
    final isOverdue =
        assignment.dueDate.isBefore(DateTime.now()) && !assignment.isCompleted;
    final daysUntilDue = assignment.dueDate.difference(DateTime.now()).inDays;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: assignment.isCompleted ? 0 : 2,
      color: assignment.isCompleted ? AppColors.background : AppColors.surface,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Checkbox
              GestureDetector(
                onTap: onToggle,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: assignment.isCompleted
                        ? AppColors.success.withOpacity(0.1)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: assignment.isCompleted
                          ? AppColors.success
                          : (isOverdue ? AppColors.error : Colors.grey[300]!),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    assignment.isCompleted
                        ? Icons.check_rounded
                        : Icons.circle_outlined,
                    color: assignment.isCompleted
                        ? AppColors.success
                        : (isOverdue ? AppColors.error : Colors.grey[400]),
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      assignment.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: assignment.isCompleted
                            ? AppColors.textSecondary
                            : AppColors.text,
                        decoration: assignment.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.book_rounded,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            assignment.courseName,
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 14,
                          color: isOverdue && !assignment.isCompleted
                              ? AppColors.error
                              : AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat.yMd().format(assignment.dueDate),
                          style: TextStyle(
                            fontSize: 13,
                            color: isOverdue && !assignment.isCompleted
                                ? AppColors.error
                                : AppColors.textSecondary,
                            fontWeight: isOverdue && !assignment.isCompleted
                                ? FontWeight.bold
                                : null,
                          ),
                        ),
                        if (!assignment.isCompleted) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: isOverdue
                                  ? AppColors.error.withOpacity(0.1)
                                  : (daysUntilDue <= 3
                                        ? AppColors.warning.withOpacity(0.1)
                                        : AppColors.info.withOpacity(0.1)),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              isOverdue
                                  ? 'Overdue'
                                  : (daysUntilDue == 0
                                        ? 'Due today'
                                        : (daysUntilDue == 1
                                              ? 'Due tomorrow'
                                              : '$daysUntilDue days left')),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: isOverdue
                                    ? AppColors.error
                                    : (daysUntilDue <= 3
                                          ? AppColors.warning
                                          : AppColors.info),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              // Priority Badge
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: priorityColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  assignment.priority.displayName.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: priorityColor,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getPriorityColor(Priority priority) {
    switch (priority) {
      case Priority.high:
        return AppColors.priorityHigh;
      case Priority.medium:
        return AppColors.priorityMedium;
      case Priority.low:
        return AppColors.priorityLow;
    }
  }
}

class SessionListItem extends StatelessWidget {
  final AcademicSession session;
  final VoidCallback onTap;

  const SessionListItem({Key? key, required this.session, required this.onTap})
    : super(key: key);

  IconData _getTypeIcon() {
    switch (session.type) {
      case SessionType.lesson:
        return Icons.school_rounded;
      case SessionType.masterySession:
        return Icons.psychology_rounded;
      case SessionType.studyGroup:
        return Icons.groups_rounded;
      case SessionType.pslMeeting:
        return Icons.meeting_room_rounded;
    }
  }

  Color _getTypeColor() {
    switch (session.type) {
      case SessionType.lesson:
        return AppColors.primary;
      case SessionType.masterySession:
        return AppColors.secondary;
      case SessionType.studyGroup:
        return AppColors.info;
      case SessionType.pslMeeting:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final startTime = DateFormat.jm().format(session.startTime);
    final endTime = DateFormat.jm().format(session.endTime);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Type Icon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getTypeColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(_getTypeIcon(), color: _getTypeColor(), size: 24),
              ),
              const SizedBox(width: 16),

              // Session Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      session.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$startTime - $endTime',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    if (session.location != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            size: 14,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              session.location!,
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              // Attendance Status
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: session.isPresent
                      ? AppColors.success.withOpacity(0.1)
                      : Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  session.isPresent
                      ? Icons.check_circle_rounded
                      : Icons.circle_outlined,
                  color: session.isPresent
                      ? AppColors.success
                      : Colors.grey[400],
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StatsCard extends StatelessWidget {
  final String title;
  final String value;
  final Color? valueColor;
  final IconData? icon;

  const StatsCard({
    Key? key,
    required this.title,
    required this.value,
    this.valueColor,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) Icon(icon, color: AppColors.primary, size: 24),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 12, color: AppColors.text),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: valueColor ?? AppColors.primary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
