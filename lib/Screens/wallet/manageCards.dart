import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:provider/provider.dart';
import 'package:safh/Services/database.dart';
import 'package:safh/Services/inAppPurchase.dart';
import 'package:safh/shared/laceSavedCreditCard.dart';


class ManageCards extends StatefulWidget {
  DocumentSnapshot userData;
  ManageCards({this.userData});
  @override
  _ManageCardsState createState() => _ManageCardsState();
}

class _ManageCardsState extends State<ManageCards> {
  @override
  Widget build(BuildContext context) {
    widget.userData = Provider.of<DocumentSnapshot>(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: <Widget>[
        FutureBuilder(
          future: getCards(),
          builder: (context, snapshot) {
            List cards = snapshot.data ?? [];
            return ListView.builder(
                itemCount: cards.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index){
                  var indexCard = cards[index];
                  return InkWell(
                    child: LaceSavedCreditCard(
                      cardNumber: indexCard['cardNo'],
                      expiryDate: indexCard['exp'],
                      cardHolderName: indexCard['holder'],
                      cvvCode: indexCard['cvv'],
                      removeCardCallback: () async{ await DatabaseService(uid: widget.userData.documentID).deleteCardDetails(indexCard['cardNo']);setState(() {});},
                    ),
                  );
                }
            );
          }
        ),

        ],
      ),
    );
  }

  Future addCard() async{
    return ;
  }

  void payViaExistingCard(BuildContext context, card){

  }

  Future getCards() async{
    return await DatabaseService(uid: widget.userData.documentID).getCardDocuments().then((value) => value.map((e) => e.data).toList());
  }

}
