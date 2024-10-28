import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prestige_vender/utils/Images.dart';
import 'package:prestige_vender/utils/colors.dart';
import 'package:prestige_vender/utils/constant.dart';
import 'package:prestige_vender/utils/widget.dart';
import 'package:prestige_vender/view/products/productDetail.dart';
import 'package:prestige_vender/view/dashboard/dashboard.dart';
import 'package:prestige_vender/view/cart/mycart.dart';
import 'package:prestige_vender/viewModel/homeViewModel.dart';
import 'package:prestige_vender/viewModel/categoryViewModel.dart';
import 'package:prestige_vender/viewModel/userViewModel.dart';
import 'package:provider/provider.dart';

class CatageriesScreen extends StatefulWidget {
  final String code;
  const CatageriesScreen({required this.code, super.key});

  @override
  State<CatageriesScreen> createState() => _CatageriesScreenState();
}

class _CatageriesScreenState extends State<CatageriesScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      HomeViewModel().shopByVendor(context);
    });
  }

  void sortJsonListByTitle(List<dynamic> list) {
    list.sort((a, b) => a['title'].compareTo(b['title']));
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
             Dashboard().launch(context);
          },
          child: const Icon(Icons.arrow_back),
        ),
        title: const Text('Scan Billing QR'),
        actions: [
          IconButton(
            onPressed: () {
              const AddToCart().launch(context);
            },
            icon: const Icon(Icons.shopping_cart),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future:
              HomeViewModel().userFindByPrestigeNumber(widget.code, context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                      child: const CustomLoadingIndicator()
                          .paddingTop(spacing_middle))
                  .paddingSymmetric(horizontal: spacing_twinty);
            } else if (snapshot.hasError) {
              return Center(
                      child: text(snapshot.error.toString(),
                          isCentered: true, maxLine: 10))
                  .paddingSymmetric(horizontal: spacing_twinty);
            } else if (!snapshot.hasData) {
              return Center(child: text("No user", maxLine: 10));
            } else {
              var prestigeUserData = snapshot.data;
              final userViewModel =
                  Provider.of<UserViewModel>(context, listen: false);
              userViewModel.userId = prestigeUserData["_id"].toString();
              userViewModel.userEmail = prestigeUserData["email"].toString();
              userViewModel.userName = prestigeUserData["name"].toString();
              userViewModel.userContact =
                  prestigeUserData["contact"].toString();

              return Column(
                children: [
                  // User Prestige Number
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: colorPrimary.withOpacity(0.13),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      leading: prestigeUserData["image"] == null ||
                              prestigeUserData["image"].isEmpty
                          ? ClipOval(
                              child: Image.asset(profileimage,
                                  height: 40, width: 40, fit: BoxFit.cover))
                          : ClipOval(
                              child: Image.network(
                                  prestigeUserData["image"].toString(),
                                  height: 40,
                                  width: 40,
                                  fit: BoxFit.cover,
                                   errorBuilder: (context, error, stackTrace) => Image.asset(placeholderProduct,height: 40,
                                  width: 40,
                                  fit: BoxFit.cover,)
                                  ,)
                                  ),
                      title: text(prestigeUserData["name"].toString(),
                          fontSize: textSizeNormal,
                          fontWeight: FontWeight.w500),
                      subtitle:
                          text(prestigeUserData["prestigeNumber"].toString()),
                    ).paddingSymmetric(horizontal: spacing_middle, vertical: 5),
                  ),
                  // Get Category API
                  FutureBuilder(
                    future: HomeViewModel().getcategoryapi(context),
                    builder: (context, snapshotcategory) {
                      if (snapshotcategory.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                                child: const CustomLoadingIndicator()
                                    .paddingTop(spacing_middle))
                            .paddingSymmetric(horizontal: spacing_twinty);
                      } else if (snapshotcategory.hasError) {
                        return Center(
                            child: text(snapshotcategory.error.toString(),
                                maxLine: 10));
                      } else if (!snapshotcategory.hasData) {
                        return Center(
                            child: text("No Categories", maxLine: 10));
                      } else {
                        return Column(
                          children: [
                            // Category
                            HorizontalList(
                              itemCount: snapshotcategory.data['data'].length,
                              itemBuilder: (context, indexCategory) {
                                return Consumer<CategoryViewModel>(builder:
                                    (context, categoryProvider, child) {
                                  if (indexCategory == 0 &&
                                      categoryProvider
                                          .selectedCategoryId.isEmpty) {
                                    categoryProvider.setCategory(
                                        snapshotcategory.data['data'][0]['_id']
                                            .toString(),
                                        0);
                                  }

                                  return SizedBox(
                                    width: size.width * 0.25,
                                    child: InkWell(
                                      onTap: () {
                                        categoryProvider.selectedSubCategoryId =
                                            "";
                                        categoryProvider.setCategory(
                                            snapshotcategory.data['data']
                                                    [indexCategory]['_id']
                                                .toString(),
                                            indexCategory);
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                ColorFiltered(
                                                  colorFilter: categoryProvider
                                                              .selectedCategoryIndex ==
                                                          indexCategory
                                                      ? ColorFilter.mode(
                                                          colorPrimary
                                                              .withOpacity(
                                                                  0.75),
                                                          BlendMode.srcATop)
                                                      : const ColorFilter.mode(
                                                          transparentColor,
                                                          BlendMode.srcATop),
                                                  child: Image.network(
                                                    snapshotcategory
                                                                .data['data']
                                                            [indexCategory]
                                                        ['image'],
                                                    scale: 1.0,
                                                    fit: BoxFit.fill,
                                                    height: size.height * 0.12,
                                                    width: size.width * 0.25,
                                                    errorBuilder: (context, error, stackTrace) => Image.asset(placeholderProduct, fit: BoxFit.fill,
                                                    height: size.height * 0.12,
                                                    width: size.width * 0.25,)
                                                  ),
                                                ),
                                                categoryProvider
                                                            .selectedCategoryIndex ==
                                                        indexCategory
                                                    ? const Icon(Icons.done,
                                                        color: Colors.white,
                                                        size: 25)
                                                    : const SizedBox(),
                                              ],
                                            ),
                                          ),
                                          text(
                                            snapshotcategory.data['data']
                                                    [indexCategory]['title']
                                                .toString(),
                                            fontSize: textSizeSMedium,
                                            overflow: TextOverflow.ellipsis,
                                            fontWeight: FontWeight.w500,
                                          ).paddingLeft(5),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                              },
                            ),
                            // Single Get Category
                            Consumer<CategoryViewModel>(
                                builder: (context, subcategoryvalue, child) {
                              return FutureBuilder(
                                future: HomeViewModel().singlegetcategory(
                                    context,
                                    subcategoryvalue.selectedCategoryId),
                                builder: (context, snapshotSubcategory) {
                                  if (snapshotSubcategory.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                            child:
                                                const CustomLoadingIndicator()
                                                    .paddingTop(spacing_middle))
                                        .paddingSymmetric(
                                            horizontal: spacing_twinty);
                                  } else if (snapshotSubcategory.hasError) {
                                    return Center(
                                            child: text(
                                                snapshotSubcategory.error
                                                    .toString(),
                                                maxLine: 10))
                                        .paddingSymmetric(
                                            vertical: spacing_twinty);
                                  } else if (!snapshotSubcategory.hasData) {
                                    return Center(
                                        child: text("No Subcategories",
                                            maxLine: 10));
                                  } else {
                                    print(
                                        "snapshotSubcategory: ${snapshotSubcategory
                                        .data['subCategory']}");

                                    if (snapshotSubcategory
                                        .data['subCategory'] != null) {
                                      dynamic subCategoryData =
                                          snapshotSubcategory
                                              .data['subCategory']
                                              .where((element) =>
                                                  element['categoryId'] ==
                                                  subcategoryvalue
                                                      .selectedCategoryId)
                                              .toList();
                                      sortJsonListByTitle(subCategoryData);

                                      dynamic productData = snapshotSubcategory
                                          .data['products']
                                          .where((element) =>
                                              element['shopId'] ==
                                              subcategoryvalue.myShopId)
                                          .toList();
                                      dynamic myProducts = productData
                                          .where((element) =>
                                              element['subCategory'] ==
                                              subcategoryvalue
                                                  .selectedSubCategoryId)
                                          .toList();

                                      if (subcategoryvalue
                                              .selectedSubCategoryId!.isEmpty &&
                                          subCategoryData.isNotEmpty) {
                                        subcategoryvalue.setSubCategory(
                                            subCategoryData[0]['_id']
                                                .toString(),
                                            0);
                                        myProducts = productData
                                            .where((element) =>
                                                element['subCategory'] ==
                                                subCategoryData[0]['_id'])
                                            .toList();
                                      }

                                      return Column(
                                        children: [
                                          HorizontalList(
                                            itemCount: subCategoryData.length,
                                            itemBuilder:
                                                (context, indexSubcategory) {
                                              debugPrint(
                                                  "subCategoryData:  $subCategoryData");

                                              return Column(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      subcategoryvalue
                                                          .setSubCategory(
                                                              subCategoryData[
                                                                          indexSubcategory]
                                                                      ['_id']
                                                                  .toString(),
                                                              indexSubcategory);
                                                    },
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8),
                                                      decoration: BoxDecoration(
                                                        color: subcategoryvalue
                                                                    .selectedSubCategoryIndex ==
                                                                indexSubcategory
                                                            ? colorPrimary
                                                            : white,
                                                        border: Border.all(
                                                            color: subcategoryvalue
                                                                        .selectedSubCategoryIndex ==
                                                                    indexSubcategory
                                                                ? colorPrimary
                                                                : colorPrimary),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                      child: text(
                                                          subCategoryData[
                                                                  indexSubcategory]
                                                              ['title'],
                                                          fontSize:
                                                              textSizeSMedium,
                                                          color: subcategoryvalue
                                                                      .selectedSubCategoryIndex ==
                                                                  indexSubcategory
                                                              ? white
                                                              : colorPrimary),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          ).paddingTop(spacing_middle),
                                          for (int i = 0;
                                              i < subCategoryData.length;
                                              i++)
                                            ListView.builder(
                                              itemCount: myProducts.length,
                                              shrinkWrap: true,
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              itemBuilder:
                                                  (context, indexProduct) {
                                                debugPrint(
                                                    "myProducts subCategoryId:  ${myProducts[indexProduct]['subCategory']}");
                                                debugPrint(
                                                    "subCategory id: ${subCategoryData[i]['_id']}");

                                                if (myProducts[indexProduct]
                                                        ['subCategory'] ==
                                                    subCategoryData[i]['_id']) {
                                                  return InkWell(
                                                    onTap: () {
                                                      ProductDetailScreen(
                                                              slug: myProducts[
                                                                          indexProduct]
                                                                      ['slug']
                                                                  .toString(),
                                                              id: myProducts[
                                                                          indexProduct]
                                                                      ['_id']
                                                                  .toString(),
                                                              index: 0)
                                                          .launch(context,
                                                              pageRouteAnimation:
                                                                  PageRouteAnimation
                                                                      .Fade);
                                                    },
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                        color: white,
                                                        boxShadow: [
                                                          BoxShadow(
                                                              color: black
                                                                  .withOpacity(
                                                                      0.06),
                                                              offset:
                                                                  const Offset(
                                                                      0, 4),
                                                              blurRadius: 24)
                                                        ],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      child: ListTile(
                                                        leading: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          child: Image.network(
                                                            myProducts[indexProduct]
                                                                    [
                                                                    'images'][0]
                                                                .toString(),
                                                            fit: BoxFit.cover,
                                                            height:
                                                                size.height *
                                                                    0.1,
                                                            width: size.width *
                                                                0.2,
                                                            scale: 1.0,
                                                             errorBuilder: (context, error, stackTrace) => Image.asset(placeholderProduct,  fit: BoxFit.cover,
                                                            height:
                                                                size.height *
                                                                    0.1,
                                                            width: size.width *
                                                                0.2,)
                                                          ),
                                                        ),
                                                        title: text(
                                                            myProducts[
                                                                    indexProduct]
                                                                ['name'],
                                                            fontSize:
                                                                textSizeMedium,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                        subtitle: text(
                                                            myProducts[
                                                                    indexProduct]
                                                                ['description'],
                                                            fontSize:
                                                                textSizeSmall,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color:
                                                                textGreyColor,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            isLongText: true),
                                                        trailing: text(
                                                            "N ${ammoutFormatter(myProducts[indexProduct]['price'])}",
                                                            fontSize:
                                                                textSizeMedium,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: colorPrimary,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis),
                                                      ),
                                                    ).paddingTop(15),
                                                  );
                                                } else {
                                                  return Container();
                                                }
                                              },
                                            ),
                                          if (subcategoryvalue
                                              .selectedSubCategoryId!.isEmpty)
                                            const Text("Select the Tab first")
                                          else if (myProducts.isEmpty)
                                            Center(
                                                child: text("No Products")
                                                    .paddingTop(
                                                        spacing_twinty)),
                                        ],
                                      );
                                    } else {
                                      return Center(
                                          child: text("No Subcategories",
                                              maxLine: 10));
                                    }
                                  }
                                },
                              );
                            }),
                          ],
                        );
                      }
                    },
                  ).paddingTop(spacing_twinty),
                ],
              );
            }
          },
        ).paddingSymmetric(horizontal: spacing_standard_new),
      ),
    );
  }
}
