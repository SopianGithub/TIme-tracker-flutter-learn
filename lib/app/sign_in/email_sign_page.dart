import 'package:example_app/app/sign_in/email_sign_in_form_bloc_based.dart';
import 'package:flutter/material.dart';

class EmailSignPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Time Tracker'),
          elevation: 2.0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
               child: EmailSignInFormBlocBased.create(context)
            )
          ),
        )
    );
  }

}
