import 'package:flutter/material.dart';
import 'package:vpr_co/screens/authenticate/signin.dart';
import 'package:vpr_co/services/auth.dart';
import 'package:vpr_co/shared/loading.dart';
import 'package:vpr_co/services/colors.dart' as AppColors;

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  //text field state variables- to store what is typed in:
  String email = '';
  String password = '';
  String error = '';
  bool loading = false;

  final fieldText = TextEditingController();

  void clearText() {
    fieldText.clear();
  }

  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.appClay,
              elevation: 0.0,
              title: const Text("Reset Password"),
            ),
            body: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 1),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: TextFormField(
                      controller: fieldText,
                      onChanged: (val) {
                        setState(() {
                          //to capture whatever the user enters into the form field
                          email = val;
                          error = '';
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
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: AppColors.appPurple, // background
                        onPrimary: Colors.white, // foreground
                      ),
                      onPressed: () async {
                        dynamic emailInUse =
                            await _auth.checkIfEmailInUse(email);
                        print(emailInUse);
                        if (emailInUse) {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              loading = true;
                            });

                            await _auth.resetPassword(email);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return const SignIn();
                              }),
                            );
                          }
                        } else {
                          setState(() {
                            error = 'please enter your email address';
                            _formKey.currentState!.reset();
                            clearText();
                            loading = false;
                          });
                        }
                      },
                      child: const Text('Submit'),
                    ),
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
