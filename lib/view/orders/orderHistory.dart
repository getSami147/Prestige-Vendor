import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prestige_vender/utils/Images.dart';
import 'package:prestige_vender/utils/colors.dart';
import 'package:prestige_vender/utils/constant.dart';
import 'package:prestige_vender/utils/widget.dart';
import 'package:prestige_vender/view/orders/orderDetailsScreen.dart';
import 'package:prestige_vender/view/searchScreens/orderSearch.dart';
import 'package:prestige_vender/viewModel/homeViewModel.dart';
import 'package:prestige_vender/viewModel/searchProvider.dart';
import 'package:provider/provider.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen>
    with TickerProviderStateMixin {
  final tabbarlist = [
    "Pending Orders",
    "Processing Orders",
    "Canceled Orders",
    "Read For Pickup",
    "Completed Orders",
  ];
  ScrollController scrollController = ScrollController();
  int page = 1;

  @override
  void initState() {
    // Delay the call to Provider.of until after the widget has been fully initialized
    var homeViewModel = Provider.of<HomeViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      homeViewModel.setPageloading(true);
      homeViewModel.shopByVendor(context).then((value) => {
            homeViewModel.getOrdersByShop(page, context),
          });
    });
    // Fetch initial data
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        // When the user reaches the end of the list, load more data
          page++;
          print("page++: ${page++}");
          homeViewModel.getOrdersByShop(page, context); // Fetch next page
       
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("object");
    TabController control =
        TabController(length: tabbarlist.length, vsync: this);
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: black),
          title: text("Order History",
              fontSize:textSizeLarge, fontWeight: FontWeight.w700),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.shopping_cart_outlined,size: 24,))
                .paddingRight(5)
          ],
        ),
        body: Consumer<HomeViewModel>(builder: (context, viewModel, child) {
          List data = viewModel.ordersbyUser;
           // Sort the list in descending order by createdAt field
          data.sort((a, b) {
            DateTime dateA = DateTime.parse(a["createdAt"]);
            DateTime dateB = DateTime.parse(b["createdAt"]);
            return dateB.compareTo(dateA); // For descending order
          });

          if (viewModel.pageloading&&data.isEmpty) {
            return const CustomLoadingIndicator();
          } else if (data.isEmpty) {
            return const Center(child: Text("No order found against your shop"));
          } else {
            //PENDING
            List<dynamic> pendingOrders = viewModel.ordersbyUser
                .where((e) => e['orderStatus'] == 'PENDING')
                .toList();
            //PROCESSING
            var processingOrders = viewModel.ordersbyUser
                .where((e) => e['orderStatus'] == 'PROCESSING')
                .toList();
            //CANCELED
            var canceledOrders = viewModel.ordersbyUser
                .where((e) => e['orderStatus'] == 'CANCELED')
                .toList();
            //pickup
            var pickupOrders = viewModel.ordersbyUser
                .where((e) => e['orderStatus'] == 'pickup')
                .toList();
            //completed
            var completedOrders = viewModel.ordersbyUser
                .where((e) => e['orderStatus'] == 'completed')
                .toList();
            return  Column(
                    children: [
                      InkWell(
                  onTap: () {
            var searchProvider = Provider.of<SearchProvider>(context,listen: false);     
                   const OrderSearch().launch(context).then((value) {
                      searchProvider.searchedOrders.clear();

                   });
                  },
                  child: Container(
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
                      children: [
                        const Icon(
                          Icons.search,
                          size: 20.0,
                        ),
                        text("Search here...").paddingLeft(spacing_middle)
                      ],
                    ).paddingAll(15),
                  )).paddingSymmetric(horizontal: spacing_standard_new),
                      SizedBox(
                        height: 20.h,
                      ),
                      DefaultTabController(
                          length: tabbarlist.length,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TabBar(
                                  isScrollable: true,
                                  physics: const BouncingScrollPhysics(),
                                  padding: const EdgeInsets.only(
                                    right: 10,
                                  ),
                                  controller: control,
                                  dividerHeight: 0,
                                  indicatorSize: TabBarIndicatorSize.tab,
                                  labelColor: Colors.white,
                                  unselectedLabelColor: const Color(0xff747688),
                                  indicator: BoxDecoration(
                                    color: colorPrimary,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  tabs: [
                                    for (int i = 0;
                                        i < tabbarlist.length;
                                        i++) ...[
                                      Tab(
                                        text: tabbarlist[i].toString(),
                                      )
                                    ]
                                  ])
                            ],
                          )),
                      Expanded(
                          child: TabBarView(
                              physics: const BouncingScrollPhysics(),
                              controller: control,
                              children: [
                            pendingOrders.isEmpty ||
                                    pendingOrders.isEmpty == null
                                ? const Center(child: Text("No Pending Orders"))
                                : SingleChildScrollView(
                                    controller: scrollController,
                                    physics: const BouncingScrollPhysics(),
                                    child: Column(
                                      children: [
                                        ListView.builder(
                                          itemCount: pendingOrders.length,
                                          shrinkWrap: true,
                                          physics:
                                              const BouncingScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                              onTap: () {
                                                // view Details
                                                Orderdetailscreen(
                                                        id: pendingOrders[index]
                                                                ["_id"]
                                                            .toString())
                                                    .launch(context,
                                                        pageRouteAnimation:
                                                            PageRouteAnimation
                                                                .Fade);
                                              },
                                              child: Customorder(
                                                startTrialing: "cancled",
                                                onTapStartTrialing: () {
                                                  // Cancling the order
                                                  Map<String, String> data = {
                                                    "orderStatus": "CANCELED"
                                                  };
                                                  HomeViewModel()
                                                      .updateOrderStatus(
                                                          data,
                                                          pendingOrders[index]
                                                                  ["_id"]
                                                              .toString(),
                                                          context);
                                                },
                                                onTapEndTrialing: () {
                                                  // accept
                                                  Map<String, String> data = {
                                                    "orderStatus": "PROCESSING"
                                                  };
                                                  HomeViewModel()
                                                      .updateOrderStatus(
                                                          data,
                                                          pendingOrders[index]
                                                                  ["_id"]
                                                              .toString(),
                                                          context)
                                                      .then((value) => (value) {
                                                            //   setState(() {

                                                            // });
                                                          });
                                                },
                                                image: pending,
                                                title: pendingOrders[index]
                                                        ["orderNo"]
                                                    .toString(),
                                                subTitle: DateFormat(
                                                        "yMMMMEEEEd")
                                                    .format(DateTime.parse(
                                                        pendingOrders[index]
                                                                ["createdAt"]
                                                            .toString())),
                                                endTrialing: "Accept",
                                              ),
                                            );
                                          },
                                        ).paddingSymmetric(horizontal: 15),
                                        if (page!=1&& viewModel.pageloading )
                                          const CircularProgressIndicator()
                                              .paddingTop(spacing_middle)
                                      ],
                                    ),
                                  ),
                            //processing Orders ......................................................>>>
                            processingOrders.isEmpty
                                ? const Center(
                                    child: Text("No Processing  Orders"))
                                : SingleChildScrollView(
                                    physics: const BouncingScrollPhysics(),
                                    controller: scrollController,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: processingOrders.length,
                                      // +
                                      //     (viewModel.orderloading ? 1 : 0),
                                      physics: const BouncingScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () {
                                            // view Details
                                            Orderdetailscreen(
                                                    id: processingOrders[index]
                                                            ["_id"]
                                                        .toString())
                                                .launch(context,
                                                    pageRouteAnimation:
                                                        PageRouteAnimation
                                                            .Fade);
                                          },
                                          child: Customorder(
                                            onTapEndTrialing: () {
                                              // accept
                                              Map<String, String> data = {
                                                "orderStatus": "pickup"
                                              };
                                              HomeViewModel().updateOrderStatus(
                                                  data,
                                                  processingOrders[index]["_id"]
                                                      .toString(),
                                                  context);
                                            },
                                            image: complete,
                                            title: processingOrders[index]
                                                    ["orderNo"]
                                                .toString(),
                                            subTitle: DateFormat("yMMMMEEEEd")
                                                .format(DateTime.parse(
                                                    processingOrders[index]
                                                            ["createdAt"]
                                                        .toString())),
                                            endTrialing: "accept",
                                          ),
                                        );
                                      },
                                    ).paddingSymmetric(horizontal: 15),
                                  ),

                            //Canceled Orders......................................................>>>
                            canceledOrders.isEmpty
                                ? const Center(
                                    child: Text("No Canceled Orders"))
                                : SingleChildScrollView(
                                    physics: const BouncingScrollPhysics(),
                                    controller: scrollController,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: canceledOrders.length,
                                      // +
                                      //     (viewModel.orderloading ? 1 : 0),
                                      physics: const BouncingScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () {
                                            // view Details
                                            Orderdetailscreen(
                                                    id: canceledOrders[index]
                                                            ["_id"]
                                                        .toString())
                                                .launch(context,
                                                    pageRouteAnimation:
                                                        PageRouteAnimation
                                                            .Fade);
                                          },
                                          child: Customorder(
                                            onTapEndTrialing: () {},
                                            image: complete,
                                            title: canceledOrders[index]
                                                    ["orderNo"]
                                                .toString(),
                                            subTitle: DateFormat("yMMMMEEEEd")
                                                .format(DateTime.parse(
                                                    canceledOrders[index]
                                                            ["createdAt"]
                                                        .toString())),
                                                        
                                            
                                          ),
                                        );
                                      },
                                    ).paddingSymmetric(horizontal: 15),
                                  ),

                            //ReadForPickup Orders......................................................>>>
                            pickupOrders.isEmpty
                                ? const Center(child: Text("No pickup Orders"))
                                : SingleChildScrollView(
                                    physics: const BouncingScrollPhysics(),
                                    controller: scrollController,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: pickupOrders.length,
                                      physics: const BouncingScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () {
                                            // view Details
                                            Orderdetailscreen(
                                                    id: pickupOrders[index]
                                                            ["_id"]
                                                        .toString())
                                                .launch(context,
                                                    pageRouteAnimation:
                                                        PageRouteAnimation
                                                            .Fade);
                                          },
                                          child: Customorder(
                                            onTapEndTrialing: () {
                                              // accept
                                              Map<String, String> data = {
                                                "orderStatus": "completed"
                                              };
                                              HomeViewModel().updateOrderStatus(
                                                  data,
                                                  pickupOrders[index]["_id"]
                                                      .toString(),
                                                  context);
                                            },
                                            image: complete,
                                            title: pickupOrders[index]
                                                    ["orderNo"]
                                                .toString(),
                                            subTitle: DateFormat("yMMMMEEEEd")
                                                .format(DateTime.parse(
                                                    pickupOrders[index]
                                                            ["createdAt"]
                                                        .toString())),
                                            endTrialing: "accept",
                                          ),
                                        );
                                      },
                                    ).paddingSymmetric(horizontal: 15),
                                  ),
                            //completedOrders......................................................>>>
                            completedOrders.isEmpty
                                ? const Center(
                                    child: Text("No Completed Orders"))
                                : SingleChildScrollView(
                                    physics: const BouncingScrollPhysics(),
                                    controller: scrollController,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: completedOrders.length,
                                      // +
                                      //     (viewModel.orderloading ? 1 : 0),
                                      physics: const BouncingScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () {
                                            // view Details
                                            Orderdetailscreen(
                                                    id: completedOrders[index]
                                                            ["_id"]
                                                        .toString())
                                                .launch(context,
                                                    pageRouteAnimation:
                                                        PageRouteAnimation
                                                            .Fade);
                                          },
                                          child: Customorder(
                                            onTapEndTrialing: () {},
                                            image: complete,
                                            title: completedOrders[index]
                                                    ["orderNo"]
                                                .toString(),
                                            subTitle: DateFormat("yMMMMEEEEd")
                                                .format(DateTime.parse(
                                                    completedOrders[index]
                                                            ["createdAt"]
                                                        .toString())),
                                            
                                          ),
                                        );
                                      },
                                    ).paddingSymmetric(horizontal: 15),
                                  )
                          ]))
                    ],
                  );
          }
        }));
  }
}

