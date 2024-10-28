class AppUrls {
  // Base Url....
  static var baseUrl = "https://prestigereward.vercel.app/api/";
  // static var baseUrl = "http://13.245.10.125:3000/api/";


  // Base Url....
   static var urlLogin = "${baseUrl}auth/login";
  static var urlSignUp = "${baseUrl}auth/signup";
  static var urlVerfityaccountOTP = "${baseUrl}auth/verify-otp-by-email";
  static var urlverifyOtpBeforeOrder = "${baseUrl}auth/verify-otp-before-order";
  static var urlResandOTP = "${baseUrl}auth/regenerate-otp";
  static var urlCompleteProfile = "${baseUrl}auth/complete-profile";
  static var urlDevicetoken = "${baseUrl}users/devicetoken";
  static var urlGetAllStates = "${baseUrl}states/all";
  static var urlGetAllSubcategory= "${baseUrl}subcategory/all";
  static var urlMyTransaction = "${baseUrl}transaction";
  static var urlLogOut = "${baseUrl}auth/logout";
  static var urlupdatePassword = "${baseUrl}auth/update-password";
  static var urlForgotPassword = "${baseUrl}auth/forgot";
  static var urlUpdateMe = "${baseUrl}users/update-me";
  static var urlGetMe = "${baseUrl}users/me";
  static var urlDeleteMe = "${baseUrl}users/delete-me";
  static var urlResetPassword = "${baseUrl}userAuth/reset-password?token=";
  static var urlProductSearch = "${baseUrl}product/search";
  static var urlorderSearchbyVendor = "${baseUrl}order/searchbyvendor";

// GetAll
  static var urlGetAllProduct = "${baseUrl}product";
  static var urlWithdrawal = "${baseUrl}withdrawal";
  static var urlgift = "${baseUrl}gift";
  static var urloffer = "${baseUrl}offer";
  static var urlGetAllCategory= "${baseUrl}category"; 
  static var urlGetAllusers = "${baseUrl}users";
  static var urlFavouriteProduct = "${baseUrl}favourite-product";
  static var urlProduct = "${baseUrl}product";
  static var urlOrders = "${baseUrl}order";
  static var urlGetAllPayment = "${baseUrl}payment";
  static var urlPlaceOrder = "${baseUrl}order";
  static var urlCreateShop = "${baseUrl}shop";
  static var urlCreateProduct = "${baseUrl}product";
  static var urlPointFormula = "${baseUrl}point";
  static var prestigeSandOTP = "${baseUrl}users/prestige-number-send-otp";


// GetByID
  static var urlUpdateShop = "${baseUrl}shop/";
  static var urlIdProduct = "${baseUrl}product/";
  static var urlSingleOrderDetails = "${baseUrl}order/";
  static var urlUpdateStatus = "${baseUrl}order/update-status/";
  static var urlNotification = "${baseUrl}notification";
  static var urlgetoffer1 = "${baseUrl}offer/";
  static var urlgetcategory1 = "${baseUrl}subcategory/category/";
  static var urlgetSubCatBYCatagory = "${baseUrl}subcategory/getcategory/";
  static var urlSingleFeatureproduct = "${baseUrl}product/slug/";
  static var urlUpdateOrder = "${baseUrl}order/update-status/";
  static var urlCurrentpoint = "${baseUrl}currentpoint/by-userid/";
  static var urlShopProductByVendor = "${baseUrl}shop/shop-product-by-vendor/";
  static var urlUserByPrestigeNumber = "${baseUrl}users/prestige-number?prestigeNumber=";
  static var urlVendorGrapgh = "${baseUrl}admindashbaord/vendor/";
  static var urlMybankDetails= "${baseUrl}bank";
//DeleteByID
  static var urlProductDelete = "${baseUrl}product/";
//UpdateByID
  static var urlProductUpdate = "${baseUrl}product/";
}
