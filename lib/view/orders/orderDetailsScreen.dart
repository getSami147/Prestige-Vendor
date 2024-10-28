import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prestige_vender/utils/Images.dart';
import 'package:prestige_vender/utils/colors.dart';
import 'package:prestige_vender/utils/constant.dart';
import 'package:prestige_vender/utils/string.dart';
import 'package:prestige_vender/utils/widget.dart';
import 'package:prestige_vender/view/cart/checkout.dart';
import 'package:prestige_vender/viewModel/homeViewModel.dart';

class Orderdetailscreen extends StatefulWidget {
  String id;
  Orderdetailscreen({required this.id, super.key});

  @override
  State<Orderdetailscreen> createState() => _OrderdetailscreenState();
}

class _OrderdetailscreenState extends State<Orderdetailscreen> {
  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      appBar: AppBar(
        title: text(Ordrdetail_Order,
            fontSize: textSizeLarge, fontWeight: FontWeight.w700),
      ),
      body: FutureBuilder(
        future: HomeViewModel()
            .getSingalOrderDetails(context, widget.id.toString().trim()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child:
                    const CustomLoadingIndicator().paddingTop(spacing_middle));
          } else if (snapshot.hasError) {
            return Center(child: text(snapshot.error.toString(), maxLine: 10));
          } else if (!snapshot.hasData) {
            return Center(child: text("No order Details", maxLine: 10));
          } else {
            var data = snapshot.data;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      text(Ordrdetail_OrderID,
                          fontSize: textSizeNormal,
                          fontWeight: FontWeight.w600),
                      const SizedBox(
                        width: 5,
                      ),
                      text(data["orderNo"].toString(),
                          fontSize: textSizeNormal,
                          fontWeight: FontWeight.w600,
                          color: colorPrimary),
                    ],
                  ).paddingTop(10),
                  text(formatDateTime(data["createdAt"]).toString(),
                      fontSize: textSizeSMedium,
                      fontWeight: FontWeight.w400,
                      color: textcolorSecondary),
                  Divider(
                    indent: 10,
                    endIndent: 10,
                    color: textcolorSecondary.withOpacity(0.3),
                  ).paddingTop(10),

                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: data["items"].length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      var items = data["items"][index];
                      return Column(
                        children: [
                          Container(
                            height: orientation == Orientation.portrait
                                ? MediaQuery.of(context).size.height * 0.13
                                : MediaQuery.of(context).size.height * 0.29,
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
                                Image.network(items["image"].toString(),
                                    height: orientation == Orientation.portrait
                                        ? MediaQuery.of(context).size.height *
                                            0.08
                                        : MediaQuery.of(context).size.height *
                                            0.2,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Image.asset(
                                              placeholderProduct,
                                              height: orientation ==
                                                      Orientation.portrait
                                                  ? MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.08
                                                  : MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.2,
                                              fit: BoxFit.cover,
                                            )).paddingLeft(10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      text(items["name"].toString(),
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: textSizeMedium,
                                          fontWeight: FontWeight.w600),
                                      text(items["type"].toString(),
                                              fontSize: textSizeSmall,
                                              fontWeight: FontWeight.w400)
                                          .paddingTop(5),
                                      text(items["quantity"].toString(),
                                              fontSize: textSizeSmall,
                                              fontWeight: FontWeight.w400)
                                          .paddingTop(5),
                                    ],
                                  ).paddingOnly(left: 10, top: 15),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    text(
                                        "N ${ammoutFormatter(items["basePrice"].toString().toInt())}",
                                        fontSize: textSizeSMedium,
                                        fontWeight: FontWeight.w600,
                                        color: colorPrimary),
                                  ],
                                ).paddingRight(20)
                              ],
                            ),
                          ).paddingTop(10),
                        ],
                      );
                    },
                  ),
                  // customorderdetail().paddingTop(10),
                  text(Checkoutscreen_Billing,
                          fontSize: textSizeMedium, fontWeight: FontWeight.w600)
                      .paddingTop(10),
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
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
                        CustomBillingRow(
                          text0: Ordrdetail_customer,
                          text1: data["receiver_Name"].toString(),
                          titleColor: textcolorSecondary,
                        ),
                        CustomBillingRow(
                          text0: Ordrdetail_Used,
                          text1: ammoutFormatter(data["point"]),
                          titleColor: textcolorSecondary,
                        ),
                        CustomBillingRow(
                          text0: "payable Cash",
                          text1: ammoutFormatter(data["cash"]),
                          titleColor: textcolorSecondary,
                        ),
                        CustomBillingRow(
                          text0: Ordrdetail_Status,
                          text1: data["orderStatus"].toString(),
                          titleColor: textcolorSecondary,
                        ),
                        const Divider(
                          indent: 10,
                          endIndent: 10,
                        ),
                        CustomBillingRow(
                          text0: Checkoutscreen_total,
                          text1: "N ${ammoutFormatter(data["totalPrice"])}",
                          titleColor: colorPrimary,
                          traillingColor: colorPrimary,
                        )
                      ],
                    ).paddingAll(spacing_middle),
                  ).paddingTop(10),
                ],
              ).paddingSymmetric(horizontal: 15),
            );
          }
        },
      ),
    );
  }
}

class customorderdetail extends StatelessWidget {
  const customorderdetail({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        text(Checkoutscreen_Nain),
        Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: colorPrimary,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: black.withOpacity(0.07),
                    blurRadius: 24,
                    offset: const Offset(0, 4))
              ]),
          height: 23,
          width: 68,
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(
              Icons.track_changes,
              color: white,
              size: 15,
            ),
            text(Ordrdetail_Track,
                fontSize: textSizeSMedium,
                fontWeight: FontWeight.w600,
                color: white)
          ]),
        )
      ],
    );
  }
}
