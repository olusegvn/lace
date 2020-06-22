import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safh/Screens/viewProfile/viewProfile.dart';
import 'package:safh/Services/database.dart';

class OtherUserLinks extends StatefulWidget {
  String otherUserUid;
  DocumentSnapshot userData;
  OtherUserLinks({this.otherUserUid, this.userData});
  @override
  _OtherUserLinksState createState() => _OtherUserLinksState();
}

class _OtherUserLinksState extends State<OtherUserLinks> {
  @override
  Widget build(BuildContext context) {
    final databaseService = DatabaseService(uid: widget.otherUserUid);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Center(
        child: FutureBuilder(
          future: databaseService.getMyLinks(widget.otherUserUid),
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
                  onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => ViewProflle(fromQr: true, otherUserUid: users[index]['uid'], userData: widget.userData)));},
                  leading: Image.network(users[index]['profilePictureUrl']),
                    title:  Text(
                      User['displayName'],
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w300, fontSize: MediaQuery.of(context).size.width/23, letterSpacing: 2.0),
                    ),
                    subtitle: Text(
                      User['firstname']+' '+User['lastname'],
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w200, fontSize: MediaQuery.of(context).size.width/28, letterSpacing: 2),
                    ),

                ),
              );
            });
          },
        ),
      ),
    );
  }
}
