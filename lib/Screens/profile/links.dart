import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safh/Screens/viewProfile/viewProfile.dart';
import 'package:safh/Services/database.dart';

class Links extends StatefulWidget {
  @override
  _LinksState createState() => _LinksState();
}

class _LinksState extends State<Links> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    final _userData = Provider.of<DocumentSnapshot>(context);
    final databaseService = DatabaseService(uid: user.uid);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Center(
        child: FutureBuilder(
          future: databaseService.getMyLinks(_userData.documentID),
          builder: (context, snapshot){
            List users = snapshot.data ?? [];

            return ListView.builder(itemCount: users.length,itemBuilder: (BuildContext context, int index) {
              dynamic User = users[index];
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
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w300, fontSize: MediaQuery.of(context).size.width/23, letterSpacing: 2.0),
                    ),
                    subtitle: Text(
                      User['firstname']+' '+User['lastname'],
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w200, fontSize: MediaQuery.of(context).size.width/28, letterSpacing: 2),
                    ),

                    trailing: ButtonTheme(
                        height: 50,
                        splashColor: Colors.black,
                        child: FlatButton.icon(onPressed: (){databaseService.addToLinks('remove', users[index]['uid']);setState(() {});}, icon: Icon(Icons.remove_circle, size: 30,), label: Text('')))

                ),
              );
            });
          },
        ),
      ),
    );
  }
}
