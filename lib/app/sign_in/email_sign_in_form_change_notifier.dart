import 'package:example_app/app/sign_in/email_sign_in_change_model.dart';
import 'package:example_app/common_widgets/form_submit_button.dart';
import 'package:example_app/common_widgets/show_exception_alert_dialog.dart';
import 'package:example_app/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class EmailSignInFormChangeNotifier extends StatefulWidget {
  EmailSignInFormChangeNotifier({ @required this.model });
  final EmailSignInChangeModel model;

  static Widget create(BuildContext context){
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<EmailSignInChangeModel>(
      create: (_) => EmailSignInChangeModel(auth: auth),
      child: Consumer<EmailSignInChangeModel>(
        builder: (_, model, __) => EmailSignInFormChangeNotifier(model: model),
      ),
    );
  }

  @override
  EmailSignInFormStateful createState() => EmailSignInFormStateful();
}

class EmailSignInFormStateful extends State<EmailSignInFormChangeNotifier> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  EmailSignInChangeModel get model => widget.model;

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
      await widget.model.submit();
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      ShowExceptionAlertDialog(
          context,
          title: 'Sign In Failed',
          exception: e
      );
    }
  }

  void _emailEditingComplete() {
    final _newFocus = model.emailValidator.isValid(model.email)
        ? _passwordFocusNode : _emailFocusNode;
    FocusScope.of(context).requestFocus(_newFocus);
  }

  void _toggleFormType(){
    widget.model.toggleFormType();
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChild() {
    return [
      _buildEmailTextField(),
      SizedBox(height: 8.0),
      _buildPasswordTextField(),
      SizedBox(height: 8.0),
      FormSubmitButton(
          text: model.primaryButtonText,
          onPressed: model.canSubmit ? _submit : null
      ),
      SizedBox(height: 8.0),
      FlatButton(
        child: Text(model.secondaryButtonText),
        onPressed: () => !model.isLoading ? _toggleFormType() : null,
      )
    ];
  }

  TextField _buildPasswordTextField() {
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
      onChanged: widget.model.updatePassword,
      onEditingComplete: () => _emailEditingComplete(),
    );
  }

  TextField _buildEmailTextField() {
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
      onChanged: widget.model.updateEmail,
      onEditingComplete: () => _emailEditingComplete(),
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

}
