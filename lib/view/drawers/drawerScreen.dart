import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prestige_vender/utils/Images.dart';
import 'package:prestige_vender/utils/colors.dart';
import 'package:prestige_vender/utils/constant.dart';
import 'package:prestige_vender/utils/widget.dart';
import 'package:prestige_vender/view/authView/PasswordSucussScreen.dart';
import 'package:prestige_vender/view/authView/otpVerification.dart';
import 'package:prestige_vender/view/store/storeDetails.dart';
import 'package:prestige_vender/view/components/component.dart';
import 'package:prestige_vender/view/drawers/mytransaction.dart';
import 'package:prestige_vender/view/orders/orderHistory.dart';
import 'package:prestige_vender/view/drawers/changePassword.dart';
import 'package:prestige_vender/view/drawers/contectUs.dart';
import 'package:prestige_vender/view/profile/deleteAccount.dart';
import 'package:prestige_vender/view/drawers/logOut.dart';
import 'package:prestige_vender/view/drawers/notificationScreen.dart';
import 'package:prestige_vender/view/profile/profileScreen.dart';
import 'package:prestige_vender/viewModel/userViewModel.dart';
import 'package:provider/provider.dart';

class DrawerScreen extends StatelessWidget {
  const DrawerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // var userViewModel = Provider.of<UserViewModel>(context, listen: false);
    var size = MediaQuery.sizeOf(context);
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Consumer<UserViewModel>(builder: (context, value, child) {
              return   Column(
              children: [
                 value.vendorImageURl == null||value.vendorImageURl!.isEmpty
                    ? CircleAvatar(
                        radius: 45,
                        backgroundColor: colorPrimary,
                        child: ClipOval(
                            child: Image.asset(
                          profileimage,
                          height: size.width * .20,
                          width: size.width * .20,
                          fit: BoxFit.cover,
                        )),
                      )
                    : CircleAvatar(
                        radius: size.width * .14,
                        backgroundColor: colorPrimary,
                        child: ClipOval(
                            child: Image.network(
                          value.vendorImageURl.toString(),
                          height: size.width * .24,
                          width: size.width * .24,
                          fit: BoxFit.cover,
                           errorBuilder: (context, error, stackTrace) =>
                                Image.asset(
                                  placeholderProfile,
                                  height: size.width * .24,
                          width: size.width * .24,
                          fit: BoxFit.cover,
                                )
                        )),
                      ),
                text(value.name.toString(),
                        fontSize: textSizeLargeMedium,
                        fontWeight: FontWeight.w600)
                    .paddingTop(spacing_middle),
                text(value.vendorEmail.toString(),
                    fontSize:textSizeSmall, color: textGreyColor),
              ],
                          );
           
            },),
             Expanded(
                child: SingleChildScrollView(physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  DrawerTile(
                    imagename: nav_ic_profile,
                    textName: "Profile",
                    onTap: () {
                      const ProfileScreen().launch(context,
                          pageRouteAnimation: PageRouteAnimation.Fade);
                    },
                  ),
                  DrawerTile(
                    imagename: drawer_ic_oderHistory,
                    textName: "Order History",
                    onTap: () {
                       const OrderHistoryScreen().launch(context,
                          pageRouteAnimation: PageRouteAnimation.Fade);
                    },
                  ),
                  DrawerTile(
                    imagename: drawer_ic_notificationbell,
                    textName: "Notification",
                    onTap: () {
                      const NotificationScreen().launch(context,
                          pageRouteAnimation: PageRouteAnimation.Fade);
                    },
                  ),
                  DrawerTile(
                    imagename: drawer_ic_profile,
                    textName: "My Store",
                    onTap: () {
                       StoreDetailScreen().launch(context,
                          pageRouteAnimation: PageRouteAnimation.Fade);
                    },
                  ),

                  DrawerTile(
                    imagename: drawer_ic_creditCard,
                    textName: "My Transactions",
                    onTap: () {
                      const Mytransactionscreen().launch(context,
                          pageRouteAnimation: PageRouteAnimation.Fade);
                    },
                  ),
                  
                  const Divider().paddingTop(spacing_standard_new),
                  DrawerTile(
                    imagename: drawer_ic_changePassword,
                    textName: "Change Password",
                    onTap: () {
                      const ChangePassword().launch(context,pageRouteAnimation: PageRouteAnimation.Fade);
                    },
                  ),
              
                DrawerTile(
                    imagename: drawer_ic_logOut,
                    textName: "Log Out",
                    onTap: () {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          var provider = Provider.of<UserViewModel>(context,
                              listen: false);
                          // Delete Page (Dialog Box) is Called.............>>>
                          return AccountLogOut(
                            refreshtoken: provider.refreshtoken,
                          );
                        },
                      );
                    },
                  ),
                  DrawerTile(
                  imagename: drawer_ic_deleteAccount,

                  textName: "Delete Account",
                  onTap: () {
                    showDialog(  barrierDismissible: false,

                      context: context,builder: (context) {
                                      // Delete Page (Dialog Box) is Called.............>>>
                                      return const DeleteAccount();
                                    },
                                  );
                  },
                  )
                ],
              ),
            ))
          ],
        )
            .paddingSymmetric(
                horizontal: spacing_large, vertical: spacing_twinty)
            .paddingTop(spacing_twinty)
            .paddingSymmetric(horizontal: spacing_twinty),
      ),
    );
  }
}
