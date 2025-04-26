import 'package:dotted_border/dotted_border.dart';
import 'package:ecommerce_app/models/cart.dart';
import 'package:ecommerce_app/providers/cart_provider.dart';
import 'package:ecommerce_app/screens/client/shipping_info.dart';
import 'package:ecommerce_app/widgets/cart_item_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  @override
  Widget build(BuildContext context) {

    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.carts;
    final totalPrice = cartProvider.totalPrice;

    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: BackButton(color: Colors.black),
      ),
      bottomNavigationBar: cartItems.isEmpty ? 
      null : 
      Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(blurRadius: 6, color: Colors.black12)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Total price\n${_formatCurrencyDouble(totalPrice! + cartProvider.shippingFee! + ((totalPrice! * cartProvider.taxes!)/100))} đ",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            ElevatedButton(
              onPressed: () {
                var price = totalPrice! + cartProvider.shippingFee! + ((totalPrice! * cartProvider.taxes!)/100);
                Navigator.push(context, MaterialPageRoute(builder: (_) => ShippingInfoScreen(cartId: cartProvider.cartId!, totalPrice: price, carts: cartProvider.carts, taxes: cartProvider.taxes!, shippingFee: cartProvider.shippingFee!,)));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text('Checkout', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
      body: cartProvider.isLoading ? Center(child: const SizedBox( width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2),)) : cartItems.isEmpty ? 
      const Center(child: Text('Your cart is empty')) :  
      ListView(
        padding: const EdgeInsets.all(12),
        children: [
          ...cartProvider.carts.map((item) => CartItemCard(
            productCart: item, 
            onQuantityChangedUp: (newQuantity) async {
              final message = await cartProvider.updateIncrementProductInCart(item.productId!, item.color!, newQuantity);
              if(message != "") {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(message)),
                );
              }
            },
            onQuantityChangedDown: (newQuantity) async {
              final message = await cartProvider.updateDecrementProductInCart(item.productId!, item.color!, newQuantity);
              if(message != "") {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(message)),
                );
              }
            },
            onRemove: () async {
              final message = await cartProvider.deleteProductFromCart(item.productId!, item.color!);
              if(message != "") {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(message)),
                );
              }
            },
            )).toList(),
              const SizedBox(height: 10),
              const Text(
                "Promo Code",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              DottedBorder(
                borderType: BorderType.RRect,
                radius: const Radius.circular(8),
                color: Colors.grey,
                dashPattern: [6, 4],
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          "#A10PEM000542",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Text("APPLY"),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              buildOrderInfo(totalPrice ?? 0,cartProvider.taxes ?? 0,cartProvider.shippingFee ?? 0)
        ],
      ),
    );
  }

  Widget buildOrderInfo(int subtotal, int taxes, int shippingFee) {
    double totalAmount = subtotal + shippingFee + ((subtotal * taxes)/100) ;

    return Container(
      // margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Order Info",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 12),

          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                _buildInfoRow("Sub Total", subtotal),
                _buildInfoRowPercent("Taxes", taxes),
                _buildInfoRow("Shipping Fee", shippingFee),
              ],
            ),
          ),

          SizedBox(height: 12),
          Divider(thickness: 1.2),
          SizedBox(height: 4),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total Amount",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                "${_formatCurrencyDouble(totalAmount)} đ",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
          Text(
            "${_formatCurrency(value)} đ",
            style: TextStyle(color: Colors.grey[800]),
          ),
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
          Text(
            "${_formatCurrency(value)} %",
            style: TextStyle(color: Colors.grey[800]),
          ),
        ],
      ),
    );
  }
}

String _formatCurrency(int price) {
  final NumberFormat formatter = NumberFormat("#,##0", "vi_VN");
  return formatter.format(price);
}

String _formatCurrencyDouble(double price) {
  final NumberFormat formatter = NumberFormat("#,##0", "vi_VN");
  return formatter.format(price);
}
