import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:safh/Screens/Home/Home.dart';
import 'package:safh/Screens/viewProfile/viewProfile.dart';
import 'package:safh/Services/database.dart';
import 'package:safh/shared/loading.dart';

class QrScanner extends StatefulWidget {
  bool loading;
  Function showScreen;
  QrScanner({this.loading= false, this.showScreen });
  @override
  _QrScannerState createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> {
  @override
  Widget build(BuildContext context)  {
    return widget.loading? Loading():
    Scaffold(
        resizeToAvoidBottomPadding: false,
        body: FutureBuilder(
        future: scan(),
        builder: (context, snapshot){
          List<DocumentSnapshot> user = snapshot.data ?? [];
          String otherUserUid = '';
          print('user0:  $user');
          if (user == []){
            WidgetsBinding.instance.addPostFrameCallback((_){
              return Home(showScreen: widget.showScreen, msgColor: Colors.redAccent[100], msg: "User not found.",);
            });
          }
          try{otherUserUid=user[0].documentID;}catch(e) {
            WidgetsBinding.instance.addPostFrameCallback((_){
              return Home(showScreen: widget.showScreen, msgColor: Colors.redAccent[100], msg: "Something went wrong.",);
            });

          }
          return ViewProflle(otherUserUid: otherUserUid, fromQr: true,);
        },
      )
    );
  }

  Future<String> scan() async{
    return await DatabaseService().getUserByQrCode();
  }
}
