import 'dart:async';

import 'package:example_app/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class SignInManager {
  SignInManager({@required this.auth, @required this.isLoading});
  final AuthBase auth;
  final ValueNotifier<bool> isLoading;

  // final StreamController<bool> _isLoadingController = StreamController<bool>();
  // Stream<bool> get isLoadingStream =>  _isLoadingController.stream;
  // void dispose () {
  //   _isLoadingController.close();
  // }
  // void setIsLoading(bool isLoading) => _isLoadingController.add(isLoading);

  Future<User> _signIn(Future<User> Function() signInMethod) async {
    try {
      // setIsLoading(true);
      isLoading.value = true;
      return await signInMethod();
    } catch (e) {
      // setIsLoading(false);
      isLoading.value = false;
      rethrow;
    }
    // finally {
    //   setIsLoading(false);
    // }
  }

  Future<User> signInAnonymously() async => await _signIn(auth.signInAnonymously);
  Future<User> signInWithGoogle() async => await _signIn(auth.signInWithGoogle);
  Future<User> signInWithFacebook() async => await _signIn(auth.signInWithFacebook);
}