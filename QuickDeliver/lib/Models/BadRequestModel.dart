class BadRequestModel {
  int? statusCode;
  String? message;
  String internalError = '';
  String? eventKey;

  BadRequestModel({this.eventKey, this.message, this.statusCode});

  BadRequestModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['internalError'] != null) {
      internalError = json['internalError'];
    }
    if (json['eventKey'] != null) {
      eventKey = json['eventKey'];
    }
  }
}
