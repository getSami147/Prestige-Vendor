import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:prestige_vender/utils/Colors.dart';
import 'package:prestige_vender/utils/Constant.dart';
import 'package:prestige_vender/utils/Images.dart';
import 'package:prestige_vender/utils/string.dart';
import 'package:prestige_vender/utils/widget.dart';
import 'package:prestige_vender/viewModel/authViewModel.dart';
import 'package:prestige_vender/viewModel/userViewModel.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
final formkey= GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final emailFouseNode = FocusNode();

    var size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                    child: Image.asset(
                  forgotPassword,
                  fit: BoxFit.contain,
                  height: size.width * .55,
                  width: size.width * .55,
                )).paddingTop(spacing_thirty),
                Center(
                    child: text(
                  Forgot_ForgetPassword,
                  isCentered: true,
                  color: black,
                      fontSize: textSizeLarge,
                      fontWeight: FontWeight.w700
                )).paddingTop(spacing_middle),
                Center(
                    child: text(
                  Forgot_text,
                  isCentered: true,
                  maxLine: 4,
                 color: textGreyColor,
                    fontSize: textSizeSMedium,
                )).paddingTop(spacing_middle),
                text(
                  LogIn_Email,
                                      fontSize: textSizeSMedium,

                ).paddingTop(spacing_middle),
               CustomTextFormField(context,
                  controller: emailController,
                  focusNode: emailFouseNode,
                  keyboardType: TextInputType.emailAddress,
                  obscureText: false,
                   validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email address';
                            } else if (!value.contains("@")) {
                              return "Please enter a validate email";
                            }

                            return null;
                          },
                  hintText: "Enter your email",
                ).paddingTop(spacing_middle),
                Consumer<AuthViewModel>(
                  builder: (context, value, child) =>
                      elevatedButton(context, loading: value.loading, onPress: () {
                        if (formkey.currentState!.validate()) {
                        AuthViewModel().forgotApi(emailController.text.toString(),context);
                        }
                  },
                          child: text(Forgot_SendCode,
                               fontWeight: FontWeight.w500,
                                  color: color_white)),
                ).paddingTop(spacing_xxLarge),
              ],
            ).paddingSymmetric(horizontal: spacing_twinty),
          ),
        ),
      ),
    );
  }
}
