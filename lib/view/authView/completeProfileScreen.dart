import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prestige_vender/models/getAllStatesModel.dart';
import 'package:prestige_vender/viewModel/homeViewModel.dart';
import 'package:prestige_vender/viewModel/services/notificationServices.dart';
import 'package:prestige_vender/viewModel/userViewModel.dart';
import 'package:provider/provider.dart';
import 'package:prestige_vender/utils/Colors.dart';
import 'package:prestige_vender/utils/Constant.dart';
import 'package:prestige_vender/utils/Images.dart';
import 'package:prestige_vender/utils/string.dart';
import 'package:prestige_vender/utils/widget.dart';
import 'package:prestige_vender/view/authView/logIn.dart';
import 'package:prestige_vender/viewModel/authViewModel.dart';
import 'package:shimmer/shimmer.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<CompleteProfileScreen> {
  // var gendervalue = 'Male';
  bool? ischecked = false;
  final obSecurePassword = ValueNotifier(true);
  final obSecureConfromPassword = ValueNotifier(true);
  // controller

  final lGAController = TextEditingController();
  final contectNumberController = TextEditingController();
  final referalCodeController = TextEditingController();
  // Focus Node
  // final lGAFouseNode = FocusNode();
  // final contectNumberFouseNode = FocusNode();
  // final referalCodeFouseNode = FocusNode();
  @override
  void initState() {
    var userViewModel = Provider.of<UserViewModel>(context, listen: false);
    userViewModel.signupToken();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // lGAController.dispose();
    // lGAFouseNode.dispose();
    // referalCodeController.dispose();
    // contectNumberController.dispose();
    // contectNumberFouseNode.dispose();
  }

  final formkey = GlobalKey<FormState>();
  final DateTime lastDate = DateTime.now();
  var stateId;

  @override
  Widget build(BuildContext context) {
    // var userViewModel = Provider.of<UserViewModel>(context, listen: false);

    var size = MediaQuery.sizeOf(context);
    DateTime? picked;
    Future<void> selectDate(BuildContext context) async {
      var userViewModel = Provider.of<UserViewModel>(context, listen: false);
      picked = await showDatePicker(
          helpText: 'Set your Date of Birth',
          cancelText: 'Cancel',
          confirmText: "Conform",
          fieldLabelText: 'Booking Date',
          fieldHintText: 'Month/Date/Year',
          errorFormatText: 'Enter valid date',
          errorInvalidText: 'Enter date in valid range',
          context: context,
          initialDate: userViewModel.selectedDate,
          firstDate: DateTime(1960, 1),
          lastDate: DateTime.now());

      if (picked != null && picked != userViewModel.selectedDate) {
        userViewModel.setSelectedDate(picked!);
      }
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                    child: SvgPicture.asset(
                  svg_SplashIcon,
                  fit: BoxFit.cover,
                  height: 50,
                  width: 60,
                  // height: size.height * .15,
                  // width: size.width * .55,
                )).paddingTop(spacing_thirty),
                Center(
                        child: text(signUp_Title,
                            isCentered: true,
                            color: black,
                            fontSize: textSizeLarge,
                            fontWeight: FontWeight.w700))
                    .paddingTop(spacing_middle),
                Center(
                    child: text(
                  SignUp_text,
                  isCentered: true,
                  maxLine: 4,
                  color: textGreyColor,
                  fontSize: textSizeSMedium,
                )).paddingTop(spacing_middle),

                //getAll States.......
                FutureBuilder(
                    future: HomeViewModel().getAllStatesAPI(context),
                    builder: (BuildContext context,
                        AsyncSnapshot<GetAllStatesModel> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Shimmer.fromColors(
                            baseColor: colorPrimary,
                            highlightColor: colorPrimary2,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: spacing_middle),
                              height: 50,
                              width: double.infinity,
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  hint: text("choose States",
                                      fontSize: textSizeMedium, color: black),
                                  items: [],
                                  onChanged: (value) {},
                                ),
                              ),
                            )).paddingTop(spacing_middle);
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(snapshot.error.toString()),
                        );
                      } else {
                        var index;
                        for (int i = 0; i < snapshot.data!.data!.length; i++) {
                          index = i;
                        }
                        // print("Snapshot data: ${snapshot.data?.data}");
                        var data = snapshot.data!.data![index];
                        return snapshot.data!.data!.isEmpty
                            ? text("No States found",
                                fontSize: textSizeMedium, color: black)
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  text(
                                    SignUp_state,
                                    fontSize: textSizeSMedium,
                                  ).paddingTop(spacing_middle),
                                  StatefulBuilder(
                                      builder: (context, justChange) {
                                    return Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          boxShadow: [
                                            BoxShadow(
                                                blurRadius: 24,
                                                offset: const Offset(0, 4),
                                                spreadRadius: 0,
                                                color: const Color(0xff000000)
                                                    .withOpacity(.1))
                                          ]),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: spacing_middle),
                                      height: 50,
                                      width: double.infinity,
                                      child: Consumer<UserViewModel>(
                                        builder: (context, stateValue, child) {
                                          return DropdownButtonFormField<
                                              String>(
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                            ),
                                            hint: text(
                                                stateValue.selectedState ??
                                                    "choose the State",
                                                fontSize: textSizeMedium,
                                                color: black),
                                            items: snapshot.data!.data!
                                                .map<DropdownMenuItem<String>>(
                                                    (e) {
                                              return DropdownMenuItem(
                                                onTap: () {
                                                  justChange(() {});
                                                  stateId = e.id;
                                                },
                                                value: e.name.toString(),
                                                child: text(
                                                  e.name.toString(),
                                                ),
                                              );
                                            }).toList(),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please select the States';
                                              }
                                              return null;
                                            },
                                            onChanged: (value) {
                                              stateValue
                                                  .setSelectedState(value!);
                                              if (kDebugMode) {
                                                print(
                                                    "Seleted State: ${stateValue.selectedState}");
                                                print(
                                                    "Seleted State: $stateId");
                                              }
                                            },
                                          );
                                        },
                                      ),
                                    ).paddingTop(spacing_middle);
                                  }),
                                  Consumer<UserViewModel>(
                                    builder: (context, stateValue, child) {
                                      // if (kDebugMode) {
                                      //   print(
                                      //     "selectedState: ${stateValue.selectedState}");
                                      // }
                                      return stateValue.selectedState == null
                                          ? const SizedBox()
                                          : StatefulBuilder(
                                              builder: (context, justChange) {
                                              return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  text(
                                                    "LGA's",
                                                    fontSize: textSizeSMedium,
                                                  ).paddingTop(spacing_middle),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        boxShadow: [
                                                          BoxShadow(
                                                              blurRadius: 24,
                                                              offset:
                                                                  const Offset(
                                                                      0, 4),
                                                              spreadRadius: 0,
                                                              color: const Color(
                                                                      0xff000000)
                                                                  .withOpacity(
                                                                      .1))
                                                        ]),
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal:
                                                            spacing_middle),
                                                    height: 50,
                                                    width: double.infinity,
                                                    child:
                                                        Consumer<UserViewModel>(
                                                      builder: (context,
                                                          stateValue, child) {
                                                        return DropdownButtonFormField<
                                                            String>(
                                                          decoration:
                                                              const InputDecoration(
                                                            border: InputBorder
                                                                .none,
                                                          ),
                                                          hint: text(
                                                              stateValue
                                                                      .selectedLGAs ??
                                                                  "choose the LGA's",
                                                              fontSize:
                                                                  textSizeMedium,
                                                              color: black),
                                                          items: snapshot
                                                              .data!.data!
                                                              .firstWhere((state) =>
                                                                  state.name ==
                                                                  stateValue
                                                                      .selectedState)
                                                              .lgAs!
                                                              .map<
                                                                  DropdownMenuItem<
                                                                      String>>((l) {
                                                            return DropdownMenuItem(
                                                              value:
                                                                  l.toString(),
                                                              child: text(
                                                                l.toString(),
                                                              ),
                                                            );
                                                          }).toList(),
                                                          validator: (value) {
                                                            if (value == null ||
                                                                value.isEmpty) {
                                                              return 'Please select the LGA';
                                                            }
                                                            return null;
                                                          },
                                                          onChanged: (value) {
                                                            stateValue
                                                                .setSelectedLGAs(
                                                                    value!);
                                                            if (kDebugMode) {
                                                              print(
                                                                  "Seleted selectedLGAs: ${stateValue.selectedLGAs.toString()}");
                                                            }
                                                            justChange(() {});
                                                          },
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ).paddingTop(spacing_middle);
                                            });
                                    },
                                  )
                                ],
                              );
                      }
                    }),

                text(
                  SignUp_gender,
                  fontSize: textSizeSMedium,
                ).paddingTop(spacing_middle),
                Consumer<UserViewModel>(
                  builder: (context, genderProvider, _) {
                    return CustomDropdownButton(
                      hint: genderProvider.selectedGender ?? "choose Gender",
                      items: <String>['Male', 'Female'].map((String g) {
                        return DropdownMenuItem<String>(
                          value: g.toString(),
                          child: text(g.toString()),
                        );
                      }).toList(),
                      onChanged: (value) {
                        genderProvider.setSelectedGender(value!);
                        if (kDebugMode) {
                          print(
                              "Seleted State: ${genderProvider.selectedGender.toString()}");
                        }
                        // justChange(() {});
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Select your LGA';
                        }

                        return null;
                      },
                    );
                  },
                ).paddingTop(spacing_middle),
                text(
                  SignUp_contectNumber,
                  fontSize: textSizeSMedium,
                ).paddingTop(spacing_middle),
                CustomTextFormField(
                  context,
                  // focusNode: contectNumberFouseNode,
                  controller: contectNumberController,
                  hintText: SignUp_contectNumber,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the Contact Number';
                    }
                    if (value.length < 11) {
                      return 'Contact Number must be at least 11 characters long';
                    }
                    return null;
                  },
                ).paddingTop(spacing_middle),
                Consumer<UserViewModel>(
                  builder: (context, checkboxState, _) {
                    return CheckboxListTile(
                      contentPadding: const EdgeInsets.all(0),
                      activeColor: colorPrimary,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: text(SignUp2_Agreetext,
                          maxLine: 5,
                          color: colorPrimary,
                          fontSize: textSizeSmall,
                          fontWeight: FontWeight.w500),
                      value: checkboxState.isChecked,
                      onChanged: (value) {
                        checkboxState.setIsChecked(value!);
                      },
                    );
                  },
                ),
                text(
                  fontSize: textSizeSMedium,
                  SignUp2_promoText,
                ).paddingTop(spacing_middle),
                textformfield1(
                  // focusNode: referalCodeFouseNode,
                  color: colorPrimary,
                  controller: referalCodeController,
                  hintText: SignUp2_EnterReferral,
                ).paddingTop(spacing_middle),
                text(
                  fontSize: textSizeSMedium,
                  SignUp_DOB,
                ).paddingTop(spacing_middle),
                Consumer<UserViewModel>(
                  builder: (context, pickDate, child) {
                    return Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 24,
                                offset: const Offset(0, 4),
                                spreadRadius: 0,
                                color: const Color(0xff000000).withOpacity(.1))
                          ]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          text(
                            DateFormat.yMd().format(pickDate.selectedDate),
                            fontSize: textSizeSMedium,
                          ),
                          IconButton(
                              onPressed: () {
                                selectDate(context);
                              },
                              icon: const Icon(
                                Icons.calendar_month,
                                color: colorPrimary,
                              )),
                        ],
                      ).paddingSymmetric(horizontal: spacing_middle),
                    ).paddingTop(spacing_middle);
                  },
                ),
                Consumer<AuthViewModel>(builder: (context, value, child) {
                  return elevatedButton(context, loading: value.loading,
                      onPress: () async {
                    var userViewModel =
                        Provider.of<UserViewModel>(context, listen: false);
                    if (formkey.currentState?.validate() ?? false) {
                      var deviceToken =
                          await NotificationServices().getToken(context);
                      Map<String, dynamic> data = {
                        "referralCodes": referalCodeController.text.toString(),
                        "gender": userViewModel.selectedGender,
                        "contact": contectNumberController.text.toString(),
                        "countryName": "Nigeria",
                        "countryId": "659312c0bf44441986f6cbb2",
                        "statesId": stateId.toString(),
                        "statesName": userViewModel.selectedState.toString(),
                        "LGA": userViewModel.selectedLGAs.toString(),
                        "DOB": userViewModel.selectedDate.toString(),
                        "deviceToken": deviceToken.toString()
                      };
                      // if (kDebugMode) {
                      // print("Pre data: ${data}");
                      // }
                      AuthViewModel().completeProfile(data, context);
                    }
                  },
                      child: text(SignUp_Next,
                          fontWeight: FontWeight.w500, color: color_white));
                }).paddingTop(spacing_thirty),
                GestureDetector(
                  onTap: () {
                    const LoginScreen().launch(context,
                        isNewTask: true,
                        pageRouteAnimation: PageRouteAnimation.Fade);
                  },
                  child: RichText(
                      text: TextSpan(
                          text: SignUp2_HaveAccount,
                          style: GoogleFonts.lato(color: Colors.black),
                          children: [
                        TextSpan(
                            text: LogIn_LOGIN,
                            style: GoogleFonts.lato(
                                color: colorPrimary,
                                decoration: TextDecoration.underline))
                      ])).center(),
                ).paddingTop(spacing_twinty),
                const SizedBox(
                  height: spacing_twinty,
                )
              ],
            ).paddingSymmetric(horizontal: spacing_twinty),
          ),
        ),
      ),
    );
  }
}
