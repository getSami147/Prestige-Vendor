import 'package:flutter/material.dart';
import 'package:prestige_vender/repository/homeRepository.dart';

class SearchProvider extends ChangeNotifier {
 final homerepository = HomeRepository();

  List searchedProducts = [];
  List searchedCategories = [];
  List searchedSubCategories = [];
  List searchedOrders = [];

  bool pageloading = false;
  setPageloading(value) {
    pageloading = value;
    notifyListeners();
  }
  ///searchProductCategory
  // Future searchProducts(int page, query,var shopId) async {
  //   setPageloading(true);
  //   try {
  //     var data = await homerepository.searchProduct(page, query, shopId);
  //     if (page == 1) {
  //       searchedProducts.clear();
  //       searchedProducts = data["products"];
       
  //     } else {
  //       searchedProducts = data["products"];
  //     }
  //   } catch (e) {
  //     if (page == 1) {
  //       searchedProducts.clear();
  //     }
  //   } finally {
  //     setPageloading(false);
  //     notifyListeners();
  //   }
  // }

//searchOrders...................................>>
  Future searchOrders(int page, query,var shopId) async {
    setPageloading(true);
    try {
      var data = await homerepository.searchOrders(query, page, shopId);
// print(data);
      if (page == 1) {
        searchedOrders.clear();
        searchedOrders = data["docs"];
      } else {
        searchedOrders = data["docs"];
        
      }
    } catch (e) {
      if (page == 1) {
        searchedOrders.clear();
      }
    } finally {
      setPageloading(false);
      notifyListeners();
    }
  }
 
}
