import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:your_project_name/Models/DeliveryDto.dart';
import 'package:your_project_name/Models/ResultDto.dart';
import 'package:your_project_name/Models/TimeSlotDto.dart';
import 'package:your_project_name/Network/HttpService.dart';
import 'package:your_project_name/widgets/ErrorDialog.dart';

class ReschedulePage extends StatefulWidget {
  DeliveryDto deliveryDto;

  ReschedulePage({
    required this.deliveryDto,
    Key? key,
  }) : super(key: key);

  @override
  State<ReschedulePage> createState() => _ReschedulePageState();
}

class _ReschedulePageState extends State<ReschedulePage> {
  TimeSlotDto? selectedTimeSlot;
  DateTime selectedDate = DateTime.now().add(const Duration(days: 5));
  bool _isProcessing = false;
  bool _isLoadingTimeSlots = true;
  List<TimeSlotDto> timeSlots = [];

  @override
  void initState() {
    super.initState();
    _loadTimeSlots();
  }

  Future<void> _loadTimeSlots() async {
    try {
      print('=== LOADING TIME SLOTS ===');
      print('Branch ID: ${widget.deliveryDto.branchId}');

      setState(() {
        _isLoadingTimeSlots = true;
      });

      // Use branch ID from delivery or default to 1 if not available
      int branchId =
          widget.deliveryDto.branchId > 0 ? widget.deliveryDto.branchId : 1;
      print('Using branch ID: $branchId');

      final result = await getTimeSlotList(branchId);

      print('=== TIME SLOT RESULT ===');
      print('Result type: ${result.runtimeType}');
      print('Result: $result');

      if (result != null) {
        setState(() {
          // Handle the actual server response format
          List<dynamic> timeSlotList;
          if (result is Map<String, dynamic>) {
            // Server returns {"lst": [...], "obj": null, "executionTime": ...}
            if (result.containsKey('lst')) {
              timeSlotList = result['lst'] as List<dynamic>;
            } else {
              timeSlotList = [];
            }
          } else if (result is List) {
            timeSlotList = result;
          } else {
            timeSlotList = [];
          }

          timeSlots = timeSlotList
              .map((e) => TimeSlotDto.fromJson(e))
              .where((slot) => slot.isActive)
              .toList();
          _isLoadingTimeSlots = false;

          print('=== PARSED TIME SLOTS ===');
          print('Time slots count: ${timeSlots.length}');
          for (var slot in timeSlots) {
            print(
                'TimeSlot: ID=${slot.timeSlotId}, Name=${slot.timeSlotName}, Display=${slot.timeSlotDisplay}, Active=${slot.isActive}');
          }
        });
      }
    } catch (e) {
      print('Error loading time slots: $e');
      setState(() {
        _isLoadingTimeSlots = false;
        // Add some default time slots as fallback (matching server format)
        timeSlots = [
          TimeSlotDto()
            ..timeSlotId = 1
            ..timeSlotName = '07.00 PM - 09:00 PM'
            ..timeSlotDisplay = '07.00 PM - 09:00 PM'
            ..isActive = true,
          TimeSlotDto()
            ..timeSlotId = 2
            ..timeSlotName = '10.00 AM - 12.00 AM'
            ..timeSlotDisplay = '10.00 AM - 12.00 AM'
            ..isActive = true,
          TimeSlotDto()
            ..timeSlotId = 3
            ..timeSlotName = '5 am - 6 am'
            ..timeSlotDisplay = '5 am - 6 am'
            ..isActive = true,
        ];
      });
      // Show error message
      if (mounted) {
        await rinErrorDialog(context, 'Error loading time slots: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            _buildDeliveryInfoSection(),
            const SizedBox(height: 24),
            const Divider(thickness: 1),
            const SizedBox(height: 24),
            _buildDateSection(),
            const SizedBox(height: 24),
            const Divider(thickness: 1),
            const SizedBox(height: 24),
            _buildTimeSlotsSection(),
            const SizedBox(height: 24),
            const Divider(thickness: 1),
            const SizedBox(height: 24),
            _buildNewScheduleSection(),
            const SizedBox(height: 40),
            _buildContinueButton(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildDeliveryInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Reschedule Delivery',
          style: TextStyle(
              fontSize: 20,
              fontFamily: 'Latefont',
              fontWeight: FontWeight.bold),
        ),
        const Divider(thickness: 1),
        const SizedBox(height: 16),
        buildpickupCard(widget.deliveryDto),
      ],
    );
  }

  Widget buildpickupCard(DeliveryDto delivery) {
    return Card(
      color: Colors.grey[200],
      margin: const EdgeInsets.all(10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '#${delivery.docNo}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Latefont',
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.date_range, size: 30, color: Colors.grey),
                    const SizedBox(width: 10),
                    Text(
                      DateFormat("dd MMM yyyy").format(delivery.docDate),
                      style: const TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                          fontFamily: 'Latefont'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.account_circle_rounded,
                    size: 23, color: Color(0xFF35BC77)),
                const SizedBox(width: 10),
                Text(
                  delivery.customerName,
                  style: const TextStyle(fontSize: 17, fontFamily: 'Latefont'),
                ),
              ],
            ),
            const SizedBox(height: 7),
            Row(
              children: [
                const Icon(Icons.add_ic_call_rounded,
                    size: 23, color: Color(0xFFE56437)),
                const SizedBox(width: 10),
                Text(
                  delivery.mobileNo,
                  style: const TextStyle(fontSize: 17, fontFamily: 'Latefont'),
                ),
              ],
            ),
            const SizedBox(height: 7),
            Row(
              children: [
                const Icon(Icons.currency_rupee_sharp,
                    size: 23, color: Color(0xFF35BC77)),
                const SizedBox(width: 10),
                Text(
                  '${delivery.amount}',
                  style: const TextStyle(
                    fontSize: 17,
                    fontFamily: 'Latefont',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 7),
            Row(
              children: [
                const Icon(Icons.date_range, size: 23, color: Colors.grey),
                const SizedBox(width: 10),
                Text(
                  DateFormat("dd MMM yyyy").format(delivery.deliveryDate),
                  style: const TextStyle(
                      fontSize: 17, color: Colors.grey, fontFamily: 'Latefont'),
                ),
                SizedBox(width: 20),
              ],
            ),
            const SizedBox(height: 7),
            Row(
              children: [
                const Icon(Icons.timelapse, size: 23),
                const SizedBox(width: 10),
                Text(
                  delivery.timeSlotName,
                  style: const TextStyle(
                      fontSize: 17, color: Colors.grey, fontFamily: 'Latefont'),
                ),
                const SizedBox(width: 15),
              ],
            ),
            const SizedBox(height: 7),
            Row(
              children: [
                const Icon(Icons.location_on, size: 23, color: Colors.grey),
                const SizedBox(width: 10),
                Text(
                  delivery.deliveryZoneName,
                  style: const TextStyle(fontSize: 17, fontFamily: 'Latefont'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Reschedule Date',
          style: TextStyle(
              fontSize: 20,
              fontFamily: "Latefont",
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () async {
            final pickedDate = await showDatePicker(
              context: context,
              initialDate: selectedDate,
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 30)),
            );
            if (pickedDate != null) {
              setState(() {
                selectedDate = pickedDate;
              });
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${selectedDate.day} ${_getMonthName(selectedDate.month)} ${selectedDate.year}",
                  style: const TextStyle(fontFamily: 'Latefont', fontSize: 16),
                ),
                const Icon(Icons.calendar_today, size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSlotsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Reschedule Time',
          style: TextStyle(
              fontSize: 20,
              fontFamily: "Latefont",
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        if (_isLoadingTimeSlots)
          const Center(
            child: CircularProgressIndicator(),
          )
        else if (timeSlots.isEmpty)
          const Center(
            child: Text(
              'No time slots available',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Latefont',
                color: Colors.grey,
              ),
            ),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: timeSlots.map((slot) {
              return ChoiceChip(
                label: Text(slot.timeSlotDisplay),
                selected: selectedTimeSlot?.timeSlotId == slot.timeSlotId,
                onSelected: (selected) {
                  setState(() {
                    selectedTimeSlot = selected ? slot : null;
                  });
                },
                selectedColor: const Color(0xFFE56437),
                labelStyle: TextStyle(
                  color: selectedTimeSlot?.timeSlotId == slot.timeSlotId
                      ? Colors.white
                      : Colors.black,
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildNewScheduleSection() {
    if (selectedTimeSlot == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'New Schedule',
          style: TextStyle(
              fontSize: 20,
              fontFamily: "Latefont",
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF35BC77).withOpacity(0.1),
            border: Border.all(color: const Color(0xFF35BC77)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.calendar_today, color: Color(0xFF35BC77)),
                  const SizedBox(width: 8),
                  Text(
                    "${selectedDate.day} ${_getMonthName(selectedDate.month)} ${selectedDate.year}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'Latefont',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.access_time, color: Color(0xFF35BC77)),
                  const SizedBox(width: 8),
                  Text(
                    selectedTimeSlot!.timeSlotDisplay,
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'Latefont',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContinueButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: (selectedTimeSlot == null || _isProcessing)
            ? null
            : () async {
                setState(() {
                  _isProcessing = true;
                });

                try {
                  // Format the date for API (format: 20May2025)
                  String formattedDate =
                      "${selectedDate.day.toString().padLeft(2, '0')}${_getMonthName(selectedDate.month)}${selectedDate.year}";

                  // Make API call to reschedule delivery
                  final result = await rescheduleDelivery(
                    widget.deliveryDto.deliveryId,
                    formattedDate,
                    selectedTimeSlot!.timeSlotId.toString(),
                  );

                  print('=== RESCHEDULE RESULT ===');
                  print('API Result: $result');
                  print('Formatted Date: $formattedDate');
                  print(
                      'Selected Time Slot: ${selectedTimeSlot!.timeSlotDisplay}');

                  // Show success message
                  await rinErrorDialog(
                      context, 'Delivery rescheduled successfully!');

                  // Return the rescheduled data for UI update
                  final rescheduleData = {
                    'newDate': formattedDate,
                    'newTimeSlot': selectedTimeSlot!
                        .timeSlotName, // Use server format for display
                    'newTimeSlotServer':
                        selectedTimeSlot!.timeSlotName, // Server format
                  };

                  print('Returning reschedule data: $rescheduleData');
                  Navigator.pop(context, rescheduleData);
                } catch (ex) {
                  // Show error message
                  await rinErrorDialog(context, ex.toString());
                } finally {
                  setState(() {
                    _isProcessing = false;
                  });
                }
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE56437),
        ),
        child: _isProcessing
            ? const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Processing...',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'LateFont',
                    ),
                  ),
                ],
              )
            : const Text(
                'Continue',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'LateFont',
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: 1,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_shipping),
          label: 'Deliveries',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
      onTap: (index) {},
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }
}

class Delivery {
  final String id, name, phone, date, location, amount, timeSlot;
  Delivery(
      {required this.id,
      required this.name,
      required this.phone,
      required this.date,
      required this.location,
      required this.amount,
      required this.timeSlot});
}
