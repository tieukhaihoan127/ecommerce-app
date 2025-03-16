import 'package:ecommerce_app/models/district.dart';
import 'package:ecommerce_app/models/province.dart';
import 'package:ecommerce_app/models/ward.dart';
import 'package:ecommerce_app/repositories/address_repository.dart';
import 'package:flutter/widgets.dart';

class AddressProvider with ChangeNotifier{

  final AddressRepository _addressRepository = AddressRepository();

  final bool _isSelected = false;

  bool get isSelected => _isSelected;

  bool _isLoaded = false;

  bool get isLoaded => _isLoaded;

  String _errorMessage = "";

  String get errorMessage => _errorMessage;

  List<Province> _provinces = [];

  List<Province> get provinces => _provinces;

  List<District> _districts = [];

  List<District> get districts => _districts;

  List<Ward> _wards = [];

  List<Ward> get wards => _wards;

  Future<void> fetchProvinces() async {

    _isLoaded = true;
    notifyListeners();

    try {
      _provinces = await _addressRepository.getAllProvinces();
      _errorMessage = '';
    }
    catch(e) {
      _errorMessage = e.toString();
    }
    finally {
      _isLoaded = false;
      notifyListeners();
    }

  }

  Future<void> fetchDistrict(String id) async {

    try {
      _districts = await _addressRepository.getAllDistrict(id);
      _errorMessage = '';
    }
    catch(e) {
      _errorMessage = e.toString();
    }
    finally {
      notifyListeners();
    }

  }

  Future<void> fetchWard(String id) async {

    try {
      _wards = await _addressRepository.getAllWard(id);
      _errorMessage = '';
    }
    catch(e) {
      _errorMessage = e.toString();
    }
    finally {
      notifyListeners();
    }

  }

  Future<void> resetWard() async {
      _wards.clear();
      notifyListeners();
  }

}