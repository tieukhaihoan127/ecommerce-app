class ApiConfig {

  static const String baseUrl = 'http://192.168.1.6:3030/';
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
  
}
