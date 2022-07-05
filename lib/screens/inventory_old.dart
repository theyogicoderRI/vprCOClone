import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:vpr_co/services/auth.dart';
import 'package:vpr_co/shared/inventory_categories.dart';
import 'package:vpr_co/services/colors.dart' as AppColors;

import 'package:google_fonts/google_fonts.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

// import 'home/add_event.dart';
// import 'home/edit_facility.dart';

class Inventory extends StatefulWidget {
  const Inventory({Key? key}) : super(key: key);

  @override
  State<Inventory> createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  late List<GDPData> _chartData;
  late TooltipBehavior _tooltipBehavior;
  final AuthService _auth = AuthService();
  final headline = TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.normal,
      color: AppColors.appDeepGrey);
  final chartTitle = TextStyle(
      fontSize: 13,
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
  //SORT firebase data by datetime name
  final Query _inventory = FirebaseFirestore.instance
      .collection('inventoryCats')
      .orderBy('category');
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

  void initState() {
    _chartData = getChartData();
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double getWidth = MediaQuery.of(context).devicePixelRatio.toDouble();
    print(getWidth);
    CollectionReference inventory =
        FirebaseFirestore.instance.collection('inventoryCats');

    editDateTime(String id) async {
      await inventory.doc(id).update({
        'dateTime': _dateTimeController.text,
      });
    }

    editDuration(String id) async {
      await inventory.doc(id).update({
        'duration': _durationController.text,
      });
    }

    editParking(String id) async {
      await inventory.doc(id).update({
        'parking': _parkingController.text,
      });
    }

    editDogs(String id) async {
      await inventory.doc(id).update({
        'dogs': _dogsController.text,
      });
    }

    editCats(String id) async {
      await inventory.doc(id).update({
        'cats': _catsController.text,
      });
    }

    editOther(String id) async {
      await inventory.doc(id).update({
        'other': _otherController.text,
      });
    }

    editNotes(String id) async {
      await inventory.doc(id).update({
        'notes': _notesController.text,
      });
    }

    editPhoto(String id) async {
      await inventory.doc(id).update({
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
                  dateMask: 'd MMMM, yyyy - hh:mm a',
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
        title: const Text("Current Inventory"),

        backgroundColor: AppColors.appClay,
        elevation: 0.0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Inventory Categories",
              style: GoogleFonts.inter(textStyle: headline),
            ),
          ),
          SizedBox(
            height: 140,
            child: StreamBuilder(
              stream: _inventory.snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasData) {
                  return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final DocumentSnapshot inventorySnapshot =
                            snapshot.data!.docs[index];
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: InventoryCategoriesContainer(
                            image: inventorySnapshot['image'],
                            category: inventorySnapshot['category'],
                            myIcon: Icons.person,
                            myColor: AppColors.appCharcoal,
                            backColor: Colors.white,
                          ),
                        );
                      });
                }
                return const SizedBox();
              },
            ),
          ),
          const Divider(
            thickness: 2,
          ),
          Center(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                margin: const EdgeInsets.all(1.0),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset:
                            const Offset(0, 2), // changes position of shadow
                      ),
                    ],
                    color: Colors.white.withOpacity(0.79),
                    shape: BoxShape.rectangle,
                    border: Border.all(width: 1.1, color: Colors.grey)),
                height: 380,
                child: SfCartesianChart(
                  title: ChartTitle(
                    text: 'VPR CO Current Inventory',
                    textStyle: GoogleFonts.inter(textStyle: chartTitle),
                  ),
                  legend: Legend(),
                  tooltipBehavior: _tooltipBehavior,
                  series: <ChartSeries>[
                    BarSeries<GDPData, String>(
                        sortingOrder: SortingOrder.descending,
                        sortFieldValueMapper: (GDPData gdp, _) => gdp.continent,
                        name: 'Inventory Counts',
                        color: AppColors.appTeal,
                        dataSource: _chartData,
                        xValueMapper: (GDPData gdp, _) => gdp.continent,
                        yValueMapper: (GDPData gdp, _) => gdp.gdp,
                        dataLabelSettings: DataLabelSettings(isVisible: true),
                        enableTooltip: true)
                  ],
                  primaryXAxis: CategoryAxis(),
                  primaryYAxis: NumericAxis(
                      edgeLabelPlacement: EdgeLabelPlacement.shift,
                      title: AxisTitle(text: "Item Counts")),
                )),
          ))
        ],
      ),
    );
  }

  //function to get the data
  List<GDPData> getChartData() {
    final List<GDPData> chartData = [
      GDPData('Blankets', 20),
      GDPData('Cat Collars', 5),
      GDPData('Cat Food', 29),
      GDPData('Cat Litter', 10),
      GDPData('Cat Toys', 17),
      GDPData('Cat Treats', 22),
      GDPData('Diapers', 15),
      GDPData('Dog Beds', 12),
      GDPData('Dog Food', 40),
      GDPData('Dog Harness', 5),
      GDPData('Dog Toys', 20),
      GDPData('Dog Treats', 20),
      GDPData('Pee Pads', 45),
    ];
    return chartData;
  }
}

class GDPData {
  GDPData(this.continent, this.gdp);
  final String continent;
  final double gdp;
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
