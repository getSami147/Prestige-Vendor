import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prestige_vender/utils/Images.dart';
import 'package:prestige_vender/utils/colors.dart';
import 'package:prestige_vender/utils/constant.dart';
import 'package:prestige_vender/utils/string.dart';
import 'package:prestige_vender/utils/widget.dart';
import 'package:prestige_vender/viewModel/homeViewModel.dart';
import 'package:prestige_vender/viewModel/userViewModel.dart';
import 'package:provider/provider.dart';

class Checkoutscreen extends StatefulWidget {
  const Checkoutscreen({super.key});

  @override
  State<Checkoutscreen> createState() => _CheckoutscreenState();
}

class _CheckoutscreenState extends State<Checkoutscreen> {
  var controller = TextEditingController();
  // @override
  // void initState() {
  //   var userViewModel = Provider.of<UserViewModel>(context, listen: false);

  //   // userViewModel.cartTotalPoints =cartTotalToPoints(userViewModel.total.toDouble());
  //   // print("point :${double.parse(userViewModel.cartTotalPoints.toStringAsFixed(2))}");
  //   // TODO: implement initState
  //   super.initState();
  // }
  double? calculatedCash;
  double? calculateCash(double totalCash, double redeemValue, double points) {
    print("total nira: $totalCash");
    print(" APi redeemValue $redeemValue");
    print(" TextFeild points $points");

    if (points == 0) return 0;
    double totalPoints = totalCash / redeemValue / 100;
    double cashInPoints = totalPoints - points;
    calculatedCash = cashInPoints * redeemValue * 100;
    // print("calculatedCash $calculatedCash");
    return calculatedCash;
  }

