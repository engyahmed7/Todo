// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/modules/ArchiveTask/archive_task_screen.dart';
import 'package:todo_app/modules/DoneTask/done_task_screen.dart';
import 'package:todo_app/modules/NewTask/new_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  List<Widget> screens = [
    NewTaskScreen(),
    DoneTaskScreen(),
    ArchiveTaskScreen()
  ];
  List<String> titles = ['New Task', 'Done Task', 'Archived Task'];

  @override
  void initState() {
    super.initState();
    createDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titles[currentIndex]),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('Engy Ahmed'),
              accountEmail: Text('engya306@gmail.com'),
              currentAccountPicture: CircleAvatar(
                child: Text('A'),
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {},
            ),
          ],
        ),
      ),
      // floatingActionButton: SpeedDial(
      //   animatedIcon: AnimatedIcons.add_event,
      //   children: [
      //     SpeedDialChild(
      //       child: Icon(Icons.copy),
      //       label: 'copy',
      //     ),
      //     SpeedDialChild(
      //       child: Icon(Icons.share),
      //       label: 'share',
      //     ),
      //     SpeedDialChild(
      //       child: Icon(Icons.phone),
      //       label: 'phone',
      //     ),
      //   ],
      //   overlayColor: Colors.grey,
      //   spaceBetweenChildren: 15,
      //   spacing: 10,
      //   closeManually: false,
      // ),
      floatingActionButton: FloatingActionButton(
        // Try Catch Error Handling

        // onPressed: () async {
        //   try {
        //     var name = await getName();
        //     print(name);
        //   } catch (err) {
        //     print('error' + err.toString());
        //   }
        // },

        // Then Catch Error Handling
        onPressed: () {
          getName().then((value) {
            print(value);
          }).catchError((err) {
            print('error' + err.toString());
          });
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Tasks'),
          BottomNavigationBarItem(
              icon: Icon(Icons.check_circle_outline), label: 'Done'),
          BottomNavigationBarItem(
              icon: Icon(Icons.archive_outlined), label: 'Archived'),
        ],
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
      body: screens[currentIndex],
    );
  }

  Future<String> getName() async {
    return 'Engy Ahmed';
  }

  void createDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = databasesPath + 'Todo.db';
    // open the database
    var database =
        await openDatabase(path, version: 1, onCreate: (db, version) {
      print('database created');
      db
          .execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
          .then((value) {
        print('table created');
      }).catchError((error) {
        print('error when creating table ${error.toString()}');
      });
    }, onOpen: (db) {
      print('database opened');
    });
  }
}
