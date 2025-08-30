import 'package:flutter/material.dart';
import 'package:your_project_name/pages/DeliveryDetails.dart'; // Ensure this import is correct
import 'package:your_project_name/pages/reschedulePage.dart';
import 'package:your_project_name/Models/DeliveryDto.dart';

class DeliveredPage extends StatefulWidget {
  final String stage;
  const DeliveredPage({required this.stage, Key? key}) : super(key: key);

  @override
  State<DeliveredPage> createState() => _DeliveredPageState();
}

class _DeliveredPageState extends State<DeliveredPage> {
  late String selectedStage;
  List<Delivery> deliveries = [
    Delivery(
      docno: '1',
      id: '12345',
      name: 'Mr. Mahesh Jain',
      phone: '9045614587',
      amount: '16,859.00',
      date: '30 Apr 2025',
      timeSlot: '6pm - 8pm',
      location: 'Madhurawada',
      status: 'Delivered',
    ),
    Delivery(
      docno: '1',
      id: '12346',
      name: 'Lakshmi Devi',
      phone: '9045614588',
      amount: '7,600.00',
      date: '30 Apr 2025',
      timeSlot: '4pm - 6pm',
      location: 'Madhurawada',
      status: 'Delivered',
    ),
  ];

  @override
  void initState() {
    super.initState();
    selectedStage = widget.stage;
  }

  // Helper method to create DeliveryDto from Delivery
  DeliveryDto createDeliveryDto(Delivery delivery) {
    return DeliveryDto()
      ..deliveryId = int.tryParse(delivery.id) ?? 0
      ..docNo = delivery.docno
      ..customerName = delivery.name
      ..mobileNo = delivery.phone
      ..amount = double.tryParse(delivery.amount.replaceAll(',', '')) ?? 0.0
      ..deliveryZoneName = delivery.location
      ..timeSlotName = delivery.timeSlot
      ..deliveryDate = DateTime.now();
  }

  // Helper method to update delivery after rescheduling
  void updateDeliveryAfterReschedule(String deliveryId, Map<String, dynamic> rescheduleData) {
    print('=== RESCHEDULE DEBUG ===');
    print('Updating delivery $deliveryId with data: $rescheduleData');
    
    final deliveryIndex = deliveries.indexWhere((d) => d.id == deliveryId);
    print('Found delivery at index: $deliveryIndex');
    
    if (deliveryIndex != -1) {
      print('Before update - Date: ${deliveries[deliveryIndex].date}, Time: ${deliveries[deliveryIndex].timeSlot}');
      
      // Force a rebuild by creating a new list
      final updatedDeliveries = List<Delivery>.from(deliveries);
      updatedDeliveries[deliveryIndex] = Delivery(
        docno: deliveries[deliveryIndex].docno,
        id: deliveries[deliveryIndex].id,
        name: deliveries[deliveryIndex].name,
        phone: deliveries[deliveryIndex].phone,
        amount: deliveries[deliveryIndex].amount,
        date: rescheduleData['newDate'] ?? deliveries[deliveryIndex].date,
        timeSlot: rescheduleData['newTimeSlot'] ?? deliveries[deliveryIndex].timeSlot,
        location: deliveries[deliveryIndex].location,
        status: deliveries[deliveryIndex].status,
        isRescheduled: true,
      );
      
      setState(() {
        deliveries = updatedDeliveries;
      });
      
      print('After update - Date: ${deliveries[deliveryIndex].date}, Time: ${deliveries[deliveryIndex].timeSlot}');
      print('=== END RESCHEDULE DEBUG ===');
    } else {
      print('ERROR: Delivery with ID $deliveryId not found!');
    }
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
                  child: Container(
                    decoration: delivery.isRescheduled
                        ? BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFF35BC77),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          )
                        : null,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('#${delivery.docno}',
                                  style: const TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.bold)),
                              if (delivery.isRescheduled)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF35BC77),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text(
                                    'Rescheduled',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
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
                              Icon(Icons.date_range,
                                  size: 19, color: delivery.isRescheduled ? const Color(0xFF35BC77) : Colors.grey),
                              const SizedBox(width: 10),
                              Text(
                                delivery.date,
                                style: TextStyle(
                                  color: delivery.isRescheduled ? const Color(0xFF35BC77) : Colors.grey,
                                  fontWeight: delivery.isRescheduled ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              Icon(Icons.timelapse, size: 19, color: delivery.isRescheduled ? const Color(0xFF35BC77) : Colors.grey),
                              const SizedBox(width: 10),
                              Text(
                                delivery.timeSlot,
                                style: TextStyle(
                                  color: delivery.isRescheduled ? const Color(0xFF35BC77) : Colors.grey,
                                  fontWeight: delivery.isRescheduled ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.location_on, size: 16),
                              Text(delivery.location),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Reschedule button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ReschedulePage(
                                        deliveryDto: createDeliveryDto(delivery),
                                      ),
                                    ),
                                  ).then((value) {
                                    print('Reschedule returned: $value');
                                    if (value != null) {
                                      updateDeliveryAfterReschedule(delivery.id, value);
                                    }
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFE56437),
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('Reschedule'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Delivered text with a tick mark
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: const [
                              Icon(
                                Icons.check_circle,
                                color: Color(0xFF35BC77),
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Delivered',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Latefont',
                                    color: Color(0xFF35BC77)),
                              ),
                            ],
                          ),
                        ],
                      ),
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
  final String docno;
  final String id;
  final String name;
  final String phone;
  final String amount;
  String date;
  String timeSlot;
  final String location;
  final String status;
  bool isRescheduled;

  Delivery({
    required this.docno,
    required this.id,
    required this.name,
    required this.phone,
    required this.amount,
    required this.date,
    required this.timeSlot,
    required this.location,
    required this.status,
    this.isRescheduled = false,
  });
}
