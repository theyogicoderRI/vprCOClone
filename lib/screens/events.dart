import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:vpr_co/services/auth.dart';
import 'package:vpr_co/services/colors.dart' as AppColors;
// import 'package:vpr_co/custom_widgets/drop_down_facilities.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:vpr_co/screens/products_to_events.dart';

import 'add_event.dart';
import 'edit_facility.dart';

class Events extends StatefulWidget {
  const Events({Key? key}) : super(key: key);

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {
  final AuthService _auth = AuthService();
  final headline = TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.normal,
      color: AppColors.appDeepGrey);
  final headline2 = const TextStyle(
      fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.appBlack);
  final selectedText = TextStyle(
      fontSize: 13, fontWeight: FontWeight.normal, color: AppColors.appPurple);
  final buildingText = TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.normal,
      color: AppColors.appDeepGrey);
  final buildingText2 = TextStyle(
      fontSize: 12, fontWeight: FontWeight.normal, color: AppColors.appPurple);
  //SORT firebase data by datetime name
  final Query _events =
      FirebaseFirestore.instance.collection('events').orderBy('dateTime');
  final userDataText = TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.normal,
      color: AppColors.appCharcoal);
  final userDataText2 = const TextStyle(
      fontSize: 9, fontWeight: FontWeight.normal, color: AppColors.appBlack);
  final TextEditingController _searchController = TextEditingController();
  var searchItem = '';
  bool isEdit = false;
  String _valueChanged2 = '';
  String _valueSaved2 = '';
  String _valueToValidate2 = '';
  bool isChecked = false;

  final TextEditingController _dateTimeController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _catsController = TextEditingController();
  final TextEditingController _dogsController = TextEditingController();
  final TextEditingController _otherController = TextEditingController();
  final TextEditingController _photoConsentController = TextEditingController();
  final TextEditingController _parkingController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double getWidth = MediaQuery.of(context).devicePixelRatio.toDouble();
    print(getWidth);
    CollectionReference events =
        FirebaseFirestore.instance.collection('events');

    editDateTime(String id) async {
      await events.doc(id).update({
        'dateTime': _dateTimeController.text,
      });
    }

    editDuration(String id) async {
      await events.doc(id).update({
        'duration': _durationController.text,
      });
    }

    editParking(String id) async {
      await events.doc(id).update({
        'parking': _parkingController.text,
      });
    }

    editDogs(String id) async {
      await events.doc(id).update({
        'dogs': _dogsController.text,
      });
    }

    editCats(String id) async {
      await events.doc(id).update({
        'cats': _catsController.text,
      });
    }

    editOther(String id) async {
      await events.doc(id).update({
        'other': _otherController.text,
      });
    }

    editNotes(String id) async {
      await events.doc(id).update({
        'notes': _notesController.text,
      });
    }

    editPhoto(String id) async {
      await events.doc(id).update({
        'photoConsent': isChecked,
      });
    }

    Future<void> dateAndTimeChange(BuildContext context, String id) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Update Date and Time'),
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
              content: DateTimePicker(
                  type: DateTimePickerType.dateTime,
                  dateMask: 'd MMMM, yyyy - HH:mm',
                  controller: _dateTimeController,
                  firstDate: DateTime(2022),
                  lastDate: DateTime(2200),
                  icon: const Icon(Icons.event),
                  dateLabelText: 'Date Time',
                  use24HourFormat: false,
                  locale: const Locale('en', 'US'),
                  onChanged: (val) {
                    setState(() {
                      editDateTime(id);
                      _valueChanged2 = val;
                    });
                    print("The time/date value in onChanged: $_valueChanged2");
                  },
                  validator: (val) {
                    setState(() => _valueToValidate2 = val ?? '');
                    return null;
                  },
                  onSaved: (val) {
                    setState(() => _valueSaved2 = val ?? '');
                    print(_valueSaved2);
                  }),
            );
          }); //.then((value) => Navigator.pop(context));
    }

    Future<void> durationChange(BuildContext context, String id) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: const Text('Update Duration'),
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
                content: TextFormField(
                    controller: _durationController,
                    keyboardType: TextInputType.number,
                    onChanged: (val) {
                      setState(() {
                        editDuration(id);
                      });
                      // print("The time/date value in onChanged: $_valueChanged2");
                    },
                    // inputFormatters: [
                    //   FilteringTextInputFormatter.digitsOnly
                    // ],
                    decoration: const InputDecoration(
                      icon: Icon(Icons.timelapse),
                      hintText: 'duration of event in hrs',
                      labelText: 'duration of event',
                      fillColor: Colors.white24,
                      filled: true,
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Name field is empty';
                      }
                    }));
          });
    }

    Future<void> parkingChange(BuildContext context, String id) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: const Text('Update Duration'),
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
                content: TextFormField(
                    controller: _parkingController,
                    keyboardType: TextInputType.number,
                    onChanged: (val) {
                      setState(() {
                        editParking(id);
                      });
                    },
                    decoration: const InputDecoration(
                      icon: Icon(Icons.timelapse),
                      hintText: 'where do we park?',
                      labelText: 'where do we park?',
                      fillColor: Colors.white24,
                      filled: true,
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Name field is empty';
                      }
                    }));
          });
    }

    Future<void> dogsChange(BuildContext context, String id) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: const Text('Update # of Dogs'),
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
                content: TextFormField(
                    controller: _dogsController,
                    keyboardType: TextInputType.number,
                    onChanged: (val) {
                      setState(() {
                        editDogs(id);
                      });
                    },
                    decoration: const InputDecoration(
                      icon: Icon(Icons.timelapse),
                      hintText: 'how many dogs?',
                      labelText: 'how many dogs?',
                      fillColor: Colors.white24,
                      filled: true,
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Name field is empty';
                      }
                    }));
          });
    }

    Future<void> catsChange(BuildContext context, String id) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: const Text('Update # of Cats'),
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
                content: TextFormField(
                    controller: _catsController,
                    keyboardType: TextInputType.number,
                    onChanged: (val) {
                      setState(() {
                        editCats(id);
                      });
                    },
                    decoration: const InputDecoration(
                      icon: Icon(Icons.timelapse),
                      hintText: 'how many cats?',
                      labelText: 'how many cats?',
                      fillColor: Colors.white24,
                      filled: true,
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Name field is empty';
                      }
                    }));
          });
    }

    Future<void> otherChange(BuildContext context, String id) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: const Text('Update # of Other Animals'),
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
                content: TextFormField(
                  controller: _otherController,
                  keyboardType: TextInputType.number,
                  onChanged: (val) {
                    setState(() {
                      editOther(id);
                    });
                  },
                  decoration: const InputDecoration(
                    icon: Icon(Icons.timelapse),
                    hintText: 'how many other animals?',
                    labelText: 'how many other animals?',
                    fillColor: Colors.white24,
                    filled: true,
                    border: OutlineInputBorder(),
                  ),
                  // validator: (value) {
                  //   if (value!.isEmpty) {
                  //     return 'Name field is empty';
                  //   }
                  // }
                ));
          });
    }

    Future<void> notesChange(BuildContext context, String id) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: const Text('Update notes'),
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
                content: TextFormField(
                    controller: _notesController,
                    // keyboardType: TextInputType.number,
                    onChanged: (val) {
                      setState(() {
                        editNotes(id);
                      });
                    },
                    decoration: const InputDecoration(
                      icon: Icon(Icons.timelapse),
                      hintText: 'edit notes',
                      labelText: 'edit notes',
                      fillColor: Colors.white24,
                      filled: true,
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Name field is empty';
                      }
                    }));
          });
    }

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false, //prevent the back arrow
          title: const Text("Events"),

          backgroundColor: AppColors.appClay,
          elevation: 0.0,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: SizedBox(
                height: 50,
                child: TextFormField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Enter year',
                    labelText: 'Filter Events by date (e.g., "2022-04")',
                    fillColor: Colors.white24,
                    filled: true,
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (val) {
                    setState(() {
                      searchItem = val;
                      // searchItem.contains(
                      //     RegExp(r'$val', caseSensitive: false));

                      print("search item = $searchItem ");
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'field is empty';
                    }
                  },
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder(
                  stream: (searchItem == "")
                      ? _events.snapshots()
                      : FirebaseFirestore.instance
                          .collection('events')
                          .where("dateTime", isGreaterThanOrEqualTo: searchItem)
                          .where('dateTime', isLessThan: searchItem + 'z')
                          .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasData) {
                      return ListView.separated(
                          itemCount: snapshot.data!.docs.length,
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(),
                          itemBuilder: (context, index) {
                            final DocumentSnapshot eventSnapshot =
                                snapshot.data!.docs[index];

                            return InkWell(
                              onTap: () {
                                print("event ID:  ${eventSnapshot.id}");
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                  // margin: const EdgeInsets.all(5.0),
                                  padding:
                                      const EdgeInsets.fromLTRB(2, 6, 2, 4),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: AppColors.appCharcoal),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: AppColors.appSubtleLine,
                                          offset: Offset(
                                            1.0,
                                            1.0,
                                          ), //Offset
                                          blurRadius: 10.0,
                                          spreadRadius: .5,
                                        ), //BoxShadow
                                      ]),
                                  // height: height / 2,
                                  child: Dismissible(
                                    dismissThresholds: const {
                                      // DismissDirection.startToEnd: 0.1,
                                      DismissDirection.endToStart: 0.8
                                    },
                                    direction: DismissDirection.endToStart,
                                    key: UniqueKey(),
                                    background: Container(
                                      color: Colors.red,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
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
                                            .collection('events')
                                            .doc(eventSnapshot.id)
                                            .delete();
                                      });
                                      const snackBar = SnackBar(
                                        content:
                                            Text('Event Has Been Deleted!'),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    },
                                    child: Card(
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: AppColors.appCharcoal,
                                              width: 1),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        color: Colors.white,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          20, 10, 0, 0),
                                                  child: Center(
                                                    child: CircleAvatar(
                                                      radius: 25,
                                                      child: ClipOval(
                                                        child: Image.network(
                                                          "${eventSnapshot['facilityMap']['facilityImage']}",
                                                          fit: BoxFit.cover,
                                                          width: 50,
                                                          height: 50,
                                                        ),
                                                      ),
                                                    ), //CircleAvatar
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(4, 0, 4, 0),
                                                    child: Center(
                                                      child: AutoSizeText(
                                                          " ${eventSnapshot['facilityMap']['facilityName']}",
                                                          style:
                                                              GoogleFonts.acme(
                                                                  textStyle:
                                                                      headline)),
                                                    ),
                                                  ),
                                                ),
                                                eventSnapshot['photoConsent'] ==
                                                        true
                                                    ? Expanded(
                                                        child: Transform(
                                                          transform:
                                                              Matrix4.identity()
                                                                ..scale(0.67)
                                                                ..right,
                                                          child: Chip(
                                                            avatar:
                                                                const Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .fromLTRB(
                                                                          0,
                                                                          0,
                                                                          0,
                                                                          0),
                                                              child: Icon(
                                                                  Icons.photo),
                                                            ),
                                                            padding:
                                                                const EdgeInsets
                                                                        .fromLTRB(
                                                                    0, 0, 0, 0),
                                                            label: Center(
                                                              child:
                                                                  AutoSizeText(
                                                                "Yes",
                                                                style: GoogleFonts
                                                                    .roboto(
                                                                        textStyle:
                                                                            buildingText),
                                                                // wrapWords: true,
                                                              ),
                                                            ),
                                                            backgroundColor:
                                                                AppColors
                                                                    .appTeal,
                                                            elevation: 3.0,
                                                            shadowColor:
                                                                Colors.grey[60],
                                                          ),
                                                        ),
                                                      )
                                                    : const SizedBox(
                                                        width: 60,
                                                      ),
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      2.0, 0, 2, 10),
                                              child: AutoSizeText(
                                                  "Building: ${eventSnapshot['facilityMap']['facilityBuilding']}",
                                                  style: GoogleFonts.openSans(
                                                      textStyle: buildingText),
                                                  overflowReplacement:
                                                      const Text("")),
                                            ),
                                            const Divider(
                                              color: AppColors.appSubtleLine,
                                              indent: 10,
                                              endIndent: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      2, 2, 2, 2),
                                                  child: Icon(Icons.date_range,
                                                      size: 16),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          2, 2, 2, 2),
                                                  child: AutoSizeText.rich(
                                                    TextSpan(
                                                        text: "Date: ",
                                                        style: GoogleFonts
                                                            .openSans(
                                                                textStyle:
                                                                    headline2),
                                                        children: [
                                                          TextSpan(
                                                            text:
                                                                "${eventSnapshot['dateTime'].toString().substring(0, 10)}",
                                                            style: GoogleFonts
                                                                .roboto(
                                                                    textStyle:
                                                                        buildingText),
                                                            recognizer:
                                                                TapGestureRecognizer()
                                                                  ..onTap = () {
                                                                    setState(
                                                                        () {
                                                                      dateAndTimeChange(
                                                                          context,
                                                                          eventSnapshot
                                                                              .id);
                                                                    });

                                                                    print(
                                                                        "Tapped the date");
                                                                  },
                                                          )
                                                        ]),
                                                    textAlign: TextAlign.center,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                )
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      2, 2, 2, 2),
                                                  child: Icon(Icons.timer,
                                                      size: 16),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          2, 2, 2, 2),
                                                  child: AutoSizeText.rich(
                                                    TextSpan(
                                                        text: "Start Time: ",
                                                        style: GoogleFonts
                                                            .openSans(
                                                                textStyle:
                                                                    headline2),
                                                        children: [
                                                          TextSpan(
                                                            text:
                                                                "${eventSnapshot['dateTime'].toString().substring(11, 16)}",
                                                            style: GoogleFonts
                                                                .roboto(
                                                                    textStyle:
                                                                        buildingText),
                                                          )
                                                        ]),
                                                    textAlign: TextAlign.center,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      2, 2, 2, 2),
                                              child: AutoSizeText.rich(
                                                TextSpan(
                                                    text: "Event Duration:",
                                                    style: GoogleFonts.openSans(
                                                        textStyle: headline2),
                                                    children: [
                                                      TextSpan(
                                                          text:
                                                              " ${eventSnapshot['duration']}",
                                                          style: GoogleFonts.roboto(
                                                              textStyle:
                                                                  buildingText),
                                                          recognizer:
                                                              TapGestureRecognizer()
                                                                ..onTap = () {
                                                                  setState(() {
                                                                    durationChange(
                                                                        context,
                                                                        eventSnapshot
                                                                            .id);
                                                                  });
                                                                  print(
                                                                      "Tapped the duration");
                                                                })
                                                    ]),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            const Divider(
                                              color: AppColors.appSubtleLine,
                                              indent: 10,
                                              endIndent: 10,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 4, 10, 10),
                                              child: Container(
                                                // color: Colors.amber,
                                                // width: width,
                                                // height: height / 16,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          2, 10, 2, 10),
                                                  child: Wrap(children: [
                                                    AutoSizeText.rich(
                                                      TextSpan(
                                                        text: "Parking:",
                                                        style: GoogleFonts
                                                            .openSans(
                                                                textStyle:
                                                                    headline2),
                                                        children: [
                                                          TextSpan(
                                                              text:
                                                                  " ${eventSnapshot['parking']}",
                                                              style: GoogleFonts
                                                                  .roboto(
                                                                      textStyle:
                                                                          buildingText),
                                                              recognizer:
                                                                  TapGestureRecognizer()
                                                                    ..onTap =
                                                                        () {
                                                                      setState(
                                                                          () {
                                                                        parkingChange(
                                                                            context,
                                                                            eventSnapshot.id);
                                                                      });
                                                                      print(
                                                                          "Tapped the parking");
                                                                    })
                                                        ],
                                                      ),
                                                      textAlign:
                                                          TextAlign.start,
                                                      maxLines: 4,
                                                      minFontSize: 11,
                                                      stepGranularity: .1,
                                                      overflow:
                                                          TextOverflow.clip,
                                                      softWrap: true,
                                                      wrapWords: true,
                                                      maxFontSize: 14,
                                                    ),
                                                  ]),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      50, 0, 50, 0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Expanded(
                                                    child: Container(
                                                      decoration:
                                                          const BoxDecoration(
                                                        color: AppColors
                                                            .appSubtleLine,
                                                        image: DecorationImage(
                                                          image: NetworkImage(
                                                            "https://firebasestorage.googleapis.com/v0/b/vpr-co-project.appspot.com/o/dog.png?alt=media&token=61e1a4bb-4bc5-4b46-90bd-159d54fedf08",
                                                          ),
                                                          // fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                      height: 50,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 18),
                                                  Expanded(
                                                    child: Container(
                                                      child: Image.network(
                                                        "https://firebasestorage.googleapis.com/v0/b/vpr-co-project.appspot.com/o/cat.png?alt=media&token=8adf387a-9de8-44ae-aae2-588f15cfac00",
                                                        // fit: BoxFit.cover,
                                                        // width: 45,
                                                        // height: 45,
                                                      ),
                                                      color: AppColors.appTeal,
                                                      height: 50,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 18),
                                                  Expanded(
                                                    child: Container(
                                                      child: Image.network(
                                                        "https://firebasestorage.googleapis.com/v0/b/vpr-co-project.appspot.com/o/other.png?alt=media&token=3fc33b83-e934-435b-83c9-c12e3ca95909",
                                                        // fit: BoxFit.cover,
                                                        // width: 45,
                                                        // height: 45,
                                                      ),
                                                      color:
                                                          AppColors.appPurple,
                                                      height: 50,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      50, 0, 50, 0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Expanded(
                                                    child: Container(
                                                      height: 26,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(0.0),
                                                        child: TextButton(
                                                          child: Text(
                                                              eventSnapshot[
                                                                  'dogs'],
                                                              style: GoogleFonts
                                                                  .roboto(
                                                                textStyle:
                                                                    headline2,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center),
                                                          onPressed: () {
                                                            setState(() {
                                                              dogsChange(
                                                                  context,
                                                                  eventSnapshot
                                                                      .id);
                                                            });
                                                            print(
                                                                "number of dogs");
                                                          },
                                                        ),
                                                      ),
                                                      // width: 45,
                                                      // height: 45,
                                                      color: AppColors
                                                          .appSubtleLine,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 18),
                                                  Expanded(
                                                    child: Container(
                                                      height: 26,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(0.0),
                                                        child: TextButton(
                                                          child: Text(
                                                              eventSnapshot[
                                                                  'cats'],
                                                              style: GoogleFonts
                                                                  .roboto(
                                                                textStyle:
                                                                    headline2,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center),
                                                          onPressed: () {
                                                            setState(() {
                                                              catsChange(
                                                                  context,
                                                                  eventSnapshot
                                                                      .id);
                                                            });
                                                            print(
                                                                "number of cats");
                                                          },
                                                        ),
                                                      ),
                                                      // width: 45,
                                                      // height: 45,
                                                      color: AppColors.appTeal,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 18),
                                                  Expanded(
                                                    child: Container(
                                                      height: 26,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(0.0),
                                                        child: TextButton(
                                                          child: Text(
                                                              eventSnapshot[
                                                                  'other'],
                                                              style: GoogleFonts
                                                                  .roboto(
                                                                textStyle:
                                                                    headline2,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center),
                                                          onPressed: () {
                                                            setState(() {
                                                              otherChange(
                                                                  context,
                                                                  eventSnapshot
                                                                      .id);
                                                            });
                                                            print(
                                                                "number of other animals");
                                                          },
                                                        ),
                                                      ),
                                                      // width: 45,
                                                      // height: 45,
                                                      color:
                                                          AppColors.appPurple,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const Divider(
                                              color: AppColors.appSubtleLine,
                                              indent: 10,
                                              endIndent: 10,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10.0, 0, 10, 0),
                                              child: AutoSizeText.rich(
                                                TextSpan(
                                                    text: "Notes:",
                                                    style: GoogleFonts.openSans(
                                                        textStyle: headline2),
                                                    children: [
                                                      TextSpan(
                                                          text:
                                                              " ${eventSnapshot['notes']}",
                                                          style: GoogleFonts.roboto(
                                                              textStyle:
                                                                  buildingText),
                                                          recognizer:
                                                              TapGestureRecognizer()
                                                                ..onTap = () {
                                                                  setState(() {
                                                                    notesChange(
                                                                        context,
                                                                        eventSnapshot
                                                                            .id);
                                                                  });
                                                                  print(
                                                                      "Tapped the notes");
                                                                })
                                                    ]),
                                                textAlign: TextAlign.start,
                                                maxLines: 4,
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(""),
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ProductEvents(
                                                                    id: eventSnapshot
                                                                        .id,
                                                                  )));
                                                      // Navigator.pushNamed(
                                                      //     context,
                                                      //     ProductEvents
                                                      //         .routeName,
                                                      //     arguments: ProductEventArguments(
                                                      //      "my name",
                                                      //         "Foo"));
                                                    },
                                                    child: Text("Products",
                                                        style: GoogleFonts.andika(
                                                            textStyle:
                                                                buildingText2)))
                                              ],
                                            )
                                          ],
                                        )),
                                  ),
                                ),
                              ),
                            );
                          });
                    }
                    return const SizedBox();
                  }),
            ),
          ],
        ));
  }
}

class ScreenArguments {
  final String id;
  final String address;
  final String building;
  final String contact;
  final String facilityName;
  final String image;
  final String location;
  final String phone;

  ScreenArguments(this.id, this.address, this.building, this.contact,
      this.facilityName, this.image, this.location, this.phone);
}

class EventArguments {
  final String id;
  final String building;
  final String facilityName;

  EventArguments(
    this.id,
    this.building,
    this.facilityName,
  );
}

class ProductEventArguments {
  final String id;

  ProductEventArguments(
    this.id,
  );
}
