import 'package:flutter/material.dart';

InputDecoration idHintText(String hintext)
{
  return InputDecoration(hintText: hintext,
    //fillColor: Colors.white,
    //filled: true,
    errorBorder: (OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(100)),)),
    focusedErrorBorder: (OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(100)),)),


    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(100)),
      //   borderSide: BorderSide(color: Colors.white , width: 2),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(100)),
      //  borderSide: BorderSide(color: Colors.white , width: 2),
    ),
  );
}

const textInputDecoration =InputDecoration(                  //another way textInputDecoration.copyWith(hintText : "email"
  //fillColor: Colors.white,
  //filled: true,
  focusedErrorBorder: (OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(100)),)),
  errorBorder: (OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(100)),)),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(100)),
    //borderSide: BorderSide(color: Colors.white , width: 2),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(100)),
    //borderSide: BorderSide(color: Colors.white , width: 2),
  ),
);
