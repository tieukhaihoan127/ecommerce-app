import 'package:ecommerce_app/models/shipping_address.dart';
import 'package:ecommerce_app/models/user.dart';
import 'package:ecommerce_app/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Signup extends StatelessWidget {
  Signup({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      body: Padding(
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
            _signUpButton(context, userProvider)
          ],
        ),
        )
    );
  }

  Widget _headerSignUp(BuildContext context) {
    return Text(
      "Create your account",
      style: TextStyle(
        fontSize: 18,
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
    print("Password: ${_passwordController.text}");
    final user = UserModel(
      email: _emailController.text,
      fullName: _nameController.text,
      password: _passwordController.text,
      shippingAddress: ShippingAddress(
        city: "TP HCM", 
        district: "Q11", 
        ward: "P12", 
        address: "127 Lanh Binh Thang"
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