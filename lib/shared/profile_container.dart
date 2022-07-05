import 'package:flutter/material.dart';
import 'package:vpr_co/services/colors.dart' as AppColors;
import 'package:google_fonts/google_fonts.dart';
import 'package:auto_size_text/auto_size_text.dart';

class ProfileCustomContainer extends StatelessWidget {
  String? userVariable = "";
  IconData? myIcon = Icons.favorite;
  Color? myColor = Colors.black;
  final userDataText = TextStyle(
      fontSize: 20, fontWeight: FontWeight.w500, color: AppColors.appCharcoal);

  ProfileCustomContainer(
      {Key? key, this.userVariable, this.myIcon, this.myColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
        // width: width - 75,
        // height: height - 100,
        margin: const EdgeInsets.all(1.0),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.8),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
            color: Colors.tealAccent.withOpacity(0.25),
            shape: BoxShape.rectangle,
            border: Border.all(width: 1.5, color: Colors.black54)),
        child: userVariable != null
            ? Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        7,
                        8,
                        2,
                        8,
                      ),
                      child: setttingWidget(myIcon!, myColor!),
                    ),
                    Flexible(
                      child: FittedBox(
                          child: AutoSizeText(
                        " $userVariable",
                        style: GoogleFonts.roboto(textStyle: userDataText),
                        maxLines: 1,
                        minFontSize: 10,
                        stepGranularity: 10,
                        overflow: TextOverflow.fade,
                      )),
                    ),
                  ],
                ),
              )
            : const Text(
                "",
              ));
  }
}

//
class setttingWidget extends StatelessWidget {
  final IconData next;
  Color myColor;

  setttingWidget(this.next, this.myColor);

  @override
  Widget build(BuildContext context) {
    return Icon(next, color: myColor);
  }
}
