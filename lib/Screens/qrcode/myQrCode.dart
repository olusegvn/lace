import 'dart:typed_data';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:safh/Screens/Home/Home.dart';
import 'package:safh/shared/loading.dart';
import 'package:safh/shared/profileOptions.dart';



class MyQrCode extends StatefulWidget {
  DocumentSnapshot userData;
  Function showScreen;
  bool loading;
  MyQrCode({this.userData, this.showScreen, this.loading = false});
  @override
  _MyQrCodeState createState() => _MyQrCodeState();
}

class _MyQrCodeState extends State<MyQrCode> {
  @override
  Widget build(BuildContext context) {
    widget.userData = Provider.of<DocumentSnapshot>(context);
    return widget.loading? Loading(): Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        elevation: 0.5,
        title: Row(
          children: <Widget>[
            ButtonTheme(minWidth: 70, height: 50, child: FlatButton.icon(splashColor: Colors.black, onPressed: (){widget.showScreen(Home(showScreen: widget.showScreen,));}, icon: Icon(Icons.arrow_back), label: Text(""))),
            Text("My QRCode",
            style: TextStyle(
                fontSize: 30,
              color: Colors.black,
              fontWeight: FontWeight.w200,
            ),),
          ],
        ),
        backgroundColor: Colors.white,
      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            widget.userData['displayName'],
            style: TextStyle(
              fontWeight: FontWeight.w200,
              fontSize: 45,

            ),
          ),

          ProfilePicture(userData: widget.userData,height: 70,width: 70,),

          Center(
            child: FutureBuilder<List>(
              future: generateImage(),
              builder: (context, snapshot) {
              Uint8List image = snapshot.data ?? [];
              return Container(
                  margin: EdgeInsets.symmetric(vertical: 80),
                  height: 400,
                  width: 400,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: MemoryImage(image),
                          fit: BoxFit.cover)
                  ),
                );
              }
            )
          )


        ],
      ),
    );
  }

  Future<Uint8List> generateImage() async{
    try {
      final image = await QrPainter(
        data: widget.userData.documentID,
        version: QrVersions.auto,
        gapless: false,
        color: Colors.black,
      ).toImage(400);
      final a = await image.toByteData(format: ImageByteFormat.png);
      return a.buffer.asUint8List();
    } catch (e) {
      throw e;
    }
  }
}
