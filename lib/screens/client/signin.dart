import 'package:ecommerce_app/models/user_login.dart';
import 'package:ecommerce_app/providers/user_provider.dart';
import 'package:ecommerce_app/screens/client/bottom_nav.dart';
import 'package:ecommerce_app/screens/client/password_recovery.dart';
import 'package:ecommerce_app/screens/client/profile.dart';
import 'package:ecommerce_app/screens/client/signup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Signin extends StatefulWidget {

  const Signin({ super.key });

  @override
  State<Signin> createState() => _SigninState();
  
}

class _SigninState extends State<Signin>{

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  
  @override
  Widget build(BuildContext context) {

    final userProvider = Provider.of<UserProvider>(context);

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
              _headerSignIn(context),
              _labelSignIn(context),
              const SizedBox(height: 20,),
              _emailLabel(context),
              const SizedBox(height: 20,),
              _passwordLabel(context),
              const SizedBox(height: 10,),
              _forgetPassword(context),
              const SizedBox(height: 25,),
              _signUpButton(context, userProvider),
              const SizedBox(height: 25,),
              _redirectSignUp(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget _headerSignIn(BuildContext context) {
    return Text(
      "Welcome Back!",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 30,
        color: Colors.black
      ),
    );
  }

  Widget _labelSignIn(BuildContext context) {
    return Text(
      "Enter your details below",
      textAlign: TextAlign.center,
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
        onPressed: userProvider.isLoading ? null : () => _loginUser(context, userProvider) ,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ), 
        child: userProvider.isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text("Sign In", style: TextStyle(color: Colors.white, fontSize: 16),)),
    );
  }

  Future<void> _loginUser(BuildContext context, UserProvider userProvider) async {

    final user = LoginUser(
      email: _emailController.text,
      password: _passwordController.text,
    );

    bool isLogin = await userProvider.loginUser(user);

    if (isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Đăng nhập thành công!")),
      );
      Navigator.pushAndRemoveUntil(
        context, 
        MaterialPageRoute(builder: (context) => BottomNavBar()),
        (Route<dynamic> route) => false
    ) ;
    } else {
      _passwordController.clear();
      _emailController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(userProvider.errorMessage)),
      );
    }

  }

  Widget _forgetPassword(BuildContext context) {
    return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PasswordRecoveryScreen()),
            );
          },
          child: Text(
            "Forget Passwod?",
          style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }

  Widget _redirectSignUp(BuildContext context) {
    return Row(
      children: [
        Text(
          "Don't have account yet?",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16
          ),  
        ),
        const SizedBox(width: 5,),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Signup()),
            );
          },
          child: Text(
            "Sign up now!",
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold
            ),
          ),
        )
      ],
    );
  }

}