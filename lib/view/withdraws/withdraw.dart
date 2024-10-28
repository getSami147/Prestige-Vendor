import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prestige_vender/utils/Images.dart';
import 'package:prestige_vender/utils/colors.dart';
import 'package:prestige_vender/utils/constant.dart';
import 'package:prestige_vender/utils/widget.dart';
import 'package:prestige_vender/viewModel/homeViewModel.dart';
import 'package:prestige_vender/viewModel/userViewModel.dart';
import 'package:provider/provider.dart';

class TotalWithdraw extends StatefulWidget {
  int initialIndex;
  String? title;
  List? totalList;
  TotalWithdraw(
      {this.title, this.totalList, required this.initialIndex, super.key});

  @override
  State<TotalWithdraw> createState() => _TotalWithdrawState();
}

class _TotalWithdrawState extends State<TotalWithdraw>
    with TickerProviderStateMixin {
  ScrollController scrollController = ScrollController();
  int page = 1;
  @override
  void initState() {
    var homeViewModel = Provider.of<HomeViewModel>(context, listen: false);
    var userViewModel = Provider.of<UserViewModel>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      homeViewModel.getAllPayment(page, context).then((value) {
   ///// GetAdmin Id
    var a;
    HomeViewModel().getAllUsers(context).then((value) => {
    a = value["data"].firstWhere((e)=>e["role"]=='admin'),
   userViewModel.adminId=a["_id"].toString(),
      // print(a)
    });
      },); // Fetch initial data
    });
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        // When the user reaches the end of the list, load more data
          page++;
          homeViewModel.getAllPayment(page, context); // Fetch next page
        
      }
    });
    // TODO: implement initState
    super.initState();
  }

  final tabbarlist = [
    "Total withdraw",
    "Withdrawal request",
    "Requested withdraw",
    "Total Paid",
    "Total payable",
    "requested payable",
  ];
  List<String> withdrawalpaymentsIds = [];
  List<String> payablePaymentsIds = [];

  // print('Withdrawal IDs: $ids');
