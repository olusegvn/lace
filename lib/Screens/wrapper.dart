import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:safh/Screens/Authenticate/authenticate.dart';
import 'package:safh/Screens/Home/Home.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:safh/Services/database.dart';


class Wrapper extends StatefulWidget {
  Widget mainScreen ;
  Wrapper({this.mainScreen});
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);

    void showScreen(Widget screen){
      setState(() {
        widget.mainScreen = screen;
      });
    }
    if(widget.mainScreen == null)
      widget.mainScreen = Home(showScreen: showScreen);
    if (user == null){
      return Authenticate();
    }
    return StreamProvider<DocumentSnapshot>.value(
      value: DatabaseService(uid: user.uid).userData,
      child: widget.mainScreen,
    );
  }
}
