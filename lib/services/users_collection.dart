import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vpr_co/services/auth.dart';
import 'package:flutter/material.dart';

///I AM NOT USING THIS MODULE///////////////////
///

class UsersHelper {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('users').snapshots();
  final AuthService _auth = AuthService();

  var userMap = {'gettingUserEmail': '', 'username': '', 'picture': ''};
  var userName1;
  var userPicture;

  Future setCurrentID() async {
    var collectionStreamEMAIL = FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (doc["email"] == _auth.getEmail) {
          userMap['gettingUserEmail'] =
              doc["email"]; //sets the email of the user to this variable
          userMap['picture'] = doc['picture'];
          // currentFSDOCID = doc.id; //sets the id of the file o this variable
          userMap['username'] = _auth.getDisplayName!;

          // userName1 = _auth.getDisplayName!;
          // userPicture = doc['picture'];
          // print(
          //     "YOU HAVE REACHED THE USERS HELPER  EMAIL IS: ${userMap['gettingUserEmail']}");

        }
      });
    });
    return userName1;
  }

  Future<String> getUserName() async {
    var collectionStreamEMAIL = FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (doc["email"] == _auth.getEmail) {
          userName1 = _auth.getDisplayName!;
          print("USERNAME BEFORE $userName1 ");

          print("USERNAME AFTER $userName1 ");
          return userName1;
        }
      });
    });

    return await userName1;
  }

  Future<String> getUserPicture() async {
    var collectionStreamEMAIL = FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (doc["email"] == _auth.getEmail) {
          // userMap['gettingUserEmail'] =
          // doc["email"]; //sets the email of the user to this variable
          // userMap['picture'] = doc['picture'];
          // // currentFSDOCID = doc.id; //sets the id of the file o this variable
          // userMap['username'] = _auth.getDisplayName!;
          userPicture = doc['picture'];

          return userPicture;
          // print(
          //     "YOU HAVE REACHED THE USERS HELPER  EMAIL IS: ${userMap['gettingUserEmail']}");

        }
      });
    });

    return await userPicture;
  }

  Future<void> updateUserPhone(String phoneNumber, String id) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('Document exists on the database');

        return users
            .doc(id)
            .update({'phoneNumber': phoneNumber})
            .then((value) => print("Phone Number updated"))
            .catchError(
                (error) => print("Failed to update Phone number: $error"));
      } else {
        print("");
      }
    });
    return fakeReturnFunction();
  }

  Future fakeReturnFunction() async {
    print("Fake function");
  }
}
