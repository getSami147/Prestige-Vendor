import 'package:flutter/material.dart';

import 'package:nb_utils/nb_utils.dart';
import 'package:prestige_vender/utils/colors.dart';
import 'package:prestige_vender/utils/constant.dart';
import 'package:prestige_vender/utils/widget.dart';
import 'package:prestige_vender/view/dashboard/dashboard.dart';

class OrderSuccessfulScreen extends StatelessWidget {
  const OrderSuccessfulScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color_white,
      appBar: AppBar(
        title: text("Congratulations",
            fontSize: textSizeNormal, fontWeight: FontWeight.w500),
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Image.asset("images/orderSuccess.png")
                        .paddingTop(spacing_twinty),
                    const SizedBox(height: spacing_xxLarge),
                    text(
                      "Congratulations!\n Your subscription is now active",
                      fontSize: 22.0,
                      fontWeight: FontWeight.w700,
                      fontFamily: fontBold,
                      maxLine: 2,
                      isCentered: true,
                    ),
                    const SizedBox(height: spacing_standard),
                    text(
                      "Granting you unlimited access to premium content.\n Enjoy the journey",
                      fontSize: textSizeMedium,
                      fontWeight: FontWeight.w500,
                      fontFamily: fontMedium,
                      color: textcolorSecondary,
                      maxLine: 2,
                      isCentered: true,
                    )
                  ],
                ),
              ),
            ),
            TextButton(
                onPressed: () {
                   Dashboard().launch(context, isNewTask: true);
                },
                child: text("Back to home",color:colorPrimary)),
            const SizedBox(height: spacing_large)
          ],
        ),
      ),
    );
  }
}
