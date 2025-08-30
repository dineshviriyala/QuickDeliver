import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:your_project_name/Models/BaseDto.dart';
import 'package:your_project_name/Models/DeliveryDto.dart';
import 'package:your_project_name/Models/ResultDto.dart';
import 'package:your_project_name/Models/SaleMDto.dart';
import 'package:your_project_name/Network/HttpService.dart';
import 'package:your_project_name/pages/DeliveriesPage.dart';
import 'package:your_project_name/widgets/ErrorDialog.dart';

class DeliveryDetails extends StatefulWidget {
  DeliveryDto delivery;
  DeliveryDetails({required this.delivery, super.key});

  @override
  State<DeliveryDetails> createState() => _DeliveryDetailsState();
}

class _DeliveryDetailsState extends State<DeliveryDetails> {
  SaleMDto saleMDto = SaleMDto();
  bool _isLoading = false;
  bool _isProcessingImages = false;
  final ImagePicker _picker = ImagePicker();
  List<File> _capturedImages = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchInvoice();
  }

  changeStatus(int deliveryid, String status, Map data) async {
    try {
      setState(() {
        _isLoading = true;
      });

      await getchangeStatus(deliveryid, status, data).then((res) async {
        if (!mounted) {
          return;
        }

        if (res != null) {
          ResultDto resultDto = ResultDto.fromJson(res);

          // Show success message for delivery
          if (status == 'Delivered') {
            await rinErrorDialog(context, 'Delivery completed successfully!');
          } else {
            // For other status changes, show the server message
            await rinErrorDialog(context, resultDto.resultMessage);
          }

          Navigator.pop(context, "");
        }
      });
    } catch (ex) {
      rinErrorDialog(context, ex.toString());
    }
  }

  fetchInvoice() async {
    try {
      setState(() {
        _isLoading = true;
      });

      await getInvoiceDetails(widget.delivery.saleMId).then((res) {
        if (!mounted) {
          return;
        }
        if (res != null) {
          BaseDto baseDto = BaseDto();
          baseDto = BaseDto.fromJson(res);
          setState(() {
            saleMDto = SaleMDto.fromJson(baseDto.obj);
          });
        }
      });

      setState(() {
        _isLoading = false;
      });
    } catch (ex) {
      rinErrorDialog(context, ex.toString());
    }
  }

  Future<void> _takePicture() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (photo != null) {
        setState(() {
          _capturedImages.add(File(photo.path));
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

  void _removeImage(int index) {
    setState(() {
      _capturedImages.removeAt(index);
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

  Future<Map<String, String>> _prepareImageData() async {
    Map<String, String> data = {
      "base64Str1": "",
      "base64Str2": "",
      "base64Str3": ""
    };

    for (int i = 0; i < _capturedImages.length && i < 3; i++) {
      String base64String = await _imageToBase64(_capturedImages[i]);
      data["base64Str${i + 1}"] = base64String;
    }

    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   title: const Text(''),
      //   backgroundColor: Colors.white.withOpacity(0.8),
      //   elevation: 0,
      // ),
      body: _isLoading
          ? Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 100,
              child: const CupertinoActivityIndicator(
                color: Colors.green,
                radius: 15,
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 40.0),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                widget.delivery.docNo,
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'LateFont',
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Icon(Icons.calendar_today,
                                      color: Colors.grey),
                                  SizedBox(width: 8.0),
                                  Text(
                                    DateFormat("dd MMM yyyy")
                                        .format(widget.delivery.docDate),
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'LateFont',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12.0),
                          Row(
                            children: <Widget>[
                              const Icon(Icons.person_outline,
                                  color: Colors.green),
                              const SizedBox(width: 8.0),
                              Text(
                                widget.delivery.customerName,
                                style: const TextStyle(
                                  fontFamily: 'LateFont',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          Row(
                            children: <Widget>[
                              const Icon(Icons.phone_outlined,
                                  color: Colors.orange),
                              const SizedBox(width: 8.0),
                              Text(
                                widget.delivery.mobileNo,
                                style: const TextStyle(
                                  fontFamily: 'LateFont',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          Row(
                            children: <Widget>[
                              const Icon(Icons.timer_outlined,
                                  color: Colors.grey),
                              const SizedBox(width: 8.0),
                              Text(
                                widget.delivery.timeSlotName,
                                style: const TextStyle(
                                  fontFamily: 'LateFont',
                                ),
                              ),
                              const SizedBox(width: 16.0),
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          Row(
                            children: [
                              const Icon(Icons.location_on,
                                  size: 23, color: Colors.black),
                              const SizedBox(width: 8.0),
                              Text(
                                widget.delivery.deliveryZoneName,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'LateFont',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 1.0),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: saleMDto.transList.length,
                      separatorBuilder: (context, index) =>
                          const Divider(thickness: 1.0),
                      itemBuilder: (context, index) {
                        final item = saleMDto.transList[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: <Widget>[
                              SizedBox(
                                width: 30.0,
                                child: Text(
                                  item.serialNo.toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      '${item.productName} - ${item.quantity}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'latefont',
                                        fontSize: 16.0,
                                      ),
                                    ),
                                    Text(
                                      item.fullName,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12.0,
                                        fontFamily: 'latefont',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              Text('₹ ${item.finalAmount.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'latefont')),
                              const SizedBox(width: 16.0),
                              SizedBox(
                                width: 24.0,
                                height: 24.0,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      item.isChecked = !item.isChecked;
                                    });
                                  },
                                  child: Icon(
                                    item.isChecked
                                        ? Icons.check_circle
                                        : Icons.radio_button_unchecked,
                                    color: item.isChecked
                                        ? Color(0xFF35BC77)
                                        : Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const Divider(thickness: 1.0),
                    const SizedBox(height: 16.0),
                    // Images section header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Delivery Photos',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'LateFont',
                          ),
                        ),
                        Text(
                          '${_capturedImages.length} photos',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            fontFamily: 'LateFont',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12.0),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: <Widget>[
                          _buildCameraButton(),
                          const SizedBox(width: 8.0),
                          // Display captured images
                          ..._capturedImages.asMap().entries.map((entry) {
                            int index = entry.key;
                            File imageFile = entry.value;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: _buildCapturedImageThumbnail(
                                  imageFile, index),
                            );
                          }).toList(),
                          // Show message if no images captured
                          if (_capturedImages.isEmpty)
                            Container(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                'Tap camera to take delivery photos',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Quantity : ${_calculateTotalPrice()}',
                            style: const TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF35BC77),
                            ),
                          ),
                          const Row(
                            children: <Widget>[
                              SizedBox(width: 1.0),
                              Text(
                                '# Cash on Delivery',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isProcessingImages
                            ? null
                            : () async {
                                if (await showCustomConfirmDialog(context,
                                        "Are you sure you want to proceed?") ??
                                    false) {
                                  setState(() {
                                    _isProcessingImages = true;
                                  });

                                  try {
                                    // Prepare image data
                                    Map<String, String> data =
                                        await _prepareImageData();

                                    await changeStatus(
                                        widget.delivery.deliveryId,
                                        'Delivered',
                                        data);
                                  } finally {
                                    setState(() {
                                      _isProcessingImages = false;
                                    });
                                  }
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          backgroundColor: Color(0xFF35BC77),
                          textStyle: const TextStyle(fontSize: 18.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: _isProcessingImages
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
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'latefont',
                                    ),
                                  ),
                                ],
                              )
                            : const Text(
                                'Confirm Delivery',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'latefont',
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 24.0),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildCameraButton() {
    return GestureDetector(
      onTap: _takePicture,
      child: Container(
        width: 80.0,
        height: 80.0,
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
                size: 32.0,
              ),
              SizedBox(height: 4),
              Text(
                'Camera',
                style: TextStyle(
                  fontSize: 12,
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

  Widget _buildCapturedImageThumbnail(File imageFile, int index) {
    return Stack(
      children: <Widget>[
        GestureDetector(
          onTap: () => _showFullImage(imageFile),
          child: Container(
            width: 80.0,
            height: 80.0,
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
          top: 3.0,
          right: 3.0,
          child: GestureDetector(
            onTap: () => _removeImage(index),
            child: Container(
              padding: const EdgeInsets.all(2.0),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 14.0,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageThumbnail(String imagePath) {
    return Stack(
      children: <Widget>[
        Container(
          width: 80.0,
          height: 80.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 3.0,
          right: 1.0,
          child: InkWell(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(1.0),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 16.0,
              ),
            ),
          ),
        ),
      ],
    );
  }

  double _calculateTotalPrice() {
    double total = 0;
    for (final item in saleMDto.transList) {
      if (item.isChecked) {
        total += item.quantity;
      }
    }
    return total;
  }
}
