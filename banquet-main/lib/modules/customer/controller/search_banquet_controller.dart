import 'package:banquet/enum/common_status.dart';
import 'package:banquet/enum/day.dart';
import 'package:banquet/modules/banquet/models/banquet_model.dart';
import 'package:banquet/modules/banquet/models/package_model.dart';
import 'package:banquet/modules/banquet/services/banquet_services.dart';
import 'package:banquet/modules/customer/controller/wishlist_controller.dart';
import 'package:banquet/modules/customer/models/booking_model.dart';
import 'package:banquet/modules/customer/services/booking_service.dart';
import 'package:banquet/utils/constants.dart';
import 'package:banquet/utils/frequent_utils.dart';
import 'package:banquet/wrapper/controller/wrapper_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

class SearchAndBookBanquetController extends GetxController {
  TextEditingController guestController = TextEditingController();
  TextEditingController addNotesController = TextEditingController();
  TextEditingController partOfTheDayController = TextEditingController();
  TextEditingController filterController = TextEditingController();

  final _wishlistController = Get.put(WishListController());

  RxBool isLoading = false.obs;
  List<BanquetModel> banquets = <BanquetModel>[];
  RxList<BanquetModel> filterBanquetList = <BanquetModel>[].obs;
  BanquetModel? _selectedBanquet;
  MenuModel? _selectedMenu;
  final RxInt _groupValue = 0.obs;
  final RxInt _filterValue = 3.obs;
  Rx<CalendarFormat> calendarFormat = CalendarFormat.month.obs;
  Rx<DateTime> focusedDay = DateTime.now().obs;
  late Rx<DateTime> _selectedDay = focusedDay;
  Rx<Day> selectedPartOfTheDay = Day.morning.obs;
  final _userController = Get.find<WrapperController>();
  RxBool wishlistAdd = false.obs;

  set setSelectedDay(DateTime value) => _selectedDay = value.obs;
  DateTime get getSelectedDay => _selectedDay.value;

  set setGroupValue(int value) => _groupValue.value = value;
  int get getGroupValue => _groupValue.value;

  set setFilterValue(int value) => _filterValue.value = value;
  int get getFilterValue => _filterValue.value;

  set setSelectedBanquet(BanquetModel value) => _selectedBanquet = value;
  BanquetModel get getSelectedBanquet => _selectedBanquet!;

  set setSelectedMenu(MenuModel value) => _selectedMenu = value;
  MenuModel get getSelectedMenu => _selectedMenu!;

  @override
  void onInit() {
    getAllBanquets();
    filterController.addListener(() => _filterList());
    super.onInit();
  }

  Future<void> _filterList() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    isLoading.value = true;
    switch (_filterValue.value) {
      case 0:
        filterBanquetList.value = banquets
            .where((element) => element.brandName
                .toLowerCase()
                .contains(filterController.text.toLowerCase()))
            .toList();
      case 1:
        filterBanquetList.value = banquets
            .where((element) => element.location
                .toLowerCase()
                .contains(filterController.text.toLowerCase()))
            .toList();
      case 2:
        filterBanquetList.value = banquets
            .where((element) => element.bookingPrice
                .toLowerCase()
                .contains(filterController.text.toLowerCase()))
            .toList();
      default:
        filterBanquetList.value = banquets
            .where((element) => element.brandName
                .toLowerCase()
                .contains(filterController.text.toLowerCase()))
            .toList();
    }
    isLoading.value = false;
  }

  void getAllBanquets() async {
    try {
      isLoading.value = true;
      Map<String, dynamic> json = await BanquetServices().getAllBanquet();
      if (json.isNotEmpty) {
        json.forEach((key, value) {
          debugPrint('Key $key, Value $value');
          Map<String, dynamic> modelJson = value;
          modelJson.addIf(true, 'id', key);
          double totalRating = 0.0, averageRating;
          if(modelJson['ratings'] != null){
            Map<String, dynamic> ratings = modelJson['ratings'];
            ratings.forEach((key, value) => totalRating += value);
            averageRating = totalRating / ratings.length;
            modelJson.addIf(true, 'rating', averageRating);
          }
          BanquetModel model = BanquetModel.fromJson(modelJson);
          banquets.add(model);
        });
      }
      filterBanquetList.value = banquets;
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      FrequentUtils.getFailureSnackBar('Error', somethingWentWrong);
      debugPrint(('Error:  ${e.toString()}'));
    }
  }

  void addBooking() async {
    try {
      isLoading.value = true;
      BanquetModel selectedBanquet = _selectedBanquet!;
      if((selectedBanquet.menuModel?.length)! > 1){
        _selectedMenu ??= selectedBanquet.menuModel?.first;
      } else{
        _selectedMenu = selectedBanquet.menuModel?.first;
      }
      bool bookingAdded = await BookingService().addBookingToDatabase(
          BookingModel(
              banquetModel: selectedBanquet,
              menuModel: _selectedMenu!,
              additionalNotes: addNotesController.text,
              attendantGuests: guestController.text,
              eventShift: partOfTheDayController.text,
              eventDate: _selectedDay.toString(),
              userModel: _userController.model.value,
              status: CommonStatus.pending.getName,
              hasReviewGiven: false,
              bookingDate: DateTime.now().toString()));
      if (bookingAdded) {
        isLoading.value = false;
        clearTextFields();
        FrequentUtils.getSuccessSnackBar(
            "Success", 'Booking added successfully');
      } else {
        isLoading.value = false;
        FrequentUtils.getFailureSnackBar("Error: ", 'Booking not added');
      }
    } catch (e) {
      isLoading.value = false;
      FrequentUtils.getFailureSnackBar("Error: ", somethingWentWrong);
      debugPrint('Error -> ${e.toString()}');
    }
  }

  void addToWishList() async {
    _wishlistController.addToWishList(_selectedBanquet!);
  }

  void clearTextFields() {
    guestController.clear();
    partOfTheDayController.clear();
    addNotesController.clear();
  }

  @override
  void onClose() {
    guestController.dispose();
    partOfTheDayController.dispose();
    addNotesController.dispose();
    filterController.removeListener(() => _filterList());
    filterController.dispose();
    super.onClose();
  }
}
