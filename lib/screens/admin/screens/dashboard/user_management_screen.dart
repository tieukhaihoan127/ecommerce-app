import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../constants.dart';
import 'components/header.dart';
import 'components/add_employee_dialog.dart';

class UserManagementScreen extends StatefulWidget {
  @override
  _UserManagementState createState() => _UserManagementState();
}

class _UserManagementState extends State<UserManagementScreen> {
  String _searchQuery = '';
  String _selectedFilter = 'Tất cả';
  int _currentPage = 1;
  final int _itemsPerPage = 10;

  final List<String> _filters = [
    'Tất cả',
    'Quản lý',
    'Nhân viên',
    'Đang làm việc',
    'Đã nghỉ',
  ];

  // Dữ liệu mẫu nhân viên
  final List<Map<String, dynamic>> _allEmployees = [
    {
      'id': 'NV001',
      'name': 'Nguyễn Văn A',
      'email': 'nguyenvana@company.com',
      'phone': '0901234567',
      'role': 'Quản lý',
      'department': 'Kinh doanh',
      'status': 'Đang làm việc',
      'joinDate': '01/01/2022',
      'avatar': 'assets/images/profile_pic.png',
    },
    {
      'id': 'NV002',
      'name': 'Trần Thị B',
      'email': 'tranthib@company.com',
      'phone': '0901234568',
      'role': 'Nhân viên',
      'department': 'Kỹ thuật',
      'status': 'Đang làm việc',
      'joinDate': '15/02/2022',
      'avatar': 'assets/images/profile_pic.png',
    },
    {
      'id': 'NV003',
      'name': 'Lê Văn C',
      'email': 'levanc@company.com',
      'phone': '0901234569',
      'role': 'Nhân viên',
      'department': 'Kế toán',
      'status': 'Đã nghỉ',
      'joinDate': '01/03/2022',
      'leaveDate': '30/04/2023',
      'avatar': 'assets/images/profile_pic.png',
    },
    {
      'id': 'NV004',
      'name': 'Phạm Thị D',
      'email': 'phamthid@company.com',
      'phone': '0901234570',
      'role': 'Quản lý',
      'department': 'Nhân sự',
      'status': 'Đang làm việc',
      'joinDate': '01/04/2022',
      'avatar': 'assets/images/profile_pic.png',
    },
    {
      'id': 'NV005',
      'name': 'Hoàng Văn E',
      'email': 'hoangvane@company.com',
      'phone': '0901234571',
      'role': 'Nhân viên',
      'department': 'Marketing',
      'status': 'Đang làm việc',
      'joinDate': '15/05/2022',
      'avatar': 'assets/images/profile_pic.png',
    },
    // Thêm nhân viên mẫu để kiểm tra phân trang
    {
      'id': 'NV006',
      'name': 'Vũ Thị F',
      'email': 'vuthif@company.com',
      'phone': '0901234572',
      'role': 'Nhân viên',
      'department': 'Kinh doanh',
      'status': 'Đang làm việc',
      'joinDate': '01/06/2022',
      'avatar': 'assets/images/profile_pic.png',
    },
    {
      'id': 'NV007',
      'name': 'Đặng Văn G',
      'email': 'dangvang@company.com',
      'phone': '0901234573',
      'role': 'Nhân viên',
      'department': 'Kỹ thuật',
      'status': 'Đã nghỉ',
      'joinDate': '15/07/2022',
      'leaveDate': '30/06/2023',
      'avatar': 'assets/images/profile_pic.png',
    },
    {
      'id': 'NV008',
      'name': 'Bùi Thị H',
      'email': 'buithih@company.com',
      'phone': '0901234574',
      'role': 'Nhân viên',
      'department': 'Kế toán',
      'status': 'Đang làm việc',
      'joinDate': '01/08/2022',
      'avatar': 'assets/images/profile_pic.png',
    },
    {
      'id': 'NV009',
      'name': 'Ngô Văn I',
      'email': 'ngovani@company.com',
      'phone': '0901234575',
      'role': 'Nhân viên',
      'department': 'Nhân sự',
      'status': 'Đang làm việc',
      'joinDate': '15/09/2022',
      'avatar': 'assets/images/profile_pic.png',
    },
    {
      'id': 'NV010',
      'name': 'Dương Thị K',
      'email': 'duongthik@company.com',
      'phone': '0901234576',
      'role': 'Nhân viên',
      'department': 'Marketing',
      'status': 'Đang làm việc',
      'joinDate': '01/10/2022',
      'avatar': 'assets/images/profile_pic.png',
    },
    {
      'id': 'NV011',
      'name': 'Lý Văn L',
      'email': 'lyvanl@company.com',
      'phone': '0901234577',
      'role': 'Quản lý',
      'department': 'Kinh doanh',
      'status': 'Đang làm việc',
      'joinDate': '15/11/2022',
      'avatar': 'assets/images/profile_pic.png',
    },
    {
      'id': 'NV012',
      'name': 'Trịnh Thị M',
      'email': 'trinhthim@company.com',
      'phone': '0901234578',
      'role': 'Nhân viên',
      'department': 'Kỹ thuật',
      'status': 'Đã nghỉ',
      'joinDate': '01/12/2022',
      'leaveDate': '15/07/2023',
      'avatar': 'assets/images/profile_pic.png',
    },
  ];

