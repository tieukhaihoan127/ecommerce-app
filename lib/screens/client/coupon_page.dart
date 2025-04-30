import 'package:ecommerce_app/providers/coupon_provider.dart';
import 'package:ecommerce_app/widgets/coupon_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CouponScreen extends StatefulWidget {

  final double totalAmount;

  const CouponScreen({super.key, required this.totalAmount});

  @override
  _CouponScreenState createState() => _CouponScreenState();

}


class _CouponScreenState extends State<CouponScreen> {
  
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<CouponProvider>(context, listen: false).loadCoupon();
    });
  }

  @override
  Widget build(BuildContext context) {

    final couponProvider = Provider.of<CouponProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text("Coupons", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: couponProvider.isLoading ? Center(child: const SizedBox( width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2),)) : couponProvider.coupon!.isEmpty ? const Center(child: Text('You do not have any valid coupon')) : 
      ListView.builder(
        itemCount: couponProvider.coupon!.length,
        itemBuilder: (context, index) {
          final coupon = couponProvider.coupon![index];
          return CouponCard(
            discount: coupon.discount!,
            code: coupon.code!,
            description: coupon.description!,
            totalAmount: widget.totalAmount,
          );
        },
      ),
    );
  }
}

