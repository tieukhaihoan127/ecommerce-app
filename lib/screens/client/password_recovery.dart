import 'package:ecommerce_app/core/config/responsive.dart';
import 'package:ecommerce_app/providers/user_provider.dart';
import 'package:ecommerce_app/screens/client/submit_otp.dart';
import 'package:ecommerce_app/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PasswordRecoveryScreen extends StatefulWidget {
  const PasswordRecoveryScreen({super.key});

  @override
  _PasswordRecoveryScreenState createState() => _PasswordRecoveryScreenState();
}

class _PasswordRecoveryScreenState extends State<PasswordRecoveryScreen> {
  final TextEditingController _emailController = TextEditingController();

  Future<void> _requestOTP(UserProvider user) async {
    final email = {
      "email": _emailController.text.trim(),
    };

    final message = await user.getAccountOTP(email);

    if (message != "") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(user.errorMessage)),
      );
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SubmitOTPScreen(email: _emailController.text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBarHelper(header: ""),
      ),
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
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _headerPasswordRecovery(),
          const SizedBox(height: 8),
          _labelPasswordRecovery(),
          const SizedBox(height: 24),
          _buildTextField(Icons.email, "Enter your email", _emailController),
          const SizedBox(height: 32),
          Center(
            child: ElevatedButton(
              onPressed: userProvider.isLoading ? null : () => _requestOTP(userProvider),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
              ),
              child: userProvider.isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Get OTP", style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerPasswordRecovery() {
    return const Text(
      "Forget Password?",
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _labelPasswordRecovery() {
    return const Text(
      "Enter the email address associated with your account.",
      style: TextStyle(
        fontSize: 16,
        color: Colors.grey,
      ),
    );
  }

  Widget _buildTextField(IconData icon, String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.blue),
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
