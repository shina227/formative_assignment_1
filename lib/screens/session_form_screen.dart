import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../services/app_provider.dart';
import '../models/academic_session.dart';
import '../utils/app_colors.dart';

class SessionFormScreen extends StatefulWidget {
  final AcademicSession? session;

  const SessionFormScreen({Key? key, this.session}) : super(key: key);

  @override
  State<SessionFormScreen> createState() => _SessionFormScreenState();
}

class _SessionFormScreenState extends State<SessionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  DateTime? _date;
  DateTime? _startTime;
  DateTime? _endTime;
  SessionType _sessionType = SessionType.lesson;

  @override
  void initState() {
    super.initState();
    if (widget.session != null) {
      _titleController.text = widget.session!.title;
      _locationController.text = widget.session!.location ?? '';
      _date = widget.session!.date;
      _startTime = widget.session!.startTime;
      _endTime = widget.session!.endTime;
      _sessionType = widget.session!.type;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.session == null ? 'New Session' : 'Edit Session'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Session Title *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter session title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Date *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    _date != null
                        ? DateFormat.yMd().format(_date!)
                        : 'Select date',
                    style: TextStyle(
                      color: _date != null ? Colors.black : Colors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectTime(context, true),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Start Time *',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.access_time),
                        ),
                        child: Text(
                          _startTime != null
                              ? DateFormat.jm().format(_startTime!)
                              : 'Select start time',
                          style: TextStyle(
                            color: _startTime != null ? Colors.black : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectTime(context, false),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'End Time *',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.access_time),
                        ),
                        child: Text(
                          _endTime != null
                              ? DateFormat.jm().format(_endTime!)
                              : 'Select end time',
                          style: TextStyle(
                            color: _endTime != null ? Colors.black : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Location (Optional)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<SessionType>(
                value: _sessionType,
                decoration: const InputDecoration(
                  labelText: 'Session Type',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                items: SessionType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type.displayName),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _sessionType = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => _saveSession(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(widget.session == null ? 'Create Session' : 'Update Session'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _date ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _date = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(
        isStartTime ? (_startTime ?? DateTime.now()) : (_endTime ?? DateTime.now()),
      ),
    );
    if (picked != null) {
      final dateTime = DateTime(
        _date?.year ?? DateTime.now().year,
        _date?.month ?? DateTime.now().month,
        _date?.day ?? DateTime.now().day,
        picked.hour,
        picked.minute,
      );
      
      setState(() {
        if (isStartTime) {
          _startTime = dateTime;
        } else {
          _endTime = dateTime;
        }
      });
    }
  }

  void _saveSession(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      if (_date == null || _startTime == null || _endTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill in all required fields')),
        );
        return;
      }

      if (_endTime!.isBefore(_startTime!)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('End time must be after start time')),
        );
        return;
      }

      final session = AcademicSession(
        id: widget.session?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        date: _date!,
        startTime: _startTime!,
        endTime: _endTime!,
        location: _locationController.text.trim().isEmpty 
            ? null 
            : _locationController.text.trim(),
        type: _sessionType,
        isPresent: widget.session?.isPresent ?? false,
      );

      final provider = Provider.of<AppProvider>(context, listen: false);

      if (widget.session == null) {
        provider.addSession(session);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Session created successfully')),
        );
      } else {
        provider.updateSession(session);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Session updated successfully')),
        );
      }

      Navigator.of(context).pop();
    }
  }
}