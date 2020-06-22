import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safh/Services/database.dart';
import 'package:safh/shared/laceInputField.dart';


class ResetPassword extends StatefulWidget {
  String currentPassword;
  String newPassword;
  String confirmPassword;
  ResetPassword({this.confirmPassword, this.currentPassword, this.newPassword});
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  @override
  Widget build(BuildContext context) {
    DocumentSnapshot _userData = Provider.of<DocumentSnapshot>(context);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Center(child: Container(
        margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/8,),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Change Password",style: TextStyle(
              fontSize: 45,
              fontWeight: FontWeight.w200,
              letterSpacing: 2,
            ),),

            SizedBox(height: 30,),

            LaceInputField(
              margin: EdgeInsets.symmetric(vertical: 20),
              padding: EdgeInsets.symmetric(horizontal: 15),
              label: "Current Password",
              callback: (val)=> setState(() {
                widget.currentPassword = val;
              }),

            ),

            LaceInputField(
              margin: EdgeInsets.symmetric(vertical: 20),
              padding: EdgeInsets.symmetric(horizontal: 15),
              label: "New Password",
              callback: (val)=> setState(() {
                widget.newPassword = val;
              }),

            ),

            LaceInputField(
              margin: EdgeInsets.symmetric(vertical: 20),
              padding: EdgeInsets.symmetric(horizontal: 15),
              label: "Confirm Password",
              callback: (val)=> setState(() {
                widget.confirmPassword = val;
              }),

            ),

            SizedBox(height: 20,),

            Container(
              height: 60,
              width: 400,
              child: FlatButton(
                color: Colors.black,
                splashColor: Colors.white,
                child: Text(
                  "Change Password",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                    fontSize: 20,
                  ),
                ),
                onPressed: (){
                  if(widget.currentPassword != _userData['password']) {
                    Scaffold.of(context).showSnackBar(SnackBar(content: Text(
                      "Current password is incorrect.",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                        fontSize: 20,
                      ),
                    ), backgroundColor: Colors.redAccent[100],));
                  }
                  else if(widget.confirmPassword != widget.newPassword){
                    Scaffold.of(context).showSnackBar(SnackBar(content: Text(
                      "New password and confirm password do not match.",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                        fontSize: 20,
                      ),
                    ), backgroundColor: Colors.redAccent[100],));
                  }else {
                    if (DatabaseService(uid: _userData.documentID)
                        .resetPassword(widget.newPassword, _userData['email']) != null) {
                      Scaffold.of(context).showSnackBar(SnackBar(content: Text(
                        "Sent reset password link.Check email and follow instructions.",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                          fontSize: 20,
                        ),
                      ), backgroundColor: Colors.greenAccent[100],));
                    }
                  }
                },
              )
            )


          ],
        ),
      )),
    );
  }
}

