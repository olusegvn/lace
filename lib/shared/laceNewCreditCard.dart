import 'package:credit_card_validate/credit_card_validate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:masked_text_input_formatter/masked_text_input_formatter.dart';
import 'package:safh/Screens/Home/Home.dart';
import 'package:safh/Services/database.dart';
import 'package:safh/Services/inAppPurchase.dart';
import 'package:stripe_payment/stripe_payment.dart';

class LaceNewCreditCard extends StatefulWidget {
  Function callback;
  String cardNo;
  String cvv;
  String exp;
  String amount;
  String currency;
  Function showScreen;
  IconData cardBrandIcon;
  String holder;
  var userData;
  LaceNewCreditCard({this.callback, this.cardNo, this.cvv, this.exp, this.currency, this.amount, this.userData, this.showScreen, this.cardBrandIcon, this.holder});
  @override
  _LaceNewCreditCardState createState() => _LaceNewCreditCardState();
}

class _LaceNewCreditCardState extends State<LaceNewCreditCard> {
  @override
  Widget build(BuildContext context) {
    String brand;


    return Container(
      width: 600,
      height: 450,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 0.6, ),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Column(
        children: <Widget>[

          Container(
            margin: EdgeInsets.all(15),
            child: Row(
              children: <Widget>[
                Container(
                    width: 50,
                    height: 50,
                    margin: EdgeInsets.only(right: 10),
                    child: Image.asset('assets/credit-card-5.png', )
                ),

                Container(
                  width: 400,
                  height: 70,
                  margin: EdgeInsets.only(top: 20),
                  child: TextField(
                    maxLength: 19,
                    cursorColor: Colors.black,
                    onChanged: (val){
                      try{
                        brand = CreditCardValidator.identifyCardBrand(val);
                      }catch(e){brand = '0';}

                      switch(brand){
                        case 'visa':
                          setState(() {
                            widget.cardBrandIcon = FontAwesomeIcons.ccVisa;
                          });
                          break;
                        case 'master_card':
                          setState(() {
                            widget.cardBrandIcon = FontAwesomeIcons.ccMastercard;
                          });
                          break;
                        case 'american_express':
                          setState(() {
                            widget.cardBrandIcon = FontAwesomeIcons.ccAmex;
                          });
                          break;
                        case 'discover':
                          setState(() {
                            widget.cardBrandIcon = FontAwesomeIcons.ccDiscover;
                          });
                          break;
                        case '0':
                          setState(() {
                            widget.cardBrandIcon = FontAwesomeIcons.ccStripe;
                          });
                          break;
                      }
                      setState(() {
                        widget.cardNo = val;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Credit card number',
                      helperText: 'Card Number',
                      border: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(10.0),
                        ),
                      )
                    ),
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 18,
                    ),
                    inputFormatters: [
                      MaskedTextInputFormatter(
                        mask: 'xxxx-xxxx-xxxx-xxxx',
                        separator: '-',
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),


          Container(
            margin: EdgeInsets.all(15),
            child: Row(
              children: <Widget>[
                Container(
                    width: 50,
                    height: 50,
                    margin: EdgeInsets.only(right: 10),
                    child: Icon(Icons.person, size: 50,)
                ),

                Container(
                  width: 400,
                  height: 70,
                  margin: EdgeInsets.only(top: 20),
                  child: TextField(
                    cursorColor: Colors.black,
                    onChanged: (val){
                      setState(() {
                        widget.holder = val;
                      });
                    },
                    decoration: InputDecoration(
                        hintText: 'Card Holder',
                        helperText: 'Card Holder',
                        border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(10.0),
                          ),
                        )
                    ),
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 18,
                    ),
                  ),
                ),

              ],
            ),
          ),


          Container(
            margin: EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Container(
                          width: 50,
                          height: 50,
                          margin: EdgeInsets.only(right: 10),
                          child: Image.asset('assets/credit-card.png', )
                      ),

                      Container(
                        width: 100,
                        height: 70,
                        child: TextField(
                          maxLength: 5,
                          cursorColor: Colors.black,
                          onChanged: (val){
                            setState(() {
                              widget.exp = val;
                            });
                          },
                          decoration: InputDecoration(
                              hintText: '01/10',
                              helperText: 'Expiry Date',
                              border: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(10.0),
                                ),
                              )
                          ),
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 18,
                          ),
                          inputFormatters: [
                            MaskedTextInputFormatter(
                              mask: 'MM/YY',
                              separator: '/',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: FaIcon(widget.cardBrandIcon?? FontAwesomeIcons.ccStripe, size: 50,)
                ),

              ],
            ),
          ),



          Container(
            margin: EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Container(
                          width: 50,
                          height: 50,
                          margin: EdgeInsets.only(right: 10),
                          child: Image.asset('assets/credit-card-with-cvv-code.png', )
                      ),

                      Container(
                        width: 100,
                        height: 70,
                        child: TextField(
                          maxLength: 3,
                          cursorColor: Colors.black,
                          onChanged: (val){
                            setState(() {
                              widget.cvv = val;
                            });
                          },
                          decoration: InputDecoration(
                              hintText: '123',
                              helperText: 'cvv',
                              border: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(10.0),
                                ),
                              )
                          ),
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),


                Container(
                  width: 170,
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30)
                  ),
                  child: FlatButton.icon(
                    color: Colors.black,
                    onPressed: () async{
                      CreditCard stripeCard = CreditCard(
                        number: widget.cardNo,
                        expMonth: int.parse(widget.exp.substring(0, 2)),
                        expYear: int.parse(widget.exp.substring(3, 5)),
                      );
                      var response = await StripeService.payViaExistingCard(
                          amount: widget.amount,
                          currency: widget.currency,
                          card: stripeCard
                      );

                      if(response.success){
                        DatabaseService(uid: widget.userData.documentID).fundWallet(double.parse(widget.amount) + double.parse(widget.userData['walletBalance'].toString()));
                        DatabaseService(uid: widget.userData.documentID).addPaymantCard(cardNo: widget.cardNo.replaceAll('-', ''), cvv: widget.cvv.substring(0, 2)+"/"+widget.cvv.substring(2, 3), exp: widget.exp, holder: widget.holder);
                      }
                      widget.showScreen(Home(
                        showScreen: widget.showScreen, msg: response.success? "Successfully paid ${widget.amount}${widget.currency}": response.message, msgColor: response.success? Colors.greenAccent[100]: Colors.redAccent[100],
                      ));
                    },
                    splashColor: Colors.white,
                    icon: Icon(Icons.add, color: Colors.white,),
                    label: Text('Add Card',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w300,

                    ),),
                  ),
                )

              ],
            ),
          ),

        ],
      )
    );
  }
}
