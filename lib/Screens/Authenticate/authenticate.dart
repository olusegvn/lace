import 'package:flutter/material.dart';
import 'package:safh/Screens/Authenticate/SignIn.dart';
import 'package:safh/Screens/Authenticate/register.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;
  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(showSignIn){
      return SignIn(toggleView: toggleView);
    }
    return Register(toggleView: toggleView);
  }
}
