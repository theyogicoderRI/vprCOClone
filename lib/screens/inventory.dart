import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

import 'package:vpr_co/shared/inventory_categories.dart';
import 'package:vpr_co/services/colors.dart' as AppColors;

import 'package:google_fonts/google_fonts.dart';

import 'package:syncfusion_flutter_charts/charts.dart'; //charting package

class Inventory extends StatefulWidget {
  const Inventory({Key? key}) : super(key: key);

  @override
  State<Inventory> createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  late List<INVData> _chartData = []; // we define a list to show the data
  late List _newData = []; //this list we use to count FB categories
  late TooltipBehavior _tooltipBehavior; //define a tool tip

  var blanketsCount = 0;
  var catCollarsCount = 0;
  var cFSampleCount = 0;
  var cFMediumCount = 0;
  var cFLargeCount = 0;
  var catLitterCount = 0;
  var catToysCount = 0;
  var catTreatsCount = 0;
  var diapersCount = 0;
  var dogBedCount = 0;
  var dFSampleCount = 0;
  var dFMediumCount = 0;
  var dFLargeCount = 0;
  var dogHarnessCount = 0;
  var dogToysCount = 0;
  var dogTreatsCount = 0;
  var peePadsCount = 0;

  var map = Map();

  final headline = TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.normal,
      color: AppColors.appDeepGrey);
  final chartTitle = TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.normal,
      color: AppColors.appDeepGrey);

  //data for the categories for the horizontal ListView -SORT firebase data by categories
  final Query _inventoryCat = FirebaseFirestore.instance
      .collection('inventoryCats')
      .orderBy('category');

  final CollectionReference snapShotsValue =
      FirebaseFirestore.instance.collection('inventory');

  //collection for inventory data
  final CollectionReference fireData =
      FirebaseFirestore.instance.collection('inventory');

  //initiate the data we show in the chart
  void initState() {
    getDataFromFireStore();
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  //function to get the data
  //this is what actually gets plotted to the chart
  List<INVData> getChartData() {
    final List<INVData> chartData = [
      INVData('Blankets', blanketsCount),
      INVData('Cat Collars', catCollarsCount),
      INVData('CF-Sample', cFSampleCount),
      INVData('CF-Medium', cFMediumCount),
      INVData('CF-Large', cFLargeCount),
      INVData('Cat Litter', catLitterCount),
      INVData('Cat Toys', catToysCount),
      INVData('Cat Treats', catTreatsCount),
      INVData('Diapers', diapersCount),
      INVData('Dog Beds', dogBedCount),
      INVData('DF-Sample', dFSampleCount),
      INVData('DF-Medium', dFMediumCount),
      INVData('DF-Large', dFLargeCount),
      INVData('Dog Harnesses', dogHarnessCount),
      INVData('Dog Toys', dogToysCount),
      INVData('Dog Treats', dogTreatsCount),
      INVData('Pee Pads', peePadsCount),
    ];
//we return the list data here
    return chartData;
  }

//gets the counts from firestore
  Future<void> getDataFromFireStore() async {
    //this gets the collection data
    var snapShotsValue =
        await FirebaseFirestore.instance.collection("inventory").get();

    // this maps the FB category field to a list
    List list = snapShotsValue.docs.map((e) => (e.data()['category'])).toList();
    _newData = list; //regular empty list = this mapped list

    // this sets the state loading the list into our empty _chartData list
    setState(() {
      // this traverses _newList and counts each category for our inventory
      // and adds to the count int variables for each instance it finds for a category
      //note can't be element.category, that won't work
      _newData.forEach((element) {
        if (element == "DF-Sample") {
          dFSampleCount = dFSampleCount + 1;
        } else if (element == "DF-Medium") {
          dFMediumCount = dFMediumCount + 1;
        } else if (element == "DF-Large") {
          dFLargeCount = dFLargeCount + 1;
        } else if (element == "Blankets") {
          blanketsCount = blanketsCount + 1;
        } else if (element == "Cat Collars") {
          catCollarsCount = catCollarsCount + 1;
        } else if (element == "CF-Sample") {
          cFSampleCount = cFSampleCount + 1;
        } else if (element == "CF-Medium") {
          cFMediumCount = cFMediumCount + 1;
        } else if (element == "CF-Large") {
          cFLargeCount = cFLargeCount + 1;
        } else if (element == "Cat Litter") {
          catLitterCount = catLitterCount + 1;
        } else if (element == "Cat Toys") {
          catToysCount = catToysCount + 1;
        } else if (element == "Cat Treats") {
          catTreatsCount = catTreatsCount + 1;
        } else if (element == "Diapers") {
          diapersCount = diapersCount + 1;
        } else if (element == "Dog Beds") {
          dogBedCount = dogBedCount + 1;
        } else if (element == "Dog Harnesses") {
          dogHarnessCount = dogHarnessCount + 1;
        } else if (element == "Dog Toys") {
          dogToysCount = dogToysCount + 1;
        } else if (element == "Dog Treats") {
          dogTreatsCount = dogTreatsCount + 1;
        } else if (element == "Pee Pads") {
          peePadsCount = peePadsCount + 1;
        }
      });

//toDO key here is when to call this and that is after the if statements
      _chartData = getChartData(); //Key to call this here
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false, //prevent the back arrow
          title: const Text("Current Inventory"),

          backgroundColor: AppColors.appClay,
          elevation: 0.0,
        ),
        body: Column(children: [
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
              stream: _inventoryCat.snapshots(),
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

          //NEW CHART

          // StreamBuilder<void>(
          //     stream: fireData.snapshots(),
          //     builder: (BuildContext context, AsyncSnapshot snapshot) {
          //       if (snapshot.hasData) {
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
                      BarSeries<INVData, String>(
                          sortingOrder: SortingOrder.descending,
                          sortFieldValueMapper: (INVData inv, _) =>
                              inv.category,
                          name: 'Inventory Counts',
                          color: AppColors.appTeal,
                          dataSource: _chartData,
                          xValueMapper: (INVData inv, _) => inv.category,
                          yValueMapper: (INVData inv, _) => inv.count,
                          dataLabelSettings: DataLabelSettings(isVisible: true),
                          enableTooltip: true)
                    ],
                    primaryXAxis: CategoryAxis(),
                    primaryYAxis: NumericAxis(
                        edgeLabelPlacement: EdgeLabelPlacement.shift,
                        title: AxisTitle(text: "Item Counts")),
                  )),
            ),
          ),
          //   }
          //   return const Text("HI THERE");
        ]));
  }
}

class INVData {
  INVData(this.category, this.count);
  final String category;
  final int count;
}
