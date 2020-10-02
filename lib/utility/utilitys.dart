import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void snackBarMessage(BuildContext context, String message) {
  Scaffold.of(context).removeCurrentSnackBar();
  Scaffold.of(context).showSnackBar(SnackBar(
    content: Text(message),
  ));
}

void setColor(Color color, BuildContext context, String selectedDevice) async {
  try {
    var res = await http.post("http://$selectedDevice/colour", body: {
      "r": color.red.toString(),
      "g": color.green.toString(),
      "b": color.blue.toString()
    });
    if (res.statusCode != 200) {
      snackBarMessage(context, "Device Error setting color");
    }
  } on SocketException {
    snackBarMessage(context, "Connection Error");
  }
}
