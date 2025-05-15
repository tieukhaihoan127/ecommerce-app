import 'package:ecommerce_app/providers/address_provider.dart';
import 'package:ecommerce_app/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class MangaDeliveryAddressScreen extends StatefulWidget {
  const MangaDeliveryAddressScreen({super.key});

  @override
  State<MangaDeliveryAddressScreen> createState() => _MangaDeliveryAddressScreenState();
}

class _MangaDeliveryAddressScreenState extends State<MangaDeliveryAddressScreen> {
  final TextEditingController _addressController = TextEditingController();
  String? _selectedProvince = "";
  String? _selectedDistrict = "";
  String? _selectedWard = "";

  String? _selectedProvinceName = "";
  String? _selectedDistrictName = "";
  String? _selectedWardName = "";

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final user = userProvider.user;

      if (user != null) {
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
      Provider.of<AddressProvider>(context, listen: false).fetchProvinces();

    });
  }

  @override
  Widget build(BuildContext context) {
    final addressProvider = Provider.of<AddressProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery Address'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _selectProvince(
                    context,
                    addressProvider,
                    "Choose your province",
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _selectDistrict(
                    context,
                    addressProvider,
                    "Choose your district",
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _selectWard(context, addressProvider, "Choose your ward"),
                ],
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [_selectAddress(context)],
              ),
              const SizedBox(height: 25),
              _submitAddress(context, userProvider),
          ],
        ),
      ),
    );
  }

  Widget _selectProvince(
    BuildContext context,
    AddressProvider addressProvider,
    String text,
  ) {
    return Flexible(
      child: DropdownButtonFormField<String>(
        value:
            addressProvider.isLoaded
                ? null
                : (_selectedProvince != "" ? _selectedProvince : null),
        hint: Text(text),
        items:
            addressProvider.provinces.map((province) {
              return DropdownMenuItem(
                value: province.code,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 200),
                    child: Text(province.name),
                  ),
                ),
              );
            }).toList(),
        onChanged: (newValue) {
          setState(() {
            _selectedProvince = newValue;
            _selectedDistrict = null;
            _selectedWard = null;
          });

          _selectedProvinceName =
              addressProvider.provinces
                  .firstWhere((province) => province.code == newValue)
                  .name;
          Provider.of<AddressProvider>(context, listen: false).resetWard();
          Provider.of<AddressProvider>(
            context,
            listen: false,
          ).fetchDistrict(newValue!);
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
        ),
      ),
    );
  }

  Widget _selectDistrict(
    BuildContext context,
    AddressProvider addressProvider,
    String text,
  ) {
    return Flexible(
      child: DropdownButtonFormField<String>(
        value:
            _selectedProvince != ""
                ? (_selectedDistrict != "" ? _selectedDistrict : null)
                : null,
        hint: Text(text),
        items:
            addressProvider.districts.map((district) {
              return DropdownMenuItem(
                value: district.code,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 200),
                    child: Text(district.name),
                  ),
                ),
              );
            }).toList(),
        onChanged: (newValue) {
          setState(() {
            _selectedDistrict = newValue;
            _selectedWard = null;
          });

          _selectedDistrictName =
              addressProvider.districts
                  .firstWhere((district) => district.code == newValue)
                  .name;
          Provider.of<AddressProvider>(
            context,
            listen: false,
          ).fetchWard(newValue!);
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
        ),
      ),
    );
  }

  Widget _selectWard(
    BuildContext context,
    AddressProvider addressProvider,
    String text,
  ) {
    return Expanded(
      child: DropdownButtonFormField<String>(
        value:
            _selectedDistrict != ""
                ? (_selectedWard != "" ? _selectedWard : null)
                : null,
        hint: Text(text),
        items:
            addressProvider.wards.map((ward) {
              return DropdownMenuItem(
                value: ward.code,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 200),
                    child: Text(ward.name),
                  ),
                ),
              );
            }).toList(),
        onChanged: (newValue) {
          setState(() {
            _selectedWard = newValue;
          });

          _selectedWardName =
              addressProvider.wards
                  .firstWhere((ward) => ward.code == newValue)
                  .name;
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
        ),
      ),
    );
  }

  Widget _selectAddress(BuildContext context) {
    return Expanded(
      child: TextField(
        controller: _addressController,
        decoration: InputDecoration(
          hintText: "Enter your address",
          prefixIcon: Icon(Icons.location_city),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
        ),
      ),
    );
  }

  Widget _submitAddress(BuildContext context, UserProvider userProvider) {
    return GestureDetector(
      onTap: () async {
        await userProvider.updateAddress(_selectedProvinceName!, _selectedDistrictName!, _selectedWardName!, _addressController.text, userProvider.user!.id!);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Cập nhật địa chỉ thành công!")),
        );
        Navigator.pop(context);
      },
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: const Color(0xFF0F1C2F),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            "Update Delivery Address",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }

}
