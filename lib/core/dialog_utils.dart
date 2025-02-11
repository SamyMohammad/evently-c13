import 'package:flutter/material.dart';

extension Dialoges on State {
  void showMessageDialog(
    String message, {
    String? posActionTitle,
    VoidCallback? posAction,
    String? negActionTitle,
    VoidCallback? negAction,
  }) {
    List<Widget> actions = [];
    if (posActionTitle != null) {
      actions.add(TextButton(
          onPressed: () {
            Navigator.pop(context);
            posAction?.call();
          },
          child: Text(posActionTitle)));
    }
    if (negActionTitle != null) {
      actions.add(TextButton(
          onPressed: () {
            Navigator.pop(context);
            negAction?.call();
          },
          child: Text(negActionTitle)));
    }
    showDialog(
      context: context,
      builder: (buildContext) {
        return AlertDialog(
          content: Text(
            message,
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
          actions: actions,
          actionsPadding: EdgeInsets.all(4),
        );
      },
    );
  }

  void showLoadingDialog(
    String message,
  ) {
    showDialog(
      context: context,
      builder: (buildContext) {
        return AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(
                width: 10,
              ),
              Text(
                message,
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ],
          ),
        );
      },
    );
  }

  void hideDialog() {
    Navigator.pop(context);
  }
}
