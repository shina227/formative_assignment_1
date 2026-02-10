import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../services/app_provider.dart';
import '../widgets/common_widgets.dart';
import '../utils/app_colors.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          );
        }

        final now = DateTime.now();
        final todayText = DateFormat.yMMMMd('en_US').format(now);
        final dayOfWeek = DateFormat.EEEE().format(now);
        final attendancePercentage = provider.attendancePercentage;
        final hasLowAttendance = provider.hasLowAttendance;
        final todaySessions = provider.todaySessions;
        final upcomingAssignments = provider.upcomingAssignments;
        final pendingCount = provider.pendingAssignmentsCount;

        return RefreshIndicator(
          onRefresh: () => provider.initializeData(),
          color: AppColors.primary,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // Modern App Bar
              SliverAppBar(
                expandedHeight: 180,
                floating: false,
                pinned: true,
                backgroundColor: AppColors.primary,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.primary,
                          AppColors.primary.withOpacity(0.8),
                        ],
                      ),
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.dashboard_rounded,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Expanded(
                                  child: Text(
                                    'Dashboard',
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today_rounded,
                                  color: Colors.white.withOpacity(0.9),
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  dayOfWeek,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white.withOpacity(0.9),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '• $todayText',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Academic Week ${provider.currentAcademicWeek}',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Quick Stats Cards
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: _QuickStatCard(
                                icon: Icons.assignment_outlined,
                                title: 'Pending',
                                value: pendingCount.toString(),
                                subtitle: 'Assignments',
                                color: pendingCount > 0
                                    ? AppColors.secondary
                                    : AppColors.success,
                                iconColor: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _QuickStatCard(
                                icon: Icons.event_note_rounded,
                                title: 'Today',
                                value: todaySessions.length.toString(),
                                subtitle: 'Sessions',
                                color: AppColors.info,
                                iconColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Attendance Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _SectionHeader(
                          icon: Icons.fact_check_rounded,
                          title: 'Attendance',
                        ),
                      ),
                      const SizedBox(height: 12),
                      Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (hasLowAttendance)
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  margin: const EdgeInsets.only(bottom: 16),
                                  decoration: BoxDecoration(
                                    color: AppColors.error.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: AppColors.error.withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.warning_rounded,
                                        color: AppColors.error,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          'Your attendance is below 75%. Please improve!',
                                          style: TextStyle(
                                            color: AppColors.error,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color:
                                          (hasLowAttendance
                                                  ? AppColors.error
                                                  : AppColors.success)
                                              .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      hasLowAttendance
                                          ? Icons.trending_down_rounded
                                          : Icons.trending_up_rounded,
                                      color: hasLowAttendance
                                          ? AppColors.error
                                          : AppColors.success,
                                      size: 32,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${attendancePercentage.toStringAsFixed(1)}%',
                                          style: TextStyle(
                                            fontSize: 32,
                                            fontWeight: FontWeight.bold,
                                            color: hasLowAttendance
                                                ? AppColors.error
                                                : AppColors.success,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Overall Attendance',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: LinearProgressIndicator(
                                  value: attendancePercentage / 100,
                                  backgroundColor: AppColors.background,
                                  color: hasLowAttendance
                                      ? AppColors.error
                                      : AppColors.success,
                                  minHeight: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Today's Sessions
                      if (todaySessions.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: _SectionHeader(
                            icon: Icons.today_rounded,
                            title: 'Today\'s Sessions',
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...todaySessions
                            .map(
                              (session) => SessionListItem(
                                session: session,
                                onTap: () {},
                              ),
                            )
                            .toList(),
                      ],

                      // Upcoming Assignments
                      if (upcomingAssignments.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: _SectionHeader(
                            icon: Icons.assignment_late_rounded,
                            title: 'Assignments Due Soon',
                            subtitle: 'Next 7 days',
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...upcomingAssignments
                            .take(5)
                            .map(
                              (assignment) => AssignmentListItem(
                                assignment: assignment,
                                onTap: () {},
                                onToggle: () {
                                  provider.toggleAssignmentCompletion(
                                    assignment.id,
                                  );
                                },
                              ),
                            )
                            .toList(),
                      ],

                      // Empty State
                      if (todaySessions.isEmpty &&
                          upcomingAssignments.isEmpty) ...[
                        const SizedBox(height: 40),
                        Center(
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.wb_sunny_rounded,
                                  size: 64,
                                  color: AppColors.primary.withOpacity(0.6),
                                ),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'All Clear!',
                                style: TextStyle(
                                  fontSize: 24,
                                  color: AppColors.text,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'No sessions or assignments due soon',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'Use the tabs below to add new items',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;

  const _SectionHeader({
    Key? key,
    required this.icon,
    required this.title,
    this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 22),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.text,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(width: 8),
          Text(
            '• $subtitle',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
        ],
      ],
    );
  }
}

class _QuickStatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;
  final Color color;
  final Color iconColor;

  const _QuickStatCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
    required this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color, color.withOpacity(0.8)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}
