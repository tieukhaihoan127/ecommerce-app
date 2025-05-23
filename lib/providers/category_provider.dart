import 'package:ecommerce_app/models/category.dart';
import 'package:ecommerce_app/models/category_model_page.dart';
import 'package:ecommerce_app/repositories/category_repositoroy.dart';
import 'package:flutter/material.dart';


class CategoryProvider with ChangeNotifier{

  final CategoryRepositoroy _categoryRepositoroy = CategoryRepositoroy();

  String _status = "All";

  String get status => _status;

  String _name = "";

  String get name => _name;

  List<CategoryModel> _categories = [];

  List<CategoryModel> get categories => _categories;

  List<CategoryPageModel> _categoryPages = [];

  List<CategoryPageModel> get categoryPages => _categoryPages;

  int selectedCategoryIndex = 0;

  bool _isLoading = false;

  bool get isLoading => _isLoading;    

  String _errorMessage = "";

  String get errorMessage => _errorMessage;

  Future<void> loadCategory() async {
    _isLoading = true;
    notifyListeners();

    try { 
      final categories = await _categoryRepositoroy.getAllCategories();
      if(categories.length > 0) {

        final categoriesList = (categories as List).map<CategoryModel>((item) => CategoryModel.fromJson(item)).toList();
        _categories = [
          CategoryModel(id: "All", name: "All"),
          CategoryModel(id: "Promotional Products", name: "Promotional Products"),
          CategoryModel(id: "New Products", name: "New Products"),
          CategoryModel(id: "Best Sellers", name: "Best Sellers"),
          ...categoriesList
        ];
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

  Future<void> fetchAllCategory() async {

    _isLoading = true;
    notifyListeners();

    try {
      final categories = await _categoryRepositoroy.getAllCategories();

      if(categories.isNotEmpty) {
        _categoryPages = (categories as List).map<CategoryPageModel>((item) => CategoryPageModel.fromJson(item)).toList();
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

  void getStatus(BuildContext context, CategoryModel category) {
    _status = category.id;
    _name = category.name;
    notifyListeners();
  }

  void setSelectedCategoryIndex(int index) {
    selectedCategoryIndex = index;
    notifyListeners();
  }

}