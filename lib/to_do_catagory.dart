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