// ignore: must_be_immutable
class Customorder extends StatelessWidget {
  String? image, title, subTitle, startTrialing, endTrialing;
  VoidCallback? onTapEndTrialing;
  VoidCallback? onTapStartTrialing;

  Customorder({
    this.image,
    this.title,
    this.subTitle,
    this.startTrialing,
    this.onTapStartTrialing,
    this.endTrialing,
    required this.onTapEndTrialing,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
            decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      color: black.withOpacity(0.07),
                      blurRadius: 24,
                      offset: const Offset(0, 4))
                ]),
            child: Row(mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Image.asset(
                                        image.toString(),
                                        fit: BoxFit.cover,
                                        height: 50,width: 60,
                                      ),
                      Flexible(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            text(title,
                                isLongText: true,
                                fontSize: 13.0,
                                fontWeight: FontWeight.w600),
                            text(subTitle,
                                isLongText: true,
                                fontSize: textSizeSmall,
                                fontWeight: FontWeight.w400,
                                color: textcolorSecondary)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                     startTrialing == null? const SizedBox():  InkWell(
                            onTap: onTapStartTrialing,
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: unselectedcontainer,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: text(startTrialing.toString(),
                                      fontSize:textSizeSmall,
                                      fontWeight: FontWeight.w600,
                                      color: colorPrimary)
                                  .paddingSymmetric(horizontal: 10, vertical: 8),
                            )),
                      endTrialing==null?SizedBox():InkWell(
                    onTap: onTapEndTrialing,
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: colorPrimary,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: text(endTrialing,
                              fontSize:textSizeSmall,
                              fontWeight: FontWeight.w600,
                              color: white)
                          .paddingSymmetric(horizontal: 10, vertical: 8),
                    )).paddingLeft(spacing_standard_new)
                      ],
                    ).paddingLeft(spacing_middle),
               
              ],
            ).paddingSymmetric(horizontal: 10, vertical: 10))
        .paddingTop(10);
  }
}