// }
  @override
  Widget build(BuildContext context) {
    var userViewModel = Provider.of<UserViewModel>(context, listen: false);
    TabController control = TabController(
        length: tabbarlist.length,
        vsync: this,
        initialIndex: widget.initialIndex);

    return Scaffold(
      appBar: AppBar(
        title: text(widget.title, fontWeight: FontWeight.bold),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DefaultTabController(
              length: tabbarlist.length,
              child: Column(
                children: [
                  TabBar(
                     dividerHeight:0,
                      // padding: EdgeInsets.all(0),
                      isScrollable: true,
                      controller: control,
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelPadding: const EdgeInsets.only(right: 6),
                      labelColor: Colors.white,
                      unselectedLabelColor: const Color(0xff747688),
                      indicatorColor: Colors.pink,
                      indicator: BoxDecoration(
                        color: colorPrimary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      tabs: [
                        for (int i = 0; i < tabbarlist.length; i++) ...[
                          Flexible(
                            child: Tab(
                              text: tabbarlist[i].toString(),
                            ).paddingLeft(10),
                          )
                        ]
                      ])
                ],
              )).paddingTop(spacing_twinty),
          // CustomTextFormField(
          //   hintText: "Search here...",
          //   prefixIcons: const Icon(Icons.search),
          //   suffixIcons: const Icon(Icons.filter_list_rounded),
          // ).paddingBottom(15),
          FutureBuilder(
              future: HomeViewModel().getAllPayment(page, context),
              builder: (context, AsyncSnapshot snapshot) {
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
                  return Center(child: text("No Payments", maxLine: 10));
                } else {
                  return Consumer<HomeViewModel>(
                    builder: (context, value, child) {
                      List<dynamic> totalWithdraw = [];
                      List<dynamic> withdrawalRequest = [];
                      List<dynamic> requestedWithdraw = [];
                      List<dynamic> totalPaid = [];
                      List<dynamic> totalPayable = [];
                      List<dynamic> requestedPayable = [];

                      if (value.myAllPayments != null &&
                          value.myAllPayments.isNotEmpty) {
                        totalWithdraw = value.myAllPayments
                            .where((e) =>
                                e['withdrawalStatus'] == 'Completed' &&
                                e['type'] == 'withdraw')
                            .toList();
                        withdrawalRequest = value.myAllPayments
                            .where((e) =>
                                e['withdrawalStatus'] == 'Pending' &&
                                e['type'] == 'withdraw')
                            .toList();
                        requestedWithdraw = value.myAllPayments
                            .where((e) =>
                                e['withdrawalStatus'] == 'Requested' &&
                                e['type'] == 'withdraw')
                            .toList();
                        totalPaid = value.myAllPayments
                            .where((e) =>
                                e['withdrawalStatus'] == 'Completed' &&
                                e['type'] == 'payable')
                            .toList();
                        totalPayable = value.myAllPayments
                            .where((e) =>
                                e['withdrawalStatus'] == 'Pending' &&
                                e['type'] == 'payable')
                            .toList();
                        requestedPayable = value.myAllPayments
                            .where((e) =>
                                e['withdrawalStatus'] == 'Requested' &&
                                e['type'] == 'payable')
                            .toList();
                      } else {
                        totalWithdraw = [];
                        withdrawalRequest = [];
                        requestedWithdraw = [];
                        totalPaid = [];
                        totalPayable = [];
                        requestedPayable = [];
                      }
                      //withdrawalRequest
                      for (var withdrawal in withdrawalRequest) {
                        withdrawalpaymentsIds.add(withdrawal['_id']);
                      }
                      //withdrawalRequest
                      for (var payable in totalPayable) {
                        payablePaymentsIds.add(payable['_id']);
                      }
                      return Expanded(
                          child: TabBarView(controller: control, children: [
                        //totalWithdraw.......................................
                        totalWithdraw.isEmpty
                            ? Center(
                                child: Flexible(
                                child: text("No total Withdraw",
                                        overflow: TextOverflow.fade)
                                    .paddingTop(70),
                              ))
                            : SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                controller: scrollController,
                                child: Column(
                                  children: [
                                    ListView.builder(
                                      itemCount: totalWithdraw.length,
                                      shrinkWrap: true,
                                      physics: const BouncingScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        //  if (kDebugMode) {
                                        //     print("totalWithdraw: ${widget.totalWithdraw}");
                                        //   }
                                        return WithdrawContainer(
                                          leadingImage: applogo,
                                          title:
                                              "order No #: ${totalWithdraw[index]["orderId"].toString()}",
                                          trailing: totalWithdraw[index]
                                                  ["amount"]
                                              .toString(),
                                          ontap: () {
                                            // PaymentDetails(
                                            //   text: widget.title,
                                            // ).launch(context);
                                          },
                                        ).paddingTop(spacing_middle);
                                      },
                                    ).paddingSymmetric(
                                        horizontal: spacing_standard_new),
                                    if (page != 1 && value.pageloading)
                                      const CircularProgressIndicator()
                                          .paddingTop(spacing_middle)
                                  ],
                                ),
                              ),

                        //WithdrawalRequest.......................................
                        withdrawalRequest.isEmpty
                            ? Center(
                                child: Flexible(
                                child: text("No withdrawal Request",
                                        overflow: TextOverflow.fade)
                                    .paddingTop(70),
                              ))
                            : Column(
                                children: [
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: withdrawalRequest.length,
                                      shrinkWrap: true,
                                      physics: const BouncingScrollPhysics(),
                                      controller: scrollController,
                                      itemBuilder: (context, index) {
                                        // if (kDebugMode) {
                                        //   print("withdrawRequest: ${widget.requestedPayable}");
                                        // }
                                        return WithdrawContainer(
                                          leadingImage: applogo,
                                          title:
                                              "withdraw No #: ${withdrawalRequest[index]["withdrawNo"].toString()}",
                                          trailing: withdrawalRequest[index]
                                                  ["amount"]
                                              .toString(),
                                          ontap: () {
                                            // PaymentDetails(
                                            //   text: "withdraw Request",
                                            // ).launch(context);
                                          },
                                        ).paddingTop(spacing_middle);
                                      },
                                    ).paddingSymmetric(
                                        horizontal: spacing_standard_new),
                                  ),
                                  if (page != 1 && value.pageloading)
                                    const CircularProgressIndicator()
                                        .paddingTop(spacing_middle),
                                  const SizedBox(
                                    height: spacing_thirty,
                                  ),
                                  elevatedButton(
                                    context,
                                    onPress: () async {
                                      Map<String, dynamic> data = {
                                        // "status": "Pending",
                                        "paymentId": withdrawalpaymentsIds,
                                        "vendorId":
                                            userViewModel.vendorId.toString(),
                                        "adminId":
                                            userViewModel.adminId.toString(),
                                        "amount":
                                            widget.totalList![1].toString()
                                      };
                                      // if (kDebugMode) {
                                      //   print("withdrawalRequest pre: $data");
                                      // }
                                      HomeViewModel()
                                          .withdrawalPostRequest(data, context);
                                    },
                                    child: Flexible(
                                        child: text("Withdraw Request",
                                            overflow: TextOverflow.fade,
                                            color: white)),
                                  ).paddingSymmetric(
                                      horizontal: spacing_twinty,
                                      vertical: spacing_standard_new)
                                ],
                              ),

                        //requestToWithdraw.......................................
                        requestedWithdraw.isEmpty
                            ? Center(
                                child: Flexible(
                                child: text("No request To Withdraw",
                                        overflow: TextOverflow.fade)
                                    .paddingTop(70),
                              ))
                            : SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                controller: scrollController,
                                child: Column(
                                  children: [
                                    ListView.builder(
                                      itemCount: requestedWithdraw.length,
                                      shrinkWrap: true,
                                      physics: const BouncingScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        // if (kDebugMode) {
                                        //   print("withdrawRequest: ${widget.requestedPayable}");
                                        // }
                                        return WithdrawContainer(
                                          leadingImage: applogo,
                                          title:
                                              "order No #: ${requestedWithdraw[index]["orderId"].toString()}",
                                          trailing: requestedWithdraw[index]
                                                  ["amount"]
                                              .toString(),
                                          ontap: () {
                                            // PaymentDetails(
                                            //   text: widget.title,
                                            // ).launch(context);
                                          },
                                        ).paddingTop(spacing_middle);
                                      },
                                    ).paddingSymmetric(
                                        horizontal: spacing_standard_new),
                                    if (page != 1 && value.pageloading)
                                      const CircularProgressIndicator()
                                          .paddingTop(spacing_middle)
                                  ],
                                ),
                              ),
                        //totalPaid.......................................
                        totalPaid.isEmpty
                            ? Center(
                                child: Flexible(
                                child: text("No totalPaid",
                                        overflow: TextOverflow.fade)
                                    .paddingTop(70),
                              ))
                            : SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                controller: scrollController,
                                child: Column(
                                  children: [
                                    ListView.builder(
                                      itemCount: totalPaid.length,
                                      shrinkWrap: true,
                                      physics: const BouncingScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        // if (kDebugMode) {
                                        //   print("totalPaid: ${widget.requestedPayable}");
                                        // }
                                        return Column(
                                          children: [
                                            WithdrawContainer(
                                              leadingImage: applogo,
                                              title:
                                                  "order No #: ${totalPaid[index]["orderId"].toString()}",
                                              trailing: totalPaid[index]
                                                      ["amount"]
                                                  .toString(),
                                              ontap: () {
                                                // PaymentDetails(
                                                //   text: widget.title,
                                                // ).launch(context);
                                              },
                                            ),
                                          ],
                                        ).paddingTop(spacing_middle);
                                      },
                                    ).paddingSymmetric(
                                        horizontal: spacing_standard_new),
                                    if (page != 1 && value.pageloading)
                                      const CircularProgressIndicator()
                                          .paddingTop(spacing_middle)
                                  ],
                                ),
                              ),
                        //totalPayable.......................................
                        totalPayable.isEmpty
                            ? Center(
                                child: Flexible(
                                child: text("No total Payable",
                                        overflow: TextOverflow.fade)
                                    .paddingTop(70),
                              ))
                            : Column(
                                children: [
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: totalPayable.length,
                                      shrinkWrap: true,
                                      physics: const BouncingScrollPhysics(),
                                      controller: scrollController,
                                      itemBuilder: (context, index) {
                                        // if (kDebugMode) {
                                        //   print("totalPayable: ${widget.requestedPayable}");
                                        // }
                                        return WithdrawContainer(
                                          leadingImage: applogo,
                                          title:
                                              "order No #: ${totalPayable[index]["orderId"].toString()}",
                                          trailing: totalPayable[index]
                                                  ["amount"]
                                              .toString(),
                                          ontap: () {
                                            // PaymentDetails(
                                            //   text: widget.title,
                                            // ).launch(context);
                                          },
                                        ).paddingTop(spacing_middle);
                                      },
                                    ).paddingSymmetric(
                                        horizontal: spacing_standard_new),
                                  ),
                                  if (page != 1 && value.pageloading)
                                    const CircularProgressIndicator()
                                        .paddingTop(spacing_middle),
                                  elevatedButton(
                                    context,
                                    onPress: () async {
                                      Map<String, dynamic> data = {
                                        // "status": "Pending",
                                        "paymentId": payablePaymentsIds,
                                        "vendorId":
                                            userViewModel.vendorId.toString(),
                                        "adminId":
                                            userViewModel.adminId.toString(),
                                        "amount":
                                            widget.totalList![4].toString()
                                      };
                                      // if (kDebugMode) {
                                      //   print("totalPayable pre: $data");
                                      // }

                                      HomeViewModel()
                                          .withdrawalPostRequest(data, context);
                                    },
                                    child: Flexible(
                                        child: text("Make Payment",
                                            overflow: TextOverflow.fade,
                                            color: white)),
                                  ).paddingSymmetric(
                                      horizontal: spacing_twinty,
                                      vertical: spacing_standard_new)
                                ],
                              ),
                        //requestedPayable.......................................
                        requestedPayable.isEmpty
                            ? Center(
                                child: Flexible(
                                child: text("No requested Payable",
                                        overflow: TextOverflow.fade)
                                    .paddingTop(70),
                              ))
                            : SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                controller: scrollController,
                                child: Column(
                                  children: [
                                    ListView.builder(
                                      itemCount: requestedPayable.length,
                                      shrinkWrap: true,
                                      physics: const BouncingScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        // if (kDebugMode) {
                                        //   print("requestedPayable: ${widget.requestedPayable}");
                                        // }
                                        return WithdrawContainer(
                                          leadingImage: applogo,
                                          title:
                                              "order No #: ${requestedPayable[index]["orderId"].toString()}",
                                          trailing: requestedPayable[index]
                                                  ["amount"]
                                              .toString(),
                                          ontap: () {
                                            // PaymentDetails(
                                            //   text: widget.title,
                                            // ).launch(context);
                                          },
                                        ).paddingTop(spacing_middle);
                                      },
                                    ).paddingSymmetric(
                                        horizontal: spacing_standard_new),
                                    if (page != 1 && value.pageloading)
                                      const CircularProgressIndicator()
                                          .paddingTop(spacing_middle)
                                  ],
                                ),
                              ),
                      ]));
                    },
                  );
                }
              }),
        ],
      ),
    );
  }
}

class WithdrawContainer extends StatelessWidget {
  VoidCallback? ontap;
  String? leadingImage, title, trailing;
  WithdrawContainer({
    required this.ontap,
    this.leadingImage,
    this.title,
    this.trailing,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  color: black.withOpacity(0.07),
                  blurRadius: 24,
                  offset: const Offset(0, 4))
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              backgroundColor: colorPrimary.withOpacity(.2),
              child: Image.asset(
                color: colorPrimary,
                leadingImage.toString(),
                height: 50,
                width: 50,
                fit: BoxFit.contain,
              ),
            ),
            Flexible(
              child: text(title.toString(),
                      fontWeight: FontWeight.w300,
                      fontSize: textSizeSMedium,
                      overflow: TextOverflow.fade,
                      isLongText: true)
                  .paddingLeft(spacing_standard_new),
            ),
            const Spacer(),
            text(
              trailing.toString(),
              fontWeight: FontWeight.w400,
              fontSize: textSizeSMedium,
            ),
          ],
        ).paddingAll(10),
      ),
    );
  }
}
