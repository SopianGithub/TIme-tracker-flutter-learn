import 'package:example_app/app/sign_in/email_sign_in_bloc.dart';
import 'package:example_app/app/sign_in/validator.dart';
import 'package:example_app/common_widgets/form_submit_button.dart';
import 'package:example_app/common_widgets/show_exception_alert_dialog.dart';
import 'package:example_app/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'email_sign_in_model.dart';


class EmailSignInFormBlocBased extends StatefulWidget {
  EmailSignInFormBlocBased({ @required this.bloc });
  final EmailSignInChangeModel bloc;

  static Widget create(BuildContext context){
    final auth = Provider.of<AuthBase>(context, listen: false);
    return Provider<EmailSignInChangeModel>(
      create: (_) => EmailSignInChangeModel(auth: auth),
      child: Consumer<EmailSignInChangeModel>(
        builder: (_, bloc, __) => EmailSignInFormBlocBased(bloc: bloc),
      ),
      dispose: (_, bloc) => bloc.dispose(),
    );
  }

  @override
  EmailSignInFormStateful createState() => EmailSignInFormStateful();
}

class EmailSignInFormStateful extends State<EmailSignInFormBlocBased> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    try {
      await widget.bloc.submit();
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      ShowExceptionAlertDialog(
          context,
          title: 'Sign In Failed',
          exception: e
      );
    }
  }

  void _emailEditingComplete(EmailSignInModel model) {
    final _newFocus = model.emailValidator.isValid(model.email)
        ? _passwordFocusNode : _emailFocusNode;
    FocusScope.of(context).requestFocus(_newFocus);
  }

  void _toggleFormType(EmailSignInModel model){
    widget.bloc.toggleFormType();
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChild(EmailSignInModel model) {
    return [
      _buildEmailTextField(model),
      SizedBox(height: 8.0),
      _buildPasswordTextField(model),
      SizedBox(height: 8.0),
      FormSubmitButton(
          text: model.primaryButtonText,
          onPressed: model.canSubmit ? _submit : null
      ),
      SizedBox(height: 8.0),
      FlatButton(
        child: Text(model.secoundaryButtonText),
        onPressed: () => !model.isLoading ? _toggleFormType(model) : null,
      )
    ];
  }

  TextField _buildPasswordTextField(EmailSignInModel model) {
    return TextField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: model.passwordErrorText,
        enabled: model.isLoading ==  false,
      ),
      obscureText: true,
      textInputAction: TextInputAction.done,
      onChanged: widget.bloc.updatePassword,
      onEditingComplete: () => _emailEditingComplete(model),
    );
  }

  TextField _buildEmailTextField(EmailSignInModel model) {
    return TextField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'test@email.com',
        errorText: model.emailErrorText,
        enabled: model.isLoading ==  false,
      ),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onChanged: widget.bloc.updateEmail,
      onEditingComplete: () => _emailEditingComplete(model),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EmailSignInModel>(
      stream: widget.bloc.modelStream,
      initialData: EmailSignInModel(),
      builder: (context, snapshot) {
        final EmailSignInModel model = snapshot.data;
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _buildChild(model),
          ),
        );
      }
    );
  }

}
