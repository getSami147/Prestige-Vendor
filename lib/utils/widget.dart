import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prestige_vender/utils/colors.dart';

import 'Constant.dart';

// Elevated button .....................................>>>
// ignore: must_be_immutable
class elevatedButton extends StatelessWidget {
  VoidCallback? onPress;
  var isStroked = false;
  double? elevation;
  Widget? child;
  ValueChanged? onFocusChanged;
  Color backgroundColor;
  Color bodersideColor;
  var height;
  var width;
  var borderRadius;
  var loading;

  elevatedButton(
    BuildContext context, {
    Key? key,
    this.loading = false,
    var this.isStroked = false,
    this.onFocusChanged,
    required var this.onPress,
    this.elevation,
    var this.child,
    var this.backgroundColor = colorPrimary,
    var this.bodersideColor = colorPrimary,
    var this.borderRadius = 30.0,
    var this.height = 50.0,
    var this.width = double.infinity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
          onFocusChange: onFocusChanged,
          onPressed: onPress,
          style: isStroked
              ? ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shape: const RoundedRectangleBorder())
              : ElevatedButton.styleFrom(
                  elevation: elevation,
                  side: BorderSide(color: bodersideColor),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(borderRadius)),
                  backgroundColor: backgroundColor,
                ),
          child: loading
              ? const CircularProgressIndicator(
                  color: color_white,
                  strokeWidth: 2,
                )
              : child),
    );
  }
}

// Elevated button .....................................>>>Finished
// ignore: must_be_immutable
class GradientButton extends StatelessWidget {
  bool? loading;

  Widget? child;
  Gradient? gradientColors;
  Color? buttonbgColor;
  var borderRadius;
  var height, width;
  VoidCallback? onPressed;
  Color? disabledBackgroundColor;

  GradientButton(
      {required this.child,
      this.loading,
      this.disabledBackgroundColor,
      this.width = double.infinity,
      required this.onPressed,
      this.height = 60.0,
      this.buttonbgColor = Colors.transparent,
      this.borderRadius = 10.0,
      this.gradientColors =
          const LinearGradient(colors: [Color(0xff9B22C5), Color(0xff6929D1)]),
      super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        gradient: gradientColors,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),

          backgroundColor:
              buttonbgColor, // Make the button background transparent
          elevation: 0, // No elevation
          disabledBackgroundColor: Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: loading == true
            ? const Center(
                child: CircularProgressIndicator(
                  color: color_white,
                  strokeWidth: 2,
                ),
              )
            : child,
      ),
    );
  }
}

class CustomDropdownButton extends StatelessWidget {
  final String hint;
 final List<DropdownMenuItem<String>>? items;
  final ValueChanged<String?> onChanged;
  final FormFieldValidator<String>? validator;
  // final TextStyle textStyle;
  // final EdgeInsets padding;
  final String? value;

  const CustomDropdownButton({
    required this.hint,
    this.value,
    required this.items,
    required this.onChanged,
    this.validator,
    // required this.textStyle,
    // required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                blurRadius: 24,
                offset: const Offset(0, 4),
                spreadRadius: 0,
                color: const Color(0xff000000).withOpacity(.1))
          ]),
      child: DropdownButtonFormField<String>(
        decoration: const InputDecoration(
        contentPadding: EdgeInsets.only(left: 10),
        border: InputBorder.none,),
        hint: text(hint),
        value: value,
        items: items,
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }
}

//buildDropButton
class buildDropButton extends StatelessWidget {
  String? myText;
  VoidCallback? onTap;
  buildDropButton({
    this.onTap,
    this.myText,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: spacing_standard_new),
        padding: const EdgeInsets.symmetric(horizontal: spacing_standard_new),
        alignment: Alignment.center,
        height: 60,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
            border: Border.all(
              color: borderColor,
            ),
            borderRadius: BorderRadius.circular(8.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
                child: text(myText,
                    fontSize: textSizeSMedium, color: textcolorSecondary)),
            const Icon(
              Icons.arrow_drop_down,
              color: textcolorSecondary,
            )
          ],
        ),
      ),
    );
  }
}
  //formatNumber ammout formatter....................>>
