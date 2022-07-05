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

class Facilities extends StatefulWidget {
  const Facilities({Key? key}) : super(key: key);

  @override
  State<Facilities> createState() => _FacilitiesState();
}

class _FacilitiesState extends State<Facilities> {
  final AuthService _auth = AuthService();
  final headline = TextStyle(
      fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.appDeepGrey);
  final headline2 = TextStyle(
      fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.appDeepGrey);
  final selectedText = TextStyle(
      fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.appPurple);
  //SORT firebase data by facility name
  final Query _facilities = FirebaseFirestore.instance
      .collection('facilities')
      .orderBy('facilityName');
  final userDataText = TextStyle(
      fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.appCharcoal);
  final phone = TextStyle(
      fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.appCharcoal);
  final website = TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w500,
      color: AppColors.appWebsiteBlue);
  final contact = TextStyle(
      fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.appDeepGrey);
  final email = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      color: AppColors.appWebsiteBlue);
  final TextEditingController _searchController = TextEditingController();
  var searchItem = '';

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await url.launchUrl(launchUri);
  }

  _launchInBrowser(website) async {
    var theWeb = Uri.parse(website); //strings not allowed must cast to Uri type
    //also URL must be https, not cleartext http
    if (await url.canLaunchUrl(theWeb)) {
      await url.launchUrl(theWeb);
    } else {
      throw 'Could not launch $website';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false, //prevent the back arrow
          title: const Text("Senior Facilities"),

          backgroundColor: AppColors.appClay,
          elevation: 0.0,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 10, 8, 10),
              child: SizedBox(
                height: 40,
                child: TextFormField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search locations (Warwick) Case Sensitive',
                    labelText: 'Search facility locations',
                    fillColor: Colors.white24,
                    filled: true,
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (val) {
                    setState(() {
                      searchItem = val;
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Name field is empty';
                    }
                  },
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: StreamBuilder(
                    stream: (searchItem == "")
                        ? _facilities.snapshots()
                        : FirebaseFirestore.instance
                            .collection('facilities')
                            .where("location",
                                isGreaterThanOrEqualTo: searchItem)
                            .where('location', isLessThan: searchItem + 'z')
                            .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasData) {
                        return ListView.separated(
                            itemCount: snapshot.data!.docs.length,
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const Divider(),
                            itemBuilder: (context, index) {
                              final DocumentSnapshot facilitySnapshot =
                                  snapshot.data!.docs[index];
                              return Column(
                                //everything on the page is in this column except the Search box
                                children: [
                                  InkWell(
                                    onTap: () {
                                      // print(facilitySnapshot.id);

                                      Navigator.pushNamed(
                                          context, EditFacility.routeName,
                                          arguments: ScreenArguments(
                                              facilitySnapshot.id,
                                              facilitySnapshot['address'],
                                              facilitySnapshot['building'],
                                              facilitySnapshot['contact'],
                                              facilitySnapshot['facilityName'],
                                              facilitySnapshot['image'],
                                              facilitySnapshot['location'],
                                              facilitySnapshot['phone'],
                                              facilitySnapshot['cell'],
                                              facilitySnapshot['website'],
                                              facilitySnapshot['unitCount'],
                                              facilitySnapshot['email']));
                                    },
                                    // the container has everything except the Add event
                                    child: Container(
                                      margin: const EdgeInsets.all(1.0),
                                      padding: const EdgeInsets.all(4.0),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              color: AppColors.appSubtleLine),
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
                                      // height: 200,
                                      child: Column(children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Flexible(
                                              flex: 1,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Image.network(
                                                  facilitySnapshot['image'],
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 1,
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .fromLTRB(
                                                        8.0, 8.0, 8.0, 4),
                                                    child: AutoSizeText(
                                                      Cap.capitalizeOnlyFirstLetter(
                                                          facilitySnapshot[
                                                              'facilityName']),
                                                      style: GoogleFonts
                                                          .zenMaruGothic(
                                                              textStyle:
                                                                  headline),
                                                      textAlign:
                                                          TextAlign.center,
                                                      maxLines: 3,
                                                    ),
                                                  ),
                                                  Divider(
                                                    height: 4,
                                                    thickness: 3,
                                                    indent: 4,
                                                    endIndent: 4,
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .fromLTRB(
                                                        8.0, 8.0, 8.0, 4),
                                                    child: AutoSizeText(
                                                      Cap.capitalizeOnlyFirstLetter(
                                                          facilitySnapshot[
                                                              'address']),
                                                      style: GoogleFonts
                                                          .zenMaruGothic(
                                                              textStyle:
                                                                  headline),
                                                      textAlign:
                                                          TextAlign.center,
                                                      maxLines: 3,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .fromLTRB(
                                                        8.0, 8.0, 8.0, 4),
                                                    child: AutoSizeText(
                                                      Cap.capitalizeOnlyFirstLetter(
                                                          facilitySnapshot[
                                                              'location']),
                                                      style: GoogleFonts
                                                          .zenMaruGothic(
                                                              textStyle:
                                                                  headline),
                                                      textAlign:
                                                          TextAlign.center,
                                                      maxLines: 3,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .fromLTRB(
                                                        8.0, 8.0, 8.0, 4),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        _launchInBrowser(
                                                            facilitySnapshot[
                                                                'website']);
                                                      },
                                                      child: AutoSizeText(
                                                        facilitySnapshot[
                                                            'website'],
                                                        style: GoogleFonts
                                                            .zenMaruGothic(
                                                                textStyle:
                                                                    website),
                                                        textAlign:
                                                            TextAlign.center,
                                                        maxLines: 3,
                                                      ),
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                1.0,
                                                                8.0,
                                                                1.0,
                                                                4),
                                                        child: Text("units:",
                                                            style: GoogleFonts
                                                                .zenMaruGothic(
                                                                    textStyle:
                                                                        userDataText)),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                1.0,
                                                                8.0,
                                                                1.0,
                                                                4),
                                                        child: AutoSizeText(
                                                          facilitySnapshot[
                                                                  'unitCount']
                                                              .toString(),
                                                          style: GoogleFonts
                                                              .zenMaruGothic(
                                                                  textStyle:
                                                                      userDataText),
                                                          textAlign:
                                                              TextAlign.center,
                                                          maxLines: 3,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Divider(
                                          height: 4,
                                          thickness: 3,
                                          indent: 4,
                                          endIndent: 4,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Flexible(
                                              flex: 15,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        5.0, 5.0, 5.0, 4),
                                                child: AutoSizeText(
                                                  Cap.capitalizeOnlyFirstLetter(
                                                      facilitySnapshot[
                                                          'contact']),
                                                  style:
                                                      GoogleFonts.zenMaruGothic(
                                                          textStyle: contact),
                                                  textAlign: TextAlign.center,
                                                  maxLines: 3,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      2.0, 5.0, 5.0, 4),
                                              child: Text("|"),
                                            ),
                                            Flexible(
                                              flex: 15,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        2, 5.0, 5.0, 4),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    final Uri launchUri = Uri(
                                                        scheme: 'mailto',
                                                        path: facilitySnapshot[
                                                            'email'],
                                                        queryParameters: {
                                                          'subject':
                                                              'VPR-CO-Outreach Program',
                                                          'body': 'Hello!'
                                                        });
                                                    url.launchUrl(
                                                        launchUri); // this can not be a string
                                                  },
                                                  child: AutoSizeText(
                                                    facilitySnapshot['email'],
                                                    style: GoogleFonts
                                                        .zenMaruGothic(
                                                            textStyle: email),
                                                    textAlign: TextAlign.center,
                                                    maxLines: 3,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      2.0, 5.0, 5.0, 4),
                                              child: Text(
                                                "w:",
                                                style:
                                                    GoogleFonts.zenMaruGothic(
                                                        textStyle:
                                                            userDataText),
                                              ),
                                            ),
                                            facilitySnapshot['phone']
                                                        .toString()
                                                        .length <
                                                    10
                                                ? AutoSizeText(
                                                    facilitySnapshot['phone'],
                                                    style: GoogleFonts
                                                        .zenMaruGothic(
                                                            textStyle:
                                                                userDataText),
                                                  )
                                                : Flexible(
                                                    flex: 20,
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          2.0, 5.0, 5.0, 4),
                                                      child: AutoSizeText(
                                                        "(${facilitySnapshot.get('phone').toString().substring(0, 3)})"
                                                        "${facilitySnapshot.get('phone').toString().substring(3, 6)}-"
                                                        "${facilitySnapshot.get('phone').toString().substring(6, 10)}",
                                                        style: GoogleFonts
                                                            .zenMaruGothic(
                                                                textStyle:
                                                                    phone),
                                                      ),
                                                    ),
                                                  ),
                                            Transform.translate(
                                              offset: Offset(0, 3.0),
                                              child: Container(
                                                child: IconButton(
                                                  icon: const Icon(
                                                      Icons.local_phone,
                                                      size: 18),
                                                  tooltip: 'call phone',
                                                  onPressed: () {
                                                    setState(() {
                                                      _makePhoneCall(
                                                          facilitySnapshot[
                                                              'phone']);
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      2.0, 5.0, 5.0, 4),
                                              child: Text("|"),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      2.0, 5.0, 5.0, 4),
                                              child: Text(
                                                "c:",
                                                style:
                                                    GoogleFonts.zenMaruGothic(
                                                        textStyle:
                                                            userDataText),
                                              ),
                                            ),
                                            facilitySnapshot['cell']
                                                        .toString()
                                                        .length <
                                                    10
                                                ? AutoSizeText(
                                                    facilitySnapshot['cell'],
                                                    style: GoogleFonts
                                                        .zenMaruGothic(
                                                            textStyle: phone),
                                                  )
                                                : Flexible(
                                                    flex: 20,
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          2.0, 5.0, 5.0, 4),
                                                      child: AutoSizeText(
                                                        "(${facilitySnapshot.get('cell').toString().substring(0, 3)})"
                                                        "${facilitySnapshot.get('cell').toString().substring(3, 6)}-"
                                                        "${facilitySnapshot.get('cell').toString().substring(6, 10)}",
                                                        style: GoogleFonts
                                                            .zenMaruGothic(
                                                                textStyle:
                                                                    phone),
                                                      ),
                                                    ),
                                                  ),
                                            Transform.translate(
                                              offset: Offset(0, 3.0),
                                              child: Container(
                                                child: IconButton(
                                                  icon: const Icon(
                                                      Icons.local_phone,
                                                      size: 18),
                                                  tooltip: 'call phone',
                                                  onPressed: () {
                                                    setState(() {
                                                      _makePhoneCall(
                                                          facilitySnapshot[
                                                              'cell']);
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ]),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text("Add Event"),
                                      IconButton(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 4, 0),
                                          alignment: Alignment.topCenter,
                                          icon: const Icon(Icons.add_box),
                                          color: AppColors.appPurple,
                                          onPressed: () {
                                            print(facilitySnapshot['image']);

                                            Navigator.pushNamed(
                                                context, AddEvent.routeName,
                                                arguments: EventArguments(
                                                  facilitySnapshot.id,
                                                  facilitySnapshot['building'],
                                                  facilitySnapshot[
                                                      'facilityName'],
                                                  facilitySnapshot['image'],
                                                ));
                                          }),
                                    ],
                                  ),
                                ],
                              );
                            });
                      }
                      return const SizedBox();
                    }),
              ),
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
  final String cell;
  final String website;
  final int unitCount;
  final String email;

  ScreenArguments(
      this.id,
      this.address,
      this.building,
      this.contact,
      this.facilityName,
      this.image,
      this.location,
      this.phone,
      this.cell,
      this.website,
      this.unitCount,
      this.email);
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
