// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:intl/intl.dart';
// import 'package:nb_utils/nb_utils.dart';
// import 'package:prestige_vender/utils/Images.dart';
// import 'package:prestige_vender/utils/colors.dart';
// import 'package:prestige_vender/utils/constant.dart';
// import 'package:prestige_vender/utils/string.dart';
// import 'package:prestige_vender/utils/widget.dart';
// import 'package:prestige_vender/view/screens/checkout.dart';


// // ignore: must_be_immutable
// class NotificationDetailScreen extends StatelessWidget {
//   var data;
//   NotificationDetailScreen({required this.data, super.key});

//   @override
//   Widget build(BuildContext context) {

//     return Scaffold(
//         appBar: AppBar(
//           iconTheme: const IconThemeData(color: black),
//           title: text("Notifications Details",
//               fontSize:textSizeLarge, fontWeight: FontWeight.w700),
//         ),
//         body: Column(
//           children: [
            
//             Container(
//               decoration: BoxDecoration(
//                       color: white,
//                       boxShadow: [
//                         BoxShadow(
//                             color: black.withOpacity(0.06),
//                             offset: const Offset(0, 4),
//                             blurRadius: 24)
//                       ],
//                       borderRadius: BorderRadius.circular(10)),
//               child: ListTile(
//                 leading: Container(height: 35,width: 35,alignment: Alignment.center,
//                                 decoration: BoxDecoration(color: colorPrimary.withOpacity(.9),borderRadius: BorderRadius.circular(10)),
              
//                   child: Image.network(
//                               data["body"]["images"][0],
//                               height:40,width: 40,fit: BoxFit.contain,
//                           ),
//                 ),
//                 title: text("Title: ${data["title"].toString()}",
//                     fontSize: textSizeSmall,
//                     fontWeight: FontWeight.w500,
//                     isLongText: true),
//                 subtitle: text(
//                     " ${DateFormat("dd MMMM y 'at' hh:mm a")
//                           .format(DateTime.parse( data["createdAt"].toString()))}",
//                     fontSize:textSizeSmall.0,
//                     fontWeight: FontWeight.w400,
//                     color: textcolorSecondary),
//               ).paddingSymmetric(horizontal: 15, vertical: 10),
//             ),
//              Container(
//                   alignment: Alignment.center,
//                   decoration: BoxDecoration(
//                       color: white,
//                       boxShadow: [
//                         BoxShadow(
//                             color: black.withOpacity(0.06),
//                             offset: const Offset(0, 4),
//                             blurRadius: 24)
//                       ],
//                       borderRadius: BorderRadius.circular(10)),
//                   child: Column(
//                     children: [
//                       CustomBillingRow(
//                         text0: "userType:",
//                         text1: data["userType"].toString(),
//                         titleColor: textGreyColor,
//                       ).paddingTop(10),
//                        CustomBillingRow(
//                         text0: Ordrdetail_OrderID,
//                         text1: data["body"]["orderNo"].toString(),
//                         titleColor: textGreyColor,
//                       ).paddingTop(10),
//                       Row(
//                         children: [
//                           text("status:", color: textGreyColor),
//                           const Spacer(),
//                           text(data["body"]["status"].toString(),
//                               fontSize: textSizeSmall, fontWeight: FontWeight.w600),
                         
//                         ],
//                       ).paddingOnly(left: 10, right: 10, top: 10),
//                     const Divider().paddingSymmetric(horizontal: spacing_standard_new).paddingTop(spacing_middle),
//                       CustomBillingRow(
//                         text0: "type:",
//                         text1: data['body']["type"].toString(),
//                         titleColor: textGreyColor,
//                         traillingColor: colorPrimary,
//                       ).paddingTop(10),
                    
//                     ],
//                   ).paddingAll(spacing_middle),
//                 ).paddingTop(20),
               
//           ],
//         ).paddingSymmetric(horizontal: spacing_standard)
//         );
//   }
// }

