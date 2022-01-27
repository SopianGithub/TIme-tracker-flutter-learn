import 'package:example_app/common_widgets/show_alert_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<void> ShowExceptionAlertDialog (
  BuildContext context, {
  @required String title,
  @required Exception exception
}) =>
    showAlertDialog(
        context,
        title: title,
        content: _message(exception),
        defaultAction: 'Ok'
    );


String _message(Exception exception){
  if(exception is FirebaseAuthException){
    return exception.message;
  }
  return exception.toString();
}