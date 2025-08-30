import 'dart:io';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:your_project_name/Models/AppConstants.dart';
import 'package:your_project_name/Models/BaseDto.dart';
import 'package:your_project_name/Models/DeliveryDto.dart';
import 'package:your_project_name/Models/ResultDto.dart';
import 'package:your_project_name/Network/HttpService.dart';
import 'package:your_project_name/pages/DeliveryDetails.dart';
import 'package:your_project_name/pages/reschedulePage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:your_project_name/widgets/ErrorDialog.dart';

Future<bool?> showCustomConfirmDialog(BuildContext context, String message) {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        title: const Text(
          'Confirmation',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'LateFont',
          ),
        ),
        content: Text(
          message,
          style: const TextStyle(
            fontSize: 16,
            fontFamily: 'LateFont',
          ),
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey[700],
            ),
            child: const Text(
              'No',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'LateFont',
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF35BC77),
            ),
            child: const Text(
              'Yes',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'LateFont',
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    },
  );
}

class DeliveryStagesPage extends StatefulWidget {
  String stage;

  DeliveryStagesPage({required this.stage, super.key});

  @override
  State<DeliveryStagesPage> createState() => _DeliveryStagesPageState();
}

Future<void> makePhoneCall(String mobileno) async {
  Uri _url = Uri.parse('tel:$mobileno');
  if (!await launchUrl(_url)) {
    throw Exception('Could not Call $mobileno');
  }
}

class _DeliveryStagesPageState extends State<DeliveryStagesPage> {
  String selectedStage = '';
  List<DeliveryDto> deliveriesList = [];
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();
  Map<int, List<File>> _deliveryImages = {}; // Store images for each delivery
  Map<int, bool> _processingDeliveries =
      {}; // Track processing state for each delivery

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedStage = widget.stage;

