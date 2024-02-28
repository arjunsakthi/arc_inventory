import 'package:arc_inventory/modals/item.dart';
import 'package:arc_inventory/resource/data_provider.dart';
import 'package:arc_inventory/screens/edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GridWidget extends ConsumerWidget {
  GridWidget({super.key, required this.title, required this.type});
  final String title;
  final TypeSel type;

  void _editList(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => EditScreen(
          title: title,
          type: type,
        ),
      ),
    );
  }

  void _expandedView(BuildContext context, WidgetRef ref) {
    final data = ref.watch(studentDataProvider.notifier).itemOfCategory(type);
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              '2nd Year',
              style: TextStyle(fontSize: 20),
            ),
            content: Container(
              // height: MediaQuery.of(context).size.height / 4,
              width: 100,
              padding: EdgeInsets.all(10),
              // child: Text("hello"),
              child: ListView(
                shrinkWrap: true,
                children: [
                  ...data.map((item) => Text(item.studName)).toList(),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(studentDataProvider);
    final data = ref.watch(studentDataProvider.notifier).itemOfCategory(type);
    return Container(
      padding: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(0.2), // Adjust shadow color as needed
            spreadRadius: 2, // Adjust spread radius as needed
            blurRadius: 7, // Adjust blur radius as needed
            offset: Offset(0, 3), // Adjust offset as needed
          ),
        ],
      ),
      alignment: Alignment.center,
      child: InkWell(
        borderRadius: BorderRadius.circular(25),
        onTap: () {
          _editList(context);
        },
        onLongPress: () {
          _expandedView(context, ref);
        },
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(title),
              Divider(
                thickness: 1,
              ),
              Expanded(
                  child: Padding(
                padding: EdgeInsets.only(left: 8, right: 8),
                child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (BuildContext, idx) {
                    return Text(data[idx].studName);
                  },
                ),
              )),
            ]),
      ),
    );
  }
}
