import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently_c13/auth/RegisterResponse.dart';
import 'package:evently_c13/db/dao/users_dao.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthServices {
  static var db = FirebaseFirestore.instance;

  static Future<AuthResponse> createAccount(String email, String password,
      String name) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      var user = await UsersDao.createUser(credential.user!.uid, email, name);

      return AuthResponse(userCredential: credential, user: user);
    } on FirebaseAuthException catch (e) {
      var message = "";
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
      }
      return AuthResponse(error: Error(errorMessage: message, exception: e));
    } catch (e) {
      return AuthResponse(
          error: Error(
              errorMessage: "Something went wrong", exception: e as Exception));
    }
  }

  static Future<AuthResponse> login(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // read user from db
      var user = await UsersDao.readUser(credential.user!.uid);
      return AuthResponse(userCredential: credential, user: user);
    } on FirebaseAuthException catch (e) {
      var message = 'Wrong Email or Password';
      // if (e.code == 'user-not-found') {
      //
      // } else if (e.code == 'wrong-password') {
      //   message = 'Wrong password provided for that user.';
      // }
      return AuthResponse(error: Error(errorMessage: message, exception: e));
    } catch (e) {
      return AuthResponse(
          error: Error(
              errorMessage: "Something went wrong", exception: e as Exception));
    }
  }
}
