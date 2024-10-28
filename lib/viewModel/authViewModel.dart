import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prestige_vender/utils/colors.dart';
import 'package:prestige_vender/view/authView/alldone.dart';
import 'package:prestige_vender/view/authView/completeProfileScreen.dart';
import 'package:prestige_vender/view/authView/welcomescreen.dart';
import 'package:prestige_vender/viewModel/services/notificationServices.dart';
import 'package:provider/provider.dart';
import 'package:prestige_vender/repository/authRepository.dart';
import 'package:prestige_vender/utils/widget.dart';
import 'package:prestige_vender/view/authView/logIn.dart';
import 'package:prestige_vender/view/authView/otpVerification.dart';
import 'package:prestige_vender/view/authView/restPassword.dart';
import 'package:prestige_vender/viewModel/userViewModel.dart';
import 'package:http/http.dart' as http;

import '../view/dashboard/dashboard.dart';


class AuthViewModel with ChangeNotifier {
  String? deviceToken;
  final authRepository = AuthRepository();
  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
// Get APIs ==> ###########################################################################################
  // getMeApi..............................................................>>

//getMeApi
  Future<void> getMeApi(
    BuildContext context,
  ) async {
    return authRepository.getMeApi(context);
  }

// Post APIs ==> #########################################################################################
// signUP API Formdata format...........>>
  Future signUpformData(Map<String,String>data, BuildContext context) async {
    setLoading(true);
    await authRepository.signUpformData(data, context).then((value) async {
      final SharedPreferences sp = await SharedPreferences.getInstance();
      //pre login Token For complete Profile or signUp details
      sp.setString("preloginToken", value["token"]["access"]["token"].toString());
      if (kDebugMode) {
        print('value: $value');
      }
      setLoading(false);
      OtpVerification(
        email: data["email"],
      ).launch(context, pageRouteAnimation: PageRouteAnimation.Fade);
    }).onError((error, stackTrace) {
      setLoading(false);
      utils().flushBar(context, error.toString(),backgroundColor: dissmisable_RedColor,textColor: whiteColor);
      if (kDebugMode) {
        print("SignUp Error: ${error.toString()}");
      }
    });
  }

// Login API..............................................................>>
  Future<void> loginApi(Map<String, dynamic> data, BuildContext context) async {
    setLoading(true);
    authRepository.loginApi(data).then((value) async {
      final SharedPreferences sp = await SharedPreferences.getInstance();
      //pre login Token For complete Profile or signUp
      sp.setString("preloginToken", value["token"]["access"]["token"].toString());
    
     if (value["user"]["isProfileCompleted"] == false) {
        setLoading(false);
        const CompleteProfileScreen().launch(context);
      } else if(value["user"]["role"]=="vendor"){
      sp.setString("accessToken", value["token"]["access"]["token"].toString());
      sp.setString("refreshToken", value["token"]["refresh"]["token"].toString());
      sp.setString("userId", value["user"]["_id"].toString());
      sp.setString("name", value["user"]["name"].toString());
      sp.setString("email", value["user"]["email"].toString());
      sp.setString("DOB",value["user"]["DOB"].toString());
      sp.setString("contact", value["user"]["contact"].toString());
      sp.setString("userImageURl", value["user"]["image"].toString());
      sp.setString("referralCode", value["user"]["referralCode"]);
      sp.setString("prestigeNumber", value["user"]["prestigeNumber"]);      
      sp.setBool("isProfileCompleted", value["user"]["isProfileCompleted"]);
      // sp.setBool("Membership", value["user"]["Membership"]);
        setLoading(false);
        // ignore: use_build_context_synchronously
        updateDeviceToken(value["token"]["access"]["token"].toString(), context);
      }
      else {
      setLoading(false);
      utils().flushBar(context, "You can only login with a vendor account.");
         
      }
    }).onError((error, stackTrace) {
      setLoading(false);
      if (kDebugMode) {
        print("Login debug:  ${error.toString()}");
      }
      utils().flushBar(context, error.toString(),backgroundColor: dissmisable_RedColor,textColor: whiteColor);
      if (error.toString().contains("Please verify")) {
        if (kDebugMode) {
          print("Launching OTP verification...");
        }
        OtpVerification(email: data["email"]).launch(context);
      }
    });
  }

