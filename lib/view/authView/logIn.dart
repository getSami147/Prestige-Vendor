import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prestige_vender/utils/Images.dart';
import 'package:prestige_vender/utils/constant.dart';
import 'package:prestige_vender/utils/widget.dart';
import 'package:prestige_vender/view/authView/forgotPassword.dart';
import 'package:prestige_vender/view/authView/signUp.dart';
import 'package:prestige_vender/view/authView/completeProfileScreen.dart';
import 'package:prestige_vender/view/dashboard/dashboard.dart';
import 'package:prestige_vender/view/dashboard/homeScreen.dart';
import 'package:prestige_vender/viewModel/authViewModel.dart';
import 'package:provider/provider.dart';

import '../../utils/Colors.dart';
import '../../utils/string.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final emailFouseNode = FocusNode();
  final passwordFouseNode = FocusNode();

  final obSecurePassword = ValueNotifier(true);
  final formkey = GlobalKey<FormState>();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    emailFouseNode.dispose();
    passwordFouseNode.dispose();
    obSecurePassword.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    var size = MediaQuery.sizeOf(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Form(
          key: formkey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                            child: SvgPicture.asset(
                          svg_SplashIcon2,
                          fit: BoxFit.cover,
                          height: 50,
                          // height: size.height * .15,
                          // width: size.width * .55,
                        )).paddingTop(spacing_thirty),
                        Center(
                            child: text(
                          LogIn_LoginTitle,
                          isCentered: true,
                          color: black,
                              fontSize: textSizeNormal,
                              fontWeight: FontWeight.w700
                        )).paddingTop(spacing_standard_new),
                        Center(
                            child: text(
                          LogIn_text,
                          maxLine: 5,
                          isCentered: true,
                         color: textGreyColor
                        ).paddingTop(spacing_middle)),
                        text(
                          LogIn_Email,
                                                      fontSize: textSizeSMedium,

                        ).paddingTop(spacing_middle),
                        CustomTextFormField(
                          context,
                          controller: emailController,
                          focusNode: emailFouseNode,
                          onFieldSubmitted: (value) {
                            utils().formFocusChange(
                                context, emailFouseNode, passwordFouseNode);
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the email';
                            } else if (!value.contains("@")) {
                              return "Please enter a validate email";
                            }

                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                          obscureText: false,
                          hintText: "Please enter email",
                        ).paddingTop(spacing_middle),
                        text(
                          LogIn_password,
                        ).paddingTop(spacing_standard_new),
                        ValueListenableBuilder(
                          valueListenable: obSecurePassword,
                          builder: (context, value, child) =>
                              CustomTextFormField(
                            context,
                            controller: passwordController,
                            focusNode: passwordFouseNode,
                            obscureText: obSecurePassword.value,
                            validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Password';
                            } 
                            return null;
                          },
                            suffixIcon: GestureDetector(
                                    onTap: () {
                                      obSecurePassword.value =
                                          !obSecurePassword.value;
                                    },
                                    child: SvgPicture.asset(
                                        obSecurePassword.value
                                            ? svg_hidePassword
                                            : svg_unHide))
                                .paddingRight(spacing_middle),
                            hintText: "Please enter Password",
                          ).paddingTop(spacing_middle),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                                onPressed: () {
                                  const ForgotPassword().launch(context,
                                      pageRouteAnimation:
                                          PageRouteAnimation.Fade);
                                },
                                child: text(LogIn_Forgot,
                                   color: colorPrimary))
                          ],
                        ),
                        Consumer<AuthViewModel>(
                            builder: (context, value, child) =>
                                elevatedButton(context, loading: value.loading,
                                    onPress: () {
                                  if (formkey.currentState?.validate() ??
                                      false) {
                                    try {
                                      Map<String, dynamic> data = {
                                        "email": emailController.text
                                            .trim()
                                            .toString(),
                                        "password": passwordController.text
                                            .trim()
                                            .toString(),
                                      };
                                      authViewModel.loginApi(data, context);
                                    } catch (e) {
                                      utils().flushBar(context, e.toString());
                                    }
                                  }
                              
                                },
                                    child: text(LogIn_LOGIN,
                                        fontWeight: FontWeight.w500,
                                            color: color_white))),
                        Row(
                          children: [
                            const Expanded(
                                child: Divider(
                              thickness: 1,
                            )),
                            text(LogIn_OR,
                                   fontWeight: FontWeight.w500)
                                .paddingSymmetric(horizontal: spacing_standard)
                                .center(),
                            const Expanded(
                                child: Divider(
                              thickness: 1,
                            )),
                          ],
                        ).paddingTop(spacing_thirty),
                        elevatedButton(context,
                            backgroundColor: white,
                            bodersideColor: color_white, onPress: () {
                          // authViewModel.googleSignIn(context);
                        },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  svg_google,
                                  height: 30,
                                  width: 30,
                                  fit: BoxFit.cover,
                                ).paddingRight(spacing_standard),
                                text("Continue With Google",
                                    fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                      fontSize: textSizeLargeMedium,),
                              ],
                            )).paddingTop(spacing_twinty),
                        elevatedButton(context,
                            backgroundColor: white,
                            bodersideColor: color_white,
                            onPress: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  svg_facebook,
                                  height: 30,
                                  width: 30,
                                  fit: BoxFit.cover,
                                ).paddingRight(spacing_standard),
                                text("Continue With Facebook",
                                    fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                      fontSize: textSizeLargeMedium,),
                              ],
                            )).paddingTop(spacing_standard_new),
                      ],
                    ).paddingSymmetric(horizontal: spacing_twinty),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  const SignUpScreen().launch(context,
                      pageRouteAnimation: PageRouteAnimation.Fade);
                },
                child: RichText(
                    text: TextSpan(
                        text: LogIn_DontHaveAccount,
                        style: GoogleFonts.lato(color: Colors.black),
                        children: [
                      TextSpan(
                          text: LogIn_RegisterNow,
                          style: GoogleFonts.lato(
                              color: colorPrimary, fontWeight: FontWeight.w600))
                    ])).center().paddingTop(spacing_thirty),
              ).paddingBottom(spacing_middle)
            ],
          ),
        ),
      ),
    );
  }
}
