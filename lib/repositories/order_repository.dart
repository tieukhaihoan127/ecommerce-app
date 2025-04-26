import 'package:ecommerce_app/models/add_to_cart.dart';
import 'package:ecommerce_app/models/checkout_order.dart';
import 'package:ecommerce_app/models/delete_cart.dart';
import 'package:ecommerce_app/models/user_cart.dart';
import 'package:ecommerce_app/services/order_service.dart';

class OrderRepository {
  final OrderService _orderService = OrderService();

  Future<String> createOrder(CheckoutOrderModel order) => _orderService.addOrders(order);

  Future<List<Map<String,dynamic>>> getOrderHisotry(String tokenId) => _orderService.getHistoryOrders(tokenId);

}