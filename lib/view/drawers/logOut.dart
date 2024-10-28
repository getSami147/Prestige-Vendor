import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prestige_vender/utils/Colors.dart';
import 'package:prestige_vender/utils/Images.dart';
import 'package:prestige_vender/utils/constant.dart';
import 'package:prestige_vender/utils/widget.dart';
import 'package:prestige_vender/viewModel/authViewModel.dart';

class AccountLogOut extends StatefulWidget {
  var refreshtoken;

  AccountLogOut({required this.refreshtoken, Key? key}) : super(key: key);

  @override
  State<AccountLogOut> createState() => _AccountLogOutState();
}

class _AccountLogOutState extends State<AccountLogOut> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: color_white,
      insetPadding: const EdgeInsets.symmetric(horizontal: spacing_twinty),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SizedBox(
        height: 300,
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    drawer_ic_logOut,
                    color: colorPrimary,
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                    height: spacing_twinty,
                  ),
                  text("Logout Account",
                     fontWeight: FontWeight.w500,
                        fontSize: textSizeNormal,),
                  const SizedBox(
                    height: spacing_control,
                  ),
                  text("Do you want to logout the App?",
                     fontSize: textSizeMedium, color: textGreyColor),
                  const SizedBox(
                    height: spacing_control,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: spacing_twinty),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: elevatedButton(
                      context,
                      onPress: () {
                        Navigator.pop(context);
                      },
                      height: 45.0,
                      borderRadius: 25.0,
                      backgroundColor: color_white,
                      bodersideColor: blackColor,
                      child: text("Cancel", fontSize: textSizeSMedium),
                    ),
                  ),
                  const SizedBox(
                    width: spacing_standard_new,
                  ),
                  Expanded(
                    child: elevatedButton(
                      context,
                      onPress: () {
                        Map<String, dynamic>data = {
                          "refreshToken": widget.refreshtoken.toString(),
                        };
                    print("refreshToken: ${widget.refreshtoken.toString()}");
                        AuthViewModel().logOutApi(data, context);
                      },
                      height: 45.0,
                      borderRadius: 25.0,
                      backgroundColor: dissmisable_RedColor,
                      bodersideColor: dissmisable_RedColor,
                      child: text("LogOut",
                          color: color_white, fontSize: textSizeSMedium),
                    ),
                  ),
                ],
              ).paddingSymmetric(horizontal: 10),
            ),
          ],
        ),
      ),
    );
  }
}
