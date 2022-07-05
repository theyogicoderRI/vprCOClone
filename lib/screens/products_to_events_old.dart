import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vpr_co/services/auth.dart';
import 'package:vpr_co/services/colors.dart' as AppColors;
import 'package:vpr_co/services/book_case.dart' as Cap;
import 'package:google_fonts/google_fonts.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:url_launcher/url_launcher.dart' as url;

import 'add_event.dart';
import 'edit_facility.dart';

class ProductEvents extends StatefulWidget {
  ProductEvents({Key? key, this.id}) : super(key: key);

  static const routeName = '/products_to_events';
  final id; //this is from the event clicked on

  @override
  State<ProductEvents> createState() => _ProductEventsState();
}

class _ProductEventsState extends State<ProductEvents> {
  @override
  void initState() {
    super.initState();
    getTheID();
  }

  final headline = TextStyle(
      fontSize: 17, fontWeight: FontWeight.w400, color: AppColors.appCharcoal);
  final headline2 = TextStyle(
      fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.appDeepGrey);
  final selectedText = TextStyle(
      fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.appPurple);
  //SORT firebase data by facility name
  final Query _facilities =
      FirebaseFirestore.instance.collection('events').orderBy('dateTime');
  final userDataText = TextStyle(
      fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.appCharcoal);

  var searchItem = '';

