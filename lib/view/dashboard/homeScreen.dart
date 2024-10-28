import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prestige_vender/models/onbondingmodel.dart';
import 'package:prestige_vender/utils/Colors.dart';
import 'package:prestige_vender/utils/Images.dart';
import 'package:prestige_vender/utils/constant.dart';
import 'package:prestige_vender/utils/widget.dart';
import 'package:prestige_vender/view/authView/completeProfileScreen.dart';
import 'package:prestige_vender/view/charts/monthlyChart.dart';
import 'package:prestige_vender/view/drawers/drawerScreen.dart';
import 'package:prestige_vender/view/qrCodeScaner/qrScanner.dart';
import 'package:prestige_vender/view/charts/weeklyChart.dart';
import 'package:prestige_vender/view/store/createStore.dart';
import 'package:prestige_vender/view/withdraws/withdraw.dart';
import 'package:prestige_vender/viewModel/homeViewModel.dart';
import 'package:prestige_vender/viewModel/userViewModel.dart';
import 'package:provider/provider.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  bool isLoading = true;

  int page = 1;
  ScrollController scrollController = ScrollController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var homeViewModel = Provider.of<HomeViewModel>(context, listen: false);
      var userViewModel = Provider.of<UserViewModel>(context, listen: false);
      homeViewModel.shopErrorMessage = null;
      userViewModel.userId = null;
      homeViewModel.setPageloading(true);
      homeViewModel.shopByVendor(context).then(
        (value) {
          
          homeViewModel.getAllPayment(page, context).then(
              (value) {
                if (mounted) {
                  setState(() {
                    isLoading = false;
                  });
                }
              },
            );
         
        },
      ).onError((error, stackTrace) {
         if (homeViewModel.shopErrorMessage != null) {
            // debugPrint("error1 v: ${homeViewModel.shopErrorMessage}");
            if (homeViewModel.shopErrorMessage!.contains("no shop")) {
              debugPrint("error2 v: ${homeViewModel.shopErrorMessage}");
              showCreateShopDialog(context,
                  "Before anything else, you'll need to create a shop.");
            }
          } 
      },);
    });
  }

  showCreateShopDialog(BuildContext context, String message) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:text("Oops!You haven't any shope.",fontSize: textSizeNormal,fontWeight: FontWeight.w500,color: redColor),
          content: text(message,maxLine: 5,color: colorPrimary),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                // Navigate to the Create Shop screen
                 const CreateStore().launch(context, isNewTask: true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colorPrimary,
                
              ),
              child:text("Create Shop",color: white,fontWeight: FontWeight.w500,),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    return Scaffold(
      drawer: const DrawerScreen(),
      key: scaffoldKey,
      backgroundColor: white,
      appBar: AppBar(
        elevation: 0,
        leadingWidth: size.width * .9,
        leading: Row(
          children: [
            InkWell(
              onTap: () {
                scaffoldKey.currentState?.openDrawer();
              },
              child: Consumer<UserViewModel>(
                builder: (context, value, child) => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (value.vendorImageURl == null ||
                        value.vendorImageURl!.isEmpty ||
                        !value.vendorImageURl!.startsWith('http'))
                      ClipOval(
                        child: Image.asset(
                          profileimage,
                          height: size.height * (40 / size.height),
                          width: size.width * (40 / size.width),
                          fit: BoxFit.cover,
                        ),
                      )
                    else
                      ClipOval(
                        child: Image.network(value.vendorImageURl.toString(),
                            height: size.height * (40 / size.height),
                            width: size.width * (40 / size.width),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Image.asset(
                                  placeholderProfile,
                                  height: size.height * (40 / size.height),
                                  width: size.width * (40 / size.width),
                                  fit: BoxFit.cover,
                                )),
                      ),
                  ],
                ).center(),
              ),
            ).paddingLeft(16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                text("Welcome",
                    fontSize: textSizeMedium,
                    fontWeight: FontWeight.w700,
                    color: textGreyColor),
                Consumer<UserViewModel>(
                    builder: (context, value, child) => text(
                        value.name.toString(),
                        fontSize: textSizeNormal,
                        fontWeight: FontWeight.w700,
                        color: black))
              ],
            ).paddingLeft(10),
          ],
        ),
        actions: [
          IconButton(
                  onPressed: () {
                    const QRScanner().launch(context,
                        pageRouteAnimation: PageRouteAnimation.Fade);
                  },
                  icon: SvgPicture.asset(svg_qr, height: 30.0))
              .paddingSymmetric(horizontal: spacing_standard_new)
        ],
      ),
      body: Consumer<HomeViewModel>(
        builder: (context, value, child) {
          return isLoading
              ? const Center(child: CustomLoadingIndicator())
              : SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MonthlyChart(),
                      Consumer<HomeViewModel>(
                        builder: (context, paymentVal, child) {
                          List<dynamic> totalWithdraw = [];
                          List<dynamic> withdrawalRequest = [];
                          List<dynamic> requestedWithdraw = [];
                          List<dynamic> totalPaid = [];
                          List<dynamic> totalPayable = [];
                          List<dynamic> requestedPayable = [];

                          if (paymentVal.myAllPayments != null &&
                              paymentVal.myAllPayments.isNotEmpty) {
                            totalWithdraw = paymentVal.myAllPayments
                                .where((e) =>
                                    e['withdrawalStatus'] == 'Completed' &&
                                    e['type'] == 'withdraw')
                                .toList();
                            withdrawalRequest = paymentVal.myAllPayments
                                .where((e) =>
                                    e['withdrawalStatus'] == 'Pending' &&
                                    e['type'] == 'withdraw')
                                .toList();
                            requestedWithdraw = paymentVal.myAllPayments
                                .where((e) =>
                                    e['withdrawalStatus'] == 'Requested' &&
                                    e['type'] == 'withdraw')
                                .toList();
                            totalPaid = paymentVal.myAllPayments
                                .where((e) =>
                                    e['withdrawalStatus'] == 'Completed' &&
                                    e['type'] == 'payable')
                                .toList();
                            totalPayable = paymentVal.myAllPayments
                                .where((e) =>
                                    e['withdrawalStatus'] == 'Pending' &&
                                    e['type'] == 'payable')
                                .toList();
                            requestedPayable = paymentVal.myAllPayments
                                .where((e) =>
                                    e['withdrawalStatus'] == 'Requested' &&
                                    e['type'] == 'payable')
                                .toList();
                          }

                          if (paymentVal.pageloading &&
                              paymentVal.myAllPayments.isEmpty &&
                              paymentVal.shopErrorMessage == null) {
                            return const Center(
                                child: CustomLoadingIndicator());
                          } else if (paymentVal.myAllPayments.isEmpty ||
                              paymentVal.shopErrorMessage != null) {
                            return Center(
                              child: text("No Payments data",
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w600,
                                      color: colorPrimary)
                                  .paddingTop(20),
                            );
                          } else {
                            List<int> totalList = [
                              totalWithdraw.fold(
                                  0,
                                  (sum, withdrawal) =>
                                      sum +
                                      withdrawal['amount'].toString().toInt()),
                              withdrawalRequest.fold(
                                  0,
                                  (sum, withdrawal) =>
                                      sum +
                                      withdrawal['amount'].toString().toInt()),
                              requestedWithdraw.fold(
                                  0,
                                  (sum, withdrawal) =>
                                      sum +
                                      withdrawal['amount'].toString().toInt()),
                              totalPaid.fold(
                                  0,
                                  (sum, withdrawal) =>
                                      sum +
                                      withdrawal['amount'].toString().toInt()),
                              totalPayable.fold(
                                  0,
                                  (sum, withdrawal) =>
                                      sum +
                                      withdrawal['amount'].toString().toInt()),
                              requestedPayable.fold(
                                  0,
                                  (sum, withdrawal) =>
                                      sum +
                                      withdrawal['amount'].toString().toInt())
                            ];

                            return Column(
                              children: [
                                GridView.builder(
                                  itemCount: homeModel.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 10.w,
                                    mainAxisSpacing: 10.h,
                                    childAspectRatio: 3 / 3.1,
                                  ),
                                  itemBuilder: (BuildContext context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        TotalWithdraw(
                                          title: homeModel[index].title,
                                          totalList: totalList,
                                          initialIndex: index,
                                        ).launch(context,
                                            pageRouteAnimation:
                                                PageRouteAnimation.Fade);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                          color: grey.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(
                                              spacing_middle),
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                SvgPicture.asset(
                                                  homeModel[index].svg,
                                                  color: homeModel[index]
                                                      .iconsColor,
                                                ),
                                                Flexible(
                                                  child: text(
                                                          homeModel[index]
                                                              .title,
                                                          overflow:
                                                              TextOverflow.fade,
                                                          fontSize:
                                                              textSizeSmall.sp,
                                                          isLongText: true,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color:
                                                              homeModel[index]
                                                                  .color_text1)
                                                      .paddingLeft(
                                                          spacing_middle),
                                                ),
                                              ],
                                            ),
                                            text(".....................",
                                                    fontSize: textSizeMedium,
                                                    fontWeight: FontWeight.w600,
                                                    color: homeModel[index]
                                                        .color_divider)
                                                .paddingBottom(10.0),
                                            const Spacer(flex: 1),
                                            text(
                                              "${ammoutFormatter(totalList[index]).toString()} N ",
                                              fontSize: textSizeNormal,
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  homeModel[index].color_text2,
                                            ).paddingBottom(10.0),
                                            const Spacer(flex: 2),
                                            Container(
                                              height: 35.0,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                color: homeModel[index]
                                                    .color_small_contianer,
                                              ),
                                              child: Center(
                                                child: text(
                                                    homeModel[index].buttontext,
                                                    fontSize: textSizeSMedium,
                                                    fontWeight: FontWeight.w500,
                                                    color: white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ).paddingTop(spacing_twinty),
                              ],
                            );
                          }
                        },
                      ),
                    ],
                  ).paddingSymmetric(horizontal: spacing_standard_new),
                );
        },
      ),
    );
  }
}
