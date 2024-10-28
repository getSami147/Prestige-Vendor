import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:prestige_vender/utils/colors.dart';
import 'package:prestige_vender/utils/widget.dart';
import 'package:prestige_vender/view/store/storeDetails.dart';
import 'package:prestige_vender/view/orders/orderHistory.dart';
import 'package:prestige_vender/view/dashboard/homeScreen.dart';
import 'package:prestige_vender/view/profile/profileScreen.dart';
import 'package:prestige_vender/viewModel/homeViewModel.dart';
import 'package:prestige_vender/viewModel/userViewModel.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class Dashboard extends StatefulWidget {
int? currentIndex;
   Dashboard({Key? key,this.currentIndex}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  
  @override
  void initState() {
    var provider = Provider.of<UserViewModel>(context, listen: false);
    // var authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    // authViewModel.updateDeviceToken(context);
    provider.getUserTokens();
    provider.getCurrentLocation();
    getCurrentCoordinates();
    //    var homeViewModel = Provider.of<HomeViewModel>(context, listen: false);
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   homeViewModel.shopByVendor(context);
    // });
    // initializeLocation(provider);
    super.initState();
  }
// get current Location
  getCurrentCoordinates() async {
    var provider = Provider.of<UserViewModel>(context, listen: false);
    var locations = await Geolocator.getCurrentPosition();
    provider.mylat = locations.latitude;
    provider.mylng = locations.longitude;
    setState(() {});
    return locations;
  }
  

  final List<Widget> screens = [
    const Homescreen(),
     StoreDetailScreen(),
    const OrderHistoryScreen(),
    const ProfileScreen()
  ];
  
  @override
  Widget build(BuildContext context) {
    widget.currentIndex = widget.currentIndex ?? 0;
    print("currentIndex ${widget.currentIndex}");
    return Scaffold(
      bottomNavigationBar: SalomonBottomBar(
        currentIndex:widget.currentIndex!,
        onTap: (i) => setState(() => widget.currentIndex = i),
        items: [
          /// Home
          SalomonBottomBarItem(
            icon: const Icon(
              Icons.stacked_line_chart_rounded,
              size: 30,
            ),
            title: const Text("Dashboard"),
            selectedColor: colorPrimary,
          ),

          /// my store
          SalomonBottomBarItem(
            icon: const Icon(
              Icons.storefront_outlined,
              size: 30,
            ),
            title: const Text("My Store"),
            selectedColor: colorPrimary,
          ),

          /// order
          SalomonBottomBarItem(
            icon: const Icon(
              Icons.shopping_bag_outlined,
              size: 30,
            ),
            title: const Text("Order History"),
            selectedColor: colorPrimary,
          ),

          /// Profile
          SalomonBottomBarItem(
            icon: const Icon(
              Icons.person_outline_outlined,
              size: 30,
            ),
            title: const Text("Profile"),
            selectedColor: colorPrimary,
          ),
        ],
      ),
       // ignore: deprecated_member_use
       body: WillPopScope(
        onWillPop: () async {
if (widget.currentIndex != 0) {
    widget.currentIndex = 0;
    setState(() {

    });

} else {
    // Show exit confirmation dialog
          return await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Exit the app?'),
                content: const Text('Are you sure you want to exit the app?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: text("NO")
                  ),
                  TextButton(
                    onPressed: () {
                      exit(0);
                    },
                    child:text("Yes")
                  ),
                ],
              );
            },);
}
          return false;
        },
        child: PageView(
          children:  [screens[widget.currentIndex!]],
        ),
      ),
    );
     
  }
}