  var eventID;
  List listProducts = [];
  Map<dynamic, List<dynamic>> newMap = {};
  Future<void> getProductData() async {
    FirebaseFirestore.instance
        .collection('events')
        // .doc(widget.id)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (doc.id == widget.id) {
          // print(doc.id);
          // print(widget.id);
          // print(doc.data());
          // print(doc['dateTime']);
          // print(doc[
          //     'product']); //[{name: test, category: Cat Food}, {name: Lil' Plates - Bitty Beef Recipe, category: Dog Treats}, {name: A Bigy Blanket, category: Blankets}, {name: Sensitive Stomach, category: Dog Food}, {name: Kidney Care k/d Beef and Vegetable Stew, category: Dog Food}]
          // print(doc['product'].runtimeType); //List<dynamic>
          // print(doc['product'][0]); //{name: test, category: Cat Food}
          // listProducts.add(doc['product']);
          // newMap.addAll(doc.data());
        }
      });
    });
    // var collection = FirebaseFirestore.instance.collection('events');
    // var querySnapshot = await collection.get();
    //
    // // final data = doc.data() as Map;
    // // print(data.runtimeType);
    // var qs = await collection.doc(widget.id).get();
    // // Map value = qs.data();
    // for (var snapshot in querySnapshot.docs) {
    //   Map<String, dynamic> data = snapshot.data();
    //   // if (data["id"]) == widget.id {
    //   //
    //   // }
    //   // print(data.keys.contains("product"));
    //   print(data.entries);
    // }

    // if (x.key == "product") {
    //   // print(x.value[0]['name']);
    //   newMap.addAll(x.value);
    //
    //   for (var y in x.value) {
    //     // print(y['category']);
    //     // print(y['name']);
    //     // listProducts.add(y);
    //
    //   }
    //   // print('PRODUCTS ONLY - ${x.key} - ${x.value} ');
    //   // listProducts.add(x);
    // }
    // print(data.values.toList());

    // for (var y in listProducts) {
    //   print(y);
    // }
    // print(doc['product'][0]['name']);
    // print(widget.id);
    // for (var x in doc['product'][0]['name']) {
    //   print(x);
    // }

    // for (var z in newMap.entries) {
    //   // print(z.value[0]['name']);
    //   print(z.value);
    // }
    // for (var z in listProducts) {
    //   print("PRINTING THE LIST $z");
    // }
  }

  //TODO: This gets the document ID we select when we click on the event
  //TODO: in the events page
  Future<void> getTheID() async {
    FirebaseFirestore.instance
        .collection('events')
        // .doc(widget.id)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (doc.id == widget.id) {
          eventID = doc.id;
          // print(eventID);
          print("EVENTID is ${eventID}, doc.id: $doc.id");
        }
      });
    });
  }

  List l = [];
  // Future help(String eid) async {
  //   FirebaseFirestore.instance
  //       .collection('events')
  //       .get()
  //       .then((QuerySnapshot querySnapshot) {
  //     querySnapshot.docs.forEach((doc) {
  //       List<dynamic> pMap = doc['product'];
  //       // print(pMap);
  //       print("DOC ID ${doc.id}");
  //       if (doc.id == eid) {
  //         print("doc.id is ${doc.id}, id is: $eid");
  //         for (var x in pMap) {
  //           l.add({"category": x["category"], "name": x["name"]});
  //         }
  //       }
  //       print(l.length);
  //       // print(l);
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // print(widget.id);
    // print(listProducts);
    // help(eventID);
    // for (var x in p) {
    //   print(p);
    // }

    // final Stream<QuerySnapshot> _eventStream =
    //     FirebaseFirestore.instance.collection('events').snapshots();
    // List simpleList = ["one", "two", "three"];
    // getProductData();
    // final _events = FirebaseFirestore.instance.collection('events').snapshots();
    // var collection =

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false, //prevent the back arrow
        title: const Text("Products Given Out At This Event"),

        backgroundColor: AppColors.appClay,
        elevation: 0.0,
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            tooltip: 'Back ',
            onPressed: () {
              Navigator.pop(context, '/');
            },
          ),
          IconButton(
            icon: const Icon(Icons.home),
            tooltip: 'Back to Nav',
            onPressed: () {
              Navigator.pushNamed(context, '/sideNav');
            },
          ),
        ],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('events').snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData) {
              return ListView.builder(
                // itemCount: snapshot.data!.docs.length,
                itemCount: 0,
                itemBuilder: (context, index) {
                  final DocumentSnapshot eventSnapshot =
                      snapshot.data!.docs[index];

                  if (eventID == widget.id) {
                    return Container(
                      height: 50,
                      // color: Colors.amber[colorCodes[index]],
                      child: Text(l[index]['name'].toString()),
                    );
                    // ListView(
                    //   children: [
                    //     snapshot.data!.docs
                    //         .map((DocumentSnapshot document) {
                    //       Map<String, dynamic> data =
                    //           document.data()! as Map<String, dynamic>;
                    //       return ListTile(
                    //         title: Text(data['cats']),
                    //         subtitle: Text(data['dogs']),
                    //       );
                    //     }).toList(),
                    //   ],
                    // );
                    // print(eventSnapshot['product']); //[{name: test, category: Cat Food}, {name: Lil' Plates - Bitty Beef Recipe, category: Dog Treats}, {name: A Bigy Blanket, category: Blankets}, {name: Sensitive Stomach, category: Dog Food}, {name: Kidney Care k/d Beef and Vegetable Stew, category: Dog Food}]
                    // print(
                    //     eventSnapshot['product'][0]['name'].toString()); //test
                    // var collection =
                    //     FirebaseFirestore.instance.collection('events');
                    // var querySnapshot = collection.get();

                    // final data = doc.data() as Map;
                    // print(data.runtimeType);
                    // var qs = collection.doc(widget.id).get();

                    // for (var s in qs.) {
                    //
                    // }
                    // for (var snapshot in querySnapshot.docs) {
                    //   Map<String, dynamic> data = snapshot.data();
                    //   // if (data["id"]) == widget.id {
                    //   //
                    //   // }
                    //   // print(data.keys.contains("product"));
                    //   print(data.entries);
                    // }
                    // return Container(
                    //     child:
                    //         Text(eventSnapshot['product'][index].toString()));

                    // return ListView(
                    //   children: [
                    //     snapshot.data!.docs
                    //         .map((DocumentSnapshot document) {
                    //       Map<String, dynamic> data =
                    //           document.data()! as Map<String, dynamic>;
                    //       return ListTile(
                    //         title: Text(data['cats']),
                    //         subtitle: Text(data['dogs']),
                    //       );
                    //     }).toList(),
                    //   ],
                    // );
                  }
                  return SizedBox();

                  // return Container(child: Text(eventSnapshot['product']));

                  // eventSnapshot.id == widget.id
                  // ? Container(
                  //     child: Column(
                  //       children: [
                  //         Text("Event:",
                  //             style: GoogleFonts.roboto(
                  //                 textStyle: selectedText)),
                  //         Text(
                  //             eventSnapshot['facilityMap']['facilityName'] +
                  //                 "-" +
                  //                 eventSnapshot['dateTime']
                  //                     .toString()
                  //                     .substring(0, 10),
                  //             style: GoogleFonts.lato(textStyle: headline)),
                  //         //todo: Use Flutter Data table widget
                  //         ListTile(
                  //             title: Text(eventSnapshot['product'][index]
                  //                 ['category']),
                  //             subtitle: Text(
                  //                 eventSnapshot['product'][index]['name'])),
                  //       ],
                  //     ),
                  //   )
                  // : SizedBox();
                },
              );
            }
            return const SizedBox();
          }),

      //TODO: ANOTHER STREAM BUILDER
      // StreamBuilder<QuerySnapshot>(
      //     stream: _eventStream,
      //     builder: (BuildContext context,
      //         AsyncSnapshot<QuerySnapshot> snapshot) {
      //       if (snapshot.hasError) {
      //         return Text('Something went wrong');
      //       }
      //
      //       if (snapshot.connectionState == ConnectionState.waiting) {
      //         return Text("Loading");
      //       }
      //
      //       return
      //
      //           // eventID == widget.id
      //           //   ?
      //
      //           ListView.builder(
      //               itemCount: snapshot.data!.docs.length,
      //               itemBuilder: (context, index) {
      //                 final DocumentSnapshot eventSnapshot =
      //                     snapshot.data!.docs[index];
      //
      //                 // final foo = eventSnapshot
      //                 return Container(child: Text("foo"));
      //
      //                 snapshot.data!.docs.map((DocumentSnapshot document) {
      //                   Map<String, dynamic> data =
      //                       document.data()! as Map<String, dynamic>;
      //
      //                   return ListTile(
      //                     title: Text(data['product'][index]['category']
      //                         .toString()),
      //                     subtitle: Text(
      //                         data['product'][index]['name'].toString()),
      //                   );
      //                 }).toList();
      //               });
      //       // : SizedBox();
      //     }),
    );
  }
}

