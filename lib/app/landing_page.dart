import 'package:example_app/app/home_page.dart';
import 'package:example_app/app/sign_in/sign_in_page.dart';
import 'package:example_app/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Landingpage extends StatelessWidget {
  // const Landingpage({Key key, @required this.auth}) : super(key: key);
  // final AuthBase auth;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return StreamBuilder<User>(
        stream: auth.authStateChanges(),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.active){
            final User user = snapshot.data;
            if (user == null){
              return SignInPage.create(context);
            }
            return HomePage();
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
    );
  }
}
