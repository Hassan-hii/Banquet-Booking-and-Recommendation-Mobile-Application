import 'dart:convert';
import 'dart:typed_data';
import 'package:banquet/gen/assets.gen.dart';
import 'package:banquet/modules/customer/controller/search_banquet_controller.dart';
import 'package:banquet/modules/customer/screens/banquet_booking_request_screen2.dart';
import 'package:banquet/utils/constants.dart';
import 'package:banquet/widgets/menu_section_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BanquetBookingRequestScreen1 extends StatelessWidget {
  BanquetBookingRequestScreen1({super.key});

  final _controller = Get.find<SearchAndBookBanquetController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: const Text('Banquet Booking'),
          centerTitle: true,
          actions: [
            Obx((){
                return IconButton(
                  onPressed: () {
                    _controller.addToWishList();
                    _controller.wishlistAdd.value = true;
                  },
                  isSelected: _controller.wishlistAdd.value,
                  color: Colors.redAccent,
                  icon: Icon(Icons.favorite_border),
                  selectedIcon: Icon(Icons.favorite),
                );
              }
            ),
          ],
        ),
        body: SingleChildScrollView(child: _banquetProfileDetails()));
  }

  Widget _banquetProfileDetails() {
    return Column(
      children: [
        Container(
          width: Get.width,
          height: Get.height * 0.3,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: MemoryImage(
                Uint8List.fromList(
                    base64Decode(_controller.getSelectedBanquet.image)),
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(_controller.getSelectedBanquet.brandName,
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 20),
              Text('Location',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 5),
              Text(_controller.getSelectedBanquet.location,
                  softWrap: true, maxLines: 2),
              SizedBox(height: 10),
              Text('Description',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text(_controller.getSelectedBanquet.description,
                  softWrap: true, maxLines: 4),
              SizedBox(height: 10),
              Text('Details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _customTile(
                      image: Assets.images.type.image(),
                      title: "Type",
                      subTitle: _controller.getSelectedBanquet.venueType),
                  _customTile(
                      image: Assets.images.parking.image(),
                      title: "Parking",
                      subTitle: _controller.getSelectedBanquet.parkingCapacity),
                  _customTile(
                      image: Assets.images.capacity.image(),
                      title: "Capacity",
                      subTitle: _controller.getSelectedBanquet.personCapacity),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(
                    child: _customTile(
                        image: Assets.images.priceTag.image(),
                        title: "Booking Price",
                        subTitle:
                            'Rs ${_controller.getSelectedBanquet.bookingPrice}/-'),
                  ),
                  Expanded(
                    child: _customTile(
                        image: null,
                        title: "Facilities",
                        subTitle: _controller.getSelectedBanquet.facilities),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // TODO: Menu list should be added here
              if (_controller.getSelectedBanquet.menuModel == null)
                noWidget
              else
                ListView.builder(
                  itemCount: _controller.getSelectedBanquet.menuModel!.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final menu =
                        _controller.getSelectedBanquet.menuModel![index];
                    return Card(
                      child: ExpansionTile(
                        title: Text(
                          menu.pkgName ?? '',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle:
                            Text('Rs ${menu.menuPrice}/- per person' ?? ''),
                        maintainState: true,
                        expandedCrossAxisAlignment: CrossAxisAlignment.start,
                        childrenPadding: EdgeInsets.symmetric(horizontal: 20),
                        shape: const Border(),
                        initiallyExpanded: true,
                        leading: Obx(() {
                          return Radio<int>(
                            value: index,
                            groupValue: _controller.getGroupValue,
                            onChanged: (value) {
                              _controller.setGroupValue = value!;
                              _controller.setSelectedMenu = menu;
                            },
                          );
                        }),
                        children: [
                          Column(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MenuSectionWidget(
                                  image: Assets.images.mainCourse
                                      .image(height: 14),
                                  title: 'Main Course',
                                  subTitle: menu.mainCourse ?? ''),
                              MenuSectionWidget(
                                  image:
                                      Assets.images.dessert.image(height: 14),
                                  title: 'Desserts',
                                  subTitle: menu.desserts ?? ''),
                              MenuSectionWidget(
                                  image: Assets.images.drinks.image(height: 14),
                                  title: 'Drinks',
                                  subTitle: menu.drinks ?? ''),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              SizedBox(height: 20),
              SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.to(() => BanquetBookingRequestScreen2());
                    },
                    child: Text('Continue Booking'),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(primaryColor),
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _customTile(
      {Image? image, required String title, required String subTitle}) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (image != null) SizedBox(height: 20, child: image),
            const SizedBox(width: 15),
            Text(title,
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 10),
        Text(subTitle,
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.redAccent)),
      ],
    );
  }
}
