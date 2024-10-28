import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prestige_vender/models/getShopModel.dart';
import 'package:prestige_vender/utils/Images.dart';
import 'package:prestige_vender/utils/colors.dart';
import 'package:prestige_vender/utils/constant.dart';
import 'package:prestige_vender/utils/string.dart';
import 'package:prestige_vender/utils/widget.dart';
import 'package:prestige_vender/view/GoogleMap/googleMapScreen.dart';
import 'package:prestige_vender/view/products/createProduct.dart';
import 'package:prestige_vender/view/store/createStore.dart';
import 'package:prestige_vender/view/products/productDetail.dart';
import 'package:prestige_vender/view/store/updateStore.dart';
import 'package:prestige_vender/viewModel/homeViewModel.dart';
import 'package:provider/provider.dart';

class StoreDetailScreen extends StatefulWidget {
  StoreDetailScreen({super.key});

  @override
  State<StoreDetailScreen> createState() => _StoreDetailScreenState();
}

class _StoreDetailScreenState extends State<StoreDetailScreen> {
  ScrollController scrollController = ScrollController();
  int page = 1;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return; // Check if the widget is still mounted

      var homeViewModel = Provider.of<HomeViewModel>(context, listen: false);
      homeViewModel.setPageloading(true);
      homeViewModel.shopByVendor(context).then((value) {
        if (mounted) {
          // Check if the widget is still mounted
          homeViewModel.getAllProducts(page, context);
        }
      });

