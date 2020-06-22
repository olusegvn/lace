import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:safh/Screens/Home/Home.dart';
import 'package:safh/Services/Auth.dart';
import 'package:safh/Services/database.dart';
import 'package:safh/models/laceSnackBar.dart';
import 'package:safh/shared/loading.dart';
import 'package:safh/shared/profileOptions.dart';
import 'package:safh/shared/laceInputField.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:safh/shared/bottomNavigationBar.dart';
import 'package:safh/shared/laceSearchableDropDown.dart';


class TestUpload extends StatefulWidget {
  final Function showScreen;
  String test = "Select Test";
  File resultImage;
  String currency;
  bool loading ;
  double price;
  File confirmImage;
  String priceValidated;
  Color priceBordrColor;
  String status;
  TestUpload({this.showScreen, this.status, this.loading=false, this.test = "Select Test", this.resultImage, this.price, this.confirmImage, this.currency, this.priceValidated, this.priceBordrColor});
  @override
  _TestUploadState createState() => _TestUploadState();
}

class _TestUploadState extends State<TestUpload> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    final userData = Provider.of<DocumentSnapshot>(context);
    return widget.loading? Loading() : Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: <Widget>[
            ProfilePicture(userData: userData,),
            Text(
              "Upload Test Result",
              style: TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.w200,
                letterSpacing: 2.0,
              ),
            ),
          ],
        ),
      ),

      body: Builder(
      builder: (context) => Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/8,),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
             LaceSearchableDropDown(
               underlineColor: Colors.black,
               callback: (val)=> setState(() {
                 widget.test = val;
               }),
               subject: "Select Test",
               listItems: [
                 DropdownMenuItem(
                   value: "Covid 19",
                   child: Text("Covid 19"),
                 ),
                 DropdownMenuItem(
                   value: "HIV",
                   child: Text("HIV"),
                 ),
               ],
             ),

              Container(
                height: 200,
                width: 350,
                margin: EdgeInsets.symmetric(vertical: 60),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  border: Border.all(
                    color: Colors.black
                  ),
                ),
                child: FlatButton.icon(
                  onPressed: uploadResult,
                  splashColor: Colors.black,
                  icon: widget.resultImage == null ?
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.add_a_photo, size: 100,),
                      Text(
                        "Upload Result",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                          fontWeight: FontWeight.w300,

                        ),
                      )
                    ],
                  )
                      :
                  Image.file(widget.resultImage), label: Text(""),
                ),
              ),


              LaceSearchableDropDown(
                underlineColor: Colors.black,
                callback: (val)=> setState(() {
                  widget.currency = val;
                }),
                subject: "Select Currency for viewing price",
                listItems: [
                  DropdownMenuItem(
                    value: "USD",
                    child: Text("\$ United States Dollar (USD)"),
                  ),
                  DropdownMenuItem(
                    value: "Naira",
                    child: Text("N= Nigerian Naira"),
                  ),
                ],
              ),


              LaceInputField(
                label: "Viewing Price (0, if free)",
                padding: EdgeInsets.only(left: 15),
                margin: EdgeInsets.symmetric(vertical: 60),
                validator: widget.priceValidated,
                borderColor: widget.priceBordrColor,
                callback: (val)=> setState(() {
                  try{widget.price = double.parse(val.trim());widget.priceValidated=null;}catch(e){setState(() {
                    widget.priceValidated = 'Invalid Price';});}if(widget.priceValidated!=null){setState(() {
                      widget.priceBordrColor = Colors.redAccent[100];
                    });}else{setState(() {widget.priceBordrColor = Colors.black; });}
                }),

              ),



//              Container(
//                height: 200,
//                width: 350,
//                margin: EdgeInsets.symmetric(vertical: 20),
//                decoration: BoxDecoration(
//                  color: Colors.grey[100],
//                  border: Border.all(
//                      color: Colors.black
//                  ),
//                ),
//                child: FlatButton.icon(
//                  onPressed: uploadConfirmImage,
//                  splashColor: Colors.black,
//                  icon: widget.confirmImage == null ?
//                  Column(
//                    mainAxisAlignment: MainAxisAlignment.center,
//                    children: <Widget>[
//                      Icon(Icons.add_a_photo, size: 100,),
//                      Text(
//                        "Upload a picture taken at the hospital(optional)",
//                        style: TextStyle(
//                          color: Colors.black,
//                          fontSize: 14,
//                          fontWeight: FontWeight.w300,
//
//                        ),
//                      )
//                    ],
//                  )
//                      :
//                  Image.file(widget.confirmImage, fit: BoxFit.contain,), label: Text(""),
//                ),
//              ),

               ButtonTheme(
                  minWidth: 800,
                  height: 60,
                  child: FlatButton(
                    splashColor: Colors.white,
                    color: Colors.black,
                    child: Text(
                        "Upload Test Result",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontSize: 20),
                    ),
                    onPressed: () async{
                      if(widget.resultImage == null|| widget.test==null||widget.currency==null||widget.price==null)
                        LaceSnackBar().showSnackBar(context, "Form not completely filled.", Colors.redAccent[100]);
                      else if(widget.priceValidated != null)
                        LaceSnackBar().showSnackBar(context, "Invalid Price. Use '0' if price is to be viewed for free", Colors.redAccent[100]);
                      else{
                        setState(() {widget.loading = true;});
                        dynamic result = await DatabaseService(uid: user.uid).uploadTestResult(widget.resultImage, widget.test, widget.currency, widget.price);
                        if(result == false){
                          LaceSnackBar().showSnackBar(context, "Unable to upload Test Result. Please check form and try again.", Colors.redAccent[100]);
                          setState(() {widget.loading = false;});
                        }else{
                          setState(() {widget.loading = false;widget.showScreen(Home(showScreen: widget.showScreen, msg: "Test Result Successfully uploaded.", msgColor: Colors.greenAccent[100],));});
                        }
                      };
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
      ),

      bottomNavigationBar: LaceBottomNavBar(showScreen: widget.showScreen, callback: (){setState(() {widget.loading = true;});}),

    );
  }

  Future uploadResult() async{
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      widget.resultImage = image;
    });
  }
  Future uploadConfirmImage() async{
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      widget.confirmImage = image;
    });
  }
}

