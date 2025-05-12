import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../constants.dart';
import 'components/header.dart';

class CouponScreen extends StatefulWidget {
  @override
  _CouponScreenState createState() => _CouponScreenState();
}

class _CouponScreenState extends State<CouponScreen> {
  String _searchQuery = '';
  String _selectedFilter = 'Tất cả';
  int _currentPage = 1;
  final int _itemsPerPage = 10;

  final List<String> _filters = [
    'Tất cả',
    'Đang hoạt động',
    'Hết hạn',
    'Sắp hết hạn',
    'Chưa kích hoạt',
  ];

  // Dữ liệu mẫu coupon
  final List<Map<String, dynamic>> _allCoupons = [
    {
      'id': 'CP001',
      'code': 'SUMMER2025',
      'discount': 15,
      'discountType': 'percent',
      'minAmount': 500000,
      'maxDiscount': 200000,
      'startDate': '2025-05-01',
      'endDate': '2025-06-30',
      'usageLimit': 100,
      'usageCount': 45,
      'status': 'Đang hoạt động',
      'description': 'Giảm 15% cho đơn hàng từ 500.000đ, tối đa 200.000đ',
      'createdAt': '2025-04-15',
    },
    {
      'id': 'CP002',
      'code': 'NEWUSER50K',
      'discount': 50000,
      'discountType': 'fixed',
      'minAmount': 300000,
      'maxDiscount': 50000,
      'startDate': '2025-01-01',
      'endDate': '2025-12-31',
      'usageLimit': 500,
      'usageCount': 234,
      'status': 'Đang hoạt động',
      'description': 'Giảm 50.000đ cho đơn hàng từ 300.000đ dành cho khách hàng mới',
      'createdAt': '2024-12-20',
    },
    {
      'id': 'CP003',
      'code': 'FLASH20',
      'discount': 20,
      'discountType': 'percent',
      'minAmount': 200000,
      'maxDiscount': 100000,
      'startDate': '2025-05-10',
      'endDate': '2025-05-15',
      'usageLimit': 50,
      'usageCount': 50,
      'status': 'Hết lượt dùng',
      'description': 'Flash sale: Giảm 20% cho đơn hàng từ 200.000đ, tối đa 100.000đ',
      'createdAt': '2025-05-01',
    },
    {
      'id': 'CP004',
      'code': 'WELCOME10',
      'discount': 10,
      'discountType': 'percent',
      'minAmount': 100000,
      'maxDiscount': 50000,
      'startDate': '2025-01-01',
      'endDate': '2025-04-30',
      'usageLimit': 1000,
      'usageCount': 876,
      'status': 'Hết hạn',
      'description': 'Giảm 10% cho đơn hàng từ 100.000đ, tối đa 50.000đ',
      'createdAt': '2024-12-15',
    },
    {
      'id': 'CP005',
      'code': 'FREESHIP',
      'discount': 30000,
      'discountType': 'fixed',
      'minAmount': 200000,
      'maxDiscount': 30000,
      'startDate': '2025-05-01',
      'endDate': '2025-07-31',
      'usageLimit': 2000,
      'usageCount': 543,
      'status': 'Đang hoạt động',
      'description': 'Miễn phí vận chuyển 30.000đ cho đơn hàng từ 200.000đ',
      'createdAt': '2025-04-20',
    },
    {
      'id': 'CP006',
      'code': 'HOLIDAY25',
      'discount': 25,
      'discountType': 'percent',
      'minAmount': 1000000,
      'maxDiscount': 500000,
      'startDate': '2025-06-01',
      'endDate': '2025-06-15',
      'usageLimit': 200,
      'usageCount': 0,
      'status': 'Chưa kích hoạt',
      'description': 'Giảm 25% cho đơn hàng từ 1.000.000đ, tối đa 500.000đ',
      'createdAt': '2025-05-10',
    },
    {
      'id': 'CP007',
      'code': 'LOYAL100K',
      'discount': 100000,
      'discountType': 'fixed',
      'minAmount': 500000,
      'maxDiscount': 100000,
      'startDate': '2025-05-15',
      'endDate': '2025-05-20',
      'usageLimit': 100,
      'usageCount': 98,
      'status': 'Sắp hết hạn',
      'description': 'Giảm 100.000đ cho đơn hàng từ 500.000đ dành cho khách hàng thân thiết',
      'createdAt': '2025-05-01',
    },
    {
      'id': 'CP008',
      'code': 'BIRTHDAY30',
      'discount': 30,
      'discountType': 'percent',
      'minAmount': 300000,
      'maxDiscount': 300000,
      'startDate': '2025-05-01',
      'endDate': '2025-12-31',
      'usageLimit': 500,
      'usageCount': 123,
      'status': 'Đang hoạt động',
      'description': 'Giảm 30% cho đơn hàng từ 300.000đ, tối đa 300.000đ nhân dịp sinh nhật',
      'createdAt': '2025-04-25',
    },
    {
      'id': 'CP009',
      'code': 'APP15',
      'discount': 15,
      'discountType': 'percent',
      'minAmount': 200000,
      'maxDiscount': 100000,
      'startDate': '2025-05-01',
      'endDate': '2025-05-31',
      'usageLimit': 300,
      'usageCount': 287,
      'status': 'Sắp hết lượt',
      'description': 'Giảm 15% cho đơn hàng từ 200.000đ, tối đa 100.000đ khi đặt qua ứng dụng',
      'createdAt': '2025-04-20',
    },
    {
      'id': 'CP010',
      'code': 'WEEKEND50',
      'discount': 50,
      'discountType': 'percent',
      'minAmount': 1000000,
      'maxDiscount': 300000,
      'startDate': '2025-05-25',
      'endDate': '2025-05-26',
      'usageLimit': 50,
      'usageCount': 0,
      'status': 'Chưa kích hoạt',
      'description': 'Giảm 50% cho đơn hàng từ 1.000.000đ, tối đa 300.000đ chỉ trong cuối tuần',
      'createdAt': '2025-05-10',
    },
    {
      'id': 'CP011',
      'code': 'MEMBER10',
      'discount': 10,
      'discountType': 'percent',
      'minAmount': 0,
      'maxDiscount': 50000,
      'startDate': '2025-01-01',
      'endDate': '2025-12-31',
      'usageLimit': 10000,
      'usageCount': 3456,
      'status': 'Đang hoạt động',
      'description': 'Giảm 10% cho tất cả đơn hàng, tối đa 50.000đ dành cho thành viên',
      'createdAt': '2024-12-15',
    },
    {
      'id': 'CP012',
      'code': 'SPECIAL200K',
      'discount': 200000,
      'discountType': 'fixed',
      'minAmount': 1500000,
      'maxDiscount': 200000,
      'startDate': '2025-06-10',
      'endDate': '2025-06-20',
      'usageLimit': 30,
      'usageCount': 0,
      'status': 'Chưa kích hoạt',
      'description': 'Giảm 200.000đ cho đơn hàng từ 1.500.000đ',
      'createdAt': '2025-05-05',
    },
  ];

