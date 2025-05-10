import 'package:ecommerce_app/core/config/responsive.dart';
import 'package:ecommerce_app/core/theme/constant.dart';
import 'package:ecommerce_app/providers/admin_provider.dart';
import 'package:ecommerce_app/providers/coupon_provider.dart';
import 'package:ecommerce_app/screens/admin/header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateCouponScreen extends StatefulWidget {
  const CreateCouponScreen({super.key});

  @override
  State<CreateCouponScreen> createState() => _CreateCouponScreenState();
}

class _CreateCouponScreenState extends State<CreateCouponScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _usageLimitController = TextEditingController();
  int? _selectedDiscount;

  final List<int> _discountOptions = [10000, 20000, 50000, 100000];

  @override
  Widget build(BuildContext context) {

    final couponProvider = Provider.of<CouponProvider>(context);

    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            const Header(),
            const SizedBox(height: defaultPadding),
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
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Tạo mã giảm giá mới",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: defaultPadding),
                          TextFormField(
                            controller: _codeController,
                            maxLength: 5,
                            decoration: const InputDecoration(
                              labelText: 'Mã coupon (5 ký tự chữ và số)',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng nhập mã';
                              }
                              if (!RegExp(r'^[a-zA-Z0-9]{5}$').hasMatch(value)) {
                                return 'Mã gồm đúng 5 ký tự chữ hoặc số';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: defaultPadding),
                          DropdownButtonFormField<int>(
                            decoration: const InputDecoration(
                              labelText: 'Mức giảm (VND)',
                              border: OutlineInputBorder(),
                            ),
                            value: _selectedDiscount,
                            items: _discountOptions.map((value) {
                              return DropdownMenuItem<int>(
                                value: value,
                                child: Text('$value VND'),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedDiscount = value;
                              });
                            },
                            validator: (value) {
                              if (value == null) return 'Vui lòng chọn mức giảm';
                              return null;
                            },
                          ),
                          const SizedBox(height: defaultPadding * 2),
                          TextFormField(
                            controller: _usageLimitController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Số lượt sử dụng tối đa (tối đa 10)',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              final number = int.tryParse(value ?? '');
                              if (number == null || number < 1 || number > 10) {
                                return 'Chỉ cho phép từ 1 đến 10';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: defaultPadding * 2),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  final message = await couponProvider.addCoupon(_codeController.text, _selectedDiscount!, int.parse(_usageLimitController.text));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Đã thêm coupon thành công!", style: TextStyle(color: Colors.white),), backgroundColor: bgColor, ),
                                  );
                                  context.read<AdminProvider>().changePage(AppPage.coupon);
                                }
                              },
                              icon: const Icon(Icons.save, color: Colors.white,),
                              label: const Text("Tạo mã", style: TextStyle(color: Colors.white),),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                backgroundColor: Colors.blueAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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
}
