import 'dart:convert';
import 'dart:typed_data';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:banquet/enum/common_status.dart';
import 'package:banquet/enum/user_type.dart';
import 'package:banquet/modules/banquet/controllers/banquet_dashboard_controller.dart';
import 'package:banquet/modules/customer/models/booking_model.dart';
import 'package:banquet/modules/customer/screens/my_booking_details_screen.dart';
import 'package:banquet/utils/constants.dart';
import 'package:banquet/utils/frequent_utils.dart';
import 'package:banquet/widgets/custom_drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BanquetHomeScreen extends StatelessWidget {
  BanquetHomeScreen({super.key});

  final _controller = Get.put(BanquetDashboardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawerWidget(userType: UserType.banquetOwner),
      body: SingleChildScrollView(
        child: Obx(() {
          if(_controller.isLoading.isTrue){
            return const Center(
              child: CircularProgressIndicator(
                backgroundColor: primaryColor,
              ),
            );
          } else if(_controller.bookings.isEmpty){
            return SizedBox(
              height: Get.height - 100,
              child: const Center(
                child: Text('No new bookings are requested'),
              ),
            );
          }
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: ListView.builder(
              reverse: true,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _controller.bookings.length,
              itemBuilder: (context, index) {
                return _listItem(_controller.bookings[index]);
              },
            ),
          );
        }),
      ),
    );
  }

  Widget _listItem(BookingModel model) {
    return InkWell(
      onTap: () {
        Get.to(() => MyBookingDetailScreen(bookingModel: model));
      },
      child: Container(
        height: Get.height * 0.2,
        width: Get.width * 0.9,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        margin: const EdgeInsets.only(bottom: 10),
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
                        height: Get.height * 0.12,
                        width: Get.width * 0.3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: MemoryImage(
                              Uint8List.fromList(base64Decode(model.banquetModel.image)),
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
                    height: Get.height * 0.1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(model.banquetModel.brandName,
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
                                      backgroundColor: model.getStatusColors(),
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
                          model.additionalNotes,
                          maxLines: 1,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 14, height: 1),
                        ),
                        SizedBox(height: 5),
                        Text(
                          '${FrequentUtils.formatDateToddMMMyyyy(FrequentUtils.parseStringToDateTime(model.eventDate))} | ${model.eventShift}',
                          maxLines: 1,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 14, height: 1, fontStyle: FontStyle.italic),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Booked by: ${model.userModel.name} \nBooked on: ${FrequentUtils.formatDateToddMMMyyyy(FrequentUtils.parseStringToDateTime(model.bookingDate))}',
                          maxLines: 2,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 13, height: 1, fontWeight: FontWeight.w300),
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
                  Flexible(
                    child: ElevatedButton.icon(onPressed: (){
                      _controller.updateBookingStatus(model.id!, CommonStatus.rejected.getName);
                    },
                      icon:const Icon(
                        Icons.close,
                        size: 15,
                        color: Colors.white,
                      ),
                      label:const AutoSizeText('Reject', style: TextStyle(color: Colors.white, fontSize: 5),),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.red)),),
                  ),
                  Flexible(
                    child: ElevatedButton.icon(onPressed: (){
                      _controller.launchWhatsApp(model.userModel.phoneNumber, 'Hi there, Did you book the banquet?');
                    },
                      icon: const Icon(
                        Icons.message_outlined,
                        size: 15,
                        color: Colors.white,
                      ),
                      label: const AutoSizeText('Message', style: TextStyle(color: Colors.white, fontSize: 5),),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.blue)),),
                  ),
                  Flexible(
                    child: ElevatedButton.icon(onPressed: (){
                      _controller.updateBookingStatus(model.id!, CommonStatus.approved.getName);
                    },
                      icon: const Icon(
                        Icons.check,
                        size: 15,
                        color: Colors.white,
                      ),
                      label: const AutoSizeText('Accept', style: TextStyle(color: Colors.white, fontSize: 5),),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.green)),),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
