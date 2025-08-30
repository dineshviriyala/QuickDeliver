import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:your_project_name/pages/LoginPage.dart';
import 'package:your_project_name/pages/dashboardpage.dart';

class onBoardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 50),
            Image.asset(
              'assets/3.png',
              width: MediaQuery.of(context).size.width - 20,
              fit: BoxFit.fill,
            ),
            SizedBox(height: 20),
            Text(
              'QuickDeliver',
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                fontFamily: 'LateFont',
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Lightning-fast service, delivered\nwith a touch of elegance.',
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 60),
            SizedBox(
              width: 150,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFE56437),
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DashboardPage(),
                    ),
                  );
                },
                child: Text(
                  'Demo',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'LateFont',
                  ),
                ),
              ),
            ),
            SizedBox(height: 60),
            SizedBox(
              width: 150,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFE56437),
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );
                },
                child: Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'LateFont',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
