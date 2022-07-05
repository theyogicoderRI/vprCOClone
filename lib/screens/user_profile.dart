import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vpr_co/services/auth.dart';
import 'package:vpr_co/shared/loading.dart';
import 'package:vpr_co/shared/profile_container.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:vpr_co/services/colors.dart' as AppColors;
import 'package:google_fonts/google_fonts.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final headline = TextStyle(
      fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.appDeepGrey);
  final userDataText = TextStyle(
      fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.appCharcoal);

  final AuthService _auth = AuthService();
  final ImagePicker _picker = ImagePicker();

  var gettingUserEmail = '';
  var currentFSDOCID;
  var imagePath;

  var intImage;

  bool editPhone = false;
  TextEditingController _phoneController = TextEditingController();
  String stockImage =
      "https://firebasestorage.googleapis.com/v0/b/vpr-co-project.appspot.com/o/funnyPug.png?alt=media&token=a1bbd7c8-4314-4a55-b651-8e1dda789040";

  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('users')
      .snapshots(); //Query snapshot

  XFile? imageFile;

  void initState() {
    super.initState();
    setCurrentID(); //ToDo FUNCTION CALL
  }

  //Todo: update phone number
  Future<void> upDatePhoneNumber() {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    if (_phoneController.text.isNotEmpty) {
      //only place I could get the null
      print("nope not empty");
      FirebaseFirestore.instance
          .collection('users')
          .doc(currentFSDOCID)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          return users
              .doc(currentFSDOCID)
              .update({
                'phoneNumber': _phoneController.text,
              })
              .then((value) => print("Added picture"))
              .catchError((error) => print("Failed to add picture: $error"));
        } else {
          print("EMPTY");
        }
      });
    } else {
      print("she's empty");
    }

    return fakeReturnFunction();
  }

  //ToDo: this uploads the file to FB storage
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

  //ToDo:  Get name of the path of the file just stored in FB Storage
  Future<void> getFilePathOnStorage(String fileName) async {
    String downloadURL = await firebase_storage.FirebaseStorage.instance
        .ref(fileName)
        .getDownloadURL();

    //Todo: Then let imagePath store the location of the file
    imagePath = downloadURL;
    print("Getting File Name NOW: $downloadURL");
    //Todo: Then kick off the function to get the current users email and ID
    setFirestoreCurrentUserEmailAndID();
  }

  Future<void> setFirestoreCurrentUserEmailAndID() async {
    var collectionStreamEMAIL = FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        // print("ID: ${doc.id} EMAIL: ${doc['email']}");
        if (doc["email"] == _auth.getEmail) {
          gettingUserEmail =
              doc["email"]; //sets the email of the user to this variable
          currentFSDOCID = doc.id; //sets the id of the file o this variable
          print("Users Email: ${gettingUserEmail} current ID: $currentFSDOCID");
        }
      });
    });

    addUserImageToFS(imagePath, currentFSDOCID);
  }

  //todo This updates the picture field on Firestore
  Future<void> addUserImageToFS(String image, String id) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        return users
            .doc(id)
            .update({'picture': image})
            .then((value) => print("Added picture"))
            .catchError((error) => print("Failed to add picture: $error"));
      } else {
        print("foo");
      }
    });
    return fakeReturnFunction(); //Needing a return here, so I created a fake function
  }

  // THIS FUNCTION SETS THE ID of our user (users collection) TO our variable currentFSDOCID
  // it gets called in initState()- Need this to make the app more responsive
  Future<void> setCurrentID() async {
    var collectionStreamEMAIL = FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (doc["email"] == _auth.getEmail) {
          gettingUserEmail =
              doc["email"]; //sets the email of the user to this variable
          currentFSDOCID = doc.id; //sets the id of the file o this variable

        }
      });
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

      uploadFile(
          File(intImage!.path), intImage.name); //don't use the ! for null aware
      //I am using the name above to get the unique name
    });
    Navigator.pop(context);
  }

  Future fakeReturnFunction() async {
    print("Fake function");
  }

  @override
  Widget build(BuildContext context) {
    String textToSendBack = _phoneController.text;
    final _key = GlobalKey<FormState>();
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

    Future<void> showPhoneDialog(BuildContext context) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                "Edit Phone Number",
                style: TextStyle(color: AppColors.appTeal),
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    Divider(
                      height: 1,
                      color: AppColors.appTeal,
                    ),
                    TextFormField(
                      key: _key,
                      keyboardType: TextInputType.phone,
                      autocorrect: false,
                      inputFormatters: [
                        // LengthLimitingTextInputFormatter(10),
                        FilteringTextInputFormatter.deny(' '),
                      ],
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.phone),
                        hintText: 'edit phone #',
                        labelText: 'phone',
                        fillColor: Colors.white24,
                        filled: true,
                        // border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        inputFormatters:
                        if (value!.isEmpty) {
                          return 'email field is empty';
                        }
                        // ApplicationState().verifyEmail(value);
                      },
                    ),
                    Divider(
                      height: 1,
                      color: AppColors.appTeal,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("Cancel")),
                        TextButton(
                            onPressed: () {
                              // print("Captured is ${_phoneController.text}");

                              upDatePhoneNumber();
                              Navigator.pop(context);
                            },
                            child: Text("Update")),
                      ],
                    ),
                  ],
                ),
              ),
            );
          });
    }

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double getWidth = MediaQuery.of(context).devicePixelRatio.toDouble();

    return Scaffold(
      body: StreamBuilder(
          stream: _usersStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Loading();
            }
            if (snapshot.hasData) {
              final documentSnapshot = snapshot.data!;

              if (documentSnapshot.docs
                  .any((element) => element['email'] == _auth.getEmail)) {
                final documentSnapshot2 = snapshot.data!.docs.firstWhere(
                    (element) => element['email'] == _auth.getEmail);

                return Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Positioned(
                      left: 0,
                      top: 0,
                      height: height / 3.1,
                      width: width - 51,
                      child: Image.network(
                        'https://firebasestorage.googleapis.com/v0/b/vpr-co-project.appspot.com/o/VPR-CO-PixTeller.png?alt=media&token=b95d9855-76ea-40a6-bdb9-92f905f2fec6',
                      ),
                    ),
                    //Container
                    Positioned(
                      left: width - 300,
                      top: width - 230,
                      height: 141,
                      width: 141,
                      child: documentSnapshot2.get('picture') != ''
                          ? Container(
                              margin: const EdgeInsets.all(1.0),
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          AppColors.appPurple.withOpacity(0.8),
                                      spreadRadius: 1,
                                      blurRadius: 2,
                                      offset: const Offset(
                                          0, 1), // changes position of shadow
                                    ),
                                  ],
                                  color: AppColors.appTeal,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      width: 1.3, color: AppColors.appCharcoal),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      documentSnapshot2.get('picture'),
                                    ),
                                    fit: BoxFit.cover,
                                  )),
                            )
                          : Container(
                              margin: const EdgeInsets.all(1.0),
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.appClay.withOpacity(0.8),
                                      spreadRadius: 3,
                                      blurRadius: 2,
                                      offset: const Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                  color: AppColors.appTeal,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      width: 1.3, color: AppColors.appCharcoal),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      stockImage,
                                    ),
                                    fit: BoxFit.cover,
                                  )),
                            ),
                    ),
                    //BUTTON TO UPDATE IMAGE:
                    Positioned(
                      left: width / 2.0,
                      top: height / 2.95,
                      // height: 50,
                      // width: 65,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.appPurple,
                          shape: BoxShape.circle,
                          border: Border.all(
                              width: 1.3, color: AppColors.appCharcoal),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.add_a_photo,
                          ),
                          iconSize: 30,
                          color: AppColors.appCharcoal,
                          splashColor: AppColors.appTeal,
                          onPressed: () {
                            // print(" I am clicking the button");
                            showChoiceDialog(context);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Positioned(
                      left: width - 410,
                      top: height / 2.40,
                      height: height / 2.9,
                      width: width - 30,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(30, 5, 30, 10),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(
                                height: 25,
                              ),
                              Text("   USER NAME ",
                                  style:
                                      GoogleFonts.roboto(textStyle: headline)),
                              const SizedBox(
                                height: 5,
                              ),
                              Expanded(
                                child: ProfileCustomContainer(
                                  userVariable: _auth.getDisplayName,
                                  myIcon: Icons.person,
                                  myColor: AppColors.appCharcoal,
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Text("   EMAIL ",
                                  style:
                                      GoogleFonts.roboto(textStyle: headline)),
                              const SizedBox(
                                height: 5,
                              ),
                              Expanded(
                                  child: ProfileCustomContainer(
                                userVariable: _auth.getEmail,
                                myIcon: Icons.email,
                                myColor: AppColors.appCharcoal,
                              )),
                              const SizedBox(
                                height: 12,
                              ),
                              Text("   PHONE ",
                                  style:
                                      GoogleFonts.roboto(textStyle: headline)),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                  width: width / 1.1,
                                  height: height / 17,
                                  margin: const EdgeInsets.all(1.0),
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.8),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: const Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                      color:
                                          Colors.tealAccent.withOpacity(0.25),
                                      shape: BoxShape.rectangle,
                                      border: Border.all(
                                          width: 1.4,
                                          color: AppColors.appCharcoal)),
                                  child: documentSnapshot2.get('email') ==
                                          _auth.getEmail
                                      ? Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                10,
                                                8,
                                                10,
                                                8,
                                              ),
                                              child: setttingWidget(Icons.phone,
                                                  AppColors.appCharcoal),
                                            ),
                                            documentSnapshot2
                                                        .get('phoneNumber')
                                                        .toString()
                                                        .length ==
                                                    10
                                                ? Text(
                                                    "(${documentSnapshot2.get('phoneNumber').toString().substring(0, 3)})-"
                                                    "${documentSnapshot2.get('phoneNumber').toString().substring(3, 6)}-"
                                                    "${documentSnapshot2.get('phoneNumber').toString().substring(6, 10)}",
                                                    style: GoogleFonts.roboto(
                                                        textStyle:
                                                            userDataText))
                                                : Text(documentSnapshot2
                                                    .get('phoneNumber')
                                                    .toString()),
                                          ],
                                        )
                                      : const Text(
                                          "",
                                        )),
                              const SizedBox(
                                height: 10,
                              ),
                            ]),
                      ),
                    ),

                    //MODIFY PHONE number
                    Positioned(
                      left: width / 1.41,
                      top: height / 1.40,
                      height: 37,
                      width: 58,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.appPurple,
                          shape: BoxShape.circle,
                          border: Border.all(
                              width: 1.0, color: AppColors.appCharcoal),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.8),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.add,
                          ),
                          iconSize: 22,
                          color: AppColors.appCharcoal,
                          splashColor: AppColors.appPurple,
                          onPressed: () {
                            // print(" I am clicking the button");
                            showPhoneDialog(context);
                          },
                        ),
                      ),
                    ),
                  ], //<Widget>[]
                );
              }
            }
            return Text("");
          }),
    );
  }
}
