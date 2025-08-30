class BaseDto {
  double? executionTime;
  List<dynamic>? lst;
  dynamic obj;

  BaseDto();

  BaseDto.fromJson(Map<String, dynamic> json) {
    executionTime = json['executionTime'];
    lst = json['lst'];
    obj = json['obj'];
  }
}

class DbElementDto {
  String status = '';
  int count = 0;

  DbElementDto();

  DbElementDto.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    count = json['Count'];
  }
}
