import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prestige_vender/utils/Images.dart';
import 'package:prestige_vender/utils/colors.dart';
import 'package:prestige_vender/utils/constant.dart';
import 'package:prestige_vender/utils/string.dart';
import 'package:prestige_vender/utils/widget.dart';
import 'package:prestige_vender/view/authView/completeProfileScreen.dart';
import 'package:prestige_vender/view/authView/onbondingscreen.dart';
import 'package:prestige_vender/view/store/createStore.dart';

class Welcomescreen extends StatefulWidget {
  const Welcomescreen({super.key});

  @override
  State<Welcomescreen> createState() => _WelcomescreenState();
}

class _WelcomescreenState extends State<Welcomescreen> {
  
  @override
  Widget build(BuildContext context) {
    var size= MediaQuery.sizeOf(context);

    return Scaffold(
        body: CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(
                flex: 3,
              ),
             Center(
                child: SvgPicture.asset(svg_SplashIcon2, height:size.height * 0.08,width:size.height * 0.08 ,fit: BoxFit.contain,),
              ),
              const Spacer(
                flex: 2,
              ),
              text(welcome_welcome, fontSize: 37.0, ).paddingTop(20),
              Container(
                width: 175,
                height: 2,
                decoration: BoxDecoration(
                    color: dissmisable_RedColor,
                    borderRadius: BorderRadius.circular(3)),
              ),
              text(welcome_welcometext,
                      isLongText: true,
                      fontSize: textSizeSMedium,
                      color: textGreyColor,
                      isCentered: true)
                  .paddingTop(20),
              const Spacer(),
              elevatedButton(
                context,
                onPress: () {
                  const Onbondingscreen().launch(context);
                },
                child: text(welcome_getstart, fontSize: textSizeMedium, color: color_white),
              ).paddingTop(20),
              const SizedBox(
                height: 20,
              )
            ],
          ).paddingSymmetric(horizontal: 15, vertical: 15),
        )
      ],
    ));
  }
}
