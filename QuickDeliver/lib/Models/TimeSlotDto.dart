class TimeSlotDto {
  int timeSlotId = 0;
  String timeSlotName = '';
  String timeSlotDisplay = '';
  bool isActive = true;

  TimeSlotDto();

  TimeSlotDto.fromJson(Map<String, dynamic> json) {
    timeSlotId = json['id'] ?? 0;
    timeSlotName = json['value'] ?? '';
    timeSlotDisplay = json['value'] ?? '';
    isActive = !(json['status'] ?? false); // status: false means active
  }
}
