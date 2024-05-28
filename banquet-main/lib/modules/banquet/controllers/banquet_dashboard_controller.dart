import 'dart:convert';
import 'dart:io';
import 'package:banquet/auth/service/auth_service.dart';
import 'package:banquet/enum/common_status.dart';
import 'package:banquet/enum/user_type.dart';
import 'package:banquet/modules/banquet/models/banquet_model.dart';
import 'package:banquet/modules/banquet/models/package_model.dart';
import 'package:banquet/modules/banquet/services/banquet_services.dart';
import 'package:banquet/modules/customer/models/booking_model.dart';
import 'package:banquet/modules/customer/services/booking_service.dart';
import 'package:banquet/utils/constants.dart';
import 'package:banquet/utils/frequent_utils.dart';
import 'package:banquet/wrapper/controller/wrapper_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class BanquetDashboardController extends GetxController {
  Rx<TextEditingController> brand = TextEditingController().obs;
  Rx<TextEditingController> personCapacity = TextEditingController().obs;
  Rx<TextEditingController> parkingCapacity = TextEditingController().obs;
  Rx<TextEditingController> bPrice = TextEditingController().obs;
  Rx<TextEditingController> facilities = TextEditingController().obs;
  Rx<TextEditingController> location = TextEditingController().obs;
  Rx<TextEditingController> description = TextEditingController().obs;
  Rx<TextEditingController> pkgName = TextEditingController().obs;
  Rx<TextEditingController> pkgPrice = TextEditingController().obs;
  Rx<TextEditingController> mainCourse = TextEditingController().obs;
  Rx<TextEditingController> desserts = TextEditingController().obs;
  Rx<TextEditingController> drinks = TextEditingController().obs;

  File? _imageFile;
  String? _venueType = 'Banquet';

  final formKey = GlobalKey<FormState>();
  final menuKey = GlobalKey<FormState>();

  RxBool isLoading = false.obs;
  RxBool isMessageLoading = false.obs;
  RxBool isBanquetFetching = false.obs;
  final BanquetServices _services = BanquetServices();
  final AuthService _authServices = AuthService();
  final BookingService _bookingService = BookingService();
  late BanquetModel banquetModel;
  Rx<RxMap<String, dynamic>> map = RxMap<String, dynamic>().obs;
  RxList<BookingModel> bookings = <BookingModel>[].obs;
  RxList<BanquetModel> children = <BanquetModel>[].obs;
  RxList<MenuModel> menus = <MenuModel>[].obs;
  final _controller = Get.find<WrapperController>();
  late BanquetModel _selectedBanquet;

  var pages = <Widget>[].obs;

  @override
  void onInit() async {
    super.onInit();
    if (_controller.model.value.userType == UserType.banquetOwner.getName) {
      fetchBanquetDetailsFromFirebase();
      // getAllBookings();
      _listenMenusList();
      _listenBookingsList();
      _listenUpdatedBookingList();
      debugPrint('BanquetDashboardController onInit');
    } else {
      _listenBanquetList();
      _listenUpdatedBanquetList();
      debugPrint('BanquetDashboardController onInit, no user type');
    }
  }

  set setSelectedBanquet(BanquetModel model) => _selectedBanquet = model;
  get getSelectedBanquet => _selectedBanquet;

  set setPickedImage(File file) => _imageFile = file;

  set setVenueType(String value) => _venueType = value;

  void fetchBanquetDetailsFromFirebase() async {
    isBanquetFetching.value = true;
    map.value.value = await _services.getBanquet() ?? {};
    if (map.value.value.isNotEmpty) {
      banquetModel = BanquetModel.fromJson(map.value.value);
    }
    isBanquetFetching.value = false;
  }

  void addBanquet() async {
    try {
      isLoading.value = true;
      bool banquetAdded = await _services.addBanquetToDatabase(BanquetModel(
          brandName: brand.value.text,
          venueType: _venueType.toString(),
          personCapacity: personCapacity.value.text,
          parkingCapacity: parkingCapacity.value.text,
          bookingPrice: bPrice.value.text,
          facilities: facilities.value.text,
          location: location.value.text,
          description: description.value.text,
          status: CommonStatus.pending.getName,
          image: FrequentUtils.convertIntoBase64(_imageFile!)));
      if (banquetAdded) {
        isLoading.value = false;
        clearTextFields();
        FrequentUtils.getSuccessSnackBar(
            "Success", 'Banquet added successfully');
        fetchBanquetDetailsFromFirebase();
      } else {
        isLoading.value = false;
        FrequentUtils.getFailureSnackBar("Error: ", 'Banquet not added');
      }
    } catch (e) {
      isLoading.value = false;
      FrequentUtils.getFailureSnackBar("Error: ", e.toString());
    }
  }

  void getAllBookings() async {
    try {
      isLoading.value = true;
      final map = await _bookingService.getBanquetBookings();
      if (map.isNotEmpty) {
        map.forEach((key, value) {
          Map<String, dynamic> map = value;
          map.addIf(true, 'id', key);
          bookings.add(BookingModel.fromJson(map));
        });
      }
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      FrequentUtils.getFailureSnackBar('Error', somethingWentWrong);
      debugPrint('Catch Error -> ${e.toString()}');
    }
  }

  void addMenuToBanquet() async {
    try {
      isLoading.value = true;
      bool menuAdded = await _services.addMenuToBanquet(MenuModel(
        pkgName: pkgName.value.text,
        menuPrice: pkgPrice.value.text,
        mainCourse: mainCourse.value.text,
        desserts: desserts.value.text,
        drinks: drinks.value.text,
      ));
      if (menuAdded) {
        isLoading.value = false;
        clearMenuTextFields();
        FrequentUtils.getSuccessSnackBar("Success", 'Menu added successfully');
        fetchBanquetDetailsFromFirebase();
      } else {
        isLoading.value = false;
        FrequentUtils.getFailureSnackBar("Error: ", 'Menu not added');
      }
    } catch (e) {
      isLoading.value = false;
      FrequentUtils.getFailureSnackBar("Error: ", somethingWentWrong);
      debugPrint('Catch Error -> ${e.toString()}');
    }
  }

  void updateBanquetStatus(String id, String status) async {
    try {
      isLoading.value = true;
      bool banquetUpdated = await _services.updateBanquetStatus(id, status);
      if (banquetUpdated) {
        isLoading.value = false;
        FrequentUtils.getSuccessSnackBar(
            "Success", 'Banquet updated successfully');
      } else {
        isLoading.value = false;
        FrequentUtils.getFailureSnackBar("Error: ", 'Banquet not updated');
      }
    } catch (e) {
      isLoading.value = false;
      FrequentUtils.getFailureSnackBar("Error: ", somethingWentWrong);
      debugPrint('Catch error -> ${e.toString()}');
    }
  }

  void updateBookingStatus(String id, String status) async {
    try {
      isLoading.value = true;
      bool banquetUpdated =
          await _bookingService.updateBookingStatus(id, status);
      if (banquetUpdated) {
        isLoading.value = false;
        FrequentUtils.getSuccessSnackBar(
            "Success", 'Booking updated successfully');
      } else {
        isLoading.value = false;
        FrequentUtils.getFailureSnackBar("Error: ", 'Booking not updated');
      }
    } catch (e) {
      isLoading.value = false;
      FrequentUtils.getFailureSnackBar("Error: ", somethingWentWrong);
      debugPrint('Catch error -> ${e.toString()}');
    }
  }

  void getUserForWhatsApp(String id) async {
    try {
      isMessageLoading.value = true;
      final userFetched = await _authServices.getUser(id);
      if (userFetched != null) {
        isMessageLoading.value = false;
        launchWhatsApp(userFetched['phoneNumber'],
            "Hi there, Did you apply for the banquet registration?");
        // FrequentUtils.getSuccessSnackBar("Success", userFetched['phoneNumber']);
      } else {
        isMessageLoading.value = false;
        // FrequentUtils.getFailureSnackBar("Error: ", 'Banquet not updated');
      }
    } catch (e) {
      isMessageLoading.value = false;
      FrequentUtils.getFailureSnackBar("Error: ", somethingWentWrong);
      debugPrint('Catch error -> ${e.toString()}');
    }
  }

  void launchWhatsApp(String phoneNumber, String msg) async {
    // var msg = msg;
    var contact = '92${phoneNumber.substring(1)}';
    var androidUrl = "whatsapp://send?phone=$contact&text=$msg";
    var iosUrl = "https://wa.me/$contact?text=${Uri.parse(msg)}";

    try {
      if (Platform.isIOS) {
        await launchUrl(Uri.parse(iosUrl));
      } else {
        await launchUrl(Uri.parse(androidUrl));
      }
    } on Exception {
      FrequentUtils.getFailureSnackBar('Error', 'WhatsApp is not installed.');
    }
  }

  void clearTextFields() {
    brand.value.clear();
    parkingCapacity.value.clear();
    bPrice.value.clear();
    facilities.value.clear();
    location.value.clear();
    description.value.clear();
    formKey.currentState!.reset();
    update();
  }

  void clearMenuTextFields() {
    pkgName.value.clear();
    pkgPrice.value.clear();
    mainCourse.value.clear();
    desserts.value.clear();
    drinks.value.clear();
    update();
  }

  void _listenBanquetList() {
    _services.getBanquets().listen((event) {
      Map<String, dynamic> value = jsonDecode(jsonEncode(event.snapshot.value));
      value.addIf(true, 'id', event.snapshot.key);
      BanquetModel model = BanquetModel.fromJson(value);
      children.add(model);
    });
  }

  void _listenMenusList() {
    _services.getMenus().listen((event) {
      Map<String, dynamic> value = jsonDecode(jsonEncode(event.snapshot.value));
      value.addIf(true, 'id', event.snapshot.key);
      MenuModel model = MenuModel.fromJson(value);
      menus.add(model);
    });
  }

  void _listenUpdatedBanquetList() {
    _services.getUpdateBanquets().listen((event) {
      Map<String, dynamic> value = jsonDecode(jsonEncode(event.snapshot.value));
      value.addIf(true, 'id', event.snapshot.key);
      BanquetModel model = BanquetModel.fromJson(value);
      children.remove(children.firstWhere((p0) => p0.id == model.id));
      children.add(model);
    });
  }

  void _listenBookingsList() {
    _bookingService.getBookingStream().listen((event) {
      Map<String, dynamic> value = jsonDecode(jsonEncode(event.snapshot.value));
      value.addIf(true, 'id', event.snapshot.key);
      BookingModel model = BookingModel.fromJson(value);
      DateTime bookingDate =
          FrequentUtils.parseStringToDateTime(model.bookingDate);
      if ((bookingDate.isAfter(DateTime.now()) ||
              bookingDate.isAtSameMomentAs(DateTime.now())) &&
          (model.status == CommonStatus.pending.getName)) {
        bookings.add(model);
      }
    });
  }

  void _listenUpdatedBookingList() {
    _bookingService.getUpdateBookings().listen((event) {
      Map<String, dynamic> value = jsonDecode(jsonEncode(event.snapshot.value));
      value.addIf(true, 'id', event.snapshot.key);
      BookingModel model = BookingModel.fromJson(value);
      bookings.remove(bookings.firstWhere((p0) => p0.id == model.id));
      bookings.add(model);
    });
  }
}
