import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:your_project_name/Models/AppConstants.dart';
import 'package:your_project_name/Models/UserModel.dart';
import 'package:your_project_name/Network/HttpService.dart';
import 'package:your_project_name/pages/dashboardpage.dart';
import 'package:your_project_name/pages/qr_scanner_screen.dart';
import 'package:http/http.dart' as http;
import 'package:your_project_name/widgets/ErrorDialog.dart';

TextEditingController storeCodeController = TextEditingController();

class LoginScreen extends StatelessWidget {
  TextEditingController unController = TextEditingController();
  TextEditingController pwdController = TextEditingController();
  String errMessage = '';

  login(BuildContext cntx) async {
    Map<String, String> body = {
      "userName": unController.text,
      "password": pwdController.text
    };
    try {
      await getlogin(body).then((res) {
        appUser = UserDto.fromJson(res);

        Navigator.pushReplacement(
          cntx,
          MaterialPageRoute(
            builder: (context) => DashboardPage(),
          ),
        );
      });
    } catch (ex) {
      rinErrorDialog(cntx, ex.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(24.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            10.height,
            Image.asset(
              'assets/2.jpg',
              width: double.infinity,
              fit: BoxFit.fill,
            ),
            // Title
            10.height,
            const Text(
              'Login',
              style: TextStyle(
                fontSize: 30,
                fontFamily: 'LateFont',
                fontWeight: FontWeight.bold,
              ),
            ),
            8.height,
            // Subtitle
            const Text(
              'Please login to continue',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'LateFont',
              ),
            ),
            32.height,

            TextField(
              controller: storeCodeController, // Attach controller
              readOnly: false, // Make it QR-only editable
              style: TextStyle(fontFamily: 'LateFont'),
              decoration: InputDecoration(
                filled: true,
                fillColor:
                    Color.fromARGB(255, 210, 208, 208), // Grey background
                labelText: 'STORECODE',
                labelStyle: TextStyle(fontFamily: 'LateFont'),
                floatingLabelBehavior: FloatingLabelBehavior.never,
                floatingLabelAlignment:
                    FloatingLabelAlignment.start, // Align label to the top
                prefixIcon: Icon(Icons.store, color: Colors.orange),
                suffixIcon: GestureDetector(
                  onTap: () async {
                    String? scannedCode = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QRScannerScreen(),
                      ),
                    );
                    if (scannedCode != null) {
                      print('Scanned Code: $scannedCode');
                      storeCodeController.text = scannedCode; // Update field
                    }
                  },
                  child: Icon(Icons.qr_code_scanner_sharp, color: Colors.grey),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.orange, width: 1.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding:
                    EdgeInsets.only(left: 16, top: 25, right: 16, bottom: 8),
              ),
            ),
            SizedBox(height: 25),
            // Username Field
            TextField(
              controller: unController,
              style: TextStyle(fontFamily: 'LateFont'),
              decoration: InputDecoration(
                filled: true,
                fillColor:
                    Color.fromARGB(255, 210, 208, 208), // Grey background
                labelText: 'USERNAME',
                labelStyle: TextStyle(fontFamily: 'LateFont'),
                floatingLabelBehavior: FloatingLabelBehavior.never,
                floatingLabelAlignment:
                    FloatingLabelAlignment.start, // Align label to the top
                prefixIcon: Icon(Icons.person, color: Colors.green),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green, width: 1.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding:
                    EdgeInsets.only(left: 16, top: 25, right: 16, bottom: 8),
              ),
            ),

            SizedBox(height: 25),
            TextField(
              controller: pwdController,
              style: TextStyle(fontFamily: 'LateFont'),
              obscureText: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: Color.fromARGB(255, 210, 208, 208),
                labelText: 'PASSWORD',
                labelStyle: TextStyle(fontFamily: 'LateFont'),
                floatingLabelBehavior: FloatingLabelBehavior.never,
                floatingLabelAlignment: FloatingLabelAlignment.start,
                prefixIcon: Icon(Icons.lock, color: Colors.green),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green, width: 1.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding:
                    EdgeInsets.only(left: 16, top: 25, right: 16, bottom: 8),
              ),
            ),
            Text(errMessage).visible(errMessage != ''),
            SizedBox(height: 45),
            // Login Button
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFE56437),
                  padding: EdgeInsets.symmetric(vertical: 13, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  login(context);
                },
                child: Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'LateFont',
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