    fetchData();
  }

  fetchData() async {
    try {
      setState(() {
        _isLoading = true;
      });

      await getDeliveries(appUser.deliveryAgentId,
              DateFormat("ddMMMyyyy").format(appMainDate), selectedStage)
          .then((res) {
        if (!mounted) {
          return;
        }
        if (res != null) {
          print('=== DELIVERIES API RESPONSE ===');
          print('Response: $res');

          BaseDto baseDto = BaseDto();
          baseDto = BaseDto.fromJson(res);

          setState(() {
            deliveriesList.clear();
            deliveriesList.addAll(
                baseDto.lst!.map((e) => DeliveryDto.fromJson(e)).toList());
          });

          // Log the parsed deliveries to see time slot info
          print('=== PARSED DELIVERIES ===');
          for (var delivery in deliveriesList) {
            print(
                'Delivery ID: ${delivery.deliveryId}, TimeSlot: ${delivery.timeSlotName}, Date: ${delivery.deliveryDate}');
          }
        }
      });
      setState(() {
        _isLoading = false;
      });
    } catch (ex) {
      // Assuming rinErrorDialog is defined elsewhere and works correctly
      rinErrorDialog(context, ex.toString());
    }
  }

  changeStatus(int deliveryid, String status, Map data) async {
    try {
      await getchangeStatus(deliveryid, status, data).then((res) {
        if (!mounted) {
          return;
        }

        if (res != null) {
          ResultDto resultDto = ResultDto.fromJson(res);

          // Assuming rinErrorDialog is defined elsewhere and works correctly
          rinErrorDialog(context, resultDto.resultMessage);
        }
      });
    } catch (ex) {
      // Assuming rinErrorDialog is defined elsewhere and works correctly
      rinErrorDialog(context, ex.toString());
    }
  }

  Future<void> _takePicture(int deliveryId) async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (photo != null) {
        setState(() {
          if (!_deliveryImages.containsKey(deliveryId)) {
            _deliveryImages[deliveryId] = [];
          }
          _deliveryImages[deliveryId]!.add(File(photo.path));
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Photo captured successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error taking picture: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _removeImage(int deliveryId, int imageIndex) {
    setState(() {
      if (_deliveryImages.containsKey(deliveryId)) {
        _deliveryImages[deliveryId]!.removeAt(imageIndex);
        if (_deliveryImages[deliveryId]!.isEmpty) {
          _deliveryImages.remove(deliveryId);
        }
      }
    });
  }

  void _showFullImage(File imageFile) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  Container(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.7,
                      maxWidth: MediaQuery.of(context).size.width * 0.9,
                    ),
                    child: Image.file(
                      imageFile,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<String> _imageToBase64(File imageFile) async {
    List<int> imageBytes = await imageFile.readAsBytes();
    return base64Encode(imageBytes);
  }

  Future<Map<String, String>> _prepareImageData(int deliveryId) async {
    Map<String, String> data = {
      "base64Str1": "",
      "base64Str2": "",
      "base64Str3": ""
    };

    List<File>? images = _deliveryImages[deliveryId];
    if (images != null) {
      for (int i = 0; i < images.length && i < 3; i++) {
        String base64String = await _imageToBase64(images[i]);
        data["base64Str${i + 1}"] = base64String;
      }
    }

    return data;
  }

  Widget _buildCameraButton(int deliveryId) {
    return GestureDetector(
      onTap: () => _takePicture(deliveryId),
      child: Container(
        width: 60.0,
        height: 60.0,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.camera_alt_outlined,
                color: Colors.green,
                size: 24.0,
              ),
              SizedBox(height: 2),
              Text(
                'Camera',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCapturedImageThumbnail(
      File imageFile, int deliveryId, int index) {
    return Stack(
      children: <Widget>[
        GestureDetector(
          onTap: () => _showFullImage(imageFile),
          child: Container(
            width: 60.0,
            height: 60.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.file(
                imageFile,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Positioned(
          top: 2.0,
          right: 2.0,
          child: GestureDetector(
            onTap: () => _removeImage(deliveryId, index),
            child: Container(
              padding: const EdgeInsets.all(1.0),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 12.0,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildDeliveredCard(DeliveryDto delivery) {
    bool isExpanded = false;

    return StatefulBuilder(builder: (context, setState) {
      return Card(
        color: Colors.grey[200],
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.04,
          vertical: 8.0,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // Optional: Rounded corners
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
                  Text('#${delivery.docNo}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Latefont',
                      )),
                  Row(
                    children: [
                      const Icon(Icons.date_range,
                          size: 23, color: Colors.black),
                      const SizedBox(width: 10),
                      Text(
                        DateFormat("dd MMMyyyy").format(delivery.docDate),
                        style: const TextStyle(
                            fontSize: 17,
                            color: Colors.black,
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
                    style:
                        const TextStyle(fontSize: 17, fontFamily: 'Latefont'),
                  )
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
                      makePhoneCall(delivery.mobileNo);
                    },
                    child: Text(
                      delivery.mobileNo,
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
                  const Icon(Icons.date_range, size: 23, color: Colors.black),
                  const SizedBox(width: 10),
                  Text(
                    DateFormat("dd MMMyyyy").format(delivery.deliveryDate),
                    style: const TextStyle(
                        fontSize: 17,
                        color: Colors.black,
                        fontFamily: 'Latefont'),
                  ),
                  const SizedBox(width: 20),
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
                        fontSize: 17,
                        color: Colors.black,
                        fontFamily: 'Latefont'),
                  ),
                  const SizedBox(width: 15),
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
                            size: 23, color: Colors.black),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Text(
                                  delivery.deliveryZoneName,
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
                    if (isExpanded && delivery.address.length < 50)
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
              const SizedBox(height: 34),
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
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Latefont',
                        color: Color(0xFF35BC77)),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget buildDeliverCard(DeliveryDto delivery) {
    bool isExpanded = false;

    return StatefulBuilder(builder: (context, setState) {
      return Card(
        color: Colors.grey[200],
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.04,
          vertical: 8.0,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // Optional: Rounded corners
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
                  Text('#${delivery.docNo}',
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'LateFont')),
                  Row(
                    children: [
                      const Icon(Icons.date_range,
                          size: 23, color: Colors.black),
                      const SizedBox(width: 10),
                      Text(
                        DateFormat("dd MMMyyyy").format(delivery.docDate),
                        style: const TextStyle(
                            fontSize: 17,
                            color: Colors.black,
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
                    style:
                        const TextStyle(fontSize: 17, fontFamily: 'Latefont'),
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
                      makePhoneCall(delivery.mobileNo);
                    },
                    child: Text(
                      delivery.mobileNo,
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
                  const Icon(Icons.date_range, size: 23, color: Colors.black),
                  const SizedBox(width: 10),
                  Text(
                    DateFormat("dd MMMyyyy").format(delivery.deliveryDate),
                    style: const TextStyle(
                        fontSize: 17,
                        color: Colors.black,
                        fontFamily: 'Latefont'),
                  ),
                  const SizedBox(width: 20),
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
                        fontSize: 17,
                        color: Colors.black,
                        fontFamily: 'Latefont'),
                  ),
                  const SizedBox(width: 15),
                ],
              ),
              //const SizedBox(height: 7),
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
                            size: 23, color: Colors.black),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Text(
                                  delivery.deliveryZoneName,
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
                    // if (isExpanded && delivery.address.length < 50)
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0, top: 5),
                      child: Text(
                        delivery.address,
                        //'dinesh',
                        style: const TextStyle(
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
              const SizedBox(height: 10),
              // Camera section for Deliver action

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReschedulePage(
                            deliveryDto: delivery,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE56437),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      'Reschedule',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'LateFont',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 70),
                  ElevatedButton(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DeliveryDetails(delivery: delivery),
                        ),
                      );
                      await fetchData();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF35BC77),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      'Deliver',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'LateFont',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget buildStartCard(DeliveryDto delivery) {
    bool isExpanded = false;

    return StatefulBuilder(builder: (context, setState) {
      return Card(
        color: Colors.grey[200],
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.04,
          vertical: 8.0,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // Optional: Rounded corners
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
                  Text('#${delivery.docNo}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Latefont',
                      )),
                  Row(
                    children: [
                      const Icon(Icons.date_range,
                          size: 23, color: Colors.black),
                      const SizedBox(width: 10),
                      Text(
                        DateFormat("dd MMMyyyy").format(delivery.docDate),
                        style: const TextStyle(
                            fontSize: 17,
                            color: Colors.black,
                            fontFamily: 'Latefont'),
                      ),
                    ],
                  )
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
                    style:
                        const TextStyle(fontSize: 17, fontFamily: 'Latefont'),
                  ),
                  // Spacing between text and icon
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
                      makePhoneCall(delivery.mobileNo);
                    },
                    child: Text(
                      delivery.mobileNo,
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
                    '${delivery.amount}',
                    style: const TextStyle(
                      fontSize: 17,
                      fontFamily: 'Latefont',
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // Spacing between text and icon
                ],
              ),
              const SizedBox(height: 7),
              Row(
                children: [
                  const Icon(Icons.date_range, size: 23, color: Colors.black),
                  const SizedBox(width: 10),
                  Text(
                    DateFormat("dd MMMyyyy").format(delivery.deliveryDate),
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontFamily: 'Latefont'),
                  ),
                  const SizedBox(width: 20),
                  const SizedBox(height: 7),
                  Row(
                    children: [
                      // Spacing between text and icon
                    ],
                  ),
                  const SizedBox(height: 3),
                  const SizedBox(width: 15),
                ],
              ),
              const SizedBox(height: 7),
              Row(
                children: [
                  const Icon(Icons.timelapse, size: 23),
                  const SizedBox(width: 10),
                  Text(
                    delivery.timeSlotName.isEmpty
                        ? 'No time slot'
                        : delivery.timeSlotName,
                    style: const TextStyle(
                        fontSize: 17,
                        color: Colors.black,
                        fontFamily: 'Latefont'),
                  ),

                  // Spacing between text and icon
                ],
              ),
              const SizedBox(height: 7),
              // Row(children: [
              //   const Icon(
              //     Icons.location_on,
              //     size: 23,
              //     color: Colors.grey,
              //   ),
              //   Text(
              //     delivery.location,
              //     style: const TextStyle(fontSize: 17, fontFamily: 'Latefont'),
              //   ),
              // ]),
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
                            size: 23, color: Colors.black),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Text(
                                  delivery.deliveryZoneName,
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
                    if (isExpanded && delivery.address.length < 50)
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

              const SizedBox(height: 34),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReschedulePage(
                            deliveryDto: delivery,
                          ),
                        ),
                      );

                      // Update the delivery data if reschedule was successful
                      if (result != null && result is Map<String, dynamic>) {
                        print('=== RESCHEDULE RESULT RECEIVED ===');
                        print('Result: $result');
                        print(
                            'Before update - Date: ${delivery.deliveryDate}, TimeSlot: ${delivery.timeSlotName}');

                        setState(() {
                          // Update the delivery date and time slot
                          // Parse the date string back to DateTime
                          String dateStr = result['newDate'];
                          String timeSlot = result[
                              'newTimeSlot']; // Use the time slot from result

                          print('Parsing date: $dateStr, timeSlot: $timeSlot');

                          // Convert date string like "20May2025" back to DateTime
                          try {
                            int day = int.parse(dateStr.substring(0, 2));
                            String monthStr = dateStr.substring(2, 5);
                            int year = int.parse(dateStr.substring(5));

                            // Convert month string to month number
                            Map<String, int> months = {
                              'Jan': 1,
                              'Feb': 2,
                              'Mar': 3,
                              'Apr': 4,
                              'May': 5,
                              'Jun': 6,
                              'Jul': 7,
                              'Aug': 8,
                              'Sep': 9,
                              'Oct': 10,
                              'Nov': 11,
                              'Dec': 12
                            };

                            int month = months[monthStr] ?? 1;
                            delivery.deliveryDate = DateTime(year, month, day);
                            delivery.timeSlotName = timeSlot;

                            print(
                                'After update - Date: ${delivery.deliveryDate}, TimeSlot: ${delivery.timeSlotName}');
                          } catch (e) {
                            print('Error parsing rescheduled date: $e');
                          }
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE56437),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      'Reschedule',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'LateFont',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 100),
                  ElevatedButton(
                    onPressed: () async {
                      if (await showCustomConfirmDialog(
                              context, "Are you sure you want to proceed?") ??
                          false) {
                        // User pressed Yes
                        setState(() {
                          delivery.isProcessing = true;
                        });

                        Map<String, String> data = {
                          "base64Str1": "",
                          "base64Str2": "",
                          "base64Str3": ""
                        };

                        await changeStatus(
                            delivery.deliveryId, 'InTransit', data);

                        setState(() {
                          delivery.isProcessing = false;
                        });

                        await fetchData();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFF35BC77), // Set the background color
                      foregroundColor: Colors.white, // Set the text color
                    ),
                    child: delivery.isProcessing
                        ? const CupertinoActivityIndicator(
                            radius: 10,
                            color: Colors.white,
                          )
                        : const Text(
                            'Start',
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'LateFont',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget buildpickupCard(DeliveryDto delivery) {
    bool isExpanded = false;

    return StatefulBuilder(
      builder: (context, setState) {
        return Card(
          color: Colors.grey[200], // Greyish background color
          margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.04,
            vertical: 8.0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15), // Rounded corners
          ),
          elevation: 5, // Shadow for a better look
          child: Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
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
                        const Icon(
                          Icons.date_range,
                          size: 23, /*color: Colors.grey*/
                        ),
                        const SizedBox(width: 10),
                        Text(
                          DateFormat("dd MMMyyyy").format(delivery.docDate),
                          style: const TextStyle(
                              fontSize: 17,
                              //color: Colors.grey,
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
                      style:
                          const TextStyle(fontSize: 17, fontFamily: 'Latefont'),
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
                        makePhoneCall(delivery.mobileNo);
                      },
                      child: Text(
                        delivery.mobileNo,
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
                    const Icon(
                      Icons.date_range,
                      size: 23, /*color: Colors.grey*/
                    ),
                    const SizedBox(width: 10),
                    Text(
                      DateFormat("dd MMMyyyy").format(delivery.deliveryDate),
                      style: const TextStyle(
                          fontSize: 17,
                          //color: Colors.grey,
                          fontFamily: 'Latefont'),
                    ),
                    const SizedBox(width: 20),
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
                          fontSize: 17,
                          //color: Colors.grey,
                          fontFamily: 'Latefont'),
                    ),
                  ],
                ),

                const SizedBox(height: 7),
                // Location with expandable text and icon right beside it
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
                          const Icon(
                            Icons.location_on,
                            size: 23,
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: Text(
                                    delivery.deliveryZoneName,
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
                      if (isExpanded && delivery.address.length < 50)
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

                const SizedBox(height: 10),
                // Camera section for Pickup action

                const SizedBox(height: 16.0),
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (await showCustomConfirmDialog(
                              context, "Are you sure") ??
                          false) {
                        setState(
                          () {
                            _processingDeliveries[delivery.deliveryId] = true;
                          },
                        );

                        try {
                          // Prepare image data
                          Map<String, String> data =
                              await _prepareImageData(delivery.deliveryId);

                          await changeStatus(
                              delivery.deliveryId, 'Picked', data);

                          // Clear images after successful submission
                          _deliveryImages.remove(delivery.deliveryId);
                        } finally {
                          setState(
                            () {
                              _processingDeliveries[delivery.deliveryId] =
                                  false;
                            },
                          );
                        }

                        await fetchData();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF35BC77),
                      foregroundColor: Colors.white,
                    ),
                    child: _processingDeliveries[delivery.deliveryId] == true
                        ? const CupertinoActivityIndicator(
                            radius: 10,
                            color: Colors.white,
                          )
                        : const Text(
                            'Pickup',
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'LateFont',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildOptionChip(
      {required String title, required stage, required Function onClick}) {
    return ElevatedButton(
      onPressed: () {
        onClick();
      },
      child: Text(
        title,
        style: const TextStyle(
            fontFamily: 'LateFont', fontWeight: FontWeight.bold, fontSize: 15),
      ),
      style: ElevatedButton.styleFrom(
        // padding: const EdgeInsets.all(10),

        backgroundColor: stage == selectedStage
            ? const Color.fromARGB(255, 234, 106, 60)
            : const Color.fromARGB(255, 236, 150, 118), // Button color
        foregroundColor: stage == selectedStage
            ? Colors.white
            : Colors.black, // Text color based on selection
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Column(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        SizedBox(
          height: 35,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              10.width,
              buildOptionChip(
                  stage: 'All',
                  title: 'All',
                  onClick: () {
                    setState(() {
                      selectedStage = 'All';
                    });
                    fetchData();
                  }),
              10.width,
              buildOptionChip(
                  stage: 'Assigned',
                  title: 'Assigned',
                  onClick: () {
                    setState(() {
                      selectedStage = 'Assigned';
                    });
                    fetchData();
                  }),
              10.width,
              buildOptionChip(
                stage: 'Picked',
                title: 'Picked Up',
                onClick: () {
                  setState(() {
                    selectedStage = 'Picked';
                  });
                  fetchData();
                },
              ),
              10.width,
              buildOptionChip(
                  stage: 'InTransit',
                  title: 'In Transit',
                  onClick: () {
                    setState(() {
                      selectedStage = 'InTransit';
                    });
                    fetchData();
                  }),
              10.width,
              buildOptionChip(
                  stage: 'Delivered',
                  title: 'Delivered',
                  onClick: () {
                    setState(() {
                      selectedStage = 'Delivered';
                    });
                    fetchData();
                  }),
              10.width
            ],
          ),
        ),
        10.height,
        Expanded(
          child: _isLoading
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height - 100,
                  child: const CupertinoActivityIndicator(
                    color: Colors.green,
                    radius: 15,
                  ),
                )
              : deliveriesList.isEmpty // Check if the list is empty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.inbox_outlined,
                            size: 80,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No orders found for "$selectedStage" stage.',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                              fontFamily: 'LateFont',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Please check back later or select a different stage.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey,
                              fontFamily: 'LateFont',
                            ),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () async {
                        await fetchData();
                      },
                      child: SingleChildScrollView(
                          child: Column(
                        children: [
                          for (DeliveryDto dlvry in deliveriesList)
                            dlvry.status == 'Assigned'
                                ? buildpickupCard(dlvry)
                                : dlvry.status == 'Picked'
                                    ? buildStartCard(dlvry)
                                    : dlvry.status == 'InTransit'
                                        ? buildDeliverCard(dlvry)
                                        : dlvry.status == 'Delivered'
                                            ? buildDeliveredCard(dlvry)
                                            : const Text(
                                                '') // Fallback for unknown status
                        ],
                      ))),
        ),
      ],
    ));
  }
}
