import 'dart:convert';
import 'dart:typed_data';
import 'package:banquet/enum/user_type.dart';
import 'package:banquet/modules/banquet/controllers/ads_controller.dart';
import 'package:banquet/modules/banquet/models/ads_model.dart';
import 'package:banquet/utils/constants.dart';
import 'package:banquet/utils/frequent_utils.dart';
import 'package:banquet/widgets/custom_drawer_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class AdsPostScreen extends StatelessWidget {
  AdsPostScreen({super.key});

  final AdsController _controller = Get.put(AdsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Ads Posts'),
        centerTitle: true,
      ),
      drawer: const CustomDrawerWidget(userType: UserType.banquetOwner),
      body: SingleChildScrollView(
        child: Obx(() {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                Text('Select no of days to run your ad',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton.outlined(
                      onPressed: _controller.decrementDays,
                      icon: Icon(Icons.remove),
                      color: Colors.white,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(primaryColor),
                      ),
                    ),
                    Text(_controller.getDays > 1 ? '${_controller.getDays} Days' : '${_controller.getDays} Day',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                    IconButton.outlined(
                      onPressed: _controller.incrementDays,
                      icon: Icon(Icons.add),
                      color: Colors.white,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(primaryColor),
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
                      _controller.addAdvertise();
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(primaryColor),
                      // padding: EdgeInsets.all(10),
                    ),
                    child: _controller.isLoading.value
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text(
                            'Post Advertise',
                            style: TextStyle(color: Colors.white),
                          ),
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
                  itemBuilder: (context, index) {
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

  Widget _listItem(AdsModel model) {
    return Container(
      height: 100,
      width: Get.width,
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
              height: 100,
              width: 150,
              margin: EdgeInsets.only(left: 3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: MemoryImage(
                    Uint8List.fromList(base64Decode(model.adImage)),
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // SizedBox(width: 10),
          Expanded(
            child: SizedBox(
              width: 160,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(int.parse(model.adDays) > 1 ? 'For ${model.adDays} Days' : 'For ${model.adDays} Day',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  SizedBox(height: 2),
                  Text(
                    model.status,
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
              width: 40,
              child: Text(model.adDate,
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
