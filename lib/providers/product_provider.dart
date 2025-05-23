import 'package:ecommerce_app/models/product.dart';
import 'package:ecommerce_app/repositories/product_repository.dart';
import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier{

  final ProductRepository _productRepository = ProductRepository();

  List<ProductModel> _products = [];

  List<ProductModel> get products => _products;

  Map<String,List<ProductModel>> productsByCategory = {};

  Map<String,List<ProductModel>> productsHomeByCategory = {};

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String _errorMessage = "";

  String get errorMessage => _errorMessage;

  Future<void> getAllProducts(String status) async{
  
    _isLoading = true;
    notifyListeners();

    try { 
      final productss = await _productRepository.getAllProducts(status);
      if(productss.isNotEmpty) {

        _products = (productss as List).map<ProductModel>((item) => ProductModel.fromJson(item)).toList();

        productsHomeByCategory[status] = products;
        
      }

      _errorMessage = "";
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
    }
    finally {
      _isLoading = false;
      notifyListeners();
    }

  }

  Future<void> getAllProductPages(String status, String? sortById, List<String>? selectedBrand, double? priceRangeStart, double? priceRangeEnd, double? ratingRangeStart, double? ratingRangeEnd, String? search) async{
  
    _isLoading = true;
    notifyListeners();

    try { 
      final productss = await _productRepository.getAllProductPages(status, sortById, selectedBrand, priceRangeStart, priceRangeEnd, ratingRangeStart, ratingRangeEnd, search);
      if(productss.isNotEmpty) {

        _products = (productss as List).map<ProductModel>((item) => ProductModel.fromJson(item)).toList();

        productsByCategory[status] = products;
        
      }

      _errorMessage = "";
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
    }
    finally {
      _isLoading = false;
      notifyListeners();
    }

  }

  void clearProductsByCategory(String categoryId) {
    productsByCategory[categoryId] = [];
    notifyListeners();
  }

}