import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vpr_co/screens/facilities.dart';
import 'package:vpr_co/services/colors.dart' as AppColors;
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:vpr_co/shared/loading.dart';
import 'dart:io';

class EditFacility extends StatefulWidget {
  const EditFacility({Key? key}) : super(key: key);

  static const routeName = '/edit_facility';

  @override
  State<EditFacility> createState() => _EditFacilityState();
}

class _EditFacilityState extends State<EditFacility> {
  final headline = TextStyle(
      fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.appLinks);
  final selectedText = TextStyle(
      fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.appPurple);

  final ImagePicker _picker = ImagePicker();

  String facility = '';
  String location = '';
  String address = '';
  String contact = '';
  String phone = '';
  String cell = '';
  String building = '';
  String website = ''; //added 6.21.2022
  int unitCount = 0; //added 6.21.2022
  String email = '';
  var img;
  var currentFSDOCID;
  var imagePath;
  var oldFolks =
      'https://firebasestorage.googleapis.com/v0/b/fir-fun-b294e.appspot.com/o/seniors_funny.jpeg?alt=media&token=52263e2e-0ad8-4080-9b93-b458572aaf17';

  var intImage;
  var gettingUserEmail = '';

  bool origImage = true;

  bool loading = false;

  final _formKey = GlobalKey<FormState>();

  //what gets stored in each form field
  TextEditingController _facilityController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _contactController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _cellController = TextEditingController();
  TextEditingController _buildingController = TextEditingController();
  TextEditingController _websiteController =
      TextEditingController(); //ADDED 6.21.2022
  TextEditingController _unitCountController =
      TextEditingController(); //ADDED 6.21.2022
  TextEditingController _emailController =
      TextEditingController(); //ADDED 6.21.2022

  XFile? imageFile;

  void clearFields() {
    setState(() {
      _facilityController.clear();
      _locationController.clear();
      _addressController.clear();
      _contactController.clear();
      _buildingController.clear();
      _phoneController.clear();
      _cellController.clear();
      _websiteController.clear(); //ADDED 6.21.2022
      _unitCountController.clear(); //ADDED 6.21.2022
      _emailController.clear(); //ADDED 6.21.2022
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _facilityController.dispose();
    _locationController.dispose();
    _addressController.dispose();
    _contactController.dispose();
    _buildingController.dispose();
    _phoneController.dispose();
    _cellController.dispose();
    _websiteController.dispose(); //ADDED 6.21.2022
    _unitCountController.dispose(); //ADDED 6.21.2022
    _emailController.dispose(); //ADDED 6.21.2022

    super.dispose();
  }

  //uploads image to firebase storage
  Future<void> uploadFile(File filePath, String fileName) async {
    try {
      await firebase_storage.FirebaseStorage.instance
          .ref('uploads/$fileName')
          .putFile(filePath);
    } on FirebaseException catch (e) {
      print(e);
    }

    getFilePathOnStorage('uploads/$fileName');
  }

//gets path to where image is stored in firebase storage
  Future<void> getFilePathOnStorage(String fileName) async {
    String downloadURL = await firebase_storage.FirebaseStorage.instance
        .ref(fileName)
        .getDownloadURL();

    //Then let imagePath store the location of the file in setState- IMPORTANT
    //if we don't do this the  selected image will not show in UI
    setState(() {
      imagePath = downloadURL;
      origImage = false;
      print("new path to image: $imagePath");
    });
  }

  void _openGallery(BuildContext context) async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      imageFile = pickedFile;
      intImage = imageFile;

      uploadFile(
          File(intImage!.path), intImage.name); //don't use the ! for null aware
      //I am using the name above to get the unique name
    });

