// ignore: file_names
// ignore_for_file: unused_local_variable, prefer_const_declarations

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;

class AddTodoPage extends StatefulWidget {
  final Map? todo;
  const AddTodoPage({super.key, this.todo});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descpController = TextEditingController();
  bool isEdit = false;
  @override
  void dispose() {
    titleController.dispose();
    descpController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;

      final title = todo['title'];
      final description = todo['description'];

      titleController.text = title;
      descpController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Edit Todo " : "Add Todo "),
        centerTitle: true,
        elevation: 2,
      ),
      body: ListView(
        padding: const EdgeInsets.all(25),
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              hintText: "Title",
            ),
          ),
          20.heightBox,
          TextField(
            controller: descpController,
            decoration: const InputDecoration(
              hintText: "Description ",
            ),
            minLines: 5,
            maxLines: 8,
          ),
          20.heightBox,
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Vx.blue500,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5))),
              onPressed: isEdit ? updatedata : submitdata,
              child: Text(
                isEdit ? "Update" : "Submit",
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ))
        ],
      ),
    );
  }

//Update Data
  Future<void> updatedata() async {
    final todo = widget.todo;
    final id = todo?['_id'];

    final title = titleController.text;
    final description = descpController.text;
    final body = {
      'title': title,
      'description': description,
      'is_completed': false,
    };

    final url = "https://api.nstack.in/v1/todos/$id";

    final uri = Uri.parse(url);

    final response = await http.put(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});

    //showing data

    if (response.statusCode == 200) {
      showmessage('Update  Sucessfully');
    } else {}
  }

  Future<void> submitdata() async {
    final title = titleController.text;
    final description = descpController.text;
    final body = {
      'title': title,
      'description': description,
      'is_completed': false,
    };

    //data submit on server

    final url = "https://api.nstack.in/v1/todos";

    final uri = Uri.parse(url);

    final response = await http.post(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});

    //showing data

    if (response.statusCode == 201) {
      titleController.text = '';
      descpController.text = '';
      showmessage('Added Sucessfully');
    } else {
      showerrormessage("Task Not Added!");
    }
  }

  void showmessage(String? message) {
    final snackBar = SnackBar(
      content: Text(
        message!,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showerrormessage(String? message) {
    final snackBar = SnackBar(
      content: Text(
        message!,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