  // verifyOTP.........................................................>>
  Future verifyOTP(Map<String,dynamic> data, BuildContext context) async {
    setLoading(true);
    authRepository.verifyOTP(data, context).then((value) {
      utils().flushBar(context, value["message"]);
      setLoading(false);
      const CompleteProfileScreen().launch(context,
          pageRouteAnimation: PageRouteAnimation.Fade, isNewTask: true);
    }).onError((error, stackTrace) {
    setLoading(false);
      if (kDebugMode) {
        print("OTP verify debug:  ${error.toString()}");
      }
      utils().flushBar(context, error.toString(),backgroundColor: dissmisable_RedColor,textColor: whiteColor);
    });
  }

  // ResendOTP.........................................................>>
  Future<void> resandOTP(String email, BuildContext context) async {
    Map<String,String> data={
      "email": email,
    };
    authRepository.resandOTP(data, context).then((value) {
      utils().flushBar(context, value["message"]);
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print("resandOTP debug:  ${error.toString()}");
      }
      utils().flushBar(context, error.toString(),backgroundColor: dissmisable_RedColor,textColor: whiteColor);
    });
  }

    // ResendOTP.........................................................>>
  Future postBankAccountDetails(Map<String,dynamic>data, BuildContext context) async {
       showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => const CustomLoadingIndicator(),
    );  
    authRepository.postBankAccountDetails(data, context).then((value) {
      utils().flushBar(context, value["message"]);
    Dashboard().launch(context, pageRouteAnimation: PageRouteAnimation.Fade);

    }).onError((error, stackTrace) {
      finish(context);
      if (kDebugMode) {
        print("resandOTP debug:  ${error.toString()}");
      }
      utils().flushBar(context, error.toString(),backgroundColor: dissmisable_RedColor,textColor: whiteColor);
    });
  }

  // logOutApi..............................................................>>
  Future<void> logOutApi(Map<String, dynamic> data, BuildContext context) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => const CustomLoadingIndicator(),
    );
    var userViewModel=Provider.of<UserViewModel>(context,listen: false);
    authRepository.logOutApi(data,context).then((value) {
      // print("LogOut response:  ${value.toString()}");
      userViewModel.remove(context);
      const LoginScreen().launch(
        context,
        pageRouteAnimation: PageRouteAnimation.Fade,
        isNewTask: true,
      );
      utils().flushBar(context, value["message"].toString());
    }).onError((error, stackTrace) {
      finish(context);
      if (kDebugMode) {
        print("LogOut error:  ${error.toString()}");
      }
      utils().flushBar(context, error.toString(),backgroundColor: dissmisable_RedColor,textColor: whiteColor);
    });
  }

  // forgot Password Api..............................................................>>
  Future<void> forgotApi(var email, BuildContext context) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => const CustomLoadingIndicator(),
    );
    authRepository.forgotApi({
      "email": email,
    }).then((value) {
      finish(context);
      utils().flushBar(context, value["message"].toString());
if (kDebugMode) {
  print(value["message"].toString());
}
      const ResetPassword().launch(
        context,
        pageRouteAnimation: PageRouteAnimation.Fade,
      );
    }).onError((error, stackTrace) {
      finish(context);
      utils().flushBar(context, error.toString(),backgroundColor: dissmisable_RedColor,textColor: whiteColor);
    });
  }

  // Update APIs ==>#########################################################################################
   //updateDeviceToken..............................................................>>
  Future updateDeviceToken(String accessToken ,BuildContext context) async {
  deviceToken= await NotificationServices().getToken(context);

    // var provider = Provider.of<UserViewModel>(context, listen: false);
    Map<String,dynamic> data={
    "deviceToken":deviceToken.toString()
};
    authRepository.updateDeviceToken(data, accessToken, context) .then((value) async {
      if (kDebugMode) {
        print("updateDeviceToken: ${value["data"]["deviceToken"]}");
      }
      
     //Dashboard
       Dashboard().launch(
          context,
          pageRouteAnimation: PageRouteAnimation.Fade,
          isNewTask: true,
        );
        // ignore: use_build_context_synchronously
        utils().flushBar(context, "Congrats! Your are succussfully logined");
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print("updateDeviceToken error: $error");
      }
      utils().flushBar(context, error.toString(),backgroundColor: dissmisable_RedColor,textColor: whiteColor);
    });
  }
  
  //completeProfile..............................................................>>
  Future completeProfile(Map<String,dynamic> data, BuildContext context) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => const CustomLoadingIndicator(),
    );
    authRepository.completeProfile(data, context).then((value) async {
      if (value["message"].toString().contains("No document")) {
      finish(context); // Close the loading dialog
      utils().flushBar(context, value["message"].toString());

      }else{
         if (kDebugMode) {
        print("completeProfile: ${value}");
        
      }
         finish(context); // Close the loading dialog
      Alldonescreen(
        value: value,
      ).launch(context,
          pageRouteAnimation: PageRouteAnimation.Fade);
      }
      // utils().flushBar(context, "Congrats you are Profile has been Updated");
    }).onError((error, stackTrace) {
      finish(context); // Close the loading dialog
      if (kDebugMode) {
        print("completeProfile error: $error");
      }
      utils().flushBar(context, error.toString(),backgroundColor: dissmisable_RedColor,textColor: whiteColor);
    });
  }

  //changePassword..............................................................>>
  Future changePassword(dynamic data, BuildContext context) async {
    setLoading(true);
  await  authRepository.changePassword(data, context).then((value) async {
      if (kDebugMode) {
        print("updatePassword: ${value}");
      }
       Dashboard().launch(context,
          isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
      setLoading(false);
      // utils().flushBar(context, "Congrats you are Profile has been Updated");
    }).onError((error, stackTrace) {
      setLoading(false);
      if (kDebugMode) {
        print("updatePassword error: $error");
      }
      utils().flushBar(context, error.toString(),backgroundColor: dissmisable_RedColor,textColor: whiteColor);
    });
  }

  
  //updateBankAccountDetails..............................................................>>
  Future updateBankAccountDetails(dynamic data,String id, BuildContext context) async {
      showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => const CustomLoadingIndicator(),
    ); 
    setLoading(true);
   await authRepository.updateBankAccountDetails(data, id, context).then((value) async {
      if (kDebugMode) {
        debugPrint("updateBankAccountDetails: ${value}");
      }
      setLoading(false);
      utils().flushBar(context, "Congratulations! Your bank account details have been updated successfully");
      // finish(context);
      Dashboard().launch(context,isNewTask: true);
    }).onError((error, stackTrace) {
      finish(context);
      setLoading(false);
      if (kDebugMode) {
        print("updateBank error: $error");
      }
      utils().flushBar(context, error.toString(),backgroundColor: dissmisable_RedColor,textColor: whiteColor);
    });
  }

