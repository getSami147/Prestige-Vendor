import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prestige_vender/utils/Images.dart';
import 'package:prestige_vender/utils/colors.dart';
import 'package:prestige_vender/utils/constant.dart';
import 'package:prestige_vender/utils/string.dart';
import 'package:prestige_vender/utils/widget.dart';
import 'package:prestige_vender/view/bankAccount/addAccountDetails.dart';
import 'package:prestige_vender/view/bankAccount/deleteBankAccountDetails%20.dart';
import 'package:prestige_vender/view/bankAccount/editAccountDetails.dart';
import 'package:prestige_vender/view/profile/profileScreen.dart';
import 'package:prestige_vender/viewModel/homeViewModel.dart';

class MyAccountDetails extends StatefulWidget {
  const MyAccountDetails({super.key});

  @override
  State<MyAccountDetails> createState() => _MyAccountDetailsState();
}

class _MyAccountDetailsState extends State<MyAccountDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          const AddAccountDetails().launch(context);
        },
      ),
      appBar: AppBar(
        title: text("Bank Account Details", fontWeight: FontWeight.bold),
      ),
      body: FutureBuilder(
        future: HomeViewModel().getMyAccountDetails(context),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CustomLoadingIndicator());
          } else if (snapshot.hasError) {
            return Center(child: text(snapshot.error.toString()));
          } else {
            // print(data);
            return snapshot.data["data"]==null||snapshot.data["data"].isEmpty?
            Center(
             child: text("Please add your bank account details\nby clicking the add button",maxLine: 5,isCentered: true),
            ):
            ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: snapshot.data["data"].length,
              itemBuilder: (context, index) {
                var data = snapshot.data["data"][index];

                return Center(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 24,
                                offset: const Offset(0, 4),
                                spreadRadius: 0,
                                color: const Color(0xff333333).withOpacity(.10))
                          ]),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ProfileDetailContainer(
                                leadingIcon: svg_bank,
                                title: "Bank Name",
                                subtitle: data["bankName"].toString(),
                              ),
                              PopupMenuButton<String>(padding: const EdgeInsets.only(left: 40),
                                onSelected: (String result) {
                                  switch (result) {
                                    case 'Edit':
                                      // ignore: prefer_const_constructors
                                      EditAccountDetails(accountDetails: data)
                                          .launch(context);
                                          // .then((value) {
                                          //   HomeViewModel().getMyAccountDetails(context);
                                          //   setState(() {
                                              
                                          //   });
                                          // });
                                      break;
                                    case 'Delete':
                                      showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (context) {
                                          // Delete Page (Dialog Box) is Called.............>>>
                                          return DeleteBankAccountDetails(
                                              accountId:
                                                  data["_id"].toString());
                                        },
                                      );
                                      break;
                                  }
                                },
                                itemBuilder: (BuildContext context) =>
                                    <PopupMenuEntry<String>>[
                                  PopupMenuItem<String>(
                                    value: 'Edit',
                                    child: ListTile(
                                      leading: const Icon(
                                        Icons.edit,
                                        size: 20,
                                        color: colorPrimary,
                                      ),
                                      title: text('Edit',
                                          color: colorPrimary,
                                          fontSize: textSizeSMedium),
                                    ),
                                  ),
                                  PopupMenuItem<String>(
                                    value: 'Delete',
                                    child: ListTile(
                                      leading: const Icon(
                                        Icons.delete,
                                        size: 20,
                                        color: dissmisable_RedColor,
                                      ),
                                      title: text('Delete',
                                          color: dissmisable_RedColor,
                                          fontSize: textSizeSMedium),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          ProfileDetailContainer(
                            leadingIcon: svg_password,
                            title: "Branch Code",
                            subtitle: data["branchCode"].toString(),
                          ),
                          ProfileDetailContainer(
                            leadingIcon: svg_password,
                            title: "IBN Number",
                            subtitle: data["ibanNumber"].toString(),
                          ),
                          ProfileDetailContainer(
                            leadingIcon: svg_password,
                            title: "Swift Code",
                            subtitle: data["swiftCode"].toString(),
                          ),
                        ],
                      )
                          .paddingSymmetric(horizontal: spacing_standard_new)
                          .paddingOnly(bottom: spacing_standard_new),
                    )
                        .paddingTop(spacing_middle)
                        .paddingSymmetric(horizontal: spacing_standard_new),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
