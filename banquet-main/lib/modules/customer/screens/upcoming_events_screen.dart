import 'dart:convert';
import 'package:banquet/enum/user_type.dart';
import 'package:banquet/gen/assets.gen.dart';
import 'package:banquet/modules/banquet/models/event_model.dart';
import 'package:banquet/utils/constants.dart';
import 'package:banquet/widgets/custom_drawer_widget.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class UpcomingEventsScreen extends StatefulWidget {
  const UpcomingEventsScreen({super.key});

  @override
  State<UpcomingEventsScreen> createState() => _UpcomingEventsScreenState();
}

class _UpcomingEventsScreenState extends State<UpcomingEventsScreen> {

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    getAllUpcomingEvents();
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
                          'Upcoming Events',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        Flexible(child: Assets.images.upcomingEvents.image()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 2,
              child: FutureBuilder(
                future: getAllUpcomingEvents(),
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
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: list?.length ?? 0,
                      itemBuilder: (context, index){
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

  Future<List<EventModel>> getAllUpcomingEvents() async {
    try {
      List<EventModel> listOfEvents = [];
      DatabaseReference dbRef = FirebaseDatabase.instance.ref().child(events);
      DatabaseEvent event = await dbRef.once();
      if (event.snapshot.value != null) {
        Map<String, dynamic> events =
            jsonDecode(jsonEncode(event.snapshot.value));
        events.forEach((key, value) {
          listOfEvents.add(EventModel.fromJson(value));
        });
      }
      return listOfEvents;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Widget _listItem(EventModel model) {
    return Container(
      height: Get.height * 0.12,
      width: Get.width,
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.brown.shade50,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: Get.height * 0.11,
            width: Get.width * 0.3,
            margin: EdgeInsets.only(left: 3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: MemoryImage(
                  Uint8List.fromList(base64Decode(model.eventImage)),
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 10),
          SizedBox(
            width: Get.width * 0.35,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(model.banquetName,
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                SizedBox(height: 2),
                Text(model.eventName,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                SizedBox(height: 2),
                Text(
                  model.eventDetails,
                  maxLines: 5,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 13, height: 1),
                ),
              ],
            ),
          ),
          SizedBox(width: 10),
          SizedBox(
            width: Get.width * 0.1,
            child: Text(model.eventDate,
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
