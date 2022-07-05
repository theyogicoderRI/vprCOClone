import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:vpr_co/services/colors.dart' as AppColors;
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:number_inc_dec/number_inc_dec.dart';

String? codeString = '00000000';

class AddInventory extends StatefulWidget {
  @override
  State<AddInventory> createState() => _AddInventoryState();
}

class _AddInventoryState extends State<AddInventory> {
  MobileScannerController cameraController = MobileScannerController();
  bool isCode = false;

  String? yourKey;
  bool clear = false;

  @override
  void initState() {
    codeString = '00000000';
    super.initState();
    getCats();
  }

  final headline = TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.normal,
      color: AppColors.appDeepGrey);
  final scanTitle = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.normal,
      color: AppColors.appDeepGrey);
  final addTitle = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.normal,
      color: AppColors.appPrettyPurple);

  //convert FB timestamp to dart DateTime
  formatTimestamp(Timestamp timestamp) {
    var format = new DateFormat('y-MM-d'); // <- use skeleton here
    return format.format(timestamp.toDate());
  }

//To force the food type
  List<String> foodTypeList = [
    'n/a',
    'dry',
    'wet',
  ];

  TextEditingController _brandController = TextEditingController();
  TextEditingController _foodContainerController = TextEditingController();
  // TextEditingController _foodTypeController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _sizeController = TextEditingController();
  TextEditingController _dateController = TextEditingController()
    ..text = "2022-05";
  TextEditingController _storageController = TextEditingController();
  TextEditingController _numberController = TextEditingController()..text = "1";

  String dropdownFoodTypeValue = 'n/a';

  Future<void> successDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text(
              "Product Saved",
              style: TextStyle(color: AppColors.appTeal),
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

  void clearFields() {
    setState(() {
      _brandController.clear();
      _foodContainerController.clear();
      // _foodTypeController.clear();
      _nameController.clear();
      _sizeController.clear();
      _storageController.clear();
    });
  }

  List<String> catList = [];

  Future getCats() async {
    await FirebaseFirestore.instance
        .collection('inventoryCats')
        .get()
        .then((value) {
      for (var doc in value.docs) {
        catList.add(doc.data()['category']);
      }
    });
    catList.sort();
    print(catList);
  }

  Future<void> launchAlert() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(40.0))),
          elevation: 8.0,
          title: const Text('Oops, There\'s an Error!',
              style: TextStyle(color: Colors.black54)),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Divider(
                  color: Colors.grey,
                  height: 0.0,
                ),
                SizedBox(height: 4.0),
                Icon(
                  Icons.crisis_alert,
                  color: Colors.red,
                  size: 45.0,
                ),
                Text(
                    'CATEGORY is Empty. Please Select a Category From the Drop Down',
                    style: TextStyle(color: Colors.black87)),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String? dropdownValue;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Product Scanner'),
        backgroundColor: AppColors.appClay,
        elevation: 0.0,
        actions: [
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: cameraController.torchState,
              builder: (context, state, child) {
                switch (state as TorchState) {
                  case TorchState.off:
                    return const Icon(Icons.flash_off, color: Colors.grey);
                  case TorchState.on:
                    return const Icon(Icons.flash_on, color: Colors.yellow);
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () => cameraController.toggleTorch(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Scan Your Item",
                style: GoogleFonts.basic(textStyle: scanTitle),
                textAlign: TextAlign.center,
              ),
            ),
            Flexible(
              child: Container(
                height: 200,
                width: 200,
                color: Colors.white,
                child: MobileScanner(
                    //todo: scans the product and collects the barcode
                    fit: BoxFit.cover,
                    allowDuplicates: false,
                    controller: cameraController,
                    onDetect: (barcode, args) {
                      final String? code = barcode
                          .rawValue; //todo: gets the bar code that is scanned in
                      setState(() {
                        // debugPrint('Barcode found! $code');
                        // _products =
                        //     []; //todo: first clears the product list (display list)
                        codeString =
                            code; //todo: lets our variable codestring = the scanned in bar code
                        isCode = true; //todo: alerts that there is a bar code
                        // clear = false;
                        // _onPressed(); //todo: calls the function that conditionally retrieves the data from FB
                      });

                      // getKey();
                    }),
              ),
            ),
            isCode ==
                    false //todo: this either shows the barcode if there is one, or shows nothing
                ? Text("")
                : Text(
                    'Your Barcode is: $codeString',
                    textAlign: TextAlign.center,
                  ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(""),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(90, 15),
                    elevation: 4,
                    primary: AppColors.appPurple, // background
                    onPrimary: Colors.white, // foreground
                  ),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Form(
                              autovalidateMode: AutovalidateMode.always,
                              key: _formKey,
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      "Add Your Product",
                                      style: GoogleFonts.basic(
                                          textStyle: addTitle),
                                    ),
                                    Divider(color: AppColors.appLightGrey),
                                    Text("barcode: $codeString",
                                        style: GoogleFonts.basic(
                                            textStyle: headline)),
                                    Divider(color: AppColors.appLightGrey),
                                    Text("Add Count",
                                        style: GoogleFonts.basic(
                                            textStyle: headline)),
                                    Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child:
                                            NumberInputPrefabbed.roundedButtons(
                                          incDecBgColor: AppColors.appTeal,
                                          buttonArrangement:
                                              ButtonArrangement.rightEnd,
                                          controller: _numberController,
                                          min: 1,
                                          max: 100,
                                          scaleWidth: 1,
                                          scaleHeight: 1,
                                          initialValue: 1,
                                          widgetContainerDecoration:
                                              BoxDecoration(
                                            border: Border.all(
                                              color: AppColors.appPrettyPurple,
                                            ),
                                          ),
                                        )),
                                    Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: TextFormField(
                                        controller: _brandController,
                                        decoration: const InputDecoration(
                                          icon: Icon(Icons.store),
                                          hintText: 'Enter Product Brand',
                                          labelText: 'Product Brand',
                                          fillColor: Colors.white24,
                                          filled: true,
                                          // border: OutlineInputBorder(),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: DropdownButtonFormField<String>(
                                        value: dropdownValue,
                                        icon: const Icon(Icons.category),
                                        elevation: 16,
                                        style: const TextStyle(
                                            color: Colors.deepPurple),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            dropdownValue = newValue!;
                                          });
                                        },
                                        items: catList
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                        hint: Text("Category"),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        controller: _dateController,
                                        decoration: const InputDecoration(
                                          icon: Icon(Icons.date_range),
                                          hintText: 'Enter Expiration Date',
                                          labelText: 'Expiration Date',
                                          fillColor: Colors.white24,
                                          filled: true,
                                          // border: OutlineInputBorder(),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        controller: _foodContainerController,
                                        decoration: const InputDecoration(
                                          icon: Icon(Icons.shopping_bag),
                                          hintText: 'Enter Food Container Type',
                                          labelText: 'Container Type',
                                          fillColor: Colors.white24,
                                          filled: true,
                                          // border: OutlineInputBorder(),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: DropdownButtonFormField<String>(
                                        value: dropdownFoodTypeValue,
                                        icon: const Icon(Icons.restaurant),
                                        elevation: 16,
                                        style: const TextStyle(
                                            color: Colors.deepPurple),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            dropdownFoodTypeValue = newValue!;
                                          });
                                        },
                                        items: foodTypeList
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                        hint: Text("Food Type"),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        controller: _nameController,
                                        decoration: const InputDecoration(
                                          icon: Icon(Icons.label),
                                          hintText: 'Enter Product Name',
                                          labelText: 'Product Name',
                                          fillColor: Colors.white24,
                                          filled: true,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        controller: _sizeController,
                                        decoration: const InputDecoration(
                                          icon: Icon(Icons.format_size),
                                          hintText: 'Enter Product Size',
                                          labelText: 'Product Size',
                                          fillColor: Colors.white24,
                                          filled: true,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        controller: _storageController,
                                        decoration: const InputDecoration(
                                          icon: Icon(Icons.account_balance),
                                          hintText: 'Enter Storage Location',
                                          labelText: 'Storage Location',
                                          fillColor: Colors.white24,
                                          filled: true,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          fixedSize: Size(90, 15),
                                          elevation: 4,
                                          primary:
                                              AppColors.appPurple, // background
                                          onPrimary: Colors.white,
                                        ),
                                        child: Text("Submit"),
                                        onPressed: () {
                                          if (dropdownValue != null) {
                                            CollectionReference _inventory =
                                                FirebaseFirestore.instance
                                                    .collection('inventory');

                                            int count = int.parse(
                                                _numberController.text);
                                            print("WHAT'S THE COUNT: $count");
                                            int newCount = count;
                                            for (var i = 0;
                                                i < newCount;
                                                i + 1) {
                                              print(
                                                  "WHAT'S THE New COUNT: $newCount");
                                              print("WHAT'S i: $i");
                                              _inventory
                                                  .add({
                                                    'pid': i = i + 1,
                                                    'barcode':
                                                        codeString, // John Doe
                                                    'brand':
                                                        _brandController.text,
                                                    'category': dropdownValue,

                                                    'expiration':
                                                        _dateController.text,
                                                    'foodContainer':
                                                        _foodContainerController
                                                            .text,
                                                    'foodType':
                                                        dropdownFoodTypeValue,
                                                    'name':
                                                        _nameController.text,
                                                    'size':
                                                        _sizeController.text,
                                                    'storage':
                                                        _storageController.text,
                                                    'mark': false,
                                                    'markedColor': '#D0D6D0',
                                                  })
                                                  .then((value) =>
                                                      print("Item added!"))
                                                  .catchError((error) => print(
                                                      "Failed to add item: $error"));
                                            }
                                            Navigator.pop(context);
                                            successDialog(context);

                                            codeString = '';
                                            setState(() {
                                              clearFields();
                                            });
                                          } else {
                                            setState(() {
                                              launchAlert();
                                              print(dropdownValue.toString());
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  },
                  child: Text('Add'),
                ),
              ],
            ),
            Expanded(child: ProductListing()),
          ],
        ),
      ),
    );
  }
}

