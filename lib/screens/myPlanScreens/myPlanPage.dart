import 'package:flutter/material.dart';

class MyPlanPage extends StatefulWidget {
  const MyPlanPage({Key? key}) : super(key: key);

  @override
  State<MyPlanPage> createState() => _MyPlanPageState();
}

class _MyPlanPageState extends State<MyPlanPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("my plans"),
      ),
    );
  }
}
