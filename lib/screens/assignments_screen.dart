import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_provider.dart';
import '../models/assignment.dart';
import 'assignment_form_screen.dart';
import '../widgets/common_widgets.dart';
import '../utils/app_colors.dart';

class AssignmentsScreen extends StatelessWidget {
  const AssignmentsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.assignment_rounded, size: 24),
            const SizedBox(width: 8),
            const Text('Assignments'),
          ],
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          final assignments = provider.assignmentsSortedByDueDate;

          if (assignments.isEmpty) {
            return Center(
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
                      Icons.assignment_outlined,
                      size: 80,
                      color: AppColors.primary.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'No Assignments Yet',
                    style: TextStyle(
                      fontSize: 22,
                      color: AppColors.text,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 48),
                    child: Text(
                      'Start organizing your coursework by creating your first assignment',
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
                          builder: (context) => const AssignmentFormScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('Create Assignment'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          // Group assignments
          final pending = assignments.where((a) => !a.isCompleted).toList();
          final completed = assignments.where((a) => a.isCompleted).toList();

          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 16),
            children: [
              if (pending.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.pending_actions_rounded,
                        size: 20,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Pending',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${pending.length}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.secondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                ...pending
                    .map(
                      (assignment) => AssignmentListItem(
                        assignment: assignment,
                        onTap: () =>
                            _showAssignmentOptions(context, assignment),
                        onToggle: () {
                          provider.toggleAssignmentCompletion(assignment.id);
                        },
                      ),
                    )
                    .toList(),
              ],

              if (completed.isNotEmpty) ...[
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        size: 20,
                        color: AppColors.success,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Completed',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${completed.length}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.success,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                ...completed
                    .map(
                      (assignment) => AssignmentListItem(
                        assignment: assignment,
                        onTap: () =>
                            _showAssignmentOptions(context, assignment),
                        onToggle: () {
                          provider.toggleAssignmentCompletion(assignment.id);
                        },
                      ),
                    )
                    .toList(),
              ],

              const SizedBox(height: 80),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'assignments_fab',
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AssignmentFormScreen(),
            ),
          );
        },
        backgroundColor: AppColors.secondary,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text(
          'New Assignment',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  void _showAssignmentOptions(BuildContext context, Assignment assignment) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Assignment'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        AssignmentFormScreen(assignment: assignment),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(
                assignment.isCompleted
                    ? Icons.check_box_outline_blank
                    : Icons.check_box,
              ),
              title: Text(
                assignment.isCompleted
                    ? 'Mark as Incomplete'
                    : 'Mark as Complete',
              ),
              onTap: () {
                Navigator.of(context).pop();
                Provider.of<AppProvider>(
                  context,
                  listen: false,
                ).toggleAssignmentCompletion(assignment.id);
              },
            ),
            if (assignment.isCompleted)
              ListTile(
                leading: const Icon(Icons.restore_from_trash),
                title: const Text('Delete Assignment'),
                onTap: () {
                  Navigator.of(context).pop();
                  _showDeleteConfirmation(context, assignment);
                },
              ),
            if (!assignment.isCompleted)
              ListTile(
                leading: const Icon(Icons.restore_from_trash),
                title: const Text('Delete Assignment'),
                onTap: () {
                  Navigator.of(context).pop();
                  _showDeleteConfirmation(context, assignment);
                },
              ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Assignment assignment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Assignment'),
        content: Text('Are you sure you want to delete "${assignment.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Provider.of<AppProvider>(
                context,
                listen: false,
              ).deleteAssignment(assignment.id);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Assignment deleted')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.accent),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
