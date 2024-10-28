import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prestige_vender/utils/Images.dart';
import 'package:prestige_vender/view/authView/logIn.dart';
import 'package:prestige_vender/view/authView/welcomescreen.dart';
import 'package:prestige_vender/viewModel/authViewModel.dart';
import 'package:prestige_vender/viewModel/services/notificationServices.dart';
import 'package:provider/provider.dart';
import '../../utils/Colors.dart'; // Updated import path
import '../../viewModel/userViewModel.dart'; // Updated import path

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isInitial = true;
  NotificationServices notificationServices = NotificationServices();
  @override
  void initState() {
    super.initState();
    var provider = Provider.of<UserViewModel>(context, listen: false);
    provider.getUserTokens();
    notificationServices.requestPermissionNotification(context);
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    NotificationServices().getToken(context).then((value) {
      if (kDebugMode) {
        print("device token: $value");
      }
    });

    // provider.getCurrentCoordinates();
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isInitial = false;
      });
    });

    Future.delayed(const Duration(seconds: 3), () {
      provider.isCheckLogin(context); // Corrected method name
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const Welcomescreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: colorPrimary,
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Padding(
          //   padding: _isInitial
          //       ? const EdgeInsets.only(left: 0)
          //       : const EdgeInsets.only(left: 0),
          //   child: SvgPicture.asset(
          //     svg_SplashText,
          //     height: _isInitial ? 10 : 25,
          //     width: _isInitial ? 5 : 25,
          //     fit: BoxFit.cover,
          //   ),
          // ),
          Center(
            child: AnimatedContainer(
              color: white,
              duration: const Duration(milliseconds: 500),
              curve: Curves.linear,
              // height: 100,
              // width: 50,
              alignment: Alignment.center,
              // margin: _isInitial
              //     ? const EdgeInsets.only(right: 0)
              //     : const EdgeInsets.only(right: 0),
              child: SvgPicture.asset(svg_SplashIcon2, height:size.height * 0.08,width:size.height * 0.08 ,fit: BoxFit.contain,),

            ),
          ),
        ],
      ),
    );
  }
}

