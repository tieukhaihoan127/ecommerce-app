import 'package:ecommerce_app/core/config/responsive.dart';
import 'package:ecommerce_app/models/user_login.dart';
import 'package:ecommerce_app/providers/user_provider.dart';
import 'package:ecommerce_app/screens/client/bottom_nav.dart';
import 'package:ecommerce_app/screens/client/password_recovery.dart';
import 'package:ecommerce_app/screens/client/signup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Signin extends StatefulWidget {
  const Signin({Key? key}) : super(key: key);

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      body: Responsive(
        mobile: _buildForm(context, userProvider, isDesktop: false),
        desktop: Center(
          child: SizedBox(
            width: 500,
            child: _buildForm(context, userProvider, isDesktop: true),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context, UserProvider userProvider, {required bool isDesktop}) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _headerSignIn(),
          const SizedBox(height: 8),
          _labelSignIn(),
          const SizedBox(height: 24),
          _emailLabel(),
          const SizedBox(height: 24),
          _passwordLabel(),
          const SizedBox(height: 12),
          _forgetPassword(context),
          const SizedBox(height: 32),
          _signInButton(userProvider),
          const SizedBox(height: 24),
          _redirectSignUp(context),
        ],
      ),
    );
  }

  Widget _headerSignIn() {
    return Text(
      "Welcome Back!",
      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    );
  }

  Widget _labelSignIn() {
    return Text(
      "Enter your details below",
      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
    );
  }

  Widget _emailLabel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Email", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            hintText: "Enter your email",
            prefixIcon: Icon(Icons.email),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }

  Widget _passwordLabel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Password", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            hintText: "Enter your password",
            prefixIcon: Icon(Icons.lock),
            suffixIcon: IconButton(
              icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }

  Widget _signInButton(UserProvider userProvider) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: userProvider.isLoading ? null : () => _loginUser(context, userProvider),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: userProvider.isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text("Sign In", style: TextStyle(fontSize: 16, color: Colors.white)),
      ),
    );
  }

  Future<void> _loginUser(BuildContext context, UserProvider userProvider) async {
    final user = LoginUser(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    bool isLogin = await userProvider.loginUser(user);

    if (isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Đăng nhập thành công!")),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => BottomNavBar()),
        (Route<dynamic> route) => false,
      );
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
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PasswordRecoveryScreen()),
      ),
      child: Text(
        "Forgot Password?",
        style: TextStyle(
          fontSize: 16,
          color: Colors.blue[700],
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _redirectSignUp(BuildContext context) {
    return Row(
      children: [
        const Text("Don't have an account?", style: TextStyle(fontSize: 16)),
        const SizedBox(width: 5),
        GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => Signup())),
          child: Text(
            "Sign up now!",
            style: TextStyle(fontSize: 16, color: Colors.blue[700], fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
