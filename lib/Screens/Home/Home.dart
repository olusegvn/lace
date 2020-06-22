import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:safh/Screens/Authenticate/authenticate.dart';
import 'package:safh/Screens/Home/Friends.dart';
import 'package:safh/Screens/Home/searchView.dart';
import 'package:safh/Screens/profile/createProfile.dart';
import 'package:safh/Screens/profile/profile.dart';
import 'package:safh/Screens/qrcode/myQrCode.dart';
import 'package:safh/Screens/qrcode/qrCodeScanner.dart';
import 'package:safh/Screens/testUpload.dart';
import 'package:safh/Services/Auth.dart';
import 'package:flutter/services.dart';
import 'package:safh/Services/database.dart';
import 'package:safh/Services/inAppPurchase.dart';
import 'package:safh/shared/bottomNavigationBar.dart';
import 'package:safh/shared/loading.dart';
import 'package:safh/shared/laceInputField.dart';


class Home extends StatefulWidget {
  File profileImage;
  Function showScreen;
  String msg;
  Color msgColor;
  bool loading;
  String searching;
  Home({this.profileImage, this.showScreen, this.loading=false, this.searching='', this.msg, this.msgColor});

  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  String query;
  List<String> homePopUpMenuButtonOptions = <String>[
    'Profile',
    'Sign Out',
  ];
  @override
  void initState(){
    super.initState();
    StripeService.init();
  }
  Widget build(BuildContext context) {
    final userData = Provider.of<DocumentSnapshot>(context);
    final user = Provider.of<FirebaseUser>(context);
    dynamic _userData;
    if(userData == null) {
      _userData = {};
      return Loading();
    }
    else
      _userData = userData.data;
    try{
      if (_userData['displayName'] == null)
        return CreateProfile();
    }catch(e){return Authenticate();}
    if(widget.loading)
      return Loading();
    print("\n\n\n\n\n\n\n${widget.msg}");

    double screenWidth  = MediaQuery.of(context).size.width;
    bool small = screenWidth < 500;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: Container(
            margin: EdgeInsets.only(left: 5, top: 5),
            child: PopupMenuButton<String>(
              child: Container(
                child: Icon(Icons.settings, color: Colors.white, size: 22,),
                height: screenWidth/25,
                width: screenWidth/25,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 7,
                      offset: Offset(0, 0), // changes position of shadow
                    ),
                  ],
                  image: DecorationImage(image: NetworkImage(_userData['profilePictureUrl']),fit: BoxFit.cover),

                ),
              ),
              onSelected: handleSelected,
              itemBuilder: (BuildContext context){
                return homePopUpMenuButtonOptions.map((String option){
                  return PopupMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList();
              },
            ),
          ),
          title: Container(
                child: Text(
                  screenWidth < 500?"":
                  "Gallery",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: screenWidth/23,
                    fontWeight: FontWeight.w200,
                    letterSpacing: 2.0,
                  ),
                ),
              ),

          actions: <Widget>[

            Container(
              margin: const EdgeInsets.only(top: 5),
              padding: EdgeInsets.only(left: 10),
              width: screenWidth/2,
              height: 3,
              decoration: BoxDecoration(
                  border: Border(left: BorderSide(width: 0.1), right: BorderSide(width: 0.1), bottom: BorderSide(width: 0.0))
              ),
              child: TextFormField(
                  validator: (val) => val.isEmpty? "Display Name Field is empty": null,
                  cursorColor: Colors.black,
                  style: TextStyle(
                    fontWeight: FontWeight.w100,
                    fontSize: 18,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search",
                  ),
                  onChanged: (val){setState(() {
                    widget.searching = val.trim();
                    DatabaseService(uid: user.uid).getUsers(query);
                  });}),
            ),
            Container(width: small? screenWidth/7:screenWidth/10, child: FlatButton.icon( splashColor: Colors.black, color: Colors.white, onPressed: (){widget.showScreen(MyQrCode(showScreen: widget.showScreen,));}, icon: Icon(Icons.camera_front, size: small? screenWidth/20: screenWidth/25,), label: Text(""))),
            Container(width: screenWidth/7, child: FlatButton.icon( splashColor: Colors.black, color: Colors.white, onPressed: (){widget.showScreen(QrScanner(showScreen: widget.showScreen,));}, icon: Icon(Icons.camera_rear, size: small? screenWidth/20:screenWidth/25,), label: Text(""))),

          ],

          bottom: TabBar(
            indicatorColor: Colors.black,
            tabs: <Widget>[
              Container(
                decoration: BoxDecoration(
                  border: Border(),
                ),
                child: Tab(
                  child: Text(
                      "Trend",
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
                    "Friends",
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



        body: Builder(
          builder: (BuildContext context){
            WidgetsBinding.instance.addPostFrameCallback((_){

            if(widget.msg != null) {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(
                  widget.msg,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w300,
                    fontSize: 20,
                  ),
                ),
                backgroundColor: widget.msgColor,
              )
              );
            }
            });
          return TabBarView(
            children: [
              widget.searching==''? Friends(): SearchView(searchValue: widget.searching,callback:
                  (){setState(() {widget.searching='';}); }
                  ,context: context,),
              widget.searching==''? Friends(): SearchView(searchValue: widget.searching,callback: (){setState(() {widget.searching='';});},context: context,),
            ],
          );

          }
        ),

        floatingActionButton: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            image: DecorationImage(image: NetworkImage(_userData['profilePictureUrl']),fit: BoxFit.cover),
          ),
          child: FloatingActionButton(

            backgroundColor: Colors.transparent,
            child: Icon(Icons.add_a_photo, size: 25,),
            splashColor: Colors.white,
            onPressed: () { widget.showScreen(TestUpload(showScreen: widget.showScreen)); widget.loading=true;},
          ),
        ),

        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,


        bottomNavigationBar: LaceBottomNavBar(showScreen: widget.showScreen, callback: (){setState(() {widget.loading = true;});})
      ),
    );
  }

  void handleSelected(String option){
    if(option.toString() == 'Sign Out'){signOut();}
    else if(option.toString() == 'Profile'){widget.showScreen(Profile(showScreen: widget.showScreen,));}

  }

  void signOut() async {
    await _auth.signOut();
  }

}



//  @override
//  Widget build(BuildContext context) {
//