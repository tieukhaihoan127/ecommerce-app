import 'package:flutter/material.dart';
import '../../constants.dart';
import 'components/header.dart';

class InvoiceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1024;

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
              'Tổng quan hóa đơn hôm nay',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white70),
            ),
            const SizedBox(height: 12),
            _buildStatsBoxes(isMobile, isTablet),
            const SizedBox(height: 32),
            Text(
              'Danh sách hóa đơn',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white70),
            ),
            const SizedBox(height: 12),
            _buildInvoiceTable(context, isMobile),
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
            title: 'Tổng hóa đơn',
            value: '124',
            subtitle: 'Đã ghi nhận',
            valueColor: Colors.greenAccent,
            fixedHeight: 100, // Chiều cao cố định cho mỗi box
          ),
          const SizedBox(height: defaultPadding),
          _TodayStatsBox(
            title: 'Tổng doanh thu',
            value: '75.800.000 đ',
            subtitle: 'Trong ngày',
            valueColor: Colors.lightBlueAccent,
            fixedHeight: 100, // Chiều cao cố định cho mỗi box
          ),
          const SizedBox(height: defaultPadding),
          _TodayStatsBox(
            title: 'Khách hàng',
            value: '112',
            subtitle: 'Đã mua',
            valueColor: Colors.orangeAccent,
            fixedHeight: 100, // Chiều cao cố định cho mỗi box
          ),
        ],
      );
    } else {
      // Trên tablet và desktop, hiển thị dạng hàng với chiều rộng bằng nhau
      return Row(
        children: [
          Expanded(
            flex: 1, // Đảm bảo mỗi box chiếm 1/3 chiều rộng
            child: _TodayStatsBox(
              title: 'Tổng hóa đơn',
              value: '124',
              subtitle: 'Đã ghi nhận',
              valueColor: Colors.greenAccent,
              fixedHeight: isTablet ? 120 : 100, // Chiều cao cố định cho mỗi box
            ),
          ),
          SizedBox(width: isTablet ? defaultPadding / 2 : defaultPadding),
          Expanded(
            flex: 1, // Đảm bảo mỗi box chiếm 1/3 chiều rộng
            child: _TodayStatsBox(
              title: 'Tổng doanh thu',
              value: '75.800.000 đ',
              subtitle: 'Trong ngày',
              valueColor: Colors.lightBlueAccent,
              fixedHeight: isTablet ? 120 : 100, // Chiều cao cố định cho mỗi box
            ),
          ),
          SizedBox(width: isTablet ? defaultPadding / 2 : defaultPadding),
          Expanded(
            flex: 1, // Đảm bảo mỗi box chiếm 1/3 chiều rộng
            child: _TodayStatsBox(
              title: 'Khách hàng',
              value: '112',
              subtitle: 'Đã mua',
              valueColor: Colors.orangeAccent,
              fixedHeight: isTablet ? 120 : 100, // Chiều cao cố định cho mỗi box
            ),
          ),
        ],
      );
    }
  }


  Widget _buildInvoiceTable(BuildContext context, bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 8 : 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1F3A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: isMobile
          ? _buildMobileInvoiceList(context)
          : _buildDesktopInvoiceTable(context),
    );
  }

  Widget _buildDesktopInvoiceTable(BuildContext context) {
    const int columnCount = 5;

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
            DataColumn(label: SizedBox(width: columnWidth, child: Text('Mã đơn'))),
            DataColumn(label: SizedBox(width: columnWidth, child: Text('Khách hàng'))),
            DataColumn(label: SizedBox(width: columnWidth, child: Text('Ngày tạo'))),
            DataColumn(label: SizedBox(width: columnWidth, child: Text('Tổng tiền'))),
            DataColumn(label: SizedBox(width: columnWidth, child: Text('Trạng thái'))),
          ],
          rows: [
            _buildInvoiceRow('HD001', 'Nguyễn Văn A', '07/05/2025', '5.230.000 đ', 'Đã thanh toán', columnWidth, context),
            _buildInvoiceRow('HD002', 'Lê Thị B', '07/05/2025', '2.100.000 đ', 'Chờ thanh toán', columnWidth, context),
            _buildInvoiceRow('HD003', 'Trần Văn C', '06/05/2025', '3.500.000 đ', 'Đã thanh toán', columnWidth, context),
            _buildInvoiceRow('HD004', 'Phạm Thị D', '06/05/2025', '4.200.000 đ', 'Chờ thanh toán', columnWidth, context),
            _buildInvoiceRow('HD005', 'Bùi Văn E', '05/05/2025', '6.000.000 đ', 'Đã thanh toán', columnWidth, context),
          ],
        );
      },
    );
  }

  Widget _buildMobileInvoiceList(BuildContext context) {
    final invoices = [
      {'code': 'HD001', 'customer': 'Nguyễn Văn A', 'date': '07/05/2025', 'total': '5.230.000 đ', 'status': 'Đã thanh toán'},
      {'code': 'HD002', 'customer': 'Lê Thị B', 'date': '07/05/2025', 'total': '2.100.000 đ', 'status': 'Chờ thanh toán'},
      {'code': 'HD003', 'customer': 'Trần Văn C', 'date': '06/05/2025', 'total': '3.500.000 đ', 'status': 'Đã thanh toán'},
      {'code': 'HD004', 'customer': 'Phạm Thị D', 'date': '06/05/2025', 'total': '4.200.000 đ', 'status': 'Chờ thanh toán'},
      {'code': 'HD005', 'customer': 'Bùi Văn E', 'date': '05/05/2025', 'total': '6.000.000 đ', 'status': 'Đã thanh toán'},
    ];

    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: invoices.length,
      separatorBuilder: (context, index) => Divider(color: Colors.white24),
      itemBuilder: (context, index) {
        final invoice = invoices[index];
        return InkWell(
          onTap: () {
            _showInvoiceDetailDialog(
                context,
                invoice['code']!,
                invoice['customer']!,
                invoice['date']!,
                invoice['total']!,
                invoice['status']!
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
                    Text(invoice['code']!, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                    Text(
                      invoice['status']!,
                      style: TextStyle(
                        color: invoice['status'] == 'Đã thanh toán' ? Colors.greenAccent : Colors.orangeAccent,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(invoice['customer']!, style: TextStyle(color: Colors.white)),
                SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(invoice['date']!, style: TextStyle(color: Colors.white70, fontSize: 12)),
                    Text(invoice['total']!, style: TextStyle(color: Colors.lightBlueAccent)),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  DataRow _buildInvoiceRow(
      String code,
      String customer,
      String date,
      String total,
      String status,
      double colWidth,
      BuildContext context,
      ) {
    return DataRow(
      cells: [
        DataCell(SizedBox(width: colWidth, child: Text(code))),
        DataCell(SizedBox(width: colWidth, child: Text(customer))),
        DataCell(SizedBox(width: colWidth, child: Text(date))),
        DataCell(SizedBox(width: colWidth, child: Text(total))),
        DataCell(SizedBox(
          width: colWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                status,
                style: TextStyle(
                  color: status == 'Đã thanh toán' ? Colors.greenAccent : Colors.orangeAccent,
                ),
              ),
              IconButton(
                icon: Icon(Icons.info_outline, color: Colors.blueAccent, size: 20),
                onPressed: () {
                  _showInvoiceDetailDialog(context, code, customer, date, total, status);
                },
              ),
            ],
          ),
        )),
      ],
    );
  }
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
            minHeight: fixedHeight ?? minHeight, // Tăng chiều cao tối thiểu
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
              SizedBox(height: 4), // Thêm khoảng cách ở đầu
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
              SizedBox(height: 4), // Thêm khoảng cách ở cuối
            ],
          ),
        ),
      ),
    );
  }
}


