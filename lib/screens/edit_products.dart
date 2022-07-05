import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vpr_co/screens/facilities.dart';
import 'package:vpr_co/services/colors.dart' as AppColors;
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:vpr_co/shared/loading.dart';
import 'dart:io';

import 'inventory_practice.dart';

class EditProducts extends StatefulWidget {
  const EditProducts({Key? key}) : super(key: key);

  static const routeName = '/edit_products';

  @override
  State<EditProducts> createState() => _EditProductsState();
}

class _EditProductsState extends State<EditProducts> {
  final _key = GlobalKey<FormState>();
  final headline = TextStyle(
      fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.appLinks);
  final selectedText = TextStyle(
      fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.appPurple);

  bool loading = false;

  final _formKey = GlobalKey<FormState>();

  String category = '';
  String barcode = '';
  String brand = '';
  String expiration = '';
  String foodContainer = '';
  String foodType = '';
  String name = '';
  String size = '';
  String storage = '';

  //what gets stored in each form field
  TextEditingController _categoryController = TextEditingController();
  TextEditingController _barcodeController = TextEditingController();
  TextEditingController _brandController = TextEditingController();
  TextEditingController _expirationController = TextEditingController();
  TextEditingController _foodContainerController = TextEditingController();
  TextEditingController _foodTypeController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _sizeController = TextEditingController();
  TextEditingController _storageController = TextEditingController();

