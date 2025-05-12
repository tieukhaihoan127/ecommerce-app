import 'package:flutter/material.dart';
import '../../constants.dart';
import 'components/header.dart';

class RevenueScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1024;
    const int columnCount = 5;

    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(isMobile ? defaultPadding / 2 : defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Header(),
            const SizedBox(height: defaultPadding),
            Text(
              'Doanh thu hôm nay',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white70),
            ),
            const SizedBox(height: 12),
            _buildStatsBoxes(isMobile, isTablet),
            const SizedBox(height: 32),
            Text(
              'Doanh thu những ngày gần đây',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white70),
            ),
            const SizedBox(height: 12),
            _buildRevenueTable(context, isMobile, columnCount),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsBoxes(bool isMobile, bool isTablet) {
    if (isMobile) {
      // Trên mobile, hiển thị dạng cột với chiều cao cố định
      return Column(
        children: [
          _TodayStatsBox(
            title: 'Doanh thu',
            value: '2.350.000 đ',
            subtitle: 'Hôm nay',
            valueColor: Colors.greenAccent,
            fixedHeight: 120,
            onTap: () {},
          ),
          const SizedBox(height: defaultPadding),
          _TodayStatsBox(
            title: 'Đơn hàng',
            value: '12',
            subtitle: 'Đã bán',
            valueColor: primaryColor,
            fixedHeight: 120,
            onTap: () {},
          ),
          const SizedBox(height: defaultPadding),
          _TodayStatsBox(
            title: 'Sản phẩm',
            value: '28',
            subtitle: 'Đã bán',
            valueColor: Colors.orangeAccent,
            fixedHeight: 120,
            onTap: () {},
          ),
        ],
      );
    } else {
      // Trên tablet và desktop, hiển thị dạng hàng với chiều rộng bằng nhau
      return Row(
        children: [
          Expanded(
            flex: 1,
            child: _TodayStatsBox(
              title: 'Doanh thu',
              value: '2.350.000 đ',
              subtitle: 'Hôm nay',
              valueColor: Colors.greenAccent,
              fixedHeight: isTablet ? 140 : 120,
              onTap: () {},
            ),
          ),
          SizedBox(width: isTablet ? defaultPadding / 2 : defaultPadding),
          Expanded(
            flex: 1,
            child: _TodayStatsBox(
              title: 'Đơn hàng',
              value: '12',
              subtitle: 'Đã bán',
              valueColor: primaryColor,
              fixedHeight: isTablet ? 140 : 120,
              onTap: () {},
            ),
          ),
          SizedBox(width: isTablet ? defaultPadding / 2 : defaultPadding),
          Expanded(
            flex: 1,
            child: _TodayStatsBox(
              title: 'Sản phẩm',
              value: '28',
              subtitle: 'Đã bán',
              valueColor: Colors.orangeAccent,
              fixedHeight: isTablet ? 140 : 120,
              onTap: () {},
            ),
          ),
        ],
      );
    }
  }

  Widget _buildRevenueTable(BuildContext context, bool isMobile, int columnCount) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 8 : 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1F3A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: isMobile
          ? _buildMobileRevenueList()
          : _buildDesktopRevenueTable(context, columnCount),
    );
  }

  Widget _buildDesktopRevenueTable(BuildContext context, int columnCount) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double columnWidth = constraints.maxWidth / columnCount;

        return DataTable(
          headingTextStyle: const TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.bold,
          ),
          dataTextStyle: const TextStyle(color: Colors.white),
          columnSpacing: 0,
          columns: [
            DataColumn(label: SizedBox(width: columnWidth, child: Text('Ngày'))),
            DataColumn(label: SizedBox(width: columnWidth, child: Center(child: Text('Doanh thu')))),
            DataColumn(label: SizedBox(width: columnWidth, child: Center(child: Text('Số đơn')))),
            DataColumn(label: SizedBox(width: columnWidth, child: Center(child: Text('Số khách')))),
            DataColumn(label: SizedBox(width: columnWidth, child: Center(child: Text('Sản phẩm bán')))),
          ],
          rows: [
            _buildEvenRow('07/05/2025', '5.230.000 đ', '23', '20', '45', columnWidth),
            _buildEvenRow('06/05/2025', '4.850.000 đ', '19', '17', '38', columnWidth),
            _buildEvenRow('05/05/2025', '6.120.000 đ', '25', '22', '52', columnWidth),
            _buildEvenRow('04/05/2025', '3.190.000 đ', '15', '14', '28', columnWidth),
            _buildEvenRow('03/05/2025', '5.890.000 đ', '21', '19', '47', columnWidth),
            _buildEvenRow('02/05/2025', '5.890.000 đ', '21', '19', '47', columnWidth),
            _buildEvenRow('01/05/2025', '5.890.000 đ', '21', '19', '47', columnWidth),
            _buildEvenRow('30/04/2025', '5.890.000 đ', '21', '19', '47', columnWidth),
            _buildEvenRow('29/04/2025', '5.890.000 đ', '21', '19', '47', columnWidth),
          ],
        );
      },
    );
  }

  Widget _buildMobileRevenueList() {
    final revenues = [
      {'date': '07/05/2025', 'revenue': '5.230.000 đ', 'orders': '23', 'customers': '20', 'products': '45'},
      {'date': '06/05/2025', 'revenue': '4.850.000 đ', 'orders': '19', 'customers': '17', 'products': '38'},
      {'date': '05/05/2025', 'revenue': '6.120.000 đ', 'orders': '25', 'customers': '22', 'products': '52'},
      {'date': '04/05/2025', 'revenue': '3.190.000 đ', 'orders': '15', 'customers': '14', 'products': '28'},
      {'date': '03/05/2025', 'revenue': '5.890.000 đ', 'orders': '21', 'customers': '19', 'products': '47'},
      {'date': '02/05/2025', 'revenue': '5.890.000 đ', 'orders': '21', 'customers': '19', 'products': '47'},
      {'date': '01/05/2025', 'revenue': '5.890.000 đ', 'orders': '21', 'customers': '19', 'products': '47'},
    ];

    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: revenues.length,
      separatorBuilder: (context, index) => Divider(color: Colors.white24),
      itemBuilder: (context, index) {
        final revenue = revenues[index];
        return InkWell(
          onTap: () {
            _showRevenueDetailDialog(
              context,
              revenue['date']!,
              revenue['revenue']!,
              revenue['orders']!,
              revenue['customers']!,
              revenue['products']!,
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      revenue['date']!,
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Text(
                      revenue['revenue']!,
                      style: TextStyle(color: Colors.greenAccent),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Đơn: ${revenue['orders']!}', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    Text('KH: ${revenue['customers']!}', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    Text('SP: ${revenue['products']!}', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

DataRow _buildEvenRow(
    String date,
    String revenue,
    String orders,
    String customers,
    String products,
    double colWidth,
    ) {
  return DataRow(
    cells: [
      DataCell(SizedBox(
        width: colWidth,
        child: Text(date),
      )),
      DataCell(SizedBox(
        width: colWidth,
        child: Center(child: Text(revenue, textAlign: TextAlign.center, style: TextStyle(color: Colors.greenAccent))),
      )),
      DataCell(SizedBox(
        width: colWidth,
        child: Center(child: Text(orders, textAlign: TextAlign.center)),
      )),
      DataCell(SizedBox(
        width: colWidth,
        child: Center(child: Text(customers, textAlign: TextAlign.center)),
      )),
      DataCell(SizedBox(
        width: colWidth,
        child: Center(child: Text(products, textAlign: TextAlign.center)),
      )),
    ],
  );
}

class _TodayStatsBox extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final Color valueColor;
  final double? fixedHeight;
  final VoidCallback? onTap;

  const _TodayStatsBox({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.valueColor,
    this.fixedHeight,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final isTablet = MediaQuery.of(context).size.width >= 600 && MediaQuery.of(context).size.width < 1024;
    final isDesktop = !isMobile && !isTablet;

    // Tăng chiều cao tối thiểu để tránh tràn nội dung
    final minHeight = isMobile ? 120.0 : isTablet ? 140.0 : 120.0;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          constraints: BoxConstraints(
            minHeight: fixedHeight ?? minHeight,
          ),
          padding: EdgeInsets.all(isMobile ? 16 : isTablet ? 10 : 12),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1F3A),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: valueColor.withOpacity(0.3), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: isMobile ? 16 : isTablet ? 14 : 15,
                    ),
                  ),
                  if (isDesktop)
                    Icon(Icons.info_outline, color: Colors.white30, size: 16),
                ],
              ),
              SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  color: valueColor,
                  fontSize: isMobile ? 24 : isTablet ? 18 : 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: isMobile ? 12 : 10,
                ),
              ),
              SizedBox(height: 4),
            ],
          ),
        ),
      ),
    );
  }
}

