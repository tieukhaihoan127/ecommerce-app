import 'package:ecommerce_app/models/checkout_order.dart';
import 'package:ecommerce_app/services/order_service.dart';

class OrderRepository {
  final OrderService _orderService = OrderService();

  Future<String> createOrder(CheckoutOrderModel order) => _orderService.addOrders(order);

  Future<List<Map<String,dynamic>>> getOrderHisotry(String tokenId) => _orderService.getHistoryOrders(tokenId);

  Future<Map<String,dynamic>> getOrderDetail(String orderId) => _orderService.getOrderDetail(orderId);

  Future<List<Map<String,dynamic>>> getOrderStatus(String orderId) => _orderService.getOrderStatusDetail(orderId);

  Future<List<Map<String,dynamic>>> getOrderUsingCoupon(String couponId) => _orderService.getOrderUsingCoupon(couponId);

}