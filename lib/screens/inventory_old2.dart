import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';

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
  late List<INVData> _chartData; // we define a list to show the data
  late TooltipBehavior _tooltipBehavior; //define a tool tip

  var map = Map();
  // var myChartData = ChartData();

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

  //query for the inventory data
  final Query _dogFood = FirebaseFirestore.instance
      .collection('inventory')
      .where("category", isEqualTo: "Dog Food");

  int catCount = 0;

  Future<int> countDocuments(String cat) async {
    QuerySnapshot _myDoc = await FirebaseFirestore.instance
        .collection('inventory')
        .where("category", isEqualTo: cat)
        .get();
    // print(_myDoc.size);
    catCount = _myDoc.size;
    // List<DocumentSnapshot> _myDocCount = _myDoc.docs;
    return _myDoc.size; // Count of Documents in Collection
  }

  //collection for inventory data
  final CollectionReference fireData =
      FirebaseFirestore.instance.collection('inventory');

  _countNames() {
    FirebaseFirestore.instance.collection("inventory").get().then((snapshot) {
      snapshot.docs.map((element) {
        if (!map.containsKey(element.data()['category'])) {
          map[element.data()['category']] = 1;
        } else {
          map[element.data()['category']] += 1;
        }
      }).toList();
    });
  }

  //initiate the data we show in the chart
  void initState() {
    _chartData = getChartData(); // this pulls the data into this list
    _tooltipBehavior = TooltipBehavior(enable: true);
    print(_chartData.length);
    super.initState();
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

          //OUR chart
          StreamBuilder<void>(
              stream: fireData.snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                Widget widget;
                if (snapshot.hasData) {
                  // List<ChartData> chartData = <ChartData>[];
                  // List newList = [];
                  // myChartData.foo();
                  // for (int index = 0;
                  //     index < snapshot.data!.docs.length;
                  //     index++) {
                  //   DocumentSnapshot documentSnapshot =
                  //       snapshot.data!.docs[index];
                  //   countDocuments('Dog Food');
                  //
                  //   // print("How many counts: $catCount");
                  //   // _countNames();
                  //   // print(map);
                  //   // print(documentSnapshot.get('category'));
                  //   // newList.add(documentSnapshot.get('category'));
                  //   // print(newList);
                  //   // print(_dogFood);
                  //   // here we are storing the data into a list which is used for chart’s data source
                  //   chartData.add(ChartData.fromMap(
                  //       documentSnapshot.data() as Map<String, dynamic>));
                  // }
                  //       return
                  //
                  //         widget = Padding(
                  //         padding: const EdgeInsets.all(4.0),
                  //         child: Container(
                  //             margin: const EdgeInsets.all(1.0),
                  //             decoration: BoxDecoration(
                  //                 borderRadius:
                  //                     const BorderRadius.all(Radius.circular(5)),
                  //                 boxShadow: [
                  //                   BoxShadow(
                  //                     color: Colors.grey.withOpacity(0.5),
                  //                     spreadRadius: 2,
                  //                     blurRadius: 5,
                  //                     offset: const Offset(
                  //                         0, 2), // changes position of shadow
                  //                   ),
                  //                 ],
                  //                 color: Colors.white.withOpacity(0.79),
                  //                 shape: BoxShape.rectangle,
                  //                 border: Border.all(width: 1.1, color: Colors.grey)),
                  //             height: 380,
                  //             child: SfCartesianChart(
                  //               title: ChartTitle(
                  //                 text: 'VPR CO Current Inventory',
                  //                 textStyle: GoogleFonts.inter(textStyle: chartTitle),
                  //               ),
                  //               legend: Legend(),
                  //               primaryXAxis: CategoryAxis(),
                  //               primaryYAxis: NumericAxis(
                  //                   edgeLabelPlacement: EdgeLabelPlacement.shift,
                  //                   title: AxisTitle(text: "Item Counts")),
                  //               tooltipBehavior: _tooltipBehavior,
                  //               series: <ChartSeries<ChartData, dynamic>>[
                  //                 BarSeries<ChartData, dynamic>(
                  //                     sortingOrder: SortingOrder.descending,
                  //                     sortFieldValueMapper: (ChartData data, _) =>
                  //                         data.category,
                  //                     name: 'Inventory Counts',
                  //                     color: AppColors.appTeal,
                  //                     dataSource: chartData,
                  //                     xValueMapper: (INVData inv, _) => inv.category,
                  //                                 yValueMapper: (INVData inv, _) => inv.count,
                  //                     dataLabelSettings:
                  //                         DataLabelSettings(isVisible: true),
                  //                     enableTooltip: true)
                  //               ],
                  //             )),
                  //       );
                  //     }
                  //     return SizedBox();
                  //   },
                  // ),
                  //       StreamBuilder(
                  //         stream: fireData.snapshots(),
                  //         builder:
                  //             (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  //           Widget widget;
                  //           if (!snapshot.hasData) {
                  //             return const Center(child: CircularProgressIndicator());
                  //           }
                  //           if (snapshot.hasData) {
                  //             List<ChartData> chartData = <ChartData>[];
                  //             for (int index = 0;
                  //                 index < snapshot.data!.docs.length;
                  //                 index++) {
                  //               DocumentSnapshot documentSnapshot =
                  //                   snapshot.data!.docs[index];
                  //
                  //               // here we are storing the data into a list which is used for chart’s data source
                  //               chartData.add(ChartData.fromMap(
                  //                   documentSnapshot.data() as Map<String, dynamic>));
                  //             }
                  //
                  // widget = Container(
                  // child: SfCartesianChart(
                  // primaryXAxis: DateTimeAxis(),
                  // series: <ChartSeries<ChartData, dynamic>>[
                  // ColumnSeries<ChartData, dynamic>(
                  // dataSource: chartData,
                  // xValueMapper: (ChartData data, _) => data.xValue,
                  // yValueMapper: (ChartData data, _) => data.yValue)
                  // ],
                  // ));
                  // }
                  // return widget;

                  // return Center(
                  //               child: Padding(
                  //                 padding: const EdgeInsets.all(8.0),
                  //                 child: Container(
                  //                     margin: const EdgeInsets.all(1.0),
                  //                     decoration: BoxDecoration(
                  //                         borderRadius:
                  //                             const BorderRadius.all(Radius.circular(5)),
                  //                         boxShadow: [
                  //                           BoxShadow(
                  //                             color: Colors.grey.withOpacity(0.5),
                  //                             spreadRadius: 2,
                  //                             blurRadius: 5,
                  //                             offset: const Offset(
                  //                                 0, 2), // changes position of shadow
                  //                           ),
                  //                         ],
                  //                         color: Colors.white.withOpacity(0.79),
                  //                         shape: BoxShape.rectangle,
                  //                         border: Border.all(width: 1.1, color: Colors.grey)),
                  //                     height: 380,
                  //                     child: SfCartesianChart(
                  //                       title: ChartTitle(
                  //                         text: 'VPR CO Current Inventory',
                  //                         textStyle: GoogleFonts.inter(textStyle: chartTitle),
                  //                       ),
                  //                       legend: Legend(),
                  //                       tooltipBehavior: _tooltipBehavior,
                  //                       series: <ChartSeries>[
                  //                         BarSeries<INVData, String>(
                  //                             sortingOrder: SortingOrder.descending,
                  //                             sortFieldValueMapper: (INVData inv, _) =>
                  //                                 inv.category,
                  //                             name: 'Inventory Counts',
                  //                             color: AppColors.appTeal,
                  //                             dataSource: _chartData,
                  //                             xValueMapper: (INVData inv, _) => inv.category,
                  //                             yValueMapper: (INVData inv, _) => inv.count,
                  //                             dataLabelSettings:
                  //                                 DataLabelSettings(isVisible: true),
                  //                             enableTooltip: true)
                  //                       ],
                  //                       primaryXAxis: CategoryAxis(),
                  //                       primaryYAxis: NumericAxis(
                  //                           edgeLabelPlacement: EdgeLabelPlacement.shift,
                  //                           title: AxisTitle(text: "Item Counts")),
                  //                     )),
                  //               ),
                  //             );

                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          margin: const EdgeInsets.all(1.0),
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(
                                      0, 2), // changes position of shadow
                                ),
                              ],
                              color: Colors.white.withOpacity(0.79),
                              shape: BoxShape.rectangle,
                              border:
                                  Border.all(width: 1.1, color: Colors.grey)),
                          height: 380,
                          child: SfCartesianChart(
                            title: ChartTitle(
                              text: 'VPR CO Current Inventory',
                              textStyle:
                                  GoogleFonts.inter(textStyle: chartTitle),
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
                                  xValueMapper: (INVData inv, _) =>
                                      inv.category,
                                  yValueMapper: (INVData inv, _) => inv.count,
                                  dataLabelSettings:
                                      DataLabelSettings(isVisible: true),
                                  enableTooltip: true)
                            ],
                            primaryXAxis: CategoryAxis(),
                            primaryYAxis: NumericAxis(
                                edgeLabelPlacement: EdgeLabelPlacement.shift,
                                title: AxisTitle(text: "Item Counts")),
                          )),
                    ),
                  );
                }
                return const SizedBox();
              })
        ],
      ),
    );
  }

  //function to get the data
  List<INVData> getChartData() {
    final List<INVData> chartData = [
      INVData('Blankets', countDocuments('Blankets')),
      INVData('Cat Collars', countDocuments('Cat Collars')),
      INVData('Cat Food', countDocuments('Cat Food')),
      INVData('Cat Litter', countDocuments('Cat Litter')),
      INVData('Cat Toys', countDocuments('Cat Toys')),
      INVData('Cat Treats', countDocuments('Cat Treats')),
      INVData('Diapers', countDocuments('Diapers')),
      INVData('Dog Beds', countDocuments('Dog Beds')),
      INVData('Dog Food', countDocuments('Dog Food')),
      INVData('Dog Harness', countDocuments('Dog Harness')),
      INVData('Dog Toys', countDocuments('Dog Toys')),
      INVData('Dog Treats', countDocuments('Dog Treats')),
      INVData('Pee Pads', countDocuments('Pee Pads')),
    ];
    return chartData;
  }
}

class INVData {
  INVData(this.category, this.count);
  final String category;
  final count;
}

//class for chart to use with firebase
// class ChartData {
//   final String? category;
//   final int? count;
//   ChartData({this.category, this.count});
//   ChartData.fromMap(Map<String, dynamic> dataMap)
//       : category = dataMap['category'],
//         count = dataMap['count'];
//
//   void foo() {
//     print(category);
//   }
// }
