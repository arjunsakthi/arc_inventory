import 'package:arc_inventory/modals/item.dart';
import 'package:arc_inventory/resource/auth.dart';
import 'package:arc_inventory/resource/providers/data_provider.dart';
import 'package:arc_inventory/screens/blogs/blogs_screen.dart';
import 'package:arc_inventory/screens/item_storageAndEditing/item_register.dart';
import 'package:arc_inventory/screens/members_screen.dart';
import 'package:arc_inventory/screens/pdf_screen.dart';
import 'package:arc_inventory/utilities/circularprogress_indicator.dart';
import 'package:arc_inventory/widgets/blog_element.dart';
import 'package:arc_inventory/widgets/drawer.dart';

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
  List<Item>? _listBucket = [];

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
          print('enumerate');
          ref.read(studentDataProvider.notifier).connectionReport(_connection);
          if (_connection == true) {
            final data = snap.data!.docs;
            final datamod = data.map((e) => e.data()).toList();

            ref.read(studentDataProvider.notifier).recieveData(datamod);
            // print(datamod);
            // print('object');
          }
          return RouterPage();
        });
  }
}

class RouterPage extends StatefulWidget {
  const RouterPage({super.key});

  @override
  State<RouterPage> createState() => _RouterPageState();
}

class _RouterPageState extends State<RouterPage> {
  late PageController _pageController;
  int pageIndex = 2;
  String title = "Entry Screen";
  Map<String, dynamic>? userData;
  bool _whetherInitialised = false;

  void initiate() async {
    userData = await Authenticate().getUserData();
    setState(() {
      _whetherInitialised = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 2);
    initiate();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    title = "Entry Screen";
    if (pageIndex == 0)
      title = "Blog Section";
    else if (pageIndex == 2) title = "Core Members";
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(title),
        centerTitle: true,
        actions: pageIndex == 1
            ? [
                IconButton(
                  onPressed: () async {
                    // await ref.read(studentDataProvider.notifier).emptyDb();
                    print('log out');
                    Authenticate().auth.signOut();
                  },
                  icon: Icon(Icons.logout),
                  color: Theme.of(context).colorScheme.onPrimary,
                )
              ]
            : null,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        unselectedItemColor: Colors.grey,
        fixedColor: Color.fromARGB(153, 69, 12, 144),
        elevation: 10,
        currentIndex: pageIndex,
        onTap: (idx) {
          setState(() {
            print(idx);
            pageIndex = idx;
            _pageController.animateToPage(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              idx,
            );
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.book), label: "Blogs"),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "inventory"),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: "Members"),
        ],
      ),
      drawer: Container(
        child: SafeArea(
          child: Drawerstate(
            whetherInitialised: _whetherInitialised,
            userData: userData,
          ),
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (idx) {
          setState(() {
            pageIndex = idx;
          });
        },
        children: [
          BlogsScreen(),
          ItemRegister(),
          MembersScreen(),
        ],
      ),
    );
  }
}
