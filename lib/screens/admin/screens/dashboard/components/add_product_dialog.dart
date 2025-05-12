import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../constants.dart';

class AddProductDialog extends StatefulWidget {
  @override
  State<AddProductDialog> createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<AddProductDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _maSP = TextEditingController();
  final TextEditingController _tenSP = TextEditingController();
  final TextEditingController _moTa = TextEditingController();
  final TextEditingController _giaGoc = TextEditingController();
  final TextEditingController _giaSale = TextEditingController();

  List<XFile>? _images;

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? picked = await picker.pickMultiImage();
    if (picked != null && picked.isNotEmpty) {
      setState(() => _images = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
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

    return Dialog(
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
        GestureDetector(
          onTap: _pickImages,
          child: Container(
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
        ),

      ],
    );
  }
}
