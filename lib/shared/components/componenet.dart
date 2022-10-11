// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.blue,
  isUpperCase = true,
  double radius = 0.0,
  required Function function,
  required String text,
}) =>
    Container(
      width: width,
      height: 50.0,
      child: MaterialButton(
          onPressed: function as void Function()?,
          child: Text(
            isUpperCase ? text.toUpperCase() : text,
            style: TextStyle(color: Colors.white, fontSize: 18),
          )),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(radius),
      ),
    );

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  Function(String)? onSubmit,
  Function(String)? onChange,
  Function()? onTap,
  required String? Function(String?)? validate,
  required String labelText,
  String? hintText,
  required IconData prefix,
  IconData? suffix,
  bool isPassword = false,
  Function()? suffixPressed,
  bool isClickable = true,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      onFieldSubmitted: onSubmit,
      onChanged: onChange,
      onTap: onTap,
      validator: validate,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        enabled: isClickable,
        // labelStyle: TextStyle(
        //   color: Colors.grey,
        // ),
        hintStyle: TextStyle(
          color: Colors.grey,
        ),
        border: OutlineInputBorder(),
        prefixIcon: Icon(prefix),
        suffixIcon: IconButton(
          onPressed: suffixPressed,
          icon: Icon(suffix),
        ),
      ),
    );

Widget buildTaskItem(Map map) => Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 40.0,
            child: Text(
              map['time'],
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            width: 20.0,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                map['title'],
                style: TextStyle(
                  fontSize: 22.0,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                map['date'],
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey,
                ),
              ),
            ],
          )
        ],
      ),
    );
