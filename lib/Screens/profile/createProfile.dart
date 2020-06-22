import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safh/Screens/Home/Home.dart';
import 'package:safh/Services/Auth.dart';
import 'package:safh/Services/database.dart';
import 'package:safh/models/showAlert.dart';
import 'package:image_picker/image_picker.dart';
import 'package:safh/shared/loading.dart';
import 'package:safh/shared/profileOptions.dart';


class CreateProfile extends StatefulWidget {
  File image;
  Function showScreen;
  CreateProfile({this.image, this.showScreen});

  @override
  _CreateProfileState createState() => _CreateProfileState();

}

class _CreateProfileState extends State<CreateProfile> {
  String displayName;
  bool loading = false;
  final showAlert = ShowAlert();
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    final _userData = Provider.of<DocumentSnapshot>(context);
    return loading? Loading() : Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Update Profile",
                style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.w100,
                  letterSpacing: 2.0,
                ),
              ),
              SizedBox(height: 30),
              Container(
                height: 250,
                width: MediaQuery.of(context).size.width/1.3,
                decoration: BoxDecoration(
                    shape: BoxShape.circle
                ),
                child: FlatButton.icon(
                  onPressed: uploadAvatar,
                  splashColor: Colors.black,
                  icon: widget.image == null ? ProfilePicture(userData: _userData, height: 250,width: 250,): Image.file(widget.image), label: Text(""),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 25),
                padding: EdgeInsets.symmetric(horizontal: 10),
                height: 43,
                width: MediaQuery.of(context).size.width/1.3,
                decoration: BoxDecoration(
                    border: Border.symmetric(horizontal: BorderSide(width: 1, color: Colors.black))
                ),
                child: TextFormField(
                    validator: (val) => val.isEmpty? "Display Name Field is empty": null,
                    cursorColor: Colors.black,
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 18,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: _userData['displayName'] ?? "Display Name",
                    ),
                    onChanged: (value){displayName = value.trim();}),
              ),
              ButtonTheme(
                minWidth: MediaQuery.of(context).size.width/1.3,
                height: 50,
                child: FlatButton(
                  color: Colors.black,
                  splashColor: Colors.white,
                  onPressed: () async{
                    if(_formKey.currentState.validate()) {
                      setState(() {
                        loading = true;
                      });
                      dynamic result = await DatabaseService(uid: user.uid)
                          .updateProfile(
                          displayName = displayName, widget.image);
                      print(result);
                      if (result == false) {
                        showAlert.showAlert(
                            context, "Failed !", "Failed to update profile.",
                            Colors.redAccent[100]);
                        setState(() {
                          loading = false;
                        });
                      } else {
                        setState(() {
                          loading = false;
                        });
                        widget.showScreen(Home(
                          msg: "Successfully created profile",
                          msgColor: Colors.greenAccent[100],
                          showScreen: widget.showScreen,));
                      };
                    }
                  },
                  child: Text(
                    "Update Profile",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w300,
                    ),

                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future uploadAvatar() async{
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      widget.image = image;
    });
  }
}
