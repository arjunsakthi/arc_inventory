import 'package:arc_inventory/modals/item.dart';
import 'package:arc_inventory/resource/auth.dart';
import 'package:arc_inventory/resource/providers/data_provider.dart';
import 'package:arc_inventory/screens/main_screens/main_screen.dart';
import 'package:arc_inventory/widgets/drawer.dart';
import 'package:arc_inventory/widgets/edit_widget.dart';
import 'package:arc_inventory/widgets/grid_widget.dart';
import 'package:bottom_bar_matu/bottom_bar/bottom_bar_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ItemRegister extends ConsumerStatefulWidget {
  ItemRegister({
    super.key,
  });

  @override
  ConsumerState<ItemRegister> createState() => _ItemRegisterState();
}

class _ItemRegisterState extends ConsumerState<ItemRegister>
    with SingleTickerProviderStateMixin {
  late AnimationController _anim;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _anim.dispose();
  }

  void _editing() {
    showModalBottomSheet(
      isDismissible: false,
      enableDrag: false,
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      transitionAnimationController: _anim,
      constraints: BoxConstraints(
        maxWidth: double.infinity,
        maxHeight: MediaQuery.of(context).size.height,
      ),
      builder: (context) {
        return SlideTransition(
          position: Tween<Offset>(begin: Offset(0, 1), end: Offset(0, 0))
              .animate(_anim),
          child: Container(
              margin: EdgeInsets.only(left: 8, right: 8),
              padding: EdgeInsets.symmetric(horizontal: 2),
              height: MediaQuery.of(context).size.height * 3 / 4,
              width: double.infinity,
              // type is random
              child: EditWidget(
                choosen: "New",
                type: TypeSel.firstYear,
              )),
        );
      },
    );
  }

  Future<void> _refresh() async {
    final snap =
        await FirebaseFirestore.instance.collection("MainDocument").get();
    final data = snap.docs.map((e) => e.data()).toList();
    ref.read(studentDataProvider.notifier).recieveData(data);
    await Future.delayed(Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(studentDataProvider);
    return RefreshIndicator(
      onRefresh: _refresh,
      child: Stack(children: [
        Positioned.fill(
          child: Container(
            margin: EdgeInsets.only(top: 8, left: 8, right: 8),
            color: Theme.of(context).colorScheme.primaryContainer,
            child: GridView(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1 / 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
              children: [
                GridWidget(
                  title: "1st year",
                  type: TypeSel.firstYear,
                ),
                GridWidget(
                  title: "2nd year",
                  type: TypeSel.secondYear,
                ),
                GridWidget(
                  title: "3rd year",
                  type: TypeSel.thirdYear,
                ),
                GridWidget(
                  title: "others",
                  type: TypeSel.other,
                ),
              ],
            ),
          ),
        ),
        Positioned(
          right: 8,
          bottom: 8,
          child: CircleAvatar(
            radius: 35,
            backgroundColor: Color.fromARGB(214, 69, 12, 144),
            child: Center(
              child: IconButton(
                iconSize: 50,
                color: Colors.white,
                icon: Icon(Icons.add),
                onPressed: _editing,
              ),
            ),
          ),
        )
      ]),
    );
  }
}
