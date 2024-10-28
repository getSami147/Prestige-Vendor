import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prestige_vender/data/network/networkApiServices.dart';
import 'package:prestige_vender/res/appUrl.dart';
import 'package:prestige_vender/viewModel/homeViewModel.dart';
import 'package:prestige_vender/viewModel/userViewModel.dart';
import 'package:provider/provider.dart';

class HomeRepository {
  NetworkApiServices apiServices = NetworkApiServices();

  // <<< Get API's..........................>>> //
  // shopByVendor............
  Future<dynamic> userFindByPrestigeNumber(context, var prestigeNumber) async {
    var provider = Provider.of<UserViewModel>(context, listen: false);
    var headers = {'Authorization': 'Bearer ${provider.accessToken}'};
    try {
      dynamic response = await apiServices.getApi(
          "${AppUrls.urlUserByPrestigeNumber}$prestigeNumber&role=user",
          headers);

      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  // shopByVendor............
  Future<dynamic> shopByVendor(context) async {
final  sp = await SharedPreferences.getInstance();
  var accessToken= sp.getString("accessToken");   
  var vendorId= sp.getString("userId");   
 var headers = {'Authorization': 'Bearer $accessToken'};
    try {
      dynamic response = await apiServices.getApi(
          "${AppUrls.urlShopProductByVendor}${vendorId}", headers);

      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  // getAllPointFormula...........
  Future getAllPointFormula(context) async {
    var provider = Provider.of<UserViewModel>(context, listen: false);
    var headers = {'Authorization': 'Bearer ${provider.accessToken}'};
    try {
      dynamic response =
          await apiServices.getApi(AppUrls.urlPointFormula, headers);
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  // getSingalOrderDetails...........
  Future<dynamic> getSingalOrderDetails(context, String id) async {
    var provider = Provider.of<UserViewModel>(context, listen: false);
    var headers = {'Authorization': 'Bearer ${provider.accessToken}'};
    try {
      dynamic response =
          await apiServices.getApi(AppUrls.urlSingleOrderDetails + id, headers);

      return response;
    } catch (e) {
      throw e.toString();
    }
  }

 

// getAllStatesAPI.....
  Future<dynamic> getAllStatesAPI(context) async {
    try {
      dynamic response = await apiServices.getApi(AppUrls.urlGetAllStates, {});
      return response;
    } catch (e) {
      throw e.toString();
    }
  }



  // getSubCatagires.....
  Future<dynamic> getSubCatagires(context) async {
    var provider = Provider.of<UserViewModel>(context, listen: false);
    var headers = {'Authorization': 'Bearer ${provider.accessToken}'};
    try {
      dynamic response =
          await apiServices.getApi(AppUrls.urlGetAllSubcategory, headers);
      return response;
    } catch (e) {
      throw e.toString();
    }
  }
   // getSubCatByCatagory.....
  Future<dynamic> getSubCatByCatagory(String id,context) async {
    var provider = Provider.of<UserViewModel>(context, listen: false);
    var headers = {'Authorization': 'Bearer ${provider.accessToken}'};
    try {
      dynamic response =
          await apiServices.getApi(AppUrls.urlgetSubCatBYCatagory+id, headers);
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  //getCurrentpointAPI...........
  Future<dynamic> getCurrentpointAPI(context, String id) async {
    var provider = Provider.of<UserViewModel>(context, listen: false);
    var headers = {'Authorization': 'Bearer ${provider.accessToken}'};

    try {
      dynamic response =
          await apiServices.getApi(AppUrls.urlCurrentpoint + id, headers);
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

 // getSingalFeatureProduct...........
  Future<dynamic> getSingalProducts(context, String slug) async {
    var provider = Provider.of<UserViewModel>(context, listen: false);
    var headers = {'Authorization': 'Bearer ${provider.accessToken}'};
    try {
      dynamic response = await apiServices.getApi(
          AppUrls.urlSingleFeatureproduct + slug, headers);

      return response;
    } catch (e) {
      throw e.toString();
    }
  }

   // getMyAccountDetails...........
  Future<dynamic> getMyAccountDetails(context) async {
    var provider = Provider.of<UserViewModel>(context, listen: false);
    var headers = {'Authorization': 'Bearer ${provider.accessToken}'};
    try {
      dynamic response = await apiServices.getApi(
          "${AppUrls.urlMybankDetails}?vendorId=${provider.vendorId}", headers);

      return response;
    } catch (e) {
      throw e.toString();
    }
  }



  //single getoffer Api...........
  Future<dynamic> singlegetoffer(context, String id) async {
    var provider = Provider.of<UserViewModel>(context, listen: false);
    var headers = {'Authorization': 'Bearer ${provider.accessToken}'};
    try {
      dynamic response =
          await apiServices.getApi(AppUrls.urlgetoffer1 + id, headers);
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

//Getallcategoryapi
  Future<dynamic> getallcategory(context) async {
    var provider = Provider.of<UserViewModel>(context, listen: false);
    var headers = {'Authorization': 'Bearer ${provider.accessToken}'};
    try {
      dynamic response = await apiServices.getApi("${AppUrls.urlGetAllCategory}/all", headers);
      return response;
    } catch (e) {
      throw e.toString();
    }
  }
    // getAllCatagires.....
  Future<dynamic> getAllCatagires(context) async {
    var provider = Provider.of<UserViewModel>(context, listen: false);
    var headers = {'Authorization': 'Bearer ${provider.accessToken}'};
    try {
      dynamic response =
          await apiServices.getApi("${AppUrls.urlGetAllCategory}?page=1&limit=100000", headers);
      return response;
    } catch (e) {
      throw e.toString();
    }
  }
  //getAllUsers
  Future<dynamic> getAllUsers(context) async {
    var provider = Provider.of<UserViewModel>(context, listen: false);
    var headers = {'Authorization': 'Bearer ${provider.accessToken}'};
    try {
      dynamic response = await apiServices.getApi(AppUrls.urlGetAllusers, headers);
      return response;
    } catch (e) {
      throw e.toString();
    }
  }
  

  //single getsinglecategory Api...........
  Future<dynamic> singlegetcategory(context, String id) async {
    var provider = Provider.of<UserViewModel>(context, listen: false);
    var headers = {'Authorization': 'Bearer ${provider.accessToken}'};
    try {
      dynamic response =
          await apiServices.getApi(AppUrls.urlgetcategory1 + id, headers);
      return response;
    } catch (e) {
      if (e.toString().contains("Please provide")) {
        throw "Please select the category.";
      }
      throw e.toString();
    }
  }

  //Prestige+ sand OTP for Oder...........
  Future<dynamic> sandOtpBeforeOrder(context, String prestigeNo) async {
    var provider = Provider.of<UserViewModel>(context, listen: false);
    var headers = {'Authorization': 'Bearer ${provider.accessToken}'};
    try {
      dynamic response =
          await apiServices.getApi("${AppUrls.prestigeSandOTP}?prestigeNumber=$prestigeNo&role=user", headers);
      return response;
    } catch (e) {
      throw e.toString();
    }
  }
  
  

   //getAllProducts...........
  Future getAllProducts(context,int page, int limit) async {
    var provider = Provider.of<UserViewModel>(context, listen: false);
    var headers = {'Authorization': 'Bearer ${provider.accessToken}'};
    try {
      dynamic response =
          await apiServices.getApi("${AppUrls.urlGetAllProduct}?page=$page&limit=$limit", headers);
  
      return response;
    } catch (e) {
      throw e.toString();
    }
  }
    //getAllPayment
  Future getAllPayment(context,int page, int limit) async {
    var provider = Provider.of<UserViewModel>(context, listen: false);
    var headers = {'Authorization': 'Bearer ${provider.accessToken}'};
    try {
      dynamic response = await apiServices.getApi("${AppUrls.urlGetAllPayment}?vendorId=${provider.vendorId.toString()}&page=$page&limit=$limit", headers);
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  //getOrdersByuser
  Future<dynamic> getOrdersByShop(context,var myShopId, int page, int limit) async {
    var provider = Provider.of<UserViewModel>(context, listen: false);
    var headers = {'Authorization': 'Bearer ${provider.accessToken}'};
    try {
          // ${provider.vendorId.toString()}

      dynamic response =
          await apiServices.getApi('${AppUrls.urlOrders}?items-shopId=$myShopId&page=$page&limit=$limit',headers);
      return response;
    } catch (e) {
      throw e.toString();
    }
  }
   // getAllNotifications...........
  Future getAllNotifications(context, int page, int limit) async {
    var provider = Provider.of<UserViewModel>(context, listen: false);
    var headers = {'Authorization': 'Bearer ${provider.accessToken}'};
    try {
      dynamic response =
          await apiServices.getApi('${AppUrls.urlNotification}?userId=${provider.vendorId}&page=$page&limit=$limit', headers);
      return response;
    } catch (e) {
      throw e.toString();
    }
  }
     // getMyTransactions...........
  Future getMyTransactions(context, int page, int limit) async {
    var provider = Provider.of<UserViewModel>(context, listen: false);
    var homeviewModel = Provider.of<HomeViewModel>(context, listen: false);
    var headers = {'Authorization': 'Bearer ${provider.accessToken}'};
    try {
      dynamic response =
          await apiServices.getApi("${AppUrls.urlMyTransaction}?shopId=${homeviewModel.myShopId.toString()}&page=$page&limit=$limit", headers);
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

    // VendorGrapgh DashboardAPI...........
  Future vendorGrapghAPI(context) async {
    var homeviewModel = Provider.of<HomeViewModel>(context, listen: false);
    var provider = Provider.of<UserViewModel>(context, listen: false);
    var headers = {'Authorization': 'Bearer ${provider.accessToken}'};
    try {
      dynamic response =
          await apiServices.getApi("${AppUrls.urlVendorGrapgh}${homeviewModel.myShopId}", headers); //ShopIdNeended
      return response;
    } catch (e) {
      throw e.toString();
    }
  }
  Future<dynamic> searchProductRepo(String query, int page,) async {
  final  sp = await SharedPreferences.getInstance();
  var accessToken= sp.getString("accessToken");
    var headers = {'Authorization': 'Bearer $accessToken'};
    try {
      dynamic response = await apiServices.getApi(
          "${AppUrls.urlProductSearch}$query&limit=15&page=$page", headers);
      return response;
    } catch (e) {
      if (kDebugMode) {
        print("repo  error : ${e.toString()}");
      }
      throw e.toString();
    }
  }

//  //searchProductCategory.................................
//   Future<dynamic> searchProduct(int page,String query,var shopId) async {
//     final  sp = await SharedPreferences.getInstance();
//     var accessToken= sp.getString("accessToken");
//     var headers = {'Authorization': 'Bearer $accessToken'};
//     try {
//       dynamic response = await apiServices.getApi(
//           "${AppUrls.urlProductSearch}?shopId=$shopId&$query&limit=15&page=$page", headers);
//       return response;
//     } catch (e) {
//       if (kDebugMode) {
//         print("repo  error : ${e.toString()}");
//       }
//       throw e.toString();
//     }
//   }

    //searchOrders...................................>>
  Future<dynamic> searchOrders(String query, int page,var shopId) async {
    final  sp = await SharedPreferences.getInstance();
    var accessToken= sp.getString("accessToken");
    var headers = {'Authorization': 'Bearer $accessToken'};
    try {
      dynamic response = await apiServices.getApi(
          "${AppUrls.urlorderSearchbyVendor}?shopId=$shopId&q=$query&limit=15&page=$page", headers);
      return response;
    } catch (e) {
      if (kDebugMode) {
        print("repo  error : ${e.toString()}");
      }
      throw e.toString();
    }
  }
    




// hassan get.....................>>

//                  // <<< Post API's==>########################>>> //

//withdrawalPostRequest...........
  Future<dynamic> withdrawalPostRequest(dynamic data,context) async {
    var provider = Provider.of<UserViewModel>(context, listen: false);
 var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${provider.accessToken}'
    };
    try {
      dynamic response = await apiServices.postApi(data,AppUrls.urlWithdrawal, headers);
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  // PlaceOrderAPI...........
  Future<dynamic> placeOrderAPI(Map<String, dynamic> data, context) async {
    var provider = Provider.of<UserViewModel>(context, listen: false);
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${provider.accessToken}'
    };
    try {
      dynamic response =
          await apiServices.postApi(data, AppUrls.urlPlaceOrder, headers);
      return response;
    } catch (e) {
      throw e.toString();
    }
  }
//Create Shope FormData farmat(Post)....................................>>>
  Future createShopAPI(dynamic data, context) async {
    var userViewModel = Provider.of<UserViewModel>(context, listen: false);

    if (kDebugMode) {
      print("data: ${data}");
      print(
          "shopCoverImage: ${userViewModel.shopCoverImage!.absolute.path.toString()}");
      print(
          "shopLogo: ${userViewModel.imageShopLogo!.absolute.path.toString()}");
    }
    var headers = {'Authorization': 'Bearer ${userViewModel.accessToken}'};
    try {
      final response = await apiServices.formDataPostServices(
          AppUrls.urlCreateShop,
          data,
          headers,
          "coverImage",
          (userViewModel.shopCoverImage != null)
              ? userViewModel.shopCoverImage!.absolute.path.toString()
              : null,
          filekey2: "logo",
          filePath2: (userViewModel.imageShopLogo != null)
              ? userViewModel.imageShopLogo!.absolute.path.toString()
              : null);

      return response;
    } catch (e) {
      rethrow;
    }
  }

  //Create Products FormData farmat(Post)....................................>>>
  Future createProductsAPI(dynamic data, context) async {
    var userViewModel = Provider.of<UserViewModel>(context, listen: false);

    // if (kDebugMode) {
    //   print(
    //       "productImage: ${userViewModel.productImage!.absolute.path.toString()}");
    // }
    var headers = {'Authorization': 'Bearer ${userViewModel.accessToken}'};
    try {
      final response = await apiServices.formDataPostServices(
        AppUrls.urlCreateProduct,
        data,
        headers,
        "images",
        (userViewModel.productImage != null)
            ? userViewModel.productImage?.absolute.path.toString()
            : null,
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  // verifyOtpBeforeOrder///
  Future<dynamic> verifyOtpBeforeOrder(Map<String,dynamic> data,context) async {
    var headers = {'Content-Type': 'application/json'};
    try {
      dynamic response = await apiServices.postApi(
          data, AppUrls.urlverifyOtpBeforeOrder, headers);
      return response;
    } catch (e) {
      rethrow;
    }
  }


  //update API's....................................>>>
  //updateOrderStatus API..............................................................>>>
 Future updateOrderStatus(Map<String,String>data,String id,context)async{
    var userViewModel = Provider.of<UserViewModel>(context, listen: false);
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${userViewModel.accessToken}'};
try {
       final response =await apiServices.updateApi(data, AppUrls.urlUpdateStatus+id, headers);
       return response;

} catch (e) {
  rethrow;
}


  }
  //updateShopAPI FormData farmat(Update)....................................>>>
  Future updateShopAPI(dynamic data, String shopId, context) async {
    var userViewModel = Provider.of<UserViewModel>(context, listen: false);
    var headers = {'Authorization': 'Bearer ${userViewModel.accessToken}'};
    try {
      final response = await apiServices.formDataUpdateServices(
          "${AppUrls.urlUpdateShop}$shopId",
          data,
          headers,
          "coverImage",
          (userViewModel.shopCoverImage != null)
              ? userViewModel.shopCoverImage!.absolute.path.toString()
              : null,
          filekey2: "logo",
          filePath2: (userViewModel.imageShopLogo != null)
              ? userViewModel.imageShopLogo!.absolute.path.toString()
              : null);

      return response;
    } catch (e) {
      rethrow;
    }
  }


  //updateShopAPI FormData farmat(Update)....................................>>>
  Future updateProductAPI(dynamic data, String productId, context) async {
    var userViewModel = Provider.of<UserViewModel>(context, listen: false);
    var headers = {'Authorization': 'Bearer ${userViewModel.accessToken}'};
    try {
      final response = await apiServices.formDataUpdateServices(
          "${AppUrls.urlProductUpdate}$productId",
          data,
          headers,
          "images",
          (userViewModel.productImage != null)
              ? userViewModel.productImage!.absolute.path.toString()
              : null);

      return response;
    } catch (e) {
      rethrow;
    }
  }

// hassan update.....................>>

//   // Delete APIs //.......................................................>>>
//    // Delete product api......................................................>>>
  Future<dynamic> deleteProduct(String id, context) async {
    var provider = Provider.of<UserViewModel>(context, listen: false);
    var headers = {'Authorization': 'Bearer ${provider.accessToken}'};
    try {
      dynamic response =
          await apiServices.deleteApi(AppUrls.urlProductDelete + id, headers);
      return response;
    } catch (e) {
      rethrow;
    }
  }

// hassan Delete.....................>>
}
