// @dart=2.9


import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as sd;




Future<void> writeToFile(ByteData data, String path) {
  final buffer = data.buffer;
  return File(path).writeAsBytes(
      buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
}

 navigatTo(context,widget)=> Navigator.push(context,MaterialPageRoute(builder: (context)=>widget));






void NavigatToAndReplace(context,widget)
{
  Navigator.pushAndRemoveUntil(context,
      MaterialPageRoute(builder: (context)=>widget,
      ), (Route<dynamic> route)=>false);
}


 String DateFormate({
   //String dateFormate = "dd-MM-yyyy",
   String dateFormate = "yyyy-MM-dd hh:mm a",
  @required String dateTime,

})
{
  try
  {
    return dateFormate = sd.DateFormat(dateFormate).format(DateTime.parse(dateTime)).toString();
  }
  catch(e)
  {
    return dateTime;
  }

}


// enum
enum ToastStates { SUCCESS, ERROR, WARNING }

Color chooseToastColor(ToastStates state) {
  Color color;

  switch (state) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.amber;
      break;
  }

  return color;
}

// List<String> cardColor = [
//   "#5EB6E4",
//   "#A24DC2",
//   "#CF0072",
//   "#6ABE2B",
//   "#FB7545",
//   "#5B1F69",
//   "#5EB6E4",
//   "#355C7D"
// ];