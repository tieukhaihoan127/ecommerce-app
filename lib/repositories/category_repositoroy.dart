import 'package:ecommerce_app/services/category_service.dart';

class CategoryRepositoroy {

  final CategoryService _categoryService = CategoryService();

  Future<List<Map<String,dynamic>>> getAllCategories() => _categoryService.getCategories();

}