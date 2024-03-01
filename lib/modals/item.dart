import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class Item {
  Item({
    required this.compList,
    required this.studName,
    required this.studRollNo,
    this.typeSelect = TypeSel.firstYear,
    String? key,
    String? timeStamp,
  })  : key = key ?? uuid.v4(),
        timeStamp = timeStamp ??
            DateFormat('dd-mm-yyyy hh-mm-ss').format(DateTime.now());
  final String key;
  TypeSel typeSelect;
  final String timeStamp;
  List<Component> compList;
  String studName;
  String studRollNo;

  Map<String, dynamic> toMap() {
    return {
      "compList": compList.map((component) => component.toMap()).toList(), // list of (component name and quantity) map
      "studName": studName,
      "studRollNo": studRollNo,
      "key": key,
      "typeSelect": typeSelect.toString(),
      "timeStamp": timeStamp,
    };
  }

// Without the factory constructor, it is not possible to directly instantiate an Item object from a Map<String, dynamic> representation.
  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      compList: (map['compList'] as List<dynamic>)
          .map((item) => Component.fromMap(item))
          .toList(),
      studName: map['studName'],
      studRollNo: map['studRollNo'],
      typeSelect:
          TypeSel.values.firstWhere((e) => e.toString() == map['typeSelect']),
      key: map['key'],
      timeStamp: map['timeStamp'],
    );
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  factory Item.fromJson(String json) {
    return Item.fromMap(jsonDecode(json));
  }
}

List<Item> sample = [
  Item(compList: [
    Component(compName: 'Arduino uno', quant: 2),
    Component(compName: '4 channel Relay', quant: 5),
  ], studName: 'Athul', studRollNo: '2022KUCP1086'),
  Item(
      compList: [Component(compName: 'Esp 32', quant: 1)],
      studName: 'Athul',
      studRollNo: '2022KUEC1140'),
  Item(
      compList: [Component(compName: '4 channel Relay', quant: 1)],
      studName: 'Athul',
      studRollNo: '2022KUCP1126'),
  Item(
      compList: [Component(compName: 'bread Board', quant: 3)],
      studName: 'Athul',
      studRollNo: '2022KUCP1089'),
];

enum TypeSel {
  secondYear,
  firstYear,
  thirdYear,
  other,
}

class Component {
  Component({required this.compName, required this.quant});
  String compName;
  int quant;

  Map<String, dynamic> toMap() {
    return {
      "compName": compName,
      "quant": quant,
    };
  }

  factory Component.fromMap(Map<String, dynamic> map) {
    return Component(
      compName: map['compName'],
      quant: map['quant'],
    );
  }
}

// // Encoding to JSON
// String jsonSample = jsonEncode(sample.map((item) => item.toMap()).toList());
// print(jsonSample);

// // Decoding from JSON
// List<dynamic> decodedList = jsonDecode(jsonSample);
// List<Item> decodedItems = decodedList.map((item) => Item.fromMap(item)).toList();
// print(decodedItems);
