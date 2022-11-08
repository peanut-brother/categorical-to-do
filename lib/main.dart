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
  // initial bool for enabled/disabled button for text form
  final ValueNotifier<bool> isEnabled = ValueNotifier(false);

  // Dialog with text from https://www.appsdeveloperblog.com/alert-dialog-with-a-text-field-in-flutter/
  late final TextEditingController _inputController1 = TextEditingController()
    ..addListener(
      () {
        listenerDeclaration();
      },
    );
  late final TextEditingController _inputController2 = TextEditingController()
    ..addListener(
      () {
        listenerDeclaration();
      },
    );
  final ButtonStyle yesStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20), backgroundColor: Colors.green);
  final ButtonStyle noStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20), backgroundColor: Colors.red);

  // starting text fields
  String catText = "";
  String valueText = "";

  // listener if statement check
  listenerDeclaration() {
    if (_inputController1.text.isNotEmpty &&
        _inputController2.text.isNotEmpty) {
      isEnabled.value = true;
    } else {
      isEnabled.value = false;
    }
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    print("Loading Dialog");
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('New Category'),
          content: Column(
            children: [
              Flexible(
                child: TextField(
                  key: const Key('CategName'),
                  onChanged: (value) {
                    setState(() {
                      catText = value;
                    });
                  },
                  controller: _inputController1,
                  decoration: const InputDecoration(hintText: "Category Name"),
                ),
              ),
              Flexible(
                child: TextField(
                  key: const Key('ItemForCateg'),
                  onChanged: (value) {
                    setState(() {
                      valueText = value;
                    });
                  },
                  controller: _inputController2,
                  decoration:
                      const InputDecoration(hintText: "First Category Item"),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              key: const Key("CancelButton"),
              style: noStyle,
              onPressed: () {
                setState(() {
                  Navigator.pop(context);
                  _inputController1.clear();
                  _inputController2.clear();
                });
              },
              child: const Text('Cancel'),
            ),
            ValueListenableBuilder<bool>(
              valueListenable: isEnabled,
              builder: (context, value, child) {
                return ElevatedButton(
                    key: const Key("OKButton"),
                    style: yesStyle,
                    onPressed: value
                        ? () {
                            _handleNewCategory(catText, valueText);
                            Navigator.pop(context);
                          }
                        : null,
                    child: const Text("OK"));
              },
            )
          ],
        );
      },
    );
  }

  final List<Category> categories = [
    Category(items: [const Item(name: "add more todos")], name: "Main Category")
  ];

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
              itemSet: const <Item>{},
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
