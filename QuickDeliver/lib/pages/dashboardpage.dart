import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // <-- Import this for status bar control
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:your_project_name/Models/AppConstants.dart';
import 'package:your_project_name/Models/BaseDto.dart';
import 'package:your_project_name/Network/HttpService.dart';
import 'package:your_project_name/pages/DeliveriesPage.dart'; // Import DeliveriesPage
import 'package:your_project_name/pages/settingspage.dart';
import 'package:your_project_name/widgets/ErrorDialog.dart'; // Import SettingsPage

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;
  //DateTime? _lastBackPressTime;

  // List of pages for Bottom Navigation
  final List<Widget> _pages = [
    DbPageContent(onchange: () {}),
    DeliveryStagesPage(stage: 'All'), // DeliveriesPage added here
    SettingsPage(), // SettingsPage added here
  ];

  // Future<bool> _onWillPop() async {
  //   bool? shouldExit = await showDialog<bool>(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: Text('Exit App?'),
  //       content: Text('Do you want to exit the application?'),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.of(context).pop(false),
  //           child: Text('No'),
  //         ),
  //         TextButton(
  //           onPressed: () => Navigator.of(context).pop(true),
  //           child: Text('Yes'),
  //         ),
  //       ],
  //     ),
  //   );

  //   if (shouldExit ?? false) {
  //     SystemNavigator.pop(); // Close the entire app
  //     return true;
  //   }
  //   return false;
  // }

  @override
  Widget build(BuildContext context) {
    // Set status bar color and icon brightness
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white, // White background for status bar
      statusBarIconBrightness:
          Brightness.dark, // Dark icons for light background
      statusBarBrightness: Brightness.light, // For iOS devices
    ));

    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.delivery_dining),
              label: 'Deliveries',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
          currentIndex: _currentIndex,
          selectedItemColor: Color(0xFF35BC77),
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
        body: SafeArea(
          child: _pages[_currentIndex],
        ),
      ),
    );
  }
}

class DbPageContent extends StatefulWidget {
  Function() onchange;
  DbPageContent({required this.onchange, super.key});

  @override
  State<DbPageContent> createState() => _DbPageContentState();
}

class _DbPageContentState extends State<DbPageContent> {
  List<DbElementDto> dblist = [];

  int aCount = 0;
  int pCount = 0;
  int tCount = 0;
  int dCount = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchDb();
  }

  fetchDb() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final res = await getDb(
          appUser.deliveryAgentId, DateFormat("ddMMMyyyy").format(appMainDate));

      if (!mounted) {
        return;
      }

      if (res != null) {
        BaseDto baseDto = BaseDto.fromJson(res);

        setState(() {
          // Replace the data instead of adding to it
          dblist = baseDto.lst!.map((e) => DbElementDto.fromJson(e)).toList();

          // Reset counts first
          aCount = 0;
          pCount = 0;
          tCount = 0;
          dCount = 0;

          // Update counts from new data
          if (dblist.where((e) => e.status == "Assigned").isNotEmpty) {
            aCount = dblist.where((e) => e.status == "Assigned").first.count;
          }

          if (dblist.where((e) => e.status == "Picked").isNotEmpty) {
            pCount = dblist.where((e) => e.status == "Picked").first.count;
          }

          if (dblist.where((e) => e.status == "InTransit").isNotEmpty) {
            tCount = dblist.where((e) => e.status == "InTransit").first.count;
          }

          if (dblist.where((e) => e.status == "Delivered").isNotEmpty) {
            dCount = dblist.where((e) => e.status == "Delivered").first.count;
          }

          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (ex) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        rinErrorDialog(context, ex.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: RefreshIndicator(
            // displacement: 100,
            onRefresh: () async {
              await fetchDb();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Hey ${appUser.userName} !!",
                        style: TextStyle(
                          fontFamily: 'LateFont',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.grey[200],
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 0.5,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 23,
                            backgroundImage: NetworkImage(appUser.imageUrl),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.store, color: Colors.orange),
                      SizedBox(width: 10),
                      Text(
                        appUser.storeName,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'LateFont',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16),
                      SizedBox(width: 5),
                      GestureDetector(
                        onTap: () async {
                          final pickedDate = await showDatePicker(
                            context: context,
                            initialDate: appMainDate,
                            firstDate:
                                DateTime.now().add(const Duration(days: -90)),
                            lastDate:
                                DateTime.now().add(const Duration(days: 30)),
                          );
                          if (pickedDate != null) {
                            // Clear previous data immediately
                            setState(() {
                              appMainDate = pickedDate;
                              aCount = 0;
                              pCount = 0;
                              tCount = 0;
                              dCount = 0;
                              dblist.clear();
                            });

                            // Fetch new data
                            await fetchDb();
                          }
                        },
                        child: Text(
                          DateFormat("dd MMM yyyy").format(appMainDate),
                          style: TextStyle(fontFamily: 'LateFont'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  if (!_isLoading) // Delivery Cards
                    SizedBox(
                      width: double.infinity,
                      height: 100,
                      child: GestureDetector(
                        onTap: () {
                          widget.onchange();
                        },
                        child: DeliveryCard(
                          count: aCount.toString(),
                          label: "Assigned Deliveries",
                          color: Color(0xFF35BC77),
                          subtitle:
                              "Up to ${DateFormat("dd MMM yyyy").format(appMainDate)}",
                        ),
                      ),
                    ),
                  if (!_isLoading)
                    SizedBox(
                      width: double.infinity,
                      height: 100,
                      child: DeliveryCard(
                        count: pCount.toString(),
                        label: "Picked Up",
                        color: Color(0xFF35BC77),
                        subtitle:
                            "Up to ${DateFormat("dd MMM yyyy").format(appMainDate)}",
                      ),
                    ),
                  if (!_isLoading)
                    SizedBox(
                      width: double.infinity,
                      height: 100,
                      child: DeliveryCard(
                        count: tCount.toString(),
                        label: "In Transit",
                        color: Color(0xFF35BC77),
                        subtitle:
                            "Up to ${DateFormat("dd MMM yyyy").format(appMainDate)}",
                      ),
                    ),
                  if (!_isLoading)
                    SizedBox(
                      width: double.infinity,
                      height: 100,
                      child: DeliveryCard(
                        count: dCount.toString(),
                        label: "Delivered",
                        color: Color(0xFF35BC77),
                        subtitle:
                            "On ${DateFormat("dd MMM yyyy").format(appMainDate)}",
                      ),
                    ),
                  if (_isLoading)
                    Container(
                      height: 400,
                      width: double.infinity,
                      child: const CupertinoActivityIndicator(
                          radius: 15, animating: true, color: Colors.green),
                    ),

                  200.height,
                ],
              ),
            )));
  }
}

class DeliveryCard extends StatelessWidget {
  final String count;
  final String label;
  final String subtitle;
  final Color color;

  DeliveryCard(
      {required this.count,
      required this.subtitle,
      required this.label,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: color,
            child: Text(
              count,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              5.height,
              Text(
                label,
                style: const TextStyle(fontSize: 18, fontFamily: "LateFont"),
              ),
              Text(
                subtitle,
                style: TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    fontFamily: "LateFont",
                    color: Colors.grey.shade600),
              )
            ],
          )
        ],
      ),
    );
  }
}
