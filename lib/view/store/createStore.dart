import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prestige_vender/models/getShopModel.dart';
import 'package:prestige_vender/models/getSubcatagriesModel.dart';
import 'package:prestige_vender/utils/Images.dart';
import 'package:prestige_vender/utils/colors.dart';
import 'package:prestige_vender/utils/constant.dart';
import 'package:prestige_vender/utils/string.dart';
import 'package:prestige_vender/utils/widget.dart';
import 'package:prestige_vender/view/GoogleMap/MapLocationSearch.dart';
import 'package:prestige_vender/view/store/addWeekPage.dart';
import 'package:prestige_vender/viewModel/homeViewModel.dart';
import 'package:prestige_vender/viewModel/userViewModel.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../models/getAllStatesModel.dart';

class CreateStore extends StatefulWidget {
  const CreateStore({super.key});

  @override
  State<CreateStore> createState() => _CreateStoreState();
}

class _CreateStoreState extends State<CreateStore> {
  final formkey = GlobalKey<FormState>();
  final shopNameController = TextEditingController();
  final addressContoller = TextEditingController();
  final descriptionController = TextEditingController();
  final locationController = TextEditingController();

  final obSecurePassword = ValueNotifier(true);
  var lat, lng;
  var week;

  var stateId;
  var subCategoryId;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var userViewModel = Provider.of<UserViewModel>(context, listen: false);
    userViewModel.selectedState = null;
    userViewModel.selectedLGAs = null;
    userViewModel.selectedSubsCatagory = null;
    userViewModel.imageShopLogo=null;
    userViewModel.shopCoverImage=null;
    
  }

  @override
  void dispose() {
    addressContoller.dispose();
    shopNameController.dispose();
    locationController.dispose();
    descriptionController.dispose();
    obSecurePassword.dispose();
    addressContoller.dispose();
    shopNameController.dispose();
    locationController.dispose();
    descriptionController.dispose();
    obSecurePassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    debugPrint("build:");

    return Scaffold(
      appBar: AppBar(
        title: text(
          StoredtailScreen_Store,
          fontSize: textSizeNormal,
          fontWeight: FontWeight.w700,
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Form(
          key: formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Banner.......
              Consumer<UserViewModel>(builder: (context, c, child) {
                return Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    // Shop Banner //////////
                    GestureDetector(
                      onTap: () {
                        c.getImageShopBanner();
                      },
                      child: SizedBox(
                        height: MediaQuery.of(context).size.width * 0.5,
                        width: MediaQuery.of(context).size.width,
                        child: c.shopCoverImage == null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.asset(
                                  store,
                                  fit: BoxFit.cover,
                                ))
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.file(
                                  c.shopCoverImage!,
                                  fit: BoxFit.cover,
                                )),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        c.getImageShopBanner();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10),
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            border: Border.all(color: white, width: 2),
                            shape: BoxShape.circle,
                            color: transparentColor),
                        child: const Center(
                          child: Icon(
                            Icons.camera_alt,
                            color: white,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                    // Shop Logo//////////
                    Positioned(
                      bottom: -20,
                      left: 10,
                      child: InkWell(
                        onTap: () {
                          c.getImageShopLogo();
                          print("logo");
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CircleAvatar(
                              radius: size.width * 0.086,
                              backgroundColor: colorPrimary,
                              child: SizedBox(
                                height: size.width * 0.15,
                                width: size.width * 0.15,
                                child: c.imageShopLogo == null
                                    ? ClipOval(
                                        child: Image.asset(
                                        uzrlogo,
                                        fit: BoxFit.cover,
                                      ))
                                    : ClipOval(
                                        child: Image.file(
                                        c.imageShopLogo!,
                                        fit: BoxFit.cover,
                                      )),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                c.getImageShopLogo();
                              },
                              child: const Center(
                                child: Icon(
                                  Icons.camera_alt,
                                  color: white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                );
              }),
              const SizedBox(
                height: spacing_thirty,
              ),
              text(
                "Shop Name",
                fontSize: textSizeSMedium,
              ).paddingTop(spacing_middle),
              CustomTextFormField(
                context,
                controller: shopNameController,
                obscureText: false,
                hintText: "Shope Name",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Shope name';
                  }
                  return null;
                },
              ).paddingTop(spacing_middle),
              text(
                "Address",
                fontSize: textSizeSMedium,
              ).paddingTop(spacing_middle),
              CustomTextFormField(
                context,
                controller: addressContoller,
                keyboardType: TextInputType.streetAddress,
                obscureText: false,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Address';
                  }
                  return null;
                },
                hintText: "Address",
              ).paddingTop(spacing_middle),
              text(
                "States",
                fontSize: textSizeSMedium,
              ).paddingTop(spacing_middle),
              //States.......
              _buildStatesDropdown(context).paddingTop(spacing_middle),
              text(
                "Subcatagory",
                fontSize: textSizeSMedium,
              ).paddingTop(spacing_middle),
              //getSubCatagires.......
              _buildSubCategoryDropdown(context),
              //Location.......
              text(
                "Location",
                fontSize: textSizeSMedium,
              ).paddingTop(spacing_middle),
              Consumer<UserViewModel>(
                builder: (context, userViewModel, child) {
                  return GestureDetector(
                      onTap: () {
                        userViewModel
                            .getLocationAndShowDialog(context)
                            .then((value) => {
                                  showDialog(
                                          context: context,
                                          builder: (context) =>
                                              const MapLocationSearch())
                                      .then((value) {
                                    locationController.text = value[0];
                                    lat = value[1];
                                    lng = value[2];
                                  })
                                });
                      },
                      child: formField(
                        context,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'choose the location';
                          }
                          return null;
                        },
                        "Shop Location",
                        controller: locationController,
                        showBorder: true,
                        isEnabled: false,
                        changeBackground: true,
                      )).paddingTop(spacing_middle);
                },
              ),

              // Select Weeks
              text(
                "Select Week",
                fontSize: textSizeSMedium,
              ).paddingTop(spacing_middle),
              buildDropButton(
                myText: "Select Week",
                onTap: () {
                  showModalBottomSheet(
                    enableDrag: false,
                    isScrollControlled: true,
                    backgroundColor: transparentColor,
                    context: context,
                    builder: (context) => const SelectWeeks(isUpdate: false),
                  ).then((value) {
                    if (value != null) {
                      week = List<Week>.from(value);
                      // print("week: ${jsonEncode(week)}");
                    }
                  });
                },
              ).paddingTop(spacing_middle),
              text(
                "Description",
                fontSize: textSizeSMedium,
              ).paddingTop(spacing_middle),
              CustomTextFormField(
                context,
                maxLines: 5,
                maxLength: 100,
                controller: descriptionController,
                keyboardType: TextInputType.text,
                obscureText: false,
                hintText: "write here...",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please write a description here';
                  }
                  return null;
                },
              ).paddingTop(spacing_middle),
              const SizedBox(
                height: 20.0,
              ),
              Consumer<UserViewModel>(
                builder: (context, userViewModel, child) {
                  return Consumer(
                    builder: (context, value, child) {
                      return elevatedButton(
                        context,
                        onPress: () {
                          if (formkey.currentState!.validate()) {
                            if (userViewModel.imageShopLogo == null) {
                              return utils()
                                  .flushBar(context, "Pick the logo for shop");
                            } else if (userViewModel.shopCoverImage == null) {
                              return utils().flushBar(
                                  context, "Pick the cover image of shop");
                            } else if (week == null) {
                              utils()
                                  .flushBar(context, "Please select the weeks");
                            } else {
                              Map<String, String> data = {
                                'title':
                                    shopNameController.text.toString().trim(),
                                'weeks': jsonEncode(week),
                                'location':
                                    '{"type":"Point","coordinates":[$lat, $lng]}',
                                'vendorId': userViewModel.vendorId.toString(),
                                'subCategoryId': subCategoryId.toString(),
                                'address':
                                    addressContoller.text.toString().trim(),
                                'description': descriptionController.text
                                    .toString()
                                    .trim(),
                                "countryName": "Nigeria",
                                "countryId":
                                    "659312c0bf44441986f6cbb2", // countryId is the Nigeria Static Id Becouse only Nigerian People should use this app
                                "statesId": stateId.toString(),
                                "status": "pending",
                                "statesName":
                                    userViewModel.selectedState.toString(),
                                "LGA": userViewModel.selectedLGAs.toString(),
                                'type': 'Retail',
                              };
                              HomeViewModel().createShopAPI(data, context);
                              // if (kDebugMode) {
                              //   print("data: ${data}");
                              // }
                              // }
                            }
                          }
                        },
                        child: text("Create Shop",
                            color: white, fontWeight: FontWeight.bold),
                      );
                    },
                  );
                },
              ),
              const SizedBox(
                height: 40,
              )
            ],
          ).paddingAll(15),
        ),
      ),
    );
  }

  Widget _buildStatesDropdown(BuildContext context) {
    return FutureBuilder<GetAllStatesModel>(
      future: HomeViewModel().getAllStatesAPI(context),
      builder:
          (BuildContext context, AsyncSnapshot<GetAllStatesModel> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildShimmerDropdown("Choose State");
        } else if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        } else {
          return StatefulBuilder(
            builder: (context, changeState) {
              return Consumer<UserViewModel>(
                builder: (context, userViewModel, child) {
                  return Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            // color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 24,
                                  offset: const Offset(0, 4),
                                  spreadRadius: 0,
                                  color:
                                      const Color(0xff000000).withOpacity(.1))
                            ]),
                        child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            fillColor: white,
                            filled: true,
                            border: InputBorder.none,
                          ),
                          borderRadius: BorderRadius.circular(15),
                          isExpanded: true,
                          hint: text(
                            userViewModel.selectedState ?? "Select the state",
                            fontSize: textSizeSMedium,
                            color: black,
                          ),
                          items: snapshot.data!.data!
                              .map<DropdownMenuItem<String>>((e) {
                            return DropdownMenuItem(
                              onTap: () {
                                changeState(() {
                                  stateId = e.id.toString();
                                });
                              },
                              value: e.name.toString(),
                              child: text(e.name.toString()),
                            );
                          }).toList(),
                          validator: (value) {
                            if (userViewModel.selectedState == null) {
                              return 'Please select the state';
                            }
                            return null;
                          },
                          onChanged: (val) {
                            userViewModel.selectedLGAs = null;

                            userViewModel.setSelectedState(val!);
                          },
                        ),
                      ),
                      userViewModel.selectedState != null
                          ? _buildLGAdropdown(context)
                          : const SizedBox(),
                    ],
                  );
                },
              );
            },
          );
        }
      },
    );
  }

  Widget _buildLGAdropdown(BuildContext context) {
    if (stateId.toString().isEmpty) {
      return const SizedBox();
    }

    return FutureBuilder<GetAllStatesModel>(
      future: HomeViewModel().getAllStatesAPI(context),
      builder:
          (BuildContext context, AsyncSnapshot<GetAllStatesModel> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildShimmerDropdown("Choose LGA");
        } else if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        } else if (snapshot.data!.data!.isEmpty) {
          return text(
            "No LGA found against the Sate",
            fontSize: textSizeSMedium,
            color: redColor,
          ).paddingTop(spacing_middle);
        } else {
          return StatefulBuilder(
            builder: (context, changeState) {
              return Consumer<UserViewModel>(
                builder: (context, userViewModel, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      text(
                        "LGA's",
                        fontSize: textSizeSMedium,
                      ).paddingTop(spacing_middle),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 24,
                                  offset: const Offset(0, 4),
                                  spreadRadius: 0,
                                  color:
                                      const Color(0xff000000).withOpacity(.1))
                            ]),
                        child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                          isExpanded: true,
                          borderRadius: BorderRadius.circular(10),
                          hint: text(
                            userViewModel.selectedLGAs ?? "Select the LGA's",
                            fontSize: textSizeSMedium,
                            color: black,
                          ).paddingLeft(10),
                          items: snapshot.data!.data!
                              .firstWhere((state) =>
                                  state.name == userViewModel.selectedState)
                              .lgAs!
                              .map<DropdownMenuItem<String>>((l) {
                            return DropdownMenuItem(
                              value: l.toString(),
                              child: text(
                                l.toString(),
                              ),
                            );
                          }).toList(),
                          validator: (value) {
                            if (userViewModel.selectedLGAs == null) {
                              return "Please select the LGA's";
                            }
                            return null;
                          },
                          onChanged: (val) {
                            userViewModel.setSelectedLGAs(val!);
                          },
                        ),
                      ),
                    ],
                  );
                },
              ).paddingTop(spacing_middle);
            },
          );
        }
      },
    );
  }

  Widget _buildShimmerDropdown(String hint) {
    return Shimmer.fromColors(
      baseColor: colorPrimary,
      highlightColor: colorPrimary2,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: spacing_middle),
        height: 50,
        width: double.infinity,
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            hint: text(hint, fontSize: textSizeMedium, color: black),
            items: const [],
            onChanged: (value) {},
          ),
        ),
      ),
    ).paddingTop(spacing_middle);
  }

  Widget _buildSubCategoryDropdown(BuildContext context) {
    return FutureBuilder<GetSubCatagriesModel>(
      future: HomeViewModel().getSubCatagires(context),
      builder:
          (BuildContext context, AsyncSnapshot<GetSubCatagriesModel> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildShimmerDropdown("Choose sub-category");
        } else if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        } else if (snapshot.data!.data!.isEmpty) {
          return text(
            "No sub-categories found",
            fontSize: textSizeSMedium,
            color: redColor,
          ).paddingTop(spacing_middle);
        } else {
          return StatefulBuilder(
            builder: (context, changeState) {
              return Consumer<UserViewModel>(
                builder: (context, userViewModel, child) {
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
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                      isExpanded: true,
                      borderRadius: BorderRadius.circular(10),
                      hint: text(
                        userViewModel.selectedSubsCatagory ??
                            "Select the sub category",
                        fontSize: textSizeSMedium,
                        color: black,
                      ).paddingLeft(10),
                      items: snapshot.data!.data!
                          .map<DropdownMenuItem<String>>((e) {
                        return DropdownMenuItem(
                          onTap: () {
                            changeState(() {
                              subCategoryId = e.id;
                            });
                          },
                          value: e.title.toString(),
                          child: text(e.title.toString(),
                                  fontSize: textSizeSMedium)
                              .paddingLeft(10),
                        );
                      }).toList(),
                      validator: (value) {
                        if (userViewModel.selectedSubsCatagory == null) {
                          return 'Please select the sub-category';
                        }
                        return null;
                      },
                      onChanged: (val) {
                        userViewModel.setSelectedSubsCatagory(val!);
                      },
                    ),
                  );
                },
              ).paddingTop(spacing_middle);
            },
          );
        }
      },
    );
  }
}
