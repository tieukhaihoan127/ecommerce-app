import 'package:ecommerce_app/models/add_to_cart.dart';
import 'package:ecommerce_app/models/cart.dart';
import 'package:ecommerce_app/models/checkout_order.dart';
import 'package:ecommerce_app/models/delete_cart.dart';
import 'package:ecommerce_app/models/order_detail.dart';
import 'package:ecommerce_app/models/order_history.dart';
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

  List<OrderHistoryModel>? _historyOrders;

  List<OrderHistoryModel>? get historyOrders => _historyOrders;

  OrderDetailModel? _orderDetail;

  OrderDetailModel? get orderDetail => _orderDetail;

  String _errorMessage = "";

  String get errorMessage => _errorMessage;

  Future<void> getAllHistoryOrders() async{
  
    _isLoading = true;
    notifyListeners();

    try { 

      final prefs = await SharedPreferences.getInstance();
      String? tokenId = prefs.getString('token');
      
      final orderResponse = await _orderRepository.getOrderHisotry(tokenId!);
      if(orderResponse.isNotEmpty) {
        _historyOrders = orderResponse.map<OrderHistoryModel>((item) => OrderHistoryModel.fromJson(item)).toList();
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

  Future<void> getOrderDetail(String orderId) async{
  
    _isLoading = true;
    notifyListeners();

    try { 
      
      final orderResponse = await _orderRepository.getOrderDetail(orderId);
      print("Response: $orderResponse");
      if(orderResponse.isNotEmpty) {
        _orderDetail = OrderDetailModel.fromJson(orderResponse);

        print("Data response: $_orderDetail");
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

  Future<String> createOrder(CheckoutOrderModel order) async {

    try {

      _isLoading = true;
      notifyListeners();

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
    finally {
      _isLoading = false;
      notifyListeners();
    }

    return "";

  } 

  void clearOrder() {
    _historyOrders = [];
    notifyListeners();
  }


}