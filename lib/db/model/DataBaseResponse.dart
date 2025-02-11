import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseResponse<T> {
  Exception? exception;
  T? data;
  bool isSuccess = false;

  DataBaseResponse({this.exception, this.data, required this.isSuccess});

  String getErrorMessage() {
    if (exception is FirebaseException) {
      return (exception as FirebaseException).message ?? "Firebase Exception";
    } else {
      return "Something went wrong";
    }
  }
}
