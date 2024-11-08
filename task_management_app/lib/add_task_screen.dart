import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final List<TextEditingController> _subtaskControllers = [];
  DateTime _selectedDate = DateTime.now();
  bool _isRepeated = false;

  void _addSubtaskField() {
    setState(() {
      _subtaskControllers.add(TextEditingController());
    });
  }

  void _submitTask() {
    if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
      return;
    }
    // Collect subtasks from controllers
    final subtasks = _subtaskControllers.map((controller) => controller.text).toList();
    final task = TaskModel(
      title: _titleController.text,
      description: _descriptionController.text,
      dueDate: _selectedDate,
      isRepeated: _isRepeated,
      subtasks: subtasks,
      subtaskCompletion: List.filled(subtasks.length, false),
    );

    // Add task to provider
    Provider.of<TaskProvider>(context, listen: false).addTask(task);
    Navigator.of(context).pop();
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Task Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            ListTile(
              title: Text('Due Date: ${_selectedDate.toLocal()}'.split(' ')[0]),
              trailing: Icon(Icons.calendar_today),
              onTap: _pickDate,
            ),
            CheckboxListTile(
              title: Text('Repeat Task'),
              value: _isRepeated,
              onChanged: (value) {
                setState(() {
                  _isRepeated = value!;
                });
              },
            ),
            SizedBox(height: 10),
            Text('Subtasks:', style: TextStyle(fontSize: 16)),
            Column(
              children: _subtaskControllers.map((controller) => TextField(
                controller: controller,
                decoration: InputDecoration(labelText: 'Subtask'),
              )).toList(),
            ),
            TextButton(
              onPressed: _addSubtaskField,
              child: Text('Add Subtask'),
            ),
            ElevatedButton(
              onPressed: _submitTask,
              child: Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }
}
