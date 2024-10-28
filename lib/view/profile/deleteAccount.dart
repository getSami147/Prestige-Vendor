import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prestige_vender/utils/Images.dart';
import 'package:prestige_vender/utils/colors.dart';
import 'package:prestige_vender/utils/constant.dart';
import 'package:prestige_vender/utils/widget.dart';
import 'package:prestige_vender/viewModel/authViewModel.dart';



class DeleteAccount extends StatelessWidget {
  const DeleteAccount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
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
                    drawer_ic_deleteAccount,
                    height: 40,
                    width: 40,
                  ),
                  const SizedBox(
                    height: spacing_twinty,
                  ),
                  text(
                    "Deleting Account",
                    fontWeight: FontWeight.w500,
                    fontSize: textSizeLargeMedium,
                    color: colorPrimary,
                  ),
                  const SizedBox(
                    height: spacing_control,
                  ),
                  text(
                    "Do you want to delete your Account?",
                    fontSize: textSizeMedium,
                  ),
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
                      bodersideColor: Colors.black,
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
                        AuthViewModel().deleteMe(context);
                      },
                      height: 45.0,
                      borderRadius: 25.0,
                      backgroundColor: redColor,
                      bodersideColor: redColor,
                      child: text("Delete",
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
