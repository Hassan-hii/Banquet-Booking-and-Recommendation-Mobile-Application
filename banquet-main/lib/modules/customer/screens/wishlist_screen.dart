import 'dart:convert';
import 'dart:typed_data';
import 'package:banquet/enum/user_type.dart';
import 'package:banquet/modules/customer/controller/wishlist_controller.dart';
import 'package:banquet/utils/constants.dart';
import 'package:banquet/widgets/custom_drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WishlistScreen extends StatelessWidget {
  final _controller = Get.put(WishListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Your Wishlist'),
        centerTitle: true,
      ),
      drawer: const CustomDrawerWidget(userType: UserType.customer),
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
            if (_controller.wishlist.isEmpty) {
              return const Center(
                child: Text('No Banquets found'),
              );
            }
            return ListView.builder(
              itemCount: _controller.wishlist.length,
              itemBuilder: (context, index) {
                final model = _controller.wishlist[index];
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
                  title: Text(model.brandName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(model.location),
                      Text('Rs. ${model.bookingPrice}/-')
                    ],
                  ),
                  // trailing: const Padding(
                  //   padding: EdgeInsets.symmetric(vertical: 10),
                  //   child: Icon(Icons.arrow_forward_ios_rounded),
                  // ),
                  // onTap: () {
                  //   _controller.setSelectedBanquet =
                  //   _controller.banquets[index];
                  //   Get.to(() => BanquetBookingRequestScreen1());
                  // },
                );
              },
            );
          }
        }),
      ),
    );
  }
}