  void clearFields() {
    setState(() {
      _categoryController.clear();
      _barcodeController.clear();
      _brandController.clear();
      _expirationController.clear();
      _foodTypeController.clear();
      _foodContainerController.clear();
      _nameController.clear();
      _sizeController.clear();
      _storageController.clear();
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _categoryController.dispose();
    _barcodeController.dispose();
    _brandController.dispose();
    _expirationController.dispose();
    _foodTypeController.dispose();
    _foodContainerController.dispose();
    _nameController.dispose();
    _sizeController.dispose();
    _storageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference _inventory =
        FirebaseFirestore.instance.collection('inventory');

    Future<void> updateProduct(String doc) {
      print(doc);
      return _inventory.doc(doc).update({
        'brand': _brandController.text,
        'foodContainer': _foodContainerController.text,
        'size': _sizeController.text,
        'expiration': _expirationController.text,
        'storage': _storageController.text,
      }).then((value) {
        _brandController.clear();
        _foodContainerController.clear();
        _sizeController.clear();
        _expirationController.clear();
        _storageController.clear();

        print("done");
      });
    }

    final args = ModalRoute.of(context)!.settings.arguments as ProductArguments;

    String expirationDate(String s) {
      if (s.isEmpty || s == '' || s.length < 10) {
        print("HERE IS THE NAME $name");
        return args.expiration;
      }
      return args.expiration.substring(0, 10);
    }

    category = args.category;
    barcode = args.barcode;
    brand = args.brand;
    expiration = expirationDate(args.expiration);
    foodContainer = args.foodContainer;
    foodType = args.foodType;
    name = args.name;
    size = args.size;
    storage = args.storage;

    _categoryController.text = category;
    _barcodeController.text = barcode;
    _brandController.text = brand;
    _expirationController.text = expiration;
    _foodTypeController.text = foodType;
    _foodContainerController.text = foodContainer;
    _nameController.text = name;
    _sizeController.text = size;
    _storageController.text = storage;

    //success dialog when record is added to firebase Firestore
    Future<void> successDialog(BuildContext context) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              insetPadding:
                  const EdgeInsets.symmetric(horizontal: 100, vertical: 180),
              elevation: 3.0,
              title: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "Product Updated",
                  style: TextStyle(color: AppColors.appTeal),
                ),
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
          }).then((value) => Navigator.pushNamed(context, '/sideNav'));
    }

    return loading
        ? const Loading()
        : Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              automaticallyImplyLeading: false, //prevents the back arrow
              title: const Text("Edit This Product"),

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
                    // print("hello");
                    Navigator.pushNamed(context, '/sideNav');
                  },
                ),
              ],
            ),
            body: StreamBuilder(
                stream: _inventory.snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  return ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    name,
                                    style:
                                        GoogleFonts.roboto(textStyle: headline),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    category,
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 4, 10, 4),
                        child: TextFormField(
                          key: _key,
                          keyboardType: TextInputType.text,
                          autocorrect: false,
                          // inputFormatters: [
                          //   // LengthLimitingTextInputFormatter(10),
                          //   FilteringTextInputFormatter.deny(' '),
                          // ],
                          controller: _brandController,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.campaign_outlined),
                            hintText: 'edit product brand name',
                            labelText: 'product brand',
                            fillColor: Colors.white24,
                            filled: true,
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            inputFormatters:
                            if (value!.isEmpty) {
                              return ' field is empty';
                            }
                            // ApplicationState().verifyEmail(value);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 4, 10, 4),
                        child: TextFormField(
                          // key: _key,
                          keyboardType: TextInputType.text,
                          autocorrect: false,
                          // inputFormatters: [
                          //   // LengthLimitingTextInputFormatter(10),
                          //   FilteringTextInputFormatter.deny(' '),
                          // ],
                          controller: _foodContainerController,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.shopping_bag_outlined),
                            hintText: 'edit product food container',
                            labelText: 'Food Container',
                            fillColor: Colors.white24,
                            filled: true,
                            border: OutlineInputBorder(),
                          ),
                          // validator: (value) {
                          //   inputFormatters:
                          //   if (value!.isEmpty) {
                          //     return 'field is empty';
                          //   }
                          //   // ApplicationState().verifyEmail(value);
                          // },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 4, 10, 4),
                        child: TextFormField(
                          // key: _key,
                          keyboardType: TextInputType.text,
                          autocorrect: false,
                          // inputFormatters: [
                          //   // LengthLimitingTextInputFormatter(10),
                          //   FilteringTextInputFormatter.deny(' '),
                          // ],
                          controller: _sizeController,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.monitor_weight_outlined),
                            hintText: 'edit product size',
                            labelText: 'Product Size',
                            fillColor: Colors.white24,
                            filled: true,
                            border: OutlineInputBorder(),
                          ),
                          // validator: (value) {
                          //   inputFormatters:
                          //   if (value!.isEmpty) {
                          //     return 'field is empty';
                          //   }
                          //   // ApplicationState().verifyEmail(value);
                          // },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 4, 10, 4),
                        child: TextFormField(
                          // key: _key,
                          keyboardType: TextInputType.text,
                          autocorrect: false,
                          // inputFormatters: [
                          //   // LengthLimitingTextInputFormatter(10),
                          //   FilteringTextInputFormatter.deny(' '),
                          // ],
                          controller: _storageController,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.account_balance),
                            hintText: 'edit storage location',
                            labelText: 'Storage Location',
                            fillColor: Colors.white24,
                            filled: true,
                            border: OutlineInputBorder(),
                          ),
                          // validator: (value) {
                          //   inputFormatters:
                          //   if (value!.isEmpty) {
                          //     return 'field is empty';
                          //   }
                          //   // ApplicationState().verifyEmail(value);
                          // },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 4, 10, 4),
                        child: TextFormField(
                          // key: _key,
                          keyboardType: TextInputType.text,
                          autocorrect: false,
                          // inputFormatters: [
                          //   // LengthLimitingTextInputFormatter(10),
                          //   FilteringTextInputFormatter.deny(' '),
                          // ],
                          controller: _expirationController,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.date_range_outlined),
                            hintText: 'edit expiration date',
                            labelText: 'Expiration Date',
                            fillColor: Colors.white24,
                            filled: true,
                            border: OutlineInputBorder(),
                          ),
                          // validator: (value) {
                          //   inputFormatters:
                          //   if (value!.isEmpty) {
                          //     return 'field is empty';
                          //   }
                          //   // ApplicationState().verifyEmail(value);
                          // },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Divider(
                        height: 2,
                        color: AppColors.appCharcoal.withOpacity(.5),
                        thickness: 1.3,
                        indent: 3,
                        endIndent: 3,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              // print("PRINTING THE ID ${args.id}");
                              updateProduct(args.id); // Here is where we update
                              //
                              successDialog(context);
                              // // loading = true;
                              //
                              clearFields();
                              // loading = false;
                            },
                            child: Text(
                              "Update Record",
                              style: GoogleFonts.roboto(textStyle: headline),
                            ),
                          ),
                        ],
                      )
                    ],
                  );
                  // );
                }),
          );
  }
}
