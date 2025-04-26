import 'package:ecommerce_app/providers/order_provider.dart';
import 'package:ecommerce_app/widgets/hex_color.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OrderHistoryPageScreen extends StatefulWidget {

  @override
  _OrderHistoryPageScreenState createState() => _OrderHistoryPageScreenState();

}

class _OrderHistoryPageScreenState extends State<OrderHistoryPageScreen> {

  @override
  Widget build(BuildContext context) {

    final orderProvider = Provider.of<OrderProvider>(context);
    final orderItems = orderProvider.historyOrders;

    return Scaffold(
      appBar: AppBar(
        title: Text('My Order', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: BackButton(color: Colors.black),
      ),
      body: orderProvider.isLoading ?  Center(child: const SizedBox( width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2),)) : orderItems!.isEmpty ? const Center(child: Text('Your order is empty')) : ListView.builder(
        itemCount: orderItems.length,
        itemBuilder: (context, index) {
          final order = orderItems[index];
          return Card(
            margin: EdgeInsets.all(10),
            child: ExpansionTileTheme(
              data: ExpansionTileTheme.of(context).copyWith(
                shape: Border(),
                collapsedShape: Border()
              ),
              child: ExpansionTile(
                title: Text('Order #: ${order.orderId}'),
                subtitle: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Date: ${order.latestUpdatedAt!.toLocal().toShortString()}'
                    ),
                    const SizedBox(width:10),
                    _buildStatusBadge(order.latestStatus!)
                  ],
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Total: ${_formatCurrencyDouble(order.totalAmount!)} đ'),
                        SizedBox(height: 8),
                        Text('Products:'),
                        ...order.products!.map(
                          (product) => ListTile(
                            leading: CircleAvatar(
                              radius: 24,
                              backgroundImage: NetworkImage(product.thumbnail!),
                            ),
                            title: Row(crossAxisAlignment: CrossAxisAlignment.center,children: [Text("${product.title}  -"), const SizedBox(width: 10,), _colorDot(product.color!)],),
                            trailing: Text('x${product.quantity!}'),
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              side: BorderSide(color: Colors.black),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed: () {

                            },
                            child: Text(
                              'View Order Detail',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}


Widget _buildStatusBadge(String status) {
  Color bgColor;
  Color textColor;

  switch (status.toLowerCase()) {
    case 'pending':
      bgColor = Colors.red.shade300;
      textColor = Colors.black;
      break;
    case 'confirmed':
      bgColor = Colors.orange.shade300;
      textColor = Colors.black;
      break;
    case 'shipping':
      bgColor = Colors.grey.shade500;
      textColor = Colors.black;
      break;
    case 'delivered':
      bgColor = Colors.green.shade300;
      textColor = Colors.black;
      break;
    default:
      bgColor = Colors.grey.shade300;
      textColor = Colors.black;
  }

  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      status,
      style: TextStyle(
        color: textColor,
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
    ),
  );
}

extension DateFormatExtension on DateTime {
  String toShortString() {
    return '${this.day}/${this.month}/${this.year}';
  }
}

String _formatCurrencyDouble(double price) {
  final NumberFormat formatter = NumberFormat("#,##0", "vi_VN");
  return formatter.format(price);
}

Widget _colorDot(String color, {bool isSelected = false, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: 10),
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          color: HexColor(color),
          shape: BoxShape.circle,
          border: Border.all(
            width: 2,
            color: Colors.black,
          ),
        ),
      ),
    );
  }