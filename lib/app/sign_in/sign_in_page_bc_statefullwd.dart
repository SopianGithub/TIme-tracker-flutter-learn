import 'package:example_app/app/sign_in/email_sign_page.dart';
import 'package:example_app/app/sign_in/sign_in_bloc.dart';
import 'package:example_app/app/sign_in/sign_in_button.dart';
import 'package:example_app/app/sign_in/social_sign_in_button.dart';
import 'package:example_app/common_widgets/show_exception_alert_dialog.dart';
import 'package:example_app/services/auth.dart';
import 'package:example_app/services/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  static Widget create(BuildContext context){
    return Provider<SignInManager>(
      create: (_) => SignInManager(),
      child: SignInPage(),
    );
  }

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  void _showSignError(BuildContext context, Exception exception) {
    if(exception is FirebaseAuthException && exception.code == "ERROR_ABORTED_BY_USER"){
      return;
    }
    ShowExceptionAlertDialog(
        context,
        title: 'Sign In Failed',
        exception: exception
    );
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    final bloc = Provider.of<SignInManager>(context, listen: false);
    try {
      bloc.setIsLoading(true);
      final auth = Provider.of<AuthBase>(context, listen: false);
      final user = await auth.signInAnonymously();
    } on Exception catch (e) {
      _showSignError(context, e);
    } finally {
      bloc.setIsLoading(false);
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    final bloc = Provider.of<SignInManager>(context, listen: false);
    try {
      bloc.setIsLoading(true);
      final auth = Provider.of<AuthBase>(context, listen: false);
      final user = await auth.signInWithGoogle();
    } on Exception catch (e) {
      _showSignError(context, e);
    } finally {
      bloc.setIsLoading(false);
    }
  }

  Future<void> _signInWithFacebook(BuildContext context) async {
    final bloc = Provider.of<SignInManager>(context, listen: false);
    try {
      bloc.setIsLoading(true);
      final auth = Provider.of<AuthBase>(context, listen: false);
      final user = await auth.signInWithFacebook();
    } on Exception catch (e) {
      _showSignError(context, e);
    } finally {
      bloc.setIsLoading(false);
    }
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(
        MaterialPageRoute<void>(
            fullscreenDialog: true,
            builder: (context) => EmailSignPage()
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<SignInManager>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          title: Text('Time Tracker'),
          elevation: 2.0,
        ),
        body: StreamBuilder<bool>(
            stream: bloc.isLoadingStream,
            initialData: false,
            builder: (context, snapshot) {
              return _buildContent(context, snapshot.data);
            }
        )
    );
  }

  Widget _buildContent(BuildContext context, bool isLoading) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 50.0,
            child: _buildHeader(isLoading),
          ),
          SizedBox(height: 48.0),
          SocialSignInButton(
            assetName: 'images/google-logo.png',
            text: 'Sign in with Google',
            textColor: Colors.black87,
            color: Colors.white,
            onPressed: isLoading ? null : () => _signInWithGoogle(context),
          ),
          SizedBox(height: 8.0),
          SocialSignInButton(
            assetName: 'images/facebook-logo.png',
            text: 'Sign in with Facebook',
            textColor: Colors.white,
            color: Color(0xFF334D92),
            onPressed: isLoading ? null : () => _signInWithFacebook(context),
          ),
          SizedBox(height: 8.0),
          SignInButton(
            text: 'Sign in with email',
            textColor: Colors.white,
            color: Colors.teal[700],
            onPressed: isLoading ? null : () => _signInWithEmail(context),
          ),
          SizedBox(height: 8.0),
          Text(
            'or',
            style: TextStyle(fontSize: 14.0, color: Colors.black87),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.0),
          SignInButton(
            text: 'Go anonymous',
            textColor: Colors.black,
            color: Colors.lime[300],
            onPressed: isLoading ? null : () => _signInAnonymously(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isLoading) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Text(
      'Sign in',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 32.0,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}