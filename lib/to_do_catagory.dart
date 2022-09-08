import 'package:flutter/material.dart';
import 'package:to_dont_list/to_do_items.dart';

class Category {
  Category({required this.items});

  List<Item> items;

  List<Item> getItems() {
    return items;
  }
}