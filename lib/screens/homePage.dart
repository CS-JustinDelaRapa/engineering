// ignore: file_names
import 'package:engineering/widget/customWidgets.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'create/create.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  bool themeValue;
  HomePage({Key? key, required this.themeValue}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.black, size: 30),
        leading: PopupMenuButton<int>(
          icon: const Icon(Icons.menu_outlined),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 0,
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 8.0, left: 8.0),
                    child: Icon(Icons.palette),
                  ),
                  const Text("Change Theme"),
                  Switch(
                      value: widget.themeValue,
                      onChanged: (state) async{
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        setState(() {
                        prefs.setBool('theme', state);  
                        });
                      })
                ],
              ),
            ),
            PopupMenuItem(
              value: 0,
              child: Row(
                children: const [
                  Padding(
                    padding: EdgeInsets.only(right: 8.0, left: 8.0),
                    child: Icon(Icons.info),
                  ),
                  Text("About"),
                ],
              ),
            ),
          ],
        ),
      ),
      // drawer: SafeArea(
      //   child: Drawer(
      //     child: ListView(
      //       // Important: Remove any padding from the ListView.
      //       padding: EdgeInsets.zero,
      //       children: <Widget>[
      //         const Padding(
      //           padding: EdgeInsets.all(16.0),
      //           child: Text(
      //             'Header',
      //           ),
      //         ),
      //         const Divider(
      //           height: 1,
      //           thickness: 1,
      //         ),
      //         ListTile(
      //           leading: const Icon(Icons.favorite),
      //           title: const Text('Item 1'),
      //           selected: _selectedDestination == 0,
      //           onTap: () => selectDestination(0),
      //         ),
      //         ListTile(
      //           leading: const Icon(Icons.delete),
      //           title: const Text('Item 2'),
      //           selected: _selectedDestination == 1,
      //           onTap: () => selectDestination(1),
      //         ),
      //         ListTile(
      //           leading: const Icon(Icons.label),
      //           title: const Text('Item 3'),
      //           selected: _selectedDestination == 2,
      //           onTap: () => selectDestination(2),
      //         ),
      //         const Divider(
      //           height: 1,
      //           thickness: 1,
      //         ),
      //         const Padding(
      //           padding: EdgeInsets.all(16.0),
      //           child: Text(
      //             'Label',
      //           ),
      //         ),
      //         ListTile(
      //           leading: const Icon(Icons.bookmark),
      //           title: const Text('Item A'),
      //           selected: _selectedDestination == 3,
      //           onTap: () {
      //             selectDestination(3);
      //             Navigator.pop(context);
      //           },
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              flex: 4,
              child: Image.asset('assets/images/sample.PNG')),
            CustomWidgets().text_title('Construction Count', 30,1),
            CustomWidgets().text_subtitle('Construction Worker Headcount Application', 14, 1),
            CustomWidgets().nav_Button('Create Project', const Icon(Icons.add),1, context, ()=> const CreateProject()),
            CustomWidgets().nav_Button('Load Project', const Icon(Icons.folder_open),1,context, ()=> const CreateProject()),
            const Flexible(
              flex: 2,
              child: SizedBox(height: 50,)),            
          ],
        ),
      ),
    );
  }
}