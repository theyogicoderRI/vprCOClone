import 'package:flutter/material.dart';
import 'package:vpr_co/services/colors.dart' as AppColors;
import 'package:google_fonts/google_fonts.dart';
import 'package:auto_size_text/auto_size_text.dart';

class InventoryCategoriesContainer extends StatelessWidget {
  String? category = "";
  IconData? myIcon = Icons.favorite;
  Color? myColor = Colors.black;
  Color? backColor;
  String? image;

  final userDataText = const TextStyle(
      fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.appBlack);

  InventoryCategoriesContainer(
      {Key? key,
      this.category,
      this.myIcon,
      this.myColor,
      this.image,
      this.backColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Container(
        width: width - 275,
        // height: height - 300,
        margin: const EdgeInsets.all(1.0),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.7),
                spreadRadius: 3,
                blurRadius: 5,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
            color: backColor!.withOpacity(0.79),
            shape: BoxShape.rectangle,
            border: Border.all(width: 1.5, color: Colors.grey)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 5),
            Container(
              child: Expanded(
                flex: 1,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(1.0, 1, 1, 0),
                    child: Image.network(
                      image!,
                      // fit: BoxFit.cover,
                      // width: 45,
                      // height: 45,
                    ),
                  ),
                ),
              ),
              // height: 70,
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(2.0, 0, 2, 0),
                  child: AutoSizeText(
                    " $category",
                    style: GoogleFonts.inter(textStyle: userDataText),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    minFontSize: 10,
                    stepGranularity: 10,
                    overflow: TextOverflow.fade,
                  ),
                ),
              ),
            ),
            // Expanded(
            //   flex: 1,
            //   child: Row(
            //     children: [
            //       IconButton(
            //         splashColor: AppColors.appDeepPurple,
            //         splashRadius: 15,
            //         icon: const Icon(
            //           Icons.add_circle,
            //           color: Colors.black38,
            //           size: 17,
            //         ),
            //         alignment: Alignment.bottomRight,
            //         tooltip: 'Add Item',
            //         onPressed: () {
            //           // setState(() {
            //           //   // _volume += 10;
            //           // });
            //           print("Add to category");
            //         },
            //       ),
            //       IconButton(
            //         splashColor: AppColors.appClay,
            //         splashRadius: 15,
            //         icon: const Icon(
            //           Icons.edit_outlined,
            //           color: Colors.black38,
            //           size: 17,
            //         ),
            //         alignment: Alignment.bottomRight,
            //         tooltip: 'Edit',
            //         onPressed: () {
            //           // setState(() {
            //           //   // _volume += 10;
            //           // });
            //           print("edit me");
            //         },
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

//
// class SetttingWidget extends StatelessWidget {
//   final IconData next;
//   Color myColor;
//
//   SetttingWidget(this.next, this.myColor);
//
//   @override
//   Widget build(BuildContext context) {
//     return Icon(next, color: myColor);
//   }
// }
