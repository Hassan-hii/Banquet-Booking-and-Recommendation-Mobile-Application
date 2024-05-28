import 'dart:convert';
import 'dart:typed_data';
import 'package:banquet/enum/user_type.dart';
import 'package:banquet/gen/assets.gen.dart';
import 'package:banquet/modules/customer/controller/customer_dashboard_controller.dart';
import 'package:banquet/modules/customer/screens/food_available_screen.dart';
import 'package:banquet/modules/customer/screens/search_banquet_screen.dart';
import 'package:banquet/modules/customer/screens/upcoming_events_screen.dart';
import 'package:banquet/utils/constants.dart';
import 'package:banquet/widgets/custom_drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerDashboardScreen extends StatefulWidget {
  const CustomerDashboardScreen({super.key});

  @override
  State<CustomerDashboardScreen> createState() =>
      _CustomerDashboardScreenState();
}

class _CustomerDashboardScreenState extends State<CustomerDashboardScreen> {
  final _controller = Get.put(CustomerDashboardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Dashboard'),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size(Get.width, 100),
          child: Container(
            color: primaryColor,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8),
                    child: TextField(
                      readOnly: true,
                      onTap: () {
                        Get.to(() => SearchBanquetScreen());
                      },
                      decoration: InputDecoration(
                        hintText: 'Search Banquet',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        isDense: true,
                        suffixIcon: Icon(Icons.search, size: 25),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      drawer: const CustomDrawerWidget(userType: UserType.customer),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() {
              return _controller.isLoading.isTrue
                  ? const SizedBox(
                      width: 250,
                      height: 150,
                      child: Card(
                        child: Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                          ),
                        ),
                      ),
                    )
                  : SizedBox(
                      height: _controller.ads.isNotEmpty ? 150 : 0,
                      child: ListView.separated(
                        physics: const ClampingScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: _controller.ads.length,
                        separatorBuilder: (context, index) {
                          return const SizedBox(width: 5);
                        },
                        itemBuilder: (context, index) {
                          return SizedBox(
                            width: 250,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                  image: MemoryImage(
                                    Uint8List.fromList(base64Decode(
                                        _controller.ads[index].adImage)),
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
            }),
            const SizedBox(height: 15),
            Text('Services'.toUpperCase(),
                style:
                    const TextStyle(fontWeight: FontWeight.w400, fontSize: 25)),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _imageButtonWithLabel(
                  image: Assets.images.confetti.image(height: 40),
                  label: 'Events',
                  callback: () => Get.to(() => const UpcomingEventsScreen()),
                ),
                _imageButtonWithLabel(
                  image: Assets.images.takeAwayFood.image(height: 40),
                  label: 'Free Food',
                  callback: () => Get.to(() => const FoodAvailableScreen()),
                ),
                _imageButtonWithLabel(
                    image: Assets.images.thumbsUpDown.image(height: 40),
                    label: 'Recommendation',
                    callback: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _imageButtonWithLabel(
      {required Widget image,
      required String label,
      required VoidCallback callback}) {
    return Column(
      children: [
        IconButton.filled(
          onPressed: callback,
          icon: image,
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(primaryColor),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  @override
  void dispose() {
    _controller.onClose();
    super.dispose();
  }
}
