import 'package:ecommerce_app/services/product_service.dart';

class ProductRepository {

  final ProductService _productService = ProductService();

  Future<List<Map<String,dynamic>>> getAllProducts(String status) => _productService.getProducts(status);

  Future<List<Map<String,dynamic>>> getAllProductPages(String status, String? sortById, List<String>? selectedBrand, double? priceRangeStart, double? priceRangeEnd, double? ratingRangeStart, double? ratingRangeEnd, String? search) => _productService.getProductPages(status, sortById, selectedBrand, priceRangeStart, priceRangeEnd, ratingRangeStart, ratingRangeEnd, search);

}