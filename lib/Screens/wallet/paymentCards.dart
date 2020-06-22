import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:provider/provider.dart';
import 'package:safh/Screens/Home/Home.dart';
import 'package:safh/Screens/wallet/fundWallet.dart';
import 'package:safh/Screens/wallet/wallet.dart';
import 'package:safh/Services/database.dart';
import 'package:safh/Services/inAppPurchase.dart';
import 'package:safh/shared/laceNewCreditCard.dart';
import 'package:safh/shared/laceSavedCreditCard.dart';
import 'package:stripe_payment/stripe_payment.dart';


class PaymentCards extends StatefulWidget {
  DocumentSnapshot userData;
  String amount;
  String currency;
  Function showScreen;
  PaymentCards({this.userData, this.amount, this.currency, this.showScreen});
  @override
  _PaymentCardsState createState() => _PaymentCardsState();
}

class _PaymentCardsState extends State<PaymentCards> {
  @override
  Widget build(BuildContext context) {
    widget.userData = Provider.of<DocumentSnapshot>(context);
    double stipend;
    switch(widget.currency){
      case 'NGN':
        stipend = 116.40;
        break;

      case 'USD':
        stipend = 0.3;
        break;
    }
    final stripeFee = (0.029 * double.parse(widget.amount)) + stipend;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: FlatButton.icon(
          splashColor: Colors.black,
          onPressed: (){widget.showScreen(Wallet(showScreen: widget.showScreen,));},
          label: Text(""),
          icon: Icon(Icons.arrow_back, size: 20,),
        ),
        title: Text('Fund wallet',
        style: TextStyle(
            color: Colors.black,
          fontSize: 30,
          fontWeight: FontWeight.w200,
        ),),
      ),
      body:
      ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(vertical: 50),
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: Column(
              children: <Widget>[
                FutureBuilder(
                    future: getCards(),
                    builder: (context, snapshot) {
                      List cards = snapshot.data ?? [];
                      print(snapshot.data);
                      return ListView.builder(
                          itemCount: cards.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index){
                            dynamic indexCard = cards[index];
                            var exp = indexCard['exp'].split('/');
                            return FlatButton(
                              splashColor: Colors.white,
                              onPressed: () async{
                                CreditCard stripeCard = CreditCard(
                                  number: indexCard['cardNo'],
                                  expMonth: int.parse(exp[0]),
                                  expYear: int.parse(exp[1]),
                                );
                                print((int.parse(widget.amount)*100).toString());
                                print(widget.amount);
                                var response = await StripeService.payViaExistingCard(
                                    amount: (int.parse(widget.amount)*100).toString(),
                                    currency: widget.currency,
                                    card: stripeCard
                                );
                                if(response.success){
                                  DatabaseService(uid: widget.userData.documentID).fundWallet((double.parse(widget.amount) + double.parse(widget.userData['walletBalance'].toString()) - stripeFee));
                                }
                                widget.showScreen(Home(
                                  showScreen: widget.showScreen, msg: response.success? "Successfully paid ${widget.amount}${widget.currency}, fees apply.": "Transaction Failed", msgColor: response.success? Colors.greenAccent[100]: Colors.redAccent[100],
                                ));

                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 20),
                                child: LaceSavedCreditCard(
                                  cardNumber: indexCard['cardNo'],
                                  expiryDate: indexCard['exp'],
                                  cardHolderName: indexCard['holder'],
                                  cvvCode: indexCard['cvv'],
                                  removeCardCallback: () async{ await DatabaseService(uid: widget.userData.documentID).deleteCardDetails(indexCard['cardNo']);setState(() {});},
                                ),
                              ),
                            );
                          }
                      );
                    }
                ),
//            Container(
//              height: 100,
//              decoration: BoxDecoration(
//                  border: Border.all(color: Colors.black54, width: 0.2),
//                  borderRadius: BorderRadius.circular(10)
//              ),
//              margin: EdgeInsets.symmetric(vertical: 50),
//              child: ListTile(
//
//                onTap: () async{
//                  var response = await StripeService.payWithNewCard(amount: widget.amount, currency: widget.currency);
//                  if(response.success){
//                    DatabaseService(uid: widget.userData.documentID).fundWallet(double.parse(widget.amount.toString()) + double.parse(widget.userData['walletBalance'].toString()?? '0.00'));
//                  }
//                  Scaffold.of(context).showSnackBar(SnackBar(
//                    content: Text(response.message),
//                    duration: Duration(seconds: 2),
//                    backgroundColor: response.success? Colors.greenAccent[100]: Colors.redAccent[100],
//                  ));
//                },
//                contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
//                leading: Icon(Icons.credit_card, size: 40,color: Colors.black,),
//                title: Text("Add Credit Card",
//                  style: TextStyle(
//                    fontWeight: FontWeight.w300,
//                    fontSize: 20,
//
//                  ),),
//                trailing: ButtonTheme(
//                    minWidth: 30,
//
//                    child: ClipOval(
//                      child: Material(
//                        color: Colors.black,
//                        child: InkWell(
//                          splashColor: Colors.white, // inkwell color
//                          child: SizedBox(width: 53, height: 53, child: Icon(Icons.add, color: Colors.white,)),
//                          onTap: () async{
//                            StripeTransactionResponse response = await StripeService.payWithNewCard(
//                                amount: widget.amount,
//                            );
//                            print(response.success);
//                            if(response.success){
//                              DatabaseService(uid: widget.userData.documentID).fundWallet(double.parse(widget.amount) + double.parse(widget.userData['walletBalance']));
//                            }
//                          },
//                        ),
//                      ),
//                    )
//                ),
//              ),
//            )

                LaceNewCreditCard(
                  amount: widget.amount,
                  currency: widget.currency,
                  userData: widget.userData,
                  showScreen: widget.showScreen,
                )
              ],
            ),
          ),
        ],
      )

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
