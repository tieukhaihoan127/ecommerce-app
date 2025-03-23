import 'package:ecommerce_app/models/shipping_address.dart';
import 'package:ecommerce_app/models/user.dart';
import 'package:ecommerce_app/providers/address_provider.dart';
import 'package:ecommerce_app/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Signup extends StatefulWidget{

  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();

}

class _SignupState extends State<Signup> {


  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmedPasswordController = TextEditingController();
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

    final userProvider = Provider.of<UserProvider>(context);
    final addressProvider = Provider.of<AddressProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: 16,
            vertical: 40
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _headerSignUp(context),
              _labelSignUp(context),
              const SizedBox(height: 20,),
              _emailLabel(context),
              const SizedBox(height: 25,),
              _nameLabel(context),
              const SizedBox(height: 25,),
              _passwordLabel(context),
              const SizedBox(height: 25,),
              _confirmPasswordLabel(context),
              const SizedBox(height: 25,),
              Text(
                "Shipping Address",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black
                ),
              ),
              const SizedBox(height: 20,),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _selectProvince(context, addressProvider, "Choose your province"),
                  const SizedBox(width: 20,),
                  _selectDistrict(context, addressProvider, "Choose your district")
                ],
              ),
              const SizedBox(height: 25,),
              Row(
                children: [
                  _selectWard(context, addressProvider, "Choose your ward"),
                  const SizedBox(width: 20,),
                  _selectAddress(context)
                ],
              ),
              const SizedBox(height: 25,),
              _signUpButton(context, userProvider)
            ],
          ),
          ),
      )
    );
  }

  Widget _headerSignUp(BuildContext context) {
    return Text(
      "Create your account",
      style: TextStyle(
        fontSize: 30,
        color: Colors.black
      ),
    );
  }

  Widget _labelSignUp(BuildContext context) {
    return Text(
      "Explore your life by joining with Eletric",
      style: TextStyle(
        fontSize: 14,
        color: Colors.grey
      ),
    );
  }

  Widget _emailLabel(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Email",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18
          ),
        ),
        const SizedBox(height: 8,),
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            hintText: "Enter your email",
            prefixIcon: Icon(Icons.email),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5)
            )
          ),
        )
      ],
    );
  }

  Widget _nameLabel(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Full Name",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18
          ),
        ),
        const SizedBox(height: 8,),
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            hintText: "Enter your name",
            prefixIcon: Icon(Icons.account_circle),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5)
            )
          ),
        )
      ],
    );
  }

  Widget _passwordLabel(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Password",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18
          ),
        ),
        const SizedBox(height: 8,),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(
            hintText: "Enter your password",
            prefixIcon: Icon(Icons.lock),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5)
            )
          ),
        )
      ],
    );
  }

  Widget _confirmPasswordLabel(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Confirm Password",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18
          ),
        ),
        const SizedBox(height: 8,),
        TextField(
          controller: _confirmedPasswordController,
          decoration: InputDecoration(
            hintText: "Re-enter your password",
            prefixIcon: Icon(Icons.lock),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5)
            )
          ),
        )
      ],
    );
  }

  Widget _selectProvince(BuildContext context, AddressProvider addressProvider, String text) {

    return Flexible(
      child: DropdownButtonFormField<String>(
        value:  addressProvider.isLoaded ? (_selectedProvince != "" ? _selectedProvince : null) : null,
        hint: Text(text),
        items: addressProvider.provinces.map((province) {
          return DropdownMenuItem(
            value: province.code,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 200),
                child: Text(province.name)
              ),
            )
          );
        }).toList(), 
        onChanged: (newValue) {

          setState(() {
            _selectedProvince = newValue;
            _selectedDistrict = null; 
            _selectedWard = null; 
          });

          _selectedProvinceName = addressProvider.provinces.firstWhere((province) => province.code == newValue).name;
          Provider.of<AddressProvider>(context, listen: false).resetWard();
          Provider.of<AddressProvider>(context, listen: false).fetchDistrict(newValue!);

        },
        decoration: InputDecoration(
      
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          )
        ),
      ),
    );
  }

  Widget _selectDistrict(BuildContext context, AddressProvider addressProvider, String text) {

    return Flexible(
      child: DropdownButtonFormField<String>(
        value:  _selectedProvince != "" ? (_selectedDistrict != "" ? _selectedDistrict : null) : null,
        hint: Text(text),
        items: addressProvider.districts.map((district) {
          return DropdownMenuItem(
            value: district.code,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 200),
                child: Text(district.name)
              ),
            )
          );
        }).toList(), 
        onChanged: (newValue) {

          setState(() {
            _selectedDistrict = newValue;
            _selectedWard = null; 
          });

          _selectedDistrictName = addressProvider.districts.firstWhere((district) => district.code == newValue).name;
          Provider.of<AddressProvider>(context, listen: false).fetchWard(newValue!);


        },
        decoration: InputDecoration(
      
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          )
        ),
      ),
    );
  }

  Widget _selectWard(BuildContext context, AddressProvider addressProvider, String text) {

    return Expanded(
      child: DropdownButtonFormField<String>(
        value:  _selectedDistrict != "" ? (_selectedWard != "" ? _selectedWard : null) : null,
        hint: Text(text),
        items: addressProvider.wards.map((ward) {
          return DropdownMenuItem(
            value: ward.code,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 200),
                child: Text(ward.name)
              ),
            )
          );
        }).toList(), 
        onChanged: (newValue) {

          setState(() {
            _selectedWard = newValue;
          });

          _selectedWardName = addressProvider.wards.firstWhere((ward) => ward.code == newValue).name;

        },
        decoration: InputDecoration(
      
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          )
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
            border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5)
          )
        ),
      ),
    );
  }

  Widget  _signUpButton(BuildContext context, UserProvider userProvider) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: userProvider.isLoading ? null : () => _registerUser(context, userProvider) ,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ), 
        child: userProvider.isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text("Sign Up", style: TextStyle(color: Colors.white, fontSize: 16),)),
    );
  }

  Future<void> _registerUser(BuildContext context, UserProvider userProvider) async {
    
    if(_passwordController.text != _confirmedPasswordController.text) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Mật khẩu nhập lại không chính xác")),
      );

      _emailController.clear();
      _nameController.clear();
      _passwordController.clear();
      _confirmedPasswordController.clear();
      _addressController.clear();

      setState(() {
        _selectedProvince = "";
        _selectedDistrict = "";
        _selectedWard = "";
      });

      return;

    }

    final user = UserModel(
      email: _emailController.text,
      fullName: _nameController.text,
      password: _passwordController.text,
      shippingAddress: ShippingAddress(
        city: _selectedProvinceName!, 
        district: _selectedDistrictName!, 
        ward: _selectedWardName!, 
        address: _addressController.text
      )
    );

    await userProvider.addUser(user);

    if(userProvider.errorMessage.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Sign up successfully"))
      );
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(userProvider.errorMessage))
      );
    }

  }

}