    Navigator.pop(context);
  }

  void _openCamera(BuildContext context) async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
    );

    setState(() {
      imageFile = pickedFile;
      intImage = imageFile;

      uploadFile(File(intImage.path), intImage.name);
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference facilities =
        FirebaseFirestore.instance.collection('facilities');

    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    img = args.image;
    facility = args.facilityName;
    location = args.location;
    address = args.address;
    contact = args.contact;
    phone = args.phone;
    cell = args.cell;
    building = args.building;
    website = args.website; //ADDED 6.21.2022
    unitCount = args.unitCount; //ADDED 6.21.2022
    email = args.email;

    _facilityController.text = facility;
    _locationController.text = location;
    _addressController.text = address;
    _contactController.text = contact;
    _phoneController.text = phone;
    _cellController.text = cell;
    _buildingController.text = building;
    _websiteController.text = website; //ADDED 6.21.2022
    _unitCountController.text = unitCount.toString(); //ADDED 6.21.2022
    _emailController.text = email;

    Future<void> updateFacility(String doc) {
      if (imagePath == null) {
        return facilities.doc(doc).update({
          'image': img,
          'facilityName': _facilityController.text,
          'location': _locationController.text,
          'address': _addressController.text,
          'contact': _contactController.text,
          'phone': _phoneController.text,
          'cell': _cellController.text,
          'building': _buildingController.text,
          'website': _websiteController.text, //ADDED 6.21.2022
          'unitCount': _unitCountController.text, //ADDED 6.21.2022
          'email': _emailController.text,
        }).then((value) {
          _facilityController.clear();
          _locationController.clear();
          _addressController.clear();
          _contactController.clear();
          _buildingController.clear();
          _phoneController.clear();
          _cellController.clear();
          _websiteController.clear(); //ADDED 6.21.2022
          _unitCountController.clear(); //ADDED 6.21.2022
          _emailController.clear();
        });
      }
      return facilities.doc(doc).update({
        'image': imagePath,
        'facilityName': _facilityController.text,
        'location': _locationController.text,
        'address': _addressController.text,
        'contact': _contactController.text,
        'phone': _phoneController.text,
        'cell': _cellController.text,
        'building': _buildingController.text,
        'website': _websiteController.text, //ADDED 6.21.2022
        'unitCount': _unitCountController.text, //ADDED 6.21.2022
        'email': _emailController.text,
      }).then((value) {
        _facilityController.clear();
        _locationController.clear();
        _addressController.clear();
        _contactController.clear();
        _buildingController.clear();
        _phoneController.clear();
        _cellController.clear();
        _websiteController.clear(); //ADDED 6.21.2022
        _unitCountController.clear(); //ADDED 6.21.2022
        _emailController.clear();
      });
    }

    Future<void> showChoiceDialog(BuildContext context) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                "Choose Image option",
                style: TextStyle(color: AppColors.appTeal),
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    Divider(
                      height: 1,
                      color: AppColors.appTeal,
                    ),
                    ListTile(
                      onTap: () {
                        _openGallery(context);
                      },
                      title: const Text("Gallery"),
                      leading: Icon(
                        Icons.account_box,
                        color: AppColors.appTeal,
                      ),
                    ),
                    Divider(
                      height: 1,
                      color: AppColors.appTeal,
                    ),
                    ListTile(
                      onTap: () {
                        _openCamera(context);
                      },
                      title: const Text("Camera"),
                      leading: Icon(
                        Icons.camera,
                        color: AppColors.appTeal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
    }

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
                  "Facility Updated",
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
              title: const Text("Edit Facility"),

              backgroundColor: AppColors.appClay,
              elevation: 0.0,
              actions: [
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
                stream: facilities.snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  return ListView(
                    children: [
                      origImage == true
                          ? Container(
                              margin: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black, width: 1),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: Image.network(
                                  img,
                                ),
                              ),
                            )
                          : imagePath == null
                              ? Container(
                                  margin: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black, width: 1),
                                  ),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: Image.network(
                                      img,
                                    ),
                                  ),
                                )
                              : Container(
                                  margin: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black, width: 1),
                                  ),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: Image.network(
                                      imagePath,
                                    ),
                                  ),
                                ),
                      //this moves the icon around to exactly where I want it
                      Transform.translate(
                        offset: const Offset(125, -35),
                        child: Container(
                          padding: const EdgeInsets.all(.2),
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      Colors.deepPurpleAccent.withOpacity(.2),
                                  spreadRadius: 1,
                                  blurRadius: 2,
                                  offset: const Offset(
                                      1, 4), // changes position of shadow
                                ),
                              ],
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Colors.deepPurpleAccent, width: .01)),
                          child: IconButton(
                              splashColor: AppColors.appClay,
                              tooltip: "edit a picture",
                              icon: const Icon(Icons.add_a_photo_sharp,
                                  color: AppColors.appDeepPurple, size: 49),
                              onPressed: () {
                                setState(() {
                                  showChoiceDialog(context);
                                });
                              }),
                        ),
                      ),
                      Divider(
                        height: 2,
                        color: AppColors.appCharcoal.withOpacity(.5),
                        thickness: 1.3,
                        indent: 3,
                        endIndent: 3,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0,
                                      MediaQuery.of(context).viewInsets.bottom),
                                  child: TextFormField(
                                    controller: _facilityController,
                                    decoration: const InputDecoration(
                                      icon: Icon(Icons.business),
                                      hintText: 'Enter the Name of Facility',
                                      labelText: 'Facility Name',
                                      fillColor: Colors.white24,
                                      filled: true,
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Name field is empty';
                                      }
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0,
                                      MediaQuery.of(context).viewInsets.bottom),
                                  child: TextFormField(
                                    controller: _locationController,
                                    decoration: const InputDecoration(
                                      icon: Icon(Icons.villa),
                                      hintText: 'City',
                                      labelText: 'City or Town',
                                      fillColor: Colors.white24,
                                      filled: true,
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Name field is empty';
                                      }
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0,
                                      MediaQuery.of(context).viewInsets.bottom),
                                  child: TextFormField(
                                    controller: _addressController,
                                    decoration: const InputDecoration(
                                      icon: Icon(Icons.streetview),
                                      hintText: 'Enter Address',
                                      labelText: 'Address',
                                      fillColor: Colors.white24,
                                      filled: true,
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Name field is empty';
                                      }
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0,
                                      MediaQuery.of(context).viewInsets.bottom),
                                  child: TextFormField(
                                    controller: _contactController,
                                    decoration: const InputDecoration(
                                      icon: Icon(Icons.person),
                                      hintText: 'Contact',
                                      labelText: 'Contact',
                                      fillColor: Colors.white24,
                                      filled: true,
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Name field is empty';
                                      }
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0,
                                      MediaQuery.of(context).viewInsets.bottom),
                                  child: TextFormField(
                                    controller: _emailController,
                                    decoration: const InputDecoration(
                                      icon: Icon(Icons.email),
                                      hintText: 'Email',
                                      labelText: 'Email',
                                      fillColor: Colors.white24,
                                      filled: true,
                                      border: OutlineInputBorder(),
                                    ),
                                    // validator: (value) {
                                    //   if (value!.isEmpty) {
                                    //     return 'Name field is empty';
                                    //   }
                                    // },
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0,
                                      MediaQuery.of(context).viewInsets.bottom),
                                  child: TextFormField(
                                    controller: _phoneController,
                                    decoration: const InputDecoration(
                                      icon: Icon(Icons.phone),
                                      hintText: 'Phone',
                                      labelText: 'Phone',
                                      fillColor: Colors.white24,
                                      filled: true,
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Phone field is empty';
                                      }
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller: _websiteController,
                                    // inputFormatters: <TextInputFormatter>[
                                    //   FilteringTextInputFormatter.allow(urlRegExp)
                                    // ],
                                    decoration: const InputDecoration(
                                      icon: Icon(Icons.web),
                                      hintText: 'http://www.theWebsite.com',
                                      labelText: 'Website',
                                      fillColor: Colors.white24,
                                      filled: true,
                                      border: OutlineInputBorder(),
                                    ),
                                    // validator: (value) {
                                    //   Pattern pattern =
                                    //       r"((https?:www\.)|(https?:\/\/)|(www\.))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?";
                                    //   RegExp regex = RegExp(pattern.toString());
                                    //   if (!regex.hasMatch(value!)) {
                                    //     return 'Enter Valid URL';
                                    //   } else {
                                    //     return null;
                                    //   }
                                    // },
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0,
                                      MediaQuery.of(context).viewInsets.bottom),
                                  child: TextFormField(
                                    controller: _cellController,
                                    decoration: const InputDecoration(
                                      icon: Icon(Icons.edgesensor_low),
                                      hintText: 'Cell',
                                      labelText: 'Cell',
                                      fillColor: Colors.white24,
                                      filled: true,
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Cell field is empty';
                                      }
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0,
                                      MediaQuery.of(context).viewInsets.bottom),
                                  child: TextFormField(
                                    controller: _buildingController,
                                    decoration: const InputDecoration(
                                      icon: Icon(Icons.widgets),
                                      hintText: 'Building',
                                      labelText: 'Building',
                                      fillColor: Colors.white24,
                                      filled: true,
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Name field is empty';
                                      }
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: _unitCountController,

                                    decoration: const InputDecoration(
                                      icon: Icon(Icons.numbers),
                                      hintText: 'How many units?',
                                      labelText: '# of Units',
                                      fillColor: Colors.white24,
                                      filled: true,
                                      border: OutlineInputBorder(),
                                    ),
                                    // validator: (value) {
                                    //   if (value!.isEmpty) {
                                    //     return 'Phone field is empty';
                                    //   }
                                    // },
                                  ),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          updateFacility(args
                                              .id); // Here is where we update

                                          successDialog(context);
                                          loading = true;
                                        }
                                        clearFields();
                                        loading = false;
                                      },
                                      child: Text(
                                        "Update Record",
                                        style: GoogleFonts.roboto(
                                            textStyle: headline),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                  // );
                }),
          );
  }
}
