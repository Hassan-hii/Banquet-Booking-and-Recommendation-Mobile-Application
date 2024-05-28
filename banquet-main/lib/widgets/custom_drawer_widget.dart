import 'package:banquet/auth/service/auth_service.dart';
import 'package:banquet/auth/view/login_screen.dart';
import 'package:banquet/enum/user_type.dart';
import 'package:banquet/gen/assets.gen.dart';
import 'package:banquet/modules/admin/screens/admin_dashboard_screen.dart';
import 'package:banquet/modules/admin/screens/ads_list_screen.dart';
import 'package:banquet/modules/banquet/controllers/banquet_dashboard_controller.dart';
import 'package:banquet/modules/banquet/screens/ads_post_screen.dart';
import 'package:banquet/modules/banquet/screens/banquet_dashboard_screen.dart';
import 'package:banquet/modules/banquet/screens/event_post_screen.dart';
import 'package:banquet/modules/banquet/screens/food_post_screen.dart';
import 'package:banquet/modules/banquet/screens/history_screen.dart';
import 'package:banquet/modules/customer/screens/customer_dashboard_screen.dart';
import 'package:banquet/modules/customer/screens/food_available_screen.dart';
import 'package:banquet/modules/customer/screens/my_bookings_screen.dart';
import 'package:banquet/modules/customer/screens/upcoming_events_screen.dart';
import 'package:banquet/modules/customer/screens/wishlist_screen.dart';
import 'package:banquet/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDrawerWidget extends StatelessWidget {
  const CustomDrawerWidget({super.key, required this.userType});
  final UserType userType;

  @override
  Widget build(BuildContext context) {
    switch(userType){
      case UserType.admin:
        return _adminDrawer();
      case UserType.banquetOwner:
        return _banquetDrawer();
      case UserType.customer:
        return _customerDrawer();
    }
  }

  Drawer _banquetDrawer(){
    return Drawer(
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: DrawerHeader(
              decoration: BoxDecoration(color: primaryColor),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(
                    backgroundImage: Assets.images.bookings.image().image,
                    radius: 40,
                  ),
                  Text(
                    'Welcome Abc',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            title: const Text('Dashboard'),
            onTap: () {
              Get.off(() => const BanquetDashboardScreen());
            },
          ),
          ListTile(
            title: const Text('Event Post'),
            onTap: () {
              Get.off(() => EventPostScreen());
            },
          ),
          ListTile(
            title: const Text('Food Post'),
            onTap: () {
              Get.off(() => FoodPostScreen());
            },
          ),
          ListTile(
            title: const Text('Advertisement'),
            onTap: () {
              Get.off(() => AdsPostScreen());
            },
          ),
          ListTile(
            title: const Text('History'),
            onTap: () {
              Get.off(() => HistoryScreen());
            },
          ),
          Spacer(),
          ListTile(
            title: const Text('Logout'),
            trailing: Icon(Icons.logout_outlined),
            onTap: onSignOut,
          ),
        ],
      ),
    );
  }

  Drawer _adminDrawer(){
    return Drawer(
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: DrawerHeader(
              decoration: BoxDecoration(color: primaryColor),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(
                    backgroundImage: Assets.images.bookings.image().image,
                    radius: 40,
                  ),
                  Text(
                    'Welcome Abc',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            title: const Text('Dashboard'),
            onTap: () {
              Get.off(() => AdminDashboardScreen());
            },
          ),
          ListTile(
            title: const Text('Advertisement'),
            onTap: () {
              Get.off(() => AdsListScreen());
            },
          ),
          Spacer(),
          ListTile(
            title: const Text('Logout'),
            trailing: Icon(Icons.logout_outlined),
            onTap: onSignOut,
          ),
        ],
      ),
    );
  }

  Drawer _customerDrawer(){
    return Drawer(
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: DrawerHeader(
              decoration: BoxDecoration(color: primaryColor),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(
                    backgroundImage: Assets.images.bookings.image().image,
                    radius: 40,
                  ),
                  Text(
                    'Welcome Abc',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            title: const Text('Home'),
            onTap: () {
              Get.off(() =>  CustomerDashboardScreen());
            },
          ),
          ListTile(
            title: const Text('Bookings'),
            onTap: () {
              Get.off(() => MyBookingsScreen());
            },
          ),
          ListTile(
            title: const Text('Wishlist'),
            onTap: () {
              Get.off(() => WishlistScreen());
            },
          ),
          ListTile(
            title: const Text('Upcoming Events'),
            onTap: () {
              Get.off(() => UpcomingEventsScreen());
            },
          ),
          ListTile(
            title: const Text('Food Available'),
            onTap: () {
              Get.off(() => FoodAvailableScreen());
            },
          ),
          Spacer(),
          ListTile(
            title: const Text('Logout'),
            trailing: Icon(Icons.logout_outlined),
            onTap: onSignOut,
          ),
        ],
      ),
    );
  }

  void onSignOut()  async{
      AuthService().signOutUser();
      Get.back();
      Get.off(() => const LoginScreen());
      Get.delete<BanquetDashboardController>();
  }
}
