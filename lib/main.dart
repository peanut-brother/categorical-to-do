// Started with https://docs.flutter.dev/development/ui/widgets-intro
import 'package:flutter/material.dart';
import 'package:to_dont_list/to_do_category.dart';
import 'package:to_dont_list/to_do_items.dart';

class ToDoList extends StatefulWidget {
  const ToDoList({super.key});

  @override
  State createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  // Dialog with text from https://www.appsdeveloperblog.com/alert-dialog-with-a-text-field-in-flutter/
  final TextEditingController _inputController = TextEditingController();
  final ButtonStyle yesStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20), primary: Colors.green);
  final ButtonStyle noStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20), primary: Colors.red);

  Future<void> _displayTextInputDialog(BuildContext context) async {
    print("Loading Dialog");
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Item To Add'),
            content:
              Column(
                children: [ 
                  Row(
                    children: [
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            catText = value;
                          });
                        },
                        controller: _inputController,
                        decoration:
                            const InputDecoration(hintText: "Category Name"),
                      ),
                      
                    ],
                  ),
                  Row(
                    children: [
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            valueText = value;
                          });
                        },
                        controller: _inputController,
                        decoration:
                            const InputDecoration(hintText: "First Item Name"),
                      ),
                      
                    ],
                  ),
                ],
              ),
            actions: <Widget>[
              ElevatedButton(
                key: const Key("OKButton"),
                style: yesStyle,
                child: const Text('OK'),
                onPressed: () {
                  setState(() {
                    _handleNewCategory(catText, valueText);
                    Navigator.pop(context);
                  });
                },
              ),

              // https://stackoverflow.com/questions/52468987/how-to-turn-disabled-button-into-enabled-button-depending-on-conditions
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: _inputController,
                builder: (context, value, child) {
                  return ElevatedButton(
                    key: const Key("CancelButton"),
                    style: noStyle,
                    onPressed: value.text.isNotEmpty
                        ? () {
                            setState(() {
                              Navigator.pop(context);
                            });
                          }
                        : null,
                    child: const Text('Cancel'),
                  );
                },
              ),
            ],
          );
        });
  }

  String catText = "";

  String valueText = "";

  final List<Category> categorys = [Category(items: [const Item(name: "add more todos")], name: "Main Category")];

  void _removeItem(Item i) {
    for (var cat in categorys) {
      if (cat.getItems().contains(i)) {
        cat.items.remove(i);
      }
      if (cat.getItems().isEmpty) {
        categorys.remove(cat);
      }
    }
  }

  void _handleNewCategory(String catText, itemText) {
    setState(() {
      print("Adding new category");
      Item item = Item(name: itemText);
      Category category = Category(items: [item], name: catText);
      categorys.insert(0, category);
      _inputController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('To Do List'),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          children: categorys.map((category) {
            return ToDoCategory(
              category: category,
              onDeleteCategory: (category) {},
            );
          }).toList(),
        ),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              _displayTextInputDialog(context);
            }));
  }
}

void main() {
  runApp(const MaterialApp(
    title: 'To Do List',
    home: ToDoList(),
  ));
}

// restructure so that button to add item is associated with each individual category. add button to add categories. Percentage of completed tasks in category. Rework unit tests.