String ammoutFormatter(int number) {
  final formatter = NumberFormat('#,##0');
  return formatter.format(number);
}
  // Function to format DateTime and convertServerTimeToLocal....................>>
  String formatDateTime(String serverTime) {
  // Parse the server time to DateTime object
  DateTime serverDateTime = DateTime.parse(serverTime);

  // Convert the server time to local time
  DateTime localDateTime = serverDateTime.toLocal();

  // Format the local time to the desired format
  String formattedDateTime = DateFormat("dd MMMM y 'at' hh:mm a").format(localDateTime);

  return formattedDateTime;
}
// Helper function to capitalize the first letter
String capitalizeFirstLetter(String input) {
  if (input.isEmpty) return input;
  return input[0].toUpperCase() + input.substring(1);
}
// Text widget .....................................>>>Start
Widget text(String? text,
    {var fontSize = textSizeMedium,
    Color? color,
    bool isgoogleFonts=true,
    var fontFamily = 'Poppins',
    var isCentered = false,
    var maxLine = 1,
    TextOverflow? overflow,
    var latterSpacing = 0.5,
    bool textAllCaps = false,
    var isLongText = false,
    bool lineThrough = false,
    var fontWeight = FontWeight.w400}) {
  return Text(
   textAllCaps ? text!.toUpperCase() : capitalizeFirstLetter(text!),
    textAlign: isCentered ? TextAlign.center : TextAlign.start,
    maxLines: isLongText ? null : maxLine,
    overflow: overflow,
    style:isgoogleFonts? GoogleFonts.koHo(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color ?? colorPrimary,
       height: 1.5,
        letterSpacing: latterSpacing,
          decoration:
              lineThrough ? TextDecoration.lineThrough : TextDecoration.none,


    ):
      TextStyle(
          fontFamily: fontFamily,
          fontWeight: fontWeight,
          fontSize: fontSize,
          color: color ?? colorPrimary,
          letterSpacing: latterSpacing,
          
          decoration:
              lineThrough ? TextDecoration.lineThrough : TextDecoration.none,
        ),
  );
}

class utils {
  // toastMethod .....................
  void toastMethod(message,
      {backgroundColor = Colors.black, textColor = Colors.white}) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: backgroundColor,
        textColor: textColor,
        fontSize: textSizeMedium);
  }

  // FlushBar Method.....................
  void flushBar(BuildContext context, String message,
      {backgroundColor = colorPrimary, textColor = Colors.white,messageSize= 15.0}) {
    showFlushbar(
      context: context,
      flushbar: Flushbar(
        message: message,
        forwardAnimationCurve: Curves.decelerate,
        reverseAnimationCurve: Curves.easeInOut,
        duration: const Duration(seconds: 3),
        flushbarPosition: FlushbarPosition.TOP,
        borderRadius: BorderRadius.circular(5),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        messageColor: textColor,
        backgroundColor: backgroundColor,
        messageSize: messageSize,
      )..show(context),
    );
  }

  // FormFocusChange.....................
  void formFocusChange(
    BuildContext context,
    FocusNode currentFocus,
    FocusNode nextFocus,
  ) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}

// customCircularProgress.....................
class CustomLoadingIndicator extends StatelessWidget {
  const CustomLoadingIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SpinKitThreeInOut(
      color: colorPrimary,
      size: 30,
    );
  }
}

// Text TextFromFeild...........................................>>>
// ignore: must_be_immutable

class CustomTextFormField extends StatelessWidget {
  final VoidCallback? onPressed;
  final FormFieldValidator<String>? validator;
  final FormFieldSetter<String>? onSaved;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final ValueChanged<String>? onFieldSubmitted;

  final double height;
  final String? hintText;
  final Color filledColor;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final BorderSide? borderSide;
  final bool isPassword;
  final bool isSecure;
  final double fontSize;
  final Color textColor;
  final String? fontFamily;
  final String? text;
  final double suffixWidth;
  final int? maxLines;
  final int? maxLength;
  final int? minLines;
  final bool obscureText;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;

