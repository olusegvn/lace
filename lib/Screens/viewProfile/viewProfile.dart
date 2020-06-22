import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:safh/Screens/viewProfile/otherUserLinks.dart';
import 'package:safh/Screens/viewProfile/userTests.dart';
import 'package:safh/Services/database.dart';
import 'package:safh/models/SafhAppBarText.dart';
import 'package:safh/shared/loading.dart';
import 'package:safh/shared/profileOptions.dart';
import 'package:photo_view/photo_view.dart';


class ViewProflle extends StatefulWidget {
  bool loading;
  String otherUserUid;
  bool fromQr;
  DocumentSnapshot userData;
ViewProflle({this.fromQr=false,this.loading=false, this.otherUserUid, this.userData});
  @override
  _ViewProflleState createState() => _ViewProflleState();
}

class _ViewProflleState extends State<ViewProflle> {
  @override
  Widget build(BuildContext context) {
    return widget.loading? Loading() : FutureBuilder(
      future: DatabaseService(otherUserUid: widget.otherUserUid).getOtherUserData(),
      builder: (context, snapshot){
      List _userData = snapshot.data ?? [];
      var u;
      try{
        u = _userData[0];
      }catch(e){
        return Loading();
      }
      return  DefaultTabController(
        length: 2,
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: Colors.black
            ),
              backgroundColor: Colors.white,
              elevation: 0.3,
              title: Row(
                children: <Widget>[
                  ProfilePicture(userData: u),
                  Container(
                      child: SafhAppBarTitle(text: "Profile")),

                ],
              ),

              bottom: TabBar(
                indicatorColor: Colors.black,
                tabs: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      border: Border(),
                    ),
                    child: Tab(
                      child: Text(
                        "Tests",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),

                  Container(
                    decoration: BoxDecoration(
                      border: Border(),
                    ),
                    child: Tab(
                      child: Text(
                        "Links",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),


          body: TabBarView(
              children: <Widget>[
                UserTests(otherUserUid: widget.otherUserUid, fromQr: widget.fromQr, userData: widget.userData,),
                OtherUserLinks(otherUserUid: widget.otherUserUid, userData: widget.userData)
              ],
          ),



//        bottomNavigationBar: SafhBottomNavBar(showScreen: widget.showScreen, callback: (){setState(() {widget.loading = true;});},),


        ),
      );
      },
    );
  }
}

