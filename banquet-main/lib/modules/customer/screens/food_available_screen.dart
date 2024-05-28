import 'dart:convert';
import 'package:banquet/enum/user_type.dart';
import 'package:banquet/gen/assets.gen.dart';
import 'package:banquet/modules/banquet/models/food_model.dart';
import 'package:banquet/utils/constants.dart';
import 'package:banquet/widgets/custom_drawer_widget.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class FoodAvailableScreen extends StatefulWidget {
  const FoodAvailableScreen({super.key});

  @override
  State<FoodAvailableScreen> createState() => _FoodAvailableScreenState();
}

class _FoodAvailableScreenState extends State<FoodAvailableScreen> {

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    getAllFoodAvailable();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      drawer: const CustomDrawerWidget(userType: UserType.customer),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 300,
                      child: Stack(
                        children: [
                          Positioned(
                            left: -30,
                            top: -30,
                            child: sideCircle(),
                          ),
                          Positioned(
                            child: IconButton(icon: Icon(Icons.menu), onPressed: (){
                              _key.currentState!.openDrawer();
                            },),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Food Available',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        SizedBox(
                          height: Get.height * 0.25,
                          child: Assets.images.foodAvailable.image(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 2,
              child: FutureBuilder(
                future: getAllFoodAvailable(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: primaryColor,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text('Something went wrong'),
                    );
                  }

                  final list = snapshot.data;
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: list?.length ?? 0,
                      itemBuilder: (context, index) {
                        return _listItem(list![index]);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget sideCircle() {
    return const CircleAvatar(
      backgroundColor: primaryColor,
      radius: 100,
    );
  }

  Future<List<FoodModel>> getAllFoodAvailable() async {
    try {
      List<FoodModel> listOfFoodAvailable = [];
      DatabaseReference dbRef = FirebaseDatabase.instance.ref().child(foods);
      DatabaseEvent event = await dbRef.once();
      if (event.snapshot.value != null) {
        Map<String, dynamic> food =
            jsonDecode(jsonEncode(event.snapshot.value));
        food.forEach((key, value) {
          listOfFoodAvailable.add(FoodModel.fromJson(value));
        });
      }
      return listOfFoodAvailable;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Widget _listItem(FoodModel model) {
    return Container(
      height: Get.height * 0.12,
      width: Get.width,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.brown.shade50,
      ),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              width: Get.width * 0.3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(model.banquetName,
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  SizedBox(height: 2),
                  Text(model.foodName,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  SizedBox(height: 2),
                  Text(
                    model.foodDetails,
                    maxLines: 5,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 13, height: 1),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 10),
          SizedBox(
            width: Get.width * 0.1,
            child: Text(model.foodDate,
                maxLines: 3,
                softWrap: true,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          ),
        ],
      ),
    );
  }
}
