import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class WalletBalance extends StatefulWidget {
  @override
  _WalletBalanceState createState() => _WalletBalanceState();
}

class _WalletBalanceState extends State<WalletBalance> {
  @override
  Widget build(BuildContext context) {
    DocumentSnapshot _userData = Provider.of<DocumentSnapshot>(context);
    return Center(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Balance",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w300,
              ),
            ),
            Text(
              double.parse(_userData['walletBalance'].toString()).toStringAsFixed(2).toString()?? '0.00'+ "NGN",
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.w200,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
