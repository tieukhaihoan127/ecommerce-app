import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../constants.dart';
import 'components/add_product_dialog.dart';
import 'components/header.dart';

class ProductsScreen extends StatefulWidget {
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'Tất cả';
  final List<String> _categories = [
    'Tất cả',
    'CPU',
    'Mainboard',
    'VGA',
    'RAM',
    'SSD',
    'HDD',
    'Nguồn',
    'Tản nhiệt',
    'Case',
  ];

  final List<Map<String, dynamic>> _allProducts = [
    {
      'id': 'SP001',
      'name': 'CPU Intel Core i7-14700K',
      'category': 'CPU',
      'price': '9.890.000 đ',
      'stock': 15,
      'image': 'assets/images/cpu.png',
    },
    {
      'id': 'SP002',
      'name': 'Mainboard ASUS TUF GAMING Z890-PLUS',
      'category': 'Mainboard',
      'price': '5.490.000 đ',
      'stock': 8,
      'image': 'assets/images/mainboard.png',
    },
    {
      'id': 'SP003',
      'name': 'Card màn hình MSI RTX 4070 Ti GAMING X TRIO 12G',
      'category': 'VGA',
      'price': '18.990.000 đ',
      'stock': 5,
      'image': 'assets/images/gpu.png',
    },
    {
      'id': 'SP004',
      'name': 'RAM Kingston FURY Beast RGB 32GB (2x16GB) DDR5 6000MHz',
      'category': 'RAM',
      'price': '3.290.000 đ',
      'stock': 20,
      'image': 'assets/images/ram.png',
    },
    {
      'id': 'SP005',
      'name': 'SSD Samsung 990 PRO 2TB PCIe 4.0',
      'category': 'SSD',
      'price': '4.990.000 đ',
      'stock': 12,
      'image': 'assets/images/ssd.png',
    },
    {
      'id': 'SP006',
      'name': 'Nguồn Corsair RM850x 850W 80 Plus Gold',
      'category': 'Nguồn',
      'price': '3.490.000 đ',
      'stock': 0,
      'image': 'assets/images/psu.png',
    },
  ];


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
            SizedBox(height: defaultPadding),
            _buildProductStats(isMobile, isTablet),
            SizedBox(height: defaultPadding),
            _buildSearchAndFilterBar(isMobile, isTablet),
            SizedBox(height: defaultPadding),
            _buildCategoryFilter(isMobile),
            SizedBox(height: defaultPadding),
            _buildProductsGrid(isMobile, isTablet),
          ],
        ),
      ),
    );
  }

  Widget _buildProductStats(bool isMobile, bool isTablet) {
    return isMobile
        ? Column(
      children: [
        _buildStatCard(
          title: "Tổng sản phẩm",
          value: "324",
          valueColor: Color(0xFF00E396), // Màu xanh lá nhạt
          subtitle: "Đã nhập",
        ),
        SizedBox(height: defaultPadding),
        _buildStatCard(
          title: "Sắp hết hàng",
          value: "18",
          valueColor: Color(0xFFFFB020), // Màu cam
          subtitle: "Cần nhập thêm",
        ),
        SizedBox(height: defaultPadding),
        _buildStatCard(
          title: "Đã hết hàng",
          value: "5",
          valueColor: Color(0xFFFF4560), // Màu đỏ
          subtitle: "Cần nhập ngay",
        ),
      ],
    )
        : Row(
      children: [
        Expanded(
          child: _buildStatCard(
            title: "Tổng sản phẩm",
            value: "324",
            valueColor: Color(0xFF00E396),
            subtitle: "Đã nhập",
          ),
        ),
        SizedBox(width: defaultPadding),
        Expanded(
          child: _buildStatCard(
            title: "Sắp hết hàng",
            value: "18",
            valueColor: Color(0xFFFFB020),
            subtitle: "Cần nhập thêm",
          ),
        ),
        SizedBox(width: defaultPadding),
        Expanded(
          child: _buildStatCard(
            title: "Đã hết hàng",
            value: "5",
            valueColor: Color(0xFFFF4560),
            subtitle: "Cần nhập ngay",
          ),
        ),
      ],
    );
  }



  Widget _buildStatCard({
    required String title,
    required String value,
    required Color valueColor,
    required String subtitle,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: valueColor.withOpacity(0.3), width: 1),
      ),
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
          SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilterBar(bool isMobile, bool isTablet) {
    return isMobile
        ? Column(
      children: [
        _buildSearchBar(),
        SizedBox(height: defaultPadding),
        _buildActionButtons(isMobile),
      ],
    )
        : Row(
      children: [
        Expanded(child: _buildSearchBar()),
        SizedBox(width: defaultPadding),
        _buildActionButtons(isMobile),
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
          hintText: "Tìm kiếm sản phẩm...",
          hintStyle: TextStyle(color: Colors.white54),
          prefixIcon: Icon(Icons.search, color: Colors.white54),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
      ),
    );
  }

  Widget _buildActionButtons(bool isMobile) {
    return Row(
      children: [
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 12 : 16,
              vertical: isMobile ? 10 : 15,
            ),
          ),
          onPressed: () => showDialog(
            context: context,
            builder: (context) => AddProductDialog(),
          ),
          icon: Icon(Icons.add),
          label: Text(isMobile ? "Thêm" : "Thêm sản phẩm"),
        ),
      ],
    );
  }

  Widget _buildCategoryFilter(bool isMobile) {
    return Container(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategory == category;

          return Padding(
            padding: EdgeInsets.only(right: 10),
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedCategory = category;
                });
                // In thông báo để kiểm tra
                print('Đã chọn danh mục: $_selectedCategory');
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
                    category,
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

  List<Map<String, dynamic>> get filteredProducts {
    return _allProducts.where((product) {
      // Lọc theo category (nếu không phải "Tất cả")
      bool matchesCategory = _selectedCategory == 'Tất cả' || product['category'] == _selectedCategory;

      // Lọc theo từ khóa tìm kiếm
      bool matchesSearch = _searchQuery.isEmpty ||
          product['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          product['id'].toLowerCase().contains(_searchQuery.toLowerCase());

      return matchesCategory && matchesSearch;
    }).toList();
  }

  Widget _buildProductsGrid(bool isMobile, bool isTablet) {
    // Số cột dựa trên kích thước màn hình
    final crossAxisCount = isMobile ? 1 : isTablet ? 2 : 3;
    final aspectRatio = isMobile ? 2.5 : isTablet ? 2.0 : 1.8;

    // Sử dụng danh sách đã được lọc
    final products = filteredProducts;

    // Hiển thị thông báo nếu không có sản phẩm nào
    if (products.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Icon(Icons.search_off, size: 50, color: Colors.white54),
              SizedBox(height: 10),
              Text(
                "Không tìm thấy sản phẩm nào",
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: defaultPadding,
        mainAxisSpacing: defaultPadding,
        childAspectRatio: aspectRatio,
      ),
      itemBuilder: (context, index) {
        final product = products[index];
        return _buildProductCard(product, isMobile);
      },
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product, bool isMobile) {
    final stockColor = product['stock'] == 0
        ? Colors.redAccent
        : product['stock'] < 10
        ? Colors.orangeAccent
        : Colors.greenAccent;

    return InkWell(
      onTap: () => _showProductDetailDialog(context, product),
      child: Container(
        decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white10),
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              // Hình ảnh sản phẩm
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Icon(Icons.computer, size: 40, color: Colors.white54),
                  // Nếu có hình ảnh thực tế:
                  // child: Image.asset(product['image'], fit: BoxFit.contain),
                ),
              ),
              SizedBox(width: 12),
              // Thông tin sản phẩm
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      product['id'],
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                    SizedBox(height: 4),
                    Text(
                      product['name'],
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: isMobile ? 14 : 16,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          product['price'],
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: stockColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            product['stock'] == 0
                                ? "Hết hàng"
                                : "SL: ${product['stock']}",
                            style: TextStyle(
                              color: stockColor,
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
            ],
          ),
        ),
      ),
    );
  }

  void _showProductDetailDialog(BuildContext context, Map<String, dynamic> product) {
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
                      'Chi tiết sản phẩm',
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
              isMobile
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildProductImage(),
                  SizedBox(height: 20),
                  _buildProductInfo(product),
                ],
              )
                  : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 2, child: _buildProductImage()),
                  SizedBox(width: 20),
                  Expanded(flex: 3, child: _buildProductInfo(product)),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                    ),
                    onPressed: () {},
                    icon: Icon(Icons.edit),
                    label: Text('Sửa'),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                    ),
                    onPressed: () {},
                    icon: Icon(Icons.delete),
                    label: Text('Xóa'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Icon(Icons.computer, size: 80, color: Colors.white54),
      ),
    );
  }

  Widget _buildProductInfo(Map<String, dynamic> product) {
    final stockColor = product['stock'] == 0
        ? Colors.redAccent
        : product['stock'] < 10
        ? Colors.orangeAccent
        : Colors.greenAccent;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product['name'],
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 10),
        _infoRow('Mã sản phẩm:', product['id']),
        _infoRow('Danh mục:', product['category']),
        _infoRow('Giá bán:', product['price']),
        _infoRow(
          'Tồn kho:',
          '${product['stock']} sản phẩm',
          valueColor: stockColor,
        ),
        SizedBox(height: 10),
        Text(
          'Mô tả sản phẩm:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white70,
          ),
        ),
        SizedBox(height: 5),
        Text(
          'Sản phẩm ${product['name']} là linh kiện cao cấp, hiệu năng mạnh mẽ, phù hợp cho gaming và các tác vụ đòi hỏi xử lý nặng. Thiết kế hiện đại, tản nhiệt hiệu quả.',
          style: TextStyle(color: Colors.white60),
        ),
      ],
    );
  }

  Widget _infoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(color: Colors.white70),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                color: valueColor ?? Colors.white,
                fontWeight: valueColor != null ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddProductDialog(BuildContext context) {
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Thêm sản phẩm mới',
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
                _buildTextField('Mã sản phẩm', 'Nhập mã sản phẩm'),
                SizedBox(height: 15),
                _buildTextField('Tên sản phẩm', 'Nhập tên sản phẩm'),
                SizedBox(height: 15),
                _buildDropdownField('Danh mục', _categories.sublist(1)),
                SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField('Giá bán', 'Nhập giá bán'),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: _buildTextField('Số lượng', 'Nhập số lượng'),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                _buildTextField('Mô tả', 'Nhập mô tả sản phẩm', maxLines: 3),
                SizedBox(height: 15),
                _buildImageUpload(),
                SizedBox(height: 20),
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
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                      onPressed: () {},
                      child: Text('Lưu sản phẩm'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.white70),
        ),
        SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white24),
          ),
          child: TextField(
            style: TextStyle(color: Colors.white),
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.white38),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(String label, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.white70),
        ),
        SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white24),
          ),
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              dropdownColor: bgColor,
              value: items[0],
              items: items.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }).toList(),
              onChanged: (value) {},
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageUpload() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hình ảnh sản phẩm',
          style: TextStyle(color: Colors.white70),
        ),
        SizedBox(height: 5),
        Container(
          height: 100,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white24, style: BorderStyle.solid),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.cloud_upload, color: Colors.white54, size: 30),
                SizedBox(height: 5),
                Text(
                  'Kéo thả hoặc nhấp để tải lên',
                  style: TextStyle(color: Colors.white54),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
