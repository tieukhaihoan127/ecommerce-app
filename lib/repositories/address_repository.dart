import 'package:ecommerce_app/models/district.dart';
import 'package:ecommerce_app/models/province.dart';
import 'package:ecommerce_app/models/ward.dart';
import 'package:ecommerce_app/services/address_service.dart';

class AddressRepository {

  final AddressService _addressService = AddressService();

  Future<List<Province>> getAllProvinces() => _addressService.fetchProvince();
  
  Future<List<District>> getAllDistrict(String id) => _addressService.fetchDistrictByProvinceId(id);

  Future<List<Ward>> getAllWard(String id) => _addressService.fetchWardByDistrictId(id);

}