import 'package:arc_inventory/resource/auth.dart';
import 'package:arc_inventory/screens/loading_screen.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _authKey = GlobalKey<FormState>();
  String _email = "";
  String _password = "";
  Authenticate _auth = Authenticate();
  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ARC-INVENTORY",
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: ((context) => LoadingScreen()),
                ),
              );
            },
            color: Theme.of(context).colorScheme.onPrimary,
            icon: Icon(Icons.front_loader),
          )
        ],
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            CircleAvatar(
              radius: 80,
              foregroundImage: AssetImage(
                'asset/arc.jpg',
              ),
              backgroundColor: Colors.grey,
            ),
            Form(
              key: _authKey,
              child: Card(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: Column(children: [
                  SizedBox(
                    height: 12,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    child: TextFormField(
                      initialValue: _email,
                      decoration: InputDecoration(
                        labelText: "Username",
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null ||
                            !value.trim().contains("@iiitkota")) {
                          print('object');
                          return "Enter valid college mail address";
                        }
                        return null;
                      },
                      onSaved: (value) => _email = value!,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    child: TextFormField(
                      initialValue: _password,
                      decoration: InputDecoration(
                        labelText: "Password",
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.trim().length < 3) {
                          return "Enter valid password";
                        }
                        return null;
                      },
                      onSaved: (value) => _password = value!,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_authKey.currentState!.validate()) {
                        _authKey.currentState!.save();
                        print("Test1");
                        await _auth.login(_email, _password);
                      }
                    },
                    child: Text("Enter"),
                    style: ElevatedButton.styleFrom(
                        elevation: 3, fixedSize: Size(100, 30)),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ]),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
