import 'package:flutter/material.dart';

const whiteTextTheme = TextStyle(color: Colors.white);

const primaryColor = Color(0xff543CAF);
const scaffoldColor = Color(0xff050910);

InputDecoration getInputDecoration(String label) {
  var inputDecoration = InputDecoration(
    label: Text(label),
    labelStyle: const TextStyle(color: Colors.white60),
    enabledBorder: OutlineInputBorder(
      borderSide:
          const BorderSide(color: Colors.white, width: 1, style: BorderStyle.solid),
      borderRadius: BorderRadius.circular(10),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide:
          const BorderSide(color: Color(0xff543CAF), width: 3, style: BorderStyle.solid),
      borderRadius: BorderRadius.circular(10),
    ),
  );
  return inputDecoration;
}
