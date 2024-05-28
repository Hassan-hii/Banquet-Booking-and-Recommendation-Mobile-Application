
import 'package:get/get_utils/src/get_utils/get_utils.dart';

class Validator{

  static final RegExp _mobileNumberRegex = RegExp(r'^03[0-9]{9}$');

  static String? checkEmailIsValid(String? email){
    if(email!.isEmpty || !GetUtils.isEmail(email)){
      return "Email is invalid";
    }
    return null;
  }

  static String? checkPasswordLength(String? pass){
    if(pass!.isEmpty || pass.length < 6){
      return "Password should contain 6 letters";
    }
    return null;
  }

  static String? checkStringIsNotEmpty(String? email){
    if(email!.isEmpty){
      return "Required**";
    }
    return null;
  }

  static String? checkPhoneNumberIsValid(String? number){
    if(number!.isEmpty || number.length < 11 || !_mobileNumberRegex.hasMatch(number)){
      return "Number is not correct";
    }
    return null;
  }

  static String? checkParkingCapacity(String? num){
    int parkingCapacity = int.tryParse(num!) ?? 0;
    if(parkingCapacity < 0 && parkingCapacity > 2000){
      return "Invalid capacity";
    }
    return null;
  }

  static String? checkBookingPrice(String? num){
    int bookingPrice = int.tryParse(num!) ?? 0;
    if(bookingPrice < 0 && bookingPrice > 999999){
      return "Invalid price";
    }
    return null;
  }

  static String? checkMenuPrice(String? num){
    if(num!.isEmpty){
      return "Invalid price";
    }
    int menuPrice = int.tryParse(num) ?? 0;
    if(menuPrice < 0 && menuPrice > 5000){
      return "Invalid price";
    }
    return null;
  }
}