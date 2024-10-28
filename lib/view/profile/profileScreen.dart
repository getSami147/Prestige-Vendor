import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prestige_vender/utils/Images.dart';
import 'package:prestige_vender/utils/colors.dart';
import 'package:prestige_vender/utils/constant.dart';
import 'package:prestige_vender/utils/widget.dart';
import 'package:prestige_vender/view/bankAccount/accountDetails.dart';
import 'package:prestige_vender/view/bankAccount/addAccountDetails.dart';
import 'package:prestige_vender/view/drawers/notificationScreen.dart';
import 'package:prestige_vender/view/profile/profile_update.dart';
import 'package:prestige_vender/viewModel/authViewModel.dart';
import 'package:prestige_vender/viewModel/userViewModel.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  // final emailFouseNode = FocusNode();
  final nameFouseNode = FocusNode();
  final emailFouseNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    var userViewModel = Provider.of<UserViewModel>(context, listen: false);
    nameController.text = userViewModel.name.toString();
    emailController.text = userViewModel.vendorEmail.toString();
    return Scaffold(
      backgroundColor: white,
      appBar: appBarWidget("Profile", color: white, elevation: 0, actions: [
        IconButton(
            onPressed: () {
              const NotificationScreen().launch(context);
            },
            icon: SvgPicture.asset(drawer_ic_notificationbell)
                .paddingRight(spacing_standard_new))
      ]),
      body: Center(
        child: FutureBuilder(
          future: AuthViewModel().getMeApi(context),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CustomLoadingIndicator());
            } else if (snapshot.hasError) {
              return Center(child: text(snapshot.error.toString()));
            } else {
              var data = snapshot.data["me"];
              // print(data);
              return Center(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      (data["image"] == null ||
                              data["image"].isEmpty ||
                              !data["image"].toString().startsWith('http'))
                          ? Center(
                              child: CircleAvatar(
                                radius: 45,
                                backgroundColor: colorPrimary,
                                child: ClipOval(
                                    child: Image.asset(
                                  profileimage,
                                  height: size.width * .20,
                                  width: size.width * .20,
                                  fit: BoxFit.cover,
                                )),
                              ),
                            )
                          : Center(
                              child: CircleAvatar(
                                radius: size.width * .14,
                                backgroundColor: colorPrimary,
                                child: ClipOval(
                                    child: Image.network(
                                        data["image"].toString(),
                                        height: size.width * .24,
                                        width: size.width * .24,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Image.asset(
                                                  placeholderProfile,
                                                  height: size.width * .24,
                                                  width: size.width * .24,
                                                  fit: BoxFit.cover,
                                                ))),
                              ),
                            ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          text(data["name"].toString(),
                              fontSize: textSizeNormal,
                              fontWeight: FontWeight.w700),
                          CircleAvatar(
                            radius: 15,
                            backgroundColor: colorPrimary.withOpacity(.2),
                            child: IconButton(
                                padding: const EdgeInsets.all(0),
                                onPressed: () {
                                  const UpdateProfileScreen().launch(context);
                                  //  UpdateProfileScreen().launch(context,
                                  //                             pageRouteAnimation: PageRouteAnimation.Fade);
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  size: 18.0,
                                )),
                          ).paddingLeft(spacing_standard),
                        ],
                      ).paddingTop(spacing_twinty),
                      text("Personal Details",
                              fontSize: textSizeLargeMedium,
                              fontWeight: FontWeight.w600)
                          .paddingTop(spacing_thirty),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 24,
                                  offset: const Offset(0, 4),
                                  spreadRadius: 0,
                                  color:
                                      const Color(0xff333333).withOpacity(.10))
                            ]),
                        child: Column(
                          children: [
                            ProfileDetailContainer(
                              leadingIcon: svg_phone,
                              title: "Mobile Number",
                              subtitle: data["contact"].toString(),
                            ),
                            ProfileDetailContainer(
                              leadingIcon: svg_email,
                              title: "Email",
                              subtitle: data["email"].toString(),
                            ),
                            ProfileDetailContainer(
                              leadingIcon: drawer_ic_profile,
                              title: "Role",
                              subtitle: data["role"].toString(),
                            ),
                            ProfileDetailContainer(
                              leadingIcon: svg_location,
                              title: "Location",
                              subtitle:
                                  "${data["statesName"].toString()}, ${data["LGA"].toString()}, ${data["countryName"].toString()}",
                            ),
                          ],
                        )
                            .paddingSymmetric(horizontal: spacing_standard_new)
                            .paddingOnly(bottom: spacing_standard_new),
                      ).paddingTop(spacing_middle),

                      const SizedBox(
                        height: spacing_middle,
                      ),

                      InkWell(
                        onTap: () {
                          const MyAccountDetails().launch(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 24,
                                    offset: const Offset(0, 4),
                                    spreadRadius: 0,
                                    color: const Color(0xff333333)
                                        .withOpacity(.10))
                              ]),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 15,
                              backgroundColor: colorPrimary.withOpacity(.2),
                              child: IconButton(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(0),
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.account_balance,
                                    color: colorPrimary.withOpacity(.8),
                                    size: 20,
                                  )),
                            ),
                            title: text("Account Details",
                                fontSize: textSizeSMedium,
                                fontWeight: FontWeight.w500),
                            trailing: const Icon(
                              Icons.arrow_forward,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: spacing_thirty,
                      ),
                      // AccountScreen
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ).paddingSymmetric(horizontal: spacing_large),
    );
  }
}

// ignore: must_be_immutable
class ProfileDetailContainer extends StatelessWidget {
  String? leadingIcon;
  String? title;
  String? subtitle;
  VoidCallback? ontap;
  bool isContainer = false;
  ProfileDetailContainer(
      {super.key,
      this.leadingIcon,
      this.ontap,
      this.title,
      this.subtitle,
      this.isContainer = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        decoration: isContainer == true
            ? BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                    BoxShadow(
                        blurRadius: 24,
                        offset: const Offset(0, 4),
                        spreadRadius: 0,
                        color: const Color(0xff333333).withOpacity(.10))
                  ])
            : const BoxDecoration(),
        child: Padding(
          padding: isContainer == true
              ? const EdgeInsets.symmetric(
                  horizontal: spacing_standard_new, vertical: spacing_middle)
              : const EdgeInsets.only(top: spacing_standard_new),
          child: Row(
            children: [
              CircleAvatar(
                radius: 15,
                backgroundColor: colorPrimary.withOpacity(.2),
                child: IconButton(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(0),
                    onPressed: () {},
                    icon: SvgPicture.asset(
                      leadingIcon.toString(),
                      color: colorPrimary,
                      height: 18,
                      width: 18,
                    )),
              ),
              isContainer == true
                  ? Padding(
                      padding: const EdgeInsets.only(left: spacing_middle),
                      child: text(title.toString(),
                          fontSize: textSizeLargeMedium,
                          fontWeight: FontWeight.w600),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        text(title.toString(),
                            color: textGreyColor,
                            fontSize: textSizeSMedium,
                            fontWeight: FontWeight.w500),
                        text(subtitle.toString(),
                            fontSize: textSizeSMedium,
                            fontWeight: FontWeight.w500),
                      ],
                    ).paddingLeft(spacing_middle)
            ],
          ),
        ),
      ),
    );
  }
}
