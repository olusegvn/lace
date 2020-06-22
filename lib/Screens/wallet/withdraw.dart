import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safh/Services/database.dart';
import 'package:safh/shared/laceInputField.dart';
import 'package:safh/shared/laceSearchableDropDown.dart';

class Withdraw extends StatefulWidget {
  String amount;
  String currency;
  Withdraw({this.currency, this.amount});
  @override
  _WithdrawState createState() => _WithdrawState();
}

class _WithdrawState extends State<Withdraw> {
  @override
  Widget build(BuildContext context) {
    DocumentSnapshot _userdata = Provider.of<DocumentSnapshot>(context);
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                "Withdraw",
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.w200,
                ),
              ),
            )
            ,
            LaceInputField(
              label: 'Amount',
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              callback: (val){setState(() {
                widget.amount = val;
              });},
              keyboardType: TextInputType.number,

            ),

            Container(
                margin: EdgeInsets.symmetric(vertical: 15),
                child: LaceSearchableDropDown(
                  listItems: [
                    DropdownMenuItem(
                      value: "USD",
                      child: Text("USD"),
                    ),
                    DropdownMenuItem(
                      value: "NGN",
                      child: Text("NGN"),
                    ),
                  ],
                  underlineColor: Colors.black,
                  subject: "Currency",
                  callback: (val)=> setState(() {
                    widget.currency = val;
                  }),
                )
            ),

            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              width: double.infinity,
              height: 50,
              child: FlatButton(
                onPressed: () {
                  DatabaseService(uid: _userdata.documentID).requestWithdrawal(widget.amount, widget.currency);
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text(
                      "Withdraw request successfully sent.",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                        fontSize: 20,
                      ),
                    ),
                    backgroundColor: Colors.greenAccent[100],
                  )
                  );
                },
                splashColor: Colors.white,
                child: Text("Request",
                  style: TextStyle(
                    fontWeight: FontWeight.w200,
                    fontSize: 30,
                    color: Colors.white,
                  ),),
                color: Colors.black,
              ),
            )

          ],
        ),
      ),

    );;
  }
}