void _showInvoiceDetailDialog(BuildContext context, String code, String customer, String date, String total, String status) {
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
                      'Chi tiết hóa đơn',
                      style: TextStyle(
                          fontSize: isMobile ? 18 : 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
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
              _invoiceDetailRow('Mã hóa đơn:', code, isMobile),
              _invoiceDetailRow('Khách hàng:', customer, isMobile),
              _invoiceDetailRow('Ngày tạo:', date, isMobile),
              _invoiceDetailRow('Tổng tiền:', total, isMobile),
              _invoiceDetailRow('Trạng thái:', status, isMobile),
              const SizedBox(height: 12),
              Text(
                'Danh sách sản phẩm:',
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
                    _productItem('1. CPU Intel Core i7-14700K (UP TO 5.6Ghz, 20 NHÂN 28 LUỒNG, 33MB CACHE, 125W) - Socket Intel LGA 1700/RAPTOR LAKE', isMobile),
                    SizedBox(height: isMobile ? 8 : 4),
                    _productItem('2. Mainboard ASUS TUF GAMING Z890-PLUS WIFI DDR5', isMobile),
                    SizedBox(height: isMobile ? 8 : 4),
                    _productItem('3. Card màn hình MSI RTX 5060 Ti 16G GAMING TRIO OC', isMobile),
                    SizedBox(height: isMobile ? 8 : 4),
                    _productItem('4. RAM Desktop Gskill Trident Z Royal RGB (F5-6400J3239G32GX2-TR5S) 64GB (2x32GB) DDR5 6400 MHz', isMobile),
                    SizedBox(height: isMobile ? 8 : 4),
                    _productItem('5. Vỏ Case Asus ROG Hyperion GR701 (Full Tower / Màu Đen)', isMobile),
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

Widget _invoiceDetailRow(String label, String value, bool isMobile) {
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

Widget _productItem(String text, bool isMobile) {
  return Text(
    text,
    style: TextStyle(
      color: Colors.white70,
      fontSize: isMobile ? 13 : 14,
    ),
  );
}
