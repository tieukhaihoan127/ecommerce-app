import 'package:ecommerce_app/models/cart.dart';
import 'package:ecommerce_app/models/checkout_order.dart';
import 'package:ecommerce_app/models/shipping_address.dart';
import 'package:ecommerce_app/models/user.dart';
import 'package:ecommerce_app/providers/address_provider.dart';
import 'package:ecommerce_app/providers/user_provider.dart';
import 'package:ecommerce_app/screens/client/payment_method.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class ShippingInfoScreen extends StatefulWidget {

  final String cartId;

  final double totalPrice;

  final List<CartModel> carts;

  final int taxes;

  final int shippingFee;

  final bool loyaltyPointUsed;

  final int loyaltyPoint;

  final int couponValue;

  final String couponId;

  const ShippingInfoScreen({super.key, required this.cartId, required this.totalPrice, required this.carts, required this.taxes, required this.shippingFee, required this.loyaltyPointUsed, required this.loyaltyPoint, required this.couponValue, required this.couponId});

  _ShippingInfoScreenState createState() => _ShippingInfoScreenState();
}

class _ShippingInfoScreenState extends State<ShippingInfoScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
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
              print(_selectedDistrictName);
              print(addressProvider.districts[0].name);
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
    final userProvider = Provider.of<UserProvider>(context);
    final addressProvider = Provider.of<AddressProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: 16,
            vertical: 25,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _headerSignUp(context),
              _labelSignUp(context),
              const SizedBox(height: 20),
              _emailLabel(context),
              const SizedBox(height: 25),
              _nameLabel(context),
              const SizedBox(height: 25),
              _passwordLabel(context),
              const SizedBox(height: 25),
              Text(
                "Shipping Address",
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              const SizedBox(height: 25),
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
              _submitAddress(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _headerSignUp(BuildContext context) {
    return Text(
      "Manage Shipping Details",
      style: TextStyle(fontSize: 30, color: Colors.black),
    );
  }

  Widget _labelSignUp(BuildContext context) {
    return Text(
      "Explore your life by joining with Eletric",
      style: TextStyle(fontSize: 14, color: Colors.grey),
    );
  }

  Widget _emailLabel(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Email", style: TextStyle(color: Colors.black, fontSize: 18)),
        const SizedBox(height: 8),
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            hintText: "Enter your email",
            prefixIcon: Icon(Icons.email),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
          ),
        ),
      ],
    );
  }

  Widget _nameLabel(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Full Name", style: TextStyle(color: Colors.black, fontSize: 18)),
        const SizedBox(height: 8),
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            hintText: "Enter your name",
            prefixIcon: Icon(Icons.account_circle),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
          ),
        ),
      ],
    );
  }

  Widget _passwordLabel(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Phone Number",
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _phoneController,
          decoration: InputDecoration(
            hintText: "Enter your phone number",
            prefixIcon: Icon(Icons.phone),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
          ),
        ),
      ],
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

  Widget _submitAddress(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final order =  CheckoutOrderModel(
          cartId: widget.cartId,
          email: _emailController.text,
          fullName: _nameController.text,
          phone: _phoneController.text,
          city: _selectedProvinceName,
          ward: _selectedWardName,
          district: _selectedDistrictName,
          address: _addressController.text,
          loyaltyPointUsed: widget.loyaltyPointUsed,
          couponPoint: widget.couponValue,
          couponCode: widget.couponId
        );

        Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentSelectionScreen(order: order, totalPrice: widget.totalPrice, carts: widget.carts, taxes: widget.taxes, shippingFee: widget.shippingFee, loyaltyPoint: widget.loyaltyPoint,)));
      },
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: const Color(0xFF0F1C2F),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            "Contiune To Payment",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }

}
