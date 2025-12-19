import 'package:flutter/material.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'قائمة المهام',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: const TodoHomeScreen(),
    );
  }
}

// الكلاس الخاص بمهمة واحدة
class Task {
  String title;
  bool isDone;

  Task({required this.title, this.isDone = false});
}

class TodoHomeScreen extends StatefulWidget {
  const TodoHomeScreen({super.key});

  @override
  State<TodoHomeScreen> createState() => _TodoHomeScreenState();
}

class _TodoHomeScreenState extends State<TodoHomeScreen> {
  // قائمة لتخزين المهام
  final List<Task> _tasks = [];

  // متحكم لنص الإدخال
  final TextEditingController _taskController = TextEditingController();

  // وظيفة لإضافة مهمة جديدة عبر نافذة منبثقة
  void _addNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('إضافة مهمة جديدة', textAlign: TextAlign.right),
          content: TextField(
            controller: _taskController,
            autofocus: true,
            textAlign: TextAlign.right,
            decoration: const InputDecoration(
              hintText: 'ماذا تريد أن تفعل؟',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_taskController.text.isNotEmpty) {
                  setState(() {
                    _tasks.add(Task(title: _taskController.text));
                  });
                  _taskController.clear();
                  Navigator.pop(context);
                }
              },
              child: const Text('إضافة'),
            ),
          ],
        );
      },
    );
  }

  // وظيفة لحذف المهمة
  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  // وظيفة لتغيير حالة المهمة (مكتملة أو لا)
  void _toggleTaskStatus(int index) {
    setState(() {
      _tasks[index].isDone = !_tasks[index].isDone;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مهامي اليومية'),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
        foregroundColor: Colors.white,
      ),
      body: _tasks.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment_turned_in_outlined, size: 100, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'لا توجد مهام حالياً\nابدأ بإضافة مهامك الجديدة!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
          ],
        ),
      )
          : ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          final task = _tasks[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 2,
            child: ListTile(
              leading: Checkbox(
                value: task.isDone,
                onChanged: (value) => _toggleTaskStatus(index),
                activeColor: Colors.deepPurple,
              ),
              title: Text(
                task.title,
                style: TextStyle(
                  fontSize: 18,
                  decoration: task.isDone
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                  color: task.isDone ? Colors.grey : Colors.black,
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                onPressed: () => _deleteTask(index),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewTask,
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}