import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:vpr_co/screens/add_event.dart';
import 'package:vpr_co/screens/add_inventory.dart';
import 'package:vpr_co/screens/edit_products.dart';
import 'package:vpr_co/screens/inventory.dart';
import 'package:vpr_co/screens/inventory_practice.dart';
import 'package:vpr_co/screens/products_to_events.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:vpr_co/screens/authenticate/register.dart';
import 'package:vpr_co/screens/authenticate/signin.dart';
import 'package:vpr_co/screens/side_nav.dart';

import 'package:vpr_co/screens/wrapper.dart';
import 'package:vpr_co/screens/facilities.dart';
import 'package:vpr_co/screens/events.dart';
import 'package:vpr_co/screens/add_facility.dart';
import 'package:vpr_co/screens/edit_facility.dart';
import 'package:provider/provider.dart';

import 'package:vpr_co/services/auth.dart';
import 'package:vpr_co/services/users_collection.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';

import 'models/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    //This is what keeps the user logged in CRUCIAL////////
    return StreamProvider<MyUser?>.value(
      //we are listening to the userStream, Wrapper and all its descendants can hear it
      value: AuthService().userStream,
      initialData: null,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/signIn': (context) => const SignIn(),
          '/register': (context) => const Register(),
          '/sideNav': (context) => const SideNav(),
          '/facilities': (context) => const Facilities(),
          '/events': (context) => const Events(),
          '/inventory': (context) => const Inventory(),
          '/add_facilities': (context) => const AddFacility(),
          '/add_inventory': (context) => AddInventory(),
          '/inventory_practice': (context) => InventoryPractice(),
          ProductEvents.routeName: (context) => ProductEvents(),
          EditFacility.routeName: (context) => const EditFacility(),
          EditProducts.routeName: (context) => const EditProducts(),
          AddEvent.routeName: (context) => const AddEvent(),
        },
        home: const Wrapper(),
        localizationsDelegates: const [
          GlobalWidgetsLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [Locale('en', 'US')],
      ),
    );
  }
}

///NOTE USING this right now
class MyCustomForm extends StatefulWidget {
  const MyCustomForm({Key? key}) : super(key: key);

  @override
  State<MyCustomForm> createState() => _MyCustomFormState();
}

class _MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextField(
              decoration: InputDecoration(
                icon: Icon(Icons.mail),
                hintText: 'enter email',
                labelText: 'email',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextField(
              obscureText: true,
              obscuringCharacter: '*',
              decoration: InputDecoration(
                icon: Icon(Icons.password),
                hintText: 'enter password',
                labelText: 'password',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState!.validate()) {
                  // If the form is valid, display a snackbar. In the real world,
                  // you'd often call a server or save the information in a database.
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Processing Data')),
                  );
                }
              },
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}
