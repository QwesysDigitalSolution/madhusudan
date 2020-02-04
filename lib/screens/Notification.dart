import 'package:flutter/material.dart';

// Component List
import 'package:madhusudan/component/LoadingComponent.dart';
import 'package:madhusudan/component/NotificationComponent.dart';

class NotificationScrren extends StatefulWidget {
  @override
  _NotificationScrrenState createState() => _NotificationScrrenState();
}

class _NotificationScrrenState extends State<NotificationScrren> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.only(top: 5),
      itemCount: 5,
      itemBuilder: (BuildContext context, int index){
        return NotificationComponent("");
      },
    );
  }
}
