// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:nb_utils/nb_utils.dart';
// import 'package:prestige_vender/utils/colors.dart';
// import 'package:prestige_vender/utils/constant.dart';
// import 'package:prestige_vender/utils/string.dart';
// import 'package:prestige_vender/utils/widget.dart';
// import 'package:prestige_vender/view/authView/logIn.dart';
// import 'package:prestige_vender/viewModel/homeViewModel.dart';
// import 'package:prestige_vender/viewModel/userViewModel.dart';
// import 'package:provider/provider.dart';


// class ContactUs extends StatefulWidget {
//   const ContactUs({super.key});

//   @override
//   State<ContactUs> createState() => _ContactUsState();
// }

// class _ContactUsState extends State<ContactUs> {
//   // controller
  
//   final nameController = TextEditingController();
//   final emailController = TextEditingController();
//   final usermessageController = TextEditingController();

//   // Focus Node
//   final nameFouseNode = FocusNode();
//   final emailFouseNode = FocusNode();
//   final usermessageFouseNode = FocusNode();

//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();

//     nameController.dispose();
//     emailController.dispose();
//     usermessageController.dispose();

//     nameFouseNode.dispose();
//     emailFouseNode.dispose();
//     usermessageFouseNode.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var provider = Provider.of<UserViewModel>(context, listen: false);
//   // nameController.text= provider.u!;
//   emailController.text= provider.vendorEmail!;
    

//     return Scaffold(
//       appBar: CustomAppBar(
//         title: ContactUs_title,
//         backbutton: true,
//         backPressed: () {
//           finish(context);
//         },
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             text(
//               ContactUs_getIn,
//               googleFonts: GoogleFonts.lato(
//                   fontSize: 33.0,
//                   fontWeight: FontWeight.w700,
//                   color: colorPrimary),
//             ).paddingTop(spacing_twinty),
//             text(
//               ContactUs_discription,
//               maxLine: 5,
//               isCentered: true,
//               googleFonts: GoogleFonts.lato(
//                 fontSize: textSizeMedium,
//                 fontWeight: FontWeight.w400,
//               ),
//             ).paddingTop(spacing_control),
//             Container(
//               decoration: BoxDecoration(
//                   color: Colors.white, borderRadius: BorderRadius.circular(20)),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   text(
//                     ContactUs_Name,
//                     googleFonts: GoogleFonts.lato(
//                       fontSize: textSizeMedium,
//                       color: blackColor.withOpacity(0.4),
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   CustomTextFormField(
//                     obscureText: false,
//                     filledColor: filledColor,
//                     controller: nameController,
//                     focusNode: nameFouseNode,
//                     onFieldSubmitted: (value) {
//                       utils().formFocusChange(
//                           context, nameFouseNode, emailFouseNode);
//                     },
//                   ).paddingTop(spacing_control),
//                   text(
//                     ContactUs_Email,
//                     googleFonts: GoogleFonts.lato(
//                       fontSize: textSizeMedium,
//                       color: blackColor.withOpacity(0.4),
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ).paddingTop(spacing_twinty),
//                   CustomTextFormField(
//                     filledColor: filledColor,
//                     controller: emailController,
//                     focusNode: emailFouseNode,
//                     onFieldSubmitted: (value) {
//                       utils().formFocusChange(
//                           context, emailFouseNode, usermessageFouseNode);
//                     },
//                   ).paddingTop(spacing_control),
//                   text(
//                     ContactUs_help,
//                     googleFonts: GoogleFonts.lato(
//                       fontSize: textSizeMedium,
//                       color: blackColor.withOpacity(0.4),
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ).paddingTop(spacing_twinty),
//                   CustomTextFormField(
//                     hight: 250.0, maxLine: 100,
//                     controller: usermessageController,
//                     focusNode: usermessageFouseNode,
//                     filledColor: filledColor,

//                     // hintText: ContactUs_Name,
//                   ).paddingTop(spacing_control),
//                   Consumer<HomeViewModel>(
//                     builder: (context, value, child) => GradientButton(
//                         loading: value.loading,
//                         onPressed: () {
//                           // Map data = {
//                           //   "name": nameController.text.trim().toString(),
//                           //   "email": emailController.text.trim().toString(),
//                           //   "message":
//                           //       usermessageController.text.trim().toString(),
//                           //   "receivedAt": "2023-08-26T08:00:00Z",
//                           //   "isActive": true
//                           // };

//                           // HomeViewModel().contectUsApi(
//                           //     data,
//                           //     {
//                           //       'Content-Type': 'application/json',
//                           //       'Authorization': 'Bearer ${provider.accessToken}'
//                           //     },
//                           //     context);
//                         },
//                         child: text(ContactUs_Submit,
//                             googleFonts: GoogleFonts.lato(
//                                 fontWeight: FontWeight.w500,
//                                 fontSize: textSizeLargeMedium,
//                                 color: color_white))),
//                   ).paddingTop(spacing_xxLarge)
//                 ],
//               ).paddingSymmetric(
//                   vertical: spacing_twinty, horizontal: spacing_standard_new),
//             ).paddingSymmetric(vertical: spacing_thirty)
//           ],
//         ).paddingSymmetric(horizontal: spacing_large),
//       ),
//     );
//   }
// }
