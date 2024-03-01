import 'package:arc_inventory/main.dart';
import 'package:arc_inventory/modals/item.dart';
import 'package:arc_inventory/resource/auth.dart';
import 'package:arc_inventory/resource/data_provider.dart';
import 'package:arc_inventory/screens/auth_screen.dart';
import 'package:arc_inventory/screens/loading_screen.dart';
import 'package:arc_inventory/widgets/drawer.dart';
import 'package:arc_inventory/widgets/edit_widget.dart';
import 'package:arc_inventory/widgets/grid_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({
    super.key,
  });

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen>
    with SingleTickerProviderStateMixin {
  Map<String, dynamic>? userData;
  List<Item>? _listBucket = [];
  late AnimationController _anim;
  bool _whetherInitialised = false;

  @override
  void initState() {
    super.initState();
    _anim =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    initiate();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _anim.dispose();
  }

  void initiate() async {
    userData = await Authenticate().getUserData();
    setState(() {
      _whetherInitialised = true;
    });
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

  @override
  Widget build(BuildContext context) {
    bool _connection = false;
    return StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection("MainDocument").snapshots(),
        builder: (ctx, snap) {
          if (snap.connectionState == ConnectionState.active) {
            _connection = true;
          }
          if (snap.connectionState == ConnectionState.waiting) {
            _connection = false;
          }
          ref.read(studentDataProvider.notifier).connectionReport(_connection);
          if (_connection == true) {
            final data = snap.data!.docs;
            final datamod = data.map((e) => e.data()).toList();
            ref.read(studentDataProvider.notifier).recieveData(datamod);
            // print(datamod);
            // print('object');
          }
          return Scaffold(
            drawer: Container(
              child: SafeArea(
                child: Drawerstate(
                  userData: userData,
                  whetherInitialised: _whetherInitialised,
                ),
              ),
            ),
            appBar: AppBar(title: Text("Main Screen"), actions: [
              IconButton(
                onPressed: () async {
                  // await ref.read(studentDataProvider.notifier).emptyDb();
                  Authenticate().auth.signOut();
                },
                icon: Icon(Icons.logout),
                color: Theme.of(context).colorScheme.onPrimary,
              )
            ]),
            body: Container(
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
            floatingActionButton: CircleAvatar(
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
          );
        });
  }
}
