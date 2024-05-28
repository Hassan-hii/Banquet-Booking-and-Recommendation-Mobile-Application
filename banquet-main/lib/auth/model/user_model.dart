import 'package:get/get.dart';

class UserModel{

  static const String jId = 'id', jEmail = 'email', jName = 'name',
      jPhoneNumber = 'phoneNumber', jUserType = 'userType';

  final String email, name, phoneNumber, userType;

  final String? id, displayName, password;

  UserModel({ this.id, required this.email,
    required this.name, required this.phoneNumber, required this.userType,
    this.displayName, this.password});

  factory UserModel.empty(){
    return UserModel(email: '', name: '', phoneNumber: '', userType: '');
  }

  factory UserModel.fromJson(Map<String, dynamic> json){
    return UserModel(
     id: json[jId],
      email: json[jEmail],
      name: json[jName],
      phoneNumber: json[jPhoneNumber],
      userType: json[jUserType]
    );
  }

  Map<String, dynamic> toJson(){
    Map<String, dynamic> json = {
      jEmail: email,
      jName: name,
      jPhoneNumber: phoneNumber,
      jUserType: userType
    };
    json.addIf(id != null, jId, id);
    return json;
  }
}