// updateMeformData format...........>>
  Future updateMeformData(Map<String,String> data,BuildContext context) async {
     showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => const CustomLoadingIndicator(),
    );
    await authRepository.updateMeformData(data, context).then((value) async {
      final SharedPreferences sp = await SharedPreferences.getInstance();
      sp.setString("name", value["data"]["name"].toString());
      sp.setString("userImageURl", value["data"]["image"].toString());
      sp.setString("DOB",value["data"]["DOB"].toString());
      sp.setString("contact", value["data"]["contact"].toString());
      if (kDebugMode) {
        print('value: $value');
      }
      finish(context); // Close the loading dialog
       Dashboard(currentIndex: 3,).launch(context,isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
    }).onError((error, stackTrace) {
      finish(context); // Close the loading dialog
      utils().flushBar(context, error.toString(),backgroundColor: dissmisable_RedColor,textColor: whiteColor);
      if (kDebugMode) {
        print("Update Profile Error: ${error.toString()}");
      }
    });
  }

  // Delete APIs ==>#########################################################################################
 // DeleteMe..............................................................>>
  Future<void> deleteMe(BuildContext context) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => const CustomLoadingIndicator(),
    );
    authRepository.deleteMe(context).then((value) async {
        if (kDebugMode) {
          print("deleteMe response: ${value.toString()}");
        }
       UserViewModel().remove(context);
      const Welcomescreen().launch(context,
          isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
      utils().flushBar(context, value["message"]);
    }).onError((error, stackTrace) {
      finish(context);
      utils().flushBar(context, error.toString(),backgroundColor: dissmisable_RedColor,textColor: whiteColor);
    });
  }

   // Delete My Bank Account Details..............................................................>>
  Future<void> deleteBankAccountDetails(BuildContext context,String id) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => const CustomLoadingIndicator(),
    );
    authRepository.deleteBankAccountDetails(context, id).then((value) async {
        if (kDebugMode) {
          print("delete banke details response: ${value.toString()}");
        }
       Dashboard().launch(context,
          isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
      utils().flushBar(context, value["message"]);
    }).onError((error, stackTrace) {
      finish(context);
      utils().flushBar(context, error.toString(),backgroundColor: dissmisable_RedColor,textColor: whiteColor);
    });
  }

resetPasswordAPI(var password,var token)async{
  var headers = {
  'Content-Type': 'application/json'
};
var request = http.Request('POST', Uri.parse('http://107.22.75.33:3000/api/auth/resetpassword/$token'));
request.body = json.encode({
  "password":password
});
request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  // print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}

}

}
