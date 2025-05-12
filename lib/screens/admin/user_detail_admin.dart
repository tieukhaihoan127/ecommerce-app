import 'package:ecommerce_app/core/config/responsive.dart';
import 'package:ecommerce_app/core/theme/constant.dart';
import 'package:ecommerce_app/providers/address_provider.dart';
import 'package:ecommerce_app/providers/admin_provider.dart';
import 'package:ecommerce_app/providers/user_provider.dart';
import 'package:ecommerce_app/screens/admin/header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class UserDetailScreen extends StatefulWidget {

  final String userId;
  
  const UserDetailScreen({super.key, required this.userId});

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();

  String? _selectedProvince = "";
  String? _selectedDistrict = "";
  String? _selectedWard = "";
  String? _selectedProvinceName = "";
  String? _selectedDistrictName = "";
  String? _selectedWardName = "";

  String _status = "Status";

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.loadUserAdminDetail(widget.userId);
      final user = userProvider.userAdminDetail;

      if (user != null) {
        _status = user.status ?? "";
        _emailController.text = user.email ?? "";
        _nameController.text = user.fullName ?? "";
        _addressController.text = user.shippingAddress?.address ?? "";

        _selectedProvinceName = user.shippingAddress?.city;
        _selectedDistrictName = user.shippingAddress?.district;
        _selectedWardName = user.shippingAddress?.ward;

        final addressProvider = Provider.of<AddressProvider>(
          context,
          listen: false,
        );

        addressProvider.fetchProvinces().then((_) {
          final province = addressProvider.provinces.firstWhereOrNull(
            (p) => p.name == _selectedProvinceName,
          );

          if (province != null) {
            setState(() {
              _selectedProvince = province.code;
            });

            addressProvider.fetchDistrict(province.code).then((_) {
              final district = addressProvider.districts.firstWhereOrNull(
                (d) => d.name == _selectedDistrictName,
              );
              if (district != null) {
                setState(() {
                  _selectedDistrict = district.code;
                });

                addressProvider.fetchWard(district.code).then((_) {
                  final ward = addressProvider.wards.firstWhereOrNull(
                    (w) => w.name == _selectedWardName,
                  );
                  if (ward != null) {
                    setState(() {
                      _selectedWard = ward.code;
                    });
                  }
                });
              }
            });
          }
        });
      }

      setState(() {
        _isLoading = false; 
      });
    });
  }

  void _handleSubmit() {
    if (_emailController.text.isEmpty ||
        _nameController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _selectedProvince == null ||
        _selectedDistrict == null ||
        _selectedWard == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng nhập đầy đủ thông tin")),
      );
      return;
    }

    Provider.of<UserProvider>(context, listen: false).updateUserAdminInfo(widget.userId, _emailController.text, _nameController.text, _selectedProvinceName!, _selectedDistrictName!, _selectedWardName!, _addressController.text, _status);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Cập nhật thông tin người dùng thành công', style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.green,
    ));
    if (Responsive.isMobile(context)) {
      Navigator.pop(context);
    }
    context.read<AdminProvider>().changePage(AppPage.user);

  }

  @override
  Widget build(BuildContext context) {
    final addressProvider = Provider.of<AddressProvider>(context);

    if (_isLoading) {
      return const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    return SafeArea(
      child: SingleChildScrollView(
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton.icon(
                            onPressed: () {
                              context.read<AdminProvider>().changePage(AppPage.user);
                            },
                            icon: Icon(Icons.arrow_back, color: Colors.white70),
                            label: Text(
                              "Quay lại",
                              style: TextStyle(color: Colors.white70),
                            ),
                          ),
                        ),
                        const SizedBox(height: defaultPadding),

                        _buildField("Email", _emailController, Icons.email),
                        const SizedBox(height: defaultPadding),

                        _buildField("Full Name", _nameController, Icons.account_circle),
                        const SizedBox(height: defaultPadding),

                        Text("Shipping Address", style: Theme.of(context).textTheme.titleSmall),
                        const SizedBox(height: defaultPadding),

                        DropdownButtonFormField<String>(
                          value: _selectedProvince?.isNotEmpty == true ? _selectedProvince : null,
                          hint: const Text("Choose your province"),
                          items: addressProvider.provinces.map((p) => DropdownMenuItem(value: p.code, child: Text(p.name))).toList(),
                          onChanged: (val) async {
                            setState(() {
                              _selectedProvince = val;
                              _selectedDistrict = null;
                              _selectedWard = null;
                              _selectedProvinceName = addressProvider.provinces.firstWhere((p) => p.code == val).name;
                            });
                            await addressProvider.fetchDistrict(val!);
                          },
                          decoration: const InputDecoration(border: OutlineInputBorder()),
                        ),

                        const SizedBox(height: defaultPadding),
                        DropdownButtonFormField<String>(
                          value: _selectedDistrict?.isNotEmpty == true ? _selectedDistrict : null,
                          hint: const Text("Choose your district"),
                          items: addressProvider.districts.map((d) => DropdownMenuItem(value: d.code, child: Text(d.name))).toList(),
                          onChanged: (val) async {
                            setState(() {
                              _selectedDistrict = val;
                              _selectedWard = null;
                              _selectedDistrictName = addressProvider.districts.firstWhere((d) => d.code == val).name;
                            });
                            await addressProvider.fetchWard(val!);
                          },
                          decoration: const InputDecoration(border: OutlineInputBorder()),
                        ),

                        const SizedBox(height: defaultPadding),
                        DropdownButtonFormField<String>(
                          value: _selectedWard?.isNotEmpty == true ? _selectedWard : null,
                          hint: const Text("Choose your ward"),
                          items: addressProvider.wards.map((w) => DropdownMenuItem(value: w.code, child: Text(w.name))).toList(),
                          onChanged: (val) {
                            setState(() {
                              _selectedWard = val;
                              _selectedWardName = addressProvider.wards.firstWhere((w) => w.code == val).name;
                            });
                          },
                          decoration: const InputDecoration(border: OutlineInputBorder()),
                        ),

                        const SizedBox(height: defaultPadding),
                        _buildField("Address", _addressController, Icons.location_city),

                        const SizedBox(height: defaultPadding),

                        // ✅ Dropdown Status
                        DropdownButtonFormField<String>(
                          value: _status,
                          decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "Status"),
                          items: const [
                            DropdownMenuItem(value: "Active", child: Text("Active")),
                            DropdownMenuItem(value: "Inactive", child: Text("Inactive")),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _status = value ?? "Active";
                            });
                          },
                        ),

                        const SizedBox(height: defaultPadding * 2),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _handleSubmit,
                            label: const Text("Update", style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (!Responsive.isMobile(context)) const SizedBox(width: defaultPadding),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: Icon(icon),
            border: OutlineInputBorder(),
            hintText: "Enter your $label",
          ),
        ),
      ],
    );
  }
}
