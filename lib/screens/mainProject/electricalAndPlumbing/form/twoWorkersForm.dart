// ignore: file_names
import 'package:engineering/databaseHelper/DataBaseHelper.dart';
import 'package:engineering/model/AdditionalManpowerModel.dart';
import 'package:engineering/model/formModel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../model/ProductivityModel.dart';
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
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  late String? units, label, worker, secondWorker, surface;
  late double? defaultValue;

  final _formKey = GlobalKey<FormState>();
  RegExp regex = RegExp(r'(?!^ +$)^.+$');

  var outputFormat = DateFormat('MM/dd/yyyy');
  DateTime selectedDate = DateTime.now();
  int additionalDays = 0;
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        isComputed = false;
      });
    }
  }

  Future readProdRate() async {
    productivityItem = await DatabaseHelper.instance.readSpecificProductivity(
        widget.projectFk,
        widget.elecAndPlumbType,
        widget.workType,
        _selectedType ?? 'DEFAULT');
  }

  List<WorkerType>? rateOfWorkers;
  List<ProductivityItem>? productivityRate;
  String? preferedTime;
  String? surfaceController;
  TextEditingController productivityRateController = TextEditingController();
  TextEditingController dateStartControler = TextEditingController();
  bool isChecked = false,
      isChecked2 = false,
      isChecked3 = false,
      isChecked4 = false,
      isChecked5 = false,
      isChecked6 = false,
      isChecked7 = false,
      isChecked8 = false,
      isChecked9 = false,
      isChecked10 = false;
  double? cbOne,
      cbTwo,
      cbThree,
      cbFour,
      cbFive,
      cbSix,
      cbSeven,
      cbEight,
      cbNine,
      cbTen;
  double? totalPercentage;
  double percentage = 0;
  double? additionalWorker1, additionalWorker2;

  //database
  AdditionalManpower? manpower;
  FormData? formData;
  ProductivityItem? productivityItem;
  bool isLoading = false, isUpdating = false, isComputed = false;

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
      } else if (widget.workType == 'Fixtures') {
        label = 'Fixtures';
        units = 'set';
        surface = 'Set';
      } else {
        label = 'Fixtures';
        units = 'set';
        surface = 'Set';
      }
      worker = 'Electrician';
      secondWorker = 'Laborer';
    } else {
      if (widget.workType == 'Works') {
        label = 'Pipes and Fittings';
        units = 'm';
        surface = 'Length';
      } else if (widget.workType == 'Fixtures') {
        label = 'Fixtures';
        units = 'set';
        surface = 'Set';
      }
      worker = 'Plumber';
      secondWorker = 'Laborer';
    }
    refreshState();
    super.initState();
  }

  Future refreshState() async {
    setState(() => isLoading = true);
    final SharedPreferences prefs = await _prefs;
    final String defaultTime = (prefs.getString(widget.projectFk.toString()) ??
        DateTime.now().toString());
    selectedDate = DateTime.parse(defaultTime);

    formData = await DatabaseHelper.instance.readFormData(
        widget.projectFk, widget.elecAndPlumbType, widget.workType);
    manpower = await DatabaseHelper.instance.readAllManpower(
        widget.projectFk, widget.workType, widget.elecAndPlumbType);
    productivityRate =
        await DatabaseHelper.instance.readAllProductivity(widget.projectFk);
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
      if (formData!.date_start == null) {
        outputFormat.format(selectedDate);
      } else {
        DateTime test = DateTime.parse(formData!.date_start!);
        selectedDate = test;
      }
      defaultValue = formData!.col_1_val;
      dateStartControler.text = formData!.date_start == null
          ? outputFormat.format(DateTime.now())
          : outputFormat.format(DateTime.parse(formData!.date_start!));
      surfaceController = formData!.col_2.toString();
      numberOfDays = formData!.num_days;
      numberOfWorkers = formData!.num_workers;
      dateEnd = formData!.date_end == null
          ? null
          : DateTime.parse(formData!.date_end!);
      worker1 = formData!.worker_1 == null ? null : formData!.worker_1!;
      worker2 = formData!.worker_2 == null ? null : formData!.worker_2!;
      costOfLabor = formData!.worker_1 == null
          ? null
          : ((formData!.worker_1!.toDouble() * workerCost!) +
                  (formData!.worker_2!.toDouble() * workerCost2!)) *
              numberOfDays!;
      // costOfLabor = formData!.cost_of_labor;
      preferedTime = formData!.pref_time.toString();
      totalPercentage = manpower!.totalPercentage;
      percentage = manpower!.totalPercentage;
      _selectedType = formData!.col_1;
      isUpdating = true;
    }
    readProdRate();
    if (manpower != null) {
      isChecked = manpower!.cbOne;
      isChecked2 = manpower!.cbTwo;
      isChecked3 = manpower!.cbThree;
      isChecked4 = manpower!.cbFour;
      isChecked5 = manpower!.cbFive;
      isChecked6 = manpower!.cbSix;
      isChecked7 = manpower!.cbSeven;
      isChecked8 = manpower!.cbEight;
      isChecked9 = manpower!.cbNine;
      isChecked10 = manpower!.cbTen;
      updateManpower();
    }
    prodRate();
    recomputeData();
    setState(() => isLoading = false);
    productivityRateController.text = defaultValue.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.workType,
                style: const TextStyle(fontSize: 18),
              ),
              Text(
                widget.elecAndPlumbType,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
            ],
          ),
          actions: [isComputed ? saveButton() : Container()],
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: Scrollbar(
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Column(children: [
                      //date start
                      Row(
                        children: [
                          const Flexible(
                            flex: 3,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Date Start',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 15),
                                  )),
                            ),
                          ),
                          Flexible(
                            flex: 4,
                            child: //date start
                                Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                  child: TextField(
                                readOnly: true,
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: selectedDate,
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime(2101));
                                  if (pickedDate != null &&
                                      pickedDate != selectedDate) {
                                    setState(() {
                                      selectedDate = pickedDate;
                                      isComputed = false;
                                    });
                                  }
                                },
                                decoration: InputDecoration(
                                    hintText: outputFormat
                                        .format(selectedDate)
                                        .toString()),
                              )),
                            ),
                          ),
                          const Flexible(
                            flex: 2,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                //date start right side
                                '',
                                textAlign: TextAlign.left,
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                          ),
                        ],
                      ),
                      //productivity rate
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    label!,
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(fontSize: 15),
                                  )),
                            ),
                          ),
                          Flexible(
                            flex: 4,
                            child: //prod rate
                                Padding(
                              padding: const EdgeInsets.fromLTRB(8, 20, 8, 0),
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
                                    onChanged: (value) {
                                      setState(() {
                                        isComputed = false;
                                      });
                                    },
                                    controller: productivityRateController,
                                    keyboardType: TextInputType.number,
                                  )),
                            ),
                          ),
                          Flexible(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    units! + '/day',
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(fontSize: 15),
                                  )),
                            ),
                          ),
                        ],
                      ),
                      //volume
                      Row(
                        children: [
                          Flexible(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    surface!,
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(fontSize: 15),
                                  )),
                            ),
                          ),
                          //area
                          Flexible(
                            flex: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: TextFormField(
                                  initialValue: surfaceController == 'null'
                                      ? ''
                                      : surfaceController,
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
                                      isComputed = false;
                                      surfaceController = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    units!,
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(fontSize: 15),
                                  )),
                            ),
                          ),
                        ],
                      ),
                      //preferred time
                      Row(
                        children: [
                          const Flexible(
                            flex: 3,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Preferred time',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 15),
                                  )),
                            ),
                          ),
                          Flexible(
                            flex: 4,
                            child: //prefered time
                                Padding(
                              padding: const EdgeInsets.all(8),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: TextFormField(
                                  initialValue: preferedTime == 'null'
                                      ? ''
                                      : preferedTime,
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
                                      isComputed = false;
                                      preferedTime = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                          const Flexible(
                            flex: 2,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'day/s',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 15),
                                  )),
                            ),
                          ),
                        ],
                      ),
                      computeButton(),
                      //number of days
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.33,
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Number of days',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 15),
                                  )),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.33,
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: numberOfDays != null
                                    ? Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.light
                                                  ? const Color.fromARGB(
                                                      255, 89, 180, 148)
                                                  : const Color.fromRGBO(
                                                      139, 216, 189, 1),
                                              width: 2, //width of border
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: Text(
                                              numberOfDays != null
                                                  ? numberOfDays!.toString()
                                                  : '',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container()),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.33,
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'day/s',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 15),
                                  )),
                            ),
                          )
                        ],
                      ),
                      // date end
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.33,
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Date End',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(fontSize: 15),
                                    )),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.33,
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: dateEnd != null
                                      ? Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.3,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Theme.of(context)
                                                            .brightness ==
                                                        Brightness.light
                                                    ? const Color.fromARGB(
                                                        255, 89, 180, 148)
                                                    : const Color.fromRGBO(
                                                        139, 216, 189, 1),
                                                width: 2, //width of border
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8.0),
                                              child: Text(
                                                dateEnd != null
                                                    ? outputFormat
                                                        .format(dateEnd!)
                                                    : '',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container()),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.33,
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      //date end right side
                                      '',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(fontSize: 15),
                                    )),
                              ),
                            )
                          ]),
                      //number of workers
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.33,
                            child: const Padding(
                              padding: EdgeInsets.fromLTRB(8, 8, 0, 8),
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Number of workers',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 15),
                                  )),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.33,
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: numberOfWorkers != null
                                    ? Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.light
                                                  ? const Color.fromARGB(
                                                      255, 89, 180, 148)
                                                  : const Color.fromRGBO(
                                                      139, 216, 189, 1),
                                              width: 2, //width of border
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: Text(
                                              numberOfWorkers != null
                                                  ? numberOfWorkers!.toString()
                                                  : '',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container()),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.33,
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'worker/s',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 15),
                                  )),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      //first worker count
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.33,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                worker!.toUpperCase(),
                                style: const TextStyle(fontSize: 15),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.33,
                            child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: numberOfWorkers != null
                                    ? Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.light
                                                  ? const Color.fromARGB(
                                                      255, 89, 180, 148)
                                                  : const Color.fromRGBO(
                                                      139, 216, 189, 1),
                                              width: 2, //width of border
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: Text(
                                              worker1 != null
                                                  ? worker1!.toString()
                                                  : '',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container()),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.33,
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'worker/s',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 15),
                                  )),
                            ),
                          )
                        ],
                      ),
                      //second worker count
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.33,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                secondWorker!.toUpperCase(),
                                textAlign: TextAlign.left,
                                style: const TextStyle(fontSize: 15),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.33,
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: worker2 != null
                                    ? Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.light
                                                  ? const Color.fromARGB(
                                                      255, 89, 180, 148)
                                                  : const Color.fromRGBO(
                                                      139, 216, 189, 1),
                                              width: 2, //width of border
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: Text(
                                              worker2 != null
                                                  ? worker2!.toString()
                                                  : '',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container()),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.33,
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'worker/s',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 15),
                                  )),
                            ),
                          )
                        ],
                      ),
                      //cost of labor
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.33,
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'COST OF LABOR',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 15),
                                  )),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.33,
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: costOfLabor != null
                                    ? Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.light
                                                  ? const Color.fromARGB(
                                                      255, 89, 180, 148)
                                                  : const Color.fromRGBO(
                                                      139, 216, 189, 1),
                                              width: 2, //width of border
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: Text(
                                              costOfLabor != null
                                                  ? costOfLabor!
                                                      .toStringAsFixed(2)
                                                  : '',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container()),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.33,
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'php',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 15),
                                  )),
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Container(
                          color: Theme.of(context).brightness ==
                                  Brightness.light
                              ? Theme.of(context).appBarTheme.foregroundColor
                              : const Color.fromRGBO(139, 216, 189, 1),
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                'Additional Manpower',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 25,
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Colors.white
                                        : const Color.fromARGB(
                                            255, 35, 28, 59)),
                              ),
                            ),
                          ),
                        ),
                      ),
                      //cbone
                      Row(
                        children: [
                          Flexible(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Checkbox(
                                checkColor: Colors.white,
                                value: isChecked,
                                onChanged: (bool? value) {
                                  setState(() {
                                    isChecked = value!;
                                    if (isChecked == true) {
                                      cbOne = 0.4;
                                      percentage = double.parse(
                                          (percentage + cbOne!)
                                              .toStringAsFixed(2));
                                    } else {
                                      cbOne = 0.4;
                                      percentage = double.parse(
                                          (percentage - cbOne!)
                                              .toStringAsFixed(2));
                                    }
                                    updateManpower();
                                  });
                                },
                              ),
                            ),
                          ),
                          const Flexible(
                            flex: 4,
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                'Shortage of construction workers due to increase in number of construction projects',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                          const Flexible(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                '40%',
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                          ),
                        ],
                      ),
                      //cbtwo
                      Row(
                        children: [
                          Flexible(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Checkbox(
                                checkColor: Colors.white,
                                value: isChecked2,
                                onChanged: (bool? value) {
                                  setState(() {
                                    isChecked2 = value!;
                                    if (isChecked2 == true) {
                                      cbTwo = 0.1;
                                      percentage = double.parse(
                                          (percentage + cbTwo!)
                                              .toStringAsFixed(2));
                                    } else {
                                      cbTwo = 0.1;
                                      percentage = double.parse(
                                          (percentage - cbTwo!)
                                              .toStringAsFixed(2));
                                    }
                                  });
                                  updateManpower();
                                },
                              ),
                            ),
                          ),
                          const Flexible(
                            flex: 4,
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                'Unskilled construction workers due to lack of experience and training',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                          const Flexible(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                '10%',
                                textAlign: TextAlign.end,
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                          ),
                        ],
                      ),
                      //cbthree
                      Row(
                        children: [
                          Flexible(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Checkbox(
                                checkColor: Colors.white,
                                value: isChecked3,
                                onChanged: (bool? value) {
                                  setState(() {
                                    isChecked3 = value!;
                                    if (isChecked3 == true) {
                                      cbThree = 0.1;
                                      percentage = double.parse(
                                          (percentage + cbThree!)
                                              .toStringAsFixed(2));
                                    } else {
                                      cbThree = 0.1;
                                      percentage = double.parse(
                                          (percentage - cbThree!)
                                              .toStringAsFixed(2));
                                    }
                                  });
                                  updateManpower();
                                },
                              ),
                            ),
                          ),
                          const Flexible(
                            flex: 4,
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                'Language barrier between workers of different dialect',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                          const Flexible(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                '10%',
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                          ),
                        ],
                      ),
                      //cbfour
                      Row(
                        children: [
                          Flexible(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Checkbox(
                                checkColor: Colors.white,
                                value: isChecked4,
                                onChanged: (bool? value) {
                                  setState(() {
                                    isChecked4 = value!;
                                    if (isChecked4 == true) {
                                      cbFour = 0.1;
                                      percentage = double.parse(
                                          (percentage + cbFour!)
                                              .toStringAsFixed(2));
                                    } else {
                                      cbFour = 0.1;
                                      percentage = double.parse(
                                          (percentage - cbFour!)
                                              .toStringAsFixed(2));
                                    }
                                  });
                                  updateManpower();
                                },
                              ),
                            ),
                          ),
                          const Flexible(
                            flex: 4,
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                'Issues of overtime scheduling with construction workers',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                          const Flexible(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                '10%',
                                textAlign: TextAlign.left,
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                          ),
                        ],
                      ),
                      //cbfive
                      Row(
                        children: [
                          Flexible(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Checkbox(
                                checkColor: Colors.white,
                                value: isChecked5,
                                onChanged: (bool? value) {
                                  setState(() {
                                    isChecked5 = value!;
                                    if (isChecked5 == true) {
                                      cbFive = 0.1;
                                      percentage = double.parse(
                                          (percentage + cbFive!)
                                              .toStringAsFixed(2));
                                    } else {
                                      cbFive = 0.1;
                                      percentage = double.parse(
                                          (percentage - cbFive!)
                                              .toStringAsFixed(2));
                                    }
                                  });
                                  updateManpower();
                                },
                              ),
                            ),
                          ),
                          const Flexible(
                            flex: 4,
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                'Demand of higher salaries from construction workers',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                          const Flexible(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                '10%',
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                          ),
                        ],
                      ),
                      //cbsix
                      Row(
                        children: [
                          Flexible(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Checkbox(
                                checkColor: Colors.white,
                                value: isChecked6,
                                onChanged: (bool? value) {
                                  setState(() {
                                    isChecked6 = value!;
                                    if (isChecked6 == true) {
                                      cbSix = 0.1;
                                      percentage = double.parse(
                                          (percentage + cbSix!)
                                              .toStringAsFixed(2));
                                    } else {
                                      cbSix = 0.1;
                                      percentage = double.parse(
                                          (percentage - cbSix!)
                                              .toStringAsFixed(2));
                                    }
                                  });
                                  updateManpower();
                                },
                              ),
                            ),
                          ),
                          const Flexible(
                            flex: 4,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Struggle with authority leading to conflict between construction workers and engineers',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                          const Flexible(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                '10%',
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                          ),
                        ],
                      ),
                      //cbseven
                      Row(
                        children: [
                          Flexible(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Checkbox(
                                checkColor: Colors.white,
                                value: isChecked7,
                                onChanged: (bool? value) {
                                  setState(() {
                                    isChecked7 = value!;
                                    if (isChecked7 == true) {
                                      cbSeven = 0.1;
                                      percentage = double.parse(
                                          (percentage + cbSeven!)
                                              .toStringAsFixed(2));
                                    } else {
                                      cbSeven = 0.1;
                                      percentage = double.parse(
                                          (percentage - cbSeven!)
                                              .toStringAsFixed(2));
                                    }
                                  });
                                  updateManpower();
                                },
                              ),
                            ),
                          ),
                          const Flexible(
                            flex: 4,
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                'Sudden absences of construction workers without prior notice to superiors',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                          const Flexible(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                '10%',
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                          ),
                        ],
                      ),
                      //cbeight
                      Row(
                        children: [
                          Flexible(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Checkbox(
                                checkColor: Colors.white,
                                value: isChecked8,
                                onChanged: (bool? value) {
                                  setState(() {
                                    isChecked8 = value!;
                                    if (isChecked8 == true) {
                                      cbEight = 0.1;
                                      percentage = double.parse(
                                          (percentage + cbEight!)
                                              .toStringAsFixed(2));
                                    } else {
                                      cbEight = 0.1;
                                      percentage = double.parse(
                                          (percentage - cbEight!)
                                              .toStringAsFixed(2));
                                    }
                                  });
                                  updateManpower();
                                },
                              ),
                            ),
                          ),
                          const Flexible(
                            flex: 4,
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                'Usage of electronic devices during working hours',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                          const Flexible(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                '10%',
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                          ),
                        ],
                      ),
                      //cbnine
                      Row(
                        children: [
                          Flexible(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Checkbox(
                                checkColor: Colors.white,
                                value: isChecked9,
                                onChanged: (bool? value) {
                                  setState(() {
                                    isChecked9 = value!;
                                    if (isChecked9 == true) {
                                      cbNine = 0.3;
                                      percentage = double.parse(
                                          (percentage + cbNine!)
                                              .toStringAsFixed(2));
                                    } else {
                                      cbNine = 0.3;
                                      percentage = double.parse(
                                          (percentage - cbNine!)
                                              .toStringAsFixed(2));
                                    }
                                  });
                                  updateManpower();
                                },
                              ),
                            ),
                          ),
                          const Flexible(
                            flex: 4,
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                'Sudden resignation of workers due to inadequate benefits, low wages, deployment abroad, etc.',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                          const Flexible(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                '30%',
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                          ),
                        ],
                      ),
                      //cbten
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Flexible(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Checkbox(
                                checkColor: Colors.white,
                                value: isChecked10,
                                onChanged: (bool? value) {
                                  setState(() {
                                    isChecked10 = value!;
                                    if (isChecked10 == true) {
                                      cbTen = 0.1;
                                      percentage = double.parse(
                                          (percentage + cbTen!)
                                              .toStringAsFixed(2));
                                    } else {
                                      cbTen = 0.1;
                                      percentage = double.parse(
                                          (percentage - cbTen!)
                                              .toStringAsFixed(2));
                                    }
                                  });
                                  updateManpower();
                                },
                              ),
                            ),
                          ),
                          const Flexible(
                            flex: 4,
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                'Sudden Termination(Serious Injury, relocation, habitual neglect of duties, serious misconduct, fraud, loss of confidence, commission of a crime and analogous causes)',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                          const Flexible(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                '10%',
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      //percentage
                      Row(
                        children: [
                          const Flexible(
                            flex: 2,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'PERCENT %',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 15),
                                  )),
                            ),
                          ),
                          Flexible(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.3,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Theme.of(context).brightness ==
                                              Brightness.light
                                          ? const Color.fromARGB(
                                              255, 89, 180, 148)
                                          : const Color.fromRGBO(
                                              139, 216, 189, 1),
                                      width: 2, //width of border
                                    ),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Text(
                                      (totalPercentage! * 100)
                                          .toStringAsFixed(0),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      //addtl first worker
                      Row(
                        children: [
                          Flexible(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    worker!.toUpperCase(),
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(fontSize: 15),
                                  )),
                            ),
                          ),
                          Flexible(
                            flex: 2,
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: additionalWorker1 != null
                                    ? Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.light
                                                  ? const Color.fromARGB(
                                                      255, 89, 180, 148)
                                                  : const Color.fromRGBO(
                                                      139, 216, 189, 1),
                                              width: 2, //width of border
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: Text(
                                              additionalWorker1 != null
                                                  ? additionalWorker1!
                                                      .toStringAsFixed(0)
                                                  : '',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container()),
                          ),
                        ],
                      ),
                      //addtl second worker
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Row(
                          children: [
                            Flexible(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      secondWorker!.toUpperCase(),
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(fontSize: 15),
                                    )),
                              ),
                            ),
                            Flexible(
                              flex: 2,
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: additionalWorker1 != null
                                      ? Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.3,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Theme.of(context)
                                                            .brightness ==
                                                        Brightness.light
                                                    ? const Color.fromARGB(
                                                        255, 89, 180, 148)
                                                    : const Color.fromRGBO(
                                                        139, 216, 189, 1),
                                                width: 2, //width of border
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8.0),
                                              child: Text(
                                                additionalWorker2 != null
                                                    ? additionalWorker2!
                                                        .toStringAsFixed(0)
                                                    : '',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container()),
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ),
                ),
              ));
  }

  void prodRate() {
    readProdRate();
    for (int i = 0; i < productivityRate!.length; i++) {
      if (productivityRate![i].type.toUpperCase() ==
              widget.workType.toUpperCase() &&
          productivityRate![i].work.toUpperCase() ==
              widget.elecAndPlumbType.toUpperCase()) {
        if (productivityRate![i].col_1 == "DEFAULT" &&
            productivityRate![i].work.toUpperCase() ==
                widget.elecAndPlumbType.toUpperCase()) {
          setState(() {
            defaultValue = productivityRate![i].col_1_val;
          });
        } else {
          if (productivityRate![i].col_1 == _selectedType) {
            setState(() {
              defaultValue = productivityRate![i].col_1_val;
            });
          }
        }
      }
    }
  }

  void recomputeData() {
    if (formData!.col_1_val != defaultValue && formData!.num_workers != null) {
      if (defaultValue! <= 0 ||
          double.parse(surfaceController!) <= 0 ||
          double.parse(preferedTime!) <= 0) {
        setState(() {
          isComputed = false;
        });
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: const Text('Invalid Input.'),
                  actions: <Widget>[
                    ElevatedButton(
                      child: const Text("OK"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ]);
            });
      } else {
        initialWorkers =
            (double.parse(surfaceController!) / defaultValue!).roundToDouble();
        if (initialWorkers! >= 1 && initialWorkers! <= 3) {
          initialNumberofDays = 1;
        } else if (initialWorkers! >= 4 && initialWorkers! <= 6) {
          initialNumberofDays = 2;
        } else if (initialWorkers! >= 7 && initialWorkers! <= 9) {
          initialNumberofDays = 3;
        } else if (initialWorkers! == 10) {
          initialNumberofDays = 5;
        } else {
          initialNumberofDays = double.parse(preferedTime!);
        }
        int workernumbers = (initialWorkers! / initialNumberofDays!).round();
        if (double.parse(preferedTime!) < initialNumberofDays!) {
          initialNumberofDays = double.parse(preferedTime!);
        }
        if (workernumbers <= 0) {
          setState(() {
            isComputed = false;
          });
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                    title: const Text('Invalid Input.'),
                    actions: <Widget>[
                      ElevatedButton(
                        child: const Text("OK"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ]);
              });
        } else {
          setState(() {
            if (workernumbers <= 2) {
              worker1 = 1;
              worker2 = 1;
            } else if (workernumbers == 3) {
              worker1 = 2;
              worker2 = 1;
            } else if (workernumbers == 4) {
              worker1 = 2;
              worker2 = 2;
            } else {
              worker1 = 2;
              worker2 = workernumbers - 2;
            }
            for (int x = 0; x < initialNumberofDays!.ceil(); x++) {
              DateTime tempDate = selectedDate.add(Duration(days: x));
              if (tempDate.weekday == DateTime.sunday) {
                additionalDays++;
              }
            }
            numberOfDays = initialNumberofDays!.round();
            numberOfWorkers = (worker1! + worker2!);
            costOfLabor = ((worker1!.toDouble() * workerCost!) +
                    (worker2!.toDouble() * workerCost2!)) *
                numberOfDays!;
            dateEnd = numberOfDays == 1
                ? selectedDate
                : selectedDate
                    .add(Duration(days: (numberOfDays! - 1) + additionalDays));
            isComputed = true;
            additionalDays = 0;
          });
        }
      }
      final formDataCreate = FormData(
        id: formData!.id,
        date_start: selectedDate.toString(),
        col_1: _selectedType ?? 'DEFAULT',
        col_1_val: defaultValue!,
        col_2: double.parse(surfaceController!),
        pref_time: int.parse(preferedTime!),
        num_days: numberOfDays!,
        date_end: dateEnd.toString(),
        num_workers: numberOfWorkers!,
        worker_1: worker1!,
        worker_2: worker2!,
        work: widget.elecAndPlumbType,
        type: widget.workType,
        fk: widget.projectFk,
      );
      DatabaseHelper.instance.updateFormData(formDataCreate);
      updateManpower();
      refreshState();
      setState(() {
        isComputed = false;
      });
    }
  }

  Widget computeButton() => ElevatedButton(
      onPressed: () {
        if (selectedDate.weekday == DateTime.sunday) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                    title: const Text('No work at Sunday'),
                    actions: <Widget>[
                      ElevatedButton(
                        child: const Text("OK"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ]);
              });
        } else {
          if (_formKey.currentState!.validate()) {
            if (double.parse(productivityRateController.text) <= 0 ||
                double.parse(surfaceController!) <= 0 ||
                double.parse(preferedTime!) <= 0) {
              setState(() {
                isComputed = false;
              });
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                        title: const Text('Invalid Input.'),
                        actions: <Widget>[
                          ElevatedButton(
                            child: const Text("OK"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ]);
                  });
            } else {
              initialWorkers = (double.parse(surfaceController!) /
                      double.parse(productivityRateController.text))
                  .roundToDouble();
              if (initialWorkers! >= 1 && initialWorkers! <= 3) {
                initialNumberofDays = 1;
              } else if (initialWorkers! >= 4 && initialWorkers! <= 6) {
                initialNumberofDays = 2;
              } else if (initialWorkers! >= 7 && initialWorkers! <= 9) {
                initialNumberofDays = 3;
              } else if (initialWorkers! == 10) {
                initialNumberofDays = 5;
              } else {
                initialNumberofDays = double.parse(preferedTime!);
              }
              int workernumbers =
                  (initialWorkers! / initialNumberofDays!).round();
              if (double.parse(preferedTime!) < initialNumberofDays!) {
                initialNumberofDays = double.parse(preferedTime!);
              }
              if (workernumbers <= 0) {
                setState(() {
                  isComputed = false;
                });
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          title: const Text('Invalid Input.'),
                          actions: <Widget>[
                            ElevatedButton(
                              child: const Text("OK"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ]);
                    });
              } else {
                setState(() {
                  if (workernumbers <= 2) {
                    worker1 = 1;
                    worker2 = 1;
                  } else if (workernumbers == 3) {
                    worker1 = 2;
                    worker2 = 1;
                  } else if (workernumbers == 4) {
                    worker1 = 2;
                    worker2 = 2;
                  } else {
                    worker1 = 2;
                    worker2 = workernumbers - 2;
                  }
                  for (int x = 0; x < initialNumberofDays!.ceil(); x++) {
                    DateTime tempDate = selectedDate.add(Duration(days: x));
                    if (tempDate.weekday == DateTime.sunday) {
                      additionalDays++;
                    }
                  }
                  numberOfDays = initialNumberofDays!.round();
                  numberOfWorkers = (worker1! + worker2!);
                  costOfLabor = ((worker1!.toDouble() * workerCost!) +
                          (worker2!.toDouble() * workerCost2!)) *
                      numberOfDays!;
                  dateEnd = numberOfDays == 1
                      ? selectedDate
                      : selectedDate.add(
                          Duration(days: (numberOfDays! - 1) + additionalDays));
                  isComputed = true;
                  additionalDays = 0;
                });
              }
            }
          }
        }
      },
      child: const Text('Compute'));

  Future updateManpower() async {
    totalPercentage = percentage;
    manpower = AdditionalManpower(
        id: manpower!.id!,
        fk: manpower!.fk,
        work: manpower!.work,
        type: manpower!.type,
        cbOne: isChecked,
        cbTwo: isChecked2,
        cbThree: isChecked3,
        cbFour: isChecked4,
        cbFive: isChecked5,
        cbSix: isChecked6,
        cbSeven: isChecked7,
        cbEight: isChecked8,
        cbNine: isChecked9,
        cbTen: isChecked10,
        totalPercentage: totalPercentage!);
    if (formData!.worker_1 != null) {
      additionalWorker1 = totalPercentage! * worker1!;
      additionalWorker2 = totalPercentage! * worker2!;
      double decimalValue = additionalWorker1! - additionalWorker1!.toInt();
      double secondDecimalValue =
          additionalWorker2! - additionalWorker2!.toInt();
      if (decimalValue <= 0.09) {
        setState(() {
          additionalWorker1 = (additionalWorker1!.floor()).toDouble();
        });
      } else {
        setState(() {
          additionalWorker1 = (additionalWorker1!.ceil()).toDouble();
        });
      }
      if (secondDecimalValue <= 0.09) {
        setState(() {
          additionalWorker2 = (additionalWorker2!.floor()).toDouble();
        });
      } else {
        setState(() {
          additionalWorker2 = (additionalWorker2!.ceil()).toDouble();
        });
      }
    }
    await DatabaseHelper.instance.updateManpower(manpower!);
  }

  Future updateProductivityRate() async {
    final updatePR = ProductivityItem(
      id: productivityItem!.id,
      fk: widget.projectFk,
      col_1: _selectedType ?? 'DEFAULT',
      col_1_val: double.parse(productivityRateController.text),
      work: productivityItem!.work,
      type: productivityItem!.type,
    );
    DatabaseHelper.instance.updateProductivityWithID(updatePR);
  }

  Widget saveButton() => ElevatedButton(
      onPressed: () async {
        final SharedPreferences prefs = await _prefs;
        final String defaultTime =
            (prefs.getString(widget.projectFk.toString()) ??
                DateTime.now().toString());
        if (dateEnd!.isAfter(DateTime.parse(defaultTime))) {
          if (dateEnd!.add(const Duration(days: 1)).weekday !=
              DateTime.sunday) {
            prefs.setString(widget.projectFk.toString(),
                dateEnd!.add(const Duration(days: 1)).toString());
          } else {
            prefs.setString(widget.projectFk.toString(),
                dateEnd!.add(const Duration(days: 2)).toString());
          }
        }

        final formDataCreate = FormData(
          id: formData!.id,
          date_start: selectedDate.toString(),
          col_1: _selectedType ?? 'DEFAULT',
          col_1_val: double.parse(productivityRateController.text),
          col_2: double.parse(surfaceController!),
          pref_time: int.parse(preferedTime!),
          num_days: numberOfDays!,
          date_end: dateEnd.toString(),
          num_workers: numberOfWorkers!,
          worker_1: worker1!,
          worker_2: worker2!,
          work: widget.elecAndPlumbType,
          type: widget.workType,
          fk: widget.projectFk,
        );
        DatabaseHelper.instance.updateFormData(formDataCreate);
        updateProductivityRate();
        updateManpower();
        refreshState();
        setState(() {
          isComputed = false;
        });
      },
      child: const Text('Save'));
}