//TODO: OLD Streambuilder
// StreamBuilder(
//     stream: FirebaseFirestore.instance.collection('events').snapshots(),
//     builder: (context, AsyncSnapshot snapshot) {
//       if (!snapshot.hasData) {
//         return const Center(child: CircularProgressIndicator());
//       }
//       if (snapshot.hasData) {
//         // List<Products> listOfProducts = snapshot.data;
//         return ListView.builder(
//           itemCount: snapshot.data!.docs.length,
//           itemBuilder: (context, index) {
//             final DocumentSnapshot eventSnapshot =
//                 snapshot.data!.docs[index];
//
//             if (eventSnapshot.id == widget.id) {
//               // print(eventSnapshot['product']); //[{name: test, category: Cat Food}, {name: Lil' Plates - Bitty Beef Recipe, category: Dog Treats}, {name: A Bigy Blanket, category: Blankets}, {name: Sensitive Stomach, category: Dog Food}, {name: Kidney Care k/d Beef and Vegetable Stew, category: Dog Food}]
//               // print(
//               //     eventSnapshot['product'][0]['name'].toString()); //test
//               // var collection =
//               //     FirebaseFirestore.instance.collection('events');
//               // var querySnapshot = collection.get();
//
//               // final data = doc.data() as Map;
//               // print(data.runtimeType);
//               // var qs = collection.doc(widget.id).get();
//
//               // for (var s in qs.) {
//               //
//               // }
//               // for (var snapshot in querySnapshot.docs) {
//               //   Map<String, dynamic> data = snapshot.data();
//               //   // if (data["id"]) == widget.id {
//               //   //
//               //   // }
//               //   // print(data.keys.contains("product"));
//               //   print(data.entries);
//               // }
//               // return Container(
//               //     child:
//               //         Text(eventSnapshot['product'][index].toString()));
//
//               return ListView(
//                 children: [
//                   snapshot.data!.docs.map((DocumentSnapshot document) {
//                     Map<String, dynamic> data =
//                         document.data()! as Map<String, dynamic>;
//                     return ListTile(
//                       title: Text(data['cats']),
//                       subtitle: Text(data['dogs']),
//                     );
//                   }).toList(),
//                 ],
//               );
//             } else
//               return SizedBox();
//
//             // return Container(child: Text(eventSnapshot['product']));
//
//             // eventSnapshot.id == widget.id
//             // ? Container(
//             //     child: Column(
//             //       children: [
//             //         Text("Event:",
//             //             style: GoogleFonts.roboto(
//             //                 textStyle: selectedText)),
//             //         Text(
//             //             eventSnapshot['facilityMap']['facilityName'] +
//             //                 "-" +
//             //                 eventSnapshot['dateTime']
//             //                     .toString()
//             //                     .substring(0, 10),
//             //             style: GoogleFonts.lato(textStyle: headline)),
//             //         //todo: Use Flutter Data table widget
//             //         ListTile(
//             //             title: Text(eventSnapshot['product'][index]
//             //                 ['category']),
//             //             subtitle: Text(
//             //                 eventSnapshot['product'][index]['name'])),
//             //       ],
//             //     ),
//             //   )
//             // : SizedBox();
//           },
//         );
//       }
//       return const SizedBox();
//     }),

class ScreenArguments {
  final String id;
  final String address;
  final String building;
  final String contact;
  final String facilityName;
  final String image;
  final String location;
  final String phone;
  final String cell;

  ScreenArguments(this.id, this.address, this.building, this.contact,
      this.facilityName, this.image, this.location, this.phone, this.cell);
}

class EventArguments {
  final String id;
  final String building;
  final String facilityName;
  final String facilityImage;

  EventArguments(
    this.id,
    this.building,
    this.facilityName,
    this.facilityImage,
  );
}

class Products {
  String? category;
  String? name;

  Products({this.category, this.name});
}

class EventsModel {
  final String id;
  final List<Products> products;

  EventsModel(this.id, this.products);
}
