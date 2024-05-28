import 'dart:convert';
import 'dart:typed_data';

import 'package:banquet/gen/assets.gen.dart';
import 'package:banquet/modules/banquet/controllers/banquet_dashboard_controller.dart';
import 'package:banquet/modules/banquet/models/banquet_model.dart';
import 'package:banquet/utils/constants.dart';
import 'package:banquet/widgets/menu_section_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BanquetDetailScreen extends StatelessWidget {
  BanquetDetailScreen({super.key});

  final _controller = Get.find<BanquetDashboardController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text('Bnaquet Details'),
          centerTitle: true,
          automaticallyImplyLeading: true,
        ),
        body: _banquetProfileDetails());
  }

  Widget _banquetProfileDetails() {
    final BanquetModel banquetModel = _controller.getSelectedBanquet;
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: Get.width,
            height: Get.height * 0.3,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: MemoryImage(
                  Uint8List.fromList(
                      base64Decode(banquetModel.image)),
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
                SizedBox(height: 20),
                Text(banquetModel.brandName,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _customTile(image: Assets.images.type.image(), title: "Type", subTitle: banquetModel.venueType),
                    _customTile(image: Assets.images.parking.image(), title: "Parking", subTitle: banquetModel.parkingCapacity),
                    _customTile(image: Assets.images.capacity.image(), title: "Capacity", subTitle: banquetModel.personCapacity),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _customTile(image: Assets.images.priceTag.image(), title: "Booking Price", subTitle: banquetModel.bookingPrice),
                    _customTile(image: null, title: "Facilities", subTitle: banquetModel.facilities),
                  ],
                ),
                const SizedBox(height: 20),
                if (banquetModel.menuModel == null)
                  noWidget
                else
                  ListView.builder(
                      itemCount: banquetModel.menuModel?.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final menu = banquetModel.menuModel![index];
                        return Card(
                          child: ExpansionTile(
                            title: Text(menu.pkgName ?? '', style: TextStyle(fontWeight: FontWeight.bold),),
                            subtitle: Text('Rs ${menu.menuPrice}/- per person' ?? ''),
                            maintainState: true,
                            expandedCrossAxisAlignment: CrossAxisAlignment.start,
                            childrenPadding: EdgeInsets.symmetric(horizontal: 20),
                            shape: const Border(),
                            initiallyExpanded: true,
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
                                      image:
                                      Assets.images.drinks.image(height: 14),
                                      title: 'Drinks',
                                      subTitle: menu.drinks ?? ''),
                                ],
                              ),
                            ],
                          ),
                        );
                      }),
                const SizedBox(height: 20),
                Text(banquetModel.description,
                  style: const TextStyle(fontSize: 15), maxLines: 2, softWrap: true,),
                const SizedBox(height: 10),
                Text(banquetModel.location,
                  style: const TextStyle(fontSize: 15), maxLines: 2, softWrap: true,),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _customTile({Image? image, required String title, required String subTitle}){
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(image != null)
              SizedBox(
                  height: 20,
                  child: image),
            const SizedBox(width: 15),
            Text(title,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 10),
        Text(subTitle,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.redAccent), maxLines: 2, softWrap: true,),
      ],
    );
  }
}
