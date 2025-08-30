// lib/widgets/delivery_card.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Make sure to import url_launcher

// Function to make a phone call
Future<void> makePhoneCall(String mobileno) async {
  Uri _url = Uri.parse('tel:$mobileno');
  if (!await launchUrl(_url)) {
    throw Exception('Could not Call $mobileno');
  }
}

class DeliveryCard extends StatefulWidget {
  final Delivery delivery;
  final Widget?
      bottomWidget; // Optional widget for the bottom section of the card

  const DeliveryCard({
    Key? key,
    required this.delivery,
    this.bottomWidget,
  }) : super(key: key);

  @override
  State<DeliveryCard> createState() => _DeliveryCardState();
}

class _DeliveryCardState extends State<DeliveryCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[200],
      margin: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.04,
        vertical: 8.0,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      child: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '#${widget.delivery.id}',
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
                      widget.delivery.date,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                        fontFamily: 'Latefont',
                      ),
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
                  widget.delivery.name,
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
                GestureDetector(
                  onTap: () {
                    makePhoneCall(widget.delivery.phone);
                  },
                  child: Text(
                    widget.delivery.phone,
                    style: const TextStyle(
                      fontSize: 17,
                      fontFamily: 'Latefont',
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
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
                  '${widget.delivery.amount}',
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
                  widget.delivery.date,
                  style: const TextStyle(
                    fontSize: 17,
                    color: Colors.grey,
                    fontFamily: 'Latefont',
                  ),
                ),
                const SizedBox(width: 20),
                Row(
                  children: [
                    const Icon(Icons.timelapse, size: 23),
                    const SizedBox(width: 10),
                    Text(
                      widget.delivery.timeSlot,
                      style: const TextStyle(
                        fontSize: 17,
                        color: Colors.grey,
                        fontFamily: 'Latefont',
                      ),
                    ),
                    const SizedBox(width: 15),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 7),
            GestureDetector(
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.location_on,
                          size: 23, color: Colors.grey),
                      const SizedBox(width: 5),
                      Flexible(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Text(
                                widget.delivery.location,
                                maxLines: isExpanded ? null : 1,
                                overflow: isExpanded
                                    ? TextOverflow.visible
                                    : TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 17, fontFamily: 'Latefont'),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Icon(
                              isExpanded
                                  ? Icons.expand_less
                                  : Icons.expand_more,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (isExpanded && widget.delivery.location.length < 50)
                    const Padding(
                      padding: EdgeInsets.only(left: 30.0, top: 5),
                      child: Text(
                        'No additional location details',
                        style: TextStyle(
                          fontSize: 15,
                          fontStyle: FontStyle.italic,
                          fontFamily: 'LateFont',
                          color: Colors.grey,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (widget.bottomWidget != null) widget.bottomWidget!,
          ],
        ),
      ),
    );
  }
}

// Keep the Delivery Model here or in a separate models/delivery.dart file
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
