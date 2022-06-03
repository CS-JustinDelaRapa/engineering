import 'package:engineering/databaseHelper/DataBaseHelper.dart';
import 'package:engineering/model/formModel.dart';
import 'package:engineering/screens/hamburgerMenu/openDrawer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class DateScchedule extends StatefulWidget {
  final VoidCallback openDrawer;
  final int fk;
  const DateScchedule({ required this.openDrawer, required this.fk, Key? key }) : super(key: key);

  @override
  State<DateScchedule> createState() => _DateSccheduleState();
}

class _DateSccheduleState extends State<DateScchedule> {

  List<FormData>? allForms;
  bool isLoading = false;

  @override
  void initState() {
    refreshState();
    super.initState();
  }

  Future refreshState() async{
    setState(() {
      isLoading = true;
    });
    allForms = await DatabaseHelper.instance.readAllFormData(widget.fk);
  setState(() {
    isLoading = false;
  });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        leading: OpenDrawerWidget(
          onClicked: widget.openDrawer,
        ),
        title: const Text('Manpower Distribution'),
      ),
        body: isLoading? const Center(child: CircularProgressIndicator(),) : 
        SfCalendar(
      view: CalendarView.month,
      dataSource: MeetingDataSource(_getDataSource()),
      onTap: (CalendarTapDetails details) {
            // List<Meeting> appointments = details.appointments as List<Meeting>;
            // print(appointments[0].eventName);
            DateTime date = details.date!;
            CalendarElement element = details.targetElement;
                showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: Text(DateFormat('MM/dd/yyyy').format(details.date!)),
                content: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: ListView.builder(
                    shrinkWrap: false,
                    itemCount: details.appointments!.length,
                    itemBuilder: (context, index){
                      Meeting meeting = details.appointments![index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical:4.0),
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical:4.0),
                          decoration: BoxDecoration(
                            color: meeting.background,
                              border: Border.all(
                                color: meeting.background,
                              ),
                              borderRadius: const BorderRadius.all(Radius.circular(10))
                              ),
                          child: ListTile(
                            title: Text(meeting.eventName)
                          ),
                        ),
                      );
                    }),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text("Done"),
                    onPressed: () {
                      // print(projectName[index]);
                      Navigator.of(context).pop();
                    },
                  ),
                ]);

          }
        );
      },
      monthViewSettings: const MonthViewSettings(
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
    ));
  }

  List<Meeting> _getDataSource() {
    final List<Meeting> meetings = <Meeting>[];

    setState(() {
      isLoading = true;
    });
    for(int x = 0; x < allForms!.length; x++){
      if(allForms![x].num_days != null){
        final DateTime today = DateTime.parse(allForms![x].date_start!);
        final DateTime startTime = DateTime(today.year, today.month, today.day);
        final DateTime endTime = startTime.add(Duration(days: allForms![x].num_days!));
        Color color = getColor(allForms![x].work);
        meetings.add(Meeting(
        allForms![x].type, startTime, endTime, color, false));
      }
    }

    setState(() {
      isLoading = false;
    });
     return meetings;
  }

  Color getColor(String type){
    Color? color;
    switch (type) {
      case 'Earthworks':
        color = const Color(0xFF0F8644);
        break;
      case 'Formworks':
        color = const Color.fromARGB(255, 8, 97, 48);
        break;  
      case 'Masonry Works':
        color = Color.fromARGB(255, 9, 161, 123);
        break;  
      case 'Reinforced Cement Works':
        color = Color.fromARGB(255, 8, 94, 97);
        break; 
      case 'Steel Reinforcement Works':
        color = Color.fromARGB(255, 120, 147, 10);
        break;  
      case 'Flooring':
        color = Color.fromARGB(255, 8, 29, 97);
        break; 
      case 'Plastering':
        color = const Color.fromARGB(255, 8, 97, 48);
        break;  
      case 'Painting Works':
        color = const Color.fromARGB(255, 8, 97, 48);
        break; 
      case 'Doors and Windows':
        color = const Color.fromARGB(255, 8, 97, 48);
        break;  
      case 'Ceiling':
        color = const Color.fromARGB(255, 8, 97, 48);
        break; 
      case 'Roofing Works':
        color = const Color.fromARGB(255, 8, 97, 48);
        break;  
      case 'Electrical Works':
        color = const Color.fromARGB(255, 8, 97, 48);
        break; 
      case 'Plumbing Works':
        color = const Color.fromARGB(255, 8, 97, 48);
        break;                                                                
       default:
        color = const Color.fromARGB(255, 184, 212, 44);
        break;
    }

    return color;
  }
}

/// An object to set the appointment collection data source to calendar, which
/// used to map the custom appointment data to the calendar appointment, and
/// allows to add, remove or reset the appointment collection.
class MeetingDataSource extends CalendarDataSource {
  /// Creates a meeting data source, which used to set the appointment
  /// collection to the calendar
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return _getMeetingData(index).from;
  }

  @override
  DateTime getEndTime(int index) {
    return _getMeetingData(index).to;
  }

  @override
  String getSubject(int index) {
    return _getMeetingData(index).eventName;
  }

  @override
  Color getColor(int index) {
    return _getMeetingData(index).background;
  }

  @override
  bool isAllDay(int index) {
    return _getMeetingData(index).isAllDay;
  }

  Meeting _getMeetingData(int index) {
    final dynamic meeting = appointments![index];
    late final Meeting meetingData;
    if (meeting is Meeting) {
      meetingData = meeting;
    }

    return meetingData;
  }
}

/// Custom business object class which contains properties to hold the detailed
/// information about the event data which will be rendered in calendar.
class Meeting {
  /// Creates a meeting class with required details.
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  /// Event name which is equivalent to subject property of [Appointment].
  String eventName;

  /// From which is equivalent to start time property of [Appointment].
  DateTime from;

  /// To which is equivalent to end time property of [Appointment].
  DateTime to;

  /// Background which is equivalent to color property of [Appointment].
  Color background;

  /// IsAllDay which is equivalent to isAllDay property of [Appointment].
  bool isAllDay;
}