import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prestige_vender/utils/widget.dart';
import 'package:prestige_vender/view/authView/logIn.dart';
import 'package:prestige_vender/view/dashboard/dashboard.dart';
import 'package:prestige_vender/viewModel/homeViewModel.dart';
import 'package:provider/provider.dart';

class UserViewModel with ChangeNotifier {

var userId;
var adminId;
var userName;
var userEmail;
var userContact;
var pointFormulaEarnPoint;
var redemptionPointsN;
//Current coordinates//..........................................
  double mylat = 0.0;
  double mylng = 0.0;
  // AddToCart..................................................
  List<Map<String, dynamic>> cartList = [];
  int quantity = 1;
  var totalCartNira;
  var subPrice;
  // var cartTotalPoints;

// Remove Products by Index from Cart...........................
  void removeFromCart(int index) {
    cartList.removeAt(index);
    utils().toastMethod("Product is remove form cart");
    // notifyListeners();
  }

  //clear the whole Cart.........................................
  void clearCart() {
    cartList.clear();
    utils().toastMethod("The cart is cleared");
    // notifyListeners();
  
  }
//updateCartPrices................................................
  void updateCartPrices() {
    totalCartNira=0;
    for (int i = 0; i <cartList.length; i++) {
      subPrice = cartList[i]['quantity'] *cartList[i]["price"];
      totalCartNira = totalCartNira + subPrice;
      if (kDebugMode) {
        print(cartList[i]['quantity']);
        print("subPrice: ${subPrice}");
        print("total: ${totalCartNira}");
      }
      notifyListeners();
    }
  }

// Calander Select date///............................................
  DateTime selectedDate = DateTime.now();
  void setSelectedDate(DateTime date) {
    selectedDate = date;
    if (kDebugMode) {
      print(selectedDate);
    }
    notifyListeners();
  }

// Image Picker Profile................................................
  File? _image;
  File? get image => _image;
  Future getImages() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      utils().toastMethod("'image picked");
      notifyListeners();
    } else {
      utils().toastMethod("'images not picked");
      // print('images not picked');
    }
  }
  // Image Picker ShopBanner................................................
  File? shopCoverImage;
  Future getImageShopBanner() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      shopCoverImage= File(pickedFile.path);
      utils().toastMethod("Shop Banner image picked");
      notifyListeners();
    } else {
      utils().toastMethod("Shop Banner images not picked");
    }
  }
   // Image Picker ShopBanner................................................
  File? imageShopLogo;
  Future getImageShopLogo() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      imageShopLogo= File(pickedFile.path);
      utils().toastMethod("Shop Logo picked");
      notifyListeners();
    } else {
      utils().toastMethod("Shop Logo not picked");
    }
  }
//Future Product isChecked....
    bool isCheckedFutureProduct = false;
  void toggleisCheckedFutureProduct(bool value) {
    isCheckedFutureProduct = value;
    notifyListeners();
  }


    // Image Picker ProductImage................................................
  File? productImage;
  Future getProductImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      productImage= File(pickedFile.path);
      utils().toastMethod("Product image picked");
      notifyListeners();
    } else {
      utils().toastMethod("Product image not picked");
    }
  }

  //SignUp dropdown.......................................................
  String selectedGender = "Male";
  String? selectedCatagory;
  String? selectedSubsCatagory;
  String? selectedState;
  String? selectedStateId;
  String? selectedLGAs;
  

// setSelected State....................................>>>
  void setSelectedState(String? states) {
    selectedState = states;
    notifyListeners(); // Notify listeners when data changes
  }
  
// setSelected StateId....................................>>>
  void setSelectedStateId(String?stateId) {
    selectedStateId=stateId;
    notifyListeners(); // Notify listeners when data changes
  }
// setSelected State LGAs....................................>>>
  void setSelectedLGAs(String? lga) {
    selectedLGAs = lga;
    notifyListeners(); // Notify listeners when data changes
  }
