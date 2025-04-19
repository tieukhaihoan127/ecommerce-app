import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class OrderInfoSection extends StatelessWidget {
  const OrderInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                      "#A1OPEN000542",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.black),
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
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "Order Info",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _orderRow("Sub Total", "\$304.00"),
                const SizedBox(height: 8),
                _orderRow("Shipping charge", "\$20.00"),
                const SizedBox(height: 8),
                _orderRow("Discount(10%)", "\$0.00"),
                const Divider(height: 24, thickness: 1),
                _orderRow("Total Amount", "\$324.00", isBold: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _orderRow(String label, String amount, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.black87,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontSize: isBold ? 16 : 14,
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontSize: isBold ? 16 : 14,
          ),
        ),
      ],
    );
  }
}
