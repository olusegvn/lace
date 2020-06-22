import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:safh/Services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<FirebaseUser> get user{
    return _auth.onAuthStateChanged;
  }

  Future signInUserWithEmailAndPassword(String email, String password) async{
    try{
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return result.user;
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  Future registerUserWithEmailAndPassword(String firstname, String lastname, String email, String phoneNo, String password) async{
    try{
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await DatabaseService(uid: result.user.uid).updateUserData(firstname, lastname, email, phoneNo, password);
      return result.user;
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future signOut() async {
    try{
      return await _auth.signOut();
    }catch (e){print(e.toString()); return null;}
  }

}