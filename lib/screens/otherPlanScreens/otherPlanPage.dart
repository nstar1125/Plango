import 'package:flutter/material.dart';

class OtherPlanPage extends StatefulWidget {
  const OtherPlanPage({Key? key}) : super(key: key);

  @override
  State<OtherPlanPage> createState() => _OtherPlanPageState();
}

class _OtherPlanPageState extends State<OtherPlanPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("other plans"),
      ),
    );
  }
}
