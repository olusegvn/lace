import 'package:flutter/material.dart';
import 'package:safh/Screens/wallet/paymentCards.dart';
import 'package:safh/models/laceSnackBar.dart';
import 'package:safh/shared/laceInputField.dart';
import 'package:safh/shared/laceSearchableDropDown.dart';

class FundWallet extends StatefulWidget {
  String amount;
  String currency;
  Function showScreen;
  FundWallet({this.amount, this.showScreen, this.currency});
  @override
  _FundWalletState createState() => _FundWalletState();
}

class _FundWalletState extends State<FundWallet> {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/7,),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                "Fund Wallet",
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
//                  DropdownMenuItem(
//                  value: "USD",
//                  child: Text("USD"),
//                    ),
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
                  if(widget.amount == null|| widget.currency == null){
                        LaceSnackBar().showSnackBar(context, "Form not completely filled.", Colors.redAccent[100]);
                      }
//                  else if(widget.amount){
//                    LaceSnackBar().showSnackBar(context, "Form not completely filled.", Colors.redAccent[100]);
//                  }
                  else {
                    widget.showScreen(PaymentCards(amount: widget.amount,
                      currency: widget.currency,
                      showScreen: widget.showScreen,));
                  }
                },
                splashColor: Colors.white,
                child: Text("Pay",
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

    );
  }
}
