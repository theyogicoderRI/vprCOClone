import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vpr_co/services/colors.dart' as AppColors;

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
    // sets the incoming document ID here from the event clicked on
    // by the user

    setState(() {
      getTheID();
    });
  }

  final selectedText = TextStyle(
      fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.appPurple);

  var eventID; //the variable that stores the in coming event ID
  List listProducts = [];

  //TODO: This gets the document ID we select when we click on the event
  //TODO: in the events page
  Future<void> getTheID() async {
    FirebaseFirestore.instance
        .collection('events')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (doc.id == widget.id) {
          eventID = doc.id;
        }
      });
      setState(() {
        help(eventID);
      });
      // call the function  that transfers the products
      //to our list here.

      setState(() {});
    });
  }

  List l = []; // the list we use in the listview.builder widget

  //todo: this is the magic where I add the map from FS to the list "l"
  Future help(String eid) async {
    FirebaseFirestore.instance
        .collection('events')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (doc.id == eid) {
          // do it only for the event we clicked on, not all events
          List<dynamic> pMap =
              doc['product']; //stores products in the pMap list
          for (var x in pMap) {
            //traverse the pMap list
            setState(() {
              //need the setState() to refresh the list from event to event
              l.add({
                "category": x["category"],
                "name": x["name"],
                "id": x["id"]
              });
            });
            // add a map of products to it
          }
        }
      });
    });
  }

  Future setList(String eid) async {
    l = [];
    FirebaseFirestore.instance
        .collection('events')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (doc.id == eid) {
          // do it only for the event we clicked on, not all events
          List<dynamic> pMap =
              doc['product']; //stores products in the pMap list
          for (var x in pMap) {
            //traverse the pMap list
            setState(() {
              //need the setState() to refresh the list from event to event
              l.add({
                "category": x["category"],
                "name": x["name"],
                "id": x["id"]
              });
            });
            // add a map of products to it
          }
          print(l);
        }
      });
    });
  }

  Future deleteRow(cat, name, id) async {
    var collection = FirebaseFirestore.instance.collection('events');
    collection.get().then((QuerySnapshot querySnapshot) {
      setState(() {
        querySnapshot.docs.forEach((doc) {
          if (doc.id == widget.id) {
            eventID = doc.id;

            for (var x in doc.get("product")) {
              if (x['category'] == cat && x['name'] == name && x['id'] == id) {
                x['id'] = id;
                print(
                    "This the cat $cat, this is the name $name, this is the id: $id");

                setState(() {
                  collection.doc(eventID).update({
                    'product': FieldValue.arrayRemove([
                      {'category': cat, "name": name, "id": id}
                    ])
                  });
                  setList(eventID);
                });
              }
            }
          }
        });
      });
    });
  }

  Future<void> successDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text(
              "Product Unattached From this Event. You may need to refresh the screen to see the changes.",
              style: selectedText,
            ),
            children: [
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false, //prevents the back arrow
        title: const Text("Products Given Out"),
        backgroundColor: AppColors.appClay,
        elevation: 0.0,
        //icon buttons for top nav
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
              return Padding(
                padding: const EdgeInsets.all(2.0),
                child: Container(
                  width: width,
                  child: SingleChildScrollView(
                    child: DataTable(
                      showBottomBorder: true,
                      columns: const <DataColumn>[
                        DataColumn(
                          label: Text(
                            'Category',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Name',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Remove',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                      ],
                      rows: l
                          .map(
                            ((product) => DataRow(
                                  cells: [
                                    DataCell(Text(product[
                                        'category'])), //Extracting from Map element the value
                                    DataCell(Text(product['name'])),
                                    DataCell(ElevatedButton(
                                      child: Text("Delete"),
                                      onPressed: () {
                                        setState(() {
                                          deleteRow(product['category'],
                                              product['name'], product['id']);
                                        });
                                        successDialog(context);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary: AppColors
                                            .appPurple, // Background color
                                      ),
                                    )),
                                  ],
                                )),
                          )
                          .toList(),
                      dividerThickness: 2,
                      dataRowHeight: 55,
                      headingTextStyle: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                      headingRowColor: MaterialStateProperty.resolveWith(
                          (states) => AppColors.appPurple),
                    ),
                  ),
                ),
              );
            }
            return const SizedBox();
          }),
    );
  }
}
