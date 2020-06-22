import 'dart:io';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:safh/Services/Auth.dart';

class DatabaseService{

  final String uid;
  final String otherUserUid;
  DatabaseService({ this.uid, this.otherUserUid });
  final CollectionReference userCollection = Firestore.instance.collection('User');
  final CollectionReference testCollection = Firestore.instance.collection('Tests');
  final CollectionReference withdrawCollection = Firestore.instance.collection('Withdrawals');
  final CollectionReference privilegedUserCollection = Firestore.instance.collection('Privileged User');

  Future updateUserData(String firstname, String lastname, String email, String phoneNo, String password) async {
    return await userCollection.document(uid).setData({
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'phoneNo': phoneNo,
      'password': password,
      'uid': uid,
      'walletBalance': 0.00
    });
  }

  Future updateProfile(String displayName, File profilePicture) async {
    try{
    final StorageReference storageReference = FirebaseStorage.instance.ref().child("User/"+uid);
    final StorageUploadTask task = storageReference.putFile(profilePicture);
    dynamic downloadUrl =  await storageReference.getDownloadURL();
    return await userCollection.document(uid).setData({
      'displayName': displayName,
      'profilePictureUrl': downloadUrl,
    }, merge: true);
    }catch(e){print(e);return false;}
  }

  Future uploadTestResult(File resultImage, String test, String currency, double price) async{
    try{
      final StorageReference storageReferenceResultImage = FirebaseStorage.instance.ref().child("Results/$uid/$test Test Result");
  //    final StorageReference storageReferenceConfirmImage = FirebaseStorage.instance.ref().child("ConfirmImages/$uid/$test Confirm Image");
      storageReferenceResultImage.putFile(resultImage);
  //    storageReferenceConfirmImage.putFile(confirmImage);
      dynamic resultDownloadUrl =  await storageReferenceResultImage.getDownloadURL();
  //    dynamic confirmImageDownloadUrl =  await storageReferenceConfirmImage.getDownloadURL();

      return await testCollection.document().setData({
        'test': test,
        'uid': uid,
        'price': price,
        'currency': currency,
        'resultImageUrl': resultDownloadUrl,
        'timestamp': DateTime.now().millisecondsSinceEpoch.toString()
  //      'confirmImageUrl': confirmImageDownloadUrl
      });

    }catch(e){return false;}
  }

  Future updateWallet({double amount, double userCut, double laceCut, String otherUserUid}) async{
    try{
      double laceAmount;
      double userAmount;
      await userCollection.document('LACE').get().then((document) => {
        laceAmount = document['walletBalance']
      });
      await userCollection.document(otherUserUid).get().then((document) => {
        userAmount = document['walletBalance']
      });
      await userCollection.document(uid).setData({
        'walletBalance': amount,
      }, merge: true);

      await userCollection.document('LACE').setData({
        'walletBalance': laceAmount + laceCut,
      }, merge: true);
      await userCollection.document(otherUserUid).setData({
        'walletBalance': userAmount + userCut,
      }, merge: true);

    }catch(e){return false;}
  }

  Future fundWallet(double amount) async{
    print('\n\n\n\n\n$amount');
    await userCollection.document(uid).setData({
      'walletBalance': amount,
    }, merge: true);
  }

  Future deleteCardDetails(documentID){
    userCollection.document(uid)
        .collection("cards").document(documentID)
        .delete();
  }

  Future deleteTestResult(documentID){
    testCollection.document(documentID).delete();
  }

  Future confirmPrivilegedUser() async{
    DocumentSnapshot ds = await privilegedUserCollection.document(uid).get();
    return ds.exists;
  }

  Future addPaymantCard({String cardNo, String cvv, String exp, String holder}) async{
    return await userCollection.document(uid).collection('cards').document(cardNo).setData({
      'cardNo': cardNo,
      'cvv': cvv,
      'exp': exp,
      'holder': holder,
      //      'confirmImageUrl': confirmImageDownloadUrl
    });
  }

  Future resetPassword(String newPassword, String email) async{
    try {
        AuthService().sendPasswordResetEmail(email);
      return await userCollection.document(uid).setData({
        'password': newPassword,
      }, merge: true);
    }catch(e){
      print(e.toString());
      return null;
    }

  }

  Future<List<DocumentSnapshot>> getTestDocuments(userUid) async{
    QuerySnapshot querySnapshot = await testCollection.where('uid', isEqualTo: userUid).getDocuments();
    return querySnapshot.documents;
  }

  Future requestWithdrawal(String amount, String currency) async{
    try{
      return await withdrawCollection.document(uid).setData({
        'amount': amount,
        'currency': currency,
        'timestamp': DateTime.now().millisecondsSinceEpoch
      });
    }
    catch(e){
      return null;
    }
  }

  Future confirmUserPayment(String documentUid) async{
    QuerySnapshot querySnapshot = await testCollection.where('paidUsers', arrayContains: uid).getDocuments();
    bool rtn = false;
    querySnapshot.documents.forEach((DocumentSnapshot snap) {
      print('userId ${snap.documentID}');
      print(documentUid);
      if (snap.documentID == documentUid){
        rtn = true;
      }
    });
    return rtn;
  }

  Future getUserByQrCode() async{
    try{
    var barcode = await BarcodeScanner.scan();
    print('code\n\n\n\n\n${barcode.rawContent}');
    return await userCollection.document(barcode.rawContent.toString()).get();
    }catch(e){
      return false;
    }
  }

  Future getOtherUserData() async{
    QuerySnapshot querySnapshot = await userCollection.where('uid', isEqualTo: otherUserUid).getDocuments();
    return querySnapshot.documents;
  }

  Future<List<Map<String, dynamic>>> getUsers(String query) async{
    return (await userCollection.where("displayName", isGreaterThanOrEqualTo: query).getDocuments()).documents.map((e) => e.data).toList();
  }

  Future addToLinks(String command, String userUid) async{
    var list = List<String>();
    list.add(uid);
    print("userUid: $userUid");
    if(command == 'remove')
      userCollection.document(userUid).updateData({"links": FieldValue.arrayRemove(list)});
    else if(command=='add')
      userCollection.document(userUid).updateData({"links": FieldValue.arrayUnion(list)});
  }

  Future addToPaidUsersFor(String documentID) async{
    var list = List<String>();
    list.add(uid);
    testCollection.document(documentID).updateData({"paidUsers": FieldValue.arrayUnion(list)});
  }

  Future getCardDocuments() async{
    QuerySnapshot querySnapshot = await userCollection.document(uid).collection('cards').getDocuments();
    print(querySnapshot.documents);
    return querySnapshot.documents;
  }


  Future getMyLinks(String userUid) async{
    return (await userCollection.where('links', arrayContains: userUid).getDocuments()).documents.map((e) => e.data).toList();
  }


  Stream<QuerySnapshot> get users {
    return userCollection.snapshots();
  }

  Stream<DocumentSnapshot> get userData{
    return userCollection.document(this.uid).snapshots();
  }


}
