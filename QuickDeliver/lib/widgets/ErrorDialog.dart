import 'package:flutter/material.dart';

Future rinErrorDialog(cntx, message) async {
  FocusNode focusNode = FocusNode();
  void closedailog() {
    Navigator.of(cntx).pop();
  }

  await showDialog(
      context: cntx,
      builder: (cntx) {
        FocusScope.of(cntx).requestFocus(focusNode);
        return AlertDialog(
          alignment: Alignment.center,
          iconPadding: EdgeInsets.all(10),
          title: const Text('Yeah!',
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'LateFont',
                fontWeight: FontWeight.w700,
                color: Color(0xFF35bc77),
              ),
              textAlign: TextAlign.left),
          titlePadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          content: Text(
            message,
            style: const TextStyle(
                fontSize: 16,
                fontFamily: 'LateFont',
                height: 1.4,
                color: Colors.black87),
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          actions: [
            ElevatedButton(
              focusNode: focusNode,
              onPressed: () {
                closedailog();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF35bc77),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: const Text(
                'Okay',
                style: TextStyle(
                    fontSize: 17,
                    fontFamily: 'LateFont',
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
            )
          ],
        );
      });
}
