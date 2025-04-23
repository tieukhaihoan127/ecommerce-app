import 'package:ecommerce_app/models/checkout_order.dart';
import 'package:ecommerce_app/providers/order_provider.dart';
import 'package:ecommerce_app/screens/client/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PaymentSelectionScreen extends StatefulWidget {
  final CheckoutOrderModel order;

  final double totalPrice;

  const PaymentSelectionScreen({super.key, required this.order, required this.totalPrice});

  
  @override
  _PaymentSelectionScreenState createState() => _PaymentSelectionScreenState();
}

class _PaymentSelectionScreenState extends State<PaymentSelectionScreen> {
  String _selectedMethod = 'Cash on Delivery';

  final List<PaymentMethod> _methods = [
    PaymentMethod('Cash on Delivery', 'https://res.cloudinary.com/dwdhkwu0r/image/upload/v1745417768/public/blvrkqragz4lwp5btcdf.jpg'),
    PaymentMethod('PayPal', 'https://res.cloudinary.com/dwdhkwu0r/image/upload/v1745417759/public/paczttlewhwarikfgb1s.jpg'),
    PaymentMethod('Apple Pay', 'https://res.cloudinary.com/dwdhkwu0r/image/upload/v1745417788/public/j6hzn8ubb7v6kvcwvmlh.jpg'),
    PaymentMethod('Google Pay', 'https://res.cloudinary.com/dwdhkwu0r/image/upload/v1745417776/public/fqtdd4hddxmz7a7ctfu2.jpg'),
  ];

  Widget _showOrderDialog(BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check, color: Colors.white, size: 32),
              ),
              const SizedBox(height: 20),
              Text(
                "Congratulations !!",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                "Your order is accepted. Your items are on the way and should arrive shortly.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[700]),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, 'tracking');
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 48),
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text("Tracking Order", style: TextStyle(color: Colors.white),),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context, 'shopping');
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: Size(double.infinity, 48),
                  side: BorderSide(color: Colors.black),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text("Continue Shopping", style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {

    final orderProvider = Provider.of<OrderProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Method', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: BackButton(color: Colors.black),
      ),
      bottomNavigationBar: 
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
              "Total price\n${_formatCurrencyDouble(widget.totalPrice)} đ",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            ElevatedButton(
              onPressed: () async {
                final result = await showDialog(
                  context: context,
                  builder: (context) => _showOrderDialog(context),
                );

                final message = await orderProvider.createOrder(widget.order);
                
                if(message != "") {
                  if (result == 'tracking') {
                    Navigator.pushNamed(context, '/tracking'); 
                  } else if (result == 'shopping') {
                    Navigator.pushNamed(context, '/home'); 
                  }
                  else {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => BottomNavBar()));
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text('Pay Now', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _methods.map((method) {
              return ListTile(
                leading: Image.network(method.iconPath, width: 32, height: 32),
                title: Text(method.name),
                trailing: Radio<String>(
                  value: method.name,
                  groupValue: _selectedMethod,
                  onChanged: (value) {
                    setState(() {
                      _selectedMethod = value!;
                    });
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}


class PaymentMethod {
  final String name;
  final String iconPath;

  PaymentMethod(this.name, this.iconPath);
}

String _formatCurrencyDouble(double price) {
  final NumberFormat formatter = NumberFormat("#,##0", "vi_VN");
  return formatter.format(price);
}
