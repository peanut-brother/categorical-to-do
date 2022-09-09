// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:to_dont_list/main.dart';
import 'package:to_dont_list/to_do_category.dart';
import 'package:to_dont_list/to_do_items.dart';

void main() {
  test('Item abbreviation should be first letter', () {
    const item = Item(name: "add more todos");
    expect(item.abbrev(), "a");
  });

  // Yes, you really need the MaterialApp and Scaffold
  testWidgets('ToDoListItem has a text', (tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: ToDoListItem(
                item: const Item(name: "test"),
                completed: true,
                onListChanged: (Item item, bool completed) {},
                onDeleteItem: (Item item) {}))));
    final textFinder = find.text('test');

    // Use the `findsOneWidget` matcher provided by flutter_test to verify
    // that the Text widgets appear exactly once in the widget tree.
    expect(textFinder, findsOneWidget);
  });

  testWidgets('ToDoListItem has a Circle Avatar with abbreviation',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: ToDoListItem(
                item: const Item(name: "test"),
                completed: true,
                onListChanged: (Item item, bool completed) {},
                onDeleteItem: (Item item) {}))));
    final abbvFinder = find.text('t');
    final avatarFinder = find.byType(CircleAvatar);

    CircleAvatar circ = tester.firstWidget(avatarFinder);
    Text ctext = circ.child as Text;

    // Use the `findsOneWidget` matcher provided by flutter_test to verify
    // that the Text widgets appear exactly once in the widget tree.
    expect(abbvFinder, findsOneWidget);
    expect(circ.backgroundColor, Colors.black54);
    expect(ctext.data, "t");
  });

  testWidgets('Default ToDoList has one item', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ToDoList()));

    final listItemFinder = find.byType(ToDoListItem);

    expect(listItemFinder, findsOneWidget);
  });

  testWidgets('Clicking and Typing adds item and cat to ToDoList', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ToDoList()));

    expect(find.byType(TextField), findsNothing);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump(); // Pump after every action to rebuild the widgets
    expect(find.text("hi"), findsNothing);

    await tester.enterText(find.byKey(const Key('textField1')), 'hi');
    await tester.pump();
    expect(find.text("hi"), findsOneWidget);

    await tester.enterText(find.byKey(const Key('textField2')), 'hi2');
    await tester.pump();
    expect(find.text("hi2"), findsOneWidget);

    await tester.tap(find.byKey(const Key("OKButton")));
    await tester.pump();

    final listItemFinder = find.byType(ToDoListItem);
    final listCatFinder = find.byType(ToDoCategory);

    expect(listItemFinder, findsNWidgets(2));
    expect(listCatFinder, findsNWidgets(2));
  });

  // One to test the tap and press actions on the items?

  test('Category has an item', () {
    const item = Item(name: "test Item");
    var category = Category(items: [item], name: "test Category");

    expect(category.getItems()[0], isA<Item>());
  });

  testWidgets('Button creates new items in category.', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ToDoList()));

    expect(find.byType(TextField), findsNothing);

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump(); // Pump after every action to rebuild the widgets
    expect(find.text("hi"), findsNothing);

    await tester.enterText(find.byType(TextField), 'hi');
    await tester.pump();
    expect(find.text("hi"), findsOneWidget);

    await tester.tap(find.byKey(const Key("OKButton")));
    await tester.pump();
    expect(find.text("hi"), findsOneWidget);

    final listItemFinder = find.byType(ToDoListItem);

    expect(listItemFinder, findsNWidgets(2));
  });
  
  testWidgets('Long press removes checked item.', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ToDoList()));


    await tester.tap(find.byType(ElevatedButton));
    await tester.pump(); // Pump after every action to rebuild the widgets
    await tester.enterText(find.byType(TextField), 'test');
    await tester.pump();
    await tester.tap(find.byKey(const Key("OKButton")));
    await tester.pump();

    final listItemFinder = find.byType(ToDoListItem);

    expect(listItemFinder, findsNWidgets(2));

    await tester.longPress(find.text('test'));
    await tester.pump();
    
    expect(listItemFinder, findsNWidgets(2));

    await tester.longPress(find.text('test'));
    await tester.pump();

    expect(listItemFinder, findsOneWidget);
  });

  testWidgets('Category has title and percentage', (tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: ToDoCategory(
              category: Category(
                items:[],
                name: "testCat"
              ),
              onDeleteCategory: (category) {},
              itemSet: <Item>{},
            ))));
    final titleFinder = find.text('testCat');
    final percentFinder = find.text('0%');


    expect(titleFinder, findsOneWidget);
    expect(percentFinder, findsOneWidget);
  });

  testWidgets('Long press on button removes category.', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ToDoList()));

    await tester.tap(find.text('add more todos'));
    await tester.pump();
    await tester.longPress(find.byType(ElevatedButton));
    await tester.pump(); // Pump after every action to rebuild the widgets

    final categoryFinder = find.byType(ToDoCategory);

    expect(categoryFinder, findsNothing);
  });
}