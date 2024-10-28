import 'package:flutter/material.dart';
import 'package:prestige_vender/utils/Images.dart';
import 'package:prestige_vender/utils/colors.dart';
import 'package:prestige_vender/utils/string.dart';

// onbondingscreen model
class onbonding {
  String? text, image, text1, text2;
  onbonding({this.image, this.text, this.text1, this.text2});
}

final onbondingscreenmodel = [
  onbonding(
      text: onbonding_reward,
      image: spendingReward,
      text1: onbonding_use_prestige,
      text2: ""),
  onbonding(
      text: welcome_welcometext,
      image: premierReward,
      text1: onbonding_use_point,
      text2: onbonding_keep_your)
];
// Home Container Model........................................................>>

class HomeModel {
  String? title, buttontext;
  var svg;
  Color? color_container, iconsColor,
      color_divider,
      color_text1,
      color_text2,
      color_text3,
      color_small_contianer;
  HomeModel(
      {this.title,
      this.iconsColor,
      this.buttontext,
      this.svg,
      this.color_container,
      this.color_small_contianer,
      this.color_divider,
      this.color_text1,
      this.color_text2,
      this.color_text3});
}

final homeModel = [
  HomeModel(
      title: "Total Withdraw",
      iconsColor:colorPrimary,
      buttontext: "view",
      svg: svg_withdraw,
      color_container: colorPrimary,
      color_divider: colorPrimary,
      color_small_contianer: colorPrimary,
      color_text1: colorPrimary,
      color_text2: colorPrimary,
      color_text3: colorPrimary),
  HomeModel(
    title: "Withdrawal Request",
    iconsColor: colorPrimary2,
    buttontext: "Request",
    svg: svg_requestWithdraw,
    color_container:colorPrimary2,
    color_divider: colorPrimary2,
    color_small_contianer:colorPrimary2,
    color_text1: colorPrimary2,
    color_text2: colorPrimary2,
    color_text3: colorPrimary2,
  ),
  HomeModel(
    title: "Requested Withdraw",
   iconsColor:Colors.blueAccent,
    buttontext: "view",
    svg: svg_myReward,
    color_container: Colors.blueAccent,
    color_divider: Colors.blueAccent,
    color_small_contianer: Colors.blueAccent,
    color_text1: Colors.blueAccent,
    color_text2: Colors.blueAccent,
    color_text3: Colors.blueAccent,
  ),
   HomeModel(
      title: "Total Paid",
      iconsColor: colorPrimary,
      buttontext: "view",
      svg: svg_coin,
      color_container:colorPrimary,
      color_divider: colorPrimary,
      color_small_contianer: colorPrimary,
      color_text1: colorPrimary,
      color_text2: colorPrimary,
      color_text3: colorPrimary),
  HomeModel(
      title: "Total Payable",
      iconsColor: Colors.cyan,
      buttontext: "make payment",
      svg: svg_coin,
      color_container:Colors.cyan,
      color_divider: Colors.cyan,
      color_small_contianer:Colors.cyan,
      color_text1: Colors.cyan,
      color_text2: Colors.cyan,
      color_text3: Colors.cyan),
       HomeModel(
      title: "Request Payable",
      iconsColor: dissmisable_RedColor,
      buttontext: "view",
      svg: svg_coin,
      color_container: dissmisable_RedColor,
      color_divider: dissmisable_RedColor,
      color_small_contianer: dissmisable_RedColor,
      color_text1: dissmisable_RedColor,
      color_text2: dissmisable_RedColor,
      color_text3: dissmisable_RedColor),
      
   
];
