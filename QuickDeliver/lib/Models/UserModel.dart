class UserDto {
  String token = '';
  String storeName = '';
  int deliveryAgentId = 0;
  String userName = '';
  String imageUrl = '';
  int branchId = 0;
  UserDto();

  UserDto.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    storeName = json['storeName'];
    deliveryAgentId = json['deliveryAgentId'];
    userName = json['userName'];
    imageUrl = json['imageUrl'];
    branchId = json['branchId'];
  }
}
