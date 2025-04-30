import 'package:dotted_border/dotted_border.dart';
import 'package:ecommerce_app/models/cart.dart';
import 'package:ecommerce_app/providers/cart_provider.dart';
import 'package:ecommerce_app/providers/coupon_provider.dart';
import 'package:ecommerce_app/screens/client/coupon_page.dart';
import 'package:ecommerce_app/screens/client/shipping_info.dart';
import 'package:ecommerce_app/widgets/cart_item_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  bool _useLoyalty = false;

  @override
  Widget build(BuildContext context) {

    final cartProvider = Provider.of<CartProvider>(context);
    final couponProvider = Provider.of<CouponProvider>(context);

    final cartItems = cartProvider.carts;
    final totalPrice = cartProvider.totalPrice;
    final couponId = couponProvider.code;
    final couponValue = couponProvider.value;

    print("Coupon Value: $couponValue");

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

                if(_useLoyalty) {

                  if(price > cartProvider.loyaltyPoints!) {
                    price = price - cartProvider.loyaltyPoints!;
                  }
                  else {
                    price = 0;
                  }
                  
                }

                if(couponValue! > 0) {
                  price = price - ((price * couponValue)/100);
                }

                Navigator.push(context, MaterialPageRoute(builder: (_) => ShippingInfoScreen(cartId: cartProvider.cartId!, totalPrice: price, carts: cartProvider.carts, taxes: cartProvider.taxes!, shippingFee: cartProvider.shippingFee!, loyaltyPointUsed: _useLoyalty, loyaltyPoint: cartProvider.loyaltyPoints!, couponValue: couponValue, couponId: couponId ?? "",)));
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
                      Expanded(
                        child: Text(
                          couponId ?? "Select your coupon",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          var price = totalPrice! + cartProvider.shippingFee! + ((totalPrice! * cartProvider.taxes!)/100);

                          if(_useLoyalty) {

                            if(price > cartProvider.loyaltyPoints!) {
                              price = price - cartProvider.loyaltyPoints!;
                            }
                            else {
                              price = 0;
                            }
                            
                          }

                          Navigator.push(context, MaterialPageRoute(builder: (context) => CouponScreen(totalAmount: price,)));
                        },
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
              _buildLoyaltyPointSection(cartProvider.loyaltyPoints!),
              const SizedBox(height: 20),
              buildOrderInfo(totalPrice ?? 0,cartProvider.taxes ?? 0,cartProvider.shippingFee ?? 0, cartProvider.loyaltyPoints ?? 0, couponValue ?? 0)
        ],
      ),
    );
  }

  Widget buildOrderInfo(int subtotal, int taxes, int shippingFee, int loyaltyPoint, int coupon) {
    double totalAmount = subtotal + shippingFee + ((subtotal * taxes)/100) ;

    if (_useLoyalty) {
      totalAmount -= loyaltyPoint.toDouble();
      if (totalAmount < 0) totalAmount = 0; 
    }

    if(coupon > 0) {
      totalAmount = totalAmount - ((totalAmount * coupon)/100);
    }

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
                if(_useLoyalty == true)
                  _buildInfoRow("Loyalty Point", loyaltyPoint),
                if(coupon > 0)
                  _buildInfoRowPercent("Coupon Point", coupon)
                
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

Widget _buildLoyaltyPointSection(int loyaltyPoints) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(color: Colors.black12, blurRadius: 6),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Loyalty Points Discount",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "${_formatCurrency(loyaltyPoints)} đ",
              style: TextStyle(
                color: loyaltyPoints > 0 ? Colors.black : Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
        Switch(
          value: _useLoyalty,
          onChanged: (loyaltyPoints == 0)
              ? null 
              : (bool value) {
                  setState(() {
                    _useLoyalty = value;
                  });
                },
          activeColor: Colors.black,
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
