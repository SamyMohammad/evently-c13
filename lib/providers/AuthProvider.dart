import 'package:evently_c13/db/dao/users_dao.dart';
import 'package:evently_c13/db/model/AppUser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  AppUser? appUser;
  User? firebaseAuthUser;

  AuthProvider() {
    firebaseAuthUser = FirebaseAuth.instance.currentUser;
    if (firebaseAuthUser != null) {
      readUser();
    }
  }

  void readUser() async {
    appUser = await UsersDao.readUser(firebaseAuthUser!.uid);
    notifyListeners();
  }

  bool isLoggedIn() {
    return firebaseAuthUser != null;
  }

  void logout() {
    FirebaseAuth.instance.signOut();
    appUser = null;
    firebaseAuthUser = null;
  }

  void saveUser(AppUser? user) {
    appUser = user;
    firebaseAuthUser = FirebaseAuth.instance.currentUser;
    notifyListeners();
  }
}
