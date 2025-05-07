import 'package:cloudinary_url_gen/config/cloud_config.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../responsive.dart';
import 'components/header.dart';


class RevenueScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(),
            SizedBox(height: defaultPadding),
            const SizedBox(height: 32),
            Row(
              children: [
                Text(
                  'Doanh thu hôm nay',
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white70),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      _TodayStatsBox(
                        title: 'Doanh thu',
                        value: '2.350.000 đ',
                        subtitle: '',
                        valueColor: Colors.greenAccent,
                      ),
                      SizedBox(width: 16),
                      _TodayStatsBox(
                        title: 'Đơn hàng',
                        value: '12',
                        subtitle: '',
                        valueColor: primaryColor,
                      ),
                    ],
                  ),
                ),
                if (!isMobile) Expanded(child: SizedBox()),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Text(
                  'Doanh thu những ngày gần đây',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white70),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1F3A),
                borderRadius: BorderRadius.circular(16),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingTextStyle: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                  ),
                  columnSpacing: defaultPadding,
                  dataTextStyle: TextStyle(color: Colors.white),
                  columns: [
                    DataColumn(label: Text('Ngày')),
                    DataColumn(
                      label: Text('Doanh thu'),
                      numeric: true,
                    ),
                    DataColumn(
                      label: Text('Số đơn'),
                      numeric: true,
                    ),
                    DataColumn(
                      label: Text('Số khách'),
                      numeric: true,
                    ),
                    DataColumn(
                      label: Text('Sản phẩm bán'),
                      numeric: true,
                    ),
                  ],
                  rows: [
                    _buildDataRow(
                      date: '07/05/2025',
                      revenue: '5.230.000 đ',
                      orders: '23',
                      customers: '20',
                      products: '45',
                    ),
                    _buildDataRow(
                      date: '06/05/2025',
                      revenue: '4.850.000 đ',
                      orders: '19',
                      customers: '17',
                      products: '38',
                    ),
                    _buildDataRow(
                      date: '05/05/2025',
                      revenue: '6.120.000 đ',
                      orders: '25',
                      customers: '22',
                      products: '52',
                    ),
                    _buildDataRow(
                      date: '04/05/2025',
                      revenue: '3.190.000 đ',
                      orders: '15',
                      customers: '14',
                      products: '28',
                    ),
                    _buildDataRow(
                      date: '03/05/2025',
                      revenue: '5.890.000 đ',
                      orders: '21',
                      customers: '19',
                      products: '47',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  DataRow _buildDataRow({
    required String date,
    required String revenue,
    required String orders,
    required String customers,
    required String products,
  }) {
    return DataRow(
      cells: [
        DataCell(Text(date)),
        DataCell(Text(
          revenue,
          style: TextStyle(color: Colors.greenAccent),
        )),
        DataCell(Text(orders)),
        DataCell(Text(customers)),
        DataCell(Text(products)),
      ],
    );
  }
}
class _TodayStatsBox extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final Color valueColor;

  const _TodayStatsBox({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1F3A),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: valueColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


