import 'package:flutter/material.dart';

class AddPage extends StatelessWidget {
  var nameEditingController = TextEditingController();
  var descEditingController = TextEditingController();
  var placeEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add name"), backgroundColor: Colors.purple,),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(decoration: const InputDecoration(hintText: "Enter item name"),
            controller: nameEditingController,),
            TextField(decoration: const InputDecoration(hintText: "Enter item description"),
            controller: descEditingController,),
            TextField(decoration: const InputDecoration(hintText: "Enter Item place"),
            controller: placeEditingController,),
            ElevatedButton(
                onPressed: (){

                print(nameEditingController.text);
                print(descEditingController.text);
                print(placeEditingController.text);

                var newItem = {
                  "name": nameEditingController.text,
                  "desc": descEditingController.text,
                  "place": placeEditingController.text,
                  "completed" : false,
                };

                Navigator.pop(context, newItem);
                },
                child: const Text("Add New Item"))
          ],
        ),
      )
    );
  }
}

