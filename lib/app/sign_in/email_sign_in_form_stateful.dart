import 'dart:io';

import 'package:example_app/app/sign_in/validator.dart';
import 'package:example_app/common_widgets/form_submit_button.dart';
import 'package:example_app/common_widgets/show_alert_dialog.dart';
import 'package:example_app/common_widgets/show_exception_alert_dialog.dart';
import 'package:example_app/services/auth.dart';
import 'package:example_app/services/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'email_sign_in_model.dart';


class EmailSignInForm extends StatefulWidget with EmailAndPasswordValidator {

  @override
  EmailSignInFormStateful createState() => EmailSignInFormStateful();
}

class EmailSignInFormStateful extends State<EmailSignInForm> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  String get _email => _emailController.text;
  String get _password => _passwordController.text;
  EmailSignInFormType _formType = EmailSignInFormType.signIn;
  bool _submitted = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _submit() async {
    setState(() {
      _submitted = true;
      _isLoading = true;
    });
    try {
      // Simulasi for Network delay, dont used in production
      // await Future.delayed(Duration(seconds: 3));

      final auth = AuthProvider.of(context);
      if (_formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(_email, _password);
      } else {
        await auth.createUserWithEmailAndPassword(_email, _password);
      }
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      ShowExceptionAlertDialog(
          context,
          title: 'Sign In Failed',
          exception: e
      );
      // showAlertDialog(
      //     context,
      //     title: 'Sign In Failed',
      //     content: e.toString(),
      //     defaultAction: 'Ok'
      // );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _emailEditingComplete() {
    final _newFocus = widget.emailValidator.isValid(_email)
        ? _passwordFocusNode : _emailFocusNode;
    FocusScope.of(context).requestFocus(_newFocus);
  }

  void _toggleFormType(){
    setState(() {
      _submitted = false;
      _formType = _formType == EmailSignInFormType.signIn ?
          EmailSignInFormType.register : EmailSignInFormType.signIn;
    });
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChild() {
    final primaryText = _formType == EmailSignInFormType.signIn ? 'Sign In' : 'Create an account';
    final secondaryText = _formType == EmailSignInFormType.signIn ? 'Need an account? Register' : 'have an account? Sign In';

    // bool submitEnabled = _email.isNotEmpty && _password.isNotEmpty;
    bool submitEnabled = widget.emailValidator.isValid(_email)
        && widget.passwordValidator.isValid(_password) && !_isLoading;

    return [
      _buildEmailTextField(),
      SizedBox(height: 8.0),
      _buildPasswordTextField(),
      SizedBox(height: 8.0),
      FormSubmitButton(
          text: primaryText,
          onPressed: submitEnabled ? _submit : null
      ),
      SizedBox(height: 8.0),
      FlatButton(
        child: Text(secondaryText),
        onPressed: !_isLoading ? _toggleFormType : null,
      )
    ];
  }

  TextField _buildPasswordTextField() {
    bool showErrorText = _submitted && !widget.emailValidator.isValid(_password);
    return TextField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: showErrorText ? widget.invalidPasswordErrorText : null,
        enabled: _isLoading ==  false,
      ),
      obscureText: true,
      textInputAction: TextInputAction.done,
      onChanged: (email) => _updateState,
      onEditingComplete: _submit,
    );
  }

  TextField _buildEmailTextField() {
    bool showErrorText = _submitted && !widget.emailValidator.isValid(_email);
    return TextField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'test@email.com',
        errorText: showErrorText ? widget.invalidEmailErrorText : null,
        enabled: _isLoading ==  false,
      ),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onChanged: (password) => _updateState,
      onEditingComplete: _emailEditingComplete,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildChild(),
      ),
    );
  }

  void _updateState() {
    setState(() {

    });
  }
}
