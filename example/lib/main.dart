import 'package:flutter/material.dart';
import 'package:mikey_state/mikey_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MyStateProvider(
      stateManager: MyStateManager({
        'tasks': [
          {
            'title': 'Buy groceries',
            'description': 'Milk, Bread, Eggs',
            'completed': false
          },
          {
            'title': 'Workout',
            'description': '1-hour gym session',
            'completed': false
          },
        ],
      }),
      child: const MaterialApp(
        home: TaskListScreen(),
      ),
    );
  }
}

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  Future<List<Map<String, dynamic>>> _fetchTasksFromAPI() async {
    // Simulate a network delay
    await Future.delayed(const Duration(seconds: 2));

    // Simulated API response
    return [
      {
        'title': 'Meeting with team',
        'description': 'Discuss project roadmap',
        'completed': false
      },
      {
        'title': 'Doctor appointment',
        'description': 'Annual check-up',
        'completed': false
      },
      {
        'title': 'Call mom',
        'description': 'Catch up with family',
        'completed': false
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final stateManager = MyStateProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
        actions: [
          IconButton(
            onPressed: () {
              // Reset the task list to its initial state
              stateManager.reset('tasks');
            },
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset Task List',
          ),
        ],
      ),
      body: ValueListenableBuilder<List<Map<String, dynamic>>>(
        valueListenable:
            stateManager.listen<List<Map<String, dynamic>>>('tasks'),
        builder: (context, tasks, child) {
          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return ListTile(
                title: Text(task['title']),
                subtitle: Text(task['description']),
                trailing: Checkbox(
                  value: task['completed'],
                  onChanged: (bool? value) {
                    // Update the task's completed status
                    final updatedTask = {...task, 'completed': value};
                    final updatedTasks = List<Map<String, dynamic>>.from(tasks);
                    updatedTasks[index] = updatedTask;
                    stateManager.set('tasks', updatedTasks);
                  },
                ),
                onTap: () {
                  // Open the edit dialog when the task is tapped
                  showDialog(
                    context: context,
                    builder: (context) => EditTaskDialog(
                      task: task,
                      onSave: (String newTitle, String newDescription) {
                        final updatedTask = {
                          ...task,
                          'title': newTitle,
                          'description': newDescription,
                        };
                        final updatedTasks =
                            List<Map<String, dynamic>>.from(tasks);
                        updatedTasks[index] = updatedTask;
                        stateManager.set('tasks', updatedTasks);
                      },
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add a new task
          final newTask = {
            'title': 'New Task',
            'description': 'Details...',
            'completed': false
          };
          final tasks = List<Map<String, dynamic>>.from(
              stateManager.get<List<Map<String, dynamic>>>('tasks'));
          tasks.add(newTask);
          stateManager.set('tasks', tasks);
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () async {
            // Simulate fetching tasks from an API
            await stateManager.setAsync('tasks', _fetchTasksFromAPI());
          },
          child: const Text('Get Tasks from API'),
        ),
      ),
    );
  }
}

class EditTaskDialog extends StatefulWidget {
  final Map<String, dynamic> task;
  final Function(String, String) onSave;

  const EditTaskDialog({
    super.key,
    required this.task,
    required this.onSave,
  });

  @override
  State<EditTaskDialog> createState() => _EditTaskDialogState();
}

class _EditTaskDialogState extends State<EditTaskDialog> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.task['title']);
    descriptionController =
        TextEditingController(text: widget.task['description']);
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Task'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(labelText: 'Task Title'),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(labelText: 'Task Description'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onSave(
              titleController.text,
              descriptionController.text,
            );
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
