import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:number_inc_dec/number_inc_dec.dart';
import 'package:vpr_co/services/colors.dart' as AppColors;
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import '../shared/hex_color.dart';
import 'edit_products.dart';

/// this is used for the total inventory listing
/// lots of stuff here

class InventoryPractice extends StatefulWidget {
  const InventoryPractice({Key? key}) : super(key: key);

  @override
  State<InventoryPractice> createState() => _InventoryPracticeState();
}

class _InventoryPracticeState extends State<InventoryPractice> {
  MobileScannerController cameraController = MobileScannerController();
  bool isCode = false;
  String? codeString;
  String? yourKey;
  bool clear = false;
  bool all = true;
  bool marked = false;
  String? attachID;
  String? attachCat;
  String? attachName;
  String? dropDownValue;
  String? subString;
  String? nameSubString;
  String? idCopy;
  String? inventoryID;

  String? clearMe = '';

  int count = 0;
  int invCount = 0;

  String? dropdownValue2;
  String? dropDownValueCat;
  bool advancedSearch = false;
  String screenChange = 'Advanced';
  String? catDD = "DF-Sample";
  String? foodTypeDD = 'dry';
  int monthsSelection = 0;
  String? convertDate;

  DateTime now = new DateTime.now();

  late TextEditingController _searchController = TextEditingController();
  late TextEditingController _eventController = TextEditingController();
  var searchItem = '';
  TextEditingController _numberController = TextEditingController()..text = "1";

