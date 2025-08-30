import 'package:flutter/material.dart';
import 'package:your_project_name/pages/DeliveryDetails.dart'; // Ensure this import is correct

class InTransitPage extends StatefulWidget {
  final String stage;
  const InTransitPage({required this.stage, Key? key}) : super(key: key);

  @override
  State<InTransitPage> createState() => _InTransitPageState();
}

class _InTransitPageState extends State<InTransitPage> {
  late String selectedStage;
  final List<Delivery> deliveries = [
    Delivery(
      id: '12345',
      name: 'Mr. Mahesh Jain',
      phone: '9045614587',
      amount: '16,859.00',
      date: '30 Apr 2025',
      timeSlot: '7pm - 9pm',
      location: 'Madhurawada',
      status: 'In Transit',
    ),
    Delivery(
      id: '12346',
      name: 'Lakshmi Devi',
      phone: '9045614588',
      amount: '7,600.00',
      date: '30 Apr 2025',
      timeSlot: '7pm - 9pm',
      location: 'Madhurawada',
      status: 'In Transit',
    ),
  ];

  @override
  void initState() {
    super.initState();
    selectedStage = widget.stage;
  }

  Widget buildOptionChip(
      {required String title, required VoidCallback onClick}) {
    return GestureDetector(
      onTap: onClick,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Chip(
          label: Text(title),
          backgroundColor: title == selectedStage
              ? const Color.fromARGB(255, 234, 106, 60)
              : const Color.fromARGB(255, 236, 150, 118),
          labelStyle: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredDeliveries = selectedStage == 'All'
        ? deliveries
        : deliveries.where((d) => d.status == selectedStage).toList();

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 80),
          SizedBox(
            height: 30,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                buildOptionChip(
                    title: 'All',
                    onClick: () => setState(() => selectedStage = 'All')),
                buildOptionChip(
                    title: 'Assigned',
                    onClick: () => setState(() => selectedStage = 'Assigned')),
                buildOptionChip(
                    title: 'Picked Up',
                    onClick: () => setState(() => selectedStage = 'Pickup')),
                buildOptionChip(
                    title: 'In Transit',
                    onClick: () =>
                        setState(() => selectedStage = 'In Transit')),
                buildOptionChip(
                    title: 'Delivered',
                    onClick: () => setState(() => selectedStage = 'Delivered')),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredDeliveries.length,
              itemBuilder: (context, index) {
                final delivery = filteredDeliveries[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('#${delivery.id}',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            const Icon(Icons.account_circle_rounded,
                                size: 19, color: Color(0xFF35BC77)),
                            const SizedBox(width: 10),
                            Text(delivery.name),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            const Icon(Icons.add_ic_call_rounded,
                                size: 19, color: Color(0xFFE56437)),
                            const SizedBox(width: 10),
                            Text(delivery.phone),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            const Icon(Icons.currency_rupee_sharp,
                                size: 19, color: Color(0xFF35BC77)),
                            const SizedBox(width: 10),
                            Text('${delivery.amount}'),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            const Icon(Icons.date_range,
                                size: 19, color: Colors.grey),
                            const SizedBox(width: 10),
                            Text(
                              delivery.date,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            const Icon(Icons.timelapse, size: 19),
                            const SizedBox(width: 10),
                            Text(
                              delivery.timeSlot,
                              style: const TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.location_on, size: 16),
                            Text(delivery.location),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                print('Reschedule button pressed');
                                // Add your Reschedule functionality here
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFE56437),
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Reschedule'),
                            ),
                            const SizedBox(width: 100),
                            ElevatedButton(
                              onPressed: () {
                                print('Deliver button pressed');
                                // Add your Deliver functionality here
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF35BC77),
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Deliver'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Delivery {
  final String id;
  final String name;
  final String phone;
  final String amount;
  final String date;
  final String timeSlot;
  final String location;
  final String status;

  Delivery({
    required this.id,
    required this.name,
    required this.phone,
    required this.amount,
    required this.date,
    required this.timeSlot,
    required this.location,
    required this.status,
  });
}
