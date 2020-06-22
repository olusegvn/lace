import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:safh/Screens/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:safh/Services/Auth.dart';
import 'package:safh/Services/database.dart';
import 'package:safh/Services/inAppPurchase.dart';
import 'package:splashscreen/splashscreen.dart';


void main() {
  runApp(MaterialApp(
    home: Main(),
  ));
}

class Main extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
    return Center(
      child: SplashScreen(
        backgroundColor: Colors.white,
        seconds: 5,
        loaderColor: Colors.white,
        image: Image.asset('assets/Vanilla-2s-288px.gif'),
        photoSize: 300,
        navigateAfterSeconds: StreamProvider<FirebaseUser>.value(
            value: AuthService().user,
            child: Wrapper(),
      ),
    )
    );
  }
}