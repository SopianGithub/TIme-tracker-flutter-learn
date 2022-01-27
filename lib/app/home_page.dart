
import 'package:example_app/common_widgets/show_alert_dialog.dart';
import 'package:example_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {

  Future<void> _signOut(BuildContext context) async {
    print('Sign Out');
    try {
      // final auth = AuthProvider.of(context);
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await showAlertDialog(
        context,
        title: 'Logout',
        content: 'Are you sure that you want to logout?',
        cancelActionText: 'Cancel',
        defaultAction: 'Logout'
    );

    if(didRequestSignOut == true){
      _signOut(context);
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
              onPressed: () => _confirmSignOut(context),
          )
        ],
      ),
    );
  }
}

