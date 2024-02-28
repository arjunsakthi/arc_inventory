import 'package:arc_inventory/screens/auth_screen.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with TickerProviderStateMixin {
  late AnimationController _loaderController;
  late AnimationController _loaderRotater;

  @override
  void initState() {
    super.initState();
    _loaderController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
      lowerBound: 0.1,
      upperBound: 1,
    );
    _loaderRotater = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
      lowerBound: 0,
      upperBound: 1,
    );
    _loaderController.repeat(reverse: true);
    _loaderRotater.repeat(reverse: true);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _loaderController.dispose();
    _loaderRotater.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        child: Scaffold(
          body: Center(
              child: Container(
            padding: EdgeInsets.all(8),
            height: 200,
            width: MediaQuery.of(context).size.width / 3 * 2,
            child: Image.asset(
              'asset/arc.jpg',
              fit: BoxFit.fill,
            ),
            decoration: BoxDecoration(
              color: Colors.blueGrey,
              borderRadius: BorderRadius.all(Radius.circular(250)),
            ),
            clipBehavior: Clip.hardEdge,
          )
              // CircleAvatar(
              //   radius: MediaQuery.of(context).size.width / 3,
              //   foregroundImage: AssetImage('asset/arc.jpg'),
              //   backgroundColor: Colors.grey,
              // ),
              ),
        ),
        animation: _loaderController,
        builder: (context, child) => RotationTransition(
          turns: CurvedAnimation(
              parent: _loaderController, curve: Curves.fastEaseInToSlowEaseOut),
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: _loaderController,
              curve: Curves.easeInOut,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
