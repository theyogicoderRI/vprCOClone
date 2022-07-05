import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vpr_co/screens/authenticate/signin.dart';
import 'package:vpr_co/screens/inventory_practice.dart';
import 'package:vpr_co/screens/user_profile.dart';
import 'package:vpr_co/screens/facilities.dart';
import 'package:vpr_co/screens/events.dart';
import 'package:vpr_co/screens/add_facility.dart';
import 'package:vpr_co/shared/nav_header.dart';
import 'package:side_navigation/side_navigation.dart';
import 'package:vpr_co/services/users_collection.dart';
import 'add_inventory.dart';
import 'home/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vpr_co/services/auth.dart';
import 'package:vpr_co/services/colors.dart' as AppColors;

import 'inventory.dart';

class SideNav extends StatefulWidget {
  const SideNav({Key? key}) : super(key: key);

  @override
  _SideNavState createState() => _SideNavState();
}

class _SideNavState extends State<SideNav> {
  final AuthService _auth = AuthService();
  // final _usersHelper = UsersHelper();
  // var captureUsersName;
  var userPicture;
  //
  // final Stream<QuerySnapshot> _usersStream =
  //     FirebaseFirestore.instance.collection('users').snapshots();

  void initState() {
    super.initState();
    // _usersHelper.setCurrentID();
    // _usersHelper.getUserPicture();
    // getUserPicture();

    ///ToDo FUNCTION CALL
    // print("HERE IS THE RETURN FROM NAV: ${_usersHelper.setCurrentID()} ");
    // print("HERE IS THE RETURN FROM NAV: ${_usersHelper.userName1} ");
  }

  // Future<String> getUserPicture() async {
  //   var collectionStreamEMAIL = FirebaseFirestore.instance
  //       .collection('users')
  //       .get()
  //       .then((QuerySnapshot querySnapshot) {
  //     querySnapshot.docs.forEach((doc) {
  //       if (doc["email"] == _auth.getEmail) {
  //         // userMap['gettingUserEmail'] =
  //         // doc["email"]; //sets the email of the user to this variable
  //         // userMap['picture'] = doc['picture'];
  //         // // currentFSDOCID = doc.id; //sets the id of the file o this variable
  //         // userMap['username'] = _auth.getDisplayName!;
  //         userPicture = doc['picture'];
  //         print(userPicture);
  //
  //         return userPicture;
  //         // print(
  //         //     "YOU HAVE REACHED THE USERS HELPER  EMAIL IS: ${userMap['gettingUserEmail']}");
  //
  //       }
  //     });
  //   });
  //
  //   return userPicture;
  // }

  // var myTheme = SideNavigationBarTheme(
  //   backgroundColor: AppColors.appClay,
  //   itemTheme: ItemTheme(
  //     selectedItemColor: AppColors.appNeutral,
  //     // Brightness dependant
  //     unselectedItemColor: AppColors.appCharcoal,
  //   ),
  //   togglerTheme: TogglerTheme(
  //     // Brightness dependant
  //     expandIconColor: AppColors.appNeutral,
  //     shrinkIconColor: AppColors.appCharcoal,
  //   ),
  //   // showHeaderDivider: true,
  //   // showMainDivider: true,
  //   // showFooterDivider: true,
  //   // dividerTheme: null,
  // );

  // var myHeader = SideNavigationBarHeader(
  //     // image: Image.network(
  //     //     'https://firebasestorage.googleapis.com/v0/b/yoganandawidsom.appspot.com/o/TEST%2F2014-11-19%2019.31.10.jpg?alt=media&token=b07b8746-4e13-43f6-aab5-9b2de392408e',
  //     //     // userPicture,
  //     //     height: 100,
  //     //     width: 100),
  //     title: Text(""),
  //     subtitle: Text(""));

  // image: NavHeaderWidget(), title: Text(""), subtitle: Text(""));

  /// Views to display
  List<Widget> views = [
    Home(),
    UserProfile(),
    Events(),
    Facilities(),
    AddFacility(),
    Inventory(),
    AddInventory(),
    InventoryPractice(),
    SignIn(),
  ];

  /// The currently selected index of the bar
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // final usersProfile = Provider.of<UsersHelper>(context);
    // captureUsersName = usersProfile.userName1;
    // print("HERE IS THE USER NAME FROM PROVIDER: $captureUsersName");
    // print(
    //     "HERE IS THE USER NAME FROM FUNCTION PROVIDER: ${usersProfile.getUserName()}");
    return Scaffold(
      // The row is needed to display the current view
      body: Row(
        children: [
          SideNavigationBar(
            selectedIndex: selectedIndex,
            initiallyExpanded: false,
            // header: myHeader,
            theme: SideNavigationBarTheme(
              backgroundColor: AppColors.appClay,
              togglerTheme: SideNavigationBarTogglerTheme.standard(),
              itemTheme: SideNavigationBarItemTheme(
                selectedItemColor: AppColors.appNeutral,
                // Brightness dependant
                unselectedItemColor: AppColors.appCharcoal,
              ),

              // SideNavigationBarItemTheme.standard(),
              dividerTheme: SideNavigationBarDividerTheme.standard(),
            ),
            items: const [
              SideNavigationBarItem(
                icon: Icons.home,
                label: 'Home',
              ),
              SideNavigationBarItem(
                icon: Icons.person,
                label: 'User Profile',
              ),
              SideNavigationBarItem(
                icon: Icons.attractions,
                label: 'Events',
              ),
              SideNavigationBarItem(
                icon: Icons.apartment,
                label: 'Facilities',
              ),
              SideNavigationBarItem(
                icon: Icons.add_business,
                label: 'Add Facility',
              ),
              SideNavigationBarItem(
                icon: Icons.multiline_chart_outlined,
                label: 'Inventory Chart',
              ),
              SideNavigationBarItem(
                icon: Icons.inventory_outlined,
                label: 'Add Inventory',
              ),
              SideNavigationBarItem(
                icon: Icons.inventory_2_outlined,
                label: 'Inventory',
              ),
              SideNavigationBarItem(
                icon: Icons.lock,
                label: 'Sign In',
              ),
            ],
            onTap: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
          ),

          /// Make it take the rest of the available width
          Expanded(
            child: views.elementAt(selectedIndex),
          ),
        ],
      ),
    );
  }
}
