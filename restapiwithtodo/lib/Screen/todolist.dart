// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Addtodo.dart';
import 'package:http/http.dart' as http;

class ToDoListpage extends StatefulWidget {
  const ToDoListpage({
    super.key,
  });
  @override
  State<ToDoListpage> createState() => _ToDoListpageState();
}

class _ToDoListpageState extends State<ToDoListpage> {
  List items = [];
  bool isloading = true;
  @override
  void initState() {
    fetchdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        centerTitle: true,
        elevation: 2,
      ),
      body: Visibility(
        visible: isloading,
        replacement: RefreshIndicator(
          onRefresh: fetchdata,
          child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index] as Map;
                final id = item['_id'] as String;
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.green,
                          child: Text("${index + 1}"),
                        ),
                        title: Text(item['title']),
                        subtitle: Text(item['description']),
                        trailing: PopupMenuButton(onSelected: (value) {
                          if (value == 'Edit') {
                            editpage(item);
                          } else if (value == 'Delete') {
                            deleteData(id);
                          }
                        }, itemBuilder: (context) {
                          return [
                            const PopupMenuItem(
                              value: 'Edit',
                              child: Text("Edit"),
                            ),
                            const PopupMenuItem(
                              value: 'Delete',
                              child: Text("Delete"),
                            )
                          ];
                        }),
                      ),
                    ),
                  ),
                );
              }),
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.green,
          onPressed: () {
            nextpage();
          },
          label: const Text("Add Task")),
    );
  }
// Delete Data from the List

  Future<void> deleteData(String id) async {
    // ignore: prefer_const_declarations
    final url = 'https://api.nstack.in/v1/todos/$id';

    final uri = Uri.parse(url);

    final response = await http.delete(uri);

    print(response.statusCode);
    if (response.statusCode == 200) {
      final fliterlist = items
          .where(
            (element) => element['_id'] != id,
          )
          .toList();
      setState(() {
        items = fliterlist;
      });
    }
  }

// Getting Data from the Server
  Future<void> fetchdata() async {
    // ignore: prefer_const_declarations
    final url = 'https://api.nstack.in/v1/todos?page=1&limit=10';

    final uri = Uri.parse(url);

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;

      final result = json['items'] as List;

      setState(() {
        items = result;
      });
      setState(() {
        isloading = false;
      });
    } else {}
  }

  Future<void> nextpage() async {
    await Get.to(() => const AddTodoPage());
    setState(() {
      isloading = true;
    });
    fetchdata();
  }

  Future<void> editpage(Map item) async {
    await Get.to(() => AddTodoPage(todo: item));
    setState(() {
      isloading = true;
    });
    fetchdata();
  }
}
