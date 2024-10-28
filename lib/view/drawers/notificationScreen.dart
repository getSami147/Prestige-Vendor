import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prestige_vender/utils/Images.dart';
import 'package:prestige_vender/utils/colors.dart';
import 'package:prestige_vender/utils/constant.dart';
import 'package:prestige_vender/utils/string.dart';
import 'package:prestige_vender/utils/widget.dart';
import 'package:prestige_vender/viewModel/homeViewModel.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  ScrollController scrollController = ScrollController();
   int page=1;
   @override
  void initState() {
    var homeViewModel = Provider.of<HomeViewModel>(context, listen: false);
     WidgetsBinding.instance.addPostFrameCallback((_) {
    homeViewModel.getAllNotifications(page, context); // Fetch initial data
     });
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        // When the user reaches the end of the list, load more data
          page++;
          homeViewModel.getAllNotifications(page, context); // Fetch next page
      
      }
    });
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: black),
          title: text(NotificationScreen_Notifications,
              fontSize: textSizeNormal.spMin, fontWeight: FontWeight.w700),
        ),
        body: Consumer<HomeViewModel>(builder: (context, value, child) {
          List data = value.myNotification;
           // Sort the list in descending order by createdAt field
          data.sort((a, b) {
            DateTime dateA = DateTime.parse(a["createdAt"]);
            DateTime dateB = DateTime.parse(b["createdAt"]);
            return dateB.compareTo(dateA); // For descending order
          });
          return value.pageloading&&data.isEmpty? const Center(child: CustomLoadingIndicator()): 
          data.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Image.asset(
                        bellicon,
                        height: MediaQuery.of(context).size.height * 0.18,
                      ),
                    ),
                    text(NotificationScreen_NoNotifications,
                            fontSize: 22.0,
                            fontWeight: FontWeight.w600,
                            color: colorPrimary)
                        .paddingTop(20)
                  ],
                )
              : SingleChildScrollView(
                controller: scrollController,
               physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    ListView.builder(
                        itemCount: data.length,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return InkWell(
                            // onTap: () {
                            //   NotificationDetailScreen(data: data[index]).launch(context,
                            //       pageRouteAnimation: PageRouteAnimation.Fade);
                            // },
                            child: CustomListTile(
                              image: drawer_ic_notificationbell,
                              text0: data[index]["title"].toString(),
                              text1: formatDateTime(
                                  data[index]["createdAt"].toString(),
                            )).paddingTop(spacing_standard_new),
                          );
                        },
                      ).paddingSymmetric(horizontal: 15),
                      if (page!=1&& value.pageloading)
                                const CircularProgressIndicator().paddingTop(spacing_middle).paddingBottom(20)
                  ],
                ),
              );
        })
        );
  
  }
}

// ignore: must_be_immutable
class CustomListTile extends StatelessWidget {
  String? image, text0, text1;
  CustomListTile({this.image, this.text0, this.text1, super.key});

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;
    return Container(
        alignment: Alignment.center,
        height: orientation == Orientation.portrait
            ? MediaQuery.of(context).size.height * 0.09
            : MediaQuery.of(context).size.height * 0.2,
        decoration: BoxDecoration(
            color: white,
            boxShadow: [
              BoxShadow(
                  color: const Color(0xff333333).withOpacity(0.10),
                  offset: const Offset(0, 4),
                  blurRadius: 27)
            ],
            borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          leading: Container(
            height: 35,
            width: 35,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: colorPrimary.withOpacity(.9),
                borderRadius: BorderRadius.circular(10)),
            child: SvgPicture.asset(image.toString(),color: white,
                height: 20, width: 20, fit: BoxFit.cover),
          ),
          title: text(text0.toString(),
              fontSize: textSizeSmall, fontWeight: FontWeight.w500, isLongText: true),
          subtitle: text(text1.toString(),
              fontSize:textSizeSmall,
              fontWeight: FontWeight.w400,
              color: textcolorSecondary),
        ));
  }
}
