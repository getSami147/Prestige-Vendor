import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prestige_vender/utils/Images.dart';
import 'package:prestige_vender/utils/colors.dart';
import 'package:prestige_vender/utils/constant.dart';
import 'package:prestige_vender/utils/string.dart';
import 'package:prestige_vender/utils/widget.dart';
import 'package:prestige_vender/view/GoogleMap/googleMapScreen.dart';
import 'package:prestige_vender/view/products/updateProduct.dart';
import 'package:prestige_vender/view/cart/mycart.dart';
import 'package:prestige_vender/viewModel/homeViewModel.dart';
import 'package:prestige_vender/viewModel/userViewModel.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatefulWidget {
  var slug,id;var index;
  ProductDetailScreen({required this.slug,required this.id,required this.index, super.key });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  void initState() {
    var userViewModel = Provider.of<UserViewModel>(context, listen: false);

    if (userViewModel.userId!=null) {
      HomeViewModel().getCurrentpointAPI(context, userViewModel.userId.toString()).then((value) {
  userViewModel.userPrestigePoint=value["currentPoint"];
  userViewModel.userCurrentNira=value["equivalenceNaira"].toString().toDouble();
      print("userPrestigePoint :${userViewModel.userPrestigePoint.toString()}");
      print("userCurrentNira :${value["equivalenceNaira"]}");

});
    }

    // TODO: implement initState
    super.initState();
  }
  @override
  var select = 0;
  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("Product Screen slug: ${widget.slug}");
      print("id: ${widget.id}");
    }
    var orientation = MediaQuery.of(context).orientation;
    var size = MediaQuery.sizeOf(context);
    var userViewModel = Provider.of<UserViewModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: black),
        title: text(ProductScreen_product,
            fontSize:textSizeLarge, fontWeight: FontWeight.w700),
        actions: [
       userViewModel.userId==null?   IconButton(
              onPressed: () {
                HomeViewModel().deleteproduct(widget.id.toString(),widget.index, context);
              },
              icon: const Icon(
                Icons.delete,
                color: redColor,
                size: 25,
              ).paddingRight(10.0)):IconButton(
              onPressed: () {
                const AddToCart().launch(context);
              },
              icon: const Icon(
                Icons.shopping_cart,
                color: colorPrimary,
                size: 25,
              ).paddingRight(10.0))
        ],
      ),
      body: FutureBuilder(
        future: HomeViewModel()
            .getSingalProducts(context, widget.slug),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child:
                    const CustomLoadingIndicator().paddingTop(spacing_middle));
          } else if (snapshot.hasError) {
            return Center(
                child: text(snapshot.error.toString(), maxLine: 10)
                    .paddingSymmetric(horizontal: spacing_twinty));
          } else if (!snapshot.hasData) {
            return Center(child: text("No Feature Products", maxLine: 10));
          } else {
            var data = snapshot.data;
            // ignore: prefer_typing_uninitialized_variables
            var images='https://cdn.dribbble.com/users/3512533/screenshots/14168376/web_1280___8_4x.jpg';
            for (var i = 0; i < data["images"].length; i++) {
              images = data["images"][i];
            }
          

            return
                // snapshot.data.isEmpty || featureData.isEmpty == null
                //     ? const Center(child: Text("No Feature Product"))
                //         .paddingSymmetric(vertical: spacing_twinty)
                //     :
                SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: orientation == Orientation.portrait
                        ? size.height * 0.33
                        : size.height * 0.48,
                    child: PageView.builder(
                      itemCount: 3,
                      onPageChanged: (value) {
                        userViewModel.selectedIndexMethod(value);
                      },
                      itemBuilder: (context, index) {
                        return Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Container(
                              width: double.infinity,
                              //height: MediaQuery.of(context).size.height * 0.2,
                              decoration: BoxDecoration(
                                  color: textcolorSecondary.withOpacity(0.4),
                                  borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20))),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(images,
                                        fit: orientation == Orientation.portrait
                                            ? BoxFit.cover
                                            : BoxFit.fill,
                                        height:
                                            orientation == Orientation.portrait
                                                ? size.height * 0.33
                                                : size.height * 0.3,
                                        width:
                                            orientation == Orientation.portrait
                                                ? size.width
                                                : size.width,errorBuilder:
                                        (context, error, stackTrace) =>
                                            Image.asset(
                                              placeholderProduct,
                                              height: size.height * 0.33,
                                              width: size.width,
                                              fit: BoxFit.cover,
                                            )),
                                  ),
                                ],
                              ),
                            ),
                          userViewModel.userId==null?    InkWell(
                                onTap: () {
                                  UpdateProductScreen(
                                    prouctData: data,
                                  ).launch(context,
                                      pageRouteAnimation:
                                          PageRouteAnimation.Fade);
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: colorPrimary.withOpacity(0.2),
                                        shape: BoxShape.circle),
                                    child: const Icon(
                                      Icons.edit_outlined,
                                      color: colorPrimary,
                                      size: 20,
                                    ).paddingAll(8)),
                              ):const SizedBox()
                          ],
                        );
                      },
                    ),
                  ),
                  Consumer<UserViewModel>(
                    builder: (context, value, child) {
                      return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (int i = 0; i < 3; i++) ...[
                              const SizedBox(
                                width: 5,
                              ),
                              Container(
                                height: 5,
                                width: value.selectedIndex == i ? 13 : 5,
                                decoration: BoxDecoration(
                                    color: value.selectedIndex == i
                                        ? colorPrimary
                                        : textcolorSecondary,
                                    borderRadius: BorderRadius.circular(8)),
                              )
                            ]
                          ]).paddingTop(8);
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: text(data["name"].toString(),
                            color: black,
                            fontSize: textSizeNormal,
                            fontWeight: FontWeight.w500),
                      ),
                      Flexible(
                        child: text("N ${ammoutFormatter(data["price"])}",
                            color: colorPrimary,
                            fontSize: textSizeMedium,
                            fontWeight: FontWeight.w600),
                      )
                    ],
                  ).paddingOnly(left: 6, right: 8, top: 10),
                 const Divider(
                    thickness: 1,
                    color: textcolorSecondary,
                    indent: 15,
                    endIndent: 15,
                  ).paddingTop(5),

                  
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: size.width * .09,
                              backgroundColor: colorPrimary,
                              child: ClipOval(
                                  child: Image.network(
                                data["shopId"]["coverImage"][0],
                                height: size.width * .16,
                                width: size.width * .16,
                                fit: BoxFit.cover,
                                errorBuilder:
                                            (context, error, stackTrace) =>
                                                Image.asset(
                                                  placeholderProduct,
                                                 height: size.width * .16,
                                width: size.width * .16,
                                fit: BoxFit.cover,
                                                )
                              )),
                            ),
                             Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            text(data["shopId"]["title"].toString(),
                                fontSize: textSizeLargeMedium),
                            text(data["shopId"]["address"].toString(),
                                fontSize: textSizeSmall,maxLine: 3)
                          ],
                        ).paddingOnly(left: 10, top: 10),
                      ),
                          ],
                        ),
                      ),
                     
                      // const Spacer(),
                      Container(
                        height: 37,
                        width: 37,
                        decoration: BoxDecoration(
                            color: textcolorSecondary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(11)),
                        child: IconButton(
                            onPressed: () {
                              GoogleMapScreen(
                                coordinates: data["shopId"]["location"]
                                    ["coordinates"],
                                shopName: data["shopId"]["title"].toString(),
                              ).launch(context,
                                  pageRouteAnimation:
                                      PageRouteAnimation.Fade);
                            },
                            icon: SvgPicture.asset(svg_current)),
                      ),
                    ],
                  ).paddingTop(5),
                  const Divider(
                    thickness: 1,
                    color: textcolorSecondary,
                    indent: 15,
                    endIndent: 15,
                  ).paddingTop(5),
                  text(
                    ProductScreen_about,
                    fontSize: textSizeLargeMedium,
                    fontWeight: FontWeight.w600,
                  ).paddingTop(10),
                  text(data["description"].toString(),
                      isLongText: true,
                      fontSize:textSizeSmall,
                      maxLine: 15,
                      fontWeight: FontWeight.w400,
                      color: textcolorSecondary),
              
              userViewModel.userId!=null?elevatedButton(
                    context,
                    backgroundColor: white,
                    bodersideColor: colorPrimary,
                    onPress: () {
                      if (data != null) {
                        if (userViewModel.cartList.isEmpty) {
                          // Adding a new key-value pair to the map
                          data["quantity"] = (0) + 1;
                          userViewModel.quantity = 1;
                          userViewModel.cartList.add(data);
                          Timer(const Duration(milliseconds: 200), () {
                            utils().toastMethod("Item added to cart");
                            const AddToCart().launch(context);
                          });
                        } else if (data["shopId"]["_id"].toString() !=
                            userViewModel.cartList[0]["shopId"]["_id"]
                                .toString()) {
                          utils().toastMethod(
                              "Add the Same Shope Products only");
                        } else if (data["_id"].toString() ==
                            userViewModel.cartList[0]["_id"].toString()) {
                          utils().toastMethod(
                              "This Product is already added.");
                        } else {
                          // Adding a new key-value pair to the map
                          data["quantity"] = (0) + 1;
                          userViewModel.quantity = 1;
                          userViewModel.cartList.add(data);
                          Timer(const Duration(milliseconds: 200), () {
                            utils().toastMethod("Item added to cart");
                            const AddToCart().launch(context);
                          });
                        }
                      }
                    },
                    child: text(ProductScreen_addcar,
                        color: colorPrimary),
                  ).paddingTop(spacingBig):const SizedBox(),
                ],
              ).paddingSymmetric(horizontal: 15, vertical: 10),
            );
          }
        },
      ),
    );
  }
}
