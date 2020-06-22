import 'package:flutter/material.dart';

class SafhAppBarTitle extends StatefulWidget {
  String text;
  SafhAppBarTitle({this.text});
  @override
  _SafhAppBarTitleState createState() => _SafhAppBarTitleState();
}

class _SafhAppBarTitleState extends State<SafhAppBarTitle> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text,
      style: TextStyle(
        color: Colors.black,
        fontSize: 25,
        fontWeight: FontWeight.w200,
        letterSpacing: 2.0,
      ),
    );
  }
}