  double? pointvalue;
  @override
  Widget build(BuildContext context) {
    var userViewModel = Provider.of<UserViewModel>(context, listen: false);
    if (kDebugMode) {
      print("calculatedCash :$calculatedCash");
      print("User prestigePoints :${userViewModel.userPrestigePoint}");
      print("userCurrentNira :${userViewModel.userCurrentNira}");
    }
    var orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      appBar: AppBar(
        title: text(Checkoutscreen_check,
            fontSize: textSizeLarge, fontWeight: FontWeight.w700),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Consumer<UserViewModel>(
          builder: (context, value, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                text(Checkoutscreen_Prestige,
                        fontSize: textSizeMedium, fontWeight: FontWeight.w600)
                    .paddingTop(10),
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            color: const Color(0xff252525).withOpacity(0.11),
                            blurRadius: 15,
                            offset: const Offset(0, 4))
                      ]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          text(
                              ammoutFormatter(
                                  (userViewModel.userPrestigePoint is double
                                              ? userViewModel.userPrestigePoint
                                              : double.tryParse(userViewModel
                                                  .userPrestigePoint
                                                  .toString()))
                                          ?.toInt() ??
                                      0),
                              // userViewModel.userPrestigePoint.toString(),
                              color: colorPrimary.withOpacity(0.4),
                              fontSize: textSizeMedium,
                              fontWeight: FontWeight.w600),
                          const SizedBox(
                            width: 5,
                          ),
                          Image.asset(
                            coin2,
                            height: 20,
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.center,
                        height: 29,
                        decoration: BoxDecoration(
                            color: textcolorSecondary,
                            borderRadius: BorderRadius.circular(6)),
                        child: text(
                                "N ${ammoutFormatter((userViewModel.userCurrentNira is double ? userViewModel.userCurrentNira : double.tryParse(userViewModel.userCurrentNira.toString()))?.toInt() ?? 0)}",
                                fontSize: textSizeSMedium,
                                fontWeight: FontWeight.w600)
                            .paddingSymmetric(horizontal: spacing_middle),
                      ),
                    ],
                  ).paddingSymmetric(horizontal: spacing_middle),
                ).paddingTop(spacing_middle),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    text(value.cartList[0]["shopId"]["title"].toString(),
                            fontSize: textSizeLargeMedium,
                            fontWeight: FontWeight.w600)
                        .paddingTop(spacing_twinty),
                    ListView.builder(
                      itemCount: userViewModel.cartList.length,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        color: black.withOpacity(0.07),
                                        blurRadius: 24,
                                        offset: const Offset(0, 4))
                                  ]),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      alignment: Alignment.center,
                                      userViewModel.cartList[index]["images"][0]
                                          .toString(),
                                      height: orientation ==
                                              Orientation.portrait
                                          ? MediaQuery.of(context).size.height *
                                              0.078
                                          : MediaQuery.of(context).size.height *
                                              0.2,
                                      width: orientation == Orientation.portrait
                                          ? MediaQuery.of(context).size.width *
                                              0.2
                                          : MediaQuery.of(context).size.height *
                                              0.2,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Image.asset(placeholderProduct,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.078,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.2,
                                                  fit: BoxFit.cover),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        text(
                                            value.cartList[index]["name"]
                                                .toString(),
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: textSizeMedium,
                                            fontWeight: FontWeight.w600),
                                        text(
                                                value.cartList[index]["type"]
                                                    .toString(),
                                                fontSize: textSizeSmall,
                                                fontWeight: FontWeight.w400)
                                            .paddingTop(5),
                                        text(
                                                value.cartList[index]
                                                        ['quantity']
                                                    .toString(),
                                                fontSize: textSizeSmall,
                                                fontWeight: FontWeight.w400)
                                            .paddingTop(5),
                                      ],
                                    ).paddingLeft(spacing_middle),
                                  ),
                                  // const Spacer(),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      text(
                                          "N ${value.cartList[index]["price"].toString()}",
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: textSizeSMedium,
                                          fontWeight: FontWeight.w600,
                                          color: textcolorSecondary),
                                      Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              if (value.cartList[index]
                                                      ['quantity'] >
                                                  1) {
                                                value.cartList[index]
                                                    ['quantity']--;
                                                value.updateCartPrices();
                                              }
                                            },
                                            child: Container(
                                              height: 20,
                                              width: 20,
                                              decoration: BoxDecoration(
                                                  color: colorPrimary
                                                      .withOpacity(0.7),
                                                  borderRadius:
                                                      BorderRadius.circular(4)),
                                              child: const Icon(
                                                Icons.remove,
                                                color: white,
                                                size: 15,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          text(value.cartList[index]['quantity']
                                              .toString()),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              value.cartList[index]
                                                  ['quantity']++;
                                              value.updateCartPrices();
                                            },
                                            child: Container(
                                              height: 20,
                                              width: 20,
                                              decoration: BoxDecoration(
                                                  color: colorPrimary,
                                                  borderRadius:
                                                      BorderRadius.circular(4)),
                                              child: const Icon(
                                                Icons.add,
                                                color: white,
                                                size: 15,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ).paddingSymmetric(
                                  horizontal: spacing_middle,
                                  vertical: spacing_twinty),
                            ).paddingTop(spacing_twinty),
                            Positioned(
                                top: spacing_twinty,
                                right: 5,
                                child: InkWell(
                                    onTap: () {
                                      value.removeFromCart(index);
                                      setState(() {});
                                      userViewModel.updateCartPrices();

                                      // if (kDebugMode) {
                                      //   print("cartlength ${userViewModel.cartList.length}");
                                      // }
                                    },
                                    child: const Icon(
                                      Icons.close,
                                      color: dissmisable_RedColor,
                                    ))),
                          ],
                        );
                      },
                    ),
                    text("use Points:",
                            fontSize: textSizeMedium,
                            fontWeight: FontWeight.w600)
                        .paddingTop(spacing_thirty),
                    userViewModel.userPrestigePoint.toString().toDouble() >=
                            value.pointFormulaEarnPoint["pointsEarned"]
                                .toString()
                                .toDouble()
                        ? TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                hintText: "Use Points"),
                            onChanged: (val) {
                              pointvalue = val.toDouble();
                              if (val.isEmpty) {
                                calculatedCash = null;
                                pointvalue = null;
                              }
                              calculateCash(
                                  value.totalCartNira.toString().toDouble(),
                                  value.redemptionPointsN.toString().toDouble(),
                                  pointvalue.toString().toDouble());
                              setState(() {});
                              // print("totalCartNira ${pointvalue}");
                            },
                          ).paddingTop(spacing_middle)
                        : const SizedBox(),
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: colorPrimary),
                          boxShadow: [
                            BoxShadow(
                                color:
                                    const Color(0xff252525).withOpacity(0.11),
                                blurRadius: 15,
                                offset: const Offset(0, 4))
                          ]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              text("Pay In Cash",
                                  // userViewModel.userPrestigePoint.toString(),
                                  color: colorPrimary,
                                  fontSize: textSizeMedium,
                                  fontWeight: FontWeight.w600),
                              const SizedBox(
                                width: 5,
                              ),
                              Image.asset(
                                coin2,
                                height: 20,
                              ),
                            ],
                          ),
                          Container(
                            alignment: Alignment.center,
                            height: 29,
                            decoration: BoxDecoration(
                                color: textcolorSecondary,
                                borderRadius: BorderRadius.circular(6)),
                            child: text(
                                    "N ${ammoutFormatter((calculatedCash is double ? calculatedCash : double.tryParse(calculatedCash.toString()))?.toInt() ?? 0)}",
                                    fontSize: textSizeSMedium,
                                    fontWeight: FontWeight.w600)
                                .paddingSymmetric(horizontal: spacing_middle),
                          ),
                        ],
                      ).paddingSymmetric(horizontal: spacing_middle),
                    ).paddingTop(spacing_middle),
                    text(Checkoutscreen_Billing,
                            fontSize: textSizeMedium,
                            fontWeight: FontWeight.w600)
                        .paddingTop(spacing_thirty),
                    Container(
                      decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                color:
                                    const Color(0xff252525).withOpacity(0.11),
                                blurRadius: 15,
                                offset: const Offset(0, 4))
                          ]),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
                          CustomBillingRow(
                            text0: "Number of Items",
                            text1: value.cartList.length.toString(),
                          ),
                          const SizedBox(
                            height: spacing_middle,
                          ),
                          CustomBillingRow(
                            text0: "Bill",
                            text1: "",
                          ),
                          const SizedBox(
                            height: spacing_middle,
                          ),
                          CustomBillingRow(
                            text0: "Service Tax",
                            text1: "",
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          CustomBillingRow(
                            text0: Checkoutscreen_special,
                            text1: "",
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          CustomBillingRow(
                            text0: Checkoutscreen_coin,
                            text1: "",
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const Divider(
                            indent: 10,
                            endIndent: 10,
                          ),
                          CustomBillingRow(
                              text0: Checkoutscreen_total,
                              text1:
                                  "N ${value.totalCartNira.toString().toInt()}",
                              titleColor: colorPrimary,
                              traillingColor: colorPrimary,
                              trallingFontWeight: FontWeight.w600,
                              leadingFontWeight: FontWeight.w600)
                        ],
                      ).paddingSymmetric(vertical: spacing_middle),
                    ).paddingTop(10),
                  ],
                ).paddingSymmetric(vertical: 10),
                SizedBox(
                  height: 70,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Map<String, dynamic> data = {
                        "userId": userViewModel.userId.toString(),
                        "receiver_phone": userViewModel.userContact.toString(),
                        "receiver_Email": userViewModel.userEmail.toString(),
                        "receiver_Name": userViewModel.userName.toString(),
                        "items": [
                          for (int index = 0;
                              index < userViewModel.cartList.length;
                              index++) ...[
                            {
                              "productId": userViewModel.cartList[index]["_id"]
                                  .toString(),
                              "quantity": userViewModel.cartList[index]
                                  ['quantity'],
                              "type": userViewModel.cartList[index]["type"]
                                  .toString(),
                              "categoryId": userViewModel.cartList[index]
                                      ["category"]
                                  .toString(),
                              "name": userViewModel.cartList[index]["name"]
                                  .toString(),
                              "basePrice": userViewModel.cartList[index]
                                  ["price"],
                              "image": userViewModel.cartList[index]["images"]
                                      [0]
                                  .toString(),
                              "description": userViewModel.cartList[index]
                                      ["description"]
                                  .toString(),
                              "shopId": userViewModel.cartList[index]["shopId"]
                                      ["_id"]
                                  .toString()
                            },
                          ]
                        ],
                        "totalPrice": userViewModel.totalCartNira,
                        "orderStatus": "PENDING",
                        "orderHistory": [],
                        "PaymentHistory": [],
                        "orderType": "apporder",
                        "point": pointvalue ?? 0,
                        "cash": calculatedCash ?? value.totalCartNira,
                        "paymentMethod":
                            calculatedCash == null ? "cash" : "cashpoint"
                      };
                      // print('placeOrderAPI: $data');
                      // print('calculatedCash: $calculatedCash');
                      // print('pointvalue: $pointvalue');
                      HomeViewModel().placeOrderAPI(data, context);
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: colorPrimary),
                    child: text(Checkoutscreen_conform,
                        color: white,
                        fontSize: textSizeMedium,
                        fontWeight: FontWeight.w600),
                  ).paddingTop(20),
                ),
              ],
            ).paddingSymmetric(horizontal: 15, vertical: 10);
          },
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class CustomBillingRow extends StatelessWidget {
  String? text0, text1;
  Color? titleColor, traillingColor;
  dynamic trallingFontWeight, leadingFontWeight;

  CustomBillingRow({
    this.traillingColor,
    this.text0,
    this.text1,
    this.titleColor,
    this.trallingFontWeight = FontWeight.w500,
    this.leadingFontWeight = FontWeight.w400,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        text(text0.toString(),
            fontSize: textSizeSMedium,
            color: titleColor,
            fontWeight: leadingFontWeight),
        text(text1.toString(),
            fontSize: textSizeSMedium,
            fontWeight: trallingFontWeight,
            color: traillingColor)
      ],
    ).paddingSymmetric(horizontal: spacing_middle);
  }
}
