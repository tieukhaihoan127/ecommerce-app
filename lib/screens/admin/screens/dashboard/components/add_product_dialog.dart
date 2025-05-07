import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
    final dialogWidth = isMobile ? screenWidth * 0.8 : screenWidth * 0.6;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: dialogWidth,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Thêm sản phẩm mới", style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(controller: _maSP, decoration: InputDecoration(labelText: "Mã sản phẩm")),
                    TextFormField(controller: _tenSP, decoration: InputDecoration(labelText: "Tên sản phẩm")),
                    TextFormField(controller: _moTa, decoration: InputDecoration(labelText: "Mô tả")),
                    TextFormField(
                      controller: _giaGoc,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: "Giá gốc"),
                    ),
                    TextFormField(
                      controller: _giaSale,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: "Giá sale (có thể để trống)"),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _pickImages,
                      icon: Icon(Icons.image),
                      label: Text("Chọn hình ảnh"),
                    ),
                    if (_images != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _images!
                              .map((img) => ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.file(File(img.path), height: 50),
                          ))
                              .toList(),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Hủy"),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // TODO: xử lý lưu thông tin sản phẩm
                      Navigator.pop(context);
                    }
                  },
                  child: Text("Lưu"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
