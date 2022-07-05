import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:vpr_co/services/colors.dart' as AppColors;
import 'package:google_fonts/google_fonts.dart';
import 'package:vpr_co/shared/loading.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:intl/intl.dart';
import 'facilities.dart';

class AddEvent extends StatefulWidget {
  const AddEvent({Key? key}) : super(key: key);
  static const routeName = '/add_event';

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> with TickerProviderStateMixin {
  final headline = TextStyle(
      fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.appLinks);
  final selectedText = TextStyle(
      fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.appPurple);

  final Stream<QuerySnapshot> _events =
      FirebaseFirestore.instance.collection('event').snapshots();

  String _valueChanged2 = '';
  String _valueToValidate2 = '';
  String _valueSaved2 = '';

  late DateTime selectedDT;
  double duration = 0.0; //TODO: Float here
  int dogs = 0;
  int cats = 0;
  int other = 0;
  String parking = '';
  String notes = '';
  String phone = '';
  String facility = '';
  String building = '';
  String facilityID = '';
  String facilityImage = '';

  Map<String, dynamic> facilityMap = {};

  bool isChecked = false;
  bool loading = false;
  final _formKey = GlobalKey<FormState>();

  //what gets stored in each form field
  TextEditingController _dateTimeController = TextEditingController();
  TextEditingController _durationController = TextEditingController();
  TextEditingController _catsController = TextEditingController();
  TextEditingController _dogsController = TextEditingController();
  TextEditingController _otherController = TextEditingController();
  TextEditingController _photoConsentController = TextEditingController();
  TextEditingController _parkingController = TextEditingController();
  TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Intl.defaultLocale = 'pt_EN';

    _dateTimeController =
        TextEditingController(text: DateTime.now().toString());
    String lsHour = TimeOfDay.now().hour.toString().padLeft(2, '0');
    String lsMinute = TimeOfDay.now().minute.toString().padLeft(2, '0');

    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm");

    var string = dateFormat
        .format(DateTime.now()); //Converting DateTime object to String

    // DateTime dateTime = dateFormat.parse("2019-07-19 8:40");

    _getValue();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _getValue() async {
    await Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm");
        var string = dateFormat
            .format(DateTime.now()); //Converting DateTime object to String

        _dateTimeController.text = string;
      });
    });
  }

  //clears form fields whe  called
  void clearFields() {
    setState(() {
      _durationController.clear();
      _dateTimeController.clear();
      _catsController.clear();
      _dogsController.clear();
      _otherController.clear();
      _photoConsentController.clear();
      _parkingController.clear();
      _notesController.clear();
      isChecked = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference events =
        FirebaseFirestore.instance.collection('events');

    final args = ModalRoute.of(context)!.settings.arguments as EventArguments;

    facility = args.facilityName;
    building = args.building;
    facilityID = args.id;
    facilityImage = args.facilityImage;

    addEvent() async {
      await events.add({
        'dateTime': _dateTimeController.text,
        'duration': _durationController.text,
        'dogs': _dogsController.text,
        'cats': _catsController.text,
        'other': _otherController.text,
        'photoConsent': isChecked,
        'parking': _parkingController.text,
        'notes': _notesController.text,
        'facilityMap': {
          "facilityID": facilityID,
          "facilityName": facility,
          "facilityBuilding": building,
          "facilityImage": facilityImage,
        },
        'inventoryMap': {
          'Blankets': 0,
          "Cat Collars": 0,
          'Cat Food': 0,
          'Cat Litter': 0,
          'Cat Toys': 0,
          'Cat Treats': 0,
          'Diapers': 0,
          'Dog Beds': 0,
          'Dog Food': 0,
          'Dog Harnesses': 0,
          'Dog Toys': 0,
          'Dog Treats': 0,
          'Pee Pads': 0
        }
      });
    }

    //success dialog when record is added to firebase Firestore
    Future<void> successDialog(BuildContext context) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              title: Text(
                "Event has been saved",
                style: TextStyle(color: AppColors.appTeal),
              ),
              children: [
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                )
              ],
            );
          });
    }

    return loading
        ? const Loading()
        : Scaffold(
            resizeToAvoidBottomInset: true, // This does it
            appBar: AppBar(
              automaticallyImplyLeading: false, //prevents the back arrow
              title: const Text("Add an Event"),

              backgroundColor: AppColors.appClay,
              elevation: 0.0,

              actions: [
                IconButton(
                  icon: const Icon(Icons.home),
                  tooltip: 'Back to Nav',
                  onPressed: () {
                    // print("hello");
                    Navigator.pushNamed(context, '/sideNav');
                  },
                ),
              ],
            ),
            body: StreamBuilder(
                stream: _events,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  return ListView(
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: DateTimePicker(
                                  type: DateTimePickerType.dateTime,
                                  dateMask: 'd MMMM, yyyy - hh:mm a',
                                  controller: _dateTimeController,
                                  // initialValue: _initialValue,
                                  firstDate: DateTime(
                                      2022), //ToDo  make this the current year
                                  lastDate: DateTime(2200),
                                  icon: const Icon(Icons.event),
                                  dateLabelText: 'Date Time',
                                  use24HourFormat: false,
                                  locale: const Locale('en', 'US'),
                                  onChanged: (val) {
                                    setState(() => _valueChanged2 = val);
                                  },
                                  validator: (val) {
                                    setState(
                                        () => _valueToValidate2 = val ?? '');
                                    return null;
                                  },
                                  onSaved: (val) {
                                    setState(() => _valueSaved2 = val ?? '');
                                    print(_valueSaved2);
                                  }),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: _durationController,
                                keyboardType: TextInputType.number,
                                // inputFormatters: <TextInputFormatter>[
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
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: _dogsController,
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration: const InputDecoration(
                                  icon: Icon(Icons.pets),
                                  hintText: 'number of dogs',
                                  labelText: '# of dogs',
                                  fillColor: Colors.white24,
                                  filled: true,
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Name field is empty';
                                  }
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: _catsController,
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration: const InputDecoration(
                                  icon: Icon(Icons.pets),
                                  hintText: 'number of cats',
                                  labelText: '# of cats',
                                  fillColor: Colors.white24,
                                  filled: true,
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Name field is empty';
                                  }
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: _otherController,
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration: const InputDecoration(
                                  icon: Icon(Icons.pets),
                                  hintText: 'number of other animals',
                                  labelText: '# of other animals',
                                  fillColor: Colors.white24,
                                  filled: true,
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Name field is empty';
                                  }
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Require Photo Consent?"),
                                  Checkbox(
                                    value: isChecked,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        isChecked = value!;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: _parkingController,
                                decoration: const InputDecoration(
                                  icon: Icon(Icons.local_parking),
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
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: _notesController,
                                decoration: const InputDecoration(
                                  icon: Icon(Icons.notes),
                                  hintText: 'add any notes',
                                  labelText: 'add notes',
                                  fillColor: Colors.white24,
                                  filled: true,
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Name field is empty';
                                  }
                                },
                              ),
                            ),
                            Divider(
                              height: 2,
                              color: AppColors.appCharcoal.withOpacity(.5),
                              thickness: 1.3,
                              indent: 3,
                              endIndent: 3,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      addEvent(); // Here is where we add user to Firebase Firestore

                                      successDialog(context);
                                      loading = true;
                                    }
                                    clearFields();
                                    loading = false;
                                  },
                                  child: Text(
                                    "Add",
                                    style:
                                        GoogleFonts.roboto(textStyle: headline),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    clearFields();
                                  },
                                  child: Text(
                                    "Clear All",
                                    style:
                                        GoogleFonts.roboto(textStyle: headline),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                }),
          );
  }
}
