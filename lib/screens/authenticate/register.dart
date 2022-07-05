import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:vpr_co/services/auth.dart';
import 'package:vpr_co/shared/loading.dart';
import 'package:vpr_co/models/user.dart';

import 'package:vpr_co/services/colors.dart' as AppColors;

class Register extends StatefulWidget {
  final Function? toggleView;
  const Register({Key? key, this.toggleView}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<Register> {
  final _formKey = GlobalKey<FormState>(); //used to identify our form
  //text field state variables- to store what is typed in:
  String email = '';
  String password = '';
  String name = '';
  String error = '';
  String phone = '';
  String img = '';
  bool loading = false;

  final AuthService _auth = AuthService();
  AddUser? myUser = AddUser();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    final userAuthEmail = _auth.getEmail.toString();

    Future<void> addUser() {
      // Call the user's CollectionReference to add a new user
      final emailTrimmed = _emailController.text.trim();
      print("the email trimmed is passed as : $emailTrimmed");
      return users
          .add({
            'email': emailTrimmed, // John Doe
            'phoneNumber': _phoneController.text, // Stokes and Sons
            'picture': '', //so picture is null to start
          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }

    return loading
        ? const Loading()
        : Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              backgroundColor: Colors.brown[400],
              elevation: 0.0,
              title: const Text("Sign up"),
            ),
            body: SingleChildScrollView(
              child: Form(
                key: _formKey,
                //_formKey will allow us to do form validation and keep track of state of form
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 2),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 1),
                      child: TextFormField(
                        onChanged: (val) {
                          setState(() {
                            //to capture whatever the user enters into the form field
                            name = val;
                          });
                        },
                        decoration: const InputDecoration(
                          icon: Icon(Icons.person),
                          hintText: 'enter name to use for this app',
                          labelText: 'nickname',
                          fillColor: Colors.white24,
                          filled: true,
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Name field is empty';
                          }

                          // ApplicationState().verifyEmail(value);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 1),
                      child: TextFormField(
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(
                              new RegExp(r"\s\b|\b\s"))
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
                          inputFormatters:
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
                          horizontal: 20, vertical: 1),
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
                              return "password must be at least 8 characters";
                            }
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 1),
                      child: TextFormField(
                        keyboardType: TextInputType.phone,
                        autocorrect: false,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(10),
                        ],
                        controller: _phoneController,
                        onChanged: (val) {
                          setState(() {
                            //to capture whatever the user enters into the form field
                            phone = val;
                          });
                        },
                        decoration: const InputDecoration(
                          icon: Icon(Icons.phone),
                          hintText: 'enter phone number',
                          labelText: 'phone',
                          fillColor: Colors.white24,
                          filled: true,
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'phone field is empty';
                          }

                          // ApplicationState().verifyEmail(value);
                        },
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          Navigator.pushNamed(context, '/signIn');
                        });

                        print("Register");
                      },
                      child: const Text("Sign In",
                          style: TextStyle(
                              fontSize: 12, fontStyle: FontStyle.italic)),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          style:
                          ElevatedButton.styleFrom(
                            primary: AppColors.appPurple, // background
                            onPrimary: Colors.white, // foreground
                          );
                          if (_formKey.currentState!.validate()) {
                            dynamic result = await _auth.registerForApp(
                                name,
                                email,
                                password); // this adds the user to Firebase Auth
                            myUser!.phoneNumber = _phoneController.text;

                            addUser(); // Here is where we add user to Firebase Firestore
                            print("YOUR EMAIL IS $userAuthEmail");
                            print(
                                "YOUR PHONE NUMBER IS : ${_phoneController.text}");

                            setState(() {
                              loading = true;
                            });
                            Navigator.pushNamed(context, '/signIn');

                            if (result == null) {
                              setState(() {
                                error = 'Registration did not work';
                                loading = false;
                              });
                            } // no else clause needed, because if they register they will be
                          }

                          // }
                        },
                        child: const Text('Register'),
                      ),
                    ),
                    // ),
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
            ),
          );
  }
}
