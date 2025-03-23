class ApiConfig {

  static const String baseUrl = 'http://192.168.1.8:3030/';
  static const String registerUrl = '${baseUrl}users/register';
  static const String addressUrl = 'https://vn-public-apis.fpo.vn/';
  static const String cityUrl = '${addressUrl}provinces/getAll?limit=-1';
  static const String districtUrl = '${addressUrl}districts/getByProvince?provinceCode=';
  static const String wardUrl = '${addressUrl}wards/getByDistrict?districtCode=';
  static const String loginUrl = '${baseUrl}users/login';
  static const String updateUserUrl = '${baseUrl}users/info/';
  
}
