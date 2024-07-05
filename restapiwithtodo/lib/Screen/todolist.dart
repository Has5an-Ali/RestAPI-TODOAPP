import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Addtodo.dart';

class ToDoListpage extends StatefulWidget {
  const ToDoListpage({super.key});
  @override
  State<ToDoListpage> createState() => _ToDoListpageState();
}

class _ToDoListpageState extends State<ToDoListpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        centerTitle: true,
        elevation: 2,
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Get.to(() => const AddTodoPage());
          },
          label: const Text("Add Task")),
    );
  }
}
