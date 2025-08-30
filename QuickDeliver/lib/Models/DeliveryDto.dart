class DeliveryDto {
  int deliveryId = 0;
  String docNo = '';
  DateTime docDate = DateTime.now();
  int saleMId = 0;
  int branchId = 0;
  DateTime deliveryDate = DateTime.now();
  int timeslotId = 0;
  String timeSlotName = '';
  int deliveryZoneId = 0;
  String deliveryZoneName = '';
  String customerName = '';
  String mobileNo = '';
  double amount = 0;
  String address = '';
  String status = '';
  bool isProcessing = false;

  DeliveryDto();

  DeliveryDto.fromJson(Map<String, dynamic> json) {
    print('=== PARSING DELIVERY JSON ===');
    print('JSON keys: ${json.keys.toList()}');
    print('TimeSlotName from JSON: ${json['TimeSlotName']}');
    print('TimeSlotId from JSON: ${json['TimeSlotId']}');

    deliveryId = json['DeliveryId'];
    docNo = json['DocNo'];
    docDate = DateTime.parse(json['DocDate'].toString());
    saleMId = json['SaleMId'];
    branchId = json['BranchId'];
    deliveryDate = DateTime.parse(json['DeliveryDate'].toString());
    timeslotId = json['TimeSlotId'];
    timeSlotName = json['TimeSlotName'] ?? '';
    deliveryZoneId = json['DeliveryZoneId'];
    deliveryZoneName = json['ZoneName'];
    customerName = json['CustomerName'];
    mobileNo = json['MobileNo'];
    amount = json['Amount'];
    status = json['Status'];

    print('Parsed timeSlotName: $timeSlotName');
  }
}
