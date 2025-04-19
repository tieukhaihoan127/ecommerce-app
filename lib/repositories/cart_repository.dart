import 'package:ecommerce_app/models/add_to_cart.dart';
import 'package:ecommerce_app/models/delete_cart.dart';
import 'package:ecommerce_app/models/user_cart.dart';
import 'package:ecommerce_app/services/cart_service.dart';

class CartRepository {
  final CartService _cartService = CartService();

  Future<Map<String,dynamic>> getAllCarts(UserCartModel user) => _cartService.getCarts(user);

  Future<String> addToCart(AddToCartModel product, String productId) => _cartService.addCarts(product, productId);

  Future<String> deleteCart(DeleteCartModel product, String productId) => _cartService.deleteCarts(product, productId);

  Future<String> updateCart(AddToCartModel product, String productId) => _cartService.updateCarts(product, productId);
}