  // Lọc nhân viên theo bộ lọc và tìm kiếm
  List<Map<String, dynamic>> get filteredEmployees {
    return _allEmployees.where((employee) {
      // Lọc theo trạng thái hoặc vai trò
      bool matchesFilter = true;

      if (_selectedFilter == 'Quản lý') {
        matchesFilter = employee['role'] == 'Quản lý';
      } else if (_selectedFilter == 'Nhân viên') {
        matchesFilter = employee['role'] == 'Nhân viên';
      } else if (_selectedFilter == 'Đang làm việc') {
        matchesFilter = employee['status'] == 'Đang làm việc';
      } else if (_selectedFilter == 'Đã nghỉ') {
        matchesFilter = employee['status'] == 'Đã nghỉ';
      }

      // Lọc theo tìm kiếm
      bool matchesSearch = _searchQuery.isEmpty ||
          employee['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          employee['id'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          employee['email'].toLowerCase().contains(_searchQuery.toLowerCase());

      return matchesFilter && matchesSearch;
    }).toList();
  }

  // Phân trang
  List<Map<String, dynamic>> get paginatedEmployees {
    final filteredList = filteredEmployees;
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
    return (filteredEmployees.length / _itemsPerPage).ceil();
  }

  // Đếm số nhân viên theo trạng thái
  int get totalEmployees => _allEmployees.length;
  int get activeEmployees => _allEmployees.where((e) => e['status'] == 'Đang làm việc').length;
  int get inactiveEmployees => _allEmployees.where((e) => e['status'] == 'Đã nghỉ').length;

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
            Text("Quản lý nhân viên"),
            SizedBox(height: defaultPadding),
            _buildEmployeeStats(isMobile),
            SizedBox(height: defaultPadding),
            _buildSearchAndFilterBar(isMobile),
            SizedBox(height: defaultPadding),
            _buildFilterTabs(),
            SizedBox(height: defaultPadding),
            _buildEmployeeList(isMobile, isTablet),
            if (pageCount > 1) _buildPagination(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmployeeStats(bool isMobile) {
    return isMobile
        ? Column(
      children: [
        _buildStatCard(
          title: "Tổng nhân viên",
          value: totalEmployees.toString(),
          valueColor: Color(0xFF00E396), // Màu xanh lá nhạt
          icon: Icons.people,
        ),
        SizedBox(height: defaultPadding),
        _buildStatCard(
          title: "Đang làm việc",
          value: activeEmployees.toString(),
          valueColor: Color(0xFF2697FF), // Màu xanh dương
          icon: Icons.check_circle,
        ),
        SizedBox(height: defaultPadding),
        _buildStatCard(
          title: "Đã nghỉ",
          value: inactiveEmployees.toString(),
          valueColor: Color(0xFFFF4560), // Màu đỏ
          icon: Icons.cancel,
        ),
      ],
    )
        : Row(
      children: [
        Expanded(
          child: _buildStatCard(
            title: "Tổng nhân viên",
            value: totalEmployees.toString(),
            valueColor: Color(0xFF00E396),
            icon: Icons.people,
          ),
        ),
        SizedBox(width: defaultPadding),
        Expanded(
          child: _buildStatCard(
            title: "Đang làm việc",
            value: activeEmployees.toString(),
            valueColor: Color(0xFF2697FF),
            icon: Icons.check_circle,
          ),
        ),
        SizedBox(width: defaultPadding),
        Expanded(
          child: _buildStatCard(
            title: "Đã nghỉ",
            value: inactiveEmployees.toString(),
            valueColor: Color(0xFFFF4560),
            icon: Icons.cancel,
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
          if (title == "Tổng nhân viên") {
            _selectedFilter = "Tất cả";
          } else if (title == "Đang làm việc") {
            _selectedFilter = "Đang làm việc";
          } else if (title == "Đã nghỉ") {
            _selectedFilter = "Đã nghỉ";
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
          hintText: "Tìm kiếm nhân viên...",
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
      onPressed: () => showDialog(
        context: context,
        builder: (context) => AddEmployeeDialog(
          onEmployeeAdded: (newEmployee) {
            setState(() {
              _allEmployees.add(newEmployee);
            });
          },
        ),
      ),
      icon: Icon(Icons.add),
      label: Text("Thêm nhân viên"),
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

  Widget _buildEmployeeList(bool isMobile, bool isTablet) {
    final employees = paginatedEmployees;

    if (employees.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Icon(Icons.search_off, size: 50, color: Colors.white54),
              SizedBox(height: 10),
              Text(
                "Không tìm thấy nhân viên nào",
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

          // Danh sách nhân viên
          ...employees.map((employee) => _buildEmployeeItem(employee, isMobile)),
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
              "Nhân viên",
              style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              "ID",
              style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              "Email",
              style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              "Vai trò",
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

  Widget _buildEmployeeItem(Map<String, dynamic> employee, bool isMobile) {
    final statusColor = employee['status'] == 'Đang làm việc'
        ? Color(0xFF2697FF)
        : Color(0xFFFF4560);

    final roleColor = employee['role'] == 'Quản lý'
        ? Color(0xFFFFB020)
        : Colors.white70;

    if (isMobile) {
      return InkWell(
        onTap: () => _showEmployeeDetailDialog(context, employee),
        child: Container(
          margin: EdgeInsets.only(bottom: 10),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white10),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white24,
                    child: Text(
                      employee['name'].substring(0, 1),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          employee['name'],
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          employee['id'],
                          style: TextStyle(color: Colors.white54, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.more_vert, color: Colors.white54),
                    onPressed: () => _showEmployeeActions(context, employee),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.email_outlined, color: Colors.white54, size: 16),
                      SizedBox(width: 5),
                      Text(
                        employee['email'],
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: roleColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      employee['role'],
                      style: TextStyle(
                        color: roleColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      employee['status'],
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    } else {
      return InkWell(
        onTap: () => _showEmployeeDetailDialog(context, employee),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.white10)),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white24,
                      child: Text(
                        employee['name'].substring(0, 1),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        employee['name'],
                        style: TextStyle(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  employee['id'],
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  employee['email'],
                  style: TextStyle(color: Colors.white70),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: roleColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    employee['role'],
                    style: TextStyle(
                      color: roleColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
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
                    employee['status'],
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(width: 10),
              IconButton(
                icon: Icon(Icons.more_vert, color: Colors.white54),
                onPressed: () => _showEmployeeActions(context, employee),
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

  void _showEmployeeDetailDialog(BuildContext context, Map<String, dynamic> employee) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

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
            'Thông tin nhân viên',
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
    CircleAvatar(
    radius: 30,
    backgroundColor: Colors.white24,
    child: Text(
    employee['name'].substring(0, 1),
    style: TextStyle(fontSize: 24, color: Colors.white),
    ),
    ),
    SizedBox(width: 20),
    Expanded(
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text(
    employee['name'],
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
    color: employee['role'] == 'Quản lý'
    ? Color(0xFFFFB020).withOpacity(0.2)
        : Colors.white10,
    borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
    employee['role'],
    style: TextStyle(
    color: employee['role'] == 'Quản lý'
    ? Color(0xFFFFB020)
        : Colors.white70,
    fontWeight: FontWeight.bold,
    fontSize: 12,
    ),
    ),
    ),
    SizedBox(width: 10),
    Container(
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
    color: employee['status'] == 'Đang làm việc'
    ? Color(0xFF2697FF).withOpacity(0.2)
        : Color(0xFFFF4560).withOpacity(0.2),
    borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
    employee['status'],
    style: TextStyle(
    color: employee['status'] == 'Đang làm việc'
    ? Color(0xFF2697FF)
        : Color(0xFFFF4560),
    fontWeight: FontWeight.bold,
    fontSize: 12,
    ),
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
    _buildInfoRow('ID nhân viên', employee['id']),
    _buildInfoRow('Email', employee['email']),
    _buildInfoRow('Số điện thoại', employee['phone']),
    _buildInfoRow('Phòng ban', employee['department']),
    _buildInfoRow('Ngày vào làm', employee['joinDate']),
    if (employee['status'] == 'Đã nghỉ')
    _buildInfoRow('Ngày nghỉ việc', employee['leaveDate']),
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
    _showEditEmployeeDialog(context, employee);
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

  Widget _buildInfoRow(String label, String value) {
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
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEmployeeActions(BuildContext context, Map<String, dynamic> employee) {
    final isActive = employee['status'] == 'Đang làm việc';

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
                  _showEmployeeDetailDialog(context, employee);
                },
              ),
              ListTile(
                leading: Icon(Icons.edit, color: Colors.white70),
                title: Text('Chỉnh sửa', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _showEditEmployeeDialog(context, employee);
                },
              ),
              if (isActive)
                ListTile(
                  leading: Icon(Icons.person_off, color: Color(0xFFFF4560)),
                  title: Text('Đánh dấu đã nghỉ việc', style: TextStyle(color: Color(0xFFFF4560))),
                  onTap: () {
                    Navigator.pop(context);
                    _showDeactivateConfirmation(employee);
                  },
                )
              else
                ListTile(
                  leading: Icon(Icons.person_add, color: Color(0xFF2697FF)),
                  title: Text('Đánh dấu đang làm việc', style: TextStyle(color: Color(0xFF2697FF))),
                  onTap: () {
                    Navigator.pop(context);
                    _reactivateEmployee(employee);
                  },
                ),
              ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text('Xóa nhân viên', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteConfirmation(employee);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditEmployeeDialog(BuildContext context, Map<String, dynamic> employee) {
    // Implement dialog chỉnh sửa thông tin nhân viên
    // Đây là một dialog phức tạp với các trường thông tin nhân viên
    // Có thể tạo một widget riêng cho dialog này
  }

  void _showDeactivateConfirmation(Map<String, dynamic> employee) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: secondaryColor,
        title: Text('Xác nhận', style: TextStyle(color: Colors.white)),
        content: Text(
          'Bạn có chắc chắn muốn đánh dấu nhân viên ${employee['name']} đã nghỉ việc?',
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
                final index = _allEmployees.indexWhere((e) => e['id'] == employee['id']);
                if (index != -1) {
                  _allEmployees[index] = {
                    ..._allEmployees[index],
                    'status': 'Đã nghỉ',
                    'leaveDate': '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                  };
                }
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Đã cập nhật trạng thái nhân viên'),
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

  void _reactivateEmployee(Map<String, dynamic> employee) {
    setState(() {
      final index = _allEmployees.indexWhere((e) => e['id'] == employee['id']);
      if (index != -1) {
        _allEmployees[index] = {
          ..._allEmployees[index],
          'status': 'Đang làm việc',
        };
        // Xóa trường leaveDate nếu có
        _allEmployees[index].remove('leaveDate');
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã cập nhật trạng thái nhân viên'),
        backgroundColor: Color(0xFF2697FF),
      ),
    );
  }

  void _showDeleteConfirmation(Map<String, dynamic> employee) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: secondaryColor,
        title: Text('Xác nhận xóa', style: TextStyle(color: Colors.white)),
        content: Text(
          'Bạn có chắc chắn muốn xóa nhân viên ${employee['name']}? Hành động này không thể hoàn tác.',
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
                _allEmployees.removeWhere((e) => e['id'] == employee['id']);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Đã xóa nhân viên'),
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

