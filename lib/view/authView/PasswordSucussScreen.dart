import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prestige_vender/utils/Images.dart';
import 'package:provider/provider.dart';
import 'package:prestige_vender/utils/Colors.dart';
import 'package:prestige_vender/utils/Constant.dart';
import 'package:prestige_vender/utils/string.dart';
import 'package:prestige_vender/utils/widget.dart';
import 'package:prestige_vender/view/authView/logIn.dart';
import 'package:prestige_vender/viewModel/authViewModel.dart';
import 'package:prestige_vender/viewModel/userViewModel.dart';

class PasswordSucussScreen extends StatefulWidget {
  const PasswordSucussScreen({super.key});

  @override
  State<PasswordSucussScreen> createState() => _PasswordSucussScreenState();
}

class _PasswordSucussScreenState extends State<PasswordSucussScreen> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<UserViewModel>(context);
    var size = MediaQuery.sizeOf(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
                child: Image.asset(
              sucussImage,
              fit: BoxFit.contain,
              height: size.width * .55,
              width: size.width * .55,
            )).paddingTop(spacing_thirty),
            Center(
                child: text(
              PasswordUpdate_title,
              isCentered: true,
               color: black,
                  fontSize: textSizeLarge,
                  fontWeight: FontWeight.w700
            )).paddingTop(spacingBig),
            Center(
                child: text(
              PasswordUpdate_subtitle,
              isCentered: true,
              maxLine: 4,
               color: textGreyColor,
                fontSize: textSizeSMedium,
            )).paddingTop(spacing_middle),
            Consumer<AuthViewModel>(
              builder: (context, value, child) =>
                  elevatedButton(context, loading: value.loading, onPress: () {
                const LoginScreen().launch(context,
                    isNewTask: true,
                    pageRouteAnimation: PageRouteAnimation.Fade);
              },
                      child: text(PasswordUpdate_back,
                          fontWeight: FontWeight.w500,
                              color: color_white)),
            ).paddingTop(size.height * .2),
          ],
        ).paddingSymmetric(horizontal: spacing_twinty),
      ),
    );
  }
}
