import 'dart:ffi';

import 'package:arc_inventory/resource/providers/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../modals/item.dart';

class ListWidget extends ConsumerWidget {
  ListWidget({
    super.key,
    required this.idx,
    required this.edit,
    required this.see,
    required this.type,
    required this.delete,
  });
  final idx;
  final type;
  final void Function(int idx) edit;
  final void Function(int idx) see;
  final void Function(int idx) delete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // print(idx);
    // print('object123');
    List<Item> data1 =
        ref.watch(studentDataProvider.notifier).itemOfCategory(type);
    print(data1[idx].studName);
    final data = data1[idx];

    return Container(
      height: 75,
      width: double.infinity,
      child: Card(
        elevation: 2,
        color: Theme.of(context).colorScheme.inversePrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        child: Row(
          children: [
            SizedBox(
              width: 12,
            ),
            Text(
              (idx + 1).toString(),
              style: TextStyle(fontSize: 18),
            ),
            VerticalDivider(
              thickness: 3,
              color: Theme.of(context).colorScheme.primary,
              width: 30,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  data.studName,
                  overflow: TextOverflow.clip,
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  data.studRollNo,
                  overflow: TextOverflow.clip,
                  style: TextStyle(fontSize: 14),
                ),
              ],
            )),
            VerticalDivider(
              thickness: 3,
              color: Theme.of(context).colorScheme.primary,
              width: 5,
            ),
            IconButton(
                onPressed: () {
                  see(idx);
                },
                icon: Icon(Icons.remove_red_eye)),
            VerticalDivider(
              thickness: 3,
              color: Theme.of(context).colorScheme.primary,
              width: 5,
            ),
            IconButton(
                onPressed: () {
                  edit(idx);
                },
                icon: Icon(Icons.edit)),
            VerticalDivider(
              thickness: 3,
              color: Theme.of(context).colorScheme.primary,
              width: 5,
            ),
            IconButton(
                onPressed: () {
                  delete(idx);
                },
                icon: Icon(
                  Icons.dangerous_outlined,
                  color: Theme.of(context).colorScheme.error,
                )),
            SizedBox(width: 5)
          ],
        ),
      ),
    );
  }
}
