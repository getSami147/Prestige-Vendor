import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:prestige_vender/utils/Colors.dart';
import 'package:prestige_vender/utils/Constant.dart';
import 'package:prestige_vender/utils/Images.dart';
import 'package:prestige_vender/utils/string.dart';
import 'package:prestige_vender/utils/widget.dart';
import 'package:prestige_vender/viewModel/authViewModel.dart';
import 'package:provider/provider.dart';

class OtpVerification extends StatefulWidget {
  final email;
  const OtpVerification({required this.email, super.key});

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  int? otp;
  final formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                    child: Image.asset(
                  oTP,
                  fit: BoxFit.contain,
                  height: size.width * .55,
                  width: size.width * .55,
                )).paddingTop(spacing_thirty),
                Center(
                    child: text(
                  OTP_title,
                  isCentered: true,
                 color: black,
                      fontSize: textSizeLarge,
                      fontWeight: FontWeight.w700
                )).paddingTop(spacing_middle),
                Center(
                    child: text(
                  "$OTP_Subtitle ${widget.email.toString()}",
                  isCentered: true,
                  maxLine: 4,
                  color: textGreyColor,
                    fontSize: textSizeSMedium,
                )).paddingTop(spacing_middle),
               
                PinCodeTextField(
                  appContext: context,
                  keyboardType: TextInputType.number,
                  length: 6,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter 6 digit OTP';
                    }

                    return null;
                  },
                  pinTheme: PinTheme(
                      fieldWidth: 50,
                      fieldHeight: 50,
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(10),
                      activeColor: colorPrimary,
                      inactiveColor: textGreyColor),
                      
                  onChanged: (value) {
                    otp = value.toInt();
                    setState(() {});
                  },
                ).paddingTop(spacing_xxLarge),
                Consumer<AuthViewModel>(
                  builder: (context, value, child) => elevatedButton(context,
                      loading: value.loading, onPress: () {
                    if (formkey.currentState!.validate()) {
                      Map<String, dynamic> data = {
                        "email": widget.email.toString(),
                        "otp": otp,
                      };
                      if (kDebugMode) {
                        print("pre otp data: ${data}");
                      }
                      AuthViewModel().verifyOTP(data, context);
                    }
                  },
                      child: text(SignUp_Next,
                          fontWeight: FontWeight.w500,
                              color: color_white)),
                ).paddingTop(spacing_xxLarge),
                TextButton(
                  onPressed: () {
                    AuthViewModel().resandOTP(widget.email, context);
                    if (kDebugMode) {
                      print("email: ${widget.email.toString()}");
                    }
                  },
                  child: text("Resend OTP",
                          textAllCaps: true,
                          color: colorPrimary,
                          fontWeight: FontWeight.w600)
                      .center()
                      .paddingTop(spacing_standard),
                ).paddingTop(spacing_middle),
              ],
            ).paddingSymmetric(horizontal: spacing_twinty),
          ),
        ),
      ),
    );
  }
}
