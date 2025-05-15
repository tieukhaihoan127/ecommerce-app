import 'package:ecommerce_app/models/cart.dart';
import 'package:ecommerce_app/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/widgets/hex_color.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CartItemCard extends StatefulWidget {

  CartModel productCart;

  final Function(int) onQuantityChangedUp;

  final Function(int) onQuantityChangedDown;

  final VoidCallback onRemove;

  CartItemCard({super.key, required this.productCart, required this.onQuantityChangedUp, required this.onQuantityChangedDown, required this.onRemove});

  @override
  State<CartItemCard> createState() => _CartItemCardState();
}

class _CartItemCardState extends State<CartItemCard> {

  bool _isUpdating = false;

  void _changeQuantityUp(int delta) async {
    final newQty = widget.productCart.quantity! + delta;
    setState(() => _isUpdating = true);
    await widget.onQuantityChangedUp(newQty);
    setState(() => _isUpdating = false);
  }

  void _changeQuantityDown(int delta) async {
    final newQty = widget.productCart.quantity! + delta;
    if (newQty <= 0) return;
    setState(() => _isUpdating = true);
    await widget.onQuantityChangedDown(newQty);
    setState(() => _isUpdating = false);
  }

  void _removeItem() async {
    setState(() => _isUpdating = true);
    widget.onRemove();
    setState(() => _isUpdating = false);
  }


  @override
  Widget build(BuildContext context) {

    final cartProvider = Provider.of<CartProvider>(context);
    final currentQty = widget.productCart.quantity ?? 0;
    final currentPrice = widget.productCart.totalPrice ?? 0;
    final currentPriceNew = widget.productCart.carts?.price ?? 0;

    return Opacity(
      opacity: _isUpdating ? 0.5 : 1,
      child: _isUpdating ? Center(child: const SizedBox( width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2),)) :
       Card(
        margin: const EdgeInsets.symmetric( vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  widget.productCart.carts?.thumbnail ?? "Empty",
                  width: 80,
                  height: 110,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.productCart.carts?.title ?? "",
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            onPressed: _removeItem,
                            icon: const Icon(Icons.delete, color: Colors.grey),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Text("Qty: ${currentQty ?? 0}", style: TextStyle(color: Colors.grey)),
                        const SizedBox(width: 8),
                        const Text("|", style: TextStyle(color: Colors.grey)),
                        const SizedBox(width: 8),
                        _colorDot(widget.productCart.color ?? "")
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: 
                          [
                            if(widget.productCart.carts!.discountPercentage! <= 0) ...[
                              Text(
                                "${_formatCurrency(currentPriceNew * currentQty)} đ",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              )
                            ]
                            else ...[
                              Text(
                                "${_formatCurrency(currentPrice)} đ",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(
                                "${_formatCurrency(currentPriceNew * currentQty)} đ",
                                style: TextStyle(fontSize: 14, color: Colors.grey, decoration: TextDecoration.lineThrough),
                              ),
                            ]
                              
                          ],
                        ),
                        _counterControl(cartProvider, currentQty)
                      ],
                    ),
                    // const SizedBox(height: 12),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _colorDot(String color, {bool isSelected = false, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: HexColor(color),
          shape: BoxShape.circle,
          border: Border.all(
            width: 2,
            color: isSelected ? Colors.black : Colors.grey.shade400,
          ),
        ),
      ),
    );
  }

  Widget _circleButton(IconData icon, Color bgColor, Color iconColor, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
    );
  }

  Widget _counterControl(CartProvider cart, int quantity) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _circleButton(Icons.remove, Colors.grey.shade200, Colors.black, () => _changeQuantityDown(-1)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              '$quantity',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          _circleButton(Icons.add, Colors.black, Colors.white, () => _changeQuantityUp(1))
        ],
      ),
    );
  }
}

String _formatCurrency(int price) {
  final NumberFormat formatter = NumberFormat("#,##0", "vi_VN");
  return formatter.format(price);
}