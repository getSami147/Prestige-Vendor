import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prestige_vender/utils/Images.dart';
import 'package:prestige_vender/utils/colors.dart';
import 'package:prestige_vender/utils/constant.dart';
import 'package:prestige_vender/utils/string.dart';
import 'package:prestige_vender/utils/widget.dart';
import 'package:prestige_vender/view/drawers/notificationScreen.dart';
import 'package:prestige_vender/viewModel/homeViewModel.dart';
import 'package:provider/provider.dart';

class Mytransactionscreen extends StatefulWidget {
  const Mytransactionscreen({super.key});

  @override
  State<Mytransactionscreen> createState() => _MytransactionscreenState();
}

class _MytransactionscreenState extends State<Mytransactionscreen> {
  int page = 1;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    var homeViewModel = Provider.of<HomeViewModel>(context, listen: false);
    homeViewModel.setPageloading(true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      homeViewModel.shopByVendor(context).then((value) => {
            homeViewModel.getMyTransactions(
                page, context), // Fetch initial data
          });
    });

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        // When the user reaches the end of the list, load more data
        if (!homeViewModel.pageloading) {
          page++;
          homeViewModel.getMyTransactions(page, context); // Fetch next page
        }
      }
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      appBar: AppBar(
        title: text(MyTransaction_My_Transactions,
            fontSize: textSizeNormal.spMin, fontWeight: FontWeight.w700),
        actions: [
          IconButton(
                  onPressed: () {
                    const NotificationScreen().launch(context);
                  },
                  icon: const Icon(Icons.notifications))
              .paddingRight(5)
        ],
      ),
      body: Column(
        children: [

          Expanded(
              child: Consumer<HomeViewModel>(
            builder: (context, value, child) {
              List transaction = value.myTransactions;
               // Sort the list in descending order by createdAt field
          transaction.sort((a, b) {
            DateTime dateA = DateTime.parse(a["createdAt"]);
            DateTime dateB = DateTime.parse(b["createdAt"]);
            return dateB.compareTo(dateA); // For descending order
          });
              // print(value.myTransactions.toList());

              return value.pageloading && transaction.isEmpty
                  ? const Center(child: CustomLoadingIndicator())
                  : transaction.isEmpty
                      ? const Center(child: Text("No Transaction Found"))
                      : SingleChildScrollView(
                          controller: scrollController,
                          child: Column(
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                itemCount: transaction.length,
                                itemBuilder: (context, index) {
                                  // if (kDebugMode) {
                                  //   print("TLength: ${transaction.length}");
                                  // }
                                  return Container(
                                      alignment: Alignment.center,
                                      height: orientation ==
                                              Orientation.portrait
                                          ? MediaQuery.of(context).size.height *
                                              0.11
                                          : MediaQuery.of(context).size.height *
                                              0.2,
                                      decoration: BoxDecoration(
                                          color: white,
                                          boxShadow: [
                                            BoxShadow(
                                                color: black.withOpacity(0.06),
                                                offset: const Offset(0, 4),
                                                blurRadius: 24)
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: ListTile(
                                          leading: SvgPicture.asset(
                                            svg_SplashIcon,
                                            height: 40,
                                          ),
                                          title: text(
                                              "$MyTransaction_shoping ${DateFormat("yMd").format(DateTime.parse(transaction[index]["createdAt"].toString()))}",
                                              fontSize: textSizeMedium,
                                              fontWeight: FontWeight.w500,
                                              isLongText: true),
                                          subtitle: text(
                                              transaction[index]
                                                      ["paymentMethod"]
                                                  .toString(),
                                              fontSize: textSizeSmall,
                                              fontWeight: FontWeight.w400,
                                              color: textcolorSecondary),
                                          trailing: Column(
                                            children: [
                                              text(
                                                "N ${ammoutFormatter(double.parse(transaction[index]["amount"].toString()).toInt())}",
                                                fontSize: textSizeLargeMedium,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              text(
                                                
                                                  "P ${ammoutFormatter(double.parse(transaction[index]["PrestigePoint"].toString()).toInt())}",
                                                  color: colorPrimary,
                                                  fontSize: textSizeLargeMedium,
                                                  fontWeight: FontWeight.w500)
                                            ],
                                          ))).paddingTop(10);
                                },
                              ),
                              SizedBox(height: value.pageloading ? 20 : 10),
                              if (page != 1 && value.pageloading)
                                const CircularProgressIndicator(),
                              SizedBox(height: value.pageloading ? 20 : 10),
                            ],
                          ).paddingSymmetric(horizontal: 15),
                        );
            },
          ).paddingTop(spacing_twinty))
        ],
      ),
    );
  }
}

class customcontainerrow extends StatelessWidget {
  String? text1;
  VoidCallback? ontap;
  Color? color, color1, color2;
  var size;
  customcontainerrow({
    this.size,
    this.color,
    this.color1,
    this.color2,
    this.ontap,
    this.text1,
    super.key,
    required this.orientation,
  });

  final Orientation orientation;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Container(
        height: orientation == Orientation.portrait
            ? MediaQuery.of(context).size.height * 0.07
            : MediaQuery.of(context).size.height * 0.18,
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: black.withOpacity(0.06),
                  offset: Offset(0, 4),
                  blurRadius: 24)
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            text(text1.toString(),
                    fontSize: size, fontWeight: FontWeight.w600, color: color1)
                .paddingLeft(10),
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.arrow_forward,
                  color: color2,
                ))
          ],
        ),
      ).paddingTop(20),
    );
  }
}
