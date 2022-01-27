import 'package:example_app/app/sign_in/validator.dart';
import 'package:example_app/services/auth.dart';
import 'package:flutter/cupertino.dart';

import 'email_sign_in_model.dart';

class EmailSignInChangeModel with EmailAndPasswordValidator, ChangeNotifier {
  EmailSignInChangeModel({
    @required this.auth,
    this.email = '',
    this.password = '',
    this.formType = EmailSignInFormType.signIn,
    this.isLoading = false,
    this.submitted = false
  });

  final AuthBase auth;
  String email;
  String password;
  EmailSignInFormType formType;
  bool isLoading;
  bool submitted;

  String get primaryButtonText {
    return formType == EmailSignInFormType.signIn ? 'Sign In' : 'Create an account';
  }

  String get secondaryButtonText {
    return formType == EmailSignInFormType.signIn ? 'Need an account? Register' : 'have an account? Sign In';
  }

  bool get canSubmit {
    return emailValidator.isValid(email)
        && passwordValidator.isValid(password) && !isLoading;
  }

  String get passwordErrorText {
    bool showErrorText = submitted && !emailValidator.isValid(password);
    return showErrorText ? invalidPasswordErrorText : null;
  }

  String get emailErrorText {
    bool showErrorText = submitted && !emailValidator.isValid(email);
    return showErrorText ? invalidEmailErrorText : null;
  }

  Future<void> submit() async {
    updateWith(submitted: true, isLoading: true);
    try {
      if(formType == EmailSignInFormType.signIn){
        await auth.signInWithEmailAndPassword(email, password);
      }else{
        await auth.createUserWithEmailAndPassword(email, password);
      }
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  void toggleFormType () {
    final formType = this.formType == EmailSignInFormType.signIn ?
    EmailSignInFormType.register : EmailSignInFormType.signIn;
    updateWith(
        email: '',
        password: '',
        formType: formType,
        isLoading: false,
        submitted: false
    );
  }

  void updateEmail(String email) => updateWith(email: email);

  void updatePassword(String password) => updateWith(password: password);

  void updateWith({
    String email,
    String password,
    EmailSignInFormType formType,
    bool isLoading,
    bool submitted
  }) {
    this.email = email ?? this.email;
    this.password = password ?? this.password;
    this.formType = formType ?? this.formType;
    this.isLoading = isLoading ?? this.isLoading;
    this.submitted = submitted ?? this.submitted;
    notifyListeners();
  }
}