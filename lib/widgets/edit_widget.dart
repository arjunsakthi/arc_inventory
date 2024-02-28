import 'package:arc_inventory/modals/item.dart';
import 'package:arc_inventory/resource/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditWidget extends ConsumerStatefulWidget {
  EditWidget(
      {super.key, this.idx = 0, required this.choosen, required this.type});
  final TypeSel type;
  final idx;
  final String choosen;
  @override
  ConsumerState<EditWidget> createState() => _EditWidgetState();
}

class _EditWidgetState extends ConsumerState<EditWidget> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final GlobalKey<FormState> _verifyKey = GlobalKey<FormState>();
  TypeSel _batch = TypeSel.firstYear;

  String _dep = "KUCP";

  String _studName = "";
  String _rollNo = "";
  Item? data;
  List<List<TextEditingController>> _controllers = [
    [TextEditingController(), TextEditingController()],
  ];
  ScrollController _scroll = ScrollController();
  Future<bool> _conformation() async {
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
    return _conformation;
  }

  @override
  void initState() {
    if (widget.choosen == "Edit") {
      data = ref
          .read(studentDataProvider.notifier)
          .itemOfCategory(widget.type)[widget.idx];
      _studName = data!.studName;
      _rollNo = data!.studRollNo.substring(8);
      _batch = data!.typeSelect;

      _dep = data!.studRollNo.substring(4, 8) == "KUCP" ? "KUCP" : "KUEC";
      _controllers = data!.compList
          .map((item) => [
                TextEditingController(text: item.compName),
                TextEditingController(text: item.quant.toString())
              ])
          .toList();
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Item _update() {
    List<Component> comList = [];
    for (int i = 0; i < _controllers.length; i++) {
      comList.add(Component(
        compName: _controllers[i][0].text,
        quant: int.parse(_controllers[i][1].text),
      ));
    }
    DateTime now = DateTime.now();
    int year = now.year;
    int month = now.month;
    if (_batch == TypeSel.firstYear) {
      year = month > 6 ? year : year - 1;
    } else if (_batch == TypeSel.secondYear) {
      year = month > 6 ? year - 1 : year - 2;
    } else if (_batch == TypeSel.thirdYear) {
      year = month > 6 ? year - 2 : year - 3;
    } else {
      year = 2000;
    }
    Item item;
    String rollNo = year.toString() + _dep + _rollNo.toString();
    if (widget.choosen == "New") {
      item = Item(
        compList: comList,
        studName: _studName,
        typeSelect: _batch,
        studRollNo: rollNo,
      );
    } else {
      item = Item(
        compList: comList,
        studName: _studName,
        typeSelect: _batch,
        studRollNo: rollNo,
        key: data!.key,
      );
    }

    return item;
  }

  void _validate() async {
    if (widget.choosen == "New") {
      print("NEW");
      bool sak = _verifyKey.currentState!.validate();
      if (sak) {
        _verifyKey.currentState!.save();
        //for debugging
        // print(_batch);
        // print(_dep);
        // print(_studName);
        // print(_rollNo);
        // for (int i = 0; i < _controllers.length; i++) {
        //   print(_controllers[i][0].text);
        //   print(_controllers[i][1].text);

        Item item = _update();
        final _bool = await ref.read(studentDataProvider.notifier).add(item);
        if (_bool) {
          Navigator.of(context).pop();
        } else {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Entry already Exisits")));
        }
      }
    } else {
      print("EDIT");
      bool status = false;
      if (_controllers.length != data!.compList.length) {
        status = true;
      } else {
        for (int i = 0; i < _controllers.length; i++) {
          if (_controllers[i][0].text != data!.compList[i].compName ||
              _controllers[i][1].text != data!.compList[i].quant.toString()) {
            status = true;
          }
        }
      }
      _verifyKey.currentState!.save();

      if (status ||
          _studName != data!.studName ||
          _batch != data!.typeSelect ||
          data!.studRollNo.substring(4, 8) != _dep) {
        print("hello puneet");
        _verifyKey.currentState!.save();
        bool response = await _conformation();

        if (response) {
          Item item = _update();
          final ok =
              await ref.read(studentDataProvider.notifier).replace(data!, item);
          // ref.refresh(studentDataProvider); -- very very bad argument -- never to be used
        }
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("No changes Made")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // final data =
    return SingleChildScrollView(
      child: Form(
        key: _verifyKey,
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Data',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                TextButton(
                  onPressed: () {
                    _validate();
                    // _verifyKey.currentState!.validate();
                  },
                  child: Text(
                    "Validate",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Flexible(
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Student Name",
                    hintStyle: Theme.of(context).textTheme.bodyLarge,
                  ),
                  keyboardType: TextInputType.name,
                  initialValue: _studName,
                  enableSuggestions: true,
                  validator: (value) {
                    if (value == null || value.trim().length < 3) {
                      return "Enter valid Name";
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    _studName = newValue!;
                  },
                ),
              ),
              SizedBox(width: 10),
              DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(
                      width: 2, color: Theme.of(context).colorScheme.primary),
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                child: DropdownButton(
                  dropdownColor: Color.fromARGB(255, 159, 72, 206),
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  underline: Container(
                    color: Theme.of(context).colorScheme.primary,
                    height: 5,
                  ),
                  padding:
                      EdgeInsets.only(left: 10, right: 10, top: 7, bottom: 7),
                  value: _batch,
                  items: TypeSel.values
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Container(
                            child:
                                Text(e.toString().split('.')[1].toUpperCase()),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) => setState(() {
                    _batch = value as TypeSel;
                    print(_batch);
                  }),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            SizedBox(width: 5),
            DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(
                    width: 2,
                    color: Theme.of(context).colorScheme.onPrimaryContainer),
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              child: DropdownButton(
                dropdownColor: Color.fromARGB(255, 159, 72, 206),
                borderRadius: BorderRadius.all(Radius.circular(25)),
                underline: Container(
                  color: Theme.of(context).colorScheme.primary,
                  height: 5,
                ),
                padding:
                    EdgeInsets.only(left: 10, right: 10, top: 7, bottom: 7),
                items: [
                  DropdownMenuItem(
                    value: "KUCP",
                    child: Container(
                      child: Text("CSE"),
                    ),
                  ),
                  DropdownMenuItem(
                    value: "KUEC",
                    child: Container(
                      child: Text("ECE"),
                    ),
                  ),
                ],
                onChanged: (value) => setState(() {
                  _dep = value as String;
                }),
                value: _dep,
              ),
            ),
            SizedBox(width: 10),
            Flexible(
              child: TextFormField(
                initialValue: _rollNo,
                decoration: InputDecoration(
                  hintText: "Roll No",
                  hintStyle: Theme.of(context).textTheme.bodyLarge,
                ),
                keyboardType: TextInputType.number,
                enableSuggestions: true,
                validator: (value) {
                  if (value == null ||
                      value.length != 4 ||
                      (int.tryParse(value) ?? -1) < 0) {
                    return "Enter valid Roll No.";
                  }
                  return null;
                },
                onSaved: (newValue) {
                  _rollNo = newValue!;
                },
              ),
            ),
            Spacer(),
          ]),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.only(bottom: 10),
            // height: MediaQuery.of(context).size.height,
            child: AnimatedList(
              shrinkWrap: true,
              key: _listKey,
              controller: _scroll,
              initialItemCount: _controllers.length,
              itemBuilder: (context, idx, animation) => SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(-1.0, 0.0),
                  end: Offset(0.0, 0.0),
                ).animate(animation),
                child: _buildRow(_controllers[idx], idx),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildRow(List<TextEditingController> controllers, int index) {
    // print(index.toString() + _controllers.length.toString());
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            flex: 3,
            child: TextFormField(
              controller: controllers[0],
              decoration: InputDecoration(
                hintText: "Component Name ${index + 1}",
                hintStyle: Theme.of(context).textTheme.bodyLarge,
              ),
              keyboardType: TextInputType.name,
              enableSuggestions: true,
              validator: (value) {
                if (value == null || value.trim().length < 3) {
                  return "Enter valid Name";
                }
                return null;
              },
              onSaved: (newValue) {},
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: TextFormField(
              controller: controllers[1],
              decoration: InputDecoration(
                hintText: "Quantity",
                hintStyle: Theme.of(context).textTheme.bodyLarge,
              ),
              keyboardType: TextInputType.number,
              enableSuggestions: true,
              validator: (value) {
                if (value == null || (int.tryParse(value) ?? -1) < 1) {
                  return "Enter valid Number";
                }
                return null;
              },
              onSaved: (newValue) {},
            ),
          ),
          index != _controllers.length - 1
              ? IconButton(
                  icon: Icon(Icons.remove_circle_outline),
                  onPressed: () => _removeRow(index),
                  color: Colors.red,
                )
              : IconButton(
                  icon: Icon(Icons.add_circle_outline),
                  onPressed: () => _addRow(),
                  color: Colors.red,
                ),
        ],
      ),
    );
  }

  void _addRow() async {
    final idx = _controllers.length;
    _controllers.add([TextEditingController(), TextEditingController()]);
    _listKey.currentState!.insertItem(idx);
    await Future.delayed(Duration(seconds: 1), () {
      _scroll.animateTo(
        _scroll.position.maxScrollExtent + 400,
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
      );
    });
  }

  void _removeRow(int idx) {
    _listKey.currentState?.removeItem(
      idx,
      (context, animation) => SlideTransition(
        position: Tween<Offset>(
          begin: Offset(1, 0),
          end: const Offset(0.0, 0.0),
        ).animate(animation),
        child: _buildRow(_controllers[idx], idx),
      ),
    );
    _controllers.removeAt(idx);
  }
}
