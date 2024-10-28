import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prestige_vender/models/VendorGragh.dart';
import 'package:prestige_vender/models/getAllStatesModel.dart';
import 'package:prestige_vender/models/getCatagriesModel.dart';
import 'package:prestige_vender/models/getShopModel.dart';
import 'package:prestige_vender/models/getSubcatagriesModel.dart';
import 'package:prestige_vender/models/subcatagoryByCatagoryModel.dart';
import 'package:prestige_vender/repository/homeRepository.dart';
import 'package:prestige_vender/utils/colors.dart';
import 'package:prestige_vender/utils/widget.dart';
import 'package:prestige_vender/view/dashboard/dashboard.dart';
import 'package:prestige_vender/view/orders/orderVerificationOtp.dart';
import 'package:prestige_vender/view/categories/catageries.dart';
import 'package:prestige_vender/viewModel/categoryViewModel.dart';
import 'package:provider/provider.dart';

class HomeViewModel with ChangeNotifier {
int _limit = 15;
 var myShopId;
 String? shopErrorMessage='';
  List<dynamic> ordersbyUser =[];
  List<dynamic> myNotification =[];
  List<dynamic> myTransactions =[];
  List<dynamic> myProducts =[];
  List<dynamic> myAllPayments =[];

   final homeRepository = HomeRepository();
  bool _pageloading = false;
  bool get pageloading => _pageloading;

//Initial Data Loading...........................
   setPageloading(bool value) {
    _pageloading = value;
    notifyListeners();
  }
  // <<< Get API's==>#########################################################################################
  // shopByVendor..............................................................>>
  Future userFindByPrestigeNumber(var prestigeNumber,BuildContext context) async {
    return homeRepository.userFindByPrestigeNumber(context, prestigeNumber);
  }
// shopByVendor..............................................................>>
  Future<GetShopModel?> shopByVendor(BuildContext context) async {
    try {
      var provider=Provider.of<CategoryViewModel>(context,listen: false);
    dynamic data=await homeRepository.shopByVendor(context);
    myShopId=data["shop"]["_id"].toString();
    provider.myShopId=data["shop"]["_id"].toString();

    notifyListeners();
    // if (kDebugMode) {
    //   print(myShopId);
    // }
    return GetShopModel.fromJson(data);

    } catch (e) {
      shopErrorMessage=e.toString();
      debugPrint('shop error:${e.toString()}');
      notifyListeners();
      return Future.error(e.toString());

    }
    
  }

// getAllPointFormula..............................................................>>
  Future getAllPointFormula(BuildContext context) async {
    return homeRepository.getAllPointFormula(context);
  } 
// getSingalOrderDetails..............................................................>>
  Future getSingalOrderDetails(BuildContext context, String id) async {
    return homeRepository.getSingalOrderDetails(context, id);
  }
 
  // getAllStatesAPI..............................................................>>
  Future<GetAllStatesModel> getAllStatesAPI(context) async {
    try {
    return homeRepository.getAllStatesAPI(context).then((value) async{
    return GetAllStatesModel.fromJson(value);

    });
    } catch (e) {
      return Future.error(e.toString());
      
    }
    
  }
   // getCatagires with Model..............................................................>>
  Future<GetAllCatagriesModel> getAllCatagires(context) async {
    try {
    return homeRepository.getAllCatagires(context).then((value) async{
    return GetAllCatagriesModel.fromJson(value);

    });
    } catch (e) {
   return Future.error(e.toString());
    
    }
  }
  // getSubCatagires..............................................................>>
  Future<GetSubCatagriesModel> getSubCatagires(context) async {
    try {
    return homeRepository.getSubCatagires(context).then((value) async{
    return GetSubCatagriesModel.fromJson(value);

    });
    } catch (e) {
   return Future.error(e.toString());
      
    }
    
  }
    // getSubCatByCatagory..............................................................>>
  Future<GetSubCatByCatagoryModel> getSubCatByCatagory(String id,context) async {
    try {
    return homeRepository.getSubCatByCatagory(id,context).then((value) async{
    return GetSubCatByCatagoryModel.fromJson(value);
    });
    } catch (e) {
   return Future.error(e.toString());
      
    }
   
  }
  // single get API..............................................................>>
  Future singlegetcategory(BuildContext context, String id) async {
  try {
    final response = await homeRepository.singlegetcategory(context, id);
    return response; // Return the successful response
  } catch (error) {
    return Future.error(error.toString()); // Return the error as a Future error
  }
}

  

