import 'package:ecommerce_app/core/config/responsive.dart';
import 'package:ecommerce_app/core/theme/constant.dart';
import 'package:ecommerce_app/providers/admin_provider.dart';
import 'package:ecommerce_app/providers/order_provider.dart';
import 'package:ecommerce_app/screens/admin/header.dart';
import 'package:ecommerce_app/widgets/order_item_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OrderDetailAdminScreen extends StatefulWidget {
  final String orderId;

  const OrderDetailAdminScreen({super.key, required this.orderId});

  @override
  State<OrderDetailAdminScreen> createState() => _OrderDetailAdminScreenState();
}

class _OrderDetailAdminScreenState extends State<OrderDetailAdminScreen> {
  String _selectedStatus = "";

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<OrderProvider>(context, listen: false).getAdminOrderDetail(widget.orderId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final order = orderProvider.orderDetailAdmin;

    if (orderProvider.orderDetailAdmin == null || orderProvider.isLoading) {
    return const Center(
      child: SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }

  if(order!.status != ""){
    _selectedStatus = order.status!;
  }

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            const Header(),
            const SizedBox(height: defaultPadding),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () {
                  context.read<AdminProvider>().changePage(AppPage.invoice);
                },
                icon: Icon(Icons.arrow_back, color: Colors.white70),
                label: Text(
                  "Quay lại",
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Container(
                    padding: const EdgeInsets.all(defaultPadding),
                    decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: orderProvider.isLoading || order == null
                        ? const Center(child: CircularProgressIndicator())
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Chi tiết đơn hàng", style: Theme.of(context).textTheme.titleMedium),
                              const SizedBox(height: defaultPadding),
                              _buildClientInfo(order),
                              const SizedBox(height: defaultPadding),
                              Text("Danh sách sản phẩm", style: Theme.of(context).textTheme.titleSmall),
                              const SizedBox(height: 8),
                              ...order.products!
                                  .map((item) => Padding(
                                        padding: const EdgeInsets.only(bottom: 12),
                                        child: OrderItemCard(product: item),
                                      ))
                                  .toList(),
                              _buildOrderInfo(order),
                              const SizedBox(height: defaultPadding * 2),
                              _buildStatusDropdown(),
                            ],
                          ),
                  ),
                ),
                if (!Responsive.isMobile(context))
                  const SizedBox(width: defaultPadding),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClientInfo(order) {
    final userInfo = order.userInfo!;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow("Tên khách hàng", userInfo.fullName!),
          _buildInfoRow("Email", userInfo.email!),
          _buildInfoRow("SĐT", userInfo.phone!),
          _buildInfoRow("Địa chỉ", "${userInfo.address}, ${userInfo.ward}, ${userInfo.district}, ${userInfo.city}"),
          _buildInfoRow("Ngày mua", _formatTimestamp(order.createdDate)),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 140, child: Text(label, style: TextStyle(color: Colors.white70))),
          Expanded(child: Text(value, style: const TextStyle(color: Colors.white))),
        ],
      ),
    );
  }

  Widget _buildOrderInfo(order) {
    double subtotal = order.totalPrice!;
    int shipping = order.shippingFee!;
    int taxes = order.taxes!;
    int coupon = order.coupon ?? 0;
    int loyalty = order.loyaltyPoint ?? 0;

    double total = subtotal + shipping + (subtotal * taxes / 100);
    total -= loyalty;
    if (coupon > 0) total -= coupon;
    if (total < 0) total = 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Thông tin đơn hàng", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _buildAmountRow("Tạm tính", subtotal),
          _buildAmountRow("Thuế", subtotal * taxes / 100),
          _buildAmountRow("Phí vận chuyển", shipping.toDouble()),
          if (loyalty > 0) _buildAmountRow("Điểm thưởng", -loyalty.toDouble()),
          if (coupon > 0) _buildAmountRow("Mã giảm giá", -coupon.toDouble()),
          const Divider(color: Colors.white38),
          _buildAmountRow("Tổng cộng", total, bold: true),
        ],
      ),
    );
  }

  Widget _buildAmountRow(String label, double value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.white70, fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
          Text("${_formatCurrencyDouble(value)} đ", style: TextStyle(color: Colors.white, fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }

  Widget _buildStatusDropdown() {
    final statuses = ['Pending', 'Confirmed', 'Shipping', 'Delivered'];

    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: "Trạng thái đơn hàng",
        border: OutlineInputBorder(),
      ),
      value: _selectedStatus,
      dropdownColor: bgColor,
      style: const TextStyle(color: Colors.white),
      iconEnabledColor: Colors.white70,
      items: statuses.map((status) {
        return DropdownMenuItem(
          value: status,
          child: Text(status),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _selectedStatus = value;
          });
          Provider.of<OrderProvider>(context, listen: false).updateOrderStatus(widget.orderId, value);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Cập nhật trạng thái thành công', style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.green,
          ));
        }
      },
    );
  }

  String _formatTimestamp(DateTime time) {
    final formatter = DateFormat('dd/MM/yyyy - HH:mm');
    return formatter.format(time);
  }

  String _formatCurrencyDouble(double price) {
    final formatter = NumberFormat("#,##0", "vi_VN");
    return formatter.format(price);
  }
}
