import 'package:dotted_border/dotted_border.dart';
import 'package:ecommerce_app/providers/order_provider.dart';
import 'package:ecommerce_app/screens/client/order_tracking.dart';
import 'package:ecommerce_app/widgets/order_item_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OrderDetailScreen extends StatefulWidget {
  final String orderId;

  const OrderDetailScreen({super.key, required this.orderId});

  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<OrderProvider>(
        context,
        listen: false,
      ).getOrderDetail(widget.orderId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    int loyalty = 0;

    if(orderProvider.isLoading == false) {
      loyalty = orderProvider.orderDetail!.loyaltyPoint!;
      double totalAmount = orderProvider.orderDetail!.totalPrice! + orderProvider.orderDetail!.shippingFee! + ((orderProvider.orderDetail!.totalPrice! * orderProvider.orderDetail!.taxes!) / 100);

      if(loyalty >= totalAmount) {
        loyalty = totalAmount.toInt();
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Detail', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: const BackButton(color: Colors.black),
      ),
      body: orderProvider.isLoading
          ? const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                buildSectionTitle('Client Information'),
                const SizedBox(height: 8),
                buildClientInfo(orderProvider),
                const SizedBox(height: 16),

                buildSectionTitle('Product Information'),
                const SizedBox(height: 8),
                ...orderProvider.orderDetail!.products!
                    .map((item) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: OrderItemCard(product: item),
                        ))
                    .toList(),
                const SizedBox(height: 16),

                // buildSectionTitle('Promo Code'),
                // const SizedBox(height: 8),
                // buildPromoCode(),
                // const SizedBox(height: 16),

                // _buildLoyaltyPointSection(loyalty),
                // const SizedBox(height: 16,),

                buildOrderInfo(
                  orderProvider.orderDetail?.totalPrice ?? 0,
                  orderProvider.orderDetail?.taxes ?? 0,
                  orderProvider.orderDetail?.shippingFee ?? 0,
                  loyalty,
                  orderProvider.orderDetail?.coupon ?? 0,
                  orderProvider
                ),

                const SizedBox(height: 16,),
                _trackingOrderButton(context, widget.orderId)
              ],
            ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget buildClientInfo(OrderProvider provider) {
    final userInfo = provider.orderDetail!.userInfo!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildClientInfoRow("Client Name", userInfo.fullName!),
          _buildClientInfoRow("Client Email", userInfo.email!),
          _buildClientInfoRow("Client Phone Number", userInfo.phone!),
          _buildClientInfoRow(
            "Client Address",
            "${userInfo.address}, ${userInfo.ward}, ${userInfo.district}, ${userInfo.city}",
          ),
          _buildClientInfoRow("Purchased Date", _formatTimestamp(provider.orderDetail!.createdDate!)),
        ],
      ),
    );
  }

  Widget _buildClientInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildOrderInfo(double subtotal, int taxes, int shippingFee, int loyaltyPoint, int coupon, OrderProvider orderProvider) {
    double totalAmount = subtotal + shippingFee + ((subtotal * taxes) / 100);

    if(orderProvider.orderDetail!.loyaltyPoint! >= totalAmount) {
      totalAmount = 0;
    }
    else {
      totalAmount = totalAmount - orderProvider.orderDetail!.loyaltyPoint!;
    }

    if(coupon > 0) {
      totalAmount = totalAmount - coupon;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Order Info",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                _buildInfoRowDouble("Sub Total", subtotal),
                _buildInfoRowPercent("Taxes", taxes),
                _buildInfoRow("Shipping Fee", shippingFee),
                if(loyaltyPoint > 0)
                  _buildInfoRow("Loyalty Point", loyaltyPoint),
                if(coupon > 0)
                  _buildInfoRow("Coupon", coupon),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Divider(thickness: 1.2),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total Amount",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                "${_formatCurrencyDouble(totalAmount)} đ",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[700])),
          Text("${_formatCurrency(value)} đ", style: TextStyle(color: Colors.grey[800])),
        ],
      ),
    );
  }

  Widget _buildInfoRowDouble(String label, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[700])),
          Text("${_formatCurrencyDouble(value)} đ", style: TextStyle(color: Colors.grey[800])),
        ],
      ),
    );
  }

  Widget _buildInfoRowPercent(String label, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[700])),
          Text("$value %", style: TextStyle(color: Colors.grey[800])),
        ],
      ),
    );
  }
}

Widget _trackingOrderButton(BuildContext context, String orderId) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => OrderTrackingScreen(orderId: orderId)));
      },
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: const Color(0xFF0F1C2F),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            "Tracking Order Status",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }

String _formatCurrency(int price) {
  final NumberFormat formatter = NumberFormat("#,##0", "vi_VN");
  return formatter.format(price);
}

String _formatCurrencyDouble(double price) {
  final NumberFormat formatter = NumberFormat("#,##0", "vi_VN");
  return formatter.format(price);
}

String _formatTimestamp(DateTime timestamp) {
  final formatter = DateFormat('dd/MM/yyyy - HH:mm');
  return formatter.format(timestamp);
}