class Product {
  Product(this.id, this.category, this.barcode, this.brand, this.foodContainer,
      this.name, this.foodType, this.size, this.expiration, this.storage);
  final String id;
  final String category;
  final String barcode;
  final String brand;
  final String foodContainer;
  final String name;
  final String foodType;
  final String size;
  final DateTime expiration;
  final String storage;
}

class ProductListing extends StatefulWidget {
  ProductListing({Key? key}) : super(key: key);

  @override
  State<ProductListing> createState() => _ProductListingState();
}

class _ProductListingState extends State<ProductListing> {
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

  void attachAndRemove(id) {
    FirebaseFirestore.instance.collection('inventory').doc(id).delete();
  }

  final _formKey = GlobalKey<FormState>();
  TextEditingController _dateController = TextEditingController()
    ..text = "2022-05";

  @override
  Widget build(BuildContext context) {
    final Query _inventory = FirebaseFirestore.instance
        .collection('inventory')
        .orderBy('expiration');

    return StreamBuilder<QuerySnapshot>(
      stream: _inventory.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData)
          return const Center(child: CircularProgressIndicator());
        if (snapshot.hasData) {
          return Container(
              height: 500,
              child: ListView.builder(
                  addAutomaticKeepAlives: false,
                  addRepaintBoundaries: false,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot inventorySnapshot =
                        snapshot.data!.docs[index];

                    return codeString == inventorySnapshot['barcode']
                        ? Dismissible(
                            dismissThresholds: const {
                              // DismissDirection.startToEnd: 0.1,
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
                                attachAndRemove(inventorySnapshot.id);
                              });
                              const snackBar = SnackBar(
                                content: Text('Item Has Been Deleted!'),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            },
                            child: Card(
                              elevation: 6,
                              margin: EdgeInsets.all(4),
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
                                        color:
                                            Colors.deepPurple.withOpacity(0.1),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    inventorySnapshot[
                                                        'category'],
                                                    style: GoogleFonts.overpass(
                                                        textStyle: category),
                                                  ),
                                                  inventorySnapshot['brand'] !=
                                                          ''
                                                      ? Text(
                                                          inventorySnapshot[
                                                              'brand'],
                                                          style: GoogleFonts
                                                              .roboto(
                                                                  textStyle:
                                                                      brand))
                                                      : Text(''),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: inventorySnapshot[
                                                          'expiration'] !=
                                                      ''
                                                  ? Text(
                                                      inventorySnapshot[
                                                              'expiration']
                                                          .toString()
                                                          .substring(0, 7),
                                                      textAlign:
                                                          TextAlign.right,
                                                      style:
                                                          GoogleFonts.mavenPro(
                                                              textStyle:
                                                                  expire))
                                                  : Text(''),
                                            ),
                                          ],
                                        ),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex: 3,
                                                child: Text(
                                                    inventorySnapshot['name'],
                                                    style: GoogleFonts.roboto(
                                                        textStyle: name)),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: IconButton(
                                                  icon: const Icon(
                                                      Icons.content_copy),
                                                  color:
                                                      AppColors.appPrettyPurple,
                                                  onPressed: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            content: Form(
                                                              key: _formKey,
                                                              child:
                                                                  SingleChildScrollView(
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: <
                                                                      Widget>[
                                                                    Text(
                                                                        "Modify Expiration Date"),
                                                                    Padding(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              8.0),
                                                                      child:
                                                                          TextFormField(
                                                                        controller:
                                                                            _dateController,
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              8.0),
                                                                      child: ElevatedButton(
                                                                          child: Text(
                                                                            "Submit",
                                                                          ),
                                                                          onPressed: () {
                                                                            CollectionReference
                                                                                _inventory =
                                                                                FirebaseFirestore.instance.collection('inventory');
                                                                            _inventory
                                                                                .add({
                                                                                  'barcode': inventorySnapshot['barcode'], // John Doe
                                                                                  'brand': inventorySnapshot['brand'],
                                                                                  'category': inventorySnapshot['category'],
                                                                                  'expiration': _dateController.text,
                                                                                  'foodContainer': inventorySnapshot['foodContainer'],
                                                                                  'foodType': inventorySnapshot['foodType'],
                                                                                  'name': inventorySnapshot['name'],
                                                                                  'size': inventorySnapshot['size'],
                                                                                  'storage': inventorySnapshot['storage'],
                                                                                  'mark': false,
                                                                                  'markedColor': '#D0D6D0',
                                                                                })
                                                                                .then((value) => print("Item Copied!"))
                                                                                .catchError((error) => print("Failed to add item: $error"));
                                                                            Navigator.pop(context);
                                                                          },
                                                                          style: ElevatedButton.styleFrom(primary: AppColors.appPurple)),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        });
                                                  },
                                                ),
                                              ),
                                            ]),
                                      ],
                                    ),
                                  )),
                            ),
                          )
                        : SizedBox(height: .0001);
                  }));
        }

        return const SizedBox();
      },
    );
    ;
  }
}

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
