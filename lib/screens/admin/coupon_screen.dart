import 'package:ecommerce_app/core/theme/constant.dart';
import 'package:ecommerce_app/models/coupon_admin.dart';
import 'package:ecommerce_app/providers/admin_provider.dart';
import 'package:ecommerce_app/providers/coupon_provider.dart';
import 'package:ecommerce_app/screens/admin/header.dart';
import 'package:ecommerce_app/core/config/responsive.dart';
import 'package:ecommerce_app/screens/admin/order_coupon_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CouponScreen extends StatefulWidget{

  const CouponScreen({super.key});

  @override
  _CouponScreenState createState() => _CouponScreenState();

}

class _CouponScreenState extends State<CouponScreen> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<CouponProvider>(context, listen: false).loadCouponAdmin();
    });
  }

  @override
  Widget build(BuildContext context) {

    final couponProvider = Provider.of<CouponProvider>(context);

  if (couponProvider.couponAdmin == null || couponProvider.isLoading) {
    return const Center(
      child: SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }

  if (couponProvider.couponAdmin!.isEmpty) {
    return const Center(child: Text('You do not have any valid coupon'));
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
                              children: [
                                Text(
                                  "Quản lý coupon",
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                ElevatedButton.icon(
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: defaultPadding * 1.5,
                                      vertical:
                                          defaultPadding / (Responsive.isMobile(context) ? 2 : 1),
                                    ),
                                  ),
                                  onPressed: () {
                                    context.read<AdminProvider>().changePage(AppPage.createCoupon!);
                                    if (Responsive.isMobile(context)) {
                                      Navigator.pop(context);
                                    }
                                  },
                                  icon: Icon(Icons.add, color: Colors.white),
                                  label: Text("Thêm coupon", style: TextStyle(color: Colors.white),),
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
                                    label: Text("Mã coupon"),
                                  ),
                                  DataColumn(
                                    label: Text("Giảm giá"),
                                  ),
                                  DataColumn(
                                    label: Text("Số lượng sử dụng tối đa"),
                                  ),
                                  DataColumn(
                                    label: Text("Số lượng đã sử dụng"),
                                  ),
                                  DataColumn(
                                    label: Text("Hành động"),
                                  ),
                                ],
                                rows: List.generate(
                                  couponProvider.couponAdmin?.length ?? 0,
                                  (index) => recentFileDataRow(couponProvider.couponAdmin![index], context),
                                ),
                              ),
                            ),
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

DataRow recentFileDataRow(CouponAdminModel couponInfo, BuildContext context) {

  return DataRow(
    cells: [
      DataCell(Text(couponInfo.code!)),
      DataCell(Text("${couponInfo.discount.toString()} VND")),
      DataCell(Text(couponInfo.stock.toString())),
      DataCell(Text(couponInfo.numberUsed.toString())),
      DataCell(
        ElevatedButton(
          onPressed: () {
            context.read<AdminProvider>().changePage(AppPage.couponOrder, couponId: couponInfo.id!);
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
            'Xem hóa đơn',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    ],
  );
}