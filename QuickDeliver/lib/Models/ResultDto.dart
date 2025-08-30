class ResultDto {
  int resultId = 0;
  int result = 0;
  String resultMessage = '';

  ResultDto();
  ResultDto.fromJson(Map<String, dynamic> json) {
    resultId = json['resultId'];
    result = json['result'];
    resultMessage = json['resultMessage'];
  }
}