  CustomTextFormField(
    BuildContext context, {
    Key? key,
    this.focusNode,
    this.onFieldSubmitted,
    this.controller,
    this.obscureText = false,
    this.validator,
    this.onSaved,
    this.minLines,
    this.onChanged,
    this.height = 80.0,
    this.onPressed,
    this.suffixWidth = 50.0,
    this.hintText,
    this.filledColor = Colors.white,
    this.prefixIcon,
    this.suffixIcon,
    this.borderSide,
    this.fontFamily,
    this.fontSize = 14.0,
    this.isPassword = false,
    this.isSecure = false,
    this.keyboardType,
    this.maxLines = 1,
    this.maxLength,
    this.text,
    this.textColor = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                blurRadius: 24,
                offset: const Offset(0, 4),
                spreadRadius: 0,
                color: const Color(0xff000000).withOpacity(.1),
              ),
            ],
          ),
          child: TextFormField(
            maxLines: maxLines,
            maxLength:maxLength ,
            focusNode: focusNode,
            minLines: minLines,
            keyboardType: keyboardType,
            onFieldSubmitted: onFieldSubmitted,
            controller: controller,
            obscureText: obscureText,
            onTap: onPressed,
            onSaved: onSaved,
            onChanged: onChanged,
            validator: validator,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 10.0), // Text ke andar ka space kam karein
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              suffixIconConstraints: BoxConstraints(
                maxHeight: 30,
                maxWidth: suffixWidth,
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10),
              ),
              hintText: hintText,
              hintStyle:  GoogleFonts.koHo(
             fontSize: fontSize,


    ),
            ),
          ),
        ),
      ],
    );
  }
}

// Text TextFromFeild end...........................................>>>

// CustomOTPCode................................................>>
class CustomOTPCode extends StatelessWidget {
  const CustomOTPCode({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          height: 68,
          width: 72,
          child: TextFormField(
            onChanged: (value) {
              if (value.length == 1) {
                FocusScope.of(context).nextFocus();
              }
            },
            style: Theme.of(context).textTheme.headlineMedium,
            keyboardType: TextInputType.number,
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
              FilteringTextInputFormatter.digitsOnly
            ],
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: textGreyColor)),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: colorPrimary),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 68,
          width: 72,
          child: TextFormField(
            onChanged: (value) {
              if (value.length == 1) {
                FocusScope.of(context).nextFocus();
              }
            },
            style: Theme.of(context).textTheme.headlineMedium,
            keyboardType: TextInputType.number,
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
              FilteringTextInputFormatter.digitsOnly
            ],
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: textGreyColor)),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: colorPrimary),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 68,
          width: 72,
          child: TextFormField(
            onChanged: (value) {
              if (value.length == 1) {
                FocusScope.of(context).nextFocus();
              }
            },
            style: Theme.of(context).textTheme.headlineMedium,
            keyboardType: TextInputType.number,
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
              FilteringTextInputFormatter.digitsOnly
            ],
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: textGreyColor)),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: colorPrimary),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 68,
          width: 72,
          child: TextFormField(
            style: Theme.of(context).textTheme.headlineMedium,
            keyboardType: TextInputType.number,
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
              FilteringTextInputFormatter.digitsOnly
            ],
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: textGreyColor)),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: colorPrimary),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Widget formField(context, hint,
    {isEnabled,
    isDark = false,
    isDummy = false,
    controller,
    showBorder = false,
    changeHintColor = false,
    changeBackground = false,
    isPasswordVisible = false,
    isPassword = false,
    onEditingComplete,
    keyboardType = TextInputType.text,
    FormFieldValidator<String>? validator,
    onSaved,
    height,
    onChanged,
    textInputAction = TextInputAction.next,
    FocusNode? focusNode,
    FocusNode? nextFocus,
    Widget? suffixIcon,
    Widget? prefixIcon,
    maxLine = 1,
    minLine,
    suffixIconSelector}) {
  return Container(
    height: height,
    alignment: Alignment.center,
    width: MediaQuery.of(context).size.width * 0.9,
    child: TextFormField(
      enabled: isEnabled,
      onEditingComplete: onEditingComplete,
      onChanged: onChanged,
      controller: controller,
      obscureText: isPassword ? isPasswordVisible : false,
      cursorColor: textColorPrimary,
      maxLines: maxLine,
      minLines: minLine,
      keyboardType: keyboardType,
      validator: validator,
      onSaved: onSaved,
      textInputAction: textInputAction,
      focusNode: focusNode,
      onFieldSubmitted: (arg) {
        if (nextFocus != null) {
          FocusScope.of(context).requestFocus(nextFocus);
        }
      },
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(spacing_standard),
            borderSide: changeBackground
                ? showBorder
                    ? const BorderSide(color: colorPrimary2)
                    : BorderSide.none
                : const BorderSide(color: borderColor)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(spacing_standard),
            borderSide: changeBackground
                ? showBorder
                    ? const BorderSide(color: borderColor)
                    : BorderSide.none
                : const BorderSide(color: borderColor)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(spacing_standard),
            borderSide: changeBackground
                ? showBorder
                    ? const BorderSide(color: borderColor)
                    : BorderSide.none
                : const BorderSide(color: borderColor)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(spacing_standard),
            borderSide: changeBackground
                ? showBorder
                    ? const BorderSide(color: borderColor)
                    : BorderSide.none
                : const BorderSide(color: borderColor)),
                disabledBorder:OutlineInputBorder(
            borderRadius: BorderRadius.circular(spacing_standard),
            borderSide: changeBackground
                ? showBorder
                    ? const BorderSide(color: borderColor)
                    : BorderSide.none
                : const BorderSide(color: borderColor)),
        filled: true,
        fillColor: changeBackground ? white : edittext_background,
        hintText: hint,
        hintStyle: TextStyle(
            fontSize: textSizeSMedium,
            color: changeHintColor ? textColorPrimary : textcolorSecondary),
        prefixIcon: prefixIcon,
        suffixIcon: isPassword
            ? GestureDetector(
                onTap: suffixIconSelector,
                child: suffixIcon,
              )
            : suffixIcon,
      ),
      style: TextStyle(
          fontSize: textSizeMedium,
          color: isDummy
              ? Colors.transparent
              : isDark == true
                  ? textColorPrimary
                  : textcolorSecondary,
          fontFamily: fontRegular),
    ),
  );
}

