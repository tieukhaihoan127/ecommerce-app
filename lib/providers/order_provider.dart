import 'package:ecommerce_app/models/checkout_order.dart';
import 'package:ecommerce_app/models/order_coupon.dart';
import 'package:ecommerce_app/models/order_detail.dart';
import 'package:ecommerce_app/models/order_detail_admin.dart';
import 'package:ecommerce_app/models/order_history.dart';
import 'package:ecommerce_app/models/order_status.dart';
import 'package:ecommerce_app/repositories/order_repository.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderProvider with ChangeNotifier{

  final OrderRepository _orderRepository = OrderRepository();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  int? _pages;

  int? get pages => _pages;

  List<OrderHistoryModel>? _historyOrders;

  List<OrderHistoryModel>? get historyOrders => _historyOrders;

  List<OrderCouponModel>? _couponOrders;

  List<OrderCouponModel>? get couponOrders => _couponOrders;

  List<OrderCouponModel>? _adminOrders;

  List<OrderCouponModel>? get adminOrders => _adminOrders;

  List<OrderStatusModel>? _orderStatus;

  List<OrderStatusModel>? get orderStatus => _orderStatus;

  OrderDetailModel? _orderDetail;

  OrderDetailModel? get orderDetail => _orderDetail;

  OrderDetailAdminModel? _orderDetailAdmin;

  OrderDetailAdminModel? get orderDetailAdmin => _orderDetailAdmin;

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

  Future<void> getAllCouponOrders(String couponId) async{
  
    _isLoading = true;
    notifyListeners();

    try { 
      
      final orderResponse = await _orderRepository.getOrderUsingCoupon(couponId);
      
      if(orderResponse.isNotEmpty) {
        _couponOrders = orderResponse.map<OrderCouponModel>((item) => OrderCouponModel.fromJson(item)).toList();
      }
      else {
        _couponOrders = [];
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

  Future<void> getAllAdminOrders(String status, DateTime? startDate, DateTime? endDate, int page) async{
  
    _isLoading = true;
    notifyListeners();

    try { 

      var filterStatus = "All";

      if(status == "Today") {
        filterStatus = "Today";
      }
      else if(status == "Yesterday") {
        filterStatus = "Yesterday";
      }
      else if(status == "This Week") {
        filterStatus = "Week";
      }
      else if(status == "This Month") {
        filterStatus = "Month";
      }
      else if(status == "Custom Range") {
        filterStatus = "Custom";
      }
      
      final orderResponseData = await _orderRepository.getAllAdminOrder(filterStatus, startDate ?? DateTime.now(), endDate ?? DateTime.now(), page);

      final orderResponse = orderResponseData["order"];
      
      if(orderResponse.isNotEmpty) {
        _adminOrders = orderResponse.map<OrderCouponModel>((item) => OrderCouponModel.fromJson(item)).toList();
        _pages = orderResponseData["totalPages"];
      }
      else {
        _adminOrders = [];
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

  Future<void> getOrderDetail(String orderId) async {
  
    _isLoading = true;
    notifyListeners();

    try { 
      
      final orderResponse = await _orderRepository.getOrderDetail(orderId);

      if(orderResponse.isNotEmpty) {
        _orderDetail = OrderDetailModel.fromJson(orderResponse);
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

  Future<void> getAdminOrderDetail(String orderId) async {
  
    _isLoading = true;
    notifyListeners();

    try { 
      
      final orderResponse = await _orderRepository.getAdminOrderDetail(orderId);

      _orderDetailAdmin = null;

      if(orderResponse.isNotEmpty) {
        _orderDetailAdmin = OrderDetailAdminModel.fromJson(orderResponse);
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

  Future<void> getOrderStatus(String orderId) async{
  
    _isLoading = true;
    notifyListeners();

    try { 
      
      final orderResponse = await _orderRepository.getOrderStatus(orderId);

      if(orderResponse.isNotEmpty) {
        _orderStatus = orderResponse.map<OrderStatusModel>((item) => OrderStatusModel.fromJson(item)).toList();
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

  Future<String> updateOrderStatus(String orderId, String status) async {

    try {

      final orderRepsonse = await _orderRepository.updateOrderStatus(orderId, status);

      if(orderRepsonse != "") {
        _orderDetailAdmin!.status = status;
        _errorMessage = "";
        notifyListeners();
        return orderRepsonse;
      }
      else {
        _errorMessage = "Cập nhật đơn hàng thất bại!";
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

  void clearOrder() {
    _historyOrders = [];
    notifyListeners();
  }


}