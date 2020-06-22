import 'package:flutter/material.dart';
import 'package:credit_card_validate/credit_card_validate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LaceSavedCreditCard extends StatefulWidget {
  String cardNumber;
  String expiryDate;
  String cardHolderName;
  String cvvCode;
  Function removeCardCallback;
  LaceSavedCreditCard({this.cardHolderName, this.cardNumber, this.cvvCode, this.expiryDate, this.removeCardCallback});
  @override
  _LaceSavedCreditCardState createState() => _LaceSavedCreditCardState();
}

class _LaceSavedCreditCardState extends State<LaceSavedCreditCard> {
  @override
  Widget build(BuildContext context) {
    IconData brandIcon;
    switch(CreditCardValidator.identifyCardBrand(widget.cardNumber)){
      case 'visa':
        brandIcon = FontAwesomeIcons.ccVisa;
        break;
      case 'master_card':
        brandIcon = FontAwesomeIcons.ccMastercard;
        break;
      case 'american_express':
        brandIcon = FontAwesomeIcons.ccAmex;
        break;
      case 'discover':
        brandIcon = FontAwesomeIcons.ccDiscover;
        break;
    }
    String c = widget.cardNumber;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment(0.5, 0.8), // 10% of the width, so there are ten blinds.
          colors: [Color.fromRGBO(0, 0, 8, 0.95), Colors.grey[300]], // whitish to gray
          tileMode: TileMode.mirror, // repeats the gradient over the canvas
        ),
      ),
      height: 200,
      width: 500,
      child: Row(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(25),
                child: Text(c.substring(0, 4)+' '+c.substring(4, 8)+' '+c.substring(8, 12)+' '+c.substring(12, 16)+' '+"\n\n"+widget.cardHolderName+"\n\n"+widget.expiryDate,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  letterSpacing: 3.0,
                  fontWeight: FontWeight.w300,
                ),),
              ),
            ],
          ),
        Container(
          margin: EdgeInsets.only(left: 50),
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FaIcon(brandIcon, size: 50,),
              ButtonTheme(
                minWidth: 40,
                height: 80,
                child: FlatButton(
                  onPressed: (){widget.removeCardCallback();},
                  splashColor: Colors.white, // inkwell color
                  child: Icon(Icons.remove_circle, color: Color.fromRGBO(0, 0, 0, 0.8), size: 40,),
                ),
              )
            ],
          ),
        )
        ],
      ),
    );
  }
}

