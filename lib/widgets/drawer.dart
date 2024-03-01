import 'package:arc_inventory/resource/data_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Drawerstate extends ConsumerStatefulWidget {
  Drawerstate(
      {super.key, required this.whetherInitialised, required this.userData});
  final bool whetherInitialised;
  final Map<String, dynamic>? userData;

  @override
  ConsumerState<Drawerstate> createState() => _DrawerstateState();
}

class _DrawerstateState extends ConsumerState<Drawerstate> {
  late TextEditingController _review;
  late TextEditingController _name;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _review = TextEditingController();
    _name = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _review.dispose();
    _name.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool connection = ref.read(studentDataProvider.notifier).connectionStatus;

    return Drawer(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            widget.whetherInitialised
                ? Container(
                    height: MediaQuery.of(context).size.height / 4,
                    color: Color.fromARGB(153, 69, 12, 144),
                    padding: EdgeInsets.only(left: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey,
                          foregroundImage: NetworkImage(
                            widget.userData!['image']!,
                          ),
                        ),
                        SizedBox(width: 5),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.userData!['name']!,
                              style: TextStyle(fontSize: 24),
                            ),
                            Text(
                              widget.userData!['role']!,
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                : CircularProgressIndicator(),
            Container(
              child: Center(
                child: Column(
                  children: [
                    Text(
                      "On Testing Stage!",
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.red,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "If any Suggestion\nDo let me know",
                      style: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 181, 165, 20)),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Write Your Review',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _name,
                      decoration: InputDecoration(
                        hintText: 'Your Belowed Name',
                      ),
                    ),
                    SizedBox(height: 5),
                    TextField(
                      controller: _review,
                      maxLines: 5,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Write your review here...',
                      ),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: connection
                          ? () async {
                              // Get the review text from the text controller
                              String reviewText = _review.text;
                              String nameText = _name.text;
                              bool connectionstatus = ref
                                  .read(studentDataProvider.notifier)
                                  .connectionStatus;
                              if (connectionstatus) {
                                await FirebaseFirestore.instance
                                    .collection("Review")
                                    .doc(nameText)
                                    .set(
                                  {"Response": reviewText},
                                );
                              }
                              // Process the review text, save it, or perform any other action

                              // Clear the text field after submitting
                              _review.clear();
                            }
                          : null,
                      style: ElevatedButton.styleFrom(elevation: 4),
                      child: Text('Submit Review'),
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            Container(
              padding: EdgeInsets.only(bottom: 5),
              child: RichText(
                text: TextSpan(
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: "Contact Detail\n",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w500),
                      ),
                      TextSpan(
                          text:
                              "Contact : 9677053634\nmail : 2022kucp1140@iiitkota.ac.in")
                    ]),
              ),
            )
          ]),
    );
  }
}