  // Get Currentpoint API..............................................................>>
  Future getCurrentpointAPI(BuildContext context, String id) async {
    return homeRepository.getCurrentpointAPI(context, id);
  }
  //Prestige+ sand OTP for Oder...........
  Future<dynamic> sandOtpBeforeOrder(context, String prestigeNo) async {
    return await homeRepository.sandOtpBeforeOrder(context, prestigeNo).then((value) {
       // Extract the message
  String message = value["message"];
  
  // Use regex to extract the email address
  RegExp emailRegex = RegExp(r'[\w\.-]+@[\w\.-]+\.\w+');
  String? email = emailRegex.firstMatch(message)?.group(0);
  // Print the extracted email
    if (kDebugMode) {
      print(email);
    }  
      OrderVerificationOtp(email: email, prestigeNo: prestigeNo).launch(context);
      utils().flushBar(context, message);

    });
  }

// GetAllcategory API.
  Future getcategoryapi(BuildContext context) async {
    return homeRepository.getallcategory(context);
  }
  // getAllUsers API.(For getting Admin id)
  Future getAllUsers(BuildContext context) async {
    return homeRepository.getAllUsers(context);
  }

// getSingalProducts..............................................................>>
  Future getSingalProducts(BuildContext context, String slug) async {
    return homeRepository.getSingalProducts(context, slug);
  }

  //getMyAccountDetails..............................................................>>
   Future getMyAccountDetails(BuildContext context) async {
    return homeRepository.getMyAccountDetails(context);
  }

 // getAllProducts..............................................................>>
   Future<void> getAllProducts(int page, BuildContext context) async {
  try {
    setPageloading(true);

    // Fetch data from repository
    dynamic newdata = await homeRepository.getAllProducts(context, page, _limit);
    List<dynamic> data = newdata["data"];
    // Filter products by shopId and check for duplicates
    for (var item in data) {
      if (item['shopId'] == myShopId.toString() &&
          !myProducts.any((existingItem) => existingItem['_id'] == item['_id'])) {
        myProducts.add(item);
      }
    }
setPageloading(false);
    notifyListeners();

    if (kDebugMode) {
      print("myProducts all data: ${myProducts}");
    }
  } catch (e) {
    // Handle error
    if (kDebugMode) {
      print("Error: $e");
    }
  } finally {
    setPageloading(false);
    notifyListeners();
  }
}

//getOrdersByShop...........................................................>>>
Future<List<dynamic>> getOrdersByShop(int page, BuildContext context) async {

  try {
    setPageloading(true);
    dynamic newOrders = await homeRepository.getOrdersByShop(context, myShopId, page, _limit);
    List<dynamic> data = newOrders["data"];

    // Ensure no duplicate data based on a unique identifier, assuming each item has an '_id' field
    for (var item in data) {
      if (!ordersbyUser.any((existingItem) => existingItem["_id"] == item["_id"])) {
        ordersbyUser.add(item);
      }
    }

    if (kDebugMode) {
      print("ordersbyUser: $newOrders");
    }
    setPageloading(false);
    notifyListeners(); // Refresh the UI
    return ordersbyUser;
  } catch (e) {
    // Handle error
    if (kDebugMode) {
      print("Error fetching orders by shop: $e");
    }
    return ordersbyUser; // Return current state in case of error
  } finally {
    setPageloading(false);
    notifyListeners();
  }
}

// getAllNotifications..........................................................>>
  Future<List<dynamic>> getAllNotifications(int page, BuildContext context) async {
  try {
    setPageloading(true);
    dynamic newData = await homeRepository.getAllNotifications(context, page, _limit);
    List<dynamic> data = newData["data"];

    // Ensure no duplicate data based on a unique identifier, assuming each item has an '_id' field
    for (var item in data) {
      if (!myNotification.any((existingItem) => existingItem["_id"] == item["_id"])) {
        myNotification.add(item);
        
      }
    }
    if (kDebugMode) {
      print("Notification: $newData");
    }
     setPageloading(false);
    notifyListeners(); // Refresh the UI
    return myNotification;
  } catch (e) {
    if (kDebugMode) {
      print("Error fetching notifications: $e");
    }

    return myNotification; // Return current state in case of error
  } finally {
    setPageloading(false);
    notifyListeners();
  }
}


