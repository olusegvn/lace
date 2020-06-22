import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:safh/Services/database.dart';
import 'package:safh/shared/laceInputField.dart';
import 'package:intl/intl.dart';


class MyTests extends StatefulWidget {
  String query;
  dynamic user;
  MyTests({this.query = '', this.user});
  @override
  _MyTestsState createState() => _MyTestsState();
}

class _MyTestsState extends State<MyTests> {
  @override
  Widget build(BuildContext context) {
    widget.user = Provider.of<FirebaseUser>(context);
    final _userData = Provider.of<DocumentSnapshot>(context);

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
                      onPressed: () {_showMyDialog(tests[index]['test'], tests[index]['resultImageUrl']);},
                      child: (Container(
                          height: 200,
                          margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width/15),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                      height: 50,
                                      padding: EdgeInsets.all(2),
                                      margin: EdgeInsets.all(20),
                                      child: FlatButton.icon(splashColor: Colors.black, onPressed: (){

                                        Alert(
                                          context: context,
                                          type: AlertType.warning,
                                          title: "Delete ?",
                                          desc: "Delete ${tests[index]['test']} test result?",
                                          buttons: [
                                            DialogButton(
                                              child: Text(
                                                "DELETE",
                                                style: TextStyle(color: Colors.white, fontSize: 20),
                                              ),
                                              onPressed: (){
                                                try {
                                                  DatabaseService(uid: widget.user.uid).deleteTestResult(tests[index].documentID);
                                                  Navigator.pop(context);
                                                  Scaffold.of(context).showSnackBar(SnackBar(content: Text("Successfully deleted test result"), duration: new Duration(seconds: 2),));
                                                  setState(() {});
                                                }catch(e){
                                                  print(e);
                                                  Navigator.pop(context);
                                                  Scaffold.of(context).showSnackBar(SnackBar(content: Text('Something went wrong.'), duration: new Duration(seconds: 2),));
                                                }

                                              },
                                              color: Colors.redAccent[200],
                                            ),
                                            DialogButton(
                                              child: Text(
                                                "CANCEL",
                                                style: TextStyle(color: Colors.white, fontSize: 20),
                                              ),
                                              onPressed: () => Navigator.pop(context),
                                              color: Colors.black,
                                            )
                                          ],
                                        ).show();

                                        }, icon: Icon(Icons.remove_circle, size: 30,), label: Text('')))

                                ],
                              ),

                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.only(
                                        left: 20, bottom: 10, top: 20),
                                    decoration: BoxDecoration(
                                        color: price == 0? Colors.blue[100]: Colors.red[100],
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
                                                DateFormat.yMMMd().format(DateTime.fromMicrosecondsSinceEpoch(int.parse(tests[index]['timestamp'] ?? '32456789087'))).toString(),
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
                                              price == 0? 'Free':
                                              tests[index]['price'].toString() +
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
                              ),
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
    return await DatabaseService(uid: widget.user.uid).getTestDocuments(widget.user.uid);
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
                Image.network(imgSrc)
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
                child: Text('Close',style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontSize: 15),),
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
