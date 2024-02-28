import 'package:arc_inventory/modals/item.dart';
import 'package:arc_inventory/resource/data_provider.dart';
import 'package:arc_inventory/widgets/edit_widget.dart';
import 'package:arc_inventory/widgets/list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditScreen extends ConsumerStatefulWidget {
  EditScreen({required this.title, this.type = TypeSel.firstYear, super.key});
  final String title;
  final type;
  @override
  ConsumerState<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends ConsumerState<EditScreen>
    with TickerProviderStateMixin {
  late AnimationController _anim;
  late AnimationController _anim1;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    _anim =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _anim1 =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _anim.dispose();
    _anim1.dispose();
  }

  void _editing(int idx) {
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
            child: EditWidget(
              idx: idx,
              choosen: "Edit",
              type: widget.type,
            ),
          ),
        );
      },
    );
  }

  void _see(int idx) {
    final data =
        ref.read(studentDataProvider.notifier).itemOfCategory(widget.type)[idx];
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              data.studName.toString(),
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
                  ...data.compList
                      .map(
                        (item) => Row(children: [
                          Text(item.compName),
                          Text(
                            item.quant.toString(),
                          )
                        ]),
                      )
                      .toList(),
                ],
              ),
            ),
          );
        });
  }

  void _remove(int idx) async {
    bool _conformation = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Conform Delete",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text("Conform")),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text("Quit")),
        ],
      ),
    );
    if (_conformation) {
      _listKey.currentState!.removeItem(
        idx,
        (context, animation) => SlideTransition(
          position:
              Tween<Offset>(begin: Offset(1, 0), end: const Offset(0, 0.0))
                  .animate(animation),
          child: ListWidget(
            idx: idx,
            edit: _editing,
            see: _see,
            type: widget.type,
            delete: _remove,
          ),
        ),
      );
      // given delay such that after it removes the item
      // the list widget will get the update
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        ref
            .read(studentDataProvider.notifier)
            .removeItemofIndex(widget.type, idx);
      });

      // error was there before building the widget (which is going to remove) the item is removed
      // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    // ref.watch(studentDataProvider);
    print("testing times it appears");
    List<Item> data =
        ref.read(studentDataProvider.notifier).itemOfCategory(widget.type);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        color: Theme.of(context).colorScheme.primaryContainer,
        padding: EdgeInsets.only(left: 8, right: 8, top: 10),
        child: AnimatedList(
          key: _listKey,
          shrinkWrap: true,
          initialItemCount: data.length,
          itemBuilder: (context, index, animation) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: Offset(-1, 0.0),
                end: Offset(0, 0.0),
              ).animate(animation),
              child: ListWidget(
                idx: index,
                edit: _editing,
                see: _see,
                type: widget.type,
                delete: _remove,
              ),
            );
          },
        ),

        // ListWidget(
        //     idx: idx, edit: _editing, see: _see, type: widget.type);
      ),
    );
  }
}
