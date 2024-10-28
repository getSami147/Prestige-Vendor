
// import 'package:flutter/material.dart';
// import 'package:nb_utils/nb_utils.dart';
// import 'package:prestige_vender/utils/colors.dart';
// import 'package:prestige_vender/utils/constant.dart';
// import 'package:prestige_vender/utils/widget.dart';
// import 'package:prestige_vender/view/categories/productdetail.dart';
// import 'package:prestige_vender/viewModel/homeViewModel.dart';
// import 'package:prestige_vender/viewModel/searchProvider.dart';
// import 'package:provider/provider.dart';

// class HomeSearch extends StatefulWidget {
//   const HomeSearch({super.key});

//   @override
//   _HomeSearchState createState() => _HomeSearchState();
// }

// class _HomeSearchState extends State<HomeSearch> {
//   ScrollController scrollController = ScrollController();
//   TextEditingController searchController = TextEditingController();

//   int page = 1;
//   @override
//   void initState() {
//     super.initState();
//     final searchProvider = Provider.of<SearchProvider>(context, listen: false);
//     final homeViewModel= Provider.of<HomeViewModel>(context, listen: false);

//     WidgetsBinding.instance.addPostFrameCallback((_) {

//     });
//     scrollController.addListener(() {
//       if (scrollController.position.pixels ==
//           scrollController.position.maxScrollExtent) {
//         // When the user reaches the end of the list, load more data
//         if (!searchProvider.pageloading) {
//           page++;
//           searchProvider.searchProducts(
//               page, searchController.text.trim().toString(),homeViewModel.myShopId);
//           // Fetch next page
//         }
//       }
//     });
//     searchProvider.searchedProducts.clear();
//   }

//   @override
//   void dispose() {
//     scrollController.removeListener(() {});
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.sizeOf(context);
//     final homeViewModel= Provider.of<HomeViewModel>(context, listen: false);

//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: const Text('Search'),
//       ),
//       body: Consumer<SearchProvider>(builder: (context, valueKey, child) {
//         return Stack(alignment: Alignment.center,
//           children: [
//             Column(
//               children: [
//                 Center(
//                   child: Container(
//                     height: 45,
//                     width: size.width,
//                     decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(10),
//                         boxShadow: [
//                           BoxShadow(
//                               color: Colors.grey.withOpacity(.1),
//                               spreadRadius: 5,
//                               blurRadius: 5)
//                         ]),
//                     child: Padding(
//                       padding: const EdgeInsets.only(left: 15),
//                       child: TextField(
//                         controller: searchController,
//                         onSubmitted: (value) {
//                           page = 1;
//                           valueKey.searchedProducts.clear();
//                           valueKey.searchProducts(
//                               page, searchController.text.trim(),homeViewModel.myShopId);
//                         },
//                         autofocus: true,
//                         cursorColor: colorPrimary,
//                         decoration: InputDecoration(
//                           hintText: 'Search',
//                           suffixIcon: Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 12),
//                             child: InkWell(
//                               onTap: () {
//                                 page = 1;
//                                 valueKey.searchedProducts.clear();
//                                 valueKey.searchProducts(
//                                     page, searchController.text.trim(),homeViewModel.myShopId);
//                               },
//                               child: const Icon(Icons.search),
//                             ),
//                           ),
//                           border: InputBorder.none,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                       valueKey.searchedProducts.isEmpty?text(""):
//                    Expanded(
//                   child: SingleChildScrollView(
//                     physics: const BouncingScrollPhysics(),
//                     child: LayoutBuilder(
//                       builder: (context, constraints) {
//                         double containerWidth = (constraints.maxWidth - 40) / 3;
//                         double containerHeight = containerWidth * 1.8;
//                         double imageHeight = containerHeight * 0.65;
//                         double imageWidth = containerWidth;
//                         return Column(
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               crossAxisAlignment: CrossAxisAlignment.end,
//                               children: [
//                                 text("Products",
//                                         fontWeight: FontWeight.w700,
//                                         color: black)
//                                     .paddingTop(spacing_twinty),
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     text("See All",
//                                             fontSize: textSizeSMedium,
//                                             color: colorPrimary,
//                                             fontWeight: FontWeight.w500)
//                                         .onTap(() {
//                                       page = 1;
//                                       valueKey.searchedProducts.clear();
//                                       valueKey.searchProducts(
//                                           page, searchController.text.trim(),homeViewModel.myShopId);
//                                     }),
//                                     const Icon(
//                                       Icons.arrow_forward,
//                                       size: 20,
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                             GridView.builder(
//                               gridDelegate:
//                                   SliverGridDelegateWithFixedCrossAxisCount(
//                                 crossAxisCount: 3,
//                                 crossAxisSpacing: 10,
//                                 mainAxisSpacing: 10,
//                                 childAspectRatio:
//                                     containerWidth / containerHeight,
//                               ),
//                               shrinkWrap: true,
//                               physics: const BouncingScrollPhysics(),
//                               itemCount: (valueKey.searchedProducts.length > 3
//                                   ? 3
//                                   : valueKey.searchedProducts.length),
//                               controller: scrollController,
//                               itemBuilder: (context, index) {
//                                 var searchData =
//                                     valueKey.searchedProducts[index];
//                                 return Container(
//                                     alignment: Alignment.center,
//                                     decoration: BoxDecoration(
//                                       color: Colors.white,
//                                       borderRadius: BorderRadius.circular(10),
//                                       boxShadow: [
//                                         BoxShadow(
//                                           color: colorPrimary.withOpacity(.1),
//                                           blurRadius: 7,
//                                           spreadRadius: 3,
//                                         ),
//                                       ],
//                                     ),
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         InkWell(
//                                           onTap: () {
//                                             ProductDetailScreen(
//                                               slug:
//                                                   searchData["slug"].toString(), id: null, index: null,
//                                             ).launch(context,
//                                                 pageRouteAnimation:
//                                                     PageRouteAnimation.Fade);
//                                           },
//                                           child: ClipRRect(
//                                             borderRadius:
//                                                 BorderRadius.circular(10),
//                                             child: Image.network(
//                                               searchData["images"][0]
//                                                   .toString(),
//                                               fit: BoxFit.cover,
//                                               height: imageHeight,
//                                               width: imageWidth,
//                                             ),
//                                           ),
//                                         ),
//                                         Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             text(
//                                               searchData["name"].toString(),
//                                               fontSize: textSizeSmall,
//                                               fontWeight: FontWeight.w700,
//                                             ).paddingTop(spacing_middle),
//                                             text(
//                                               "N ${ammoutFormatter(searchData["price"].toString().toInt())}",
//                                               fontSize: textSizeSMedium,
//                                               fontWeight: FontWeight.w700,
//                                               color: colorPrimary,
//                                             ),
//                                           ],
//                                         ).paddingSymmetric(
//                                           horizontal: 8,
//                                         ),
//                                       ],
//                                     )).paddingTop(spacing_twinty);
//                               },
//                             ),
//                           ],
//                         );
//                       },
//                     ).paddingSymmetric(horizontal: spacing_standard_new),
//                   ),
//                 ),
//               ],
//             ),
//         valueKey.pageloading?const CustomLoadingIndicator():  valueKey.searchedProducts.isEmpty&&valueKey.searchedCategories.isEmpty&&valueKey.searchedSubCategories.isEmpty?text("No Document found"):const SizedBox(),
          
//           ],
//         );
//       }),
//     );
//   }
// }
