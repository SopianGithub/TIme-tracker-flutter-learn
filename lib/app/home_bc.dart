
import 'package:example_app/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeBc extends StatelessWidget {
  const HomeBc({Key key, @required this.onSignOut, @required this.auth}) : super(key: key);
  final AuthBase auth;
  final VoidCallback onSignOut;

  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      onSignOut();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: <Widget>[
          FlatButton(
            child: Text('Logout',
              style: TextStyle(fontSize: 18.0, color: Colors.white),
            ),
            onPressed: _signOut,
          )
        ],
      ),
    );
  }
}

