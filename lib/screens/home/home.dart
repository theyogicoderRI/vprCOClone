import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:vpr_co/screens/authenticate/register.dart';
import 'package:vpr_co/screens/authenticate/signin.dart';
import 'package:vpr_co/services/auth.dart';
import 'package:vpr_co/services/colors.dart' as AppColors;
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var teamPix =
      'https://firebasestorage.googleapis.com/v0/b/vpr-co-project.appspot.com/o/VPR-CO-GANG-PixTeller.png?alt=media&token=893f4b96-6280-4a4f-9533-213b36b25838';
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

  @override
  Widget build(BuildContext context) {
    final Query _events = FirebaseFirestore.instance
        .collection('events')
        .orderBy('dateTime')
        .limit(3);
    final userDataText = TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: AppColors.appCharcoal);
    return Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          automaticallyImplyLeading: false, //prevent the back arrow
          title: _auth.getDisplayName != null
              ? const Text("Vintage Pet Rescue")
              : const Text("Welcome to VPR"),
          backgroundColor: AppColors.appClay,
          elevation: 0.0,
          actions: [
            TextButton.icon(
                onPressed: () {
                  setState(() {
                    _auth.signOut();
                    Navigator.pushNamed(context, '/signIn');
                  });
                  // don't need to assign
                  print("log out");
                },
                icon: const Icon(Icons.person, color: Colors.white70),
                label: const Text("Sign out",
                    style: TextStyle(color: Colors.white70)))
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: _auth.getDisplayName != null
                  ? Text("Hi ${_auth.getDisplayName}  ",
                      style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                          fontWeight: FontWeight.bold))
                  : const Text(
                      "",
                      style: TextStyle(color: Colors.blueAccent, fontSize: 12),
                    ),
            ),
            teamPix != ''
                ? Image.network(teamPix)
                : CircularProgressIndicator(),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                "Recent Events",
                style: GoogleFonts.roboto(textStyle: userDataText),
                textAlign: TextAlign.left,
              ),
            ),
            StreamBuilder(
                stream: _events.snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasData) {
                    return Expanded(
                      child: ListView.separated(
                          // scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.docs.length,
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(),
                          itemBuilder: (context, index) {
                            final DocumentSnapshot eventSnapshot =
                                snapshot.data!.docs[index];

                            return Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Container(
                                padding: const EdgeInsets.fromLTRB(2, 6, 2, 4),
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
                                child: Card(
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: AppColors.appCharcoal,
                                          width: 1),
                                      borderRadius: BorderRadius.circular(20),
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
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        4, 0, 4, 0),
                                                child: Center(
                                                  child: AutoSizeText(
                                                      " ${eventSnapshot['facilityMap']['facilityName']}",
                                                      style: GoogleFonts.acme(
                                                          textStyle: headline)),
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
                                                        avatar: const Padding(
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                                  0, 0, 0, 0),
                                                          child:
                                                              Icon(Icons.photo),
                                                        ),
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                0, 0, 0, 0),
                                                        label: Center(
                                                          child: AutoSizeText(
                                                            "Yes",
                                                            style: GoogleFonts
                                                                .roboto(
                                                                    textStyle:
                                                                        buildingText),
                                                            // wrapWords: true,
                                                          ),
                                                        ),
                                                        backgroundColor:
                                                            AppColors.appTeal,
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
                                          padding: const EdgeInsets.fromLTRB(
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
                                                    style: GoogleFonts.openSans(
                                                        textStyle: headline2),
                                                    children: [
                                                      TextSpan(
                                                        text:
                                                            "${eventSnapshot['dateTime'].toString().substring(0, 10)}",
                                                        style: GoogleFonts.roboto(
                                                            textStyle:
                                                                buildingText),
                                                        recognizer:
                                                            TapGestureRecognizer()
                                                              ..onTap = () {
                                                                setState(() {
                                                                  dateAndTimeChange(
                                                                      context,
                                                                      eventSnapshot
                                                                          .id);
                                                                });
                                                              },
                                                      )
                                                    ]),
                                                textAlign: TextAlign.center,
                                                overflow: TextOverflow.ellipsis,
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
                                              child:
                                                  Icon(Icons.timer, size: 16),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      2, 2, 2, 2),
                                              child: AutoSizeText.rich(
                                                TextSpan(
                                                    text: "Start Time: ",
                                                    style: GoogleFonts.openSans(
                                                        textStyle: headline2),
                                                    children: [
                                                      TextSpan(
                                                        text:
                                                            "${eventSnapshot['dateTime'].toString().substring(11, 16)}",
                                                        style: GoogleFonts.roboto(
                                                            textStyle:
                                                                buildingText),
                                                      )
                                                    ]),
                                                textAlign: TextAlign.center,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
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
                                                  )
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
                                          padding: const EdgeInsets.fromLTRB(
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
                                                    style: GoogleFonts.openSans(
                                                        textStyle: headline2),
                                                    children: [
                                                      TextSpan(
                                                        text:
                                                            " ${eventSnapshot['parking']}",
                                                        style: GoogleFonts.roboto(
                                                            textStyle:
                                                                buildingText),
                                                      )
                                                    ],
                                                  ),
                                                  textAlign: TextAlign.start,
                                                  maxLines: 4,
                                                  minFontSize: 11,
                                                  stepGranularity: .1,
                                                  overflow: TextOverflow.clip,
                                                  softWrap: true,
                                                  wrapWords: true,
                                                  maxFontSize: 14,
                                                ),
                                              ]),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              50, 0, 50, 0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Expanded(
                                                child: Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                    color:
                                                        AppColors.appSubtleLine,
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
                                                  color: AppColors.appPurple,
                                                  height: 50,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              50, 0, 50, 0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Expanded(
                                                child: Container(
                                                  height: 26,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            0.0),
                                                    child: TextButton(
                                                      child: Text(
                                                          eventSnapshot['dogs'],
                                                          style: GoogleFonts
                                                              .roboto(
                                                            textStyle:
                                                                headline2,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center),
                                                      onPressed: () {
                                                        print("number of dogs");
                                                      },
                                                    ),
                                                  ),
                                                  // width: 45,
                                                  // height: 45,
                                                  color:
                                                      AppColors.appSubtleLine,
                                                ),
                                              ),
                                              const SizedBox(width: 18),
                                              Expanded(
                                                child: Container(
                                                  height: 26,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            0.0),
                                                    child: TextButton(
                                                      child: Text(
                                                          eventSnapshot['cats'],
                                                          style: GoogleFonts
                                                              .roboto(
                                                            textStyle:
                                                                headline2,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center),
                                                      onPressed: () {
                                                        print("number of cats");
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
                                                        const EdgeInsets.all(
                                                            0.0),
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
                                                              TextAlign.center),
                                                      onPressed: () {
                                                        print(
                                                            "number of other animals");
                                                      },
                                                    ),
                                                  ),
                                                  // width: 45,
                                                  // height: 45,
                                                  color: AppColors.appPurple,
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
                                          padding: const EdgeInsets.fromLTRB(
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
                                                  )
                                                ]),
                                            textAlign: TextAlign.start,
                                            maxLines: 4,
                                          ),
                                        ),
                                      ],
                                    )),
                              ),
                            );
                          }),
                    );
                  }
                  return const SizedBox();
                }),
          ],
        ));
  }

  void dateAndTimeChange(BuildContext context, String id) {}
}
