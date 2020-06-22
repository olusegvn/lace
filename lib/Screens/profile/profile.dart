import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safh/Screens/profile/links.dart';
import 'package:safh/Screens/profile/myTests.dart';
import 'package:safh/Screens/settings/settings.dart';
import 'package:safh/models/SafhAppBarText.dart';
import 'package:safh/shared/bottomNavigationBar.dart';
import 'package:safh/shared/loading.dart';
import 'package:safh/shared/profileOptions.dart';


class Profile extends StatefulWidget {
  final Function showScreen;
  bool loading;
  Profile({this.showScreen, this.loading=false});
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    final _userData = Provider.of<DocumentSnapshot>(context);
    return widget.loading? Loading() : DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.3,
            title: Row(
              children: <Widget>[

                ProfilePicture(userData: _userData,),
                Container(
                    child: SafhAppBarTitle(text: "Profile")),

              ],
            ),
            actions: <Widget>[
              FlatButton.icon( splashColor: Colors.black, color: Colors.white, onPressed: (){widget.showScreen(ProfileSettings(showScreen: widget.showScreen,));}, icon: Icon(Icons.settings), label: Text("")),
                      ],

            bottom: TabBar(
//            indicator: BoxDecoration(
//                border: Border(top: BorderSide(width: 1), bottom: BorderSide(width: 1.5), left: BorderSide(width: 1), right: BorderSide(width: 1))
//            ),
              indicatorColor: Colors.black,
              tabs: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    border: Border(),
                  ),
                  child: Tab(
                    child: Text(
                      "My Tests",
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
              MyTests(),
              Links()
            ],
        ),



        bottomNavigationBar: LaceBottomNavBar(showScreen: widget.showScreen, callback: (){setState(() {widget.loading = true;});},),


      ),
    );
  }
}

