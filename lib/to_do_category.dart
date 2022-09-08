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
  
  void add(Item item) {
    items.add(item);
  }

  void remove(Item item) {
    items.remove(item);
  }
}

typedef ToDoCategoryChangedCallback = Function(Category category, bool complete);
typedef ToDoCategoryRemovedCallback = Function(Category category);
typedef ToDoNewItemCallback = Function(Category category);

class ToDoCategory extends StatefulWidget {
  ToDoCategory(
    {required this.category,
    required this.completed,
    required this.onListChanged,
    required this.onDeleteCategory,
    required this.onNewItem,
    super.key}
  );

  final Category category;
  final List<bool> completed;
  final ToDoCategoryChangedCallback onListChanged;
  final ToDoCategoryRemovedCallback onDeleteCategory;
  final ToDoNewItemCallback onNewItem;

  @override
  State<ToDoCategory> createState() => _ToDoCategoryState();
}

class _ToDoCategoryState extends State<ToDoCategory> {
  final TextEditingController _inputController = TextEditingController();

  int _percentComplete = 0;

  void _adjustPercentage() {
    setState(() {
      int numTrue = 0;
      widget.completed.map((complete) => {if (complete) {numTrue++}});
      _percentComplete = 100 * (numTrue ~/ widget.completed.length);
    });
  }

  void _handleDeleteItem(Item item) {
    setState(() {
      print("Deleting item");
      _removeItem(item);
    });
  }

  void _handleNewItem(String itemText, Category category) {
    setState(() {
      print("Adding new item");
      Item item = Item(name: itemText);
      category.add(item);
      _inputController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            ListTile(
              onLongPress: widget.completed.every((element) => true)
                  ? () {
                      widget.onDeleteCategory(widget.category);
                    }
                  : null,
              title: Text(
                widget.category.name,
                style: null,
              ),
            ),
            ElevatedButton(
              onPressed: widget.onNewItem(widget.category),
              child: const Icon(Icons.add),
            ),
          ],
        ),
        ListView(
          children: widget.category.items.map((item) {
            return ToDoListItem(
              item: item,
              completed: _itemSet.contains(item),
              onListChanged: _handleListChanged,
              onDeleteItem: _handleDeleteItem,
            );
          }).toList(),
        ),
      ],
    );
  }
}