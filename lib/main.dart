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
  final TextEditingController _inputController1 = TextEditingController();
  final TextEditingController _inputController2 = TextEditingController();
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
                  Flexible(
                    child: 
                      TextField(
                      onChanged: (value) {
                        setState(() {
                          catText = value;
                        });
                      },
                      controller: _inputController1,
                      decoration:
                          const InputDecoration(hintText: "Category Name"),
                    ),
                  ),
                  Flexible(
                    child: 
                      TextField(
                      onChanged: (value) {
                        setState(() {
                          valueText = value;
                        });
                      },
                      controller: _inputController2,
                      decoration:
                          const InputDecoration(hintText: "First Item Name"),
                    ),
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
                valueListenable: _inputController1,
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

  final List<Category> categories = [Category(items: [const Item(name: "add more todos")], name: "Main Category")];

  void _handleNewCategory(String catText, itemText) {
    setState(() {
      print("Adding new category");
      Item item = Item(name: itemText);
      Category category = Category(items: [item], name: catText);
      categories.insert(0, category);
      _inputController1.clear();
      _inputController2.clear();
    });
  }

  void _handleDeleteCategory(Category category) {
    setState(() {
      print("Deleting category");
      categories.remove(category);
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
          children: categories.map((category) {
            return ToDoCategory(
              category: category,
              onDeleteCategory: _handleDeleteCategory,
              itemSet: <Item>{},
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