void _showRevenueDetailDialog(
    BuildContext context,
    String date,
    String revenue,
    String orders,
    String customers,
    String products,
    ) {
  final screenWidth = MediaQuery.of(context).size.width;
  final isMobile = screenWidth < 600;

  showDialog(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: const Color(0xFF1E1F3A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: screenWidth * (isMobile ? 0.95 : 0.6),
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
        padding: EdgeInsets.all(isMobile ? 16 : 24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Chi tiết doanh thu',
                      style: TextStyle(
                        fontSize: isMobile ? 18 : 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.white70),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),
              const SizedBox(height: 16),
              _detailRow('Ngày:', date, isMobile),
              _detailRow('Doanh thu:', revenue, isMobile),
              _detailRow('Số đơn hàng:', orders, isMobile),
              _detailRow('Số khách hàng:', customers, isMobile),
              _detailRow('Sản phẩm đã bán:', products, isMobile),
              const SizedBox(height: 12),
              Text(
                'Sản phẩm bán chạy:',
                style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(isMobile ? 8 : 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF2F2F5D),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _productSaleItem('1. CPU Intel Core i7-14700K - 8 sản phẩm', '12.800.000 đ', isMobile),
                    SizedBox(height: isMobile ? 8 : 4),
                    _productSaleItem('2. Mainboard ASUS TUF GAMING Z890-PLUS - 5 sản phẩm', '7.500.000 đ', isMobile),
                    SizedBox(height: isMobile ? 8 : 4),
                    _productSaleItem('3. Card màn hình MSI RTX 5060 Ti - 4 sản phẩm', '10.400.000 đ', isMobile),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Đóng', style: TextStyle(color: Colors.blueAccent)),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget _detailRow(String label, String value, bool isMobile) {
  if (isMobile) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.white70, fontSize: 14)),
          SizedBox(height: 4),
          Text(value, style: TextStyle(color: Colors.white, fontSize: 16)),
        ],
      ),
    );
  } else {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(label, style: TextStyle(color: Colors.white70))),
          Expanded(flex: 5, child: Text(value, style: TextStyle(color: Colors.white))),
        ],
      ),
    );
  }
}

Widget _productSaleItem(String productName, String revenue, bool isMobile) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: Text(
          productName,
          style: TextStyle(
            color: Colors.white70,
            fontSize: isMobile ? 13 : 14,
          ),
        ),
      ),
      Text(
        revenue,
        style: TextStyle(
          color: Colors.greenAccent,
          fontSize: isMobile ? 13 : 14,
        ),
      ),
    ],
  );
}
