import 'package:example_app/app/home_page.dart';
import 'package:example_app/app/sign_in/sign_in_page.dart';
import 'package:example_app/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Landingbc extends StatefulWidget {
  const Landingbc({Key key, @required this.auth}) : super(key: key);
  final AuthBase auth;

  @override
  _LandingpageState createState() => _LandingpageState();
}

class _LandingpageState extends State<Landingbc> {

  User _user;

  @override
  void initState() {
    super.initState();
    // widget.auth.authStateChanges().listen((user) {
    //   print('uid ${user?.uid}');
    // });
    _updateUser(widget.auth.currentUser);
  }

  void _updateUser(User user){
    // print('User ID : ${user.uid}');
    setState(() {
      _user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
        stream: widget.auth.authStateChanges(),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.active){
            final User user = snapshot.data;
            if (_user == null){
              return SignInPage(
                 // auth: widget.auth,
                // onSignIn: _updateUser,
              );
            }
            return HomePage(
              // auth: widget.auth,
              // onSignOut: () => _updateUser(null),
            );
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
