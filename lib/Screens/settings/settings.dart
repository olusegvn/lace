import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safh/Screens/profile/createProfile.dart';
import 'package:safh/Screens/settings/resetPassword.dart';
import 'package:safh/shared/bottomNavigationBar.dart';
import 'package:safh/shared/loading.dart';
import 'package:safh/shared/profileOptions.dart';


class ProfileSettings extends StatefulWidget {
  Function showTab;
  Function showScreen;
  Widget tab;
  bool loading;
  ProfileSettings({this.showTab, this.tab ,this.showScreen, this.loading=false});
  @override
  _ProfileSettingsState createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  @override
  Widget build(BuildContext context) {
    final _userData = Provider.of<DocumentSnapshot>(context);
    return widget.loading? Loading(): Scaffold(
      resizeToAvoidBottomPadding: false,
      drawer: Drawer(
        elevation: 16,
        child: Column(
          children: <Widget>[
            Container(
              height: 150,
              color: Colors.black,
              child: DrawerHeader(
                child: Center(
                  child: Text("Settings", style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w300,
                    color: Colors.white,

                ),),
              )),
            ),


            Container(
                alignment: Alignment.centerLeft,
                child: ButtonTheme(
                  height: 70,
                  child: FlatButton.icon(splashColor: Colors.black, onPressed: (){setState(() {widget.tab = CreateProfile();});Navigator.pop(context);}, icon: Icon(Icons.person),label: Text('Update Profile', style: TextStyle(
                    fontWeight: FontWeight.w200,
                    fontSize: 20,
                  ),)),
                ),
              ),
            Container(
              alignment: Alignment.centerLeft,
              child: ButtonTheme(
                height: 70,
                child: FlatButton.icon(splashColor: Colors.black, onPressed: (){setState(() {widget.tab = ResetPassword();}); Navigator.pop(context);}, icon: Icon(Icons.lock_outline),label: Text('Change Password', style: TextStyle(
                  fontWeight: FontWeight.w200,
                  fontSize: 20,
                ),)),
              ),
            )

          ],
        ),

      ),

      appBar: AppBar(
        iconTheme: new IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Row(
          children: <Widget>[
            Center(
              child: ProfilePicture(userData: _userData,)
            ),
            Text(_userData['displayName'], style: TextStyle(
              color: Colors.black,
              fontSize: 30,
              fontWeight: FontWeight.w200,
            ),)
          ],
        )
      ),


      body: widget.tab?? CreateProfile(showScreen: widget.showScreen,),

      bottomNavigationBar: LaceBottomNavBar(showScreen: widget.showScreen, callback: (){setState(() {widget.loading=true;});},),
    );
  }
}

