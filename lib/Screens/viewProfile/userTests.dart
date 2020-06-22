import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:safh/Services/database.dart';
import 'package:safh/shared/laceInputField.dart';
import 'package:intl/intl.dart';


class UserTests extends StatefulWidget {
  String query;
  dynamic otherUserUid;
  DocumentSnapshot userData;
  bool fromQr;
  UserTests({this.query = '', this.otherUserUid, this.fromQr,this.userData});
  @override
  _UserTestsState createState() => _UserTestsState();
}

class _UserTestsState extends State<UserTests> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.3,
          leading: Container(child: Icon(Icons.search, color: Colors.black38,size: 40,)),
          title: LaceInputField(
            padding: EdgeInsets.symmetric(horizontal: 15),
            margin: EdgeInsets.only( right: 50),
            label: "Search Test",
            callback: (val)=> (setState(() {
              widget.query = val;
            })
            )),
      ),
      
      body: Container(
        color: Colors.white70,
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/25),
        child: Center(
          child: FutureBuilder<List>(
            future: getDocuments(),
            builder: (context, snapshot) {
              List tests = snapshot.data ?? [];
              return ListView.builder(
                itemCount: tests.length,
                  itemBuilder: (BuildContext context, int index) {
                  var price = tests[index]['price'];
                  if(tests[index]['test'].toString().toLowerCase().contains(widget.query.trim()) || widget.query.trim()=='') {
                    return FlatButton(
                      splashColor: Colors.redAccent,
                      onPressed: () async{
                        if (tests[index]['price'] == 0|| await DatabaseService(uid: widget.userData.documentID).confirmUserPayment(tests[index].documentID) || (widget.fromQr && await DatabaseService(uid: widget.userData.documentID).confirmPrivilegedUser())  ) {
                        _showMyDialog(tests[index]['test'], tests[index]['resultImageUrl']);}
                        else{
                          Alert(
                            context: context,
                            type: AlertType.warning,
                            title: "PAY ?",
                            desc: "pay ${tests[index]['price']} to view result ?",
                            buttons: [
                              DialogButton(
                                child: Text(
                                  "PAY",
                                  style: TextStyle(color: Colors.white, fontSize: 20),
                                ),
                                onPressed: (){
                                  double balance = widget.userData['walletBalance'];
                                  double price = double.parse(tests[index]['price'].toString());
                                  if(balance>price){
                                    try {
                                      DatabaseService(uid: widget.userData.documentID)
                                          .updateWallet(amount: balance - price, userCut: price-(0.05*price), laceCut: 0.05*price, otherUserUid: tests[index]['uid']);
                                      DatabaseService(uid: widget.userData.documentID)
                                          .addToPaidUsersFor(tests[index].documentID);
                                      Navigator.pop(context);
                                      Scaffold.of(context).showSnackBar(SnackBar(content: Text("Payment Successful, Please tap test to view."), duration: new Duration(seconds: 2),));
                                    }catch(e){
                                      Navigator.pop(context);
                                      Scaffold.of(context).showSnackBar(SnackBar(content: Text(e.toString()), duration: new Duration(seconds: 2),));
                                    }
                                  }else{
                                    Navigator.pop(context);
                                    Scaffold.of(context).showSnackBar(SnackBar(content: Text('Insufficient Funds, Please fund wallet.'), duration: new Duration(seconds: 2),));
                                  }

                                },
                                color: Colors.greenAccent[200],
                              ),
                              DialogButton(
                                child: Text(
                                  "CANCEL",
                                  style: TextStyle(color: Colors.white, fontSize: 20),
                                ),
                                onPressed: () => Navigator.pop(context),
                                gradient: LinearGradient(colors: [
                                  Colors.black,
                                  Colors.white
                                ]),
                              )
                            ],
                          ).show();

                        }},
                      child: (Container(
                          height: 200,
                          margin: EdgeInsets.symmetric(vertical: 30),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(top: BorderSide(
                                color: Colors.black54),
                                bottom: BorderSide(
                                    color: Colors.black54),
                                left: BorderSide(color: Colors.black54),
                                right: BorderSide(
                                    color: Colors.black54)),
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(image: NetworkImage(
                                tests[index]['resultImageUrl']),
                              fit: BoxFit.cover,
                              colorFilter: new ColorFilter.mode(
                                  Colors.white.withOpacity(0.4),
                                  BlendMode.dstATop),),

                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(
                                    left: 20, bottom: 10, top: 20),
                                decoration: BoxDecoration(
                                    color: price == 0?Colors.blue[100]: Colors.red[100],
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10))),
                                child: Row(
                                  children: <Widget>[
                                    Icon(price == 0? Icons.lock_open: Icons.lock, size: 30,
                                      color: Colors.black54,),
                                    Expanded(
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                            tests[index]['test']+" ",
                                            style: TextStyle(
                                              fontSize: MediaQuery.of(context).size.width/12,
                                              fontWeight: FontWeight.w200,
                                            ),
                                          ),
                                          Text(
                                            DateFormat.yMMMd().format(DateTime.fromMicrosecondsSinceEpoch(int.parse(tests[index]['timestamp']?? '230290930239023'))).toString(),
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w200,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: price == 0? Colors.blueAccent[200]: Colors.redAccent[200],
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(3),
                                              bottomLeft: Radius.circular(3))
                                      ),
                                      child: Center(
                                        child: Text(
                                          price == 0?"Free":
                                          price.toString() +
                                              " " + tests[index]['currency'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.w200,
                                            fontSize: 21,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),)
                                  ],
                                ),
                              )
                            ],
                          )
                      )),
                    );
                  }return null;
                  }
              );
            }
          ),
        ),
      ),
    );
  }

  Future<List> getDocuments() async{
    return await DatabaseService().getTestDocuments(widget.otherUserUid);
  }


  Future<void> _showMyDialog(String title, String imgSrc) async {

      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              title,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w300,
              ),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  FlatButton(splashColor: Colors.black, onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Scaffold(body: Container(color: Colors.white, child: PhotoView(imageProvider: NetworkImage(imgSrc)),))),
                    );
                  }, child: Image.network(imgSrc))
                ],
              ),
            ),
            actions: <Widget>[
              ButtonTheme(
                minWidth: 120,
                height: 50,
                splashColor: Colors.white,
                child: FlatButton(
                  color: Colors.black,
                  child: Text('Close', style: TextStyle(color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: 15),),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          );
        },
      );
    }
  }


