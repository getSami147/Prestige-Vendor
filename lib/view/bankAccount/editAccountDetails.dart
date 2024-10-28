import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prestige_vender/utils/constant.dart';
import 'package:prestige_vender/utils/string.dart';
import 'package:prestige_vender/utils/widget.dart';
import 'package:prestige_vender/viewModel/authViewModel.dart';
import 'package:prestige_vender/viewModel/userViewModel.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class EditAccountDetails extends StatefulWidget {
  var accountDetails;
  EditAccountDetails({required this.accountDetails, super.key});

  @override
  State<EditAccountDetails> createState() => _EditAccountDetailsState();
}

class _EditAccountDetailsState extends State<EditAccountDetails> {
  final _formkey = GlobalKey<FormState>();
  final bankNameController = TextEditingController();
  final iBNController = TextEditingController();
  final branchCodeController = TextEditingController();
  final swiftCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bankNameController.text = widget.accountDetails["bankName"].toString();
    iBNController.text = widget.accountDetails["branchCode"].toString();
    branchCodeController.text = widget.accountDetails["ibanNumber"].toString();
    swiftCodeController.text = widget.accountDetails["swiftCode"].toString();
    return Scaffold(
      appBar: AppBar(
        title: text("Edit Account Details", fontWeight: FontWeight.bold),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              text(
                bank_name,
                                 fontSize: textSizeSMedium,

              ).paddingTop(spacing_middle),
              CustomTextFormField(
                context,
                hintText: bank_name,
                controller: bankNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your bank name';
                  }
                  return null;
                },
              ).paddingTop(spacing_middle),
              text(
                ibnNumber,
                                 fontSize: textSizeSMedium,

              ).paddingTop(spacing_middle),
              CustomTextFormField(
                context,
                hintText: ibnNumber,
                controller: iBNController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your IBN Number';
                  }
                  return null;
                },
              ).paddingTop(spacing_middle),
              text(
                branchCode,
                                 fontSize: textSizeSMedium,

              ).paddingTop(spacing_middle),
              CustomTextFormField(
                context,
                keyboardType: TextInputType.number,
                hintText: branchCode,
                controller: branchCodeController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your IBN Number';
                  }
                  return null;
                },
              ).paddingTop(spacing_middle),
              text(
                swiftCode,
                                fontSize: textSizeSMedium,

              ).paddingTop(spacing_middle),
              CustomTextFormField(
                context,
                keyboardType: TextInputType.emailAddress,
                hintText: swiftCode,
                controller: swiftCodeController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter bank swift code';
                  }
                  return null;
                },
              ).paddingTop(spacing_middle),
              const SizedBox(
                height: 30,
              ),
              Consumer<AuthViewModel>(
                builder: (context, value, child) {
                  var userViewModel=Provider.of<UserViewModel>(context,listen: false);
                  return elevatedButton(
                      loading: value.loading,
                      context,
                      child: text(
                        "Update",
                        fontWeight: FontWeight.bold,
                        color: white,
                        fontSize: textSizeMedium,
                      ), onPress: () {
                    if (_formkey.currentState!.validate()) {
                      Map<String, dynamic> data = {
                        "vendorId": userViewModel.vendorId.toString(),
                        "bankName":bankNameController.text.trim().toString(),
                        "ibanNumber": iBNController.text.trim().toString(),
                        "branchCode": branchCodeController.text.trim().toString(),
                        "swiftCode":swiftCodeController.text.trim().toString(),
                         "isActive": true
                      };
                      AuthViewModel().updateBankAccountDetails(data,
                          widget.accountDetails["_id"].toString(), context);
                    } else {
                      debugPrint("not validate");
                    }
                  }).paddingBottom(20.0);
                },
              )
            ],
          ).paddingAll(20.0),
        ),
      ),
    );
  }
}
