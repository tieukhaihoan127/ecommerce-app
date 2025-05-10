import 'package:ecommerce_app/core/theme/constant.dart';
import 'package:ecommerce_app/core/config/responsive.dart';
import 'package:ecommerce_app/models/order_coupon.dart';
import 'package:ecommerce_app/providers/admin_provider.dart';
import 'package:ecommerce_app/providers/order_provider.dart';
import 'package:ecommerce_app/screens/admin/header.dart';
import 'package:ecommerce_app/screens/admin/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OrderCouponScreen extends StatefulWidget {
  final String couponId;

  const OrderCouponScreen({super.key, required this.couponId});

  @override
  State<OrderCouponScreen> createState() => _OrderCouponScreenState();
}

class _OrderCouponScreenState extends State<OrderCouponScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<OrderProvider>(context, listen: false)
          .getAllCouponOrders(widget.couponId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);

    if (orderProvider.couponOrders == null || orderProvider.isLoading) {
      return const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    if (orderProvider.couponOrders!.isEmpty) {
      return const Center(
        child: Text('You do not have any orders that using this coupon'),
      );
    }

    return SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(),
            SizedBox(height: defaultPadding),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () {
                  context.read<AdminProvider>().changePage(AppPage.coupon);
                },
                icon: Icon(Icons.arrow_back, color: Colors.white70),
                label: Text(
                  "Quay lại",
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ),
            SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      SizedBox(height: defaultPadding),
                      Container(
                        padding: EdgeInsets.all(defaultPadding),
                        decoration: BoxDecoration(
                          color: secondaryColor,
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Những đơn hàng sử dụng coupon",
                              style: const TextStyle(color: Colors.white70),
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: DataTable(
                                columnSpacing: defaultPadding,
                                columns: [
                                  DataColumn(label: Text("Mã đơn hàng")),
                                  DataColumn(label: Text("Tổng tiền")),
                                  DataColumn(label: Text("Trạng thái")),
                                  DataColumn(label: Text("Ngày tạo đơn")),
                                  DataColumn(label: Text("Hành động")),
                                ],
                                rows: List.generate(
                                  orderProvider.couponOrders?.length ?? 0,
                                  (index) => recentFileDataRow(
                                      orderProvider.couponOrders![index]),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (Responsive.isMobile(context))
                        SizedBox(height: defaultPadding),
                    ],
                  ),
                ),
                if (!Responsive.isMobile(context))
                  SizedBox(width: defaultPadding),
              ],
            ),
          ],
        ),
      );
  }
}

DataRow recentFileDataRow(OrderCouponModel orderInfo) {
  return DataRow(
    cells: [
      DataCell(Text(orderInfo.orderId!)),
      DataCell(Text("${_formatCurrencyDouble(orderInfo.totalAmount!)} VND")),
      DataCell(Text(orderInfo.latestStatus.toString())),
      DataCell(Text(_formatTimestamp(orderInfo.latestUpdatedAt!))),
      DataCell(
        ElevatedButton(
          onPressed: () {

          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          child: Text(
            'Xem sản phẩm',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    ],
  );
}

String _formatCurrencyDouble(double price) {
  final NumberFormat formatter = NumberFormat("#,##0", "vi_VN");
  return formatter.format(price);
}

String _formatTimestamp(DateTime timestamp) {
  final formatter = DateFormat('dd/MM/yyyy - HH:mm');
  return formatter.format(timestamp);
}
