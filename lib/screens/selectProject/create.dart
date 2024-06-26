// ignore_for_file: unused_import

import 'package:engineering/databaseHelper/DataBaseHelper.dart';
import 'package:engineering/model/ProjectModel.dart';
import 'package:engineering/screens/hamburgerMenu/stack.dart';
import 'package:engineering/widget/customWidgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../homePage.dart';

class CreateProject extends StatefulWidget {
  const CreateProject({Key? key}) : super(key: key);

  @override
  _CreateProjectState createState() => _CreateProjectState();
}

class _CreateProjectState extends State<CreateProject> {
  final _formKey = GlobalKey<FormState>();
  String val = "Bungalow";
  TextEditingController projectName = TextEditingController();
  TextEditingController projectManager = TextEditingController();
  RegExp regex = RegExp(r'(?!^ +$)^.+$');
  var outputFormat = DateFormat('MM/dd/yyyy');
  TextEditingController dateStartControler = TextEditingController();
  DateTime startSelectedDate = DateTime.now();
  DateTime endSelectedDate = DateTime.now();
  Future<void> _selectDateStart(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: startSelectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null && picked != startSelectedDate) {
      setState(() {
        startSelectedDate = picked;
      });
    }
  }

  Future<void> _selectDateEnd(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: endSelectedDate.add(const Duration(days: 1)),
        firstDate: DateTime.now().add(const Duration(days: 1)),
        lastDate: DateTime(2101));
    if (picked != null && picked != endSelectedDate) {
      setState(() {
        endSelectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: CustomWidgets().text_title('New Project', 20),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: CustomWidgets().text_title(
                    'Enter the name of the new project and select style.', 20),
              ),
              //project name
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: TextFormField(
                  initialValue: projectName.text,
                  decoration: const InputDecoration(hintText: ("Project Name")),
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
                      projectName.text = value;
                    });
                  },
                ),
              ),
              // project manager
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: TextFormField(
                  initialValue: projectManager.text,
                  decoration:
                      const InputDecoration(hintText: ("Project Manager")),
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
                      projectManager.text = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Row(
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            CustomWidgets().text_subtitle('Start Date: ', 16),
                            IconButton(
                                iconSize: 30,
                                icon: const Icon(Icons.calendar_today),
                                onPressed: () {
                                  _selectDateStart(context);
                                }),
                            Text(
                                outputFormat
                                    .format(startSelectedDate)
                                    .toString(),
                                style: const TextStyle(fontSize: 20)),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Row(
                  children: [
                    CustomWidgets().text_subtitle('End Date: ', 16),
                    IconButton(
                        iconSize: 30,
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () {
                          _selectDateEnd(context);
                        }),
                    Text(outputFormat.format(endSelectedDate).toString(),
                        style: const TextStyle(fontSize: 20)),
                  ],
                ),
              ),
              Container(
                alignment: AlignmentDirectional.centerStart,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: CustomWidgets().text_title('Style:', 20),
                ),
              ),
              ListTile(
                title: const Text("Bungalow"),
                leading: Radio(
                  value: "Bungalow",
                  groupValue: val,
                  onChanged: (value) {
                    setState(() {
                      val = value.toString();
                    });
                  },
                  activeColor: Colors.green,
                ),
              ),
              ListTile(
                title: const Text("Two-Storey"),
                leading: Radio(
                  value: "Two-Storey",
                  groupValue: val,
                  onChanged: (value) {
                    setState(() {
                      val = value.toString();
                    });
                  },
                  activeColor: Colors.green,
                ),
              ),
              // const SizedBox(
              //   height: 30,
              // ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: CustomWidgets().funtion_Button(
                        'Save',
                        const Icon(Icons.menu_open),
                        0.6,
                        0.07,
                        context,
                        saveProject),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  saveProject() async {
    if (_formKey.currentState!.validate()) {
      if (startSelectedDate.isAfter(
              endSelectedDate) /*||
          startSelectedDate.isAtSameMomentAs(endSelectedDate)*/
          ) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: const Text('Please Enter Valid Input'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("OK"),
                      onPressed: () {
                        // print(projectName[index]);
                        Navigator.of(context).pop();
                      },
                    ),
                  ]);
            });
      } else {
        final createdProject = ProjectItem(
            project_name: projectName.text,
            project_manager: projectManager.text,
            date_start: startSelectedDate,
            date_end: endSelectedDate,
            type: val);
        final iDFromSQL =
            await DatabaseHelper.instance.createProject(createdProject);
        final toStackProject = ProjectItem(
            id: iDFromSQL,
            project_name: projectName.text,
            project_manager: projectManager.text,
            date_start: startSelectedDate,
            date_end: endSelectedDate,
            type: val);
        CustomWidgets().function_pushReplacement(
            context, () => StackWidget(project: toStackProject));
      }
    }
  }
}
