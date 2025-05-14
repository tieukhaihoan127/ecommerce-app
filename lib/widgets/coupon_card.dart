import 'package:ecommerce_app/providers/coupon_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CouponCard extends StatelessWidget {

  final int discount;
  final String code;
  final double totalAmount;
  final int stock;

  const CouponCard({super.key, required this.discount, required this.code, required this.totalAmount, required this.stock});

  @override
  Widget build(BuildContext context) {

    final couponProvider = Provider.of<CouponProvider>(context);

    return Container(
      height: 100,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            decoration: const BoxDecoration(
              color: Color(0xFF0D1F3C),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
            ),
            child: Center(
              child: RotatedBox(
                quarterTurns: -1,
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: _formatCurrency(discount),
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      TextSpan(
                        text: ' VND',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ClipPath(
              clipper: TicketShapeClipper(),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      code,
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Stock: $stock',
                          style: TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                        GestureDetector(
                          onTap: () async {

                            if(discount > totalAmount) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Mã coupon không hợp lệ!")),
                              );
                              couponProvider.resetCode();
                              couponProvider.resetValue();
                            }
                            else{
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Áp dụng mã coupon thành công!")),
                              );
                              couponProvider.setCode(code);
                              couponProvider.setValue(discount);
                            }

                            Navigator.pop(context);
                          },
                          child: Text(
                            'APPLY',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom clipper to simulate ticket edge
class TicketShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const double radius = 10;
    Path path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width - radius, 0)
      ..arcToPoint(Offset(size.width, radius),
          radius: const Radius.circular(radius), clockwise: true)
      ..lineTo(size.width, size.height - radius)
      ..arcToPoint(Offset(size.width - radius, size.height),
          radius: const Radius.circular(radius), clockwise: true)
      ..lineTo(0, size.height)
      ..arcToPoint(Offset(0, size.height - 20),
          radius: const Radius.circular(10), clockwise: false)
      ..lineTo(0, 20)
      ..arcToPoint(Offset(0, 0),
          radius: const Radius.circular(10), clockwise: false)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

String _formatCurrency(int price) {
  final NumberFormat formatter = NumberFormat("#,##0", "vi_VN");
  return formatter.format(price);
}