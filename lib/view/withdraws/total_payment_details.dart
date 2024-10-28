// import 'package:flutter/material.dart';
// import 'package:nb_utils/nb_utils.dart';
// import 'package:prestige_vender/utils/colors.dart';
// import 'package:prestige_vender/utils/constant.dart';
// import 'package:prestige_vender/utils/widget.dart';

// class PaymentDetails extends StatefulWidget {
//   String? text;
//   PaymentDetails({this.text, super.key});

//   @override
//   State<PaymentDetails> createState() => _PaymentDetailsState();
// }

// class _PaymentDetailsState extends State<PaymentDetails> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: text("${widget.text} " "details", fontWeight: FontWeight.bold),
//       ),
//       body: Column(
//         children: [
//           Container(
//             decoration: BoxDecoration(boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.1),
//                 spreadRadius: 2,
//                 blurRadius: 5,
//                 offset: const Offset(0, 3),
//               ),
//             ], borderRadius: BorderRadius.circular(15), color: color_white),
//             padding: const EdgeInsets.all(10),
//             child: Column(
//               children: [
//                 paymentDetailsContainer(
//                   text1: "Withdraw-ID",
//                   text2: "#21480",
//                 ),
//                 paymentDetailsContainer(
//                   text1: "User Name",
//                   text2: "Waheed",
//                 ),
//                 paymentDetailsContainer(
//                   text1: "User Email",
//                   text2: "uzr@gmail.com",
//                 ),
//                 paymentDetailsContainer(
//                   text1: "Shop Name",
//                   text2: "Nain's Mart",
//                 ),
//                 paymentDetailsContainer(
//                   text1: "Amount Requested",
//                   text2: "N50",
//                 ),
//                 paymentDetailsContainer(
//                   text1: "Withdraw Account",
//                   text2: "xxxx-xxxxx-xxxxx",
//                 ),
//                 paymentDetailsContainer(
//                   text1: "Requested Date",
//                   text2: "02/01/2024(3:00 PM)",
//                 ),
//                 paymentDetailsContainer(
//                   text1: "Status",
//                   text2: "Approved",
//                 ),
//               ],
//             ),
//           )
//         ],
//       ).paddingAll(20),
//     );
//   }
// }

// class paymentDetailsContainer extends StatelessWidget {
//   String? text1, text2;
//   paymentDetailsContainer({
//     this.text1,
//     this.text2,
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         text(text1,
//             fontWeight: FontWeight.w400, fontSize: textSizeMedium, color: grey),
//         text(
//           text2,
//           fontWeight: FontWeight.w500,
//           fontSize: textSizeMedium,
//         ),
//       ],
//     );
//   }
// }
