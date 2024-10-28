import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prestige_vender/viewModel/userViewModel.dart';
import 'package:provider/provider.dart';
import 'package:prestige_vender/utils/Colors.dart';
import 'package:prestige_vender/utils/Constant.dart';
import 'package:prestige_vender/utils/Images.dart';
import 'package:prestige_vender/utils/string.dart';
import 'package:prestige_vender/utils/widget.dart';
import 'package:prestige_vender/viewModel/authViewModel.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var gendervalue = 'Male';
  bool? ischecked = false;
  final obSecurePassword = ValueNotifier(true);
  final obSecureConfromPassword = ValueNotifier(true);
  // controller
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final conformpasswordController = TextEditingController();
  // Focus Node
  final nameFouseNode = FocusNode();
  final emailFouseNode = FocusNode();
  final passwordFouseNode = FocusNode();
  final conformPasswordFouseNode = FocusNode();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    conformpasswordController.dispose();

    nameFouseNode.dispose();
    emailFouseNode.dispose();
    passwordFouseNode.dispose();
    conformPasswordFouseNode.dispose();

    obSecurePassword.dispose();
    obSecureConfromPassword.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formkey=GlobalKey<FormState>();
    var authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    var size = MediaQuery.sizeOf(context);
    return Scaffold(
      // appBar: AppBar(),
      body: SafeArea(
        child: Form(
          key: formkey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                  child: SvgPicture.asset(svg_SplashIcon2, height:size.height * 0.05,width:size.height * 0.05 ,fit: BoxFit.contain,).paddingTop(16),
                ),
                      Center(
                          child: text(
                        signUp_Title,
                        isCentered: true,
                       color: black,
                            fontSize: textSizeLarge,
                            fontWeight: FontWeight.w700
                      )).paddingTop(spacing_middle),
                      Center(
                          child: text(
                        SignUp_text,
                        isCentered: true,
                        maxLine: 4,
                       color: textGreyColor,
                          fontSize: textSizeSMedium,
                      )).paddingTop(spacing_middle),
                      Consumer<UserViewModel>(
                        builder: (BuildContext context, value, Widget? child) =>
                            Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: size.width * .14,
                              backgroundColor: colorPrimary,
                              child: value.image == null
                                  ? ClipOval(
                                      child: Image.asset(
                                      profileimage,
                                      height: size.width * .23,
                                      width: size.width * .23,
                                      fit: BoxFit.cover,
                                    ))
                                  : ClipOval(
                                      child: Image.file(
                                        File(value.image!.path).absolute,
                                        height: size.width * .24,
                                        width: size.width * .24,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                            Container(
                                alignment: Alignment.center,
                                height: 35,
                                width: 35,
                                decoration: const BoxDecoration(
                                    color: colorPrimary, shape: BoxShape.circle),
                                child: IconButton(
                                  onPressed: () {
                                    value.getImages();
                                  },
                                  icon: const Icon(Icons.edit_outlined),
                                  color: whiteColor,
                                  iconSize: 20,
                                ))
                          ],
                        ).center(),
                      ).paddingTop(spacing_middle),
                      text(
                        SignUp_Name,
                                                  fontSize: textSizeSMedium,

                      ).paddingTop(spacing_middle),
                      CustomTextFormField(context,
                        controller: nameController,
                        focusNode: nameFouseNode,
                         validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your full name';
                              } 
                              return null;
                            },
                        onFieldSubmitted: (value) {
                          utils().formFocusChange(
                              context, nameFouseNode, emailFouseNode);
                        },
                        hintText: SignUp_Name,
                      ).paddingTop(spacing_middle),
                      text(
                        SignUp_Email,
                                                  fontSize: textSizeSMedium,

                      ).paddingTop(spacing_middle),
                      CustomTextFormField(context,
                        focusNode: emailFouseNode,
                        controller: emailController,
                        hintText: LogIn_Email,
                        keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the email';
                            } else if (!value.contains("@")) {
                              return "Please enter a validate email";
                            }

                            return null;
                          },
                        onFieldSubmitted: (value) {
                          utils().formFocusChange(
                              context, nameFouseNode, passwordFouseNode);
                        },
                      ).paddingTop(spacing_middle),
                      text(
                        SignUp_Password,
                                                 fontSize: textSizeSMedium,

                      ).paddingTop(spacing_middle),
                      ValueListenableBuilder(
                        valueListenable: obSecurePassword,
                        builder: (context, value, child) => CustomTextFormField(context,
                          controller: passwordController,
                          focusNode: passwordFouseNode,
                          obscureText: obSecurePassword.value,
                          hintText: SignUp_Password,
                          keyboardType: TextInputType.visiblePassword,
                           validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter the password';
                            } 
                            return null;
                          },
                          onFieldSubmitted: (value) {
                            utils().formFocusChange(context, passwordFouseNode,
                                conformPasswordFouseNode);
                          },
                          suffixIcon: GestureDetector(
                                  onTap: () {
                                    obSecurePassword.value =
                                        !obSecurePassword.value;
                                  },
                                  child: SvgPicture.asset(obSecurePassword.value
                                      ? svg_hidePassword
                                      : svg_unHide))
                              .paddingRight(spacing_middle),
                        ).paddingTop(spacing_middle),
                      ),
                      text(
                        SignUp_conformPassword,
                                                 fontSize: textSizeSMedium,

                      ).paddingTop(spacing_middle),
                      ValueListenableBuilder(
                        valueListenable: obSecureConfromPassword,
                        builder: (context, value, child) => CustomTextFormField(context,
                          controller: conformpasswordController,
                          focusNode: conformPasswordFouseNode,
                          obscureText: obSecureConfromPassword.value,
                          hintText: SignUp2_ConformPassword,
                          keyboardType: TextInputType.visiblePassword,
                           validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the conform password';
                            }else if(passwordController.text.toString()!=conformpasswordController.text.toString()){
                              return "Your passwords don't match.";
                            }
                            return null;
                          },
                          suffixIcon: GestureDetector(
                                  onTap: () {
                                    obSecureConfromPassword.value =
                                        !obSecureConfromPassword.value;
                                  },
                                  child: SvgPicture.asset(
                                      obSecureConfromPassword.value
                                          ? svg_hidePassword
                                          : svg_unHide))
                              .paddingRight(spacing_middle),
                        ).paddingTop(spacing_middle),
                      ),
                     
                     
                      const SizedBox(
                        height: spacing_twinty,
                      )
                    ],
                  ).paddingSymmetric(horizontal: spacing_twinty),
                ),
              ),
              Consumer<AuthViewModel>(
                builder: (context, value, child) => elevatedButton(
                  context,
                  loading: value.loading,
                  onPress: () {
                    if (formkey.currentState!.validate()) {
                       Map<String, String> data = {
                        "name": nameController.text.toString(),
                        "email": emailController.text.toString(),
                        "password": passwordController.text.toString(),
                        "role": "vendor",
                      };
                        authViewModel.signUpformData(data, context);
                      
                    }
                  },
                  child: text(
                    SignUp_Next,
                   fontWeight: FontWeight.w500,
                      color: color_white,
                  ),
                ),
              ).paddingOnly(
                bottom: spacing_thirty,
                left: spacing_standard_new,
                right: spacing_standard_new,
              )
            ],
          ),
        ),
      ),
    );
  }
}
///  testing  ....