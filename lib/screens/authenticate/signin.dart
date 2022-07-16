import 'package:flutter/material.dart';

import 'package:vpr_co/services/auth.dart';
import 'forgot_password.dart';
import 'package:vpr_co/shared/loading.dart';

import 'package:flutter/services.dart';
import 'package:vpr_co/services/colors.dart' as AppColors;

class SignIn extends StatefulWidget {
  final Function? toggleView;
  const SignIn({Key? key, this.toggleView}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final fieldText = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _formKeyDeleteAccount = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _emailReController = TextEditingController();
  final TextEditingController _passwordReController = TextEditingController();
  //text field state variables- to store what is typed in:
  String email = '';
  String password = '';
  String error = '';
  bool loading = false;
  String reEmail = '';
  String rePassword = '';

  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: AppColors.appClay,
              elevation: 0.0,
              title: const Text("Sign In"),
            ),
            body: Form(
              key: _formKey,
              //Form will allow us to do form validation
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 1),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: TextFormField(
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(r"\s\b|\b\s"))
                      ],
                      controller: _emailController,
                      onChanged: (val) {
                        setState(() {
                          //to capture whatever the user enters into the form field
                          email = val;
                        });
                      },
                      decoration: const InputDecoration(
                        icon: Icon(Icons.mail),
                        hintText: 'enter email',
                        labelText: 'email',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'email field is empty';
                        }
                        if (!value.contains('@')) {
                          return "your email has no: @";
                        }
                        if (!RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                        ).hasMatch(value)) {
                          return "Your email is not valid";
                        }
                        // ApplicationState().verifyEmail(value);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: TextFormField(
                        onChanged: (val) {
                          setState(() {
                            //to capture whatever the user enters into the form field
                            password = val;
                          });
                        },
                        obscureText: true,
                        obscuringCharacter: '*',
                        decoration: const InputDecoration(
                          icon: Icon(Icons.password),
                          hintText: 'enter password',
                          labelText: 'password',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'password field is empty';
                          }
                          if (value.length < 8) {
                            return "your password is not complete";
                          }
                        }),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return const ForgotPassword();
                                }),
                              );
                            });
                          },
                          child: const Text("Forgot Password?",
                              style: TextStyle(
                                  fontSize: 12, fontStyle: FontStyle.italic)),
                        ),
                      ),
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              Navigator.pushNamed(context, '/register');
                            });
                          },
                          child: const Text(" Need to Register?",
                              style: TextStyle(
                                  fontSize: 12, fontStyle: FontStyle.italic)),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: AppColors.appPurple, // background
                        onPrimary: Colors.white, // foreground
                      ),
                      onPressed: () async {
                        ///START RIGHT HERE WITH NEW CODE
                        dynamic emailInUse =
                            await _auth.checkIfEmailInUse(email);

                        if (emailInUse) {
                          if (_formKey.currentState!.validate()) {
                            await _auth.signInWithEmailAndPassword(
                                email: email, password: password);
                            setState(() {
                              loading = true;
                            });
                            Navigator.pushNamed(context, '/sideNav');
                            // Navigator.push(context,
                            //     MaterialPageRoute(builder: (context) {
                            //   return const SideNav();
                            // }));
                          }
                        } else {
                          setState(() {
                            error = 'please enter your email address';
                            _formKey.currentState!.reset();
                            loading = false;
                          });
                        }
                      },
                      child: const Text('Submit'),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      print(_auth.getDisplayName);
                      print(_auth.getEmail);
                      print(_auth.isUserLoggedIn());

                      // Navigator.pushNamed(context, '/register');

                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              insetPadding: EdgeInsets.symmetric(
                                horizontal: 50.0,
                                vertical: 50.0,
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0))),
                              elevation: 6.0,
                              title: const Text(
                                'Delete Your Account?',
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 18),
                                textAlign: TextAlign.center,
                              ),
                              content: Form(
                                key: _formKeyDeleteAccount,
                                child: SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      Divider(
                                        color: Colors.grey,
                                        height: 0.0,
                                      ),
                                      SizedBox(height: 8),
                                      const Text(
                                        'Re-enter your credentials to proceed',
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 14),
                                        textAlign: TextAlign.center,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: TextFormField(
                                          controller: _emailReController,
                                          decoration: const InputDecoration(
                                            icon: Icon(Icons.verified_user),
                                            hintText: 'Enter Email',
                                            labelText: 'email',
                                            fillColor: Colors.white24,
                                            filled: true,
                                            // border: OutlineInputBorder(),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: TextFormField(
                                          obscureText: true,
                                          controller: _passwordReController,
                                          decoration: const InputDecoration(
                                            icon: Icon(Icons.password),
                                            hintText: 'Enter Password',
                                            labelText: 'password',
                                            fillColor: Colors.white24,
                                            filled: true,
                                            // border: OutlineInputBorder(),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 6.0),
                                      Icon(
                                        Icons.crisis_alert,
                                        color: Colors.red,
                                        size: 40.0,
                                      ),
                                      SizedBox(height: 8.0),
                                      Center(
                                        child: Text(
                                          'Your account will be permanently deleted',
                                          style:
                                              TextStyle(color: Colors.black87),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Yes, Delete'),
                                  onPressed: () {
                                    setState(() {
                                      reEmail = _emailReController.text;
                                      rePassword = _passwordReController.text;
                                      _auth.deleteUser(reEmail, rePassword);
                                    });

                                    Navigator.of(context).pop();

                                    const snackBar = SnackBar(
                                      content: Text('Account Is Deleted'),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  },
                                ),
                              ],
                            );
                          });
                    },
                    child: const Text("Delete Account",
                        style: TextStyle(
                            fontSize: 14, fontStyle: FontStyle.normal)),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    error,
                    style: const TextStyle(
                        color: Colors.red,
                        fontSize: 12), // this will show error on screen
                    //if register fails
                  ),
                ],
              ),
            ),
          );
  }
}
