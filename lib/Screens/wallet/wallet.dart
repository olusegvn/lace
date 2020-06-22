import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safh/Screens/profile/createProfile.dart';
import 'package:safh/Screens/settings/resetPassword.dart';
import 'package:safh/Screens/wallet/fundWallet.dart';
import 'package:safh/Screens/wallet/walletBalance.dart';
import 'package:safh/Screens/wallet/withdraw.dart';
import 'package:safh/Screens/wallet/manageCards.dart';
import 'package:safh/shared/bottomNavigationBar.dart';
import 'package:safh/shared/loading.dart';
import 'package:safh/shared/profileOptions.dart';


class Wallet extends StatefulWidget {
  Function showTab;
  Function showScreen;
  Widget tab;
  bool loading;
  Wallet({this.showTab, this.tab ,this.showScreen, this.loading=false});
  @override
  _WalletState createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  @override
  Widget build(BuildContext context) {
    final _userData = Provider.of<DocumentSnapshot>(context);
//    widget.tab = WalletBalance();
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
                    child: Text("Wallet", style: TextStyle(
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
                child: FlatButton.icon(splashColor: Colors.black, onPressed: (){setState(() {widget.tab = WalletBalance();});Navigator.pop(context);}, icon: Icon(Icons.account_balance_wallet),label: Text('Balance', style: TextStyle(
                  fontWeight: FontWeight.w200,
                  fontSize: 20,
                ),)),
              ),
            ),


            Container(
              alignment: Alignment.centerLeft,
              child: ButtonTheme(
                height: 70,
                child: FlatButton.icon(splashColor: Colors.black, onPressed: (){setState(() {widget.tab = FundWallet(showScreen: widget.showScreen,);});Navigator.pop(context);}, icon: Icon(Icons.credit_card),label: Text('Fund Wallet', style: TextStyle(
                  fontWeight: FontWeight.w200,
                  fontSize: 20,
                ),)),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: ButtonTheme(
                height: 70,
                child: FlatButton.icon(splashColor: Colors.black, onPressed: (){setState(() {widget.tab = Withdraw();}); Navigator.pop(context);}, icon: Icon(Icons.check_circle),label: Text('Withdraw', style: TextStyle(
                  fontWeight: FontWeight.w200,
                  fontSize: 20,
                ),)),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: ButtonTheme(
                height: 70,
                child: FlatButton.icon(splashColor: Colors.black, onPressed: (){setState(() {widget.tab = ManageCards();}); Navigator.pop(context);}, icon: Icon(Icons.format_line_spacing),label: Text('Manage Cards', style: TextStyle(
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


      body: widget.tab ?? WalletBalance(),

      bottomNavigationBar: LaceBottomNavBar(showScreen: widget.showScreen, callback: (){setState(() {widget.loading=true;});},),
    );
  }
}
