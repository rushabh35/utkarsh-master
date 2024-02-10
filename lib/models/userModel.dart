import 'dart:math';

// UserModel userFromMap(Map<String, dynamic> data) => UserModel.fromMap(data);

Map userToJson(UserModel data) => data.toJson();

class UserModel {
  UserModel({
     this.id,
    required this.name,
    required this.email,
    required this.number,
    this.pickupInfo = const []
  });

  String? id;
  String name;
  String email;
  String number;
  List pickupInfo;

  factory UserModel.fromMap(Map<String, dynamic> map) {
    // print("in user factory");
    // print("factory map: ${map['name']}");
    // print("factory map rtt: ${map.runtimeType}");
    return UserModel(
        id: map['id'],
        name: map['name'] ?? "",
        email: map['email'] ?? "",
        number: map['number'] ?? "",
        // onPeriod: map['onPeriod'] ?? false,
        // autoLength: map['autoLength'] ?? true,
        // cycleLength: int.parse(map['cycleLength'].toString()),
        // periodLength: int.parse(map['periodLength'].toString()),
        pickupInfo: map['pickupInfo'] ?? []
      );}

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'name': name,
        'email': email,
        'number': number,
        'pickupInfo': pickupInfo,

      };
}
