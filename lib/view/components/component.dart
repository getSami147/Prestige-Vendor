import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prestige_vender/utils/Colors.dart';
import 'package:prestige_vender/utils/Constant.dart';
import 'package:prestige_vender/utils/widget.dart';


// ignore: must_be_immutable
class DrawerTile extends StatelessWidget {
  // IconData? iconA;
  String? imagename;
  String? textName;
  VoidCallback? onTap;

  DrawerTile(
      {Key? key,
      required this.imagename,
      required this.textName,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                imagename.toString(),
                height: 25,
                width: 25,
                color: colorPrimary,
                fit: BoxFit.contain,
              ),
              text(textName, fontFamily: 'Poppins')
                  .paddingLeft(spacing_standard_new),
            ],
          ).paddingTop(spacing_standard_new),
          // const Divider().paddingTop(spacing_middle)
        ],
      ).paddingTop(spacing_standard),
    );
  }
}
