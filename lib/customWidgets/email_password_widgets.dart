import 'package:flutter/material.dart';

class EmailPasswordWidgets extends StatelessWidget {
  String email;
  String name;
  EmailPasswordWidgets({super.key,required this.email,required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(name,style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold
          ),),
          Text(email,style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500
          ),)
        ],
      ),
    );
  }
}