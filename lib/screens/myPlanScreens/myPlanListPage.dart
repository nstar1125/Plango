import 'package:flutter/material.dart';

class MyPlanListPage extends StatefulWidget {
  const MyPlanListPage({Key? key}) : super(key: key);

  @override
  State<MyPlanListPage> createState() => _MyPlanListPageState();
}

class _MyPlanListPageState extends State<MyPlanListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("plans"),),
    );
  }
}
