import "package:flutter/material.dart";
import 'package:get/get.dart';
import "Screen/todolist.dart";

void main() {
  runApp(const Myapp());
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const ToDoListpage(),
    );
  }
}
