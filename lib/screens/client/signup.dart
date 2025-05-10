import 'package:ecommerce_app/core/config/responsive.dart';
import 'package:ecommerce_app/models/shipping_address.dart';
import 'package:ecommerce_app/models/user.dart';
import 'package:ecommerce_app/providers/address_provider.dart';
import 'package:ecommerce_app/providers/user_provider.dart';
import 'package:ecommerce_app/screens/client/signin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
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
      Provider.of<AddressProvider>(context, listen: false).fetchProvinces();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      backgroundColor: Colors.white,
      leading: IconButton( icon: Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context) ),
    ),
      body: Responsive(
        mobile: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _buildSignUpForm(context, isDesktop: false),
        ),
        desktop: Center(
          child: Container(
            width: 600,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: _buildSignUpForm(context, isDesktop: true),
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpForm(BuildContext context, {required bool isDesktop}) {
    final userProvider = Provider.of<UserProvider>(context);
    final addressProvider = Provider.of<AddressProvider>(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _headerSignUp(),
          _labelSignUp(),
          const SizedBox(height: 20),
          _emailLabel(),
          const SizedBox(height: 25),
          _nameLabel(),
          const SizedBox(height: 25),
          Text("Shipping Address", style: TextStyle(fontSize: 18, color: Colors.black)),
          const SizedBox(height: 25),
          isDesktop
              ? Row(
                  children: [
                    Expanded(child: _selectProvince(addressProvider, "Choose your province")),
                    const SizedBox(width: 16),
                    Expanded(child: _selectDistrict(addressProvider, "Choose your district")),
                  ],
                )
              : Column(
                  children: [
                    _selectProvince(addressProvider, "Choose your province"),
                    const SizedBox(height: 25),
                    _selectDistrict(addressProvider, "Choose your district"),
                  ],
                ),
          const SizedBox(height: 25),
          isDesktop
              ? Row(
                  children: [
                    Expanded(child: _selectWard(addressProvider, "Choose your ward")),
                    const SizedBox(width: 16),
                    Expanded(child: _selectAddress()),
                  ],
                )
              : Column(
                  children: [
                    _selectWard(addressProvider, "Choose your ward"),
                    const SizedBox(height: 25),
                    _selectAddress(),
                  ],
                ),
          const SizedBox(height: 25),
          _signUpButton(userProvider),
        ],
      ),
    );
  }

  Widget _headerSignUp() {
    return Text("Create your account", style: TextStyle(fontSize: 30, color: Colors.black));
  }

  Widget _labelSignUp() {
    return Text("Explore your life by joining with Eletric", style: TextStyle(fontSize: 14, color: Colors.grey));
  }

  Widget _emailLabel() {
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

  Widget _nameLabel() {
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

  Widget _selectProvince(AddressProvider addressProvider, String hint) {
    return DropdownButtonFormField<String>(
      value: addressProvider.isLoaded ? (_selectedProvince != "" ? _selectedProvince : null) : null,
      hint: Text(hint),
      items: addressProvider.provinces.map((province) {
        return DropdownMenuItem(
          value: province.code,
          child: Text(province.name, overflow: TextOverflow.ellipsis),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          _selectedProvince = newValue;
          _selectedDistrict = null;
          _selectedWard = null;
        });
        _selectedProvinceName = addressProvider.provinces.firstWhere((p) => p.code == newValue).name;
        Provider.of<AddressProvider>(context, listen: false).resetWard();
        Provider.of<AddressProvider>(context, listen: false).fetchDistrict(newValue!);
      },
      decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
    );
  }

  Widget _selectDistrict(AddressProvider addressProvider, String hint) {
    return DropdownButtonFormField<String>(
      value: _selectedProvince != "" ? (_selectedDistrict != "" ? _selectedDistrict : null) : null,
      hint: Text(hint),
      items: addressProvider.districts.map((district) {
        return DropdownMenuItem(
          value: district.code,
          child: Text(district.name, overflow: TextOverflow.ellipsis),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          _selectedDistrict = newValue;
          _selectedWard = null;
        });
        _selectedDistrictName = addressProvider.districts.firstWhere((d) => d.code == newValue).name;
        Provider.of<AddressProvider>(context, listen: false).fetchWard(newValue!);
      },
      decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
    );
  }

  Widget _selectWard(AddressProvider addressProvider, String hint) {
    return DropdownButtonFormField<String>(
      value: _selectedDistrict != "" ? (_selectedWard != "" ? _selectedWard : null) : null,
      hint: Text(hint),
      items: addressProvider.wards.map((ward) {
        return DropdownMenuItem(
          value: ward.code,
          child: Text(ward.name, overflow: TextOverflow.ellipsis),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          _selectedWard = newValue;
        });
        _selectedWardName = addressProvider.wards.firstWhere((w) => w.code == newValue).name;
      },
      decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
    );
  }

  Widget _selectAddress() {
    return TextField(
      controller: _addressController,
      decoration: InputDecoration(
        hintText: "Enter your address",
        prefixIcon: Icon(Icons.location_city),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
      ),
    );
  }

  Widget _signUpButton(UserProvider userProvider) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: userProvider.isLoading ? null : () => _registerUser(context, userProvider),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
        child: userProvider.isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text("Sign Up", style: TextStyle(color: Colors.white, fontSize: 16)),
      ),
    );
  }

  Future<void> _registerUser(BuildContext context, UserProvider userProvider) async {
    final user = UserModel(
      email: _emailController.text,
      fullName: _nameController.text,
      shippingAddress: ShippingAddress(
        city: _selectedProvinceName!,
        district: _selectedDistrictName!,
        ward: _selectedWardName!,
        address: _addressController.text,
      ),
    );

    await userProvider.addUser(user);

    if (userProvider.errorMessage.isEmpty) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Signin()));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tạo tài khoản thành công! Mật khẩu mặc định là tên email của bạn")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(userProvider.errorMessage)),
      );
    }
  }
}