  // Lọc coupon theo bộ lọc và tìm kiếm
  List<Map<String, dynamic>> get filteredCoupons {
    final now = DateTime.now();

    return _allCoupons.where((coupon) {
      // Lọc theo trạng thái
      bool matchesFilter = true;
      final startDate = DateTime.parse(coupon['startDate']);
      final endDate = DateTime.parse(coupon['endDate']);

      if (_selectedFilter == 'Đang hoạt động') {
        matchesFilter = coupon['status'] == 'Đang hoạt động';
      } else if (_selectedFilter == 'Hết hạn') {
        matchesFilter = endDate.isBefore(now) || coupon['status'] == 'Hết hạn';
      } else if (_selectedFilter == 'Sắp hết hạn') {
        final daysRemaining = endDate.difference(now).inDays;
        matchesFilter = (daysRemaining <= 7 && daysRemaining >= 0) || coupon['status'] == 'Sắp hết hạn';
      } else if (_selectedFilter == 'Chưa kích hoạt') {
        matchesFilter = startDate.isAfter(now) || coupon['status'] == 'Chưa kích hoạt';
      }

      // Lọc theo tìm kiếm
      bool matchesSearch = _searchQuery.isEmpty ||
          coupon['code'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          coupon['id'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          coupon['description'].toLowerCase().contains(_searchQuery.toLowerCase());

      return matchesFilter && matchesSearch;
    }).toList();
  }

  // Phân trang
  List<Map<String, dynamic>> get paginatedCoupons {
    final filteredList = filteredCoupons;
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage > filteredList.length
        ? filteredList.length
        : startIndex + _itemsPerPage;

    if (startIndex >= filteredList.length) {
      return [];
    }

    return filteredList.sublist(startIndex, endIndex);
  }

  // Tính toán số lượng trang
  int get pageCount {
    return (filteredCoupons.length / _itemsPerPage).ceil();
  }

  // Đếm số coupon theo trạng thái
  int get totalCoupons => _allCoupons.length;
  int get activeCoupons => _allCoupons.where((c) => c['status'] == 'Đang hoạt động').length;
  int get expiredCoupons => _allCoupons.where((c) =>
  c['status'] == 'Hết hạn' || DateTime.parse(c['endDate']).isBefore(DateTime.now())).length;
  int get upcomingCoupons => _allCoupons.where((c) =>
  c['status'] == 'Chưa kích hoạt' || DateTime.parse(c['startDate']).isAfter(DateTime.now())).length;

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
            Text("Quản lý Coupon"),
            SizedBox(height: defaultPadding),
            _buildCouponStats(isMobile),
            SizedBox(height: defaultPadding),
            _buildSearchAndFilterBar(isMobile),
            SizedBox(height: defaultPadding),
            _buildFilterTabs(),
            SizedBox(height: defaultPadding),
            _buildCouponList(isMobile, isTablet),
            if (pageCount > 1) _buildPagination(),
          ],
        ),
      ),
    );
  }

  Widget _buildCouponStats(bool isMobile) {
    return isMobile
        ? Column(
      children: [
        _buildStatCard(
          title: "Tổng Coupon",
          value: totalCoupons.toString(),
          valueColor: Color(0xFF00E396), // Màu xanh lá nhạt
          icon: Icons.card_giftcard,
        ),
        SizedBox(height: defaultPadding),
        _buildStatCard(
          title: "Đang hoạt động",
          value: activeCoupons.toString(),
          valueColor: Color(0xFF2697FF), // Màu xanh dương
          icon: Icons.check_circle,
        ),
        SizedBox(height: defaultPadding),
        _buildStatCard(
          title: "Hết hạn",
          value: expiredCoupons.toString(),
          valueColor: Color(0xFFFF4560), // Màu đỏ
          icon: Icons.timer_off,
        ),
        SizedBox(height: defaultPadding),
        _buildStatCard(
          title: "Chưa kích hoạt",
          value: upcomingCoupons.toString(),
          valueColor: Color(0xFFFFB020), // Màu cam
          icon: Icons.pending_actions,
        ),
      ],
    )
        : Row(
      children: [
        Expanded(
          child: _buildStatCard(
            title: "Tổng Coupon",
            value: totalCoupons.toString(),
            valueColor: Color(0xFF00E396),
            icon: Icons.card_giftcard,
          ),
        ),
        SizedBox(width: defaultPadding),
        Expanded(
          child: _buildStatCard(
            title: "Đang hoạt động",
            value: activeCoupons.toString(),
            valueColor: Color(0xFF2697FF),
            icon: Icons.check_circle,
          ),
        ),
        SizedBox(width: defaultPadding),
        Expanded(
          child: _buildStatCard(
            title: "Hết hạn",
            value: expiredCoupons.toString(),
            valueColor: Color(0xFFFF4560),
            icon: Icons.timer_off,
          ),
        ),
        SizedBox(width: defaultPadding),
        Expanded(
          child: _buildStatCard(
            title: "Chưa kích hoạt",
            value: upcomingCoupons.toString(),
            valueColor: Color(0xFFFFB020),
            icon: Icons.pending_actions,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required Color valueColor,
    required IconData icon,
  }) {
    return InkWell(
      onTap: () {
        setState(() {
          if (title == "Tổng Coupon") {
            _selectedFilter = "Tất cả";
          } else if (title == "Đang hoạt động") {
            _selectedFilter = "Đang hoạt động";
          } else if (title == "Hết hạn") {
            _selectedFilter = "Hết hạn";
          } else if (title == "Chưa kích hoạt") {
            _selectedFilter = "Chưa kích hoạt";
          }
          _currentPage = 1; // Reset về trang đầu tiên khi thay đổi bộ lọc
        });
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(defaultPadding),
        decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: valueColor.withOpacity(0.3), width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: valueColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: valueColor),
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: valueColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndFilterBar(bool isMobile) {
    return isMobile
        ? Column(
      children: [
        _buildSearchBar(),
        SizedBox(height: defaultPadding),
        _buildAddButton(),
      ],
    )
        : Row(
      children: [
        Expanded(child: _buildSearchBar()),
        SizedBox(width: defaultPadding),
        _buildAddButton(),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: "Tìm kiếm mã giảm giá...",
          hintStyle: TextStyle(color: Colors.white54),
          prefixIcon: Icon(Icons.search, color: Colors.white54),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
            _currentPage = 1; // Reset về trang đầu tiên khi tìm kiếm
          });
        },
      ),
    );
  }

  Widget _buildAddButton() {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),
      ),
      onPressed: () => _showAddCouponDialog(context),
      icon: Icon(Icons.add),
      label: Text("Tạo Coupon"),
    );
  }

  Widget _buildFilterTabs() {
    return Container(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = _selectedFilter == filter;

          return Padding(
            padding: EdgeInsets.only(right: 10),
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedFilter = filter;
                  _currentPage = 1; // Reset về trang đầu tiên khi thay đổi bộ lọc
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: isSelected ? primaryColor : secondaryColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? primaryColor : Colors.white24,
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    filter,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.white70,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCouponList(bool isMobile, bool isTablet) {
    final coupons = paginatedCoupons;

    if (coupons.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Icon(Icons.search_off, size: 50, color: Colors.white54),
              SizedBox(height: 10),
              Text(
                "Không tìm thấy coupon nào",
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header của bảng
          if (!isMobile) _buildTableHeader(),

          // Danh sách coupon
          ...coupons.map((coupon) => _buildCouponItem(coupon, isMobile)),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              "Mã giảm giá",
              style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              "Chi tiết",
              style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              "Thời gian",
              style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              "Trạng thái",
              style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: 50), // Khoảng trống cho nút hành động
        ],
      ),
    );
  }

  Widget _buildCouponItem(Map<String, dynamic> coupon, bool isMobile) {
    final statusColor = _getCouponStatusColor(coupon['status']);
    final discountText = coupon['discountType'] == 'percent'
        ? '${coupon['discount']}%'
        : '${_formatCurrency(coupon['discount'])}';

    final startDate = DateTime.parse(coupon['startDate']);
    final endDate = DateTime.parse(coupon['endDate']);
    final dateRange = '${DateFormat('dd/MM/yyyy').format(startDate)} - ${DateFormat('dd/MM/yyyy').format(endDate)}';

    if (isMobile) {
      return InkWell(
        onTap: () => _showCouponDetailDialog(context, coupon),
        child: Container(
          margin: EdgeInsets.only(bottom: 10),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white10),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          coupon['code'],
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          coupon['id'],
                          style: TextStyle(color: Colors.white54, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.more_vert, color: Colors.white54),
                    onPressed: () => _showCouponActions(context, coupon),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                discountText,
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 5),
              Text(
                coupon['description'],
                style: TextStyle(color: Colors.white70, fontSize: 13),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.date_range, color: Colors.white54, size: 16),
                      SizedBox(width: 5),
                      Text(
                        dateRange,
                        style: TextStyle(color: Colors.white54, fontSize: 12),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      coupon['status'],
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Text(
                'Đã sử dụng: ${coupon['usageCount']}/${coupon['usageLimit']}',
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ],
          ),
        ),
      );
    } else {
      return InkWell(
          onTap: () => _showCouponDetailDialog(context, coupon),
          child: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
    decoration: BoxDecoration(
    border: Border(bottom: BorderSide(color: Colors.white10)),
    ),
    child: Row(
    children: [
    Expanded(
    flex: 3,
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text(
    coupon['code'],
    style: TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    ),
    ),
    SizedBox(height: 4),
    Text(
    coupon['id'],
    style: TextStyle(color: Colors.white54, fontSize: 12),
    ),
    SizedBox(height: 4),
    Text(
    discountText,
    style: TextStyle(
    color: primaryColor,
    fontWeight: FontWeight.bold,
    ),
    ),
    ],
    ),
    ),
    Expanded(
    flex: 4,
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text(
    coupon['description'],
    style: TextStyle(color: Colors.white70),
    maxLines: 2,
    overflow: TextOverflow.ellipsis,
    ),
    SizedBox(height: 4),
    Text(
    'Đã sử dụng: ${coupon['usageCount']}/${coupon['usageLimit']}',
    style: TextStyle(color: Colors.white54, fontSize: 12),
    ),
    ],
    ),
    ),
      Expanded(
        flex: 2,
        child: Text(
          dateRange,
          style: TextStyle(color: Colors.white70),
        ),
      ),
      Expanded(
        flex: 2,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            coupon['status'],
            style: TextStyle(
              color: statusColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      IconButton(
        icon: Icon(Icons.more_vert, color: Colors.white54),
        onPressed: () => _showCouponActions(context, coupon),
      ),
    ],
    ),
          ),
      );
    }
  }

  Widget _buildPagination() {
    return Container(
      margin: EdgeInsets.only(top: defaultPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.chevron_left, color: _currentPage > 1 ? Colors.white : Colors.white38),
            onPressed: _currentPage > 1
                ? () => setState(() => _currentPage--)
                : null,
          ),
          for (int i = 1; i <= pageCount; i++)
            if (i == 1 || i == pageCount || (i >= _currentPage - 1 && i <= _currentPage + 1))
              Container(
                margin: EdgeInsets.symmetric(horizontal: 5),
                child: InkWell(
                  onTap: () => setState(() => _currentPage = i),
                  child: CircleAvatar(
                    radius: 15,
                    backgroundColor: i == _currentPage ? primaryColor : Colors.white10,
                    child: Text(
                      '$i',
                      style: TextStyle(
                        color: i == _currentPage ? Colors.white : Colors.white70,
                        fontWeight: i == _currentPage ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              )
            else if (i == 2 || i == pageCount - 1)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Text('...', style: TextStyle(color: Colors.white70)),
              ),
          IconButton(
            icon: Icon(Icons.chevron_right, color: _currentPage < pageCount ? Colors.white : Colors.white38),
            onPressed: _currentPage < pageCount
                ? () => setState(() => _currentPage++)
                : null,
          ),
        ],
      ),
    );
  }

  Color _getCouponStatusColor(String status) {
    switch (status) {
      case 'Đang hoạt động':
        return Color(0xFF2697FF); // Màu xanh dương
      case 'Hết hạn':
      case 'Hết lượt dùng':
        return Color(0xFFFF4560); // Màu đỏ
      case 'Sắp hết hạn':
      case 'Sắp hết lượt':
        return Color(0xFFFF9800); // Màu cam
      case 'Chưa kích hoạt':
        return Color(0xFFFFB020); // Màu vàng
      default:
        return Colors.white70;
    }
  }

  String _formatCurrency(num amount) {
    final formatter = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  void _showCouponDetailDialog(BuildContext context, Map<String, dynamic> coupon) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    final discountText = coupon['discountType'] == 'percent'
        ? '${coupon['discount']}%'
        : _formatCurrency(coupon['discount']);

    final startDate = DateTime.parse(coupon['startDate']);
    final endDate = DateTime.parse(coupon['endDate']);

    final statusColor = _getCouponStatusColor(coupon['status']);

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: secondaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: isMobile ? screenWidth * 0.9 : screenWidth * 0.6,
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Chi tiết Coupon',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.white70),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.card_giftcard,
                      color: primaryColor,
                      size: 30,
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          coupon['code'],
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                coupon['status'],
                                style: TextStyle(
                                  color: statusColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              coupon['id'],
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Divider(color: Colors.white24),
              SizedBox(height: 10),

              // Thông tin chi tiết
              _buildInfoRow('Giảm giá', discountText, valueColor: primaryColor),
              _buildInfoRow('Mô tả', coupon['description']),
              _buildInfoRow('Đơn hàng tối thiểu', _formatCurrency(coupon['minAmount'])),
              if (coupon['discountType'] == 'percent')
                _buildInfoRow('Giảm tối đa', _formatCurrency(coupon['maxDiscount'])),
              _buildInfoRow('Ngày bắt đầu', DateFormat('dd/MM/yyyy').format(startDate)),
              _buildInfoRow('Ngày kết thúc', DateFormat('dd/MM/yyyy').format(endDate)),
              _buildInfoRow('Giới hạn sử dụng', '${coupon['usageCount']}/${coupon['usageLimit']}'),
              _buildInfoRow('Ngày tạo', coupon['createdAt']),

              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Đóng', style: TextStyle(color: Colors.white70)),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      _showEditCouponDialog(context, coupon);
                    },
                    child: Text('Chỉnh sửa'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white54,
                fontSize: 14,
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: valueColor ?? Colors.white,
                fontSize: 14,
                fontWeight: valueColor != null ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCouponActions(BuildContext context, Map<String, dynamic> coupon) {
    final isActive = coupon['status'] == 'Đang hoạt động';
    final isExpired = coupon['status'] == 'Hết hạn' ||
        DateTime.parse(coupon['endDate']).isBefore(DateTime.now());
    final isNotActive = coupon['status'] == 'Chưa kích hoạt';

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: secondaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.visibility, color: Colors.white70),
                title: Text('Xem chi tiết', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _showCouponDetailDialog(context, coupon);
                },
              ),
              ListTile(
                leading: Icon(Icons.edit, color: Colors.white70),
                title: Text('Chỉnh sửa', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _showEditCouponDialog(context, coupon);
                },
              ),
              ListTile(
                leading: Icon(Icons.content_copy, color: Colors.white70),
                title: Text('Sao chép mã', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Clipboard.setData(ClipboardData(text: coupon['code']));
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Đã sao chép mã: ${coupon['code']}'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
              ),
              if (isActive)
                ListTile(
                  leading: Icon(Icons.block, color: Color(0xFFFF4560)),
                  title: Text('Vô hiệu hóa', style: TextStyle(color: Color(0xFFFF4560))),
                  onTap: () {
                    Navigator.pop(context);
                    _showDeactivateConfirmation(coupon);
                  },
                ),
              if (isNotActive)
                ListTile(
                  leading: Icon(Icons.check_circle, color: Color(0xFF2697FF)),
                  title: Text('Kích hoạt', style: TextStyle(color: Color(0xFF2697FF))),
                  onTap: () {
                    Navigator.pop(context);
                    _activateCoupon(coupon);
                  },
                ),
              if (isExpired)
                ListTile(
                  leading: Icon(Icons.refresh, color: Color(0xFF2697FF)),
                  title: Text('Gia hạn', style: TextStyle(color: Color(0xFF2697FF))),
                  onTap: () {
                    Navigator.pop(context);
                    _showExtendCouponDialog(context, coupon);
                  },
                ),
              ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text('Xóa coupon', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteConfirmation(coupon);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddCouponDialog(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    final TextEditingController codeController = TextEditingController();
    final TextEditingController discountController = TextEditingController();
    final TextEditingController minAmountController = TextEditingController();
    final TextEditingController maxDiscountController = TextEditingController();
    final TextEditingController usageLimitController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    String discountType = 'percent';
    DateTime startDate = DateTime.now();
    DateTime endDate = DateTime.now().add(Duration(days: 30));

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Dialog(
          backgroundColor: secondaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            width: isMobile ? screenWidth * 0.9 : screenWidth * 0.6,
            padding: EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Tạo Coupon mới',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.white70),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  // Mã coupon
                  _buildDialogTextField(
                    label: 'Mã Coupon',
                    controller: codeController,
                    hintText: 'Ví dụ: SUMMER2025',
                  ),
                  SizedBox(height: 15),

                  // Loại giảm giá
                  Text(
                    'Loại giảm giá',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<String>(
                          title: Text('Phần trăm (%)', style: TextStyle(color: Colors.white)),
                          value: 'percent',
                          groupValue: discountType,
                          activeColor: primaryColor,
                          contentPadding: EdgeInsets.zero,
                          onChanged: (value) {
                            setState(() {
                              discountType = value!;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<String>(
                          title: Text('Số tiền cố định', style: TextStyle(color: Colors.white)),
                          value: 'fixed',
                          groupValue: discountType,
                          activeColor: primaryColor,
                          contentPadding: EdgeInsets.zero,
                          onChanged: (value) {
                            setState(() {
                              discountType = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),

                  // Giá trị giảm giá
                  _buildDialogTextField(
                    label: discountType == 'percent' ? 'Phần trăm giảm giá' : 'Số tiền giảm giá',
                    controller: discountController,
                    hintText: discountType == 'percent' ? 'Ví dụ: 15' : 'Ví dụ: 50000',
                    keyboardType: TextInputType.number,
                    suffix: discountType == 'percent' ? '%' : '₫',
                  ),
                  SizedBox(height: 15),

                  // Giá trị đơn hàng tối thiểu
                  _buildDialogTextField(
                    label: 'Giá trị đơn hàng tối thiểu',
                    controller: minAmountController,
                    hintText: 'Ví dụ: 300000',
                    keyboardType: TextInputType.number,
                    suffix: '₫',
                  ),
                  SizedBox(height: 15),

                  // Giảm giá tối đa (chỉ cho loại phần trăm)
                  if (discountType == 'percent')
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDialogTextField(
                          label: 'Giảm giá tối đa',
                          controller: maxDiscountController,
                          hintText: 'Ví dụ: 100000',
                          keyboardType: TextInputType.number,
                          suffix: '₫',
                        ),
                        SizedBox(height: 15),
                      ],
                    ),

                  // Thời gian hiệu lực
                  Text(
                    'Thời gian hiệu lực',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: startDate,
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2030),
                              builder: (context, child) {
                                return Theme(
                                  data: ThemeData.dark().copyWith(
                                    colorScheme: ColorScheme.dark(
                                      primary: primaryColor,
                                      onPrimary: Colors.white,
                                      surface: secondaryColor,
                                      onSurface: Colors.white,
                                    ),
                                    dialogBackgroundColor: bgColor,
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (picked != null) {
                              setState(() {
                                startDate = picked;
                                if (endDate.isBefore(startDate)) {
                                  endDate = startDate.add(Duration(days: 1));
                                }
                              });
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.white24),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  DateFormat('dd/MM/yyyy').format(startDate),
                                  style: TextStyle(color: Colors.white),
                                ),
                                Icon(Icons.calendar_today, color: Colors.white54, size: 16),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text('đến', style: TextStyle(color: Colors.white70)),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: endDate.isAfter(startDate) ? endDate : startDate.add(Duration(days: 1)),
                              firstDate: startDate,
                              lastDate: DateTime(2030),
                              builder: (context, child) {
                                return Theme(
                                  data: ThemeData.dark().copyWith(
                                    colorScheme: ColorScheme.dark(
                                      primary: primaryColor,
                                      onPrimary: Colors.white,
                                      surface: secondaryColor,
                                      onSurface: Colors.white,
                                    ),
                                    dialogBackgroundColor: bgColor,
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (picked != null) {
                              setState(() {
                                endDate = picked;
                              });
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.white24),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  DateFormat('dd/MM/yyyy').format(endDate),
                                  style: TextStyle(color: Colors.white),
                                ),
                                Icon(Icons.calendar_today, color: Colors.white54, size: 16),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),

                  // Giới hạn sử dụng
                  _buildDialogTextField(
                    label: 'Giới hạn sử dụng',
                    controller: usageLimitController,
                    hintText: 'Ví dụ: 100',
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 15),

                  // Mô tả
                  _buildDialogTextField(
                    label: 'Mô tả',
                    controller: descriptionController,
                    hintText: 'Mô tả chi tiết về coupon',
                    maxLines: 3,
                  ),
                  SizedBox(height: 30),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Hủy', style: TextStyle(color: Colors.white70)),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                        onPressed: () {
                          // Kiểm tra dữ liệu nhập
                          if (codeController.text.isEmpty ||
                              discountController.text.isEmpty ||
                              minAmountController.text.isEmpty ||
                              (discountType == 'percent' && maxDiscountController.text.isEmpty) ||
                              usageLimitController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Vui lòng điền đầy đủ thông tin'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          // Tạo coupon mới
                          final newCoupon = {
                            'id': 'CP${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                            'code': codeController.text.toUpperCase(),
                            'discount': discountType == 'percent'
                                ? int.parse(discountController.text)
                                : int.parse(discountController.text),
                            'discountType': discountType,
                            'minAmount': int.parse(minAmountController.text),
                            'maxDiscount': discountType == 'percent'
                                ? int.parse(maxDiscountController.text)
                                : int.parse(discountController.text),
                            'startDate': DateFormat('yyyy-MM-dd').format(startDate),
                            'endDate': DateFormat('yyyy-MM-dd').format(endDate),
                            'usageLimit': int.parse(usageLimitController.text),
                            'usageCount': 0,
                            'status': startDate.isAfter(DateTime.now()) ? 'Chưa kích hoạt' : 'Đang hoạt động',
                            'description': descriptionController.text,
                            'createdAt': DateFormat('yyyy-MM-dd').format(DateTime.now()),
                          };

                          setState(() {
                            _allCoupons.add(newCoupon);
                          });

                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Đã tạo coupon mới: ${codeController.text.toUpperCase()}'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                        child: Text('Tạo Coupon'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDialogTextField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    String? suffix,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.white70, fontSize: 14),
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: bgColor,
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.white38),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.white24),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.white24),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: primaryColor),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            suffixText: suffix,
            suffixStyle: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  void _showEditCouponDialog(BuildContext context, Map<String, dynamic> coupon) {
    // Tương tự như hàm _showAddCouponDialog nhưng với dữ liệu có sẵn
    // Có thể tái sử dụng code từ hàm _showAddCouponDialog với một số điều chỉnh
  }

  void _showExtendCouponDialog(BuildContext context, Map<String, dynamic> coupon) {
    final TextEditingController daysController = TextEditingController();
    final endDate = DateTime.parse(coupon['endDate']);
    final newEndDate = DateTime.now().add(Duration(days: 30));

    showDialog(
        context: context,
        builder: (context) => Dialog(
        backgroundColor: secondaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
        padding: EdgeInsets.all(20),
    child: Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text(
    'Gia hạn Coupon',
    style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    ),
    ),
    SizedBox(height: 20),
    Text(
    'Coupon: ${coupon['code']}',
    style: TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    ),
    ),
    SizedBox(height: 10),
    Text(
    'Ngày hết hạn hiện tại: ${DateFormat('dd/MM/yyyy').format(endDate)}',
    style: TextStyle(color: Colors.white70),
    ),
    SizedBox(height: 20),
      Text(
        'Gia hạn đến ngày:',
        style: TextStyle(color: Colors.white70, fontSize: 14),
      ),
      SizedBox(height: 8),
      InkWell(
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: newEndDate,
            firstDate: DateTime.now(),
            lastDate: DateTime(2030),
            builder: (context, child) {
              return Theme(
                data: ThemeData.dark().copyWith(
                  colorScheme: ColorScheme.dark(
                    primary: primaryColor,
                    onPrimary: Colors.white,
                    surface: secondaryColor,
                    onSurface: Colors.white,
                  ),
                  dialogBackgroundColor: bgColor,
                ),
                child: child!,
              );
            },
          );
          if (picked != null) {
            daysController.text = DateFormat('dd/MM/yyyy').format(picked);
          }
        },
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white24),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                daysController.text.isEmpty
                    ? DateFormat('dd/MM/yyyy').format(newEndDate)
                    : daysController.text,
                style: TextStyle(color: Colors.white),
              ),
              Icon(Icons.calendar_today, color: Colors.white54, size: 16),
            ],
          ),
        ),
      ),
      SizedBox(height: 30),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Hủy', style: TextStyle(color: Colors.white70)),
          ),
          SizedBox(width: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
            ),
            onPressed: () {
              final newDate = daysController.text.isEmpty
                  ? newEndDate
                  : DateFormat('dd/MM/yyyy').parse(daysController.text);

              setState(() {
                final index = _allCoupons.indexWhere((c) => c['id'] == coupon['id']);
                if (index != -1) {
                  _allCoupons[index] = {
                    ..._allCoupons[index],
                    'endDate': DateFormat('yyyy-MM-dd').format(newDate),
                    'status': 'Đang hoạt động',
                  };
                }
              });

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Đã gia hạn coupon ${coupon['code']} đến ${DateFormat('dd/MM/yyyy').format(newDate)}'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: Text('Xác nhận'),
          ),
        ],
      ),
    ],
    ),
        ),
        ),
    );
  }

  void _showDeactivateConfirmation(Map<String, dynamic> coupon) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: secondaryColor,
        title: Text('Xác nhận', style: TextStyle(color: Colors.white)),
        content: Text(
          'Bạn có chắc chắn muốn vô hiệu hóa coupon ${coupon['code']}?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Hủy', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFFF4560),
            ),
            onPressed: () {
              setState(() {
                final index = _allCoupons.indexWhere((c) => c['id'] == coupon['id']);
                if (index != -1) {
                  _allCoupons[index] = {
                    ..._allCoupons[index],
                    'status': 'Hết hạn',
                  };
                }
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Đã vô hiệu hóa coupon ${coupon['code']}'),
                  backgroundColor: Color(0xFFFF4560),
                ),
              );
            },
            child: Text('Xác nhận'),
          ),
        ],
      ),
    );
  }

  void _activateCoupon(Map<String, dynamic> coupon) {
    setState(() {
      final index = _allCoupons.indexWhere((c) => c['id'] == coupon['id']);
      if (index != -1) {
        _allCoupons[index] = {
          ..._allCoupons[index],
          'status': 'Đang hoạt động',
        };
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã kích hoạt coupon ${coupon['code']}'),
        backgroundColor: Color(0xFF2697FF),
      ),
    );
  }

  void _showDeleteConfirmation(Map<String, dynamic> coupon) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: secondaryColor,
        title: Text('Xác nhận xóa', style: TextStyle(color: Colors.white)),
        content: Text(
          'Bạn có chắc chắn muốn xóa coupon ${coupon['code']}? Hành động này không thể hoàn tác.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Hủy', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              setState(() {
                _allCoupons.removeWhere((c) => c['id'] == coupon['id']);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Đã xóa coupon ${coupon['code']}'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: Text('Xóa'),
          ),
        ],
      ),
    );
  }
}



