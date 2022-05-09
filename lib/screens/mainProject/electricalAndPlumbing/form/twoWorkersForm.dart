// ignore: file_names
import 'package:engineering/databaseHelper/DataBaseHelper.dart';
import 'package:engineering/model/formModel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../model/workerModel.dart';

// ignore: must_be_immutable
class TwoWorkersForm extends StatefulWidget {
  String workType;
  String elecAndPlumbType;
  String projectType;
  int projectFk;
  TwoWorkersForm(
      {Key? key,
      required this.workType,
      required this.elecAndPlumbType,
      required this.projectType,
      required this.projectFk})
      : super(key: key);

  @override
  State<TwoWorkersForm> createState() => _TwoWorkersFormState();
}

class _TwoWorkersFormState extends State<TwoWorkersForm> {
  late String? units, label, worker, secondWorker, surface;
  late double? defaultValue;

  final _formKey = GlobalKey<FormState>();
  RegExp regex = RegExp(r'(?!^ +$)^.+$');

  var outputFormat = DateFormat('MM/dd/yyyy');
  DateTime selectedDate = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  List<WorkerType>? rateOfWorkers;
  String? preferedTime;
  String? surfaceController;
  TextEditingController productivityRateController = TextEditingController();
  TextEditingController dateStartControler = TextEditingController();

  //database
  FormData? formData;
  bool isLoading = false, isUpdating = false, isExceeded = false;

  //auto populated
  int? numberOfDays, numberOfWorkers, worker1, worker2;
  String? _selectedType;
  DateTime? dateEnd;
  double? costOfLabor,
      initialWorkers,
      initialNumberofDays,
      workerCost,
      workerCost2;

  @override
  void initState() {
    if (widget.elecAndPlumbType == 'Electrical Works') {
      if (widget.workType == 'Roughing Ins') {
        label = 'Conduit Pipes';
        units = 'm';
        surface = 'Length';
        defaultValue = 30;
      } else {
        label = 'Fixtures';
        units = 'set';
        surface = 'Set';
        defaultValue = 10;
      }
      worker = 'Electrician';
      secondWorker = 'Laborer';
    } else {
      if (widget.workType == 'Works') {
        label = 'Pipes and Fittings';
        units = 'm';
        surface = 'Length';
        defaultValue = 31.5;
      } else {
        label = 'Fixtures';
        units = 'set';
        surface = 'Fixtures';
        defaultValue = 5;
      }
      worker = 'Plumber';
      secondWorker = 'Laborer';
    }
    productivityRateController.text = defaultValue.toString();
    refreshState();
    super.initState();
  }

