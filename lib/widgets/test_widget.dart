// import 'package:flutter/material.dart';

import 'package:uuid/uuid.dart';

/// Flutter code sample for [AnimatedList].

// void main() {
//   runApp(const AnimatedListSample());
// }

// class AnimatedListSample extends StatefulWidget {
//   const AnimatedListSample({super.key});

//   @override
//   State<AnimatedListSample> createState() => _AnimatedListSampleState();
// }

// class _AnimatedListSampleState extends State<AnimatedListSample> {
//   final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
//   late ListModel<int> _list;
//   int? _selectedItem;
//   late int
//       _nextItem; // The next item inserted when the user presses the '+' button.

//   @override
//   void initState() {
//     super.initState();
//     _list = ListModel<int>(
//       listKey: _listKey,
//       initialItems: <int>[0, 1, 2],
//       removedItemBuilder: _buildRemovedItem,
//     );
//     _nextItem = 3;
//   }

//   // Used to build list items that haven't been removed.
//   Widget _buildItem(
//       BuildContext context, int index, Animation<double> animation) {
//     return CardItem(
//       animation: animation,
//       item: _list[index],
//       selected: _selectedItem == _list[index],
//       onTap: () {
//         setState(() {
//           _selectedItem = _selectedItem == _list[index] ? null : _list[index];
//         });
//       },
//     );
//   }

//   /// The builder function used to build items that have been removed.
//   ///
//   /// Used to build an item after it has been removed from the list. This method
//   /// is needed because a removed item remains visible until its animation has
//   /// completed (even though it's gone as far as this ListModel is concerned).
//   /// The widget will be used by the [AnimatedListState.removeItem] method's
//   /// [AnimatedRemovedItemBuilder] parameter.
//   Widget _buildRemovedItem(
//       int item, BuildContext context, Animation<double> animation) {
//     return CardItem(
//       animation: animation,
//       item: item,
//       // No gesture detector here: we don't want removed items to be interactive.
//     );
//   }

//   // Insert the "next item" into the list model.
//   void _insert() {
//     final int index =
//         _selectedItem == null ? _list.length : _list.indexOf(_selectedItem!);
//     _list.insert(index, _nextItem++);
//   }

