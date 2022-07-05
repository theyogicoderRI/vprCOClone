import 'package:flutter/material.dart';
import 'package:vpr_co/models/user.dart';
import 'package:vpr_co/screens/authenticate/authenticate.dart';
import 'package:vpr_co/screens/home/home.dart';
import 'package:provider/provider.dart';
import 'side_nav.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //return either home or authenticate widget
    final user = Provider.of<MyUser?>(context);
    if (user == null) {
      return const Authenticate();
    } else {
      // print(user!.uid);
      return const SideNav();
    }
  }
}
