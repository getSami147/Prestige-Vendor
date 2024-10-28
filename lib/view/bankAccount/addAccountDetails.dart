import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prestige_vender/utils/colors.dart';
import 'package:prestige_vender/utils/constant.dart';
import 'package:prestige_vender/utils/string.dart';
import 'package:prestige_vender/utils/widget.dart';
import 'package:prestige_vender/view/bankAccount/editAccountDetails.dart';
import 'package:prestige_vender/viewModel/authViewModel.dart';
import 'package:prestige_vender/viewModel/userViewModel.dart';
import 'package:provider/provider.dart';

class AddAccountDetails extends StatefulWidget {
  const AddAccountDetails({super.key});

  @override
  State<AddAccountDetails> createState() => _AddAccountDetailsState();
}

class _AddAccountDetailsState extends State<AddAccountDetails> {
  final _formkey = GlobalKey<FormState>();
  final bankNameController = TextEditingController();
  final iBNController = TextEditingController();
  final branchCodeController = TextEditingController();
  final swiftCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: text("Account Details", fontWeight: FontWeight.bold),
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
              elevatedButton(context,
                  child: text(
                    "Submit",
                    fontWeight: FontWeight.bold,
                    color: white,
                    fontSize: textSizeMedium,
                  ), onPress: () {
                var userViewModel =
                    Provider.of<UserViewModel>(context, listen: false);

                if (_formkey.currentState!.validate()) {
                  Map<String, dynamic> data = {
                    "vendorId": userViewModel.vendorId.toString(),
                    "bankName": bankNameController.text.trim().toString(),
                    "ibanNumber": iBNController.text.trim().toString(),
                    "branchCode": branchCodeController.text.trim().toString(),
                    "swiftCode": swiftCodeController.text.trim().toString(),
                    "isActive": true
                  };
                  AuthViewModel().postBankAccountDetails(data, context);
                } else {
                  debugPrint("not validate");
                }
              }).paddingBottom(20.0)
            ],
          ).paddingAll(20.0),
        ),
      ),
    );
  }
}
