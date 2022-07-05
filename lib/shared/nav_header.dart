import 'package:flutter/material.dart';
import 'package:vpr_co/services/auth.dart';
// import 'package:just_fb_auth/services/users_collection.dart';
// import 'package:provider/provider.dart';

class NavHeaderWidget extends StatelessWidget {
  const NavHeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final AuthService _auth = AuthService();
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double getWidth = MediaQuery.of(context).devicePixelRatio.toDouble();

    return Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Padding(
          //   padding: EdgeInsets.fromLTRB(5, 20, 5, 5),
          //   child: getWidth < 40
          //       ? Text(
          //           "${_auth.getDisplayName}",
          //           style: TextStyle(
          //               fontSize: 9,
          //               color: Colors.amber,
          //               fontWeight: FontWeight.w500,
          //               fontStyle: FontStyle.italic),
          //         )
          //       : Text(
          //           "Hi: ${_auth.getDisplayName}",
          //           style: TextStyle(fontSize: 20),
          //         ),
          // ),
          //
          // Padding(
          //   padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
          //   child: getWidth < 40
          //       ? Text(
          //           "VPR-CO",
          //           style: TextStyle(
          //               fontSize: 9,
          //               color: Colors.amber,
          //               fontWeight: FontWeight.w400,
          //               fontStyle: FontStyle.normal),
          //         )
          //       : Text(
          //           "Hi: ${_auth.getDisplayName}",
          //           style: TextStyle(fontSize: 20),
          //         ),
          // ),

          // Padding(
          //   padding: const EdgeInsets.fromLTRB(1, 10, 1, 1),
          //   child: ClipRRect(
          //     clipBehavior: Clip.antiAlias,
          //     borderRadius: BorderRadius.circular(40.0),
          //     child: Image.network(
          //         // 'https://firebasestorage.googleapis.com/v0/b/yoganandawidsom.appspot.com/o/TEST%2F2014-11-19%2019.31.10.jpg?alt=media&token=b07b8746-4e13-43f6-aab5-9b2de392408e',
          //         usersProfile.userPicture,
          //         height: 10,
          //         width: 10),
          //   ),
          // ),
          const SizedBox(
            height: 2,
          ),
          // Center(
          //   child: _auth.getDisplayName != null
          //       ? Text(" ${_auth.getDisplayName}  ",
          //           style: const TextStyle(
          //               color: Colors.black54,
          //               fontSize: 15,
          //               fontWeight: FontWeight.bold))
          //       : const Text(
          //           "",
          //         ),
          // ),
        ]);
  }
}
