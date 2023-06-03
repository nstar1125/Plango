import 'package:flutter/material.dart';

class SearchPlanPage extends StatefulWidget {
  const SearchPlanPage({Key? key}) : super(key: key);

  @override
  State<SearchPlanPage> createState() => _SearchPlanPageState();
}

class _SearchPlanPageState extends State<SearchPlanPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("searched plans")),
    );
  }
}
