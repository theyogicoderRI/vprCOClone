import 'package:firebase_auth/firebase_auth.dart';
import 'package:vpr_co/models/user.dart';

class AuthService {
  ///methods that will interact with firebase auth
  // create instance of firebase authentication to communicate with firebase auth

  final FirebaseAuth _auth = FirebaseAuth
      .instance; //this creates the firebase auth instance for us to use

  //Check is user is logged in- THIS IS MINE- MAY NOT BE FULLY BAKED
  Future<bool> isUserLoggedIn() async {
    var user = _auth.currentUser;
    return user != null;
  }

  //create user object based on FireBase user
  MyUser? _userFromFirebaseUser(User? user) {
    return user != null ? MyUser(uid: user.uid) : null;
  }

  //auth change user stream
//everytime the user signs in or signs out we will get some kind of response
  //we pipe this to our custom object
  Stream<MyUser?> get userStream {
    return _auth.authStateChanges().map((user) => _userFromFirebaseUser(user));
  }

  //Display user name getter
  String? get getDisplayName {
    User? user = _auth.currentUser;
    if (user != null) {
      return user.displayName;
    } else {
      return null;
    }
  }

  String? get getEmail {
    User? user = _auth.currentUser;
    if (user != null) {
      return user.email;
    } else {
      return null;
    }
  }

  Future signInAnon() async {
    try {
      UserCredential result = await _auth
          .signInAnonymously(); //he had of type AuthResult, but flutter could not find that
      User? user = result.user;

      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign in with email and password
  Future signInWithEmailAndPassword({
    String? email,
    String? password,
  }) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email!, password: password!);
      //he had of type AuthResult, but flutter could not find that
      User? user = result.user;

      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //register with email and password
  Future registerForApp(String name, String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email,
          password:
              password); //he had of type AuthResult, but flutter could not find that
      await result.user!
          .updateDisplayName(name); //how we can also add users name
      User? user = result.user;
      print(user!.displayName);
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign out
  Future signOut() async {
    try {
      // print("am I signing out?");
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future deleteUser(String email, String password) async {
    try {
      // Create a credential
      AuthCredential credential =
          EmailAuthProvider.credential(email: email, password: password);
      await FirebaseAuth.instance.currentUser!
          .reauthenticateWithCredential(credential);
      User? user = _auth.currentUser;
      print(user);
      if (user != null) {
        return user.delete();
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future resetPassword(String emailAddress) async {
    final list = await _auth.fetchSignInMethodsForEmail(emailAddress);
    try {
      if (list.isNotEmpty) {
        return _auth.sendPasswordResetEmail(email: emailAddress);
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<bool> checkIfEmailInUse(String emailAddress) async {
    try {
      // Fetch sign-in methods for the email address
      final list =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(emailAddress);

      // In case list is not empty
      if (list.isNotEmpty) {
        // Return true because there is an existing
        // user using the email address
        return true;
      } else {
        // Return false because email adress is not in use
        return false;
      }
    } catch (e) {
      print(e.toString());
      return true;
    }
  }
}
