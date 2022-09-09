import 'package:flutter/material.dart';
import 'package:to_dont_list/to_do_items.dart';

class Category {
  Category({required this.items,
  required this.name});

  List<Item> items;

  final String name;

  List<Item> getItems() {
    return items;
  }

}

typedef ToDoCategoryChangedCallback = Function(Category category, bool complete);
typedef ToDoCategoryRemovedCallback = Function(Category category);
typedef ToDoNewItemCallback = Function(Category category);

class ToDoCategory extends StatefulWidget {
  ToDoCategory(
    {required this.category,
    required this.onDeleteCategory,
    super.key}
  );

  final Category category;
  final ToDoCategoryRemovedCallback onDeleteCategory;

  @override
  State<ToDoCategory> createState() => _ToDoCategoryState();
}

class _ToDoCategoryState extends State<ToDoCategory> {
  final TextEditingController _inputController = TextEditingController();

  int _percentComplete = 0;

  void _adjustPercentage() {
    setState(() {
      int numTrue = 0;
      _percentComplete = 100 * (_itemSet.length ~/ widget.category.items.length);
    });
  }

  void _handleDeleteItem(Item item) {
    setState(() {
      print("Deleting item");
      widget.category.items.remove(item);
    });
  }

  void _handleNewItem(String itemText, Category category) {
    setState(() {
      print("Adding new item");
      Item item = Item(name: itemText);
      category.items.add(item);
      _inputController.clear();
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
        _itemSet.add(item);
        widget.category.items.add(item);
      } else {
        print("Making Undone");
        _itemSet.remove(item);
        widget.category.items.insert(0, item);
      }
    });
  }

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
                        const InputDecoration(hintText: "type something here"),
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
                    _handleNewItem(valueText, widget.category);
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

  String valueText = "";

  final _itemSet = <Item>{};

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Expanded( 
        child: Column(
          children: [
              Row(
                children: [ 
                  const SizedBox(
                    width: 20
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    child: GestureDetector(
                      onLongPress: _itemSet.isEmpty 
                        ? () {
                          setState(() {
                            widget.onDeleteCategory(widget.category);
                          });
                        }
                        : null,
                      child: Expanded(
                        child: Text(
                          widget.category.name,
                          style: null,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20
                  ),
                  const Spacer(),
                  Flexible(
                    fit: FlexFit.tight,
                    child: ElevatedButton(
                      onPressed: () { setState(() {_displayTextInputDialog(context);});},
                      child: const Icon(Icons.add),
                    ),
                  ),
                  const SizedBox(
                    width: 20
                  )
                ],
              ),
            Flexible(
              child: ListView(
                children: widget.category.items.map((item) {
                  return ToDoListItem(
                    item: item,
                    completed: _itemSet.contains(item),
                    onListChanged: _handleListChanged,
                    onDeleteItem: _handleDeleteItem,
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}