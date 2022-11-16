import 'package:flutter/material.dart';
import 'package:to_dont_list/to_do_items.dart';

class Category {
  Category({required this.items, required this.name});

  List<Item> items;

  final String name;

  List<Item> getItems() {
    return items;
  }
}

typedef ToDoCategoryChangedCallback = Function(
    Category category, bool complete);
typedef ToDoCategoryRemovedCallback = Function(Category category);
typedef ToDoNewItemCallback = Function(Category category);

class ToDoCategory extends StatefulWidget {
  ToDoCategory(
      {required this.category,
      required this.onDeleteCategory,
      required this.itemSet,
      super.key});

  final Category category;
  final ToDoCategoryRemovedCallback onDeleteCategory;
  Set<Item> itemSet;

  @override
  State<ToDoCategory> createState() => _ToDoCategoryState();
}

class _ToDoCategoryState extends State<ToDoCategory> {
  final TextEditingController _inputController = TextEditingController();

  int _percentComplete = 0;

  void _adjustPercentage() {
    int numTrue = 0;
    _percentComplete =
        (widget.itemSet.length * 100) ~/ (widget.category.items.length);
  }

  void _handleDeleteItem(Item item) {
    setState(() {
      print("Deleting item");
      widget.category.items.remove(item);
      widget.itemSet.remove(item);
      _adjustPercentage();
    });
  }

  void _handleNewItem(String itemText, Category category) {
    setState(() {
      print("Adding new item");
      Item item = Item(name: itemText);
      category.items.add(item);
      _inputController.clear();
      _adjustPercentage();
    });
  }

  void _handleListChanged(Item item, bool completed) {
    setState(() {
      // When a user changes what's in the list, you need
      // to change _itemSet inside a setState call to
      // trigger a rebuild.
      // The framework then calls build, below,
      // which updates the visual appearance of the app.

      widget.category.items.remove(item);
      if (!completed) {
        print("Completing");
        widget.itemSet.add(item);
        widget.category.items.add(item);
      } else {
        print("Making Undone");
        widget.itemSet.remove(item);
        widget.category.items.insert(0, item);
      }
      _adjustPercentage();
    });
  }

  final ButtonStyle yesStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20), backgroundColor: Colors.green);
  final ButtonStyle noStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20), backgroundColor: Colors.red);

  Future<void> _displayTextInputDialog(BuildContext context) async {
    print("Loading Dialog");
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Item To Add'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  valueText = value;
                });
              },
              controller: _inputController,
              decoration: const InputDecoration(hintText: "New Item"),
            ),
            actions: <Widget>[
              ElevatedButton(
                key: const Key("CancelButton"),
                style: noStyle,
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
                child: const Text('Cancel'),
              ),
              // https://stackoverflow.com/questions/52468987/how-to-turn-disabled-button-into-enabled-button-depending-on-conditions
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: _inputController,
                builder: (context, value, child) {
                  return ElevatedButton(
                    key: const Key("OKButton"),
                    style: yesStyle,
                    onPressed: value.text.isNotEmpty
                        ? () {
                            setState(() {
                              _handleNewItem(valueText, widget.category);
                              Navigator.pop(context);
                            });
                          }
                        : null,
                    child: const Text('OK'),
                  );
                },
              ),
            ],
          );
        });
  }

  String valueText = "";

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Column(
        children: [
          Row(
            children: [
              const SizedBox(width: 20),
              Flexible(
                fit: FlexFit.tight,
                child: Text(
                  widget.category.name,
                  style: null,
                ),
              ),
              const Spacer(),
              Expanded(
                child: Text(
                  "$_percentComplete%",
                  style: null,
                ),
              ),
              const SizedBox(width: 20),
              Flexible(
                fit: FlexFit.tight,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _displayTextInputDialog(context);
                    });
                  },
                  onLongPress: widget.itemSet.containsAll(widget.category.items)
                      ? () {
                          setState(() {
                            widget.onDeleteCategory(widget.category);
                          });
                        }
                      : null,
                  child: const Icon(Icons.add),
                ),
              ),
              const SizedBox(width: 20)
            ],
          ),
          Flexible(
            child: ListView(
              children: widget.category.items.map((item) {
                return ToDoListItem(
                  item: item,
                  completed: widget.itemSet.contains(item),
                  onListChanged: _handleListChanged,
                  onDeleteItem: _handleDeleteItem,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
