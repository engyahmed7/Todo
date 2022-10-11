// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:todo_app/shared/components/componenet.dart';
import 'package:todo_app/shared/components/constants.dart';

class NewTaskScreen extends StatelessWidget {
  const NewTaskScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context, index) {
          return buildTaskItem(tasks[index]);
        },
        separatorBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsetsDirectional.only(start: 20.0),
            child: Divider(
              thickness: 2,
            ),
          );
        },
        itemCount: tasks.length);
  }
}
