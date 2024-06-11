import 'package:arc_inventory/resource/providers/data_provider.dart';
import 'package:arc_inventory/screens/main_screens/auth_screen.dart';
import 'package:arc_inventory/screens/item_storageAndEditing/edit_screen.dart';
import 'package:arc_inventory/screens/main_screens/loading_screen.dart';
import 'package:arc_inventory/screens/main_screens/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: 'AIzaSyCwn_wDK40UJwPhL9OWYDyXp9sn800Fxxw',
      appId: '1:389118231763:android:e2efa4700e075336788026',
      messagingSenderId: '389118231763',
      projectId: 'arc-inventory-b113f',
      storageBucket: 'arc-inventory-b113f.appspot.com',
    ),
  );
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        scaffoldBackgroundColor: Theme.of(context).colorScheme.primaryContainer,
        snackBarTheme: SnackBarThemeData(
          actionBackgroundColor: Color.fromARGB(153, 69, 12, 144),
          backgroundColor: Color.fromARGB(153, 69, 12, 144),
          dismissDirection: DismissDirection.down,
          contentTextStyle: TextStyle(
            color: Colors.white,
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Color.fromARGB(153, 69, 12, 144),
          titleTextStyle: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(fontSize: 24, color: Colors.white),
        ),
        inputDecorationTheme: InputDecorationTheme().copyWith(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                width: 2, color: Theme.of(context).colorScheme.primary),
            borderRadius: BorderRadius.circular(25),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                width: 2, color: Theme.of(context).colorScheme.primary),
            borderRadius: BorderRadius.circular(25),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(width: 2, color: Colors.red),
          ),
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key});

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: ref.read(studentDataProvider.notifier).init(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.done) {
            print('hi');
            return StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                print(snap);
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return LoadingScreen();
                } else if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    return MainScreen();
                  }
                }
                return AuthScreen();
              },
            );
          } else {
            return LoadingScreen();
          }
        });
  }
}
