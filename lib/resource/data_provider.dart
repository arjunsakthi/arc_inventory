import 'package:arc_inventory/resource/db.dart';
import 'package:arc_inventory/modals/item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as paths;

class StudentDataNotifier extends StateNotifier<List<Item>> {
  StudentDataNotifier() : super([]);
  bool _online = false;
  List<Item> _fireState = [];
  final _firestore = FirebaseFirestore.instance;
  // Item itemOfIndx(int idx) => state[idx];
  Future<void> init() async {
    final db = await createDb();
    final data = await db.query('data_storage');
    print("hello321");
    print(data);
    state = data.map((row) => Item.fromJson(row['Data'] as String)).toList()
            as List<Item> ??
        [];
    print("hello123");
    // print(data);
    print(state);
  }

  Future<void> emptyDb() async {
    final dbPath = await sql.getDatabasesPath();
    print(dbPath);
    final path = paths.join(dbPath, "DataBase.db");
    await sql.deleteDatabase(path);
    final db = await createDb();
    final data = await db.query('data_storage');
    print(data);
  }

  List<Item> itemOfCategory(TypeSel type) {
    // giving back list of Item of that category
    return state.where((item) => item.typeSelect == type).toList();
  }

  Future<String> removeItemofIndex(TypeSel type, idx) async {
    String res = "Some Error";
    // to remove a item of index idx of a category type
    Item obj = state.where((item) => item.typeSelect == type).toList()[idx];

    // print(obj.compList[0]);

    final db = await createDb();

    await db
        .delete('data_storage', where: 'ValueKey = ?', whereArgs: [obj.key]);
    final data = await db.query('data_storage').then(
        (value) => state = [...state.where((item) => item.key != obj.key)]);
    if (_online) {
      _firestore.collection("MainDocument").doc(obj.studRollNo).delete();
      res = "Deletion is Reflected to Database";
    } else {
      res = "Deletion is not Reflected to Database";
    }
    print(obj.key);
    print("Deleted successfully");
    print(data);
    return res;
  }

  bool checkIfExisits(Item item) {
    bool _check = true;
    for (int i = 0; i < 0; i++) {
      if (state[i].studRollNo == item.studRollNo) {
        _check = false;
      }
    }
    return _check;
  }

  Future<String> add(Item item) async {
    String res = "Some Error";
    if (checkIfExisits(item)) {
      print(item.toJson());
      final db = await createDb();
      await db.insert(
          'data_storage', {'ValueKey': item.key, 'Data': item.toJson()});
      final data = await db
          .query('data_storage')
          .then((value) => state = [...state, item]);
      print(data);
      if (_online) {
        await _firestore
            .collection("MainDocument")
            .doc(item.studRollNo)
            .set(item.toMap());
        res = "Added to DataBase";
      } else {
        res = "Not Added to DataBase";
      }

      return res;
    }
    return res;
  }

  Future<String> replace(Item prevItem, Item edittedItem) async {
    String res = "Some Error";
    int index = -1;
    for (int i = 0; i < state.length; i++) {
      if (state[i].studRollNo == prevItem.studRollNo &&
          state[i].studName == prevItem.studName) {
        index = i;
        print(i);
        print("got some");
        break;
      }
    }

    List<Item> list = state;
    list[index] = edittedItem;

    print(list);
    print(state);
    final db = await createDb();
    db
        .update('data_storage',
            {'ValueKey': prevItem.key, 'Data': edittedItem.toJson()},
            where: "ValueKey = ?", whereArgs: [prevItem.key])
        .then((value) => state = list);
    if (_online) {
      await _firestore
          .collection("MainDocument")
          .doc(prevItem.studRollNo)
          .update(edittedItem.toMap());
      res = "Changes are Reflected on Database";
    } else {
      res = "Changes are not Reflected on Database";
    }
    final data = await db.query('data_storage');
    print(data);
    print("success update");
    return res;
  }

  // regarding database
  void connectionReport(bool report) {
    _online = report;
  }

  // getter for connection status
  bool get connectionStatus => _online;
  // data from cloud
  void recieveData(List<Map<String, dynamic>> data) {
    _fireState = data.map((item) => Item.fromMap(item)).toList();
    compareUpdate();
    print(_fireState);
  }

  void compareUpdate() async {
    for (final Item firestoreItem in _fireState) {
      final localItemIndex =
          state.indexWhere((item) => item.key == firestoreItem.key);
      if (localItemIndex == -1) {
        state = [...state, firestoreItem];
      } else {
        final localItem = state[localItemIndex];
        if (localItem.toMap().toString() != firestoreItem.toMap().toString()) {
          final temp = state;
          temp[localItemIndex] = firestoreItem;
          state = temp;
        }
      }
    }
    for (final Item localItem in state) {
      final existingDoc =
          _fireState.any((item) => item.studRollNo == localItem.studRollNo);
      if (existingDoc == false) {
        // Item does not exist in Firebase, add it
        print(localItem.studRollNo);
        await FirebaseFirestore.instance
            .collection('MainDocument')
            .doc(localItem.studRollNo)
            .set(localItem.toMap());
      }
    }

    /*
    needed to update in a way 
    if there are changes needed to updated then need to show on alert dailog of list of need to change items then
    if update => reflect changes
    else => update database with changes

    for now what ever in firebase gets updated to local
  */
  }
}

final studentDataProvider =
    StateNotifierProvider<StudentDataNotifier, List<Item>>(
        (ref) => StudentDataNotifier());
