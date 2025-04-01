import 'package:ecommerce_app/services/product_service.dart';

class ProductRepository {

  final ProductService _productService = ProductService();

  Future<List<Map<String,dynamic>>> getAllProducts(String status) => _productService.getProducts(status);

}