//   // Remove the selected item from the list model.
//   void _remove() {
//     if (_selectedItem != null) {
//       _list.removeAt(_list.indexOf(_selectedItem!));
//       setState(() {
//         _selectedItem = null;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('AnimatedList'),
//           actions: <Widget>[
//             IconButton(
//               icon: const Icon(Icons.add_circle),
//               onPressed: _insert,
//               tooltip: 'insert a new item',
//             ),
//             IconButton(
//               icon: const Icon(Icons.remove_circle),
//               onPressed: _remove,
//               tooltip: 'remove the selected item',
//             ),
//           ],
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: AnimatedList(
//             key: _listKey,
//             initialItemCount: _list.length,
//             itemBuilder: _buildItem,
//           ),
//         ),
//       ),
//     );
//   }
// }

// typedef RemovedItemBuilder<T> = Widget Function(
//     T item, BuildContext context, Animation<double> animation);

// /// Keeps a Dart [List] in sync with an [AnimatedList].
// ///
// /// The [insert] and [removeAt] methods apply to both the internal list and
// /// the animated list that belongs to [listKey].
// ///
// /// This class only exposes as much of the Dart List API as is needed by the
// /// sample app. More list methods are easily added, however methods that
// /// mutate the list must make the same changes to the animated list in terms
// /// of [AnimatedListState.insertItem] and [AnimatedList.removeItem].
// class ListModel<E> {
//   ListModel({
//     required this.listKey,
//     required this.removedItemBuilder,
//     Iterable<E>? initialItems,
//   }) : _items = List<E>.from(initialItems ?? <E>[]);

//   final GlobalKey<AnimatedListState> listKey;
//   final RemovedItemBuilder<E> removedItemBuilder;
//   final List<E> _items;

//   AnimatedListState? get _animatedList => listKey.currentState;

//   void insert(int index, E item) {
//     _items.insert(index, item);
//     _animatedList!.insertItem(index);
//   }

//   E removeAt(int index) {
//     final E removedItem = _items.removeAt(index);
//     if (removedItem != null) {
//       _animatedList!.removeItem(
//         index,
//         (BuildContext context, Animation<double> animation) {
//           return removedItemBuilder(removedItem, context, animation);
//         },
//       );
//     }
//     return removedItem;
//   }

//   int get length => _items.length;

//   E operator [](int index) => _items[index];

//   int indexOf(E item) => _items.indexOf(item);
// }

// /// Displays its integer item as 'item N' on a Card whose color is based on
// /// the item's value.
// ///
// /// The text is displayed in bright green if [selected] is
// /// true. This widget's height is based on the [animation] parameter, it
// /// varies from 0 to 128 as the animation varies from 0.0 to 1.0.
// class CardItem extends StatelessWidget {
//   const CardItem({
//     super.key,
//     this.onTap,
//     this.selected = false,
//     required this.animation,
//     required this.item,
//   }) : assert(item >= 0);

//   final Animation<double> animation;
//   final VoidCallback? onTap;
//   final int item;
//   final bool selected;

//   @override
//   Widget build(BuildContext context) {
//     TextStyle textStyle = Theme.of(context).textTheme.headlineMedium!;
//     if (selected) {
//       textStyle = textStyle.copyWith(color: Colors.lightGreenAccent[400]);
//     }
//     return Padding(
//       padding: const EdgeInsets.all(2.0),
//       child: SizeTransition(
//         sizeFactor: animation,
//         child: GestureDetector(
//           behavior: HitTestBehavior.opaque,
//           onTap: onTap,
//           child: SizedBox(
//             height: 80.0,
//             child: Card(
//               color: Colors.primaries[item % Colors.primaries.length],
//               child: Center(
//                 child: Text('Item $item', style: textStyle),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: NotesApp(),
//     );
//   }
// }

// class NotesApp extends StatefulWidget {
//   @override
//   _NotesAppState createState() => _NotesAppState();
// }

// class _NotesAppState extends State<NotesApp> {
//   final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
//   List<List<TextEditingController>> rowControllers = [
//     [TextEditingController(), TextEditingController()]
//   ];

//   void addRow() {
//     final index = rowControllers.length;
//     rowControllers.add([TextEditingController(), TextEditingController()]);
//     _listKey.currentState?.insertItem(index);
//   }

//   void removeRow(int index) {
//     _listKey.currentState?.removeItem(
//       index,
//       (context, animation) => SlideTransition(
//         position: Tween<Offset>(
//           begin: Offset(1, 0),
//           end: const Offset(0.0, 0.0),
//         ).animate(animation),
//         child: buildRow(rowControllers[index], index),
//       ),
//     );
//     rowControllers.removeAt(index);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Notes App'),
//       ),
//       body: AnimatedList(
//         key: _listKey,
//         initialItemCount: rowControllers.length,
//         itemBuilder: (context, index, animation) {
//           return SlideTransition(
//             position: Tween<Offset>(
//               begin: const Offset(-1.0, 0.0),
//               end: Offset.zero,
//             ).animate(animation),
//             child: buildRow(rowControllers[index], index),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: addRow,
//         child: Icon(Icons.add),
//       ),
//     );
//   }

//   Widget buildRow(List<TextEditingController> controllers, int index) {
//     return Row(
//       children: [
//         Expanded(
//           child: TextField(
//             controller: controllers[0],
//             decoration: InputDecoration(hintText: 'Detail ${index + 1}'),
//           ),
//         ),
//         Expanded(
//           child: TextField(
//             controller: controllers[1],
//             decoration: InputDecoration(hintText: 'Detail ${index + 1}'),
//           ),
//         ),
//         IconButton(
//           icon: Icon(Icons.remove_circle_outline),
//           onPressed: () => removeRow(index),
//           color: Colors.red,
//         ),
//       ],
//     );
//   }
// }

void main() {
  var uuid = Uuid();
  String uniqueKey = uuid.v4();
  String uniq = uuid.v4();
  print(uniqueKey + " \n" + uniq);
}
