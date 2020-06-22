import 'package:flutter/material.dart';

class  Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: 400,
          color: Colors.white,
          child: Center(
            child: Image.asset('assets/Vanilla-2s-288px.gif'),
          ),
        ),
      ),
    );
  }
}
