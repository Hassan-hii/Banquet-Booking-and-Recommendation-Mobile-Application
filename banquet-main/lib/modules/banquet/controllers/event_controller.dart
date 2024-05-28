import 'dart:convert';
import 'dart:io';
import 'package:banquet/modules/banquet/controllers/banquet_dashboard_controller.dart';
import 'package:banquet/modules/banquet/models/event_model.dart';
import 'package:banquet/modules/banquet/services/event_service.dart';
import 'package:banquet/utils/frequent_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EventController extends GetxController{

  Rx<TextEditingController> eventName = TextEditingController().obs;
  Rx<TextEditingController> eventDetails = TextEditingController().obs;
  final formKey = GlobalKey<FormState>();

  RxBool isLoading = false.obs;
  RxList<EventModel> children = <EventModel>[].obs;
  late Rx<File> image = File('').obs;

  final EventService _service = EventService();
  final _banquetController = Get.find<BanquetDashboardController>();

  set setPickedImage(value) => image = value;

  @override
  void onInit() {
    super.onInit();
    _listenEventList();
  }

  void addEvent() async{
    try{
      isLoading.value = true;
      bool isAdded = await _service.addEventToDatabase(
        EventModel(eventName: eventName.value.text, eventDetails: eventDetails.value.text,
            eventImage: FrequentUtils.convertIntoBase64((image.value)),
            eventDate: FrequentUtils.formatDateToddMMMyyyy(DateTime.now()),
            banquetId: _banquetController.banquetModel.id!, banquetName:  _banquetController.banquetModel.brandName)
      );
      if(isAdded){
        isLoading.value = false;
        FrequentUtils.getSuccessSnackBar("Success", 'Event added successfully');
        clearTextFields();
      } else{
        isLoading.value = false;
        FrequentUtils.getFailureSnackBar("Error: ", 'Event not added');
      }
    } catch (e){
      isLoading.value = false;
      FrequentUtils.getFailureSnackBar("Error: ", e.toString());
    }
  }

  void _listenEventList(){
    _service.getEventStream().listen((event) {
      final Map<String, dynamic> value = jsonDecode(jsonEncode(event.snapshot.value));
      EventModel model = EventModel.fromJson(value);
      children.addIf(model.banquetId == _banquetController.banquetModel.id, model);
    });
  }

  void clearTextFields() {
    eventName.value.clear();
    eventDetails.value.clear();
    formKey.currentState?.reset();
    image.value = File('');
  }

  Future<void> pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      image.value = File(pickedImage.path);
    } else {
      print('No image selected.');
    }
  }

}