 // getMyTransactions API..............................................................>>
 Future<List<dynamic>> getMyTransactions(int page, BuildContext context) async {
  try {
    setPageloading(true);
    dynamic newData = await homeRepository.getMyTransactions(context, page, _limit);
    List<dynamic> data = newData["data"];
    // Ensure no duplicate data based on a unique identifier, assuming each item has an '_id' field
    for (var item in data) {
      if (!myTransactions.any((existingItem) => existingItem["_id"] == item["_id"])) {
        myTransactions.add(item);
      }
    }
    if (kDebugMode) {
      print("myTransactions: $newData");
    }
    notifyListeners(); // Refresh the UI
    return myTransactions;
  } catch (e) {
    if (kDebugMode) {
      print("Error fetching transactions: $e");
    }
    return myTransactions; // Return current state in case of error
  } finally {
     setPageloading(false);
    notifyListeners();
  }
}
//getAllPayment...............................................................>>>
 Future<List<dynamic>> getAllPayment(int page, BuildContext context) async {
    try {
    setPageloading(true);
      dynamic newData = await homeRepository.getAllPayment(context, page, _limit);
      List<dynamic> data = newData["data"];

      // Ensure no duplicate data based on a unique identifier, assuming each item has an '_id' field
      for (var item in data) {
        if (!myAllPayments.any((existingItem) => existingItem["_id"] == item["_id"])) {
          myAllPayments.add(item);
          print("myAllPayments: ${myAllPayments}");
        }
      }
 setPageloading(false);
      return myAllPayments;
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching payments: $e");
      }
      return myAllPayments; // Return current state in case of error
    } finally {
    setPageloading(false);
      notifyListeners();
    }
  }

 // vendorGrapghAPI
 Future<VendorGraghModel> vendorGrapghAPI (context,)async{
  try {
     var a= await shopByVendor(context);
  // print("aaa: ${a}");
  return await homeRepository.vendorGrapghAPI(context).then((value)async {
    // print(value);
    return VendorGraghModel.fromJson(value);
  });
  } catch (e) {
   return Future.error(e.toString());
    
  }
 
 }


  // <<< Post API's ==>#########################################################################################
   // Place order.........................................................>>
  Future placeOrderAPI(Map<String, dynamic> data, BuildContext context) async {
   showDialog(
barrierDismissible: false,  
    context: context,
      builder: (context) => const CustomLoadingIndicator(),
    );   
   await  homeRepository.placeOrderAPI(data, context).then((value) {
      utils().flushBar(context, value["message"].toString());
    var provider=Provider.of<HomeViewModel>(context,listen: false);
      provider.ordersbyUser.clear();
      provider.myTransactions.clear();
      provider.myNotification.clear();
      provider.myAllPayments.clear();
    if (kDebugMode) {
        print('placeOrderAPI: $value');
      }
       Dashboard().launch(context, pageRouteAnimation: PageRouteAnimation.Fade);
    }).onError((error, stackTrace) {
          finish(context); // Close the loading dialog
      if (kDebugMode) {
        print('placeOrderAPI error: ${error}');
      }
      utils().flushBar(context, error.toString(),backgroundColor: dissmisable_RedColor,textColor: whiteColor);
    });
  }

 // withdrawalPostRequest.........................................................>>
  Future withdrawalPostRequest(Map<String, dynamic> data, BuildContext context) async {
   showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => const CustomLoadingIndicator(),
    );   
   await  homeRepository.withdrawalPostRequest(data, context)
   .then((value) {
      utils().flushBar(context, value["message"].toString());
    // if (kDebugMode) {
    //     print('withdrawalPostRequest: $value');
    //   }
    var provider=Provider.of<HomeViewModel>(context,listen: false);
     provider.myAllPayments.clear();
       Dashboard(currentIndex: 0).launch(context, pageRouteAnimation: PageRouteAnimation.Fade);
    }).onError((error, stackTrace) {
          finish(context); // Close the loading dialog
      if (kDebugMode) {
        print('withdrawalPostRequest error: $error');
      }
      utils().flushBar(context, error.toString(),backgroundColor: dissmisable_RedColor,textColor: whiteColor);
    });
  }
// createShopAPI Formdata format...........>>
  Future createShopAPI(dynamic data, BuildContext context) async {
     showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => const CustomLoadingIndicator(),
    );
    await homeRepository.createShopAPI(data, context).then((value) async {
      utils().flushBar(context, value["message"].toString());
      // if (kDebugMode) {
      //   print('value: $value');
      // }
      shopErrorMessage=null;
       Dashboard(currentIndex: 1,).launch(context, pageRouteAnimation: PageRouteAnimation.Fade,isNewTask: true);
   
    }).onError((error, stackTrace) {
      finish(context); // Close the loading dialog
      utils().flushBar(context, error.toString(),backgroundColor: dissmisable_RedColor,textColor: whiteColor);
      if (kDebugMode) {
        print("shop Error: ${error.toString()}");
      }
    });
  }

  // createProductsAPI Formdata format...........>>
