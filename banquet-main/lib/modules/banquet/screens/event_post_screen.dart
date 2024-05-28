import 'dart:convert';
import 'dart:typed_data';
import 'package:banquet/enum/user_type.dart';
import 'package:banquet/modules/banquet/controllers/event_controller.dart';
import 'package:banquet/modules/banquet/models/event_model.dart';
import 'package:banquet/utils/constants.dart';
import 'package:banquet/utils/frequent_utils.dart';
import 'package:banquet/utils/validator.dart';
import 'package:banquet/widgets/custom_drawer_widget.dart';
import 'package:banquet/widgets/custom_text_form_field_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class EventPostScreen extends StatelessWidget {
  EventPostScreen({super.key});

  final EventController _controller = Get.put(EventController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Event Posts'),
        centerTitle: true,
      ),
      drawer: const CustomDrawerWidget(userType: UserType.banquetOwner),
      body: SingleChildScrollView(
        child: Obx(() {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              children: [
                Form(
                  key: _controller.formKey,
                  child: Column(
                    children: [
                      CustomTextFormFieldWidget(
                        controller: _controller.eventName.value,
                        labelText: "Event Name",
                        textCapitalization: TextCapitalization.words,
                        validator: Validator.checkStringIsNotEmpty,
                        textInputAction: TextInputAction.next,
                      ),
                      SizedBox(height: 20),
                      CustomTextFormFieldWidget(
                        controller: _controller.eventDetails.value,
                        labelText: "Event Details",
                        textCapitalization: TextCapitalization.sentences,
                        validator: Validator.checkStringIsNotEmpty,
                        maxLines: null,
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 100,
                              // width: 150,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.brown),
                                borderRadius: BorderRadius.circular(20),
                              ),
                                child: _controller.image.value.path.isNotEmpty
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.file(
                                        (_controller.image.value)!,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : noWidget,
                            ),
                          ),
                          SizedBox(width: 10),
                          SizedBox(
                            height: 100,
                            child: ElevatedButton(
                              onPressed: () {
                                _controller.pickImageFromGallery();
                              },
                              child: Text('Pick Image'),
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        width: Get.width,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_controller.image.value.path.isEmpty) {
                              FrequentUtils.getFailureSnackBar(
                                  'Alert', 'Please select event image');
                              return;
                            }
                            if ((_controller.formKey.currentState?.validate())!) {
                              // _controller.setPickedImage = _pickedImage!;
                              _controller.addEvent();
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(primaryColor),
                            // padding: EdgeInsets.all(10),
                          ),
                          child: _controller.isLoading.value
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  'Post Event',
                                  style: TextStyle(color: Colors.white),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Divider(),
                SizedBox(height: 20),
                ListView.builder(
                  reverse: true,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _controller.children.length,
                    itemBuilder: (context, index){
                      return _listItem(_controller.children[index]);
                    },
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _listItem(EventModel model) {
    return Container(
      height: Get.height * .11,
      width: Get.width * 0.9,
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.brown.shade50,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Container(
              height: Get.height * .1,
              width: Get.width * .3,
              margin: EdgeInsets.only(left: 3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: MemoryImage(
                    Uint8List.fromList(
                        base64Decode(model.eventImage)),
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // SizedBox(width: 10),
          Flexible(
            child: SizedBox(
              width: Get.width * .35,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(model.eventName,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  SizedBox(height: 2),
                  Text(
                    model.eventDetails,
                    maxLines: 5,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 13, height: 1),
                  ),
                ],
              ),
            ),
          ),
          // SizedBox(width: 10),
          Flexible(
            child: SizedBox(
              width: Get.width * .1,
              child: Text(model.eventDate,
                  maxLines: 3,
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ),
          ),
        ],
      ),
    );
  }
}
