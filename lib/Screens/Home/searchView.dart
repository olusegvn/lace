import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safh/Screens/viewProfile/viewProfile.dart';
import 'package:safh/Services/database.dart';


class SearchView extends StatefulWidget {
  String searchValue;
  final Function callback;
  BuildContext context;
  SearchView({this.searchValue, this.callback, this.context});
  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    final _userData = Provider.of<DocumentSnapshot>(context);
    final databaseService = DatabaseService(uid: user.uid);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
              '"'+widget.searchValue+'"',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w200,
              color: Colors.black,
            ),
          ),
        ),

        actions: <Widget>[
          FlatButton.icon(
            splashColor: Colors.black,
              onPressed: (){widget.callback();}, icon: Icon(Icons.clear), label: Text(""))
          
        ],
      ),

      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: FutureBuilder(
            future: databaseService.getUsers(widget.searchValue),
            builder: (context, snapshot){
              List users = snapshot.data ?? [];

              return ListView.builder(itemCount: users.length,itemBuilder: (BuildContext context, int index) {
                var User = users[index];
                return Container(
                  height: 100,
                  margin: EdgeInsets.only(top: 40),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black54)
                  ),
                  child: ListTile(
                    onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => ViewProflle(fromQr: true, otherUserUid: users[index]['uid'], userData: _userData)));},
                    leading: Image.network(users[index]['profilePictureUrl']),
                    title:  Text(
                          User['displayName'],
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w300, fontSize: 25, letterSpacing: 2.0),
                        ),
                    subtitle: Text(
                      User['firstname']+' '+User['lastname'],
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w200, fontSize: 20, letterSpacing: 2),
                    ),

                    trailing: ButtonTheme(
                        height: 50,
                        splashColor: Colors.black,
                        child: FlatButton.icon(onPressed: (){databaseService.addToLinks('add', User['uid']);}, icon: Icon(Icons.person_add, size: 30,), label: Text('')))

                  ),
                );
              });
            },
          ),
        ),
      ),
    );
  }
}