  Future refreshState() async {
    setState(() => isLoading = true);
    formData = await DatabaseHelper.instance.readFormData(
        widget.projectFk, widget.elecAndPlumbType, widget.workType);

    rateOfWorkers = await DatabaseHelper.instance.readWorkers(widget.projectFk);
    for (int i = 0; i < rateOfWorkers!.length; i++) {
      if (rateOfWorkers![i].workerType.toUpperCase() == worker!.toUpperCase()) {
        workerCost = rateOfWorkers![i].rate;
      } else if (rateOfWorkers![i].workerType.toUpperCase() ==
          secondWorker!.toUpperCase()) {
        workerCost2 = rateOfWorkers![i].rate;
      }
    }

    if (formData != null) {
      dateStartControler.text =
          DateFormat('MM/dd/yyyy').format(formData!.date_start);
      defaultValue = formData!.col_1_val;
      surfaceController = formData!.col_2.toString();
      numberOfDays = formData!.num_days;
      numberOfWorkers = formData!.num_workers;
      dateEnd = formData!.date_end;
      worker2 = formData!.worker_2!;
      worker1 = formData!.worker_1;
      costOfLabor = (formData!.worker_1 * workerCost!) +
          (formData!.worker_2! * workerCost2!);
      //costOfLabor = formData!.cost_of_labor;
      preferedTime = formData!.pref_time.toString();

      _selectedType = formData!.col_1;
      defaultValue = formData!.col_1_val;
      isUpdating = true;
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workType),
        actions: [saveButton()],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        //first column
                        Flexible(
                            flex: 3,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.07,
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
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.07,
                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            label!,
                                            textAlign: TextAlign.left,
                                            style:
                                                const TextStyle(fontSize: 15),
                                          ))),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.07,
                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            surface!,
                                            textAlign: TextAlign.left,
                                            style:
                                                const TextStyle(fontSize: 15),
                                          ))),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.07,
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
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.07,
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
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.07,
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
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.07,
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
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.07,
                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            worker!.toUpperCase(),
                                            textAlign: TextAlign.left,
                                            style:
                                                const TextStyle(fontSize: 15),
                                          ))),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.07,
                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            secondWorker!.toUpperCase(),
                                            textAlign: TextAlign.left,
                                            style:
                                                const TextStyle(fontSize: 15),
                                          ))),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.07,
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
                        //second column
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
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 20, 8, 0),
                                  child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.07,
                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: TextFormField(
                                            decoration: const InputDecoration(
                                              helperText: ' ', // this is new
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty ||
                                                  !regex.hasMatch(value)) {
                                                return 'This Field is Required';
                                              }
                                              return null;
                                            },
                                            controller:
                                                productivityRateController,
                                            keyboardType: TextInputType.number,
                                          ))),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 20, 8, 0),
                                  child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.07,
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: TextFormField(
                                          initialValue: surfaceController ?? '',
                                          decoration: const InputDecoration(
                                            helperText: ' ', // this is new
                                          ),
                                          keyboardType: TextInputType.number,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty ||
                                                !regex.hasMatch(value)) {
                                              return 'This Field is Required';
                                            }
                                            return null;
                                          },

                                          // controller: projectName.text,
                                          onChanged: (value) {
                                            setState(() {
                                              surfaceController = value;
                                            });
                                          },
                                        ),
                                      )),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 15, 8, 0),
                                  child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.07,
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: TextFormField(
                                          initialValue: preferedTime ?? '',
                                          decoration: const InputDecoration(
                                            helperText: ' ', // this is new
                                          ),
                                          keyboardType: TextInputType.number,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty ||
                                                !regex.hasMatch(value)) {
                                              return 'This Field is Required';
                                            }
                                            return null;
                                          },

                                          // controller: projectName.text,
                                          onChanged: (value) {
                                            setState(() {
                                              preferedTime = value;
                                            });
                                          },
                                        ),
                                      )),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.07,
                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            numberOfDays != null
                                                ? numberOfDays.toString()
                                                : '',
                                            textAlign: TextAlign.left,
                                            style:
                                                const TextStyle(fontSize: 15),
                                          ))),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.07,
                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            dateEnd != null
                                                ? outputFormat.format(dateEnd!)
                                                : '',
                                            textAlign: TextAlign.left,
                                            style:
                                                const TextStyle(fontSize: 15),
                                          ))),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.07,
                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            numberOfWorkers != null
                                                ? numberOfWorkers.toString()
                                                : '',
                                            textAlign: TextAlign.left,
                                            style:
                                                const TextStyle(fontSize: 15),
                                          ))),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.07,
                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            worker1 != null
                                                ? worker1.toString()
                                                : '',
                                            textAlign: TextAlign.left,
                                            style:
                                                const TextStyle(fontSize: 15),
                                          ))),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.07,
                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            worker2 != null
                                                ? worker2.toString()
                                                : '',
                                            textAlign: TextAlign.left,
                                            style:
                                                const TextStyle(fontSize: 15),
                                          ))),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.07,
                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            costOfLabor != null
                                                ? costOfLabor.toString()
                                                : '',
                                            textAlign: TextAlign.left,
                                            style:
                                                const TextStyle(fontSize: 15),
                                          ))),
                                ),
                              ],
                            )),
                        //third column
                        Flexible(
                          flex: 2,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.07,
                                      child: const Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            //date start right side
                                            '',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(fontSize: 15),
                                          ))),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.07,
                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            units! + '/day',
                                            textAlign: TextAlign.left,
                                            style:
                                                const TextStyle(fontSize: 15),
                                          ))),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.07,
                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            units!,
                                            textAlign: TextAlign.left,
                                            style:
                                                const TextStyle(fontSize: 15),
                                          ))),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.07,
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
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.07,
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
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.07,
                                      child: const Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            //date end right side
                                            '',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(fontSize: 15),
                                          ))),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.07,
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
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.07,
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
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.07,
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
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.07,
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
            ),
    );
  }

  Widget saveButton() => ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          initialWorkers = (double.parse(surfaceController!) /
                  double.parse(productivityRateController.text))
              .roundToDouble();
          if (initialWorkers! <= 3) {
            initialNumberofDays = 1;
          } else if (initialWorkers! >= 4 && initialWorkers! <= 6) {
            initialNumberofDays = 2;
          } else if (initialWorkers! >= 7 && initialWorkers! <= 9) {
            initialNumberofDays = 3;
          } else if (initialWorkers! >= 10 && initialWorkers! <= 12) {
            initialNumberofDays = 4;
          } else if (initialWorkers! >= 13 && initialWorkers! <= 15) {
            initialNumberofDays = 5;
          } else {
            isExceeded = true;
          }

          if (double.parse(preferedTime!) < initialNumberofDays!) {
            initialNumberofDays = double.parse(preferedTime!);
          }
          numberOfDays = initialNumberofDays!.round();
          numberOfWorkers = (initialWorkers! / initialNumberofDays!).round();
          costOfLabor = numberOfWorkers! * workerCost!;

          if (isUpdating) {
            final formDataUpdate = FormData(
                date_start: selectedDate,
                col_1: _selectedType ?? 'DEFAULT',
                col_1_val: defaultValue!,
                col_2: double.parse(surfaceController!),
                pref_time: int.parse(preferedTime!),
                num_days: numberOfDays!,
                date_end: dateEnd!,
                num_workers: numberOfWorkers!,
                worker_1: worker1!,
                worker_2: worker2,
                cost_of_labor: costOfLabor!,
                type: widget.elecAndPlumbType,
                work: widget.workType,
                fk: widget.projectFk,
                id: formData!.id!);

            DatabaseHelper.instance.updateFormData(formDataUpdate);
          } else {
            final formDataCreate = FormData(
              date_start: selectedDate,
              col_1: _selectedType ?? 'DEFAULT',
              col_1_val: defaultValue!,
              col_2: double.parse(surfaceController!),
              pref_time: int.parse(preferedTime!),
              num_days: numberOfDays!,
              date_end: selectedDate.add(Duration(days: numberOfDays!)),
              num_workers: numberOfWorkers!,
              worker_1: numberOfWorkers!,
              worker_2: numberOfWorkers!,
              cost_of_labor: costOfLabor!,
              type: widget.elecAndPlumbType,
              work: widget.workType,
              fk: widget.projectFk,
            );
            DatabaseHelper.instance.createFormData(formDataCreate);
          }
          refreshState();
        }
      },
      child: const Text('Save'));
}
