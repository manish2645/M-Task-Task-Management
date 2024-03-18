import 'package:flutter/material.dart';
import 'package:m_task/database_helper.dart';
import 'package:m_task/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Task> tasks;
  bool taskLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    tasks = await DatabaseHelper().getTasks();
    _loadCheckboxState();
    taskLoaded= true;
    setState(() {});
  }

  Future<void> _loadCheckboxState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (var task in tasks) {
      task.isCompleted = prefs.getBool('task_${task.id}') ?? false;
    }
  }

  Future<void> _updateCheckboxState(Task task) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('task_${task.id}', task.isCompleted);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('M-Task'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setBool('isLoggedIn', false);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: !taskLoaded ? const Center(
        child: CircularProgressIndicator()
      ) : tasks.isEmpty
          ? const Center(
        child: Text(
          'No tasks yet!',
          style: TextStyle(fontSize: 20),
        ),
      ) : ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Card(
              elevation: 3,
              child: ListTile(
                leading: Checkbox(
                  value: tasks[index].isCompleted,
                  onChanged: (newValue) {
                    setState(() {
                      tasks[index].isCompleted = newValue ?? false;
                      _updateCheckboxState(tasks[index]); // Save state
                    });
                  },
                ),
                title: Text(
                  tasks[index].name,
                  style: TextStyle(fontSize: 18),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        _updateTask(tasks[index], index);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: (){
                        _deleteTask(tasks[index].id!);
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addTask() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController taskController = TextEditingController();

        return AlertDialog(
          title: const Text('Add Task'),
          content: TextField(
            controller: taskController,
            decoration: const InputDecoration(
              hintText: 'Enter task name',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                String taskName = taskController.text;
                if (taskName.isNotEmpty) {
                  Task newTask = Task(name: taskName);
                  await DatabaseHelper().insertTask(newTask);
                  _loadTasks();
                }
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _updateTask(Task task, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController taskController =
        TextEditingController(text: task.name);

        return AlertDialog(
          title: const Text('Update Task'),
          content: TextField(
            controller: taskController,
            decoration: const InputDecoration(
              hintText: 'Enter task name',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                String taskName = taskController.text;
                if (taskName.isNotEmpty) {
                  Task updatedTask = Task(id: task.id, name: taskName);
                  await DatabaseHelper().updateTask(updatedTask);
                  _loadTasks();
                }
                Navigator.of(context).pop();
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _deleteTask(int taskId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Task'),
          content: const Text('Are you sure you want to delete this task?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await DatabaseHelper().deleteTask(taskId);
                _loadTasks();
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
