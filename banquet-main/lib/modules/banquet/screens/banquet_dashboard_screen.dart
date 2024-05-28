import 'package:banquet/enum/user_type.dart';
import 'package:banquet/gen/assets.gen.dart';
import 'package:banquet/modules/banquet/controllers/banquet_dashboard_controller.dart';
import 'package:banquet/modules/banquet/screens/banquet_home_screen.dart';
import 'package:banquet/modules/banquet/screens/banquet_profile_screen.dart';
import 'package:banquet/utils/constants.dart';
import 'package:banquet/widgets/custom_drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BanquetDashboardScreen extends StatefulWidget {
  const BanquetDashboardScreen({super.key});

  @override
  State<BanquetDashboardScreen> createState() => _BanquetDashboardScreenState();
}

class _BanquetDashboardScreenState extends State<BanquetDashboardScreen> {

  int _selectedTab = 0;

  final List _pages = [
    const BanquetProfileScreen(),
    BanquetHomeScreen()
  ];

  _changeTab(int index) {
    setState(() {
      _selectedTab = index;
    });
  }

  @override
  void initState() {
    debugPrint('BanquetDashboard initState');
    Get.lazyPut(() => BanquetDashboardController(), fenix: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('BanquetDashboard build');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(_selectedTab == 0 ? 'Banquet Profile' : 'Home'),
        centerTitle: true,
      ),
      drawer: const CustomDrawerWidget(userType: UserType.banquetOwner),
      body: _pages[_selectedTab],
      bottomNavigationBar: Theme(
        data: ThemeData(
          canvasColor: primaryColor,
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedTab,
          onTap: (index) => _changeTab(index),
          selectedItemColor: Colors.yellow.shade100,
          unselectedItemColor: Colors.white,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: [
            BottomNavigationBarItem(icon: SizedBox(height: 30, child: Assets.images.profile.image()), label: "Profile"),
            BottomNavigationBarItem(icon: SizedBox(height: 30, child: Assets.images.home.image()), label: "Home",),
          ],
        ),
      ),
    );
  }
}
