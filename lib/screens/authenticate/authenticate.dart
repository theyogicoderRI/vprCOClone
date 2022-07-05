import 'package:flutter/material.dart';
import 'package:vpr_co/screens/authenticate/signin.dart';
import 'package:vpr_co/screens/authenticate/register.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool? showSignIn = true;

  void toggleView() {
    setState(() {
      showSignIn =
          !showSignIn!; // this just reverses the value either true or false
      //will always do the opposite of what it is
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn!) {
      return SignIn(
          toggleView: toggleView); //has to be the same as the function name
    } else {
      return Register(toggleView: toggleView);
    }
  }
}
