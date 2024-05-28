import 'dart:convert';
import 'dart:typed_data';
import 'package:banquet/modules/customer/controller/search_banquet_controller.dart';
import 'package:banquet/modules/customer/screens/banquet_booking_request_screen1.dart';
import 'package:banquet/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

class SearchBanquetScreen extends StatelessWidget {
  SearchBanquetScreen({super.key});

  final _controller = Get.put(SearchAndBookBanquetController());
  final filterList = ['Name', 'Location', 'Price'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight - 15),
          child: Obx(() {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                filterList.length,
                (index) => ChoiceChip(
                  label: Text(filterList[index]),
                  padding: const EdgeInsets.all(8),
                  selected: _controller.getFilterValue == index,
                  backgroundColor: Colors.white,
                  checkmarkColor: Colors.green,
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  onSelected: (value) {
                    if (value) _controller.setFilterValue = index;
                  },
                ),
              ),
            );
          }),
        ),
        title: TextField(
          controller: _controller.filterController,
          style: const TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          decoration: const InputDecoration(
            hintText: 'Search...',
            hintStyle: TextStyle(color: Colors.white54),
            border: InputBorder.none,
          ),
        ),
      ),
      body: SizedBox(
        height: Get.height,
        child: Obx(() {
          if (_controller.isLoading.isTrue) {
            return const Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          } else {
            if (_controller.filterBanquetList.isEmpty) {
              return const Center(
                child: Text('No Banquets found'),
              );
            }
            return ListView.builder(
              itemCount: _controller.filterBanquetList.length,
              itemBuilder: (context, index) {
                final model = _controller.filterBanquetList[index];
                return ListTile(
                  isThreeLine: true,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  leading: CircleAvatar(
                    radius: 40,
                    foregroundImage: MemoryImage(
                      Uint8List.fromList(
                        base64Decode(model.image),
                      ),
                    ),
                  ),
                  title: Row(
                    children: [
                      Expanded(child: Text(model.brandName)),
                      // const Spacer(),
                      Text('(${model.rating ?? 0.0})', style: TextStyle(fontSize: 12),),
                      const Icon(Icons.star, color: Colors.amber, size: 15),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(model.location),
                      Text('Rs. ${model.bookingPrice}/-'),
                      // const SizedBox(height: 10),
                      // RatingBar.builder(
                      //   initialRating: model.rating ?? 0.0,
                      //   direction: Axis.horizontal,
                      //   allowHalfRating: true,
                      //   itemCount: 5,
                      //   ignoreGestures: true,
                      //   itemSize: 15,
                      //   itemPadding:
                      //       const EdgeInsets.symmetric(horizontal: 4.0),
                      //   itemBuilder: (context, _) => const Icon(
                      //     Icons.star,
                      //     color: Colors.amber,
                      //   ),
                      //   onRatingUpdate: (rating) {
                      //     return;
                      //   },
                      // ),
                    ],
                  ),
                  trailing: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Icon(Icons.arrow_forward_ios_rounded),
                  ),
                  onTap: () {
                    _controller.setSelectedBanquet =
                        _controller.banquets[index];
                    Get.to(() => BanquetBookingRequestScreen1());
                  },
                );
              },
            );
          }
        }),
      ),
    );
  }
}
