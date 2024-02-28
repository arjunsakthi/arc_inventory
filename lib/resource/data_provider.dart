import 'package:arc_inventory/resource/db.dart';
import 'package:arc_inventory/modals/item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as paths;

class StudentDataNotifier extends StateNotifier<List<Item>> {
  StudentDataNotifier() : super([]);

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

  Future<void> removeItemofIndex(TypeSel type, idx) async {
    // to remove a item of index idx of a category type
    Item obj = state.where((item) => item.typeSelect == type).toList()[idx];

    // print(obj.compList[0]);

    final db = await createDb();

    await db.delete('data_storage', where: 'ValueKey = ?', whereArgs: [obj.key]);
    final data = await db.query('data_storage').then(
        (value) => state = [...state.where((item) => item.key != obj.key)]);
    print(obj.key);
    print("Deleted successfully");
    print(data);
  }

  bool checkIfExisits(Item item) {
    bool _check = true;
    for (int i = 0; i < 0; i++) {
      if (state[i].key == item.key) {
        _check = false;
      }
    }
    return _check;
  }

  Future<bool> add(Item item) async {
    if (checkIfExisits(item)) {
      print(item.toJson());
      final db = await createDb();
      await db.insert('data_storage', {'ValueKey': item.key, 'Data': item.toJson()});
      final data = await db
          .query('data_storage')
          .then((value) => state = [...state, item]);
      print(data);
      return true;
    }
    return false;
  }

  Future<void> replace(Item prevItem, Item edittedItem) async {
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

    final data = await db.query('data_storage');
    print(data);
    print("success update");
  }
}

final studentDataProvider =
    StateNotifierProvider<StudentDataNotifier, List<Item>>(
        (ref) => StudentDataNotifier());