// SelectedGender....................................>>>
  void setSelectedGender(String gender) {
    selectedGender = gender;
    notifyListeners(); // Notify listeners when data changes
  }

// setSelectedCatagory....................................>>>
  void setSelectedCatagory(String? catagory) {
    selectedCatagory = catagory;
    notifyListeners(); // Notify listeners when data changes
  }
// setSelectedSubsCatagory....................................>>>
  void setSelectedSubsCatagory(String? subsCatagory) {
    selectedSubsCatagory = subsCatagory;
    notifyListeners(); // Notify listeners when data changes
  }

// image Sliding (Product details)
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  selectedIndexMethod(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  //SignUp CheckBox
  bool _isChecked = false;

  bool get isChecked => _isChecked;

  void setIsChecked(bool value) {
    _isChecked = value;
    notifyListeners();
  }

  // remove share Prefence data.......................>>
  void remove(context) async {
    var provider=Provider.of<HomeViewModel>(context,listen: false);
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.clear();
    provider.ordersbyUser.clear();
    provider.myNotification.clear();
    provider.myTransactions.clear();
    provider.myProducts.clear();
    provider.myAllPayments.clear();
    provider.myShopId=null;
    vendorId=null;
    notifyListeners();
  }

// Get User Token...........................................................>>>
  String?preloginToken;
  String? accessToken;
  String? refreshtoken;
  String? vendorId;
  String? name;
  String? vendorEmail;
  String? contact;
  String? userDateOfBirth;
  String? referralCode;
  String? prestigeNumber;
  String? vendorImageURl;
  bool? isProfileCompleted;
  bool? membership;
  double? userPrestigePoint=0.0;
  double? userCurrentNira=0.0;
  void getUserTokens() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    
    preloginToken = sp.getString("preloginToken");
    accessToken = sp.getString("accessToken");
    refreshtoken = sp.getString("refreshToken");
    vendorId = sp.getString("userId");
    name = sp.getString("name");
    vendorEmail = sp.getString("email");
    contact = sp.getString("contact");
    userDateOfBirth = sp.getString("DOB");
    referralCode=sp.getString("referralCode");
    prestigeNumber=sp.getString("prestigeNumber");
    vendorImageURl = sp.getString("userImageURl");
    membership = sp.getBool("Membership");
    notifyListeners();
  }

  signupToken() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    preloginToken = sp.getString("preloginToken");
    notifyListeners();
    // print("accessToken: $accessToken");
  }

  // isCheack Login ..........................................................>>>
  late bool hasExpired;
  void isCheckLogin(context) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    preloginToken = sp.getString("preloginToken");
    isProfileCompleted = sp.getBool("isProfileCompleted");

    hasExpired = JwtDecoder.isExpired(accessToken.toString());
    Map<String, dynamic>? decodedToken =
        JwtDecoder.decode(accessToken.toString());

    if (kDebugMode) {
      print("hasExpired: $hasExpired");
      print("decodedToken: $decodedToken");
    }
    accessToken == null || hasExpired || isProfileCompleted == false
        ? const LoginScreen().launch(context)
        :  Dashboard().launch(context);
    notifyListeners();
  }

  
// Location getLocationAndShowDialog
   Future<void> getLocationAndShowDialog(context) async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    notifyListeners();
  }
// Location premission
  Future getCurrentLocation() async {
    bool serviceEnable = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnable) {
      return Future.error("Location Service are disable");
    } else {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        notifyListeners();
        if (permission == LocationPermission.denied) {
          if (kDebugMode) {
            print("Location Permission is Denied");
          }
          return Future.error("Location Permission is Denied");
        }
      }
    }
  }
// Payment Method //.................
  String _selectedMethod = "cashpoint"; // Default selection

  String get selectedMethod => _selectedMethod;
  void setSelectedMethod(String newValue) {
    _selectedMethod = newValue;
    notifyListeners();
  }

  
}
