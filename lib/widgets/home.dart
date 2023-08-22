import 'dart:convert';
import 'package:flutter/material.dart';
import 'add.dart';
import 'detail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var todos = <Map<String, dynamic>>[];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var savedItem = prefs.getString("todos");
    if (savedItem != null) {
      setState(() {
        todos = List<Map<String, dynamic>>.from(
          jsonDecode(savedItem).map((item) => Map<String, dynamic>.from(item)),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("To do app"),
        backgroundColor: Colors.greenAccent,
        actions: [
          IconButton(
            onPressed: () async {
              var newItem = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddPage()),
              );
              if (newItem != null) {
                setState(() {
                  todos.add(newItem);
                });

                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                prefs.setString("todos", jsonEncode(todos));
              }
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: todos[index]["completed"] == true
                  ? Icon(Icons.check)
                  : Icon(Icons.circle),
              title: Text(todos[index]["name"] as String),
              subtitle: Text(todos[index]["place"] as String),
              trailing: Icon(Icons.chevron_right),
              onTap: () async {
                var data = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailPage(todoItem: todos[index]),
                  ),
                );
                if (data != null) {
                  if (data["action"] == 1) {
                    setState(() {
                      todos.remove(data["object"]);
                    });

                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setString("todos", jsonEncode(todos));
                  } else {
                    var retrievedObject = data["object"];
                    for (var i = 0; i < todos.length; i++) {
                      if (todos[i]["name"] == retrievedObject["name"] &&
                          todos[i]["desc"] == retrievedObject["desc"] &&
                          todos[i]["place"] == retrievedObject["place"]) {
                        setState(() {
                          todos[i]["completed"] = !todos[i]["completed"];
                        });
                        break;
                      }
                    }

                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setString("todos", jsonEncode(todos));
                  }
                }
              },
            ),
          );
        },
      ),
    );
  }
}
