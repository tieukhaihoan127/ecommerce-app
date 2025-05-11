import 'package:ecommerce_app/core/theme/constant.dart';
import 'package:ecommerce_app/models/coupon_admin.dart';
import 'package:ecommerce_app/models/order_coupon.dart';
import 'package:ecommerce_app/providers/admin_provider.dart';
import 'package:ecommerce_app/providers/coupon_provider.dart';
import 'package:ecommerce_app/providers/order_provider.dart';
import 'package:ecommerce_app/screens/admin/header.dart';
import 'package:ecommerce_app/core/config/responsive.dart';
import 'package:ecommerce_app/screens/admin/order_coupon_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class InvoiceScreen extends StatefulWidget{

  const InvoiceScreen({super.key});

  @override
  _InvoiceScreenState createState() => _InvoiceScreenState();

}

class _InvoiceScreenState extends State<InvoiceScreen> {

  String _selectedFilter = 'All';

  DateTime? _startDate;

  DateTime? _endDate;

  int? _currentPage = 1;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<OrderProvider>(context, listen: false).getAllAdminOrders("All",null,null,_currentPage!);
    });
  }

  @override
  Widget build(BuildContext context) {

  final orderProvider = Provider.of<OrderProvider>(context);

  final totalPages = orderProvider.pages ?? 1;

  if (orderProvider.adminOrders == null || orderProvider.isLoading) {
    return const Center(
      child: SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }

  if (orderProvider.adminOrders!.isEmpty) {
    return const Center(child: Text('You do not have any order'));
  }

    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    DropdownButton<String>(
                                      value: _selectedFilter,
                                      items: [
                                        'All',
                                        'Today',
                                        'Yesterday',
                                        'This Week',
                                        'This Month',
                                        'Custom Range',
                                      ].map((label) => DropdownMenuItem(
                                            value: label,
                                            child: Text(label),
                                          )).toList(),
                                      onChanged: (value) async {
                                        if (value == 'Custom Range') {
                                          final pickedStart = await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(2022),
                                            lastDate: DateTime.now(),
                                          );
                                          if (pickedStart == null) return;

                                          final pickedEndRaw = await showDatePicker(
                                            context: context,
                                            initialDate: pickedStart,
                                            firstDate: pickedStart,
                                            lastDate: DateTime.now(),
                                          );
                                          if (pickedEndRaw == null) return;

                                          final pickedEnd = DateTime(
                                            pickedEndRaw.year,
                                            pickedEndRaw.month,
                                            pickedEndRaw.day,
                                            23,
                                            59,
                                            59,
                                          );

                                          setState(() {
                                            _selectedFilter = value!;
                                            _startDate = pickedStart;
                                            _endDate = pickedEnd;
                                          });

                                          orderProvider.getAllAdminOrders(_selectedFilter, _startDate, _endDate,_currentPage!);

                                        } else {
                                          setState(() {
                                            _selectedFilter = value!;
                                            _startDate = null;
                                            _endDate = null;
                                          });

                                          orderProvider.getAllAdminOrders(_selectedFilter, _startDate, _endDate,_currentPage!);

                                        }
                                      },
                                    ),
                                    if (_selectedFilter == 'Custom Range' && _startDate != null && _endDate != null)
                                      Padding(
                                        padding: const EdgeInsets.only(left: 16.0),
                                        child: Text(
                                          '${_startDate!.toLocal().toString().split(' ')[0]} → ${_endDate!.toLocal().toString().split(' ')[0]}',
                                          style: const TextStyle(color: Colors.white70),
                                        ),
                                      ),
                                  ],
                                ),

                                // Add Coupon Button
                                ElevatedButton.icon(
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: defaultPadding * 1.5,
                                      vertical: defaultPadding / (Responsive.isMobile(context) ? 2 : 1),
                                    ),
                                  ),
                                  onPressed: () {
                                    context.read<AdminProvider>().changePage(AppPage.createCoupon!);
                                    if (Responsive.isMobile(context)) {
                                      Navigator.pop(context);
                                    }
                                  },
                                  icon: Icon(Icons.add, color: Colors.white),
                                  label: Text("Thêm coupon", style: TextStyle(color: Colors.white)),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: DataTable(
                                columnSpacing: defaultPadding,
                                // minWidth: 600,
                                columns: [
                                  DataColumn(
                                    label: Text("Mã đơn hàng"),
                                  ),
                                  DataColumn(
                                    label: Text("Tổng tiền"),
                                  ),
                                  DataColumn(
                                    label: Text("Trạng thái"),
                                  ),
                                  DataColumn(
                                    label: Text("Ngày tạo đơn"),
                                  ),
                                  DataColumn(
                                    label: Text("Hành động"),
                                  ),
                                ],
                                rows: List.generate(
                                  orderProvider.adminOrders?.length ?? 0,
                                  (index) => recentFileDataRow(orderProvider.adminOrders![index],context),
                                ),
                              ),
                            ),
                            const SizedBox(height: defaultPadding),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                  onPressed: _currentPage! > 1
                                      ? () {
                                          setState(() {
                                            _currentPage = _currentPage! - 1;
                                          });
                                          orderProvider.getAllAdminOrders(_selectedFilter, _startDate, _endDate,_currentPage!);
                                        }
                                      : null,
                                  child: const Text("Trước"),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Text("Trang $_currentPage / $totalPages"),
                                ),
                                TextButton(
                                  onPressed: _currentPage! < totalPages
                                      ? () {
                                          setState(() {
                                            _currentPage = _currentPage! + 1;
                                          });
                                          orderProvider.getAllAdminOrders(_selectedFilter, _startDate, _endDate,_currentPage!);
                                        }
                                      : null,
                                  child: const Text("Sau"),
                                ),
                              ],
                            )
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
            )
          ],
        ),
      ),
    );
  }
}


DataRow recentFileDataRow(OrderCouponModel orderInfo, BuildContext context) {
  return DataRow(
    cells: [
      DataCell(Text(orderInfo.orderId!)),
      DataCell(Text("${_formatCurrencyDouble(orderInfo.totalAmount!)} VND")),
      DataCell(Text(orderInfo.latestStatus.toString())),
      DataCell(Text(_formatTimestamp(orderInfo.latestUpdatedAt!))),
      DataCell(
        ElevatedButton(
          onPressed: () {
            context.read<AdminProvider>().changePage(AppPage.detailOrder, couponId: orderInfo.orderId);
            if (Responsive.isMobile(context)) {
              Navigator.pop(context);
            }
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