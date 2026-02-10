import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../services/app_provider.dart';
import '../models/academic_session.dart';
import 'session_form_screen.dart';
import '../utils/app_colors.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  late DateTime _selectedWeekStart;

  @override
  void initState() {
    super.initState();
    _selectedWeekStart = _getWeekStart(DateTime.now());
  }

  DateTime _getWeekStart(DateTime date) {
    final day = date.weekday;
    return date.subtract(Duration(days: day - 1));
  }

  List<DateTime> _getWeekDays(DateTime weekStart) {
    return List.generate(7, (index) => weekStart.add(Duration(days: index)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.calendar_month_rounded, size: 24),
            const SizedBox(width: 8),
            const Text('Schedule'),
          ],
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.today_rounded),
            tooltip: 'Go to current week',
            onPressed: () {
              setState(() {
                _selectedWeekStart = _getWeekStart(DateTime.now());
              });
            },
          ),
        ],
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          final weekDays = _getWeekDays(_selectedWeekStart);
          final weekSessions = provider.getSessionsForWeek(_selectedWeekStart);

          return Column(
            children: [
              // Week Navigation
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withOpacity(0.9),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.chevron_left_rounded,
                              color: Colors.white,
                              size: 28,
                            ),
                            onPressed: () {
                              setState(() {
                                _selectedWeekStart = _selectedWeekStart
                                    .subtract(const Duration(days: 7));
                              });
                            },
                          ),
                          Column(
                            children: [
                              Text(
                                'Week of ${DateFormat.yMMMd().format(_selectedWeekStart)}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${weekSessions.length} session${weekSessions.length != 1 ? 's' : ''}',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.chevron_right_rounded,
                              color: Colors.white,
                              size: 28,
                            ),
                            onPressed: () {
                              setState(() {
                                _selectedWeekStart = _selectedWeekStart.add(
                                  const Duration(days: 7),
                                );
                              });
                            },
                          ),
                        ],
                      ),
                    ),

                    // Week Days Header
                    Container(
                      color: Colors.white.withOpacity(0.1),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        children: weekDays.map((day) {
                          final isToday = _isSameDay(day, DateTime.now());
                          return Expanded(
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: isToday
                                    ? AppColors.secondary
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    DateFormat.E().format(day),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: isToday
                                          ? FontWeight.bold
                                          : FontWeight.w500,
                                      color: isToday
                                          ? Colors.white
                                          : Colors.white.withOpacity(0.9),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    DateFormat.d().format(day),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: isToday
                                          ? Colors.white
                                          : Colors.white.withOpacity(0.9),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),

              // Sessions List
              Expanded(
                child: weekSessions.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(32),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.event_busy_rounded,
                                size: 80,
                                color: AppColors.primary.withOpacity(0.6),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'No Sessions This Week',
                              style: TextStyle(
                                fontSize: 22,
                                color: AppColors.text,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 48,
                              ),
                              child: Text(
                                'Create a new session to start planning your week',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: AppColors.textSecondary,
                                  height: 1.4,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 32),
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const SessionFormScreen(),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.add_rounded),
                              label: const Text('Create Session'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 16,
                                ),
                                backgroundColor: AppColors.secondary,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        itemCount: weekSessions.length,
                        itemBuilder: (context, index) {
                          final session = weekSessions[index];
                          return _SessionCard(
                            session: session,
                            onTap: () => _showSessionOptions(context, session),
                            onToggleAttendance: session.isOverdue
                                ? () => provider.toggleSessionAttendance(
                                    session.id,
                                  )
                                : null,
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'schedule_fab',
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const SessionFormScreen()),
          );
        },
        backgroundColor: AppColors.secondary,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text(
          'New Session',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  void _showSessionOptions(BuildContext context, AcademicSession session) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.edit_rounded,
                    color: AppColors.primary,
                  ),
                ),
                title: const Text('Edit Session'),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SessionFormScreen(session: session),
                    ),
                  );
                },
              ),
              if (session.isOverdue)
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color:
                          (session.isPresent
                                  ? AppColors.warning
                                  : AppColors.success)
                              .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      session.isPresent
                          ? Icons.cancel_rounded
                          : Icons.check_circle_rounded,
                      color: session.isPresent
                          ? AppColors.warning
                          : AppColors.success,
                    ),
                  ),
                  title: Text(
                    session.isPresent ? 'Mark as Absent' : 'Mark as Present',
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Provider.of<AppProvider>(
                      context,
                      listen: false,
                    ).toggleSessionAttendance(session.id);
                  },
                ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.delete_rounded,
                    color: AppColors.error,
                  ),
                ),
                title: const Text('Delete Session'),
                onTap: () {
                  Navigator.of(context).pop();
                  _showDeleteConfirmation(context, session);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, AcademicSession session) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Session'),
        content: Text('Are you sure you want to delete "${session.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Provider.of<AppProvider>(
                context,
                listen: false,
              ).deleteSession(session.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Session deleted'),
                  backgroundColor: AppColors.success,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _SessionCard extends StatelessWidget {
  final AcademicSession session;
  final VoidCallback onTap;
  final VoidCallback? onToggleAttendance;

  const _SessionCard({
    Key? key,
    required this.session,
    required this.onTap,
    this.onToggleAttendance,
  }) : super(key: key);

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
    final isOverdue = session.isOverdue;
    final isMissed = isOverdue && !session.isPresent;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Attendance Checkbox
              GestureDetector(
                onTap: onToggleAttendance,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: session.isPresent
                        ? AppColors.success.withOpacity(0.1)
                        : (isMissed
                              ? AppColors.error.withOpacity(0.1)
                              : Colors.grey[100]),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: session.isPresent
                          ? AppColors.success
                          : (isMissed ? AppColors.error : Colors.grey[300]!),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    session.isPresent
                        ? Icons.check_rounded
                        : (isMissed
                              ? Icons.close_rounded
                              : Icons.circle_outlined),
                    color: session.isPresent
                        ? AppColors.success
                        : (isMissed ? AppColors.error : Colors.grey[400]),
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Session Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: _getTypeColor().withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            _getTypeIcon(),
                            size: 16,
                            color: _getTypeColor(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            session.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.text,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${DateFormat.jm().format(session.startTime)} - ${DateFormat.jm().format(session.endTime)}',
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
                    if (isMissed) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.error.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.warning_rounded,
                              size: 12,
                              color: AppColors.error,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Missed',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppColors.error,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Type Badge
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getTypeColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  session.type.displayName,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: _getTypeColor(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
