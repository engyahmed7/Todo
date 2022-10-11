// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/modules/ArchiveTask/archive_task_screen.dart';
import 'package:todo_app/modules/DoneTask/done_task_screen.dart';
import 'package:todo_app/modules/NewTask/new_task_screen.dart';
import 'package:todo_app/shared/components/componenet.dart';

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
  late Database database;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  var statusController = TextEditingController();

  @override
  void initState() {
    super.initState();
    createDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
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
                backgroundImage: AssetImage('images/img.jpg'),
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
        onPressed: () {
          if (isBottomSheetShown) {
            if (formKey.currentState!.validate()) {
              insertToDatabase(
                title: titleController.text,
                time: timeController.text,
                date: dateController.text,
              ).then((value) {
                print('inserted');
              });
              Navigator.pop(context);
              isBottomSheetShown = false;
              setState(() {
                fabIcon = Icons.edit;
              });
            }
          } else {
            scaffoldKey.currentState?.showBottomSheet(
              (context) {
                return Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: formKey,
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        defaultFormField(
                            controller: titleController,
                            type: TextInputType.text,
                            validate: (String? value) {
                              if (value!.isEmpty) {
                                return 'Title must not be empty';
                              }
                              return null;
                            },
                            labelText: 'Task Title',
                            hintText: 'Enter Task Title',
                            prefix: Icons.title),
                        SizedBox(
                          height: 15,
                        ),
                        defaultFormField(
                            controller: timeController,
                            type: TextInputType.datetime,
                            validate: (String? value) {
                              if (value!.isEmpty) {
                                return 'Time must not be empty';
                              }
                              return null;
                            },
                            labelText: 'Task Time',
                            prefix: Icons.watch_later_outlined,
                            onTap: () {
                              showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now())
                                  .then((value) {
                                timeController.text =
                                    value!.format(context).toString();
                              }).catchError((err) {
                                print(err);
                              });
                            }),
                        SizedBox(
                          height: 15.0,
                        ),
                        defaultFormField(
                            controller: dateController,
                            type: TextInputType.datetime,
                            validate: (String? value) {
                              if (value!.isEmpty) {
                                return 'Date must not be empty';
                              }
                              return null;
                            },
                            labelText: 'Task Date',
                            prefix: Icons.calendar_today,
                            onTap: () {
                              showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.parse('2022-11-10'))
                                  .then((value) {
                                dateController.text =
                                    DateFormat.yMMMd().format(value!);
                              }).catchError((err) {
                                print(err);
                              });
                            }),
                        SizedBox(
                          height: 15.0,
                        ),
                      ]),
                    ),
                  ),
                );
              },
              elevation: 50.0,
            );
            isBottomSheetShown = true;
            setState(() {
              fabIcon = Icons.add;
            });
          }
        },
        child: Icon(fabIcon),
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
    database = await openDatabase(path, version: 1, onCreate: (db, version) {
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

  // insert to database with then and catch
  Future insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    await database.transaction((txn) async {
      await txn
          .rawInsert(
              'INSERT INTO tasks(title, date, time,status) VALUES("$title","$date","$time","new")')
          .then((value) {
        print('$value inserted successfully');
      }).catchError((error) {
        print('error when inserting new record ${error.toString()}');
      });
    });
  }
}