  final headline = TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.normal,
      color: AppColors.appDeepGrey);

  final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
    textStyle: TextStyle(fontSize: 16, color: AppColors.appPrettyPurple),
    primary: AppColors.appTeal,
    onPrimary: AppColors.appPrettyPurple,
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
        side: BorderSide(color: AppColors.appPrettyPurple)),
  );

  //ToDo: calls data when page loads or refreshes
  @override
  void initState() {
    super.initState();
    searchItem == '';
    getEvents();
    // print("INV COUNTER IN INITSTATE $invCount");
    invCount = 0;
  }

  void clearText() {
    setState(() {
      _searchController.clear();
      searchItem = "all";
    });
  }

  CollectionReference inventory =
      FirebaseFirestore.instance.collection('inventory');

  Future<void> updateMark(String doc, bool value) {
    if (value == false) {
      return inventory.doc(doc).update({
        'mark': value,
        'markedColor': '#D0D6D0',
      }).then((value) {});
    } else {
      return inventory.doc(doc).update({
        'mark': value,
        'markedColor': '#10C508',
      }).then((value) {});
    }
  }

  // Future<void> advancedCounter(cat, monthsAhead, foodType) async {
  //   FirebaseFirestore.instance
  //       .collection('inventory')
  //       .where('category', isEqualTo: catDD)
  //       .where('foodType', isEqualTo: foodTypeDD)
  //       .get()
  //       .then((QuerySnapshot value) {
  //     value.docs.forEach((doc) {
  //       convertDate =
  //           doc['expiration'] + '-01'; // this gets it back to the full date
  //       var stringToDate =
  //           DateTime.parse(convertDate.toString().substring(0, 10));
  //       var convertToInt = monthsSelection;
  //       int convertToDays = (convertToInt * 30.4167).toInt();
  //       var dateRange =
  //           stringToDate.isBefore(now.add(Duration(days: convertToDays)));
  //       if (dateRange) {
  //         print(doc.id.length);
  //         // print(inventorySnapshot['name']);
  //         invCount = doc.id.length; // this variable holds the count
  //         print("PRINT  THE COUNT FROM THE FUNCTION: $invCount");
  //       }
  //     });
  //   });
  // }

  List<String> foodCatList = [
    "DF-Small",
    "CF-Small",
    "DF-Sample",
    "CF-Sample",
    "DF-Medium",
    "CF-Medium",
    "DF-Large",
    "CF-Large"
  ];

  List<String> foodType = [
    'dry',
    'wet',
  ];

  final category = TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.normal,
      color: AppColors.appPrettyPurple);
  final brand = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: AppColors.appLightGrey);

  final name = TextStyle(
      fontSize: 15, fontWeight: FontWeight.normal, color: AppColors.appBlack);
  final expire = TextStyle(
      fontSize: 12, fontWeight: FontWeight.normal, color: AppColors.appBlack);

  final Stream<QuerySnapshot> _inventory =
      FirebaseFirestore.instance.collection('inventory').snapshots();
  final CollectionReference _categories =
      FirebaseFirestore.instance.collection('inventory');
  final Stream<QuerySnapshot> _eventStream =
      FirebaseFirestore.instance.collection('events').snapshots();
  final Query _eventQuery =
      FirebaseFirestore.instance.collection('events').orderBy('dateTime');
  final Query _cLIst = FirebaseFirestore.instance
      .collection('inventory')
      .where('category', isEqualTo: 'Blankets');

  final DocumentReference documentReference =
      FirebaseFirestore.instance.doc("events/9InTfsbMPMLRFVgut6v3");

  List<Map<String, dynamic>> inventoryList = [];
  // var product1;

  List<Map<String, dynamic>> categoryList = [];

  CollectionReference events = FirebaseFirestore.instance.collection('events');

  addProductToEvent(dropDownValue, attachID, attachCat, attachName) async {
    //dropDownValue is the concat name and time of the event we selected
    //attachID, attachCat and attachName are from the inventory product card we clicked on
    //get all records from the events collection
    await events.get().then((value) {
      value.docs.forEach((element) {
        //extracts just month,day year from the events documents
        var time = element['dateTime'].toString().substring(0, 10);
        //extracts just the facility name from the events documents
        var name = element['facilityMap']['facilityName'];

        //then only for that record where the concatenated dropdown value contains both the time
        // (month,day year only) and the facility name - this creates the unique ID
        if (dropDownValue.toString().contains(time) &&
            dropDownValue.toString().contains(name)) {
          idCopy =
              element.id; //element.id is that specific event we want to attach
          // the product to.  Then we copy that to our variable idCopy (this is the event ID)
          inventoryID =
              attachID; // the inventory ID (This is the specific product id)

          //get records from the inventory collection (products)
          //and update the one that matches the inventory ID we pass in

          inventory.get().then((value) {
            value.docs.forEach((doc) {
              if (doc.id == attachID) {
                // this is how we add new category/name pairs to the newly
                // created "product" map
                //
                events.doc(idCopy).update({
                  'product': FieldValue.arrayUnion([
                    {
                      'id': inventoryID,
                      'category': doc['category'],
                      'name': doc['name'],
                    }
                  ]),
                });
              }
            });
          });
        }
      });
    });
  }

  List<String> eventList = [];

  List<String> idList = [];
  List<String> nameList = [];
  List<String> dateList = [];

  Map eventMap = {};

  //This gets  events and puts in a list
  Future getEvents() async {
    await FirebaseFirestore.instance.collection('events').get().then((value) {
      for (var doc in value.docs) {
        //this converts our string date back to date time
        //so that I can use the isAfter method
        var stringToDate =
            DateTime.parse(doc.data()['dateTime'].toString().substring(0, 10));
        if (stringToDate.isAfter(now.subtract(const Duration(days: 1)))) {
          eventList.add(doc.data()['facilityMap']['facilityName'] +
              "-" +
              doc.data()['dateTime'].toString().substring(0, 10));
        }
      }
    });
  }

  //THIS brings up an alert box and allows us to select an event
  Future<void> attachEvent(
      BuildContext context, String id, bool marked, String cat, String name) {
    String? dropdownValue;
    final _formKey = GlobalKey<FormState>();
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          if (marked == true) {
            return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('events')
                    .where("dateTime", isGreaterThanOrEqualTo: now)
                    .limit(2)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData)
                    return const Center(child: CircularProgressIndicator());
                  if (snapshot.hasData) {
                    return AlertDialog(
                      title: const Text('Attach Product To Event'),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Exit'),
                          onPressed: () {
                            setState(() {
                              Navigator.pop(context);
                            });
                          },
                        ),
                      ],
                      content: Form(
                        key: _formKey,
                        child: DropdownButtonFormField<String>(
                          value: dropdownValue,
                          icon: const Icon(Icons.category),
                          elevation: 16,
                          style: const TextStyle(color: Colors.deepPurple),
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownValue = newValue!;
                              attachID = id;
                              attachCat = cat;
                              attachName = name;
                              dropDownValue = dropdownValue;
                              //call the function that will add the product to the event we select through
                              //the drop down
                              addProductToEvent(dropDownValue, attachID,
                                  attachCat, attachName);
                            });
                          },
                          items: eventList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          hint: Text("Event"),
                        ),
                      ),
                    );
                  }
                  return const SizedBox();
                });
          } else {
            return SizedBox();
          }
        });
  }

  Widget myStream() {
    return Scaffold(
      body: Column(
        children: [
          //search
          Expanded(
            flex: 6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 75,
                  child: SizedBox(
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _searchController,
                        enableSuggestions: true,
                        decoration: const InputDecoration(
                          hintText: '("DF-Sample","all")',
                          labelText: 'Search Product Categories',
                          fillColor: Colors.white24,
                          filled: true,
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (val) {
                          setState(() {
                            searchItem = _searchController.text;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _searchController.text = '';
                      clearText();
                      searchItem = "all";
                    });
                  },
                  icon: const Icon(Icons.delete_outline),
                  color: AppColors.appPrettyPurple,
                ),
              ],
            ),
          ),
          //everything else
          Expanded(
            flex: 35,
            child: StreamBuilder<QuerySnapshot>(
              stream: ((searchItem == '') || (searchItem == "all"))
                  ? _inventory
                  : FirebaseFirestore.instance
                      .collection('inventory')
                      .where("category", isGreaterThanOrEqualTo: searchItem)
                      .where('category', isLessThan: searchItem + 'z')
                      .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                double width = MediaQuery.of(context).size.width;
                if (!snapshot.hasData)
                  return const Center(child: CircularProgressIndicator());
                if (snapshot.hasData) {
                  return Container(
                    height: 500,
                    width: width,
                    child: ListView.builder(
                        addAutomaticKeepAlives: false,
                        addRepaintBoundaries: false,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final DocumentSnapshot inventorySnapshot =
                              snapshot.data!.docs[index];

                          return InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, EditProducts.routeName,
                                  arguments: ProductArguments(
                                    inventorySnapshot.id,
                                    inventorySnapshot['barcode'],
                                    inventorySnapshot['brand'],
                                    inventorySnapshot['category'],
                                    inventorySnapshot['expiration'],
                                    inventorySnapshot['foodContainer'],
                                    inventorySnapshot['foodType'],
                                    inventorySnapshot['name'],
                                    inventorySnapshot['size'],
                                    inventorySnapshot['storage'],
                                  ));
                            },
                            child: Dismissible(
                              dismissThresholds: const {
                                DismissDirection.endToStart: 0.8
                              },
                              direction: DismissDirection.endToStart,
                              key: UniqueKey(),
                              background: Container(
                                color: Colors.red,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                alignment: AlignmentDirectional.center,
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                  size: 25,
                                ),
                              ),
                              onDismissed: (DismissDirection direction) {
                                setState(() {
                                  FirebaseFirestore.instance
                                      .collection('inventory')
                                      .doc(inventorySnapshot.id)
                                      .delete();
                                });
                                const snackBar = SnackBar(
                                  content: Text('Event Has Been Deleted!'),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              },
                              child: Card(
                                elevation: 6,
                                margin: EdgeInsets.all(6),
                                child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.deepPurple
                                              .withOpacity(0.1),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            flex: 4,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    IconButton(
                                                        onPressed: () {
                                                          marked = !marked;
                                                          updateMark(
                                                              inventorySnapshot
                                                                  .id,
                                                              marked);
                                                          if (marked == true) {
                                                            attachEvent(
                                                                context,
                                                                inventorySnapshot
                                                                    .id,
                                                                marked,
                                                                inventorySnapshot[
                                                                    'category'],
                                                                inventorySnapshot[
                                                                    'name']);
                                                          }
                                                        },
                                                        icon: Icon(
                                                            Icons
                                                                .loyalty_outlined,
                                                            color: HexColor(
                                                                inventorySnapshot[
                                                                    'markedColor']))),
                                                    Flexible(
                                                      flex: 20,
                                                      child: AutoSizeText(
                                                        inventorySnapshot[
                                                            'category'],
                                                        style: GoogleFonts
                                                            .overpass(
                                                                textStyle:
                                                                    category),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                inventorySnapshot['brand'] != ''
                                                    ? Text(
                                                        inventorySnapshot[
                                                            'brand'],
                                                        style:
                                                            GoogleFonts.roboto(
                                                                textStyle:
                                                                    brand))
                                                    : Text(''),
                                                Text(inventorySnapshot['name'],
                                                    style: GoogleFonts.roboto(
                                                        textStyle: name)),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: inventorySnapshot[
                                                            'expiration'] ==
                                                        '' ||
                                                    inventorySnapshot[
                                                                'expiration']
                                                            .toString()
                                                            .length <
                                                        6
                                                ? Text('')
                                                : Text(
                                                    inventorySnapshot[
                                                            'expiration']
                                                        .toString()
                                                        .substring(0, 7),
                                                    textAlign: TextAlign.right,
                                                    style: GoogleFonts.mavenPro(
                                                        textStyle: expire)),
                                          ),
                                        ],
                                      ),
                                    )),
                              ),
                            ),
                          );
                        }),
                  );
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget myStream2() {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 8, 8, 0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                          color: AppColors
                              .appTeal, //background color of dropdown button
                          border: Border.all(
                              color: AppColors.appPrettyPurple,
                              width: 1), //border of dropdown button
                          borderRadius: BorderRadius.circular(
                              15), //border radius of dropdown button
                          boxShadow: <BoxShadow>[
                            //apply shadow on Dropdown button
                            BoxShadow(
                                color: AppColors
                                    .appPrettyPurple, //shadow for button
                                blurRadius: 1) //blur radius of shadow
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 16,
                          child: DropdownButton(
                            value: dropDownValueCat,
                            icon: Icon(Icons.arrow_downward,
                                color: AppColors.appPrettyPurple),
                            elevation: 20,
                            style: const TextStyle(color: Colors.deepPurple),
                            onChanged: (selected) {
                              setState(() {
                                dropDownValueCat = selected.toString();
                                catDD = dropDownValueCat;
                              });

                              setState(() {});
                            },
                            items: foodCatList.map((String v) {
                              return DropdownMenuItem<String>(
                                value: v,
                                child: Text(v),
                              );
                            }).toList(),
                            hint: Text("Select Category"),
                          ),
                        ),
                      ),
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                          color: AppColors
                              .appTeal, //background color of dropdown button
                          border: Border.all(
                              color: AppColors.appPrettyPurple,
                              width: 1), //border of dropdown button
                          borderRadius: BorderRadius.circular(
                              15), //border radius of dropdown button
                          boxShadow: <BoxShadow>[
                            //apply shadow on Dropdown button
                            BoxShadow(
                                color: AppColors
                                    .appPrettyPurple, //shadow for button
                                blurRadius: 1) //blur radius of shadow
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 16,
                          child: DropdownButton(
                            value: dropdownValue2,
                            icon: Icon(Icons.arrow_downward,
                                color: AppColors.appPrettyPurple),
                            elevation: 20,
                            style: const TextStyle(color: Colors.deepPurple),
                            onChanged: (newValue) {
                              setState(() {
                                dropdownValue2 = newValue.toString();
                                foodTypeDD = dropdownValue2;
                              });
                            },
                            items: foodType.map((value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            hint: Text("Select Food Type"),
                          ),
                        ),
                      ),
                    ),
                  ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(1.0),
            child: Text("Expires within # of Months",
                style: GoogleFonts.basic(textStyle: headline)),
          ),
          Expanded(
            flex: 6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  flex: 9,
                  child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Container(
                        width: 70,
                        height: 70,
                        child: NumberInputWithIncrementDecrement(
                          incDecBgColor: AppColors.appTeal,
                          buttonArrangement: ButtonArrangement.rightEnd,
                          controller: _numberController,
                          min: 1,
                          max: 36,
                          // scaleWidth: 1,
                          // scaleHeight: 1,
                          initialValue: 1,
                          widgetContainerDecoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.appPrettyPurple,
                            ),
                          ),
                        ),
                      )),
                ),
                Expanded(
                  flex: 5,
                  child: ElevatedButton(
                    style: buttonStyle,
                    onPressed: () {
                      setState(() {
                        monthsSelection = int.parse(_numberController.text);
                      });
                    },
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 20,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('inventory')
                  .where('category', isEqualTo: catDD)
                  .where('foodType', isEqualTo: foodTypeDD)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                double width = MediaQuery.of(context).size.width;
                if (!snapshot.hasData)
                  return const Center(child: CircularProgressIndicator());
                if (snapshot.hasData) {
                  return Container(
                    height: 500,
                    width: width,
                    child: ListView.builder(
                        addAutomaticKeepAlives: false,
                        addRepaintBoundaries: false,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          // invCount = 0;
                          final DocumentSnapshot inventorySnapshot =
                              snapshot.data!.docs[index];

                          var convertDate = inventorySnapshot['expiration'] +
                              '-01'; // this gets it back to the full date
                          var stringToDate = DateTime.parse(
                              convertDate.toString().substring(0, 10));
                          var convertToInt = monthsSelection;
                          int convertToDays = (convertToInt * 30.4167).toInt();
                          var dateRange = stringToDate
                              .isBefore(now.add(Duration(days: convertToDays)));

                          // advancedCounter(inventorySnapshot['category'],
                          //     monthsSelection, inventorySnapshot['foodType']);

                          // if (dateRange) {
                          //   invCount = inventorySnapshot.id.toString().length;
                          // }
                          // print("HOW MANY IN INV? : $invCount");
                          //THIS IS ONLY TO GET THE COUNT
                          // var dataBack = FirebaseFirestore.instance
                          //     .collection('inventory')
                          //     .where('category', isEqualTo: catDD)
                          //     .where('foodType', isEqualTo: foodTypeDD)
                          //     .get();
                          //
                          // dataBack.then((value) {
                          //   value.docs.((element) {
                          //     if (dateRange == true) {
                          //       print(element.id.length);
                          //       // print(inventorySnapshot['name']);
                          //       invCount = element
                          //           .id.length; // this variable holds the count
                          //     }
                          //   });
                          // });
                          //
                          //                       }
                          //

                          return InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, EditProducts.routeName,
                                  arguments: ProductArguments(
                                    inventorySnapshot.id,
                                    inventorySnapshot['barcode'],
                                    inventorySnapshot['brand'],
                                    inventorySnapshot['category'],
                                    inventorySnapshot['expiration'],
                                    inventorySnapshot['foodContainer'],
                                    inventorySnapshot['foodType'],
                                    inventorySnapshot['name'],
                                    inventorySnapshot['size'],
                                    inventorySnapshot['storage'],
                                  ));
                            },
                            child: Dismissible(
                              dismissThresholds: const {
                                DismissDirection.endToStart: 0.8
                              },
                              direction: DismissDirection.endToStart,
                              key: UniqueKey(),
                              background: Container(
                                color: Colors.red,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                alignment: AlignmentDirectional.center,
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                  size: 25,
                                ),
                              ),
                              onDismissed: (DismissDirection direction) {
                                setState(() {
                                  FirebaseFirestore.instance
                                      .collection('inventory')
                                      .doc(inventorySnapshot.id)
                                      .delete();
                                });

                                //TODO: This is where the product gets deleted
                                const snackBar = SnackBar(
                                  content: Text('Event Has Been Deleted!'),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              },
                              child: dateRange ==
                                      true //THis is for the expiration months selected
                                  ? Card(
                                      elevation: 6,
                                      margin: EdgeInsets.all(6),
                                      child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10),
                                                bottomLeft: Radius.circular(10),
                                                bottomRight:
                                                    Radius.circular(10)),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.deepPurple
                                                    .withOpacity(0.1),
                                                spreadRadius: 5,
                                                blurRadius: 7,
                                                offset: Offset(0,
                                                    3), // changes position of shadow
                                              ),
                                            ],
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(6.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  flex: 4,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          IconButton(
                                                              onPressed: () {
                                                                marked =
                                                                    !marked;
                                                                updateMark(
                                                                    inventorySnapshot
                                                                        .id,
                                                                    marked);
                                                                if (marked ==
                                                                    true) {
                                                                  attachEvent(
                                                                      context,
                                                                      inventorySnapshot
                                                                          .id,
                                                                      marked,
                                                                      inventorySnapshot[
                                                                          'category'],
                                                                      inventorySnapshot[
                                                                          'name']);
                                                                }
                                                              },
                                                              icon: Icon(
                                                                  Icons
                                                                      .loyalty_outlined,
                                                                  color: HexColor(
                                                                      inventorySnapshot[
                                                                          'markedColor']))),
                                                          Flexible(
                                                            flex: 20,
                                                            child: AutoSizeText(
                                                              inventorySnapshot[
                                                                  'category'],
                                                              style: GoogleFonts
                                                                  .overpass(
                                                                      textStyle:
                                                                          category),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      inventorySnapshot[
                                                                  'brand'] !=
                                                              ''
                                                          ? Text(
                                                              inventorySnapshot[
                                                                  'brand'],
                                                              style: GoogleFonts
                                                                  .roboto(
                                                                      textStyle:
                                                                          brand))
                                                          : Text(''),
                                                      Text(
                                                          inventorySnapshot[
                                                              'name'],
                                                          style: GoogleFonts
                                                              .roboto(
                                                                  textStyle:
                                                                      name)),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: inventorySnapshot[
                                                                  'expiration'] ==
                                                              '' ||
                                                          inventorySnapshot[
                                                                      'expiration']
                                                                  .toString()
                                                                  .length <
                                                              6
                                                      ? Text('')
                                                      : Text(
                                                          inventorySnapshot[
                                                                  'expiration']
                                                              .toString()
                                                              .substring(0, 7),
                                                          textAlign:
                                                              TextAlign.right,
                                                          style: GoogleFonts
                                                              .mavenPro(
                                                                  textStyle:
                                                                      expire)),
                                                ),
                                              ],
                                            ),
                                          )),
                                    )
                                  : SizedBox(height: 0001),
                            ),
                          );
                        }),
                  );
                }

                return const SizedBox();
              },
            ),
          ),
          // Expanded(
          //     child: Padding(
          //   padding: const EdgeInsets.fromLTRB(2, 2, 4, 2),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.end,
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     children: [
          //       // Text("Count:"),
          //       // Text(invCount.toString()),
          //     ],
          //   ),
          // )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.all(16.0),
              primary: Colors.white,
              textStyle: const TextStyle(fontSize: 15),
            ),
            onPressed: () {
              setState(() {
                advancedSearch = !advancedSearch;
                if (advancedSearch == true) {
                  screenChange = "Back";
                } else {
                  screenChange = "Advanced";
                }
              });
            },
            child: Text(screenChange),
          )
        ],
        automaticallyImplyLeading: false, //prevent the back arrow
        title: const Text("Total Inventory"),
        backgroundColor: AppColors.appClay,
        elevation: 0.0,
      ),
      body: Column(
        children: [
          advancedSearch == false
              ? Expanded(child: myStream())
              : Expanded(child: myStream2()),
          // Expanded(child: myStream2()),
        ],
      ),
    );
  }
}

class ProductArguments {
  final String id;
  final String barcode;
  final String brand;
  final String category;
  final String expiration;
  final String foodContainer;
  final String foodType;
  final String name;
  final String size;
  final String storage;

  ProductArguments(
      this.id,
      this.barcode,
      this.brand,
      this.category,
      this.expiration,
      this.foodContainer,
      this.foodType,
      this.name,
      this.size,
      this.storage);
}
