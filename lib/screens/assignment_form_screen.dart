import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../services/app_provider.dart';
import '../models/assignment.dart';
import '../widgets/common_widgets.dart';
import '../utils/app_colors.dart';

class AssignmentFormScreen extends StatefulWidget {
  final Assignment? assignment;

  const AssignmentFormScreen({Key? key, this.assignment}) : super(key: key);

  @override
  State<AssignmentFormScreen> createState() => _AssignmentFormScreenState();
}

class _AssignmentFormScreenState extends State<AssignmentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _courseController = TextEditingController();
  DateTime? _dueDate;
  Priority _priority = Priority.medium;

  @override
  void initState() {
    super.initState();
    if (widget.assignment != null) {
      _titleController.text = widget.assignment!.title;
      _courseController.text = widget.assignment!.courseName;
      _dueDate = widget.assignment!.dueDate;
      _priority = widget.assignment!.priority;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _courseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.assignment == null ? 'New Assignment' : 'Edit Assignment'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Assignment Title *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter assignment title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _courseController,
                decoration: const InputDecoration(
                  labelText: 'Course Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.book),
                ),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () => _selectDueDate(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Due Date *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    _dueDate != null
                        ? DateFormat.yMd().format(_dueDate!)
                        : 'Select due date',
                    style: TextStyle(
                      color: _dueDate != null ? Colors.black : Colors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<Priority>(
                value: _priority,
                decoration: const InputDecoration(
                  labelText: 'Priority',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.priority_high),
                ),
                items: Priority.values.map((priority) {
                  return DropdownMenuItem(
                    value: priority,
                    child: Text(priority.displayName),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _priority = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => _saveAssignment(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(widget.assignment == null ? 'Create Assignment' : 'Update Assignment'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  void _saveAssignment(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      if (_dueDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a due date')),
        );
        return;
      }

      final assignment = Assignment(
        id: widget.assignment?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        dueDate: _dueDate!,
        courseName: _courseController.text.trim(),
        priority: _priority,
        isCompleted: widget.assignment?.isCompleted ?? false,
      );

      final provider = Provider.of<AppProvider>(context, listen: false);

      if (widget.assignment == null) {
        provider.addAssignment(assignment);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Assignment created successfully')),
        );
      } else {
        provider.updateAssignment(assignment);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Assignment updated successfully')),
        );
      }

      Navigator.of(context).pop();
    }
  }
}