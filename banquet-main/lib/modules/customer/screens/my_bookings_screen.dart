import 'dart:convert';
import 'dart:typed_data';
import 'package:banquet/enum/user_type.dart';
import 'package:banquet/modules/customer/controller/booking_controller.dart';
import 'package:banquet/modules/customer/screens/my_booking_details_screen.dart';
import 'package:banquet/utils/constants.dart';
import 'package:banquet/widgets/custom_drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

class MyBookingsScreen extends StatelessWidget {
  MyBookingsScreen({super.key});

  final _controller = Get.put(BookingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookings'),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      drawer: const CustomDrawerWidget(userType: UserType.customer),
      body: Obx(() {
        if (_controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: primaryColor,
            ),
          );
        } else {
          if (_controller.bookingsList.isEmpty) {
            return const Center(
              child: Text('No Bookings'),
            );
          } else {
            return ListView.builder(
              itemCount: _controller.bookingsList.length,
              itemBuilder: (context, index) {
                final model = _controller.bookingsList[index];
                return ListTile(
                  contentPadding: const EdgeInsets.all(8),
                  leading: CircleAvatar(
                    radius: 40,
                    foregroundImage: MemoryImage(
                      Uint8List.fromList(
                        base64Decode(model.banquetModel.image),
                      ),
                    ),
                  ),
                  title: Text(
                    model.banquetModel.brandName,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Row(
                        children: [
                          InkWell(
                            onTap: model.hasReviewGiven ? null : () {
                              Get.defaultDialog(
                                title: 'Rating',
                                content: Row(
                                  children: [
                                    RatingBar.builder(
                                      initialRating: 3,
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemPadding:
                                          EdgeInsets.symmetric(horizontal: 4.0),
                                      itemBuilder: (context, _) => Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      onRatingUpdate: (rating) {
                                        _controller.giveRatings(model, rating);
                                        Get.back();
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(5),
                                color: model.hasReviewGiven ? Colors.amber : Colors.grey.shade300,
                              ),
                              child:  Text(model.hasReviewGiven ? 'Reviewed': 'Review'),
                            ),
                          ),
                          const Expanded(child: SizedBox.shrink()),
                        ],
                      ),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded),
                  onTap: () {
                    // _controller.setBookingModel = model;
                    Get.to(() => MyBookingDetailScreen(bookingModel: model));
                  },
                );
              },
            );
          }
        }
      }),
    );
  }
}
