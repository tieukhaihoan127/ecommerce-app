import 'package:ecommerce_app/models/add_to_cart.dart';
import 'package:ecommerce_app/models/cart.dart';
import 'package:ecommerce_app/models/checkout_order.dart';
import 'package:ecommerce_app/models/delete_cart.dart';
import 'package:ecommerce_app/models/user_cart.dart';
import 'package:ecommerce_app/repositories/cart_repository.dart';
import 'package:ecommerce_app/repositories/order_repository.dart';
import 'package:ecommerce_app/screens/client/cart.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderProvider with ChangeNotifier{

  final OrderRepository _orderRepository = OrderRepository();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String _errorMessage = "";

  String get errorMessage => _errorMessage;

  Future<String> createOrder(CheckoutOrderModel order) async {

    try {

      final orderRepsonse = await _orderRepository.createOrder(order);

      if(orderRepsonse != "") {
        _errorMessage = "";
        notifyListeners();
        return orderRepsonse;
      }
      else {
        _errorMessage = "Thêm đơn hàng thất bại!";
        notifyListeners();
      }

    } catch (e) {
      _errorMessage = e.toString();
    }

    return "";

  } 


}