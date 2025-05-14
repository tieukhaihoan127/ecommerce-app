import 'package:ecommerce_app/models/add_to_cart.dart';
import 'package:ecommerce_app/models/cart.dart';
import 'package:ecommerce_app/models/delete_cart.dart';
import 'package:ecommerce_app/models/user_cart.dart';
import 'package:ecommerce_app/repositories/cart_repository.dart';
import 'package:ecommerce_app/screens/client/cart.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider with ChangeNotifier{

  final CartRepository _cartRepository = CartRepository();

  List<CartModel> _carts = [];

  List<CartModel> get carts => _carts;

  int _totalPrice = 0;

  int get totalPrice => _totalPrice;

  int? _taxes;

  int? get taxes => _taxes;

  int? _shippingFee;

  int? get shippingFee => _shippingFee;

  int? _loyaltyPoints;

  int? get loyaltyPoints => _loyaltyPoints;

  String? _cartId;

  String? get cartId => _cartId;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String _errorMessage = "";

  String get errorMessage => _errorMessage;

  Future<void> getAllCarts() async {

    _isLoading = true;
    notifyListeners();

    try {

      final prefs = await SharedPreferences.getInstance();
      String? sessionId = prefs.getString('session_id');
      String? tokenId = prefs.getString('token');

      var user = UserCartModel(
        sessionId: sessionId,
        tokenId: tokenId
      );

      print("User: $user");

      final cartResponse = await _cartRepository.getAllCarts(user);

      print("Cart Provider Response: $cartResponse");

      if(cartResponse['products'] == null || (cartResponse['products'] as List).isEmpty) {
        _carts = [];
        _totalPrice = 0;
        print("Cart Response: $cartResponse");
      }
      else {
        final productsJson = cartResponse['products'] as List;
        _carts = productsJson.map<CartModel>((item) => CartModel.fromJson(item)).toList();
        print("Cart Response Data: $_carts");
        _totalPrice = cartResponse['totalPrice'];
        _taxes = cartResponse['taxes'];
        _shippingFee = cartResponse['shippingFee'];
        _cartId = cartResponse['cartId'];
        _loyaltyPoints = cartResponse['loyaltyPoint'];
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

  Future<String> addProductToCart(String productId, String color, int quantity) async {

    _isLoading = true;
    notifyListeners();

    try {

      final prefs = await SharedPreferences.getInstance();
      String? sessionId = prefs.getString('session_id');
      String? tokenId = prefs.getString('token');

      var product = AddToCartModel(
        sessionId: sessionId,
        tokenId: tokenId,
        color: color,
        quantity: quantity
      );

      final cartResponse = await _cartRepository.addToCart(product, productId);

      if(cartResponse != "") {
        _errorMessage = "";
        notifyListeners();
        return cartResponse;
      }
      else {
        _errorMessage = "Thêm sản phẩm vào giỏ hàng thất bại!";
        notifyListeners();
      }

    } catch (e) {
      _errorMessage = e.toString();
    }
    finally {
      _isLoading = false;
      notifyListeners();
    }

    return "";

  } 

  Future<String> deleteProductFromCart(String productId, String color) async {

    try {

      final prefs = await SharedPreferences.getInstance();
      String? sessionId = prefs.getString('session_id');
      String? tokenId = prefs.getString('token');

      var product = DeleteCartModel(
        sessionId: sessionId,
        tokenId: tokenId,
        color: color,
      );

      final cartResponse = await _cartRepository.deleteCart(product, productId);

      if(cartResponse != "") {

        final index = _carts.indexWhere((item) => item.productId == productId && item.color == color);
        if (index == -1) return "";

        _totalPrice = _totalPrice! - _carts[index].totalPrice!;
        _carts.removeAt(index);

        _errorMessage = "";
        notifyListeners();
        return cartResponse;
      }
      else {
        _errorMessage = "Xóa sản phẩm vào giỏ hàng thất bại!";
        notifyListeners();
      }

    } catch (e) {
      _errorMessage = e.toString();
    }
    finally {
      notifyListeners();
    }

    return "";

  } 

  Future<String> updateIncrementProductInCart(String productId, String color, int quantity) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? sessionId = prefs.getString('session_id');
      String? tokenId = prefs.getString('token');

      var product = AddToCartModel(
        sessionId: sessionId,
        tokenId: tokenId,
        color: color,
        quantity: quantity
      );

      final cartResponse = await _cartRepository.updateCart(product, productId);

      if(cartResponse != "") {

        final index = _carts.indexWhere((item) => item.productId == productId && item.color == color);
        if (index == -1) return "";

        _carts[index].quantity = _carts[index].quantity! + 1;
        _carts[index].totalPrice = _carts[index].quantity! * _carts[index].carts!.priceNew!;
        _totalPrice = _totalPrice! +  _carts[index].carts!.priceNew!;

        _errorMessage = "";
        notifyListeners();
        return cartResponse;
      }
      else {
        _errorMessage = "Cập nhật sản phẩm trong giỏ hàng thất bại!";
        notifyListeners();
      }

    } catch (e) {
      _errorMessage = e.toString();
    }
    finally {
      notifyListeners();
    }

    return "";

  } 

  Future<String> updateDecrementProductInCart(String productId, String color, int quantity) async {

    try {
      final prefs = await SharedPreferences.getInstance();
      String? sessionId = prefs.getString('session_id');
      String? tokenId = prefs.getString('token');

      var product = AddToCartModel(
        sessionId: sessionId,
        tokenId: tokenId,
        color: color,
        quantity: quantity
      );

      final cartResponse = await _cartRepository.updateCart(product, productId);

      if(cartResponse != "" ) {

        final index = _carts.indexWhere((item) => item.productId == productId && item.color == color);
        if (index == -1) return "";

        if(_carts[index].quantity != 1) {
          _carts[index].quantity = _carts[index].quantity! - 1;
          _carts[index].totalPrice = _carts[index].quantity! * _carts[index].carts!.priceNew!;
          _totalPrice = _totalPrice! - _carts[index].carts!.priceNew!;
        }
        else {
          _totalPrice = _totalPrice! - _carts[index].totalPrice!;
          _carts.removeAt(index);
        }

        _errorMessage = "";
        notifyListeners();
        return cartResponse;
      }
      else {
        _errorMessage = "Cập nhật sản phẩm trong giỏ hàng thất bại!";
        notifyListeners();
      }

    } catch (e) {
      _errorMessage = e.toString();
    }
    finally {
      notifyListeners();
    }

    return "";

  }

  void clearCart() {
    _carts = [];
    notifyListeners();
  }

}