// Text TextFromFeild2...........................................>>>
// ignore: must_be_immutable
class textformfield1 extends StatelessWidget {
  VoidCallback? onPressed;
  FormFieldValidator<String>? validator;
  FormFieldValidator<String>? onSaved;
  ValueChanged? onChanged;
  TextEditingController? controller;
  ValueChanged<String>? onFieldSubmitted;
  Color color;
  var hight;
  var hinttext;
  var filledColor;
  var suffixIcons;
  var prefixIcons;
  var borderSide;
  var isPassword;
  var isSecure;
  var fontSize;
  var textColor;
  var fontFamily;
  var text;
  var suffixWidth;
  var maxLine;
  bool obscureText;
  TextInputType? keyboardType;
  FocusNode? focusNode;
  textformfield1({
    Key? key,
    required this.color,
    this.focusNode,
    this.onFieldSubmitted,
    this.controller,
    this.obscureText = false,
    this.validator,
    this.onSaved,
    this.onChanged,
    var this.hight = 50.0,
    this.onPressed,
    var this.suffixWidth = 50.0,
    var this.hinttext,
    var this.filledColor = Colors.white,
    var this.prefixIcons,
    var this.suffixIcons,
    var this.borderSide,
    var this.fontFamily,
    var this.fontSize = textSizeMedium,
    var this.isPassword = false,
    var this.isSecure = false,
    var this.keyboardType,
    var this.maxLine = 1,
    var this.text,
    var this.textColor = textSecondaryColor,
    required String hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: color),
            boxShadow: [
              BoxShadow(
                  blurRadius: 24,
                  offset: const Offset(0, 4),
                  spreadRadius: 0,
                  color: const Color(0xff000000).withOpacity(.1))
            ]),
        height: hight,
        child: TextFormField(
          maxLines: maxLine,
          focusNode: focusNode,
          keyboardType: keyboardType,
          onFieldSubmitted: onFieldSubmitted,
          controller: controller,
          obscureText: obscureText,
          onTap: onPressed,
          onSaved: onSaved,
          onChanged: onChanged,
          validator: validator,
          decoration: InputDecoration(
              prefixIcon: prefixIcons,
              suffixIcon: suffixIcons,
              suffixIconConstraints:
                  BoxConstraints(maxHeight: 50, maxWidth: suffixWidth),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(30)),
              hintText: hinttext,
              hintStyle: const TextStyle(fontSize: textSizeSmall)),
        ));
  }
}
