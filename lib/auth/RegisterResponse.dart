import 'package:evently_c13/db/model/AppUser.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthResponse {
  UserCredential? userCredential;
  AppUser? user;
  Error? error;

  AuthResponse({this.userCredential, this.user, this.error});
}

class Error {
  String? errorMessage;
  Exception? exception;

  Error({this.exception, this.errorMessage});
}
