import 'package:engineering/screens/hamburgerMenu/openDrawer.dart';
import 'package:engineering/screens/mainProject/rateOfWorkers/rateOfWorkers.dart';
import 'package:engineering/widget/customWidgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class EarthWorksForm extends StatefulWidget {
  String workType;
  EarthWorksForm({Key? key, required this.workType}) : super(key: key);

  @override
  State<EarthWorksForm> createState() => _EarthWorksFormState();
}

class _EarthWorksFormState extends State<EarthWorksForm> {
  TextEditingController dateStartControler = TextEditingController();
  var outputFormat = DateFormat('MM/dd/yyyy');
  DateTime selectedDate = DateTime.now();

  List<String> _locations = ['Hard Soil', 'Soft Soil'];
  String? _selectedLocation;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workType),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                    flex: 3,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              height: MediaQuery.of(context).size.height * 0.07,
                              child: const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Date Start',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 15),
                                  ))),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              height: MediaQuery.of(context).size.height * 0.07,
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    widget.workType,
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(fontSize: 15),
                                  ))),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              height: MediaQuery.of(context).size.height * 0.07,
                              child: const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Volume',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 15),
                                  ))),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              height: MediaQuery.of(context).size.height * 0.07,
                              child: const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Preferred Time',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 15),
                                  ))),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              height: MediaQuery.of(context).size.height * 0.07,
                              child: const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Number of days',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 15),
                                  ))),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              height: MediaQuery.of(context).size.height * 0.07,
                              child: const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Date End',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 15),
                                  ))),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              height: MediaQuery.of(context).size.height * 0.07,
                              child: const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Number of workers',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 15),
                                  ))),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              height: MediaQuery.of(context).size.height * 0.07,
                              child: const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Laborer',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 15),
                                  ))),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              height: MediaQuery.of(context).size.height * 0.07,
                              child: const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Cost of Laborer',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 15),
                                  ))),
                        ),
                      ],
                    )),
                //dito ka mageedit
                Flexible(
                    flex: 5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                              child: TextField(
                            readOnly: true,
                            controller: dateStartControler,
                            onTap: () async {
                              _selectDate(context);
                            },
                            decoration: InputDecoration(
                                hintText: outputFormat
                                    .format(selectedDate)
                                    .toString()),
                          )),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: MediaQuery.of(context).size.height * 0.07,
                            child: DropdownButton(
                                hint: Text(
                                    'Hard Soil'), // Not necessary for Option 1
                                value: _selectedLocation,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedLocation = value.toString();
                                  });
                                },
                                items: _locations.map((location) {
                                  return DropdownMenuItem(
                                    child: new Text(location),
                                    value: location,
                                  );
                                }).toList()),
                          ),
                        ),
                      ],
                    )),
                Flexible(
                  flex: 2,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              height: MediaQuery.of(context).size.height * 0.07,
                              child: const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 15),
                                  ))),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              height: MediaQuery.of(context).size.height * 0.07,
                              child: const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'cum/day',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 15),
                                  ))),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              height: MediaQuery.of(context).size.height * 0.07,
                              child: const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'cum',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 15),
                                  ))),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              height: MediaQuery.of(context).size.height * 0.07,
                              child: const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Day/s',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 15),
                                  ))),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              height: MediaQuery.of(context).size.height * 0.07,
                              child: const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Day/s',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 15),
                                  ))),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              height: MediaQuery.of(context).size.height * 0.07,
                              child: const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 15),
                                  ))),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              height: MediaQuery.of(context).size.height * 0.07,
                              child: const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'worker/s',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 15),
                                  ))),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              height: MediaQuery.of(context).size.height * 0.07,
                              child: const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'worker/s',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 15),
                                  ))),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              height: MediaQuery.of(context).size.height * 0.07,
                              child: const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'php',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 15),
                                  ))),
                        ),
                      ]),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
