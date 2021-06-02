import 'package:flutter/material.dart';
import 'package:nhs_pedometer/ui/drawer/drawer_widget.dart';

class RankingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ranking'),
      ),
      drawer: DrawerWidget(),
    );
  }
}