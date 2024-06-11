import 'dart:ffi';

import 'package:flutter/material.dart';

class MembersScreen extends StatefulWidget {
  const MembersScreen({super.key});

  @override
  State<MembersScreen> createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen> {
  @override
  void initState() {
    initialise();
    super.initState();
  }

  void initialise() {
    
  }

  @override
  Widget build(BuildContext context) {
    return GridView(
      padding: EdgeInsets.all(8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 3 / 4,
      ),
      children: [
        ProfileCard(),
        ProfileCard(),
        ProfileCard(),
        ProfileCard(),
        ProfileCard(),
      ],
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
          color: Colors.grey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                clipBehavior: Clip.hardEdge,
                child: Image.asset(
                  'asset/SAKTHIVELk.jpeg',
                  height: MediaQuery.of(context).size.height / 5,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 30,
                color: Color.fromARGB(234, 154, 39, 189),
                alignment: Alignment.center,
                child: Text(
                  "SAKTHIVEL K",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 35,
                color: Color.fromARGB(255, 48, 199, 237),
                alignment: Alignment.center,
                child: Text(
                  "MEMBER",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
