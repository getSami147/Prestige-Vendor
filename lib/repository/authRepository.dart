import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:prestige_vender/data/network/networkApiServices.dart';
import 'package:prestige_vender/res/appUrl.dart';
import 'package:prestige_vender/viewModel/userViewModel.dart';

class AuthRepository {
  NetworkApiServices apiServices = NetworkApiServices();

// Get APIs ==>########################################################################################
  // getMe API...........
  Future<dynamic> getMeApi(context) async {
    try {
      dynamic response = await apiServices.getApi(AppUrls.urlGetMe, {
        'Authorization':
            'Bearer ${Provider.of<UserViewModel>(context, listen: false).accessToken}'
      });
      return response;
    } catch (e) {
      rethrow;
    }
  }


  //
// Post APIs  ==>######################################################################################
  //login...........
  Future<dynamic> loginApi(Map<String, dynamic> data) async {
    var headers = {'Content-Type': 'application/json'};
    try {
      dynamic response =
          await apiServices.postApi(data, AppUrls.urlLogin, headers);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // verifyOTP Account///
  Future<dynamic> verifyOTP(Map<String,dynamic> data,context) async {
    var headers = {'Content-Type': 'application/json'};
    try {
      dynamic response = await apiServices.postApi(
          data, AppUrls.urlVerfityaccountOTP, headers);
      return response;
    } catch (e) {
      rethrow;
    }
  }

    // verifyOTP Account///
  Future<dynamic> resandOTP(Map<String,String> data,context) async {
    var headers = {'Content-Type': 'application/json'};
    try {
      dynamic response = await apiServices.postApi(
          data, AppUrls.urlResandOTP, headers);
      return response;
    } catch (e) {
      rethrow;
    }
  }
      // PostBankAccountDetails
  Future<dynamic> postBankAccountDetails(Map<String,dynamic> data, context) async {
var provider = Provider.of<UserViewModel>(context, listen: false);

      var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${provider.accessToken}'
    };    try {
      dynamic response = await apiServices.postApi(
          data,AppUrls.urlMybankDetails, headers);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  //signUp in FormData farmat....................................>>>
  Future signUpformData(Map<String,String>data,context) async {
    var userViewModel = Provider.of<UserViewModel>(context, listen: false);

      var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${userViewModel.accessToken}'
    };
    try {
      final response = await apiServices.formDataPostServices(
          AppUrls.urlSignUp, data, headers, "image", (userViewModel.image != null)?userViewModel.image!.path.toString():null);
      return response; 
    } catch (e) {
      rethrow;
    }
  }

  // //signUp...........
  // Future<dynamic> signUpApi(dynamic data, Map<String, String> headers) async {
  //   try {
  //     dynamic response =
  //         await apiServices.postApi(data, AppUrls.urlSignUp, headers);
  //     return response;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
  // logoutApi API...........
  Future<dynamic> logOutApi(Map<String,dynamic> data,context) async {
    var provider = Provider.of<UserViewModel>(context, listen: false);

      var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${provider.accessToken}'
    };
    try {
      dynamic response =
          await apiServices.postApi(data, AppUrls.urlLogOut, headers);
      return response;
    } catch (e) {
      rethrow;
    }
  }
  // forgot Password API...........
  Future<dynamic> forgotApi(dynamic data) async {
    var headers = {
  'Content-Type': 'application/json'
};
    try {
      dynamic response = await apiServices.postApi(data,AppUrls.urlForgotPassword, headers);
      return response;
    } catch (e) {
      rethrow;
    }
  }
  
  // // Rest Password Api...........
  // Future<dynamic> restPasswordApi(dynamic data,Map<String, String> headers) async {
  //   try {
  //     dynamic response = await apiServices.postApi(data,AppUrls.urlResetPassword, headers);
  //     return response;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }


  // Update Me API ==> ######################################################################################
  // updateDeviceToken.................................................>>
  Future<dynamic> updateDeviceToken(Map<String,dynamic> data,String accessToken, context) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };
    try {
      dynamic response = await apiServices.updateApi(
          data, AppUrls.urlDevicetoken, headers);
      return response;
    } catch (e) {
      rethrow;
    }
  }
   // Update Me Profile.................................................>>
  Future<dynamic> completeProfile(Map<String,dynamic> data, context) async {
    var provider = Provider.of<UserViewModel>(context, listen: false);
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${provider.preloginToken}'
    };
    if (kDebugMode) {
    print("preloginToken:${provider.preloginToken}");
    print("pre data:${data}");
    print("headers:${headers}");

    }
    try {
      dynamic response = await apiServices.updateApi(
          data, AppUrls.urlCompleteProfile, headers);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Update Password.................................................>>
   Future<dynamic> changePassword(dynamic data, context) async {
    var provider = Provider.of<UserViewModel>(context, listen: false);
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${provider.accessToken}'
    };
    try {
      dynamic response = await apiServices.updateApi(
          data, AppUrls.urlupdatePassword, headers);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  
  //updateBankAccountDetails.................................................>>
   Future<dynamic> updateBankAccountDetails(dynamic data,String id, context) async {
    var provider = Provider.of<UserViewModel>(context, listen: false);
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${provider.accessToken}'
    };
    try {
      dynamic response = await apiServices.updateApi(
          data, "${AppUrls.urlMybankDetails}/$id", headers);
      return response;
    } catch (e) {
      rethrow;
    }
  }
 
  //updateMeformData farmat....................................>>>
  Future updateMeformData(Map<String,String>data,context) async {
    var userViewModel = Provider.of<UserViewModel>(context, listen: false);
var headers = {
  'Authorization': 'Bearer ${userViewModel.accessToken}'
};    
try {
      final response = await apiServices.formDataUpdateServices(
          AppUrls.urlUpdateMe, data, headers, "image", (userViewModel.image != null)?userViewModel.image!.path.toString():null);
      return response; 
    } catch (e) {
      rethrow;
    }
  }
  

  // Delete APIs ==>######################################################################################
  // Delete Me api......................................................>>>
  Future<dynamic> deleteMe(context) async {
    var provider = Provider.of<UserViewModel>(context, listen: false);
    var headers = {'Authorization': 'Bearer ${provider.accessToken}'};
    try {
      dynamic response =
          await apiServices.deleteApi(AppUrls.urlDeleteMe, headers);
      return response;
    } catch (e) {
      rethrow;
    }
  }

    // delete Bank Account Details......................................................>>>
  Future<dynamic> deleteBankAccountDetails(context,String id) async {
    var provider = Provider.of<UserViewModel>(context, listen: false);
    var headers = {'Authorization': 'Bearer ${provider.accessToken}'};
    try {
      dynamic response =
          await apiServices.deleteApi("${AppUrls.urlMybankDetails}/$id", headers);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
