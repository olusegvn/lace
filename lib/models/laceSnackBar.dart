import 'package:flutter/material.dart';

class LaceSnackBar{
  void showSnackBar(context, msg, color){
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(
        msg,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w300,
          fontSize: 20,
        ),
      ),
      backgroundColor: color,
    ));
  }
}