      scrollController.addListener(() {
        if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {
          // if (page != 1 && !homeViewModel.pageloading) {
          page++;
          if (mounted) {
            // Check if the widget is still mounted
            homeViewModel.getAllProducts(page, context);
            // }
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
          iconTheme: const IconThemeData(color: black),
          title: text(StoredtailScreen_Store,
              overflow: TextOverflow.ellipsis,
              fontSize: textSizeLarge,
              fontWeight: FontWeight.w700)),
      body: FutureBuilder(
        future: HomeViewModel().shopByVendor(context),
        builder: (context, AsyncSnapshot<GetShopModel?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child:
                    const CustomLoadingIndicator().paddingTop(spacing_middle));
          } else if (snapshot.hasError) {
            if (snapshot.error.toString().contains("no shop")) {
              return _buildNoShopUI(size, "Oops!You haven't any shope.",
                  "Before anything else, you'll need to create a shop.", true);
            } else {
              return Center(
                  child: Flexible(
                child: text(snapshot.error.toString(), maxLine: 10)
                    .paddingSymmetric(horizontal: spacing_twinty),
              ));
            }
          } else {
            if (snapshot.data!=null) {
            var shopdata = snapshot.data?.shop;
            var images, logo, title, des;
            if (shopdata!.coverImage!.isNotEmpty) {
              images = shopdata.coverImage![0];
            }
            if (shopdata.logo!.isNotEmpty) {
              logo = shopdata.logo![0];
            }
            title = shopdata.title;
            des = shopdata.description;
            var provider = Provider.of<HomeViewModel>(context, listen: false);
            provider.myShopId = shopdata.id.toString();
            return shopdata.status != "pending"
                ? SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildShopHeader(context, size, shopdata, images, logo),
                        _buildShopDetails(context, title, des, shopdata),
                        _buildProductsSection(
                          context,
                          shopdata,
                        ),
                      ],
                    ),
                  )
                : _buildNoShopUI(
                    size,
                    "Pending by admin approval",
                    "Your shop has been created successfully, but it is pending approval by the admin.",
                    false);
         
            }else{
              return text("text");
            }
          }
        },
      ).paddingSymmetric(horizontal: 15),
    );
  }

  Widget _buildNoShopUI(Size size, var title, var subTitle, bool isButton) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          noShop,
          height: size.height * 0.3,
          width: size.height * 0.3,
          fit: BoxFit.cover,
        ).paddingTop(spacing_thirty),
        Center(
            child: Flexible(
          child: text(title.toString(),
                  fontSize: textSizeNormal,
                  fontWeight: FontWeight.w500,
                  isCentered: true,
                  maxLine: 10)
              .paddingSymmetric(horizontal: spacing_twinty),
        )).paddingTop(spacing_twinty),
        Flexible(
          child: text(subTitle.toString(), isCentered: true, maxLine: 10),
        ),
        isButton == true
            ? elevatedButton(
                context,
                onPress: () {
                  const CreateStore().launch(context);
                },
                child: text("Create Shop", color: white),
              ).paddingTop(spacingBig)
            : const SizedBox(),
      ],
    );
  }

  Widget _buildShopHeader(
      BuildContext context, Size size, Shop shopdata, var images, var logo) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topRight,
      children: [
        // Shop Banner
        SizedBox(
          height: size.width * 0.5,
          width: size.width,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                images,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    placeholderProduct,
                    height: size.width * 0.5,
                    width: size.width,
                    fit: BoxFit.cover,
                  );
                },
              )),
        ),
        InkWell(
          onTap: () {
            UpdateStoreScreen(
              data: shopdata,
            ).launch(context, pageRouteAnimation: PageRouteAnimation.Fade);
          },
          child: Container(
              decoration: BoxDecoration(
                  color: colorPrimary.withOpacity(0.2), shape: BoxShape.circle),
              child: const Icon(
                Icons.edit_outlined,
                color: colorPrimary,
                size: 20,
              ).paddingAll(8)),
        ),
        // Shop Logo
        Positioned(
          bottom: -20,
          left: 10,
          child: CircleAvatar(
            radius: size.width * 0.086,
            backgroundColor: colorPrimary,
            child: SizedBox(
              height: size.width * 0.15,
              width: size.width * 0.15,
              child: ClipOval(
                  child: Image.network(
                logo,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    placeholderProduct,
                    height: size.width * 0.15,
                    width: size.width * 0.15,
                    fit: BoxFit.cover,
                  );
                },
              )),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildShopDetails(
      BuildContext context, var title, var des, Shop shopdata) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: text(title,
                  fontSize: textSizeMedium, overflow: TextOverflow.ellipsis),
            ),
            Container(
              height: 37,
              width: 37,
              decoration: BoxDecoration(
                  color: textcolorSecondary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(11)),
              child: IconButton(
                  onPressed: () {
                    GoogleMapScreen(
                      coordinates: shopdata.location!.coordinates!,
                      shopName: "Shop Location",
                    ).launch(context,
                        pageRouteAnimation: PageRouteAnimation.Fade);
                  },
                  icon: SvgPicture.asset(svg_current)),
            ),
          ],
        ).paddingTop(spacingBig),
        const Divider(
          thickness: 1,
          color: textcolorSecondary,
        ).paddingTop(5),
        text("About",
            fontSize: textSizeLargeMedium, fontWeight: FontWeight.w600),
        text(
          des,
          fontSize: textSizeSMedium,
          fontWeight: FontWeight.w400,
          maxLine: 10,
          isLongText: true,
        ),
        const Divider(
          thickness: 1,
          color: textcolorSecondary,
        ).paddingTop(5),
      ],
    );
  }

  Widget _buildProductsSection(
    BuildContext context,
    Shop shopdata,
  ) {
    var size = MediaQuery.sizeOf(context);
    return Consumer<HomeViewModel>(
      builder: (context, homeViewModel, child) {
        return Column(
          children: [
            InkWell(
              onTap: () {
                CreateProduct(shopId: shopdata.id.toString()).launch(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  text("Products",
                          fontSize: textSizeLargeMedium,
                          fontWeight: FontWeight.w600)
                      .paddingTop(spacing_middle),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: colorPrimary),
                    child: Center(
                      child: Row(
                        children: [
                          text("Upload Product",
                                  color: white, fontSize: textSizeSMedium)
                              .paddingRight(5),
                          const Icon(
                            Icons.add,
                            color: white,
                          )
                        ],
                      ).paddingSymmetric(
                          horizontal: spacing_middle, vertical: spacing_middle),
                    ),
                  ),
                ],
              ),
            ).paddingTop(spacing_twinty),
            page == 1 && homeViewModel.pageloading
                ? const Center(child: CustomLoadingIndicator())
                : homeViewModel.myProducts.isEmpty
                    ? SizedBox(
                        height:
                            size.height * 0.5, // Provide a constrained height
                        child: Center(
                            child:
                                text("No Products").paddingTop(spacing_twinty)),
                      )
                    : Column(
                        children: [
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount: homeViewModel.myProducts.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 10.w,
                              mainAxisSpacing: 10.h,
                              childAspectRatio: 3 / 4,
                            ),
                            itemBuilder: (context, index) {
                              var images =
                                  homeViewModel.myProducts[index]['images'];
                              // Check if images list is empty or null, and provide a placeholder if needed
                              var imageUrl = (images != null &&
                                      images.isNotEmpty)
                                  ? images[0]
                                  : "https://cdn.dribbble.com/users/3512533/screenshots/14168376/web_1280___8_4x.jpg"; // Placeholder image URL

                              return InkWell(
                                onTap: () {
                                  ProductDetailScreen(
                                    slug: homeViewModel.myProducts[index]
                                            ['slug']
                                        .toString(),
                                    id: homeViewModel.myProducts[index]['_id']
                                        .toString(),
                                    index: index,
                                  ).launch(context,
                                      pageRouteAnimation:
                                          PageRouteAnimation.Fade);
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 24,
                                            offset: const Offset(0, 4),
                                            spreadRadius: 0,
                                            color: const Color(0xff000000)
                                                .withOpacity(.1))
                                      ]),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                            imageUrl.toString(),
                                            fit: BoxFit.cover,
                                            height: size.height * 0.12,
                                            width: size.width,
                                            errorBuilder: (context, error,
                                                    stackTrace) =>
                                                Image.asset(
                                                  placeholderProduct,
                                                  fit: BoxFit.cover,
                                                  height: size.height * 0.12,
                                                  width: size.width,
                                                )),
                                      ),
                                      Flexible(
                                        child: text(
                                            isCentered: true,
                                            homeViewModel.myProducts[index]
                                                    ['name']
                                                .toString(),
                                            isLongText: true,
                                            fontSize: textSizeSmall,
                                            overflow: TextOverflow.ellipsis,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Flexible(
                                        child: text(
                                            "N ${ammoutFormatter(homeViewModel.myProducts[index]['price'])}",
                                            fontSize: textSizeSmall,
                                            overflow: TextOverflow.fade,
                                            fontWeight: FontWeight.w500,
                                            color: colorPrimary),
                                      ),
                                    ],
                                  ).paddingSymmetric(
                                      horizontal: spacing_middle),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: homeViewModel.pageloading ? 20 : 10),
                          if (page != 1 && homeViewModel.pageloading)
                            const CircularProgressIndicator(),
                          SizedBox(height: homeViewModel.pageloading ? 20 : 10),
                        ],
                      ).paddingTop(spacing_middle),
          ],
        );
      },
    );
  }
}
