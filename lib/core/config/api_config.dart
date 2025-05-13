class ApiConfig {

  static const String baseUrl = 'http://192.168.1.9:3030/';
  static const String getUserUrl = '${baseUrl}users/signin';
  static const String registerUrl = '${baseUrl}users/register';
  static const String addressUrl = 'https://vn-public-apis.fpo.vn/';
  static const String cityUrl = '${addressUrl}provinces/getAll?limit=-1';
  static const String districtUrl = '${addressUrl}districts/getByProvince?provinceCode=';
  static const String wardUrl = '${addressUrl}wards/getByDistrict?districtCode=';
  static const String loginUrl = '${baseUrl}users/login';
  static const String updateUserUrl = '${baseUrl}users/info/';
  static const String changePasswordUrl = '${baseUrl}users/change-password/';
  static const String getOTPUrl = '${baseUrl}users/password/forgot';
  static const String submitOTPUrl = '${baseUrl}users/password/otp';
  static const String updatePasswordUrl = '${baseUrl}users/password/reset';
  static const String getCategoriesUrl = '${baseUrl}categories/';
  static const String getProductsUrl = '${baseUrl}products/';
  static const String getProductPagesUrl = '${baseUrl}products/pages/';
  static const String getCartUrl = '${baseUrl}cart/';
  static const String addCartUrl = '${baseUrl}cart/add/';
  static const String updateCartUrl = '${baseUrl}cart/update/';
  static const String deleteCartUrl = '${baseUrl}cart/delete/';
  static const String checkoutUrl = '${baseUrl}checkout/order/';
  static const String getOrderHistoryUrl = '${baseUrl}checkout/';
  static const String getOrderStatusUrl = '${baseUrl}checkout/status';
  static const String getCouponCodeUrl = '${baseUrl}coupon/';
  static const String getCouponCodeAdminUrl = '${baseUrl}admin/coupon/';
  static const String addCouponUrl = '${baseUrl}admin/coupon/add';
  static const String getReviewUrl = '${baseUrl}review/';
  static const String addReviewUrl = '${baseUrl}review/add';
  static const String getRatingUrl = '${baseUrl}rating/';
  static const String addRatingUrl = '${baseUrl}rating/add';
  static const String chatUrl = '${baseUrl}chat/';
  static const String getOrderAdminUrl = '${baseUrl}admin/order/';
  static const String getOrderAdminDetailUrl = '${baseUrl}admin/order/detail/';
  static const String updateOrderStatusUrl = '${baseUrl}admin/order/changeStatus/';
  static const String getUserAdminUrl = '${baseUrl}admin/user/';
  static const String updateUserAdminUrl = '${baseUrl}admin/user/update/';
  static const String getDashboardUrl = '${baseUrl}admin/dashboard/';
  
}
