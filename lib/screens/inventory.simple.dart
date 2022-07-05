import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';

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
  var catFoodCount = 0;
  var catLitterCount = 0;
  var catToysCount = 0;
  var catTreatsCount = 0;
  var diapersCount = 0;
  var dogBedCount = 0;
  var dogFoodCount = 0;
  var dogHarnessCount = 0;
  var dogToysCount = 0;
  var dogTreatsCount = 0;
  var peePadsCount = 0;

  final chartTitle = TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.normal,
      color: AppColors.appDeepGrey);

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
      INVData('Cat Food', catFoodCount),
      INVData('Cat Litter', catLitterCount),
      INVData('Cat Toys', catToysCount),
      INVData('Cat Treats', catTreatsCount),
      INVData('Diapers', diapersCount),
      INVData('Dog Beds', dogBedCount),
      INVData('Dog Food', dogFoodCount),
      INVData('Dog Harness', dogHarnessCount),
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
        if (element == "Dog Food") {
          dogFoodCount = dogFoodCount + 1;
        } else if (element == "Blankets") {
          blanketsCount = blanketsCount + 1;
        } else if (element == "Cat Collars") {
          catCollarsCount = catCollarsCount + 1;
        } else if (element == "Cat Food") {
          catFoodCount = catFoodCount + 1;
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
        } else if (element == "Dog Harness") {
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
      body: Column(
        children: [
//THE CHART
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  margin: const EdgeInsets.all(1.0),
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
        ],
      ),
    );
  }
}

//our chart model - two elements, category and count of each category
class INVData {
  INVData(this.category, this.count);
  final String category;
  final int count;
}
