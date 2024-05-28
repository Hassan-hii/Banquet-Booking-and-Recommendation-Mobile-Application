import 'dart:convert';
import 'dart:typed_data';
import 'package:banquet/enum/common_status.dart';
import 'package:banquet/enum/user_type.dart';
import 'package:banquet/modules/banquet/controllers/ads_controller.dart';
import 'package:banquet/modules/banquet/models/ads_model.dart';
import 'package:banquet/utils/constants.dart';
import 'package:banquet/widgets/custom_drawer_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class AdsListScreen extends StatelessWidget {
  AdsListScreen({super.key});

  final _controller = Get.put(AdsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Advertisement'),
        centerTitle: true,
      ),
      drawer: const CustomDrawerWidget(userType: UserType.admin),
      body: SingleChildScrollView(
        child: Obx(() {
          if(_controller.isLoading.isTrue){
            return const Center(
              child: CircularProgressIndicator(
                backgroundColor: primaryColor,
              ),
            );
          } else if( _controller.children.isEmpty){
            return SizedBox(
              height: Get.height - 100,
              child: const Center(
                child: Text('No ads available'),
              ),
            );
          }
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: ListView.builder(
              reverse: true,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _controller.children.length,
              itemBuilder: (context, index) {
                return _listItem(_controller.children[index]);
              },
            ),
          );
        }),
      ),
    );
  }

  Widget _listItem(AdsModel model) {
    return Container(
      height: Get.height * 0.17,
      width: Get.width * 0.9,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.brown.shade50,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: Get.height * .1,
                      width: Get.width * .3,
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
                  ],
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: Get.height * .1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text( int.parse(model.adDays) > 1 ? 'For ${model.adDays} days' : 'For ${model.adDays} day',
                                maxLines: 2,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    height: 1)),
                          ),
                          Flexible(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                CircleAvatar(
                                    backgroundColor: model.getStatusColor(),
                                    radius: 5),
                                SizedBox(width: 4),
                                Text(model.status,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Text(
                        model.adDate,
                        maxLines: 3,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 14, height: 1),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(onPressed: (){
                  _controller.updateAdsStatus(model.id!, CommonStatus.rejected.getName);
                },
                  icon:const Icon(
                  Icons.close,
                  size: 20,
                  color: Colors.white,
                ),
                  label:const  Text('Reject', style: TextStyle(color: Colors.white),),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red)),),
                ElevatedButton.icon(onPressed: (){
                  _controller.updateAdsStatus(model.id!, CommonStatus.approved.getName);
                },
                  icon: const Icon(
                    Icons.check,
                    size: 20,
                    color: Colors.white,
                  ),
                  label: const Text('Accept', style: TextStyle(color: Colors.white),),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green)),),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