Future createProductsAPI(dynamic data, BuildContext context) async {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => const CustomLoadingIndicator(),
  );
  await homeRepository.createProductsAPI(data, context).then((value) async {
      print("Product sucuss res: $value");

    // Assuming `value` contains the created product's data
    myProducts.add(value["data"]);
    notifyListeners();
    // Navigate back to Store Details screen and refresh data
     Dashboard(currentIndex: 1,).launch(context,isNewTask: true);
    utils().flushBar(context, "Your Product Sucussfuly created.");
     }).onError((error, stackTrace) {
    finish(context); // Close the loading dialog
    utils().flushBar(context, error.toString(), backgroundColor: dissmisable_RedColor, textColor: whiteColor);
    if (kDebugMode) {
      print("Product Error: ${error.toString()}");
    }
  });
}
  // verifyOtpBeforeOrder.........................................................>>
  Future verifyOtpBeforeOrder(Map<String,dynamic> data,var prestigeNo, BuildContext context) async {
    homeRepository.verifyOtpBeforeOrder(data, context).then((value) {
      utils().flushBar(context, value["message"]);
      CatageriesScreen(code: prestigeNo).launch(context,isNewTask: true);

    }).onError((error, stackTrace) {
      utils().flushBar(context, error.toString(),backgroundColor: dissmisable_RedColor,textColor: whiteColor);
    });
  }



  // Update APIs  ==>#########################################################################################
  Future updateOrderStatus(Map<String,String> data,String id,context)async{
      showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => const CustomLoadingIndicator(),
    );
    await homeRepository.updateOrderStatus(data, id, context).then((value)async {
       if (kDebugMode) {
        print('order updated: $value');
      }
    var provider=Provider.of<HomeViewModel>(context,listen: false);
      provider.ordersbyUser.clear();
      notifyListeners();
      // await getOrdersByShop(context);
     utils().flushBar(context, "updated");
       Dashboard(currentIndex: 2,).launch(context,isNewTask: true);

    }) .onError((error, stackTrace) {
      finish(context); // Close the loading dialog
      utils().flushBar(context, error.toString(),backgroundColor: dissmisable_RedColor,textColor: whiteColor);
      if (kDebugMode) {
        print("order updated Error: ${error.toString()}");
      }
    });
  }
  // updateMeformData format...........>>
  //updateShopAPI FormData farmat(Update).....................................>>>
   Future updateShopAPI(dynamic data,String shopId, BuildContext context) async {
     showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => const CustomLoadingIndicator(),
    );
    await homeRepository.updateShopAPI(data,shopId, context).then((value)  {
      utils().flushBar(context, value["message"].toString());
      if (kDebugMode) {
        print('shop updated: $value');
      }
     Dashboard(currentIndex: 1,).launch(context,isNewTask: true);
    }).onError((error, stackTrace) {
      finish(context); // Close the loading dialog
      utils().flushBar(context, error.toString(),backgroundColor: dissmisable_RedColor,textColor: whiteColor);
      if (kDebugMode) {
        print("shop update Error: ${error.toString()}");
      }
    });
  }
 //updateProductAPI FormData farmat(Update)
   Future updateProductAPI(dynamic data,String productId, BuildContext context) async {
    var provider=Provider.of<HomeViewModel>(context,listen: false);

     showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => const CustomLoadingIndicator(),
    );
    await homeRepository.updateProductAPI(data,productId, context).then((value) async {
      utils().flushBar(context, value["message"].toString());
      if (kDebugMode) {
        print('Product updated: $value');
      }
       provider.myProducts.clear();
        Dashboard(currentIndex: 1,).launch(context,isNewTask: true);
    }).onError((error, stackTrace) {
      finish(context); // Close the loading dialog
      utils().flushBar(context, error.toString(),backgroundColor: dissmisable_RedColor,textColor: whiteColor);
      if (kDebugMode) {
        print("Product update Error: ${error.toString()}");
      }
    });
  }
 // deleteProduct local Method
  void deleteProduct(String id,context) {
    var p=Provider.of<HomeViewModel>(context,listen: false);
    p.myProducts.removeWhere((product) => product["_id"] == id);
    notifyListeners();
  }

  // Delete APIs  ==>#########################################################################################
  // DeleteMe..............................................................>>
  Future deleteproduct(String id,int index, BuildContext context)
   async {
    var p=Provider.of<HomeViewModel>(context,listen: false);
print("myProducts succuss ${p.myProducts}");
   
     showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => const CustomLoadingIndicator(),
    );
   await homeRepository.deleteProduct(id, context).then((value) async {
     Dashboard(currentIndex: 1,).launch(context,isNewTask: true);
   deleteProduct(id, context);
    utils().flushBar(context, "Product deleted successfully.");
    notifyListeners();

    }).onError((error, stackTrace) {
      finish(context);
      utils().flushBar(context, error.toString(),backgroundColor: dissmisable_RedColor,textColor: whiteColor);
      if (kDebugMode) {
        print(error.toString());
      }